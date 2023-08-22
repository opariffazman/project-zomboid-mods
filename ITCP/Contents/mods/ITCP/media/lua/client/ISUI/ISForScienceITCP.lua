if not getActivatedMods():contains("ForScience") then
	return
end

local function predicateNotBroken(item)
	return not item:isBroken()
end

local original_dissectCorpseContextMenu
local original_onDissectCorpse
local original_tinkerWorldContextMenu
local original_onTinkerWorld
local original_tinkerInvContextMenu
local original_onTinkerInv

local function new_dissectCorpseContextMenu(player, context, worldobjects, test)
	-- print("dissectCorpseContextMenu patched")

	local playerObj = getSpecificPlayer(player)
	local x = getMouseX()
	local y = getMouseY()

	local body = IsoObjectPicker.Instance:PickCorpse(x, y)
	if not body then return end

	if body then
		if playerObj:getPerkLevel(Perks.Doctor) >= 4 then
			if test == true then return true; end
			local option = context:addOption(getText("ContextMenu_FSDissect_Corpse"), worldobjects,
				ISForScience.onDissectCorpse, player, body);
			local toolTip = ISWorldObjectContextMenu.addToolTip();
			toolTip.description = getText("ContextMenu_FSDissect_Tooltip");
			option.toolTip = toolTip;
			if playerObj:getInventory():containsTagEvalRecurse("SharpKnife", predicateNotBroken) == false then
				toolTip.description = toolTip.description ..
						" <LINE> <RGB:1,0,0> " .. getText("ContextMenu_Require", getItemNameFromFullType("Base.Scalpel"));
				option.toolTip = toolTip;
				option.notAvailable = true
			end
			if playerObj:getInventory():containsTypeRecurse("Base.BookMedicalJournal") then
				toolTip.description = toolTip.description .. " <LINE> <RGB:0,1,0> " .. getText("ContextMenu_FSJournal_Tooltip");
			end
		end
	end
end

local function new_onDissectCorpse(worldobjects, player, corpse)
	-- print("onDissectCorpse patched")

	local playerObj = getSpecificPlayer(player);
	local playerInv = playerObj:getInventory();
	if corpse:getSquare() and luautils.walkAdj(playerObj, corpse:getSquare()) then
		local scalpel = playerInv:getFirstTagEvalRecurse("SharpKnife", predicateNotBroken);
		ISInventoryPaneContextMenu.transferIfNeeded(playerObj, scalpel);
		ISTimedActionQueue.add(ISFSDissectCorpseAction:new(playerObj, corpse, scalpel));
	end
end

local function new_tinkerWorldContextMenu(player, context, worldobjects, test)
	-- print("tinkerWorldContextMenu patched")

	local playerObj = getSpecificPlayer(player)
	local sq = clickedSquare;
	local deviceSimple = nil
	local deviceAdvanced = nil
	if sq then
		if sq:getObjects() then
			for i = 0, sq:getObjects():size() - 1 do
				local obj = sq:getObjects():get(i);
				if instanceof(obj, "IsoRadio") or instanceof(obj, "IsoTelevision") then
					deviceSimple = obj;
					break;
				end
				if obj:getSprite() then
					local spriteName = obj:getSprite():getName() or nil;
					if spriteName then
						--Jukebox
						if (spriteName == "recreational_01_0") or (spriteName == "recreational_01_1") then
							deviceSimple = obj;
							break;
						end
						-- Security Terminal
						if (spriteName == "security_01_0") or (spriteName == "security_01_1") then
							deviceAdvanced = obj;
							break;
						end
						-- Arcade
						if (spriteName == "recreational_01_16") or (spriteName == "recreational_01_17")
								or (spriteName == "recreational_01_18") or (spriteName == "recreational_01_19")
								or (spriteName == "recreational_01_20") or (spriteName == "recreational_01_21")
								or (spriteName == "recreational_01_22") or (spriteName == "recreational_01_23") then
							deviceAdvanced = obj;
							break;
						end
						-- Computer
						if (spriteName == "appliances_com_01_72") or (spriteName == "appliances_com_01_73")
								or (spriteName == "appliances_com_01_74") or (spriteName == "appliances_com_01_75") then
							deviceAdvanced = obj;
							break;
						end
						-- Radio (if not found by IsoRadio)
						-- e.g. appliances_radio_01_8
						if string.find(spriteName, "radio") then
							deviceSimple = obj;
							break;
						end
						-- Television (if not found by IsoTelevision)
						-- e.g. appliances_television_01_2
						if string.find(spriteName, "television") then
							deviceSimple = obj;
							break;
						end
						-- Ham radios
						-- e.g. appliances_com_01
						if string.find(spriteName, "appliances_com_01") then
							deviceSimple = obj;
							break;
						end
					end
				end
			end
		end
	end
	if deviceSimple then
		if test == true then return true; end
		local option = context:addOption(getText("ContextMenu_FSTinker"), worldobjects, ISForScience.onTinkerWorld, player,
			deviceSimple, true);
		local toolTip = ISWorldObjectContextMenu.addToolTip();
		toolTip.description = getText("ContextMenu_FSSimple");
		option.toolTip = toolTip;
		if playerObj:getInventory():containsTagEvalRecurse("Screwdriver", predicateNotBroken) == false then
			toolTip.description = toolTip.description ..
					" <LINE> <RGB:1,0,0> " .. getText("ContextMenu_Require", getItemNameFromFullType("Base.Screwdriver"));
			option.notAvailable = true;
		end
		if playerObj:getInventory():containsTypeRecurse("Base.ElectronicsScrap") == false then
			toolTip.description = toolTip.description ..
					" <LINE> <RGB:1,0,0> " .. getText("ContextMenu_Require", getItemNameFromFullType("Base.ElectronicsScrap"));
			option.notAvailable = true;
		end
		if playerObj:getInventory():containsTypeRecurse("Base.BookElectricManual") then
			toolTip.description = toolTip.description .. " <LINE> <RGB:0,1,0> " .. getText("ContextMenu_FSManual_Tooltip");
		end
		if playerObj:getPerkLevel(Perks.Electricity) >= 4 then
			toolTip.description = toolTip.description .. " <LINE> <RGB:1,0,0> " .. getText("ContextMenu_FSTooSkilled_Tooltip");
			option.notAvailable = true;
		end
	end
	if deviceAdvanced and (playerObj:getPerkLevel(Perks.Electricity) >= 4) then
		if test == true then return true; end
		local option = context:addOption(getText("ContextMenu_FSTinker"), worldobjects, ISForScience.onTinkerWorld, player,
			deviceAdvanced, false);
		local toolTip = ISWorldObjectContextMenu.addToolTip();
		toolTip.description = getText("ContextMenu_FSAdvanced");
		option.toolTip = toolTip;
		if playerObj:getInventory():containsTagEvalRecurse("Screwdriver", predicateNotBroken) == false then
			toolTip.description = toolTip.description ..
					" <LINE> <RGB:1,0,0> " .. getText("ContextMenu_Require", getItemNameFromFullType("Base.Screwdriver"));
			option.notAvailable = true;
		end
		if playerObj:getInventory():containsTypeRecurse("Base.ElectronicsScrap") == false then
			toolTip.description = toolTip.description ..
					" <LINE> <RGB:1,0,0> " .. getText("ContextMenu_Require", getItemNameFromFullType("Base.ElectronicsScrap"));
			option.notAvailable = true;
		end
		if playerObj:getInventory():containsTypeRecurse("Base.BookElectricManual") then
			toolTip.description = toolTip.description .. " <LINE> <RGB:0,1,0> " .. getText("ContextMenu_FSManual_Tooltip");
		end
	end
