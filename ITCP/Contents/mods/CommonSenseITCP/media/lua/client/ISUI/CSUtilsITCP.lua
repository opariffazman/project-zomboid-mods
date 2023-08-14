if not getActivatedMods():contains("BB_CommonSense") then
  return
end

local original_playerHasPryingTool = CSUtils.playerHasPryingTool
local original_showRadialMenuOutsideCrowbar = CSUtils.showRadialMenuOutsideCrowbar
local original_OnFillWorldObjectContextMenuCrowbar = CSUtils.OnFillWorldObjectContextMenuCrowbar

local function new_playerHasPryingTool(playerObj, itemID, override)
  -- print("playerHasPryingTool patched")

  if override then return true end
  if not playerObj then return false end
  if not itemID then return false end

  local playerInv = playerObj:getInventory()
  local pryingTool = playerInv:getFirstTagEvalRecurse("Crowbar", CSUtils.predicateNotBroken)


  if not pryingTool then return false end
end

local function new_showRadialMenuOutsideCrowbar(playerObj)
  if not SandboxVars.CommonSense.PryingMechanic then return end

  local vehicle = playerObj:getNearVehicle()
  if not vehicle then return end
  local menu = getPlayerRadialMenu(playerObj:getPlayerNum())
  local playerInv = playerObj:getInventory()
  local pryingTool = playerInv:getFirstTagEvalRecurse("Crowbar", CSUtils.predicateNotBroken)

  if not pryingTool then return end

  local doorPart = vehicle:getUseablePart(playerObj)

  if doorPart and doorPart:getDoor() and doorPart:getInventoryItem() then
    if not doorPart:getDoor():isLocked() then return end

    local isHood = doorPart:getId() == "EngineDoor"

    if not (isHood) then
      menu:addSlice(getText("ContextMenu_Pry_open"), getTexture("media/ui/vehicles/crowbar.png"), CSUtils.PryVehicleOpen,
        vehicle, doorPart, playerObj, pryingTool)
    end
  end
end

local function new_OnFillWorldObjectContextMenuCrowbar(player, context, worldobjects, test)
  if not SandboxVars.CommonSense.PryingMechanic then return end
  if test and ISWorldObjectContextMenu.Test then return true end

  if getCore():getGameMode() == "LastStand" then
    return
  end

  if test then return ISWorldObjectContextMenu.setTest() end
  local playerObj = getSpecificPlayer(player)
  local playerInv = playerObj:getInventory()
  local pryingTool = playerInv:getFirstTagEvalRecurse("Crowbar", CSUtils.predicateNotBroken)

  if playerObj:getVehicle() then return end
  if not pryingTool then return end

  local priableObject = nil

  for i, v in ipairs(worldobjects) do
    if ISWorldObjectContextMenu.isThumpDoor(v) == true then
      priableObject = v
    end
  end

  -- door interaction
  if priableObject ~= nil then
    -- Prevent prying open reinforced doors.
    -- Code snippet thanks to "UnCheat"!
    local spriteName = priableObject:getSprite():getName()

    if spriteName and
        spriteName == "fixtures_doors_01_32" or
        spriteName == "fixtures_doors_01_33" or
        spriteName == "location_community_police_01_4" or
        spriteName == "location_community_police_01_5" then
      return
    end
    -- End of credit

    local text = getText("ContextMenu_Pry_open")

    if not (priableObject:isLocked() == false or priableObject:isBarricaded()) then
      if instanceof(priableObject, "IsoDoor") or instanceof(priableObject, "IsoWindow") then
        context:addOptionOnTop(text, worldobjects, CSUtils.PryEntityOpen, priableObject, playerObj, pryingTool)
      end
    end
  end
end

Events.OnGameBoot.Add(function()
  original_playerHasPryingTool = CSUtils.playerHasPryingTool
  original_showRadialMenuOutsideCrowbar = CSUtils.showRadialMenuOutsideCrowbar
  original_OnFillWorldObjectContextMenuCrowbar = CSUtils.OnFillWorldObjectContextMenuCrowbar

  CSUtils.playerHasPryingTool = new_playerHasPryingTool
  CSUtils.showRadialMenuOutsideCrowbar = new_showRadialMenuOutsideCrowbar
  CSUtils.OnFillWorldObjectContextMenuCrowbar = new_OnFillWorldObjectContextMenuCrowbar
end)
