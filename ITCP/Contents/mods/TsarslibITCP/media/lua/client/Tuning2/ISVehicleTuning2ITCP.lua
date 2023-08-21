if not getActivatedMods():contains("tsarslib") then
	return
end

local original_getAvailableItemsType

local function new_getAvailableItemsType(self, RecipeItem)
  local result = {};
  local recipeListBox = self:getRecipeListBox()
  RecipeItem = RecipeItem or recipeListBox.items[recipeListBox.selected].item
  if RecipeItem.use then
    for _, itemInList in pairs(RecipeItem.use) do
      local fullType = itemInList.fullType
      for _, itemCont in pairs(self.containerListLua) do
        if itemInList.isDrainable then       -- если предмет расходуемый, считает количество доступного использования
          local array = itemCont:FindAll(fullType)
          local count = 0
          for i = 0, array:size() - 1 do
            local itemFromInventory = array:get(i)
            local availableUses = itemFromInventory:getDrainableUsesInt()
            if availableUses > 0 then
              result[#result + 1] = itemFromInventory
              count = count + availableUses
            end
            if count > itemInList.count then break end
          end
          result[fullType] = (result[fullType] or 0) + count
        else
          local arraySize = itemCont:FindAll(fullType):size()
          result[fullType] = (result[fullType] or 0) + arraySize
        end
      end
    end
  end
  if RecipeItem.tools then
    for _, itemInList in pairs(RecipeItem.tools) do
      local fullType = itemInList.fullType
      for _, itemCont in pairs(self.containerListLua) do
        local arraySize = itemCont:FindAll(fullType):size()
        if itemCont:getFirstTagRecurse(itemInList.name) then
          arraySize = 1
        end
        result[fullType] = (result[fullType] or 0) + arraySize
      end
    end
  end
  return result
end

Events.OnGameBoot.Add(function()
  original_getAvailableItemsType = ISVehicleTuning2.getAvailableItemsType

  ISVehicleTuning2.getAvailableItemsType = new_getAvailableItemsType
end)
