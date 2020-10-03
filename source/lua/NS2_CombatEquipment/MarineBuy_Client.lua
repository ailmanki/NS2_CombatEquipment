

local oldMarineBuy_GetWeaponDescription = MarineBuy_GetWeaponDescription
function MarineBuy_GetWeaponDescription(techId)
    if techId ~= kTechId.DropSentry then
        return oldMarineBuy_GetWeaponDescription(techId)
    end
    
    local description = "Requires a welder to build! The AI sentry gun targets and fires automatically upon any aliens in its line of sight."

    local techTree = GetTechTree()
    
    local requires = techTree:GetRequiresText(techId)

    if requires ~= "" then
        description = string.format(Locale.ResolveString("WEAPON_DESC_REQUIREMENTS"), requires:lower(), description)
    end

    
    return description
    
end

local oldMarineBuy_GetEquipment = MarineBuy_GetEquipment
function MarineBuy_GetEquipment()

    local inventory = oldMarineBuy_GetEquipment()

    local player = Client.GetLocalPlayer()
    
    if player then
        local ownerId = player:GetId()
        for _, sentry in ientitylist( Shared.GetEntitiesWithClassname("Sentry") ) do
            --Print("ownerId: " .. sentry.ownerId .. ", clientId: " .. ownerId)
            if sentry.personal and sentry.ownerId == ownerId then
                inventory[kTechId.DropSentry] = true
                break
            end
        end
        
    end

    return inventory

end

local oldMarineBuy_GetEquipped = MarineBuy_GetEquipped
function MarineBuy_GetEquipped()

    local equipped = oldMarineBuy_GetEquipped()

    local player = Client.GetLocalPlayer()
    
    local items = GetChildEntities(player, "ScriptActor")
    
    for _, item in ipairs(items) do
        
        local techId = item:GetTechId()
        if techId == kTechId.DropSentry then
            table.insertunique(equipped, kTechId.DropSentry)
    
            return equipped
        end
    
    end
    
    if player then
        local ownerId = player:GetId()
        for _, sentry in ientitylist( Shared.GetEntitiesWithClassname("Sentry") ) do
            --Print("ownerId: " .. sentry.ownerId .. ", clientId: " .. ownerId)
            if sentry.personal and sentry.ownerId == ownerId then
                table.insertunique(equipped, kTechId.DropSentry)
                break
            end
        end
    
    end

    return equipped

end