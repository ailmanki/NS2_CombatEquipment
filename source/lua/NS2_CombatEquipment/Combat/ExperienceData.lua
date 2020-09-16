local upgrade = CombatMarineUpgrade()

--team, upgradeId, upgradeTextCode, upgradeDescription, upgradeTechId, upgradeFunc, requirements, levels, upgradeType, refundUpgrade, hardCap, mutuallyExclusive, needsNearComm)
local points = 1
upgrade:Initialize(kCombatUpgrades.Sentries, "sentries", "Sentry", kTechId.DropSentry, nil, kCombatUpgrades.Armor2, points, kCombatUpgradeTypes.Weapon, false, 0, nil)

table.insert(UpsList, upgrade)