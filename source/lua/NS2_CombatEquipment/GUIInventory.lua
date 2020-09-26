
local oldUpdate = GUIInventory.Update
function GUIInventory:Update(_, parameters)

    local activeWeaponTechId, inventoryTechIds = parameters[1], parameters[2]
    
    local wasForced = false
    if #self.inventoryIcons ~= #inventoryTechIds and not self.forceAnimationReset then
        self.forceAnimationReset = true
        wasForced = true
    end
    
    oldUpdate(self, _, parameters)
    
    if wasForced then
        self.forceAnimationReset = false
    end
    
end