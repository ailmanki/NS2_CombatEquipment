
local grenadeResupplyTime = 15
local mineResupplyTime = 15

local function ShouldResupplyGrenade(player)

    if not player:GetIsAlive() then
        return false
    end
	
	local grenadeSlotWeapon = player:GetWeaponInHUDSlot(GrenadeThrower.GetHUDSlot())
	return not grenadeSlotWeapon and (not player._lastGrenade or player._lastGrenade + grenadeResupplyTime < Shared.GetTime())
end

local function ShouldResupplyMine(player)

    if not player:GetIsAlive() then
        return false
    end
	
	local mineSlotWeapon = player:GetWeaponInHUDSlot(LayMines.GetHUDSlot())
	if mineSlotWeapon and mineSlotWeapon.kMapName == BuildSentry.kMapName  then
		mineSlotWeapon = false
	end
	return not mineSlotWeapon and (not player._lastMine or player._lastMine + mineResupplyTime < Shared.GetTime())
end


local oldResupply = Armory.ResupplyPlayer
function Armory:ResupplyPlayer(player)
	oldResupply(self, player)
	local gaveGrenade = false
	local gaveMine = false
	if ShouldResupplyGrenade(player) then
	
		if player:GetHasCombatUpgrade(kCombatUpgrades.ClusterGrenade) then
			player:GiveItem(ClusterGrenadeThrower.kMapName)
			gaveGrenade = true
		elseif player:GetHasCombatUpgrade(kCombatUpgrades.PulseGrenade) then
			player:GiveItem(PulseGrenadeThrower.kMapName)
			gaveGrenade = true
		elseif player:GetHasCombatUpgrade(kCombatUpgrades.GasGrenade) then
			player:GiveItem(GasGrenadeThrower.kMapName)
			gaveGrenade = true
		end
		
	end
	
	if gaveGrenade then
		player._lastGrenade = Shared.GetTime()
	end
	
	if ShouldResupplyMine(player) then
	
		if player:GetHasCombatUpgrade(kCombatUpgrades.Mines) then
			player:GiveItem(LayMines.kMapName)
			gaveMine = true
			player._lastMine = Shared.GetTime()
		end
		
	end
	
	if gaveGrenade or gaveMine then
		self:TriggerEffects("armory_ammo", {effecthostcoords = Coords.GetTranslation(player:GetOrigin())})
	end
end

local oldGetShouldResupplyPlayer = Armory.GetShouldResupplyPlayer
function Armory:GetShouldResupplyPlayer(player)
	local shouldResupply = oldGetShouldResupplyPlayer(self, player)
	if not shouldResupply then
	
		if ShouldResupplyGrenade(player) then
		
			if player:GetHasCombatUpgrade(kCombatUpgrades.ClusterGrenade) or
			   player:GetHasCombatUpgrade(kCombatUpgrades.PulseGrenade) or
			   player:GetHasCombatUpgrade(kCombatUpgrades.GasGrenade) then
				shouldResupply = true
			end
			
		end
		
		if ShouldResupplyMine(player) then
		
			if player:GetHasCombatUpgrade(kCombatUpgrades.Mines) then
				shouldResupply = true
			end
			
		end
	end
	
	return shouldResupply
end