if not getActivatedMods():contains("LazoloDynamicBackpackUpgrades") then
	return
end

local original_start

local function new_start()
	--if self.recipe:getSound() then
		--self.craftSound = self.character:playSound(self.recipe:getSound());
	--end
	self.item:setJobType(self.JobType);
	self.item:setJobDelta(0.0);
	
	for i,v in pairs(self.ExtraItems) do
		v:setJobType(self.JobType)
		v:setJobDelta(0.0)
	end
	
	
	-- putting this in Start, this is a lot of code to run every frame when it really shouldn't be able to change.
	local imd = self.item:getModData()
	local TailoringModifier = SandboxVars.DynamicBackpacks.TailoringModifier
	if TailoringModifier == 0 then TailoringModifier = 100 end -- easier to make the math function do this than to make a whole set of "if" statements.
	if instanceof(self.iteminfo,"InventoryItem") then
		local UpgradesValid = imd.LMaxUpgrades > 0 and #imd.LUpgrades < imd.LMaxUpgrades + math.floor(self.character:getPerkLevel(Perks.Tailoring)/TailoringModifier)
		local ItemsLocationValid = self.character:getInventory():contains(self.item) and self.character:getInventory():contains(self.iteminfo)
		local HasTools = self.character:getInventory():containsTag("SewingNeedle") and self.character:getInventory():contains("Thread")
		print(UpgradesValid, ItemsLocationValid, HasTools)
		self.StartValid = UpgradesValid and ItemsLocationValid and HasTools
	else
		if self.character:getInventory():getFirstTag("Scissors") or SandboxVars.DynamicBackpacks.KnivesCanRemove and self.character:getInventory():getFirstTag("SharpKnife") then
			HasTool = true
		else
			HasTool = false
		end
		local UpgradesValid = false
		for i,v in pairs(imd.LUpgrades) do
			if v == self.iteminfo then
				UpgradesValid = true
			end
		end
		
		local BagRemovalValid = RemoveValid(self.item,self.iteminfo)
		print(HasTool, BagRemovalValid, UpgradesValid)
		self.StartValid = HasTool and BagRemovalValid and UpgradesValid
	end
	
	--if self.recipe:getProp1() or self.recipe:getProp2() then
		--self:setOverrideHandModels(self:getPropItemOrModel(self.recipe:getProp1()), self:getPropItemOrModel(self.recipe:getProp2()))
	--end
	--if self.recipe:getAnimNode() then
		--self:setActionAnim(self.recipe:getAnimNode());
	--else
		self:setActionAnim(CharacterActionAnims.Craft);
	--end

	--	self.character:reportEvent("EventCrafting");
end

Events.OnGameBoot.Add(function()
	original_start = ISDynamicBackpacksAction.start

	ISDynamicBackpacksAction.start = new_start
end)