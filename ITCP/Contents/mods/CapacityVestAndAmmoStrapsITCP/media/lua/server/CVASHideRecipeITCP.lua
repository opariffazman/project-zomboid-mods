if not getActivatedMods():contains("CapacityVestAndAmmoStraps") then
  return
end

local recipes = getAllRecipes()

local function HideRecipe()
  if recipes then
    for i = 0, recipes:size() - 1 do
      local recipe = recipes:get(i)
      -- print("CapacityVestAndAmmoStraps patched")

      if recipe:getName() == "Make grey hunting vest" or
          recipe:getName() == "Make orange hunting vest" or
          recipe:getName() == "Make camo hunting vest" or
          recipe:getName() == "Make green camo hunting vest" or
          recipe:getName() == "Make shells ammo strap" or
          recipe:getName() == "Make bullets ammo strap" then
        recipe:setIsHidden(true)
      end
    end
  end
end

HideRecipe()
