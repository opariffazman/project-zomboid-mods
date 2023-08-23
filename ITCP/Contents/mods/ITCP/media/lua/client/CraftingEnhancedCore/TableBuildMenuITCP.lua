if not getActivatedMods():contains("craftingEnhancedCore") then
	return
end

local function predicateNotBroken(item)
  return not item:isBroken()
end

local original_canBuildObject

local function new_canBuildObject(_tooltip, player, table)
  local inv = getPlayer(player):getInventory()

  if not inv:containsTagEvalRecurse(table.requireTool, predicateNotBroken) then
    _tooltip.description = _tooltip.description .. ' <RGB:1,0,0>' ..
        getText("ContextMenu_RequireTool") .. " " .. getItemNameFromFullType("Base." .. table.requireTool) .. ' <LINE>'
  end

  for _, material in pairs(table.recipe) do
    local invItemCount = inv:getItemCountFromTypeRecurse(material.type)

    if invItemCount >= material.amount or ISBuildMenu.cheat then
      _tooltip.description = _tooltip.description ..
          ' <RGB:1,1,1>' ..
          getItemNameFromFullType(material.type) .. ' ' .. material.amount .. '/' .. material.amount .. ' <LINE>'
    else
      _tooltip.description = _tooltip.description ..
          ' <RGB:1,0,0>' ..
          getItemNameFromFullType(material.type) .. ' ' .. invItemCount .. '/' .. material.amount .. ' <LINE>'
    end
  end
end

Events.OnGameBoot.Add(function()
  original_canBuildObject = CraftingEnhancedCore.canBuildObject

  CraftingEnhancedCore.canBuildObject = new_canBuildObject
end)
