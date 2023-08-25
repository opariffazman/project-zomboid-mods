if not getActivatedMods():contains("ForScience") then
	return
end

-- to allow dissecting corpses
local itemData = {
  ["Base.Scalpel"] = {
    Tags = "SharpKnife"
  }
}

for itemName, data in pairs(itemData) do
  local item = ScriptManager.instance:getItem(itemName)
  if item then
    item:DoParam("Tags = " .. data.Tags)
  end
end