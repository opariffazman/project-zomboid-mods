if not getActivatedMods():contains("Better Belts") then
  return
end

local recipes = getAllRecipes()

local function HideRecipe()
  if recipes then
    for i = 0, recipes:size() - 1 do
      local recipe = recipes:get(i)
      -- print("BetterBelts patched")

      if recipe:getName() == "Make Holster" or
          recipe:getName() == "Make Belt" or
          recipe:getName() == "Rip Belt" or
          recipe:getName() == "Make Quiver"
      then
        recipe:setIsHidden(true)
      end
    end
  end
end

HideRecipe()
