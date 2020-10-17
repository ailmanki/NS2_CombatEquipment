
if Client then
    
    function MarineActionFinderMixin:OnProcessMove()
    
        PROFILE("MarineActionFinderMixin:OnProcessMove")
    
        local kIconUpdateRate = 0.25
        local prediction = Shared.GetIsRunningPrediction()
        if prediction then
            return
        end

        local now = Shared.GetTime()
        local enoughTimePassed = (now - self.lastMarineActionFindTime) >= kIconUpdateRate
        if not enoughTimePassed then
            return
        end

        self.lastMarineActionFindTime = now
        
        local success = false
        
        local gameStarted = self:GetGameStarted()
        
        if self:GetIsAlive() then
            local manualPickupWeapon = self:GetNearbyPickupableWeapon()
            if gameStarted and manualPickupWeapon then
                self.actionIconGUI:ShowIcon(BindingsUI_GetInputValue("Use"), manualPickupWeapon:GetClassName(), nil)
                success = true
            else
                
                local ent = self:PerformUseTrace()

                local usageAllowed = ent ~= nil -- check for entity
                usageAllowed = usageAllowed and (gameStarted or (ent.GetUseAllowedBeforeGameStart and ent:GetUseAllowedBeforeGameStart())) -- check if entity can be used before game start
                usageAllowed = usageAllowed and (not GetWarmupActive() or not ent.GetCanBeUsedDuringWarmup or ent:GetCanBeUsedDuringWarmup()) -- check if entity can be used during warmup
                if usageAllowed then
                    if GetPlayerCanUseEntity(self, ent) then
    
                        if ent:isa("CommandStation") and ent:GetIsBuilt() and not self:GetIsUsing() then
                            local hintText = gameStarted and "START_COMMANDING" or "START_GAME"
                            self.actionIconGUI:ShowIcon(BindingsUI_GetInputValue("Use"), nil, hintText, nil)
                            success = true
                        elseif HasMixin(ent, "Digest") and ent:GetIsAlive() then
        
                            local hintFraction = DigestMixin.GetDigestFraction(ent)
                            -- avoid the slight flicker at the end, caused by the digest effect for Clogs..
                            if hintFraction <= 1.0 then
                                local hintText = "RECYCLE"
                                self.actionIconGUI:ShowIcon(BindingsUI_GetInputValue("Use"), nil, hintText, hintFraction)
            
                                success = true
                            end
    
                        elseif not self:GetIsUsing() then
                            self.actionIconGUI:ShowIcon(BindingsUI_GetInputValue("Use"), nil, hintText, nil)
                            success = true
                        end
                        
                    end
                    
                end
                
            end
        end
        
        if not success then
            self.actionIconGUI:Hide()
        end
        
    end
    
end