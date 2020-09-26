
class 'GUISwitchInfo' (GUIAnimatedScript)

GUISwitchInfo.kBaseYResolution = 1200
local kFontName = Fonts.kAgencyFB_Small
function GUISwitchInfo:Initialize()
    GUIAnimatedScript.Initialize(self)
    self.switchName = "mine"
    self.scale = Client.GetScreenHeight() / GUISwitchInfo.kBaseYResolution
    self.background = self:CreateAnimatedGraphicItem()
    self.background:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.background:SetColor(Color(0,0,0,0))    
    self:Reset()
end
function GUISwitchInfo:Uninitialize()
    
    GUIAnimatedScript.Uninitialize(self)

end
function GUISwitchInfo:GetIsVisible()
    return self.background:GetIsVisible()
end
function GUISwitchInfo:SetIsVisible(isVisible)
    self.background:SetIsVisible(isVisible == true)
end
function GUISwitchInfo:OnResolutionChanged(oldX, oldY, newX, newY)

    self:Uninitialize()
    self:Initialize()

end
function GUISwitchInfo:SetSwitchName(name)
    self.switchName = name
    self:UpdateDescription()
end
function GUISwitchInfo:UpdateDescription()
    self.description:SetText("Right-click to switch to " .. self.switchName)
end
function GUISwitchInfo:Reset()
    
    self.background:SetUniformScale(self.scale)
    self.description = self:CreateAnimatedTextItem()
    self.description:SetUniformScale(self.scale) 
    self.description:SetAnchor(GUIItem.Middle, GUIItem.Top)
    self.description:SetTextAlignmentX(GUIItem.Align_Center)
    self.description:SetTextAlignmentY(GUIItem.Align_Center)
    self.description:SetScale(GetScaledVector())
    self.description:SetFontName(kFontName)
    GUIMakeFontScale(self.description)
    self.description:SetPosition(Vector(0, 128, 0))
    self.description:SetFontIsBold(true)
    self.background:AddChild(self.description)
    
    
    self:UpdateDescription()
    
end