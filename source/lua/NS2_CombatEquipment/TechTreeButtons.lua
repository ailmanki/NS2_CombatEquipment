
local kTechIdSentry = {}

kTechIdSentry[kTechId.BuildSentry] = kTechId.Sentry
kTechIdSentry[kTechId.DropSentry] = kTechId.Sentry

-- GetMaterialXYOffset Code used from Nin's Hades Device https://steamcommunity.com/sharedfiles/filedetails/?id=873978863
local origGetMaterialXYOffset = GetMaterialXYOffset
function GetMaterialXYOffset(techId)
    if kTechIdSentry[techId] ~= nil then
        techId = kTechIdSentry[techId]
    end
    return origGetMaterialXYOffset(techId)
end