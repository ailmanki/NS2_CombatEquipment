

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
    
        local items = GetChildEntities(player, "ScriptActor")
    
        for _, item in ipairs(items) do
        
            local techId = item:GetTechId()
            if techId == kTechId.DropSentry then
                inventory[kTechId.DropSentry] = true
                if item.hasMine then
                    inventory[kTechId.LayMines] = true
                end
            elseif techId == kTechId.LayMines and item.hasSentry then
                inventory[kTechId.DropSentry] = true
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
            if item.hasMine then
                table.insertunique(equipped, kTechId.LayMines)
            end
        elseif techId == kTechId.LayMines and item.hasSentry then
            table.insertunique(equipped, kTechId.DropSentry)
        end
    
    end
    
    return equipped

end