Script.Load("lua/DigestMixin.lua")

Script.kMaxUseableRange = 6.5
local kDigestDuration = 1.5

function Sentry:GetDigestDuration()
    return kDigestDuration
end

function Sentry:GetUseMaxRange()
    return self.kMaxUseableRange
end
function Sentry:GetCanDigest(player)
    return player == self:GetOwner() and player:isa("Marine") and (not HasMixin(self, "Live") or self:GetIsAlive())
end

function Sentry:GetCanConsumeOverride()
    return false
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
end

-- CQ: Predates Mixins, somewhat hackish
function Sentry:GetCanBeUsed(player, useSuccessTable)
    useSuccessTable.useSuccess = useSuccessTable.useSuccess and self:GetCanDigest(player)
end

function Sentry:GetCanBeUsedConstructed()
    return true
end

if not Server then
    function Sentry:GetOwner()
        return self.ownerId ~= nil and Shared.GetEntity(self.ownerId)
    end
end

local sentry_onpudate = Sentry.OnUpdate
function Sentry:OnUpdate(deltaTime)

    self.attachedToBattery = true
    self.lastBatteryCheckTime = Shared.GetTime()
    
    sentry_onpudate(self, deltaTime)

end

function Sentry:OnUpdateAnimationInput(modelMixin)

    PROFILE("Sentry:OnUpdateAnimationInput")    
    modelMixin:SetAnimationInput("attack", self.attacking)
    modelMixin:SetAnimationInput("powered", true)
    
end


function Sentry:GetUnitNameOverride(viewer)
    
    local unitName = GetDisplayName(self)
    
    if not GetAreEnemies(self, viewer) and self.ownerId then
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

-- fixes blueprint leftover on comsume
local oldKill = Sentry.Kill
function Sentry:Kill()
    
    if self.GetIsGhostStructure and self:GetIsGhostStructure() then
        -- make it poof!
        self:SetHealth(0)
        self:OnTakeDamage(0)
        return
    end
    if oldKill then
        oldKill(self)
    end
end

local oldOnDestroy = Sentry.OnDestroy
function Sentry:OnDestroy()
    if Server then
        local player = self:GetOwner()
        if player and self.consumed and player:GetIsAlive() then
            player:GiveItem(BuildSentry.kMapName)
        end
    end
   
    oldOnDestroy(self)
end

local networkVars =
{
    ownerId = "entityid"
}

Shared.LinkClassToMap("Sentry", Sentry.kMapName, networkVars, true)
--Class_Reload("Sentry")