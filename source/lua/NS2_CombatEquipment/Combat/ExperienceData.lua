local upgrade = CombatMarineUpgrade()

--team, upgradeId, upgradeTextCode, upgradeDescription, upgradeTechId, upgradeFunc, requirements, levels, upgradeType, refundUpgrade, hardCap, mutuallyExclusive, needsNearComm)
local points = 2
upgrade:Initialize(kCombatUpgrades.Sentries, "sentries", "Sentry", kTechId.DropSentry, nil, kCombatUpgrades.Welder, points, kCombatUpgradeTypes.Weapon, false, 1/3,  nil)

table.insert(UpsList, upgrade)