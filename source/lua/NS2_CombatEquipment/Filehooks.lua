
ModLoader.SetupFileHook( "lua/TechTreeConstants.lua", 	"lua/NS2_CombatEquipment/TechTreeConstants.lua", "post" )
ModLoader.SetupFileHook( "lua/TechData.lua", 			"lua/NS2_CombatEquipment/TechData.lua", "post" )

--ModLoader.SetupFileHook( "lua/GUIActionIcon.lua", 	"lua/NS2_CombatEquipment/GUIActionIcon.lua", "replace" )
ModLoader.SetupFileHook( "lua/GUIMarineBuyMenu.lua", 	"lua/NS2_CombatEquipment/GUIMarineBuyMenu.lua", "post" )
ModLoader.SetupFileHook( "lua/Player.lua", 	"lua/NS2_CombatEquipment/Player.lua", "post" )

ModLoader.SetupFileHook( "lua/TechTreeButtons.lua", 	"lua/NS2_CombatEquipment/TechTreeButtons.lua", "post" )
ModLoader.SetupFileHook( "lua/MarineActionFinderMixin.lua", "lua/NS2_CombatEquipment/MarineActionFinderMixin.lua", "post" )
ModLoader.SetupFileHook( "lua/MarineTeam.lua", "lua/NS2_CombatEquipment/MarineTeam.lua", "post" )
ModLoader.SetupFileHook( "lua/Armory_Server.lua", "lua/NS2_CombatEquipment/Armory_Server.lua", "post" )


ModLoader.SetupFileHook( "lua/Balance.lua",				"lua/NS2_CombatEquipment/Balance.lua", "post" )
ModLoader.SetupFileHook( "lua/Combat/Globals.lua","lua/NS2_CombatEquipment/BalanceCombat.lua", "post" )
ModLoader.SetupFileHook( "lua/Combat/FileHooks/Post/Armory_Server.lua","lua/NS2_CombatEquipment/Combat/Armory_Server.lua", "replace" )

-- On certain "reset" event destroy structures from the player
ModLoader.SetupFileHook( "lua/Combat/Player_Upgrades.lua","lua/NS2_CombatEquipment/Combat/Player_Upgrades.lua", "post" )

-- add sentry to combat!
ModLoader.SetupFileHook( "lua/Combat/CombatMarineUpgrade.lua", "lua/NS2_CombatEquipment/Combat/CombatMarineUpgrade.lua", "post" )
ModLoader.SetupFileHook( "lua/Combat/ExperienceData.lua", "lua/NS2_CombatEquipment/Combat/ExperienceData.lua", "post" )
ModLoader.SetupFileHook( "lua/Combat/ExperienceEnums.lua", "lua/NS2_CombatEquipment/Combat/ExperienceEnums.lua", "post" )
ModLoader.SetupFileHook( "lua/Combat/MarineBuyFuncs.lua", "lua/NS2_CombatEquipment/Combat/MarineBuyFuncs.lua", "post" )


ModLoader.SetupFileHook( "lua/Hud/GUIInventory.lua", "lua/NS2_CombatEquipment/GUIInventory.lua", "post" )
ModLoader.SetupFileHook( "lua/Weapons/Marine/LayMines.lua", "lua/NS2_CombatEquipment/Weapons/Marine/LayMines.lua", "post" )
ModLoader.SetupFileHook( "lua/WeaponOwnerMixin.lua", "lua/NS2_CombatEquipment/WeaponOwnerMixin.lua", "post" )
