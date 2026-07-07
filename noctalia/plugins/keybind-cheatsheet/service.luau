-- keybind-cheatsheet :: watcher service
-- Scans the configured Hyprland config file/folder, parses keybinds from both
-- Lua (hl.bind("MODS + KEY", hl.dsp...., { description=... })) and classic
-- (bind = MODS, KEY, dispatcher, args) syntax. Binds are grouped into sections
-- taken from the `-- comment` headers in the config, in file order. Detects
-- duplicate combos as conflicts and publishes the result on the state channel.
-- Re-scans whenever any watched file changes (the auto-update trigger).

local MODMAP = {
  SUPER = "SUPER", MOD4 = "SUPER", WIN = "SUPER", WINDOWS = "SUPER", META = "SUPER", SUPER_L = "SUPER",
  CTRL = "CTRL", CONTROL = "CTRL",
  ALT = "ALT", MOD1 = "ALT",
  SHIFT = "SHIFT",
}
local MODORDER = { SUPER = 1, CTRL = 2, ALT = 3, SHIFT = 4 }
local MODDISP = { SUPER = "Super", CTRL = "Ctrl", ALT = "Alt", SHIFT = "Shift" }

-- Friendly display names for non-letter keys (mouse buttons, media keys, etc.).
local KEYNAMES = {
  ["mouse:272"] = "Left Mouse Click",
  ["mouse:273"] = "Right Mouse Click",
  ["mouse:274"] = "Middle Mouse Click",
  ["mouse:275"] = "Mouse Button 4",
  ["mouse:276"] = "Mouse Button 5",
  mouse_up = "Scroll Up",
  mouse_down = "Scroll Down",
  Print = "Print Screen",
  Return = "Enter",
  XF86AudioPlay = "Media Play/Pause",
  XF86AudioNext = "Media Next",
  XF86AudioPrev = "Media Previous",
  XF86AudioRaiseVolume = "Volume Up",
  XF86AudioLowerVolume = "Volume Down",
  XF86AudioMute = "Mute",
  XF86AudioMicMute = "Mic Mute",
  XF86MonBrightnessUp = "Brightness Up",
  XF86MonBrightnessDown = "Brightness Down",
}

-- Keys hidden when "hide volume & brightness" is on.
local VOLBRIGHT = {
  ["XF86AudioRaiseVolume"] = true, ["XF86AudioLowerVolume"] = true, ["XF86AudioMute"] = true,
  ["XF86AudioMicMute"] = true, ["XF86MonBrightnessUp"] = true, ["XF86MonBrightnessDown"] = true,
}

local function friendlyKey(k)
  return KEYNAMES[k] or k
end

