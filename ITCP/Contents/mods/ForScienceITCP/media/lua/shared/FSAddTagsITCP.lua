local itemNames = {
  "Base.Scalpel"
}

for _, itemName in ipairs(itemNames) do
  local item = ScriptManager.instance:getItem(itemName)
  if item then
      item:DoParam("Tags = SharpKnife")
  end
end