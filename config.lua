print("^2Jim-Mining ^7v^42^7.^44^7.^42 ^7- ^2Mining Script by ^1Jimathy^7")

Config = {
	Lan = "en", -- Pick your language here
	System = {
		Debug = trfalseue, -- enable debug mode
		Menu = "ox",			--"qb" or "ox"
		ProgressBar = "gta",		--"qb" or "ox"
		Notify = "gta",			--"qb" or "ox"

	},
	General = {
		JimShops = false, 		-- Set this to true if using jim-shops
		DrillSound = true,		-- disable drill sounds

		K4MB1Prop = true, -- Enable this to make use of K4MB1's ore props provided with their Mining Cave MLO
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
		["OreRespawn"] = math.random(55000, 75000),
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

	PanPool = {		-- Rewards from panning
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