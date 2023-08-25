if not getActivatedMods():contains("ReorganizedInfoScreen") then
	return
end

local original_onShaveChest

local function new_onShaveChest(playerObj, chestStyle)
	local playerInv = playerObj:getInventory()
	local scissors = playerInv:getFirstTagEvalRecurse("Razor", predicateNotBroken);
	ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), scissors, true)
	ISTimedActionQueue.add(ISShaveChest:new(playerObj, chestStyle, scissors, 300));
end

Events.OnGameBoot.Add(function()
	original_onShaveChest = ISCharacterScreen.onShaveChest

	ISCharacterScreen.onShaveChest = new_onShaveChest
end)