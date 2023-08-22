if not getActivatedMods():contains("ToolsOfTheTrade") then
	return
end

function ISVehiclePartMenu.equipRequiredItems(playerObj, part, tbl)
	if tbl and tbl.items then
		for _, item in pairs(tbl.items) do
			local module, type = VehicleUtils.split(item.type, "\\.")
			type = type or item.type -- in case item.type has no '.'
			local itemToEquip = playerObj:getInventory():getFirstTagRecurse(type)
			if item.equip == "primary" then
				ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), itemToEquip, true)
			elseif item.equip == "secondary" then
				ISWorldObjectContextMenu.equip(playerObj, playerObj:getSecondaryHandItem(), itemToEquip, false)
			elseif item.equip == "both" then
				ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), itemToEquip, false, true)
			end
		end
	end
end
