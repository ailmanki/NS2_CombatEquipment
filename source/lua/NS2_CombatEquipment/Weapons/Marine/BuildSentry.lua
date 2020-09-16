Script.Load("lua/Weapons/Weapon.lua")
--Script.Load("lua/PickupableWeaponMixin.lua")

class 'BuildSentry' (Weapon)

BuildSentry.kMapName = "buildsentry"

local kDropModelName = PrecacheAsset("models/marine/sentry/sentry.model")
--local kHeldModelName = PrecacheAsset("models/marine/sentry/sentry.model")
--local kAnimationGraph = PrecacheAsset("models/marine/mine/mine_view.animation_graph")

local kHeldModelName = PrecacheAsset("models/marine/welder/welder.model") --PrecacheAsset("models/marine/mine/mine_3p.model")
local kViewModelName = PrecacheAsset("models/marine/welder/welder_view.model") --PrecacheAsset("models/marine/mine/mine_view.model")
local kAnimationGraph = PrecacheAsset("models/marine/welder/welder_view.animation_graph") --PrecacheAsset("models/marine/mine/mine_view.animation_graph")

local kPlacementDistance = 2

local networkVars =
{
    droppingSentry = "boolean"
}

function BuildSentry:OnCreate()

    Weapon.OnCreate(self)
    
    InitMixin(self, PickupableWeaponMixin)
    
    self.droppingSentry = false
    
end

function BuildSentry:OnInitialized()

    Weapon.OnInitialized(self)
    
    self:SetModel(kHeldModelName)
    
end

function BuildSentry:GetIsValidRecipient(recipient)

    if self:GetParent() == nil and recipient and not GetIsVortexed(recipient) and recipient:isa("Marine") then
    
        local buildSentry = recipient:GetWeapon(BuildSentry.kMapName)
        return buildSentry == nil
        
    end
    
    return false
    
end

function BuildSentry:GetDropStructureId()
    return kTechId.Sentry
end

function BuildSentry:GetViewModelName()
    return kViewModelName
end

function BuildSentry:GetAnimationGraphName()
    return kAnimationGraph
end

function BuildSentry:GetSuffixName()
    return "sentry"
end

function BuildSentry:GetDropClassName()
    return "Sentry"
end

function BuildSentry:GetDropMapName()
    return Sentry.kMapName
end

function BuildSentry:GetHUDSlot()
    return 4
end

function BuildSentry:Build()

    local player = self:GetParent()
    if player then
    
        self:PerformPrimaryAttack(player)

        self:OnHolster(player)
        player:RemoveWeapon(self)
        player:SwitchWeapon(1)
            
        if Server then                
            DestroyEntity(self)
        end

    end
    
    self.droppingSentry = false
    
end

function BuildSentry:OnTag(tagName)
    
    ClipWeapon.OnTag(self, tagName)
    
    if tagName == "mine" then
        self:Build()        
    end
    
end

function BuildSentry:OnPrimaryAttackEnd()
    self.droppingSentry = false
end

function BuildSentry:GetIsDroppable()
    return true
end

function BuildSentry:OnPrimaryAttack(player)

    -- Ensure the current location is valid for placement.
    if not player:GetPrimaryAttackLastFrame() then
    
        local _, _, valid = self:GetPositionForStructure(player)
        if valid then
            self.droppingSentry = true
            self:Build()
        else
            self.droppingSentry = false
            
            if Client then
                player:TriggerInvalidSound()
            end
            
        end
        
    end
    
end

local function DropStructure(self, player)

    if Server then
    
        local _, coords, valid = self:GetPositionForStructure(player)
        if valid then
        
            -- Create mine.
            local mine = CreateEntity(self:GetDropMapName(), coords.origin, player:GetTeamNumber())
            if mine then
            
                mine:SetOwner(player)
                
                -- Check for space
                if mine:SpaceClearForEntity(coords.origin) then
                
                    local angles = Angles()
                    angles:BuildFromCoords(coords)
                    mine:SetAngles(angles)
                    
                    player:TriggerEffects("create_" .. self:GetSuffixName())
                    
                    -- Jackpot.
                    return true
                    
                else
                
                    player:TriggerInvalidSound()
                    DestroyEntity(mine)
                    
                end
                
            else
                player:TriggerInvalidSound()
            end
            
        else
        
            if not valid then
                player:TriggerInvalidSound()
            end
            
        end
        
    elseif Client then
        return true
    end
    
    return false
    
end

