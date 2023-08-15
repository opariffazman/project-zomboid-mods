if not getActivatedMods():contains("AutoSewing") then
    return
end

local original_getPlayerFastestItemAnyInventory = AutoSewing.getPlayerFastestItemAnyInventory

local function new_getPlayerFastestItemAnyInventory(player, itemType)
    -- print("getPlayerFastestItemAnyInventory patched")
    local returnItem = nil
    if itemType == "Needle" then
        returnItem = player:getInventory():getFirstTagRecurse("SewingNeedle")
    else
        returnItem = player:getInventory():getFirstTypeRecurse(itemType)
    end
    return returnItem
end

Events.OnGameBoot.Add(function()
    original_getPlayerFastestItemAnyInventory = AutoSewing.getPlayerFastestItemAnyInventory
    AutoSewing.getPlayerFastestItemAnyInventory = new_getPlayerFastestItemAnyInventory
end)
