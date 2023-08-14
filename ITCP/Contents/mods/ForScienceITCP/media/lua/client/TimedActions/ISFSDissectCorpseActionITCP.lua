if not getActivatedMods():contains("ForScience") then
	return
end

local original_isValid = ISFSDissectCorpseAction.isValid

local function new_isValid(self)
	print("dissect isValid patched")

	local playerInv = self.character:getInventory()
	local containsScalpel = playerInv:containsTag("SharpKnife")
	if self.corpse:getStaticMovingObjectIndex() < 0 then
		return false
	end
	if not containsScalpel then
		return false;
	end
	return true;
end

Events.OnGameBoot.Add(function()
	original_isValid = ISFSDissectCorpseAction.isValid

	ISFSDissectCorpseAction.isValid = new_isValid
end)
