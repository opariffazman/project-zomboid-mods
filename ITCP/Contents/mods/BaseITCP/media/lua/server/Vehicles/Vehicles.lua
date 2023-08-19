function VehicleUtils.getItems(playerNum)
	local containers = VehicleUtils.getContainers(playerNum)
	local typeToItem = {}
	for _,container in ipairs(containers) do
		for i=1,container:getItems():size() do
			local item = container:getItems():get(i-1)
			if item:getCondition() > 0 then
				typeToItem[item:getFullType()] = typeToItem[item:getFullType()] or {}
				table.insert(typeToItem[item:getFullType()], item)
				-- This isn't needed for Radios any longer.  There was a bug setting
				-- the item type to Radio.worldSprite, but that no longer happens.
				if instanceof(item, "Moveable") and item:getWorldSprite() then
					local fullType = item:getScriptItem():getFullName()
					if fullType ~= item:getFullType() then
						typeToItem[fullType] = typeToItem[fullType] or {}
						table.insert(typeToItem[fullType], item)
					end
				end
			end
		end
	end
	return typeToItem
end