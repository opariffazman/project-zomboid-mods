if not getActivatedMods():contains("Remastered Kitsune's Crossbow Mod") then
  return
end

local recipes = getAllRecipes()

local function HideRecipe()
  if recipes then
    for i = 0, recipes:size() - 1 do
      local recipe = recipes:get(i)
      print("Remastered Kitsune's Crossbow Mod patched")

      if recipe:getName() == "Dismantle Hand Crossbow" or
      recipe:getName() == "Dismantle Hunting Crossbow" or
      recipe:getName() == "Dismantle Long Crossbow Bolts (x3)" or
      recipe:getName() == "Dismantle Short Crossbow Bolts (x3)" or
      recipe:getName() == "Craft Wooden Crossbow" or
      recipe:getName() == "Craft Metal Crossbow" or
      recipe:getName() == "Craft Wooden Crossbow Bolts (x3)" or
      recipe:getName() == "Craft Wooden Crossbow Bolts (x3)" or
      recipe:getName() == "Craft Bolt Fletching (x3)" or
      recipe:getName() == "Craft Short Shafts (x3)" or
      recipe:getName() == "Craft Long Shafts (x3)" or
      recipe:getName() == "Craft Bolt Head (x3)" or
      recipe:getName() == "Craft Long Crossbow Bolt (x3)" or
      recipe:getName() == "Craft Short Crossbow Bolt (x3)" or
      recipe:getName() == "Craft Chipped Stone" or
      recipe:getName() == "Convert Sling to Crossbow Sling" or
      recipe:getName() == "Convert Ironsight to Crossbow Ironsight" or
      recipe:getName() == "Convert x2 Scope to Crossbow x2 Scope" or
      recipe:getName() == "Convert x4 Scope to Crossbow x4 Scope" or
      recipe:getName() == "Convert x8 Scope to Crossbow x8 Scope" or
      recipe:getName() == "Convert RedDot to Crossbow RedDot" or
      recipe:getName() == "Convert Stock to Crossbow Stock" or
      recipe:getName() == "Convert Laser to Crossbow Laser" or
      recipe:getName() == "Convert Crossbow Sling to Normal Sling" or
      recipe:getName() == "Convert Crossbow Ironsight to Normal Ironsight" or
      recipe:getName() == "Convert Crossbow x2 Scope to Normal x2 Scope" or
      recipe:getName() == "Convert Crossbow x4 Scope to Normal 4x Scope" or
      recipe:getName() == "Convert Crossbow x8 Scope to Normal x8 Scope" or
      recipe:getName() == "Convert Crossbow RedDot to Normal RedDot" or
      recipe:getName() == "Convert Crossbow Stock to Normal Stock" or
      recipe:getName() == "Convert Crossbow Laser to Normal Laser"
      then
        recipe:setIsHidden(true)
      end
    end
  end
end

HideRecipe()