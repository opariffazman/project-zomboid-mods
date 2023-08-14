if getActivatedMods():contains("nattachments") then
  require("NATT_Recipes");
else
  return
end

local recipes = getAllRecipes()

local function HideRecipe()
  if recipes then
    for i = 0, recipes:size() - 1 do
      local recipe = recipes:get(i)
      -- print("nattachments patched")

      if recipe:getName() == "Add Weapon Slot"
          or recipe:getName() == "Remove Weapon Slot"
          or recipe:getName() == "Add Short Weapon Slot"
          or recipe:getName() == "Remove Short Weapon Slot"
          or recipe:getName() == "Add Flashlight Slot"
          or recipe:getName() == "Remove Flashlight Slot"
          or recipe:getName() == "Add Left Side Slot"
          or recipe:getName() == "Remove Left Side Slot"
          or recipe:getName() == "Add Right Side Slot"
          or recipe:getName() == "Remove Right Side Slot"
          or recipe:getName() == "Add Utility Left Slot"
          or recipe:getName() == "Remove Utility Left Slot"
          or recipe:getName() == "Add Utility Right Slot"
          or recipe:getName() == "Remove Utility Right Slot"
          or recipe:getName() == "Add Container Slot"
          or recipe:getName() == "Remove Container Slot"
          or recipe:getName() == "Add Small Container Left Slot"
          or recipe:getName() == "Remove Small Container Left Slot"
          or recipe:getName() == "Add Small Container Right Slot"
          or recipe:getName() == "Remove Small Container Right Slot"
          or recipe:getName() == "Add Bedroll Slot"
          or recipe:getName() == "Remove Bedroll Slot" then
        recipe:setIsHidden(true)
      end
    end
  end
end

Events.OnGameStart.Add(HideRecipe);
