print("Jim-Mining - Mining Script by Jimathy")

Loc = {}

Config = {
	Debug = false, -- enable debug mode
	Blips = true, -- Enable Blips?
	BlipNamer = false, -- Enable to Name Blips different things, disable if you already have too many blips as this will group them together
	PropSpawn = true, -- Enable Ore Props
	Pedspawn = true, -- Do you want to spawn peds for main locations?
	img = "qb-inventory/html/images/", --Set this to the image directory of your inventory script or "nil" if using newer qb-menu
	Lan = "en", -- Pick your language here
	JimShops = false, -- Set this to true if using jim-shops
	Job = nil, -- set this to a job role eg "miner" or nil for no job
}


-- Each one has individual blip enablers
Config.Locations =  {
	['Mine'] = { name = "Mine", location = vector4(-594.96, 2091.3, 131.47-1.03, 67.65), spr = 527, col = 81, blipTrue = true }, -- The location where you enter the mine 
	['Quarry'] = { name = "Quarry", location = vector4(2960.9, 2754.14, 43.71-1.03, 204.58), spr = 527, col = 81, blipTrue = true }, -- The location where you enter the mine 
	['Smelter'] = {	name = "Smelter", location = vector3(1112.29, -2009.9, 31.46), spr = 527, col = 81, blipTrue = true }, -- The location of the smelter
	['Cracking'] = { name = "Stone Cracking", location = vector4(1109.19, -1992.8, 30.98-1.03, 56.88), spr = 527, col = 81, blipTrue = false }, -- The location of the smelter
	['Buyer'] = { name = "Ore Buyer", location = vector4(1085.57, -2001.11, 31.4-1.03, 317.12), spr = 527, col = 81, blipTrue = false }, -- The Location of the ore buyer
	['JewelCut'] = { name = "Jewel Cutting", location = vector4(1077.11, -1984.22, 31.02-1.03, 55.8), spr = 527, col = 81, blipTrue = false }, -- The Location of the jewel cutting bench. Couldn't decide so left in smeltery
	['Buyer2'] = { name = "Jewel Buyer", location = vector4(-629.86, -240.35, 38.16-1.03, 110.05), spr = 527, col = 81, blipTrue = false }, -- The Location of the jewel buyer, I left this as Vangelico, others will proabably change to pawn shops
}

------------------------------------------------------------
--Ores and Props

Config.OrePositions = {
	---MineShaft Locations
	{ coords = vector3(-587.05, 2059.08, 129.75), },
	{ coords = vector3(-588.49, 2048.05, 129.95-1.0), },
	{ coords = vector3(-580.10, 2037.82, 128.8-1.0), },
	{ coords = vector3(-572.28, 2022.37, 127.93-1.0), },
	{ coords = vector3(-562.8, 2011.85, 127.55-1.0), },
	--Quarry Locations
	{ coords = vector3(2980.37, 2748.4, 43.4-1.5), },
	{ coords = vector3(2985.77, 2751.19, 43.46-1.5), },
	{ coords = vector3(2990.38, 2750.4, 43.46-1.5), },
	{ coords = vector3(3000.77, 2754.15, 43.5-1.5), },
	{ coords = vector3(2977.74, 2741.16, 44.54-1.5), },
}

-----------------------------------------------------------

Config.RewardPool = {
	[1] = "carbon",
	[2] = "copperore",
	[3] = "goldore",
	[4] = "ironore",
	[5] = "metalscrap",
	[6] = 'uncut_ruby',
	[7] = 'uncut_emerald',
	[8] = 'uncut_diamond',
	[9] = 'uncut_sapphire',
}

------------------------------------------------------------
Config.SellItems = { -- Selling Prices
	['copperore'] = 100,
	['goldore'] = 100,
	['ironore'] = 100,
	['carbon'] = 100,
	
	['goldbar'] = 100,
	
	['uncut_emerald'] = 100,
	['uncut_ruby'] = 100,
	['uncut_diamond'] = 100,
	['uncut_sapphire'] = 100,

	['emerald'] = 100,
	['ruby'] = 100,
	['diamond'] = 100,
	['sapphire'] = 100,

	['diamond_ring'] = 100,
	['emerald_ring'] = 100,
	['ruby_ring'] = 100,
	['sapphire_ring'] = 100,

	['diamond_necklace'] = 100,
	['emerald_necklace'] = 100,
	['ruby_necklace'] = 100,
	['sapphire_necklace'] = 100,

	['gold_ring'] = 100,
	['goldchain'] = 100,
	['10kgoldchain'] = 100,

}

------------------------------------------------------------

Config.PedList = { -- APPARENTLY You can call config locations IN the config, learn't that one today
	{ model = `S_M_Y_Construct_01`, coords = Config.Locations['Mine'].location, gender = "male", scenario = "WORLD_HUMAN_CLIPBOARD", }, -- Outside Mine
	{ model = `S_M_Y_Construct_01`, coords = Config.Locations['Quarry'].location, gender = "male", scenario = "WORLD_HUMAN_CLIPBOARD", }, -- Outside Mine
	{ model = `S_M_Y_Construct_01`, coords = Config.Locations['Buyer'].location, gender = "male", scenario = "WORLD_HUMAN_CLIPBOARD", }, -- Ore Buyer
	{ model = `S_M_M_HighSec_03`, coords = Config.Locations['Buyer2'].location, gender = "male", scenario = "WORLD_HUMAN_CLIPBOARD", }, -- Jewel Buyer
}

