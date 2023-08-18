local itemNames = {
  "Base.PipeWrench",
  "ToolsOfTheTrade.IndustrialPipeWrench"
}

for _, itemName in ipairs(itemNames) do
  local item = ScriptManager.instance:getItem(itemName)
  if item then
      item:DoParam("Tags = PipeWrench")
  end
end
