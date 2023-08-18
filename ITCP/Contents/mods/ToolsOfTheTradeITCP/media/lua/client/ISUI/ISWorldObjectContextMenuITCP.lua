local function predicateNotBroken(item)
  return not item:isBroken()
end

local function getMoveableDisplayName(obj)
  if not obj then return nil end
  if not obj:getSprite() then return nil end
  local props = obj:getSprite():getProperties()
  if props:Is("CustomName") then
    local name = props:Val("CustomName")
    if props:Is("GroupName") then
      name = props:Val("GroupName") .. " " .. name
    end
    return Translator.getMoveableDisplayName(name)
  end
  return nil
end

function ISWorldObjectContextMenu.onPlumbItem(worldobjects, player, itemToPipe)
  local playerObj = getSpecificPlayer(player)
  local wrench = playerObj:getInventory():getFirstTagEvalRecurse("PipeWrench", predicateNotBroken)
  ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), wrench, true)
  ISTimedActionQueue.add(ISPlumbItem:new(playerObj, itemToPipe, wrench, 100))
end

local original_createMenu = ISWorldObjectContextMenu.createMenu

function ISWorldObjectContextMenu.createMenu(player, worldobjects, x, y, test)
  local context = original_createMenu(player, worldobjects, x, y, test)
  local playerObj = getSpecificPlayer(player)
  local playerInv = playerObj:getInventory()

  if canBeWaterPiped then
    print('canBeWaterPiped patched')
    if test == true then return true; end
    local name = getMoveableDisplayName(canBeWaterPiped) or ""
    local option = context:addOptionOnTop(getText("ContextMenu_PlumbItemITCP", name), worldobjects, ISWorldObjectContextMenu.onPlumbItem, playerObj, canBeWaterPiped)
    if not playerInv:containsTagEvalRecurse("PipeWrench", predicateNotBroken) then
      option.notAvailable = true
      local tooltip = ISWorldObjectContextMenu.addToolTip()
      tooltip:setName(getText("ContextMenu_PlumbItemITCP", name))
      local usedItem = InventoryItemFactory.CreateItem("Base.PipeWrench")
      tooltip.description = getText("Tooltip_NeedWrench", usedItem:getName())
      option.toolTip = tooltip
    end
    return context
  else
    return original_createMenu(player, worldobjects, x, y, test)
  end
end