function BuildSentry:PerformPrimaryAttack(player)
    player:TriggerEffects("start_create_" .. self:GetSuffixName())

    local success = DropStructure(self, player)
            
    return success
    
end

function BuildSentry:OnHolster(player, previousWeaponMapName)

    Weapon.OnHolster(self, player, previousWeaponMapName)
    
    self.droppingSentry = false
    
end

function BuildSentry:OnDraw(player, previousWeaponMapName)

    Weapon.OnDraw(self, player, previousWeaponMapName)
    
    -- Attach weapon to parent's hand
    self:SetAttachPoint(Weapon.kHumanAttachPoint)
    
    self.droppingSentry = false
    
    self:SetModel(kHeldModelName)
    
end

function BuildSentry:Dropped(prevOwner)

    self.doNotDynamicServer = true
    Weapon.Dropped(self, prevOwner)
    
    self:SetModel(kDropModelName)
    
end

-- Given a gorge player's position and view angles, return a position and orientation
-- for structure. Used to preview placement via a ghost structure and then to create it.
-- Also returns bool if it's a valid position or not.
function BuildSentry:GetPositionForStructure(player)

    local isPositionValid = false
    local foundPositionInRange = false
    local structPosition

    local origin = player:GetEyePos() + player:GetViewAngles():GetCoords().zAxis * kPlacementDistance
    
    -- Trace short distance in front
    local trace = Shared.TraceRay(player:GetEyePos(), origin, CollisionRep.Default, PhysicsMask.AllButPCsAndRagdolls, EntityFilterTwo(player, self))
    
    local displayOrigin = trace.endPoint
    
    -- If we hit nothing, trace down to place on ground
    if trace.fraction == 1 then
    
        origin = player:GetEyePos() + player:GetViewAngles():GetCoords().zAxis * kPlacementDistance
        trace = Shared.TraceRay(origin, origin - Vector(0, kPlacementDistance, 0), CollisionRep.Default, PhysicsMask.AllButPCsAndRagdolls, EntityFilterTwo(player, self))
        
    end

    
    -- If it hits something, position on this surface (must be the world or another structure)
    if trace.fraction < 1 then
        
        foundPositionInRange = true
    
        if trace.entity == nil then
            isPositionValid = true
        elseif not trace.entity:isa("ScriptActor") and not trace.entity:isa("Clog") then
            isPositionValid = true
        end
        
        displayOrigin = trace.endPoint
        
        -- Can not be built on infestation
        if GetIsPointOnInfestation(displayOrigin) then
            isPositionValid = false
        end
    
        -- Don't allow dropped structures to go too close to techpoints and resource nozzles
        if GetPointBlocksAttachEntities(displayOrigin) then
            isPositionValid = false
        end
    
        -- Don't allow placing above or below us and don't draw either
        local structureFacing = player:GetViewAngles():GetCoords().zAxis
    
        if math.abs(Math.DotProduct(trace.normal, structureFacing)) > 0.9 then
            structureFacing = trace.normal:GetPerpendicular()
        end
    
        -- Coords.GetLookIn will prioritize the direction when constructing the coords,
        -- so make sure the facing direction is perpendicular to the normal so we get
        -- the correct y-axis.
        local perp = Math.CrossProduct(trace.normal, structureFacing)
        structureFacing = Math.CrossProduct(perp, trace.normal)
    
        structPosition = Coords.GetLookIn(displayOrigin, structureFacing, trace.normal)
        
    end
    
    return foundPositionInRange, structPosition, isPositionValid
    
end

function BuildSentry:GetGhostModelName()
    return LookupTechData(self:GetDropStructureId(), kTechDataModel)
end

function BuildSentry:OnUpdateAnimationInput(modelMixin)
    
    modelMixin:SetAnimationInput("activity", ConditionalValue(self.droppingSentry, "primary", "none"))
    
end

if Client then

    function BuildSentry:OnProcessIntermediate()
    
        local player = self:GetParent()
        
        if player then
        
            self.showGhost, self.ghostCoords, self.placementValid = self:GetPositionForStructure(player)
            
        end
        
    end
    
    function BuildSentry:GetUIDisplaySettings()
        return { xSize = 256, ySize = 417, script = "lua/GUIMineDisplay.lua" }
    end
    
end

function BuildSentry:GetShowGhostModel()
    return self.showGhost
end

function BuildSentry:GetGhostModelCoords()
    return self.ghostCoords
end   

function BuildSentry:GetIsPlacementValid()
    return self.placementValid
end

Shared.LinkClassToMap("BuildSentry", BuildSentry.kMapName, networkVars)
