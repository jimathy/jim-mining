Config = {}

Config = {
	Blips = true, -- Enable Blips?
	BlipNamer = false, -- Enable to Name Blips different things, disable if you already have too many blips as this will group them together
	PropSpawn = true, -- Enable Ore Props
	Pedspawn = true, -- Do you want to spawn peds for main locations?
	Invincible = true, --Do you want the peds to be invincible?
	Frozen = true, --Do you want the peds to be unable to move? It's probably a yes, so leave true in there.
	Stoic = true, --Do you want the peds to react to what is happening in their surroundings?
	Fade = true, -- Do you want the peds to fade into/out of existence? It looks better than just *POP* its there.
	Distance = 40.0, --The distance you want peds to spawn at
}

--Config.Pedspawn = false
--Blips and Locations
-- Each one has individual blip enablers
-- Mine and Mine Leave have headings for the player locations
Config.Locations =  {
	['Mine'] = { name = "Mine", location = vector3(-595.15,2091.23,131.46-1.03), heading = 61.59, blipTrue = true }, -- The location where you enter the mine 
	['Smelter'] = {	name = "Smelter", location = vector3(1112.29, -2009.9, 31.46), blipTrue = true }, -- The location of the smelter
	['Cracking'] = { name = "Stone Cracking", location = vector3(1109.27,-1992.68,30.99-1.03), heading = 305.0-180.0, blipTrue = false }, -- The location of the smelter
	['Buyer'] = { name = "Ore Buyer", location = vector3(1085.7,-2001.04,31.41-1.03), heading = 323.73, blipTrue = false }, -- The Location of the ore buyer
	['JewelCut'] = { name = "Jewel Cutting", location = vector3(1077.24, -1984.22, 31.0-0.97), heading = 300.0, blipTrue = false }, -- The Location of the jewel buyer, most likely leave this as Vangelico Jeweler
	['Buyer2'] = { name = "Jewel Buyer", location = vector3(-629.85, -240.31, 38.16-1.03), heading = 105.74, blipTrue = false }, -- The Location of the jewel buyer, most likely leave this as Vangelico Jeweler
}

------------------------------------------------------------
--Ores and Props

Config.OrePositions = {
	{ coords = vector3(-587.05, 2059.08, 129.75), },
	{ coords = vector3(-588.49, 2048.05, 129.95-1.0), },
	{ coords = vector3(-580.10, 2037.82, 128.8-1.0), },
	{ coords = vector3(-572.28, 2022.37, 127.93-1.0), },
}

-----------------------------------------------------------
--Mining rewards stone
Config.MineReward = { "stone" }

Config.RewardPool = {
	'carbon', 'carbon', 'carbon', 'carbon', --4x
	'copperore', 'copperore', 'copperore', 'copperore', 'copperore', 'copperore', -- 6x
	'goldore', 'goldore', 'goldore', --'goldore', -- 3x
	'ironore', 'ironore', 'ironore', 'ironore', -- 'ironore', 'ironore', -- 6x
    'metalscrap',
	'uncut_ruby',
	'uncut_emerald',
	'uncut_diamond',
}
------------------------------------------------------------
Config.SellItems = { -- Not working on yet
	['copperore'] = 100,
	['goldore'] = 100,
	['ironore'] = 100,
	['carbon'] = 100,
	
	['goldbar'] = 100,
	
	['uncut_emerald'] = 100,
	['uncut_ruby'] = 100,
	['uncut_diamond'] = 100,
	
	['emerald'] = 100,
	['ruby'] = 100,
	['diamond'] = 100,
	
	['diamond_ring'] = 100,
	['gold_ring'] = 100,
	['goldchain'] = 100,
	['10kgoldchain'] = 100,

}
------------------------------------------------------------
-- Ped Spawning Variables
Config.Pedspawn = true -- Do you want to spawn peds for main locations?

Config.Invincible = true --Do you want the peds to be invincible?
Config.Frozen = true --Do you want the peds to be unable to move? It's probably a yes, so leave true in there.
Config.Stoic = true --Do you want the peds to react to what is happening in their surroundings?
Config.Fade = true -- Do you want the peds to fade into/out of existence? It looks better than just *POP* its there.
Config.Distance = 40.0 --The distance you want peds to spawn at

Config.PedList = { -- APPARENTLY You can call config locations IN the config, learn't that one today
	{ model = "S_M_Y_Construct_01", coords = Config.Locations['Mine'].location, heading = Config.Locations['Mine'].heading, gender = "male", scenario = "WORLD_HUMAN_CLIPBOARD", }, -- Outside Mine
	{ model = "S_M_Y_Construct_01", coords = Config.Locations['Buyer'].location, heading = Config.Locations['Buyer'].heading, gender = "male", scenario = "WORLD_HUMAN_CLIPBOARD", }, -- Ore Buyer
	{ model = "S_M_M_HighSec_03", coords = Config.Locations['Buyer2'].location, heading = Config.Locations['Buyer2'].heading, gender = "male", scenario = "WORLD_HUMAN_CLIPBOARD", }, -- Jewel Buyer
}

------------------------------------------------------------
--Added mine lighting for my first world NVE problems
--Don't always light up...
Config.MineLights = {
	{ coords = vector3(-594.30, 2082.89, 131.40+1.73), },
	{ coords = vector3(-591.85, 2073.95, 131.35+1.73), },
	{ coords = vector3(-589.98, 2066.16, 131.02+1.73), },
	{ coords = vector3(-587.83, 2052.98, 130.21+1.73), },
	{ coords = vector3(-583.94, 2041.11, 129.11+1.73), },
	{ coords = vector3(-577.49, 2030.93, 128.24+1.73), },
	{ coords = vector3(-567.83, 2020.27, 127.58+1.73), },
}

------------------------------------------------------------
--Mining Store Items
Config.Items = {
    label = "Mining Store",  slots = 4,
    items = {
	[1] = { name = "water_bottle",
			price = 0, amount = 100,
			info = {}, type = "item",
			slot = 1, },
	[2] = { name = "sandwich",
			price = 0, amount = 250,
			info = {}, type = "item",
			slot = 2, },
	[3] = { name = "bandage",
			price = 0, amount = 100,
			info = {}, type = "item",
			slot = 3, },
	[4] = { name = "weapon_flashlight",
			price = 0, amount = 1,
			info = {}, type = "item",
			slot = 4, }, 
	[5] = { name = "drill",
			price = 0, amount = 1,
			info = {}, type = "item",
			slot = 5, }, }
}