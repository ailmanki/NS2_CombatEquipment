if GUIMarineBuyMenu.kItemSlotForWeapon then
    GUIMarineBuyMenu.kItemSlotForWeapon["buildsentry"] = 4
end

local shieldTexture = PrecacheAsset("ui/ns2_combatequipment/sentry.dds")
local shieldBigIcon = PrecacheAsset("ui/ns2_combatequipment/sentry_bigicon.dds")
local smallIconHeight = 64
local smallIconWidth = 128
local bigIconWidth = 400
local bigIconHeight = 300

-- small override if combat is running
if kCombatVersion then
	shieldTexture = PrecacheAsset("ui/ns2_combatequipment/combat_sentry.dds")
	smallIconHeight = 80
	smallIconWidth = 80
end

local old_InitializeItemButtons = GUIMarineBuyMenu._InitializeItemButtons
function GUIMarineBuyMenu:_InitializeItemButtons()
    old_InitializeItemButtons(self)
    
    
    if self.itemButtons then
        for i, item in ipairs(self.itemButtons) do
            if item.TechId == kTechId.DropSentry then
                item.Button:SetTexture(shieldTexture)
                item.Button:SetTexturePixelCoordinates(0, 0, smallIconWidth, smallIconHeight)
            end
        end
    end
end

local old_UpdateContent = GUIMarineBuyMenu._UpdateContent
function GUIMarineBuyMenu:_UpdateContent(deltaTime)
    old_UpdateContent(self, deltaTime)
    local techId = self.hoverItem
    if not self.hoverItem then
        techId = self.selectedItem
    end
    if techId ~= nil and techId ~= kTechId.None and self.portrait then
        if techId == kTechId.DropSentry then
            self.portrait:SetTexture(shieldBigIcon)
            self.portrait:SetTexturePixelCoordinates(0, 0, bigIconWidth, bigIconHeight)
        else
            self.portrait:SetTexture(GUIMarineBuyMenu.kBigIconTexture)
        end
    end
end