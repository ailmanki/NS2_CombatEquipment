
local oldInitTechTree = MarineTeam.InitTechTree
function MarineTeam:InitTechTree()
    local disable = function() end
    local oldPlayingTeamInitTechTree = PlayingTeam.InitTechTree
    
    PlayingTeam.InitTechTree(self)
    
    self.techTree:AddBuyNode(kTechId.DropSentry, kTechId.None, kTechId.None)
    
    PlayingTeam.InitTechTree = disable
    oldInitTechTree(self)
    PlayingTeam.InitTechTree = oldPlayingTeamInitTechTree
    
end