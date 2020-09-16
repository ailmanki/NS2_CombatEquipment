local oldBuildTechData = BuildTechData
function BuildTechData()
    local kTechData = oldBuildTechData()
    
    local tech = {}
    for k=1, #kTechData do
        table.insert(tech, kTechData[k])
        
        if (kTechData[k][kTechDataId] == kTechId.DropExosuit) then
            table.insert(tech, {
                [kTechDataId] = kTechId.DropSentry,
                [kTechDataMapName] = BuildSentry.kMapName,
                [kTechDataDisplayName] = "Sentry",
                [kTechDataModel] = Sentry.kModelName
            })
            
            table.insert(tech, {
                [kTechDataId] = kTechId.BuildSentry,
                [kTechDataMapName] = BuildSentry.kMapName,
                [kTechDataDisplayName] = "Sentry"
            })
        end
    
    end
    return tech
end