local pending = false
local audioSource = "system"
local monitorDevice = nil
local captureTmp = "/tmp/songrec_cap.wav"
local monPending = false
local continuousListening = false

if noctalia.state.get("sr_history") == nil then noctalia.state.set("sr_history", {}) end
if noctalia.state.get("sr_current") == nil then noctalia.state.set("sr_current", "") end
if noctalia.state.get("sr_artist") == nil then noctalia.state.set("sr_artist", "") end
if noctalia.state.get("sr_title") == nil then noctalia.state.set("sr_title", "") end
if noctalia.state.get("sr_audio_source") == nil then noctalia.state.set("sr_audio_source", "system") end
noctalia.state.set("sr_listening", false)
noctalia.state.set("sr_available", false)
noctalia.state.set("sr_status", "checking")

local function chkSong()
  noctalia.runAsync("command -v songrec 2>/dev/null", function(r)
    local p = noctalia.string.trim(r.stdout or "")
    if p ~= "" then
      noctalia.log("songrec: found " .. p)
      noctalia.state.set("sr_available", true)
      noctalia.state.set("sr_status", "ready")
    end
    noctalia.runAsync("command -v ffmpeg 2>/dev/null", function(r2)
      local p2 = noctalia.string.trim(r2.stdout or "")
      if p2 ~= "" then noctalia.log("songrec: ffmpeg " .. p2)
      else noctalia.log("songrec: ffmpeg NOT found") end
      if p == "" then noctalia.state.set("sr_status", "no songrec") end
    end)
  end)
end

local function chkMon()
  noctalia.runAsync("pactl get-default-sink 2>/dev/null", function(r)
    local s = noctalia.string.trim(r.stdout or "")
    if s ~= "" then
      monitorDevice = s .. ".monitor"
      noctalia.log("songrec: monitor = " .. monitorDevice)
    else
      noctalia.runAsync("pactl list sources short 2>/dev/null | grep monitor | head -1 | awk '{print $2}'", function(r2)
        local s2 = noctalia.string.trim(r2.stdout or "")
        if s2 ~= "" then
          monitorDevice = s2
          noctalia.log("songrec: mon fallback = " .. monitorDevice)
        else
          noctalia.log("songrec: NO monitor found")
        end
      end)
    end
  end)
end

chkSong()
chkMon()

local function stopListening()
  continuousListening = false
  noctalia.state.set("sr_listening", false)
end

local function processResult(out)
  out = noctalia.string.trim(out)
  if out == "" then
    noctalia.log("songrec: empty stdout, no match")
    noctalia.state.set("sr_status", "no match")
    return
  end
  noctalia.log("songrec: result = " .. out)

  local artist, title = out:match("^(.-)%s*%-%s*(.-)%s*$")
  local cur, art, tit
  if artist and title then
    art = noctalia.string.trim(artist)
    tit = noctalia.string.trim(title)
    cur = art .. " - " .. tit
  else
    art = ""
    tit = out
    cur = out
  end

  local prev = noctalia.state.get("sr_current") or ""
  if cur ~= prev then
    local oldH = noctalia.state.get("sr_history") or {}
    local h = { { artist = art, title = tit, time = os.time() } }
    for i = 1, math.min(#oldH, 49) do h[#h + 1] = oldH[i] end
    noctalia.state.set("sr_history", h)
    local ok, err = pcall(noctalia.notify, "SongRec", "Detected: " .. cur)
    if not ok then noctalia.log("songrec: notify error: " .. tostring(err)) end
  end

  noctalia.state.set("sr_artist", art)
  noctalia.state.set("sr_title", tit)
  noctalia.state.set("sr_current", cur)
  noctalia.state.set("sr_status", "recognized")

  if continuousListening then
    stopListening()
    noctalia.log("songrec: song found, stopped listening")
  end
end

local function recognize()
  if pending then
    noctalia.log("songrec: recognize skipped (pending)")
    return
  end
  pending = true

  if audioSource == "system" and not monitorDevice then
    if not monPending then
      monPending = true
      noctalia.log("songrec: detecting monitor...")
      noctalia.runAsync("pactl get-default-sink 2>/dev/null", function(r)
        monPending = false
        local s = noctalia.string.trim(r.stdout or "")
        if s ~= "" then
          monitorDevice = s .. ".monitor"
          noctalia.log("songrec: monitor now " .. monitorDevice)
          pending = false
          recognize()
        else
          noctalia.log("songrec: no sink found, will retry later")
          pending = false
        end
      end)
    else
      pending = false
    end
    return
  end

  noctalia.state.set("sr_status", "listening")

  if audioSource == "system" then
    local cmd = "ffmpeg -nostdin -f pulse -i " .. monitorDevice .. " -ac 1 -ar 44100 -t 2 " .. captureTmp .. " -y >/dev/null 2>&1 && songrec recognize " .. captureTmp .. " 2>/dev/null; rm -f " .. captureTmp .. " >/dev/null 2>&1"
    noctalia.log("songrec: running pipeline")
    local ok = noctalia.runAsync(cmd, function(r)
      pending = false
      if r.stdout and r.stdout ~= "" then
        processResult(r.stdout)
      else
        noctalia.state.set("sr_status", "no match")
        if continuousListening then
          noctalia.log("songrec: no match, retrying...")
          noctalia.runAsync("sleep 1.5", function()
            if continuousListening then recognize() end
          end)
        end
      end
    end)
    if not ok then pending = false; noctalia.state.set("sr_status", "error"); noctalia.log("songrec: runAsync rejected") end
  else
    local ok = noctalia.runAsync("songrec recognize 2>/dev/null", function(r)
      pending = false
      if r.stdout and r.stdout ~= "" then
        processResult(r.stdout)
      else
        noctalia.state.set("sr_status", "no match")
        if continuousListening then
          noctalia.runAsync("sleep 1.5", function()
            if continuousListening then recognize() end
          end)
        end
      end
    end)
    if not ok then pending = false; noctalia.state.set("sr_status", "error"); noctalia.log("songrec: runAsync rejected") end
  end
end

function update()
  local auto = noctalia.getConfig("sr_auto")
  if continuousListening then
    noctalia.setUpdateInterval(1500)
  elseif (auto == nil or auto) then
    noctalia.setUpdateInterval(math.max((tonumber(noctalia.getConfig("sr_poll_seconds")) or 10) * 1000, 3000))
    recognize()
  else
    noctalia.setUpdateInterval(5000)
  end
end

function onConfigChanged()
  local interval = (tonumber(noctalia.getConfig("sr_poll_seconds")) or 10) * 1000
  noctalia.setUpdateInterval(math.max(interval, 3000))
end

noctalia.setUpdateInterval(5000)

noctalia.state.watch("sr_listening", function(val)
  if val then
    if not continuousListening then
      continuousListening = true
      noctalia.log("songrec: start continuous listening")
      recognize()
    end
  else
    if continuousListening then
      noctalia.log("songrec: stop continuous listening")
      continuousListening = false
    end
  end
end)
noctalia.state.watch("sr_audio_source", function(s) audioSource = s or "system"; noctalia.log("songrec: source = " .. audioSource) end)
