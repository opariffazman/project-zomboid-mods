if not getActivatedMods():contains("AutoMechanics") then
    return
end

local original_getPlayerFastestItemAnyInventory

local function new_getPlayerFastestItemAnyInventory(player, itemType)
    -- print("getPlayerFastestItemAnyInventory patched")
    local returnItem = nil
    if itemType == "Screwdriver" then
        returnItem = player:getInventory():getFirstTagRecurse("Screwdriver")
    else
        returnItem = player:getInventory():getFirstTypeRecurse(itemType)
    end
    return returnItem
end

Events.OnGameBoot.Add(function()
    original_getPlayerFastestItemAnyInventory = AutoMechanics.getPlayerFastestItemAnyInventory
    AutoMechanics.getPlayerFastestItemAnyInventory = new_getPlayerFastestItemAnyInventory
end)
