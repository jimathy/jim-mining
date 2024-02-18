print("^2Jim-Mining ^7v^4"..GetResourceMetadata(GetCurrentResourceName(), 'version', nil):gsub("%.", "^7.^4").."^7 - ^2Mining Script by ^1Jimathy^7")

Config = {
	Lan = "en", -- Pick your language here
	System = {
		Debug = false, -- enable debug mode
		Menu = "ox",			--"qb" or "ox"
		ProgressBar = "gta",		--"qb" or "ox"
		Notify = "gta",			--"qb" or "ox"

	},
	General = {
		JimShops = false, 		-- Set this to true if using jim-shops
		DrillSound = true,		-- disable drill sounds

		K4MB1Prop = false, 		-- Enable this to make use of K4MB1's ore props provided with their Mining Cave MLO

		AltMining = true,		-- Enables Alternate mining (enhanced with k4mb1's mining ore props)
								-- Changes system to one based on rarity of ores specified in setMiningTable below
								-- Every ore that spawns will give specific ores

		K4MB1Cart = false,		-- If using k4mb1's shaftcave mlo + caveprops
								-- Allow players to use a minecart to get to the chambers faster
								-- Add's target option to the store ped at the mine shaft
	},
	Crafting = {
		craftCam = true,
		MultiCraft = true,		-- Enable multicraft
		MultiCraftAmounts = { [1], [5], [10] },
	},

	Timings = { -- Time it takes to do things
		["Cracking"] = math.random(5000, 10000),
		["Washing"] = math.random(10000, 12000),
		["Panning"] = math.random(25000, 30000),
		["Pickaxe"] = math.random(15000, 18000),
		["Mining"] = math.random(10000, 15000),
		["Laser"] = math.random(7000, 10000),
		["OreRespawn"] = math.random(1800000),
		["Crafting"] = 5000,
	},

	CrackPool = { -- Rewards from cracking stone
		"carbon",
		"copperore",
		"ironore",
		"metalscrap",
	},

	WashPool = {	-- Rewards from washing stone
		"goldore",
		"uncut_ruby",
		"uncut_emerald",
		"uncut_diamond",
		"uncut_sapphire",
		"goldore",
	},

	PanPool = { 	-- Rewards from panning
		"can",
		"goldore",
		"can",
		"goldore",
		"bottle",
		"stone",
		"goldore",
		"bottle",
		"can",
		"silverore",
		"can",
		"silverore",
		"bottle",
		"stone",
		"silverore",
		"bottle",
	},

	setMiningTable = {	-- Set rarity of ore spawn for AltMining
		{ name = "carbon", rarity = "common", prop = "k4mb1_coal2", },
		{ name = "copperore", rarity = "common", prop = "k4mb1_copperore2", },
		{ name = "ironore", rarity = "common", prop = "k4mb1_ironore2", },
		{ name = "metalscrap", rarity = "common", prop = "k4mb1_leadore2" },
		{ name = "goldore", rarity = "rare", prop = "k4mb1_goldore2" },
		{ name = "silverore", rarity = "rare", prop = "k4mb1_tinore2" },
		{ name = "uncut_ruby", rarity = "ultra_rare", prop = "k4mb1_crystalred" },
		{ name = "uncut_emerald", rarity = "ultra_rare", prop = "k4mb1_crystalgreen" },
		{ name = "uncut_diamond", rarity = "ultra_rare", prop = "k4mb1_diamond" },
		{ name = "uncut_sapphire", rarity = "ultra_rare", prop = "k4mb1_crystalblue" },
		{ name = "stone", rarity = "common", prop = "cs_x_rubweec" },
	},

------------------------------------------------------------
--Mining Store Items
	Items = {
		label = "Mining Store",  slots = 9,
		items = {
			{ name = "water_bottle", price = 0, amount = 100, info = {}, type = "item", slot = 1, },
			{ name = "sandwich", price = 0, amount = 250, info = {}, type = "item", slot = 2, },
			{ name = "bandage", price = 0, amount = 100, info = {}, type = "item", slot = 3, },
			{ name = "weapon_flashlight", price = 0, amount = 100, info = {}, type = "item", slot = 4, },
			{ name = "goldpan", price = 0, amount = 100, info = {}, type = "item", slot = 5, },
			{ name = "pickaxe",	price = 100, amount = 100, info = {}, type = "item", slot = 6, },
			{ name = "miningdrill",	price = 10000, amount = 50, info = {}, type = "item", slot = 7, },
			{ name = "mininglaser",	price = 60000, amount = 5, info = {}, type = "item", slot = 8, },
			{ name = "drillbit", price = 0, amount = 100, info = {}, type = "item", slot = 9, },
		},
	},
}