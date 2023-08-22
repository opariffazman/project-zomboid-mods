if isClient() then return end

function VehicleUtils.getItems(playerNum)
  local containers = VehicleUtils.getContainers(playerNum)
  local typeToItem = {}
  for _, container in ipairs(containers) do
    for i = 1, container:getItems():size() do
      local item = container:getItems():get(i - 1)
      if item:getCondition() > 0 then
        if item:hasTag("Screwdriver") then
          typeToItem["Base.Screwdriver"] = typeToItem["Base.Screwdriver"] or {}
          table.insert(typeToItem["Base.Screwdriver"], item)
        elseif item:hasTag("Wrench") then
          typeToItem["Base.Wrench"] = typeToItem["Base.Wrench"] or {}
          table.insert(typeToItem["Base.Wrench"], item)
        else
          typeToItem[item:getFullType()] = typeToItem[item:getFullType()] or {}
          table.insert(typeToItem[item:getFullType()], item)
        end
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
