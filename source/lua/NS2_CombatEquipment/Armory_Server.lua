
local sentryResupplyTime = 15


local function ShouldResupplySentry(player)
	
	if not player:GetIsAlive() then
		return false
	end
	
	local sentrySlotWeapon = player:GetWeaponInHUDSlot(BuildSentry.GetHUDSlot())
	return not sentrySlotWeapon and (not player._lastSentry or player._lastSentry + sentryResupplyTime < Shared.GetTime())
end


local oldResupply = Armory.ResupplyPlayer
function Armory:ResupplyPlayer(player)
	oldResupply(self, player)
	local gaveSentry = false
	
	if ShouldResupplySentry(player) then
		
		if player:GetHasCombatUpgrade(kCombatUpgrades.Sentries) then
			
			player:GiveItem(BuildSentry.kMapName)
			gaveSentry = true
			player._lastSentry = Shared.GetTime()
		end
	
	end
	
	if gaveSentry then
		self:TriggerEffects("armory_ammo", {effecthostcoords = Coords.GetTranslation(player:GetOrigin())})
	end
end

local oldGetShouldResupplyPlayer = Armory.GetShouldResupplyPlayer
function Armory:GetShouldResupplyPlayer(player)
	local shouldResupply = oldGetShouldResupplyPlayer(self, player)
	if not shouldResupply then
		
		if ShouldResupplySentry(player) then
			
			if player:GetHasCombatUpgrade(kCombatUpgrades.Sentries) then
				shouldResupply = true
				
				local ownerId = player:GetId()
				for _, sentry in ientitylist( Shared.GetEntitiesWithClassname("Sentry") ) do
					--Print("ownerId: " .. sentry.ownerId .. ", clientId: " .. ownerId)
					if sentry.ownerId == ownerId then
						shouldResupply = false
						break
					end
				end
			end
		
		end
	end
	
	return shouldResupply
end