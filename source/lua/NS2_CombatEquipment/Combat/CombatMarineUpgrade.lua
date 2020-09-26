local oldCombatMarineUpgrade = CombatMarineUpgrade.TeamSpecificLogic
function CombatMarineUpgrade:TeamSpecificLogic(player)
	
	local techId = self:GetTechId()
	local kMapName = LookupTechData(techId, kTechDataMapName)
	if kMapName == BuildSentry.kMapName then
		-- Apply weapons upgrades to a marine.
		if (player:GetIsAlive() and self:GetType() == kCombatUpgradeTypes.Weapon) then
			--Player.InitWeapons(player)
			if player:isa("Exo") then
				--
				--local newWeapon = CreateEntity(kMapName, player:GetEyePos(), player:GetTeamNumber(), nil, false)
				--
				---- if this is a primary weapon, destroy the old primary
				--if player.storedWeaponsIds then
				--
				--	-- MUST iterate backwards, as "DestroyEntity()" causes the ids to be removed as they're hit.
				--	for i=#player.storedWeaponsIds, 1, -1 do
				--		local weaponId = player.storedWeaponsIds[i]
				--		local oldWeapon = Shared.GetEntity(weaponId)
				--		if oldWeapon and oldWeapon.GetHUDSlot and oldWeapon:GetHUDSlot() == newWeapon:GetHUDSlot() then
				--			DestroyEntity(oldWeapon)
				--		end
				--	end
				--
				--end
				--
				--
				--player:StoreWeapon(newWeapon)
				return oldCombatMarineUpgrade(self, player)
			
			else
				-- if this is a primary weapon, destroy the old one.
				--local weapon = player:GetWeaponInHUDSlot(BuildSentry:GetHUDSlot())
				--if (weapon) then
				--	player:RemoveWeapon(weapon)
				--	DestroyEntity(weapon)
				--	self:GiveItem(player)
				--else
					local ownerId = player:GetId()
					local shouldResupply = true
					for _, sentry in ientitylist( Shared.GetEntitiesWithClassname("Sentry") ) do
						--Print("ownerId: " .. sentry.ownerId .. ", clientId: " .. ownerId)
						if sentry.ownerId == ownerId then
							shouldResupply = false
							break
						end
					end
					if shouldResupply then
						self:GiveItem(player)
					end
				--end
				return true
			end
		end
	else
		return oldCombatMarineUpgrade(self, player)
	end
	
end