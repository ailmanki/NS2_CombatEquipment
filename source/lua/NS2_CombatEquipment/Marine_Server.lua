
local oldAttemptToBuy = Marine.AttemptToBuy
function Marine:AttemptToBuy(techIds)
    local techId = techIds[1]
    
    local hostStructure = GetHostStructureFor(self, techId)

    
    if hostStructure then
    
        if techId == kTechId.DropSentry then
    
            local ownerId = self:GetId()
            for _, sentry in ientitylist( Shared.GetEntitiesWithClassname("Sentry") ) do
                --Print("ownerId: " .. sentry.ownerId .. ", clientId: " .. ownerId)
                if sentry.personal and sentry.ownerId == ownerId then
                    return false
                end
            end
    
        end
        
        
    end
    
    return oldAttemptToBuy(self, techIds)
    
    
end
