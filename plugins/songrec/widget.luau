local function updateDisplay()
  local cur = noctalia.state.get("sr_current") or ""
  local status = noctalia.state.get("sr_status") or ""
  if cur ~= "" then
    barWidget.setText(#cur > 40 and cur:sub(1, 39) .. "..." or cur)
    barWidget.setTooltip("Now playing: " .. cur)
  elseif status == "listening" then
    barWidget.setText("...")
    barWidget.setTooltip("Listening...")
  elseif status == "no match" then
    barWidget.setText("")
    barWidget.setTooltip("No match")
  elseif status == "no songrec" then
    barWidget.setText("!")
    barWidget.setTooltip("songrec not found")
  elseif status == "checking" then
    barWidget.setText("")
    barWidget.setTooltip("Checking...")
  elseif status == "error" then
    barWidget.setText("!")
    barWidget.setTooltip("Error")
  else
    barWidget.setText("")
    barWidget.setTooltip("Click to recognize")
  end
end

function onClick()
  noctalia.togglePanel("kaizoku/songrec:panel")
end

function update()
  updateDisplay()
end

noctalia.setUpdateInterval(2000)

noctalia.state.watch("sr_current", function() updateDisplay() end)
noctalia.state.watch("sr_status", function() updateDisplay() end)

updateDisplay()
