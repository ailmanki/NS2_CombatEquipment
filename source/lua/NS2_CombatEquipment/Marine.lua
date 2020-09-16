if Client then

    function Marine:UpdateGhostModel()

        self.currentTechId = nil
        self.ghostStructureCoords = nil
        self.ghostStructureValid = false
        self.showGhostModel = false

        local weapon = self:GetActiveWeapon()

        if weapon and (weapon:isa("LayMines") or weapon:isa("BuildSentry")) then

            self.currentTechId = weapon:GetDropStructureId()
            self.ghostStructureCoords = weapon:GetGhostModelCoords()
            self.ghostStructureValid = weapon:GetIsPlacementValid()
            self.showGhostModel = weapon:GetShowGhostModel()
        end

    end

    function Marine:GetShowGhostModel()
        return self.showGhostModel
    end    

    function Marine:GetGhostModelTechId()
        return self.currentTechId
    end

    function Marine:GetGhostModelCoords()
        return self.ghostStructureCoords
    end

    function Marine:GetIsPlacementValid()
        return self.ghostStructureValid
    end

end

Class_Reload("Marine")