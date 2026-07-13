local isOpen = false

local copyLabels = {}
local function doCopy(i)
  local lbl = copyLabels[i]
  if lbl and lbl ~= "" then
    noctalia.copyToClipboard(lbl, "text/plain")
    noctalia.notify("Copied", lbl)
  end
end
function onCopy1() doCopy(1) end
function onCopy2() doCopy(2) end
function onCopy3() doCopy(3) end
function onCopy4() doCopy(4) end
function onCopy5() doCopy(5) end
function onCopy6() doCopy(6) end
function onCopy7() doCopy(7) end
function onCopy8() doCopy(8) end
function onCopy9() doCopy(9) end
function onCopy10() doCopy(10) end
function onCopy11() doCopy(11) end
function onCopy12() doCopy(12) end
function onCopy13() doCopy(13) end
function onCopy14() doCopy(14) end
function onCopy15() doCopy(15) end
function onCopy16() doCopy(16) end
function onCopy17() doCopy(17) end
function onCopy18() doCopy(18) end
function onCopy19() doCopy(19) end
function onCopy20() doCopy(20) end
function onCopy21() doCopy(21) end
function onCopy22() doCopy(22) end
function onCopy23() doCopy(23) end
function onCopy24() doCopy(24) end
function onCopy25() doCopy(25) end
function onCopy26() doCopy(26) end
function onCopy27() doCopy(27) end
function onCopy28() doCopy(28) end
function onCopy29() doCopy(29) end
function onCopy30() doCopy(30) end
function onCopy31() doCopy(31) end
function onCopy32() doCopy(32) end
function onCopy33() doCopy(33) end
function onCopy34() doCopy(34) end
function onCopy35() doCopy(35) end
function onCopy36() doCopy(36) end
function onCopy37() doCopy(37) end
function onCopy38() doCopy(38) end
function onCopy39() doCopy(39) end
function onCopy40() doCopy(40) end
function onCopy41() doCopy(41) end
function onCopy42() doCopy(42) end
function onCopy43() doCopy(43) end
function onCopy44() doCopy(44) end
function onCopy45() doCopy(45) end
function onCopy46() doCopy(46) end
function onCopy47() doCopy(47) end
function onCopy48() doCopy(48) end
function onCopy49() doCopy(49) end
function onCopy50() doCopy(50) end

local function fmtTime(ts)
  local t = os.date("*t", ts)
  return string.format("%02d:%02d", t.hour, t.min)
end

function onListenToggle()
  local cur = noctalia.state.get("sr_listening") or false
  noctalia.state.set("sr_listening", not cur)
end

local function render()
  if not isOpen then return end
  local available = noctalia.state.get("sr_available")
  local status = noctalia.state.get("sr_status") or ""
  local current = noctalia.state.get("sr_current") or ""
  local history = noctalia.state.get("sr_history") or {}
  local audioSource = noctalia.state.get("sr_audio_source") or "system"
  local listening = noctalia.state.get("sr_listening") or false
  local sourceGlyph = audioSource == "system" and "speakerphone" or "microphone"
  local listenGlyph = listening and "player-stop" or "player-play"
  local statusText = listening and "listening..." or status
  local statusColor = "on_surface_variant"
  if status == "recognized" then statusColor = "primary"
  elseif listening then statusColor = "warning"
  elseif not available or status == "no songrec" then statusText = "songrec not installed"; statusColor = "error"
  end

  local body = {}
  if current ~= "" and available then
    body[#body + 1] = ui.column({ gap = 4, fill = "surface_variant", radius = 10, padding = 14 }, {
      ui.label({ text = "Now Playing", fontSize = 11, color = "on_surface_variant" }),
      ui.label({ text = current, fontSize = 15, fontWeight = "bold", color = "primary" }),
    })
    body[#body + 1] = ui.separator({ thickness = 1, spacing = 4 })
  end

  if #history > 0 then
    local rows = {}
    for i, entry in ipairs(history) do
      local lbl = (entry.artist ~= "" and (entry.artist .. " - " .. entry.title) or entry.title)
      copyLabels[i] = lbl
      rows[#rows + 1] = ui.row({ gap = 6, fill = "surface_variant", radius = 6, padding = { left = 8, right = 8, top = 3, bottom = 3 } }, {
        ui.label({ text = tostring(i), fontSize = 11, color = "on_surface_variant", width = 24 }),
        ui.separator({ orientation = "vertical", thickness = 1, spacing = 4 }),
        ui.button({ variant = "ghost", onClick = "onCopy" .. i, text = lbl, flexGrow = 1, maxLines = 1 }),
        ui.label({ text = fmtTime(entry.time), fontSize = 11, color = "on_surface_variant" }),
      })
    end
    body[#body + 1] = ui.column({ gap = 2 }, {
      ui.label({ text = "History", fontSize = 14, fontWeight = "bold", color = "primary", padding = { left = 10, right = 10, top = 6, bottom = 6 } }),
      table.unpack(rows),
    })
  else
    body[#body + 1] = ui.row({ padding = { top = 20, bottom = 20 }, justify = "center" }, {
      ui.label({ text = available and "Press play to start listening" or "Install songrec to get started", color = "on_surface_variant" }),
    })
  end

  panel.render(ui.column({ gap = 10, flexGrow = 1, align = "stretch" }, {
    ui.row({ align = "center", gap = 10, padding = { left = 14, right = 14, top = 14, bottom = 0 } }, {
      ui.glyph({ name = "music", size = 20, color = "primary" }),
      ui.label({ text = "SongRec", fontSize = 17, fontWeight = "bold", flexGrow = 1 }),
      ui.button({ glyph = sourceGlyph, variant = "ghost", onClick = "onToggleSource" }),
      ui.button({ glyph = listenGlyph, variant = "ghost", onClick = "onListenToggle" }),
      ui.button({ glyph = "x", variant = "ghost", onClick = "onCloseClicked" }),
    }),
    ui.label({ text = statusText, fontSize = 11, color = statusColor, padding = { left = 14, right = 14 } }),
    ui.separator({ thickness = 1, spacing = 4 }),
    ui.scroll({ gap = 12, fill = "surface_variant", radius = 10, flexGrow = 1, padding = 8 }, body),
  }))
end

function onOpen(context) isOpen = true; render(); noctalia.state.set("sr_listening", true) end
function onClose() isOpen = false end
function onToggleSource()
  local cur = noctalia.state.get("sr_audio_source") or "system"
  noctalia.state.set("sr_audio_source", cur == "system" and "mic" or "system")
end
function onCloseClicked() panel.close() end

for _, key in ipairs({ "sr_current", "sr_status", "sr_available", "sr_history", "sr_audio_source", "sr_listening" }) do
  noctalia.state.watch(key, function() render() end)
end
