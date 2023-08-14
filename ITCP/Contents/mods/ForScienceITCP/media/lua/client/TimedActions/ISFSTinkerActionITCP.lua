if not getActivatedMods():contains("ForScience") then
	return
end

local original_isValid = ISFSTinkerAction.isValid

local function new_isValid(self)
	-- print("tinker isValid patched")
	
	local playerInv = self.character:getInventory()
	local containsScrewdriver = playerInv:containsTag("Screwdriver")
	local containsElectronicsScrap = playerInv:containsTypeRecurse("Base.ElectronicsScrap")
	return containsScrewdriver and containsElectronicsScrap
end

Events.OnGameBoot.Add(function()
	original_isValid = ISFSTinkerAction.isValid

	ISFSTinkerAction.isValid = new_isValid
end)
