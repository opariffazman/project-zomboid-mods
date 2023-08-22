if not getActivatedMods():contains("ToolsOfTheTrade") then
	return
end

local itemData = {
  ["Base.PipeWrench"] = {
    Tags = "PipeWrench"
  },
  ["ToolsOfTheTrade.IndustrialPipeWrench"] = {
    Tags = "PipeWrench"
  },
  ["ToolsOfTheTrade.IndustrialWrench"] = {
    Tags = "Wrench"
}
}

for itemName, data in pairs(itemData) do
  local item = ScriptManager.instance:getItem(itemName)
  if item then
      item:DoParam("Tags = " .. data.Tags)
  end
end