-- keybind-cheatsheet :: bar widget
-- Shows a keyboard glyph; when the config has conflicting binds it turns the
-- glyph red and shows the conflict count. Click toggles the cheatsheet panel.

local function render()
  local conflicts = noctalia.state.get("conflicts") or 0
  local count = noctalia.state.get("count") or 0
  barWidget.setGlyph("keyboard")
  if conflicts > 0 then
    barWidget.setText(tostring(conflicts))
    barWidget.setGlyphColor("error")
    barWidget.setColor("error")
    barWidget.setTooltip(string.format("%d keybind conflict%s (of %d binds) — click to view",
      conflicts, conflicts == 1 and "" or "s", count))
  else
    barWidget.setText("")
    barWidget.setGlyphColor("on_surface")
    barWidget.setTooltip(string.format("%d keybinds, no conflicts — click for cheatsheet", count))
  end
end

function update()
  noctalia.setUpdateInterval(2000)
  render()
end

function onClick()
  noctalia.togglePanel("kaizoku/keybind-cheatsheet:cheatsheet")
end

noctalia.state.watch("conflicts", function() render() end)
noctalia.state.watch("count", function() render() end)
