-- keybind-cheatsheet :: panel
-- Renders binds grouped into the config's comment sections (in file order):
-- section header + underline, then "combo | description" rows. Conflicts are
-- drawn red. The search field is focused the moment the panel opens.

local isOpen = false
local filter = ""
local openSeq = 0   -- bumped each open so the search input is recreated + refocused

local function matches(b)
  if filter == "" then return true end
  return noctalia.fuzzyScore(filter, b.combo .. " " .. b.label) ~= nil
end

local function bindRow(b)
  local comboColor = b.conflict and "error" or "on_surface"
  local right = {
    ui.label({ text = b.label, color = b.conflict and "error" or "on_surface_variant", flexGrow = 1, maxLines = 1 }),
  }
  if b.conflict then
    right[#right + 1] = ui.label({ text = "● conflict", fontSize = 11, fontWeight = "bold", color = "error" })
  end
  return ui.row({ gap = 12, align = "center", paddingV = 3, paddingH = 10 }, {
    ui.label({ text = b.combo, fontWeight = "bold", color = comboColor, width = 230 }),
    ui.separator({ orientation = "vertical", thickness = 1 }),
    ui.row({ gap = 8, align = "center", flexGrow = 1 }, right),
  })
end

local function sectionHeader(title)
  return ui.column({ gap = 4, paddingV = 6, paddingH = 6 }, {
    ui.label({ text = title, fontSize = 14, fontWeight = "bold", color = "primary" }),
    ui.separator({ thickness = 1, spacing = 1 }),
  })
end

local function render()
  if not isOpen then return end
  local binds = noctalia.state.get("binds") or {}
  local total = noctalia.state.get("count") or 0
  local conflicts = noctalia.state.get("conflicts") or 0
  local fileCount = noctalia.state.get("fileCount") or 0

  local headerRight = {}
  if conflicts > 0 then
    headerRight[#headerRight + 1] = ui.label({ text = tostring(conflicts) .. " conflict" .. (conflicts == 1 and "" or "s"),
                                               color = "error", fontWeight = "bold" })
  else
    headerRight[#headerRight + 1] = ui.label({ text = "no conflicts", color = "on_surface_variant" })
  end
  headerRight[#headerRight + 1] = ui.button({ glyph = "refresh", variant = "ghost", onClick = "onRefresh" })
  headerRight[#headerRight + 1] = ui.button({ glyph = "x", variant = "ghost", onClick = "onCloseClicked" })

  -- body: one column block per section (in file order). Even spacing between
  -- sections comes from the scroll's gap, so there are no filler bars.
  local blocks = {}
  local curSection, curKids = nil, nil
  local shownAny = false
  for _, b in ipairs(binds) do
    if matches(b) then
      if b.section ~= curSection then
        curSection = b.section
        curKids = { sectionHeader(b.section) }
        blocks[#blocks + 1] = ui.column({ gap = 2, align = "stretch" }, curKids)
      end
      curKids[#curKids + 1] = bindRow(b)
      shownAny = true
    end
  end
  local body = blocks
  if not shownAny then
    body[#body + 1] = ui.row({ paddingV = 20, justify = "center" }, {
      ui.label({ text = total == 0 and "Scanning config…" or "No binds match your search.", color = "on_surface_variant" }),
    })
  end

  panel.render(ui.column({ gap = 10, padding = 14, flexGrow = 1, align = "stretch" }, {
    ui.row({ align = "center", gap = 10 }, {
      ui.glyph({ name = "keyboard", size = 20, color = "primary" }),
      ui.label({ text = "Keybind Cheatsheet", fontSize = 17, fontWeight = "bold", flexGrow = 1 }),
      table.unpack(headerRight),
    }),
    ui.input({ key = "kb-search-" .. openSeq, value = "", placeholder = "Filter keybinds…", focus = true, onChange = "onSearch" }),
    ui.label({ text = string.format("%d binds · %d file%s", total, fileCount, fileCount == 1 and "" or "s"),
               fontSize = 11, color = "on_surface_variant" }),
    ui.scroll({ gap = 18, fill = "surface_variant", radius = 10, padding = 12, flexGrow = 1 }, body),
  }))
end

function onOpen(context)
  isOpen = true
  filter = ""
  openSeq = openSeq + 1
  render()
end

function onClose() isOpen = false end
function onSearch(value) filter = noctalia.string.trim(value); render() end
function onRefresh() noctalia.state.set("requestScan", os.time()) end
function onCloseClicked() panel.close() end

noctalia.state.watch("binds", function() render() end)
noctalia.state.watch("conflicts", function() render() end)
