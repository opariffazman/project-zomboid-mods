if not getActivatedMods():contains("TheStar") then
	return
end

local function isDrainableComboItem(item)
    return instanceof(item, "DrainableComboItem")
end

local original_render

local function new_render(self)
    local primaryItem = self.chr:getPrimaryHandItem();
    local secondaryItem = self.chr:getSecondaryHandItem();

    if ISMouseDrag.dragging and self:isMouseOver() then
        local item1, item2 = self:getDraggedEquippableItems()
        if item1 and secondaryItem and (primaryItem == secondaryItem or item1 == secondaryItem) then
            secondaryItem = nil;
        end
        if item2 and primaryItem and (primaryItem == secondaryItem or primaryItem == item2) then
            primaryItem = nil;
        end
        primaryItem = item1 or primaryItem
        secondaryItem = item2 or secondaryItem
    end

    if primaryItem then
        local item = primaryItem

        local isHandWeapon = TheStar.Utils.isHandWeapon(item)
        local isWaterSource = TheStar.Utils.isWaterSource(item)
        local isDrainableComboItem = isDrainableComboItem(item)

        local conditionLevel
        if isHandWeapon or isWaterSource or isDrainableComboItem then
            conditionLevel = item:getCondition() / item:getConditionMax()
            if isWaterSource or isDrainableComboItem then
                conditionLevel = item:getUsedDelta()
            end
            if conditionLevel < 0.0 then conditionLevel = 0.0 end
            if conditionLevel > 1.0 then conditionLevel = 1.0 end
        end

        -- Blinker
        if isHandWeapon and TheStar.Options.blinkOnConditionDrop then
            local hasConditionDropped = false
            if self.previousItem == item then
                self.isNewItem = false
                hasConditionDropped = conditionLevel < self.previousConditionLevel
            else
                self.isNewItem = true
            end
            self.previousItem = item
            self.previousConditionLevel = conditionLevel

            -- In case the player equips other item during blinking
            if self.isNewItem then self.isBlinking = false end

            if (not self.isNewItem and hasConditionDropped and conditionLevel <= TheStar.Options.blinkCondition)
                    or self.isBlinking then
                -- Init counter/reset counter every time condition drops
                if not self.blinkCount or hasConditionDropped then self.blinkCount = 0 end

                -- Blink
                if self.blinkCount <= TheStar.Config.BLINK_COUNT_MAX then
                    self.isBlinking = true

                    if not self.blinkAlpha then self.blinkAlpha = TheStar.Config.BLINK_ALPHA_MAX end

                    local overlayTexture
                    if TheStar.Options.showProgressBar then
                        local n = math.ceil(conditionLevel * 10)
                        overlayTexture = TheStar.Utils.getHandMainOverlayReversedTexture(n)
                    else
                        overlayTexture = TheStar.Utils.getHandMainOverlayTexture(10)
                    end
                    local blinkColor = TheStar.Utils.getProgressColor(conditionLevel)
                    self.mainHand:drawTexture(overlayTexture, 0, 0, self.blinkAlpha, blinkColor.r, blinkColor.g, blinkColor.b)

                    if not self.blinkAlphaIncrease then
                        self.blinkAlpha = self.blinkAlpha - 0.05 * (UIManager.getMillisSinceLastRender() / 22.2)
                        if self.blinkAlpha < 0 then
                            self.blinkAlpha = 0

                            -- Don't increase blinkAlpha on the last blink
                            if self.blinkCount < TheStar.Config.BLINK_COUNT_MAX then
                                self.blinkAlphaIncrease = true
                            end

                            -- Last blink
                            if self.blinkCount == TheStar.Config.BLINK_COUNT_MAX then
                                self.isBlinking = false
                            end
                        end
                    else
                        self.blinkAlpha = self.blinkAlpha + 0.05 * (UIManager.getMillisSinceLastRender() / 22.2)
                        if self.blinkAlpha > TheStar.Config.BLINK_ALPHA_MAX then
                            self.blinkAlpha = TheStar.Config.BLINK_ALPHA_MAX
                            self.blinkAlphaIncrease = false
                            -- Increase counter
                            self.blinkCount = self.blinkCount + 1
                        end
                    end
                end
            end
        end

        -- Progress Bar
        if (isHandWeapon or isWaterSource or isDrainableComboItem) and TheStar.Options.showProgressBar then
            local n = math.ceil(conditionLevel * 10)
            local overlayTexture = TheStar.Utils.getHandMainOverlayTexture(n)
            local progressColor = TheStar.Utils.getProgressColor(conditionLevel, isWaterSource)

            self.mainHand:drawTexture(overlayTexture, 0, 0, TheStar.Options.progressBarOpacityEquipped, progressColor.r, progressColor.g, progressColor.b)
        end

        -- Item Texture
        if item:getTex() and item:getTex():getWidth() <= 32 and item:getTex():getHeight() <= 32 then
            self:drawTextureScaled(item:getTex(), (self.handMainTexture:getWidth() / 2) - (item:getTex():getWidth() / 2), (self.handMainTexture:getHeight() / 2) - (item:getTex():getHeight() / 2), item:getTex():getWidth(), item:getTex():getHeight(), item:getA(), item:getR(), item:getG(), item:getB());
        else
            self:drawTextureScaledAspect(item:getTex(), self.handMainTexture:getWidth() / 2 - 16, self.handMainTexture:getHeight() / 2 - 16, 32, 32, item:getA(), item:getR(), item:getG(), item:getB());
        end

        -- Icon
        if isHandWeapon and TheStar.Options.showIcon then
            local n = math.ceil(conditionLevel * 5)
            local iconTexture = TheStar.Utils.getIconTexture(n)

            if TheStar.Options.equippedItemIconPosition == 1 then
                -- top left (original)
                self:drawTexture(iconTexture, 7, 10, 1, 1, 1, 1)
            else
                -- top right
                self:drawTexture(iconTexture, 42 - iconTexture:getWidth(), 10, 1, 1, 1, 1)
            end
        end
    else
        -- Reset
        self.previousItem = nil
    end
    if secondaryItem then
        local item = secondaryItem
        local width = 24
        local height = 24
        if item:getTex() and item:getTex():getWidth() <= width and item:getTex():getHeight() <= height then
            width = self.HandSecondaryTexture:getWidthOrig()
            height = self.HandSecondaryTexture:getHeightOrig()
            self:drawTextureScaled(item:getTex(), (width - item:getTex():getWidth()) / 2, 50 + (height - item:getTex():getHeight()) / 2, item:getTex():getWidth(), item:getTex():getHeight(), item:getA(), item:getR(), item:getG(), item:getB());
        else
            self:drawTextureScaledAspect(item:getTex(), 0 + (self.HandSecondaryTexture:getWidthOrig() - width) / 2, 50 + (self.HandSecondaryTexture:getHeightOrig() - height) / 2, width, height, item:getA(), item:getR(), item:getG(), item:getB());
        end
    end

    if self.chr:getBodyDamage():getHealth() ~= self.previousHealth then
        if self.previousHealth > self.chr:getBodyDamage():getHealth() then
            self.healthIconOscillatorLevel = 1;
        end
        self.previousHealth = self.chr:getBodyDamage():getHealth()
    end

    --code for the oscillation of the heart icon when attacked
    if not self.healthBtn then
        -- Player 1/2/3
    elseif self.healthIconOscillatorLevel > 0.01 then
        local fpsFrac = PerformanceSettings.getLockFPS() / 30.0;
        self.healthIconOscillatorLevel = self.healthIconOscillatorLevel * self.healthIconOscillatorDecelerator
        self.healthIconOscillatorLevel = self.healthIconOscillatorLevel - (self.healthIconOscillatorLevel * (1 - self.healthIconOscillatorDecelerator) / fpsFrac)
        self.healthIconOscillatorStep = self.healthIconOscillatorStep + self.healthIconOscillatorRate / fpsFrac
        self.healthIconOscillator = math.sin(self.healthIconOscillatorStep)
        self.healthBtn:setX(self.healthIconOscillator * self.healthIconOscillatorLevel * self.healthIconOscillatorScalar)
    elseif self.healthIconOscillatorLevel < 0.01 then
        self.healthIconOscillatorLevel = 0
        self.healthBtn:setX(self.healthIconOscillator * self.healthIconOscillatorLevel * self.healthIconOscillatorScalar)
    end

    if self.invBtn == nil then
        return ;
    end

    if ISEquippedItem.text then
        self:drawText(ISEquippedItem.text, 50, 0, 1, 1, 1, 1, UIFont.Medium);
    end

    self:checkToolTip();

    self:renderFPS();
end

Events.OnGameBoot.Add(function()
	original_Render = ISEquippedItem.render

	ISEquippedItem.render = new_render
end)