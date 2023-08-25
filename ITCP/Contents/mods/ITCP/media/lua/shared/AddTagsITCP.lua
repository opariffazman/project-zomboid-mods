local itemData = {
  ["Base.PipeWrench"] = {
    Tags = "PipeWrench"
  },
  ["Base.MeatCleaver"] = {
    Tags = "SharpKnife"
  },
  ["Base.Wrench"] = {
    Tags = "Wrench"
  }
}

for itemName, data in pairs(itemData) do
  local item = ScriptManager.instance:getItem(itemName)
  if item then
      item:DoParam("Tags = " .. data.Tags)
  end
end