Script.Load("lua/DigestMixin.lua")
Script.Load("lua/LaserMixin.lua")


---- Balance
--Sentry.kPingInterval = 4
---- kFov 160 default
if kCombatVersion then
    Sentry.kFov = 180
end
--Sentry.kMaxPitch = 80 -- 160 total
--Sentry.kMaxYaw = Sentry.kFov / 2
--Sentry.kTargetScanDelay = 1.5

--Sentry.kBaseROF = kSentryAttackBaseROF
--Sentry.kRandROF = kSentryAttackRandROF
--Sentry.kSpread = Math.Radians(3)
--Sentry.kBulletsPerSalvo = kSentryAttackBulletsPerSalvo
--Sentry.kBarrelScanRate = 60      -- Degrees per second to scan back and forth with no target
--Sentry.kBarrelMoveRate = 150    -- Degrees per second to move sentry orientation towards target or back to flat when targeted
--Sentry.kBarrelMoveTargetMult = 4 -- when a target is acquired, how fast to swivel the barrel
---- kRange 20 default
if kCombatVersion then
    Sentry.kRange = 30
end
--Sentry.kReorientSpeed = .05

--Sentry.kTargetAcquireTime = 0.15
--Sentry.kConfuseDuration = 4
--Sentry.kAttackEffectIntervall = 0.2
--Sentry.kConfusedAttackEffectInterval = kConfusedSentryBaseROF
-- balance end

Sentry.kMaxUseableRange = 6.5


local networkVars =
{
    ownerId = "entityid",
    personal = "boolean"
}

AddMixinNetworkVars(LaserMixin, networkVars)
local kDigestDuration = 1.5

function Sentry:GetDigestDuration()
    return kDigestDuration
end

function Sentry:GetUseMaxRange()
    return self.kMaxUseableRange
end

function Sentry:GetCanDigest(player)
    return self.personal and player == self:GetOwner() and player:isa("Marine") and (not HasMixin(self, "Live") or self:GetIsAlive())
end

function Sentry:GetCanConsumeOverride()
    return false
end

local oldOnInitialized = Sentry.OnInitialized
function Sentry:OnInitialized()
    oldOnInitialized(self)
    
    InitMixin(self, LaserMixin)
end

-- Called by ConstructMixing:OnUse
function Sentry:GetCanConstruct(player)
    if self.GetCanConstructOverride then
        return self:GetCanConstructOverride(player)
    end
    
    -- Check if we're on infestation
    -- Doing the origin-based check may be expensive, but this is only done sparsely. And better than tracking infestation all the time.
    if LookupTechData(self:GetTechId(), kTechDataNotOnInfestation) and GetIsPointOnInfestation(self:GetOrigin()) then
        return false
    end
    
    local activeWeapon = player:GetActiveWeapon()
    
    return not self:GetIsBuilt() and GetAreFriends(self, player) and self:GetIsAlive() and
            (not player or player:isa("Marine") or player:isa("MAC")) and activeWeapon and activeWeapon:GetMapName() == Welder.kMapName
end

local oldOnCreate = Sentry.OnCreate
function Sentry:OnCreate()
    oldOnCreate(self)
    InitMixin(self, DigestMixin)
    self.personal = false
end

function Sentry:Personal()
    self.isGhostStructure = false
    self.personal = true
end

local oldSetLagCompensated = Sentry.SetLagCompensated
function Sentry:SetLagCompensated(compensate)
    oldSetLagCompensated(self, true)
end

-- CQ: Predates Mixins, somewhat hackish
function Sentry:GetCanBeUsed(player, useSuccessTable)
    useSuccessTable.useSuccess = useSuccessTable.useSuccess and self:GetCanDigest(player)
end

function Sentry:GetCanBeUsedConstructed()
    return self.personal
end

if not Server then
    function Sentry:GetOwner()
        return self.personal and self.ownerId ~= nil and Shared.GetEntity(self.ownerId)
    end
end

local sentry_onpudate = Sentry.OnUpdate
function Sentry:OnUpdate(deltaTime)

    if self.personal then
     self.attachedToBattery = true
     self.lastBatteryCheckTime = Shared.GetTime()
    end
    sentry_onpudate(self, deltaTime)

end

function Sentry:OnUpdateAnimationInput(modelMixin)

    PROFILE("Sentry:OnUpdateAnimationInput")    
    modelMixin:SetAnimationInput("attack", self.attacking)
    modelMixin:SetAnimationInput("powered", true)
    
end

function Sentry:GetCanRecycleOverride()
    return self.personal == false -- and Shared.GetEntity(self.ownerId)
end

function Sentry:GetUnitNameOverride(viewer)
    
    local unitName = GetDisplayName(self)
    
    if self.personal and not GetAreEnemies(self, viewer) and self.ownerId then
        local ownerName
        for _, playerInfo in ientitylist(Shared.GetEntitiesWithClassname("PlayerInfoEntity")) do
            if playerInfo.playerId == self.ownerId then
                ownerName = playerInfo.playerName
                break
            end
        end
        if ownerName then
            
            local lastLetter = ownerName:sub(-1)
            if lastLetter == "s" or lastLetter == "S" then
                return string.format( "%s' Sentry", ownerName )
            else
                return string.format( "%s's Sentry", ownerName )
            end
        end
    
    end
    
    return unitName

end

--- we skip blueprint
-- fixes blueprint leftover on comsume
--local oldKill = Sentry.Kill
--function Sentry:Kill()
--
--    if self.GetIsGhostStructure and self:GetIsGhostStructure() then
--        -- make it poof!
--        self:SetHealth(0)
--        self:OnTakeDamage(0)
--        return
--    end
--    if oldKill then
--        oldKill(self)
--    end
--end

if kCombatVersion then
    function Sentry:ComputeDamageOverride(attacker, damage, damageType, hitPoint)
        
        -- Lerk spikes do double damage to mines.
        if (damageType == kDamageType.Puncture and attacker:isa("Lerk")) or (damageType == kDamageType.Corrode and attacker:isa("Gorge"))  then
            damage = damage * 0.5
        end
        
        return damage
    
    end
end
local oldOnDestroy = Sentry.OnDestroy
function Sentry:OnDestroy()
    if self.personal and Server then
        local player = self:GetOwner()
        if player and player:GetIsAlive() then
            local activeWeapon
            if not self.consumed then
                activeWeapon = player:GetActiveWeapon()
            end
            
            player:GiveItem(BuildSentry.kMapName)
            
            if activeWeapon and activeWeapon:GetMapName() then
                player:SetActiveWeapon(activeWeapon:GetMapName())
            end
        end
    end
   
    oldOnDestroy(self)
end

function GetCheckSentryLimit(techId, origin, normal, commander)
    
    -- Prevent the case where a Sentry in one room is being placed next to a
    -- SentryBattery in another room.
    local battery = GetSentryBatteryInRoom(origin)
    if battery then
        
        if (battery:GetOrigin() - origin):GetLength() > SentryBattery.kRange then
            return false
        end
    
    else
        return false
    end
    
    local location = GetLocationForPoint(origin)
    local locationName = location and location:GetName() or nil
    local numInRoom = 0
    local validRoom = false
    
    if locationName then
        
        validRoom = true
        
        for index, sentry in ientitylist(Shared.GetEntitiesWithClassname("Sentry")) do
            
            if false == sentry.personal and sentry:GetLocationName() == locationName then
                numInRoom = numInRoom + 1
            end
        
        end
    
    end
    
    return validRoom and numInRoom < kSentriesPerBattery

end

Shared.LinkClassToMap("Sentry", Sentry.kMapName, networkVars, true)
--Class_Reload("Sentry")