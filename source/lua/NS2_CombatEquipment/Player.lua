function Player:GetWeaponClip()

    --We could do some checks to make sure we have a non-nil ClipWeapon,
    --but this should never be called unless we do.
    local weapon = self:GetActiveWeapon()
    
    if weapon then
        if weapon:isa("ClipWeapon") then
            return weapon:GetClip()
        elseif weapon:isa("LayMines") then
            return weapon:GetMinesLeft()
        elseif weapon:isa("BuildSentry") then
            return 1
        end
    end
    
    return 0

end