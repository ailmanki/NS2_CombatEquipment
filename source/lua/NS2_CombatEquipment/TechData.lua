local oldBuildTechData = BuildTechData
function BuildTechData()
	local kTechData = oldBuildTechData()
	
	local tech = {}
	for k = 1, #kTechData do
		table.insert(tech, kTechData[k])
		
		if (kTechData[k][kTechDataId] == kTechId.DropExosuit) then
			table.insert(tech, {
				[kTechDataId] = kTechId.DropSentry,
				[kTechDataMapName] = BuildSentry.kMapName,
				[kTechDataDisplayName] = "Sentry",
				[kTechDataModel] = Sentry.kModelName,
				[kTechDataCostKey] = kCombatEquipmentSentryCost,
				[kStructureAttachId] = { kTechId.Armory, kTechId.AdvancedArmory },
			})
			
			table.insert(tech, {
				[kTechDataId] = kTechId.BuildSentry,
				[kTechDataMapName] = BuildSentry.kMapName,
				[kTechDataDisplayName] = "Sentry"
			})
			table.insert(tech, {
				[kTechDataId] = kTechId.DropSentryTech,
				[kTechDataCostKey] = kCombatEquipmentSentryResearchCost,
				[kTechDataResearchTimeKey] = kCombatEquipmentSentryResearchTime,
				[kTechDataDisplayName] = "Research AI sentry guns",
				[kTechDataTooltipInfo] = "Allows purchasing AI sentry guns from armories.",
				[kTechDataResearchName] = "Sentries"
			})
		end
	
	
	end
	return tech
end