-- Turn a list of raw tokens into a normalized bind descriptor. When
-- forcedKeyDisplay is given (dynamic/looped bind), it is used as the key label
-- verbatim and the bind is flagged dynamic (excluded from conflict detection).
local function buildCombo(tokens, forcedKeyDisplay)
  local modset, key = {}, nil
  for _, raw in ipairs(tokens) do
    local t = noctalia.string.trim(raw)
    if t ~= "" then
      local m = MODMAP[t:upper()]
      if m then
        modset[m] = true
      elseif not forcedKeyDisplay then
        key = t -- last non-modifier token is the key
      end
    end
  end
  if forcedKeyDisplay then key = forcedKeyDisplay end
  if not key then return nil end
  local mods = {}
  for m in pairs(modset) do mods[#mods + 1] = m end
  table.sort(mods, function(a, b) return (MODORDER[a] or 9) < (MODORDER[b] or 9) end)

  local dispMods = {}
  for _, m in ipairs(mods) do dispMods[#dispMods + 1] = MODDISP[m] or m end
  local keyDisp = forcedKeyDisplay or friendlyKey(key)
  local display = keyDisp
  if #dispMods > 0 then display = table.concat(dispMods, " + ") .. " + " .. keyDisp end

  local canonical = table.concat(mods, "+") .. "|" .. key:lower()
  return { mods = mods, key = key, display = display, canonical = canonical, dynamic = forcedKeyDisplay ~= nil }
end

-- Collect quoted string literals from a chunk of Lua, joined in order. Prefer
-- double-quoted literals; fall back to single-quoted only if there are none.
local function joinStringLiterals(s)
  local parts = {}
  for lit in s:gmatch('"([^"]*)"') do parts[#parts + 1] = lit end
  if #parts == 0 then
    for lit in s:gmatch("'([^']*)'") do parts[#parts + 1] = lit end
  end
  return noctalia.string.trim(table.concat(parts, ""))
end

-- Derive a fallback action label (used when a bind has no { description }).
local function actionLabel(action)
  local exec = action:match("exec_cmd%s*%((.*)%)") or action:match("exec_raw%s*%((.*)%)")
  if exec then
    local cmd = joinStringLiterals(exec)
    if cmd ~= "" then return "run: " .. cmd end
    return "run command"
  end
  local path = action:match("hl%.dsp%.([%w_%.]+)")
  if path then
    local args = action:match("%((.*)%)")
    local inline = args and joinStringLiterals(args) or ""
    if inline ~= "" then return path .. " → " .. inline end
    return path
  end
  return noctalia.string.trim(action)
end

-- String-aware check: are parentheses in `s` balanced (and at least one opened)?
local function balanced(s)
  local depth, inStr, quote, esc, opened = 0, false, nil, false, false
  for i = 1, #s do
    local c = s:sub(i, i)
    if inStr then
      if esc then esc = false
      elseif c == "\\" then esc = true
      elseif c == quote then inStr = false end
    else
      if c == '"' or c == "'" then inStr = true; quote = c
      elseif c == "(" then depth = depth + 1; opened = true
      elseif c == ")" then depth = depth - 1 end
    end
  end
  return opened and depth <= 0
end

-- Parse a full (possibly multi-line) hl.bind(...) statement.
local function parseLuaStatement(stmt)
  local s, e, combo = stmt:find('hl%.bind%s*%(%s*"([^"]*)"')
  if not combo then s, e, combo = stmt:find("hl%.bind%s*%(%s*'([^']*)'") end
  if not combo then return nil end

  -- A combo built by string concatenation ("SUPER + code:" .. x) is a dynamic /
  -- looped bind whose key can't be resolved statically.
  local dynamic = stmt:sub((e or 0) + 1):match("^%s*%.%.") ~= nil

  local tokens = {}
  for tok in combo:gmatch("[^+]+") do tokens[#tokens + 1] = tok end

  local b
  if dynamic then
    local placeholder
    if combo:find("code:") then
      placeholder = "[number]"
    elseif stmt:find("direction") then
      placeholder = "[arrows]"
    else
      placeholder = "[key]"
    end
    b = buildCombo(tokens, placeholder)
  else
    b = buildCombo(tokens)
  end
  if not b then return nil end

  local desc = stmt:match('description%s*=%s*"([^"]*)"') or stmt:match("description%s*=%s*'([^']*)'")
  if desc and desc ~= "" then
    b.label = desc
  else
    local action = stmt:match('hl%.bind%s*%(%s*["\'][^"\']*["\']%s*,%s*(.*)') or ""
    b.label = actionLabel(action)
  end
  return b
end

-- Parse a single classic `bind = ...` line.
local function parseClassicLine(line, vars)
  local rhs = line:match("^%s*bind[lrenmtsdpio]*%s*=%s*(.+)$")
  if not rhs then return nil end
  rhs = rhs:gsub("%$([%w_]+)", function(name) return vars[name] or ("$" .. name) end)
  local fields = {}
  for f in rhs:gmatch("[^,]+") do fields[#fields + 1] = noctalia.string.trim(f) end
  if #fields < 2 then return nil end
  local tokens = {}
  for tok in fields[1]:gmatch("[^%s]+") do tokens[#tokens + 1] = tok end
  tokens[#tokens + 1] = fields[2]
  local b = buildCombo(tokens)
  if not b then return nil end
  local args = {}
  for i = 4, #fields do args[#args + 1] = fields[i] end
  b.label = noctalia.string.trim((fields[3] or "") .. " " .. table.concat(args, ", "))
  return b
end

-- Is a comment line a section header (vs a commented-out bind or code)?
local function sectionFromComment(trimmed)
  if trimmed:sub(1, 2) ~= "--" then return nil end
  local text = noctalia.string.trim(trimmed:gsub("^%-+", ""))
  if text == "" then return nil end
  -- ignore commented-out binds / code lines
  if text:match("hl%.bind") or text:match("hl%.dsp") or text:match("^bind%s*=") or text:match("bind[lrenmtsdpio]*%s*=") then
    return nil
  end
  return text
end

local function collectVars(content, vars)
  for name, val in content:gmatch("%$([%w_]+)%s*=%s*([^\n]+)") do
    vars[name] = noctalia.string.trim(val)
  end
end

local function isConfigFile(name)
  return name:match("%.lua$") or name:match("%.conf$")
end

local function collectFiles(path, out, depth)
  if depth > 6 then return end
  local info = noctalia.fileInfo(path)
  if not info then return end
  if info.isDir then
    local entries = noctalia.listDir(path)
    if entries then
      table.sort(entries)
      for _, name in ipairs(entries) do collectFiles(path .. "/" .. name, out, depth + 1) end
    end
  elseif isConfigFile(path) then
    out[#out + 1] = path
  end
end

local function signature(files)
  local sig = ""
  for _, f in ipairs(files) do
    local info = noctalia.fileInfo(f)
    if info then sig = sig .. f .. ":" .. tostring(info.mtime) .. ":" .. tostring(info.size) .. ";" end
  end
  return sig
end

-- Split file content into logical statements, tracking the current section,
-- and parse every bind in file order.
local function parseFile(content, hideVB, out)
  local vars = {}
  collectVars(content, vars)

  local lines = {}
  for line in (content .. "\n"):gmatch("([^\n]*)\n") do lines[#lines + 1] = line end

  local section = "General"
  local i = 1
  while i <= #lines do
    local line = lines[i]
    local trimmed = noctalia.string.trim(line)

    if trimmed:sub(1, 2) == "--" then
      local sec = sectionFromComment(trimmed)
      if sec then section = sec end
      i = i + 1
    elseif trimmed:match("hl%.bind") then
      -- accumulate a (possibly multi-line) statement until parens balance
      local stmt = line
      local j = i
      while not balanced(stmt) and (j - i) < 20 and j < #lines do
        j = j + 1
        stmt = stmt .. "\n" .. lines[j]
      end
      local b = parseLuaStatement(stmt)
      if b and not (hideVB and b.key:match("^XF86")) then
        b.section = section
        out[#out + 1] = b
      end
      i = j + 1
    else
      local b = parseClassicLine(line, vars)
      if b and not (hideVB and b.key:match("^XF86")) then
        b.section = section
        out[#out + 1] = b
      end
      i = i + 1
    end
  end
end

local function scan()
  local root = noctalia.expandPath(noctalia.getConfig("config_path") or "~/.config/hypr")
  local hideVB = noctalia.getConfig("hide_volume_brightness") ~= false
  local files = {}
  collectFiles(root, files, 0)
  table.sort(files)
  noctalia.state.set("signature", signature(files))

  local binds = {}
  for _, f in ipairs(files) do
    local content = noctalia.readFile(f)
    if content then parseFile(content, hideVB, binds) end
  end

  -- Conflict detection: group by canonical combo, dedup identical, flag groups >1.
  -- Dynamic/looped binds have unresolved keys, so they are excluded.
  local groups = {}
  for _, b in ipairs(binds) do
    if not b.dynamic then
      groups[b.canonical] = groups[b.canonical] or {}
      table.insert(groups[b.canonical], b)
    end
  end
  local conflicts = 0
  for _, g in pairs(groups) do
    local seen, distinct = {}, 0
    for _, b in ipairs(g) do
      local k = b.canonical .. "\0" .. (b.label or "")
      if not seen[k] then seen[k] = true; distinct = distinct + 1 end
    end
    if distinct > 1 then
      for _, b in ipairs(g) do b.conflict = true end
      conflicts = conflicts + 1
    end
  end

  -- Emit in file order, tagged with section; the panel groups consecutively.
  local out = {}
  for _, b in ipairs(binds) do
    out[#out + 1] = {
      section = b.section or "General",
      combo = b.display,
      key = b.key,
      label = b.label or "",
      conflict = b.conflict == true,
    }
  end

  noctalia.state.set("binds", out)
  noctalia.state.set("count", #out)
  noctalia.state.set("conflicts", conflicts)
  noctalia.state.set("fileCount", #files)
  noctalia.state.set("updated", os.time())
  noctalia.log(string.format("keybind-cheatsheet: %d binds, %d conflicts across %d files", #out, conflicts, #files))
end

local lastSig = nil
local function tick()
  local root = noctalia.expandPath(noctalia.getConfig("config_path") or "~/.config/hypr")
  local files = {}
  collectFiles(root, files, 0)
  table.sort(files)
  local sig = signature(files)
  if sig ~= lastSig then
    lastSig = sig
    scan()
  end
end

function update() tick() end

noctalia.state.watch("requestScan", function()
  lastSig = nil
  tick()
end)

function onConfigChanged()
  lastSig = nil
  noctalia.setUpdateInterval((tonumber(noctalia.getConfig("poll_seconds")) or 2) * 1000)
  tick()
end

noctalia.setUpdateInterval((tonumber(noctalia.getConfig("poll_seconds")) or 2) * 1000)
scan()
lastSig = noctalia.state.get("signature")
