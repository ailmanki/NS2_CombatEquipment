
local oldInitTechTree = MarineTeam.InitTechTree
function MarineTeam:InitTechTree()
    local disable = function() end
    local oldPlayingTeamInitTechTree = PlayingTeam.InitTechTree
    
    PlayingTeam.InitTechTree(self)
    
    self.techTree:AddResearchNode(kTechId.DropSentryTech, kTechId.AdvancedArmory, kTechId.None)
    self.techTree:AddBuyNode(kTechId.DropSentry, kTechId.DropSentryTech, kTechId.None)
    
    PlayingTeam.InitTechTree = disable
    oldInitTechTree(self)
    PlayingTeam.InitTechTree = oldPlayingTeamInitTechTree
    
end