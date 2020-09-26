
local networkVars =
{
    hasSentry = "private boolean"
}
local oldOnCreate = LayMines.OnCreate
function LayMines:OnCreate()
    
    oldOnCreate(self)
    
    self.hasSentry = false

end

function LayMines:GetHasSecondary(player)
    return self.hasSentry
end
function LayMines:GetSecondaryAttackRequiresPress()
    return true
end

if Server then
    function LayMines:SwitchToWelder(player)
        self.secondaryAttacking = false
        player:RemoveWeapon(self)
        DestroyEntity(self)
        
        local newBuildSentry = player:GiveItem(BuildSentry.kMapName)
        newBuildSentry.hasMine = true
        player:SetHUDSlotActive(newBuildSentry:GetHUDSlot()) -- switch to it
    end
    
    function LayMines:OnSecondaryAttack(player)
        self.secondaryAttacking = true
        Weapon.OnSecondaryAttack(self, player)
    end
    
    function LayMines:OnSecondaryAttackEnd(player)
        if self.secondaryAttacking and self.hasSentry then
            self:SwitchToWelder(player)
        end
        self.secondaryAttacking = false
    end
end
if Client then
    
    function LayMines:CreateSwitchInfo()
        
        if not self.switchInfo then
            self.switchInfo = GetGUIManager():CreateGUIScript("NS2_CombatEquipment/GUISwitchInfo")
            self.switchInfo:SetSwitchName("Sentry")
        end
    
    end
    
    function LayMines:DestroySwitchInfo()
        if self.switchInfo ~= nil then
            GetGUIManager():DestroyGUIScript(self.switchInfo)
            self.switchInfo = nil
        end
    end
    
    local function UpdateGUI(self, player)
        local localPlayer = Client.GetLocalPlayer()
        if localPlayer == player then
            self:CreateSwitchInfo()
        end
        
        if self.switchInfo then
            self.switchInfo:SetIsVisible(player and localPlayer == player and self.hasSentry and self:GetIsActive() and not HelpScreen_GetHelpScreen():GetIsBeingDisplayed())
        end
    end
    
    function LayMines:OnUpdateRender()
        UpdateGUI(self, self:GetParent())
    end
    
    local oldOnDestroy = LayMines.OnDestroy
    function LayMines:OnDestroy()
        self:DestroySwitchInfo()
        oldOnDestroy(self)
    end

end

function LayMines:OnTag(tagName)
    
    PROFILE("LayMines:OnTag")
    
    ClipWeapon.OnTag(self, tagName)
    
    if tagName == "mine" then
        
        local player = self:GetParent()
        if player then
            
            self:PerformPrimaryAttack(player)
            
            if self.minesLeft == 0 then
                
                self:OnHolster(player)
                player:RemoveWeapon(self)
    
                if Server and self.hasSentry then
                    local newBuildSentry = player:GiveItem(BuildSentry.kMapName)
                    newBuildSentry.hasMine = false
                end
                
                player:SwitchWeapon(1)
                
                if Server then
                    DestroyEntity(self)
                end
            
            end
        
        end
        
        self.droppingMine = false
    
    end

end
Shared.LinkClassToMap("LayMines", LayMines.kMapName, networkVars)