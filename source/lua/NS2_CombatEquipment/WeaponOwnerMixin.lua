local oldAddWeapon = WeaponOwnerMixin.AddWeapon
function WeaponOwnerMixin:AddWeapon(weapon, setActive)
	
	assert(weapon:GetParent() ~= self)
	
	local hudSlot = weapon:GetHUDSlot()
	if 4 == hudSlot then
		local hasWeapon = self:GetWeaponInHUDSlot(hudSlot)
		if hasWeapon then
			local removeOld = false
			--Print("kMapName: " .. hasWeapon.kMapName)
			if hasWeapon.kMapName == BuildSentry.kMapName then
				--Print("techid: BuildSentry")
				if weapon.kMapName == LayMines.kMapName then
					removeOld = true
				end
				weapon.hasSentry = true
			end
			
			if hasWeapon.kMapName == LayMines.kMapName then
				--Print("techid: LayMines")
				if weapon.kMapName == BuildSentry.kMapName then
					removeOld = true
				end
				weapon.hasMine = true
			end
			if removeOld then
				self:RemoveWeapon(hasWeapon)
				DestroyEntity(hasWeapon)
			end
		end
	end
	
	return oldAddWeapon(self, weapon, setActive)

end