------------------------------------------------------------
--Added mine lighting for my first world NVE problems
--Light Up at Night..or sometimes not at all :(
Config.MineLights = {
	{ coords = vector3(-595.52, 2086.38, 131.38+0.45), },
	{ coords = vector3(-594.30, 2082.89, 131.40+0.65), },
	{ coords = vector3(-591.85, 2073.95, 131.35+0.65), },
	{ coords = vector3(-589.98, 2066.16, 131.02+0.55), },
	{ coords = vector3(-588.92, 2059.21, 130.67+0.45), },
	{ coords = vector3(-588.69, 2054.36, 130.33+0.25), },
	{ coords = vector3(-587.11, 2048.25, 129.79+0.25), },
	{ coords = vector3(-584.51, 2041.63, 129.26+0.0), },
	{ coords = vector3(-580.87, 2035.56, 128.72+0.0), },
	{ coords = vector3(-576.07, 2028.91, 128.16+0.0), },
	{ coords = vector3(-571.74, 2023.9, 127.81+0.0), },
	{ coords = vector3(-565.44, 2017.63, 127.47+0.0), },
	{ coords = vector3(-561.39, 2012.64, 127.28+0.0), },
	{ coords = vector3(-558.24, 2008.18, 127.16+0.0), },
}

------------------------------------------------------------
--Mining Store Items
Config.Items = {
    label = "Mining Store",  slots = 7,
    items = {
	[1] = { name = "water_bottle", price = 0, amount = 100, info = {}, type = "item", slot = 1, },
	[2] = { name = "sandwich", price = 0, amount = 250, info = {}, type = "item", slot = 2, },
	[3] = { name = "bandage", price = 0, amount = 100, info = {}, type = "item", slot = 3, },
	[4] = { name = "weapon_flashlight", price = 0, amount = 100, info = {}, type = "item", slot = 4, }, 
	[5] = { name = "drill",	price = 0, amount = 100, info = {}, type = "item", slot = 5, }, 
	[6] = { name = "handdrill",	price = 0, amount = 100, info = {}, type = "item",	slot = 6, },
	[7] = { name = "drillbit", price = 0, amount = 100,	info = {}, type = "item", slot = 7, }, }		
}

Crafting = {}
Crafting.SmeltMenu = {
	[1] = { ["copper"] = { ["copperore"] = 1 }, ['amount'] = 4 },
	[2] = { ["goldbar"] = { ["goldore"] = 1 } },
	[3] = { ["goldbar"] = { ["goldchain"] = 2 } },
	[4] = { ["goldbar"] = { ["10kgoldchain"] = 1 } },
	[5] = { ["goldbar"] = { ["gold_ring"] = 4 } },
	[6] = { ["iron"] = { ["ironore"] = 1 } },
	[7] = { ["steel"] = { ["ironore"] = 1, ["carbon"] = 1 } },
	--[8] = { ["aluminum"] = { ["can"] = 2, }, ['amount'] = 3 },
	--[9] = { ["glass"] = { ["bottle"] = 3, }, ['amount'] = 2 },
}
Crafting.GemCut = {
	[1] = { ["emerald"] = { ["uncut_emerald"] = 1, } },
	[2] = { ["diamond"] = { ["uncut_diamond"] = 1}, },
	[3] = { ["ruby"] = { ["uncut_ruby"] = 1 }, },
	[4] = { ["sapphire"] = { ["uncut_sapphire"] = 1 }, },
}
Crafting.RingCut = {
	[1] = { ["gold_ring"] = { ["goldbar"] = 1 }, ['amount'] = 3 },
	[2] = { ["diamond_ring"] = { ["gold_ring"] = 1, ["diamond"] = 1 }, },
	[3] = { ["emerald_ring"] = { ["gold_ring"] = 1, ["emerald"] = 1 }, },
	[4] = { ["ruby_ring"] = { ["gold_ring"] = 1, ["ruby"] = 1 }, },
	[5] = { ["sapphire_ring"] = { ["gold_ring"] = 1, ["sapphire"] = 1 }, },
}
Crafting.NeckCut = {
	[1] = { ["goldchain"] = { ["goldbar"] = 1 }, ['amount'] = 3  },
	[2] = { ["10kgoldchain"] = { ["goldbar"] = 1 }, ['amount'] = 2 },
	[3] = { ["diamond_necklace"] = { ["goldchain"] = 1, ["diamond"] = 1 }, },
	[4] = { ["ruby_necklace"] = { ["goldchain"] = 1, ["ruby"] = 1 }, },
	[5] = { ["sapphire_necklace"] = { ["goldchain"] = 1, ["sapphire"] = 1 }, },
	[6] = { ["emerald_necklace"] = { ["goldchain"] = 1, ["emerald"] = 1 }, },
}