end

local function new_onTinkerWorld(worldobjects, player, device, isSimple)
	-- print("onTinkerWorld patched")

	local playerObj = getSpecificPlayer(player);
	local playerInv = playerObj:getInventory();
	if device:getSquare() and luautils.walkAdj(playerObj, device:getSquare()) then
		local screwdriver = playerInv:getFirstTagEvalRecurse("Screwdriver", predicateNotBroken);
		ISInventoryPaneContextMenu.transferIfNeeded(playerObj, screwdriver);
		ISTimedActionQueue.add(ISFSTinkerAction:new(playerObj, device, nil, screwdriver, isSimple));
	end
end

local function new_tinkerInvContextMenu(player, context, items)
	-- print("tinkerInvContextMenu patched")

	local playerObj = getSpecificPlayer(player);
	items = ISInventoryPane.getActualItems(items)
	for _, item in ipairs(items) do
		if instanceof(item, "Radio") then
			if test == true then return true; end
			local option = context:addOption(getText("ContextMenu_FSTinker"), player, ISForScience.onTinkerInv, item, true);
			local toolTip = ISWorldObjectContextMenu.addToolTip();
			toolTip.description = getText("ContextMenu_FSSimple");
			option.toolTip = toolTip;
			if playerObj:getInventory():containsTagEvalRecurse("Screwdriver", predicateNotBroken) == false then
				toolTip.description = toolTip.description ..
						" <LINE> <RGB:1,0,0> " .. getText("ContextMenu_Require", getItemNameFromFullType("Base.Screwdriver"));
				option.notAvailable = true;
			end
			if playerObj:getInventory():containsTypeRecurse("Base.ElectronicsScrap") == false then
				toolTip.description = toolTip.description ..
						" <LINE> <RGB:1,0,0> " .. getText("ContextMenu_Require", getItemNameFromFullType("Base.ElectronicsScrap"));
				option.notAvailable = true;
			end
			if playerObj:getInventory():containsTypeRecurse("Base.BookElectricManual") then
				toolTip.description = toolTip.description .. " <LINE> <RGB:0,1,0> " .. getText("ContextMenu_FSManual_Tooltip");
			end
			break;
		end
	end
end

local function new_onTinkerInv(player, device)
	-- print("onTinkerInv patched")

	local playerObj = getSpecificPlayer(player);
	local playerInv = playerObj:getInventory();
	local screwdriver = playerInv:getFirstTagEvalRecurse("Screwdriver", predicateNotBroken)
	ISInventoryPaneContextMenu.transferIfNeeded(playerObj, screwdriver);
	ISInventoryPaneContextMenu.transferIfNeeded(playerObj, device);
	ISTimedActionQueue.add(ISFSTinkerAction:new(playerObj, nil, device, screwdriver, true));
end

Events.OnGameBoot.Add(function()
	original_dissectCorpseContextMenu = ISForScience.dissectCorpseContextMenu
	original_onDissectCorpse = ISForScience.onDissectCorpse
	original_tinkerWorldContextMenu = ISForScience.tinkerWorldContextMenu
	original_onTinkerWorld = ISForScience.onTinkerWorld
	original_tinkerInvContextMenu = ISForScience.tinkerInvContextMenu
	original_onTinkerInv = ISForScience.onTinkerInv

	ISForScience.dissectCorpseContextMenu = new_dissectCorpseContextMenu
	ISForScience.onDissectCorpse = new_onDissectCorpse
	ISForScience.tinkerWorldContextMenu = new_tinkerWorldContextMenu
	ISForScience.onTinkerWorld = new_onTinkerWorld
	ISForScience.tinkerInvContextMenu = new_tinkerInvContextMenu
	ISForScience.onTinkerInv = new_onTinkerInv
end)