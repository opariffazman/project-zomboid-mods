if not getActivatedMods():contains("LazoloDynamicBackpackUpgrades") then
	return
end

local original_CheckForAndGetUpgradeItems
local original_CheckForAndGetRemoveItems

local function new_CheckForAndGetUpgradeItems(Player,Fetch)
	local inv = Player:getInventory()
	local Needle = inv:getFirstTagRecurse("SewingNeedle")
	local Thread = inv:getFirstTypeEvalRecurse("Thread",function(item) return item:getRemainingUses() > 0 end)
	if not Needle or not Thread then return false end
	if Fetch and not inv:containsTag("SewingNeedle") then
		ISTimedActionQueue.add(ISInventoryTransferAction:new(Player, Needle, Needle:getContainer(), inv, Needle:getWeight()*60)) 
	end
	if Fetch and not inv:contains(Thread) then
		ISTimedActionQueue.add(ISInventoryTransferAction:new(Player, Thread, Thread:getContainer(), inv, Thread:getWeight()*60))
	end
	return Needle, Thread
end

local function new_CheckForAndGetRemoveItems(Player,Fetch)
	local inv = Player:getInventory()
	local Scissors = inv:getFirstTagEvalRecurse("Scissors",HasDurability)
	--for i,v in pairs(ScissorsItemTypes) do
		--Scissors = inv:getFirstTypeRecurse(v)
	--end
	if KnivesCanRemove and not Scissors then Scissors = inv:getFirstTagEvalRecurse("SharpKnife",HasDurability) end
	
	if not Scissors then return false end
	if Fetch and not inv:containsTag("Scissors") then
		ISTimedActionQueue.add(ISInventoryTransferAction:new(Player, Scissors, Scissors:getContainer(), inv, Scissors:getWeight()*60))
	end
	return Scissors, Damaged
end

Events.OnGameBoot.Add(function()
	original_CheckForAndGetUpgradeItems = CheckForAndGetUpgradeItems
	original_CheckForAndGetRemoveItems = CheckForAndGetRemoveItems

	CheckForAndGetUpgradeItems = new_CheckForAndGetUpgradeItems
	CheckForAndGetRemoveItems = new_CheckForAndGetRemoveItems
end)