local oldAddWeapon = WeaponOwnerMixin.AddWeapon
function WeaponOwnerMixin:AddWeapon(weapon, setActive)
	
	assert(weapon:GetParent() ~= self)
	
	local hudSlot = weapon:GetHUDSlot()
	if 4 == hudSlot then
		local hasWeapon = self:GetWeaponInHUDSlot(hudSlot)
		if hasWeapon then
			--Print("kMapName: " .. hasWeapon.kMapName)
			if hasWeapon.kMapName == BuildSentry.kMapName then
				--Print("techid: BuildSentry")
				weapon.hasSentry = true
			end
			
			if hasWeapon.kMapName == LayMines.kMapName then
				--Print("techid: LayMines")
				weapon.hasMine = true
			end
			if kCombatVersion then
				self:RemoveWeapon(hasWeapon)
				DestroyEntity(hasWeapon)
			end
		end
	end
	
	return oldAddWeapon(self, weapon, setActive)

end