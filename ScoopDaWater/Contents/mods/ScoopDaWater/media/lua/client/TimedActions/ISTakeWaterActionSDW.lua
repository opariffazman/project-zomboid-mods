function ISTakeWaterAction:start()
  local waterAvailable = self.waterObject:getWaterAmount()

  if self.oldItem ~= nil then
      self.character:getInventory():AddItem(self.item);
      if self.character:isPrimaryHandItem(self.oldItem) then
          self.character:setPrimaryHandItem(self.item);
      end
      if self.character:isSecondaryHandItem(self.oldItem) then
          self.character:setSecondaryHandItem(self.item);
      end
      self.character:getInventory():Remove(self.oldItem);
      self.oldItem = nil
  end
  self.item = self.item;
  local props = self.waterObject:getProperties()
  local hasWaterFlag = (props ~= nil) and props:Is(IsoFlagType.water)
  local isLakeOrRiver = not instanceof(self.waterObject, "IsoWorldInventoryObject") and (props ~= nil) and
      luautils.stringStarts(self.waterObject:getSprite():getName(), 'blends_natural_02')
  local isPuddle = not hasWaterFlag and not isLakeOrRiver and (props ~= nil) and props:Is(IsoFlagType.solidfloor)
  if self.item ~= nil then
      self.item:setBeingFilled(true)
      self.item:setJobType(getText("ContextMenu_Fill") .. self.item:getName());
      self.item:setJobDelta(0.0);
      if (props ~= nil) and (props:Val("CustomName") == "Dispenser") then
          self.sound = self.character:playSound(self.item:getFillFromDispenserSound() or "GetWaterFromTap");
      elseif instanceof(self.waterObject, "IsoThumpable") or hasWaterFlag or isLakeOrRiver or isPuddle then -- play the drink sound for rain barrel
          self.sound = self.character:playSound("GetWaterFromLake");
      else
          self.sound = self.character:playSound(self.item:getFillFromTapSound() or "GetWaterFromTap");
      end
      local destCapacity = (1 - self.item:getUsedDelta()) / self.item:getUseDelta()
      self.waterUnit = math.min(math.ceil(destCapacity - 0.001), waterAvailable)
      self.startUsedDelta = self.item:getUsedDelta()
      self.endUsedDelta = math.min(self.item:getUsedDelta() + self.waterUnit * self.item:getUseDelta(), 1.0)
      if instanceof(self.waterObject, "IsoThumpable") or isLakeOrRiver then -- increase speed for barrel & lake or river
          -- print("ScoopThatWater mod item: " .. self.item:getName())
          if self.item:hasTag("FastScoop") then
              -- print('ScoopThatWater mod: FastScoop')
              self.action:setTime((self.waterUnit * 1) + 30)
          elseif self.item:hasTag("SlowScoop") then
              -- print('ScoopThatWater mod: SlowScoop')
              self.action:setTime((self.waterUnit * 5) + 30)
          else
              -- print('ScoopThatWater mod: none')
              self.action:setTime((self.waterUnit * 10) + 30)
          end
      else
          self.action:setTime((self.waterUnit * 10) + 30)
      end
      self:setAnimVariable("FoodType", self.item:getEatType());
      self:setActionAnim("fill_container_tap");
      if not self.item:getEatType() then
          self:setOverrideHandModels(nil, self.item:getStaticModel())
      else
          self:setOverrideHandModels(self.item:getStaticModel(), nil)
      end
  else
      if isLakeOrRiver or isPuddle then
          self.sound = self.character:playSound("DrinkingFromRiver");
      elseif instanceof(self.waterObject, "IsoThumpable") or hasWaterFlag or isLakeOrRiver then -- play the drink sound for rain barrel
          self.sound = self.character:playSound("DrinkingFromPool");
          --            getSoundManager():PlayWorldSoundWav("PZ_DrinkingFromBottle", self.character:getCurrentSquare(), 0, 2, 0.8, true);
      else
          self.sound = self.character:playSound("DrinkingFromTap");
          --            getSoundManager():PlayWorldSound("PZ_DrinkingFromTap", self.character:getCurrentSquare(), 0, 2, 0.8, true);
      end
      local thirst = self.character:getStats():getThirst()
      local waterNeeded = math.min(math.ceil(thirst / 0.1), 10)
      self.waterUnit = math.min(waterNeeded, waterAvailable)
      self.action:setTime((self.waterUnit * 10) + 15)

      self:setActionAnim("drink_tap")
      self:setOverrideHandModels(nil, nil)
  end

  self.character:reportEvent("EventTakeWater");
end