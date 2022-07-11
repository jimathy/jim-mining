print("^2Jim-Mining ^7v^52.1 ^7- ^2Mining Script by ^1Jimathy^7")

Loc = {}

Config = {
	Debug = false, -- enable debug mode
	Blips = true, -- Enable Blips?
	BlipNamer = false, -- Enable to Name Blips different things, disable if you already have too many blips as this will group them together
	propSpawn = true, -- Enable Ore Props
	pedSpawn = true, -- Do you want to spawn peds for main locations?
	img = "qb-inventory/html/images/", --Set this to the image directory of your inventory script or "nil" if using newer qb-menu
	CheckMarks = true, -- shows checkmarks if user has the materials to craft an item, set false if causing lag.
	Lan = "en", -- Pick your language here
	JimMenu = false, -- Set this to true if using update qb-menu with icons
	JimShops = false, -- Set this to true if using jim-shops
	Job = nil, -- set this to a job role eg "miner" or nil for no job
	--Lighting for mines
	HangingLights = false, -- if false, will spawn work lights. if true will spawn hanging lights

	Timings = { -- Time it takes to do things
		["Cracking"] = math.random(9000, 11500),
		["Washing"] = math.random(10000, 12000),
		["Panning"] = math.random(25000, 30000),
		["Pickaxe"] = math.random(15000, 18000),
		["Mining"] = math.random(10000, 15000),
		["Laser"] = math.random(7000, 10000),
		["OreRespawn"] = math.random(55000, 75000),
		["Crafting"] = 8000,
	},

	Locations =  {
		['MineStore'] = {
			{ name = "Mine", coords = vector4(-594.96, 2091.3, 131.47, 67.65), sprite = 527, col = 81, blipTrue = true, model = `G_M_M_ChemWork_01`, scenario = "WORLD_HUMAN_CLIPBOARD",  },		-- The location where you enter the mine
			{ name = "Quarry", coords = vector4(2960.9, 2754.14, 43.71, 204.58), sprite = 527, col = 81, blipTrue = true, model = `G_M_M_ChemWork_01`, scenario = "WORLD_HUMAN_CLIPBOARD",  },
			{ name = "Foundary Store", coords = vector4(1074.89, -1988.19, 30.89, 235.07), sprite = 436, col = 1, blipTrue = true, model = `G_M_M_ChemWork_01`, scenario = "WORLD_HUMAN_CLIPBOARD",  },
		},
		['Smelter'] = {	 -- The location of the smelter
			{ name = "Foundary", coords = vector3(1112.29, -2009.9, 31.46), sprite = 436, col = 1, blipTrue = false, },
		},
		["Washing"] = {
			{ name = "Stone Washing", coords = vector3(1840.18, 412.42, 160.49), sprite = 467, col = 3, disp = 6, blipTrue = true }, -- Mountains
			{ name = "Stone Washing", coords = vector3(1870.91, 395.1, 160.16), sprite = 467, col = 3, disp = 6, blipTrue = false },

			{ name = "Stone Washing", coords = vector3(-432.59, 2936.84, 13.87), sprite = 467, col = 3, disp = 6, blipTrue = true }, -- Stream Blip
			{ name = "Stone Washing", coords = vector3(-422.37, 2946.18, 13.77), sprite = 467, col = 3, blipTrue = false },
			{ name = "Stone Washing", coords = vector3(-443.21, 2926.5, 13.62), sprite = 467, col = 3, blipTrue = false },
			{ name = "Stone Washing", coords = vector3(-455.48, 2917.16, 13.52), sprite = 467, col = 3, blipTrue = false },

			{ name = "Stone Washing", coords = vector3(2500.64, 6129.4, 162.46), sprite = 467, col = 3, disp = 6, blipTrue = true }, -- Gordo

			{ name = "Stone Washing", coords = vector3(907.06, 4377.66, 30.28), sprite = 467, col = 3, disp = 6, blipTrue = true }, -- Alamo Sea
			{ name = "Stone Washing", coords = vector3(894.14, 4386.56, 30.24), sprite = 467, col = 3, blipTrue = false },
			{ name = "Stone Washing", coords = vector3(893.12, 4370.74, 30.35), sprite = 467, col = 3, blipTrue = false },
			{ name = "Stone Washing", coords = vector3(912.88, 4365.7, 30.39), sprite = 467, col = 3, blipTrue = false },
		},
		["Panning"] = {
			{ name = "Gold Panning", coords = vector3(-1656.67, 2074.85, 87.37), sprite = 467, col = 5, disp = 6, blipTrue = true }, -- Vineyard
			{ name = "Gold Panning", coords = vector3(-1672.06, 2070.89, 91.68), sprite = 467, col = 5, blipTrue = false },

			{ name = "Gold Panning", coords = vector3(-1273.16, 1898.19, 100.82), sprite = 467, col = 5, disp = 6, blipTrue = true }, -- Tongva

			{ name = "Gold Panning", coords = vector3(-1551.31, 1444.15, 116.44), sprite = 467, col = 5, disp = 6, blipTrue = true }, -- Tongva
			{ name = "Gold Panning", coords = vector3(-1565.47, 1431.46, 117.1), sprite = 467, col = 5, blipTrue = false },
			{ name = "Gold Panning", coords = vector3(-1578.39, 1419.59, 118.13), sprite = 467, col = 5, blipTrue = false },

			{ name = "Gold Panning", coords = vector3(-850.78, 4433.95, 14.21), sprite = 467, col = 5, disp = 6, blipTrue = true }, -- Wilderness
		},
		['Cracking'] = { -- The location of the smelter
			{ name = "Stone Cracking", coords = vector4(1109.19, -1992.8, 30.98, 146.88), sprite = 566, col = 81, blipTrue = false, prop = `prop_vertdrill_01` }, -- Foundary
			{ name = "Stone Cracking", coords = vector4(1105.56, -1992.53, 30.94, 238.19), sprite = 566, col = 81, blipTrue = false, prop = `prop_vertdrill_01` }, -- Foundary
		},
		['OreBuyer'] = { -- The Locations of the ore buyers
			{ name = "Ore Buyer", coords = vector4(1090.18, -1999.51, 30.93, 146.24), sprite = 568, col = 81, blipTrue = false, model = `G_M_M_ChemWork_01`, scenario = "WORLD_HUMAN_CLIPBOARD", },
		},
		['JewelCut'] = { -- The Location of the jewel cutting bench. Couldn't decide so left in smeltery
			{ name = "Jewel Cutting", coords = vector4(1077.11, -1984.22, 31.02, 235.8), sprite = 566, col = 81, blipTrue = false, prop = `gr_prop_gr_speeddrill_01c` },
			{ name = "Jewel Cutting", coords = vector4(1075.19, -1985.45, 30.92, 144.89), sprite = 566, col = 81, blipTrue = false, prop = `gr_prop_gr_speeddrill_01c` },
		},
		['JewelBuyer'] = { -- The Location of the jewel buyer, I left this as Vangelico, others will proabably change to pawn shops
			{ name = "Jewel Buyer", coords = vector4(-629.86, -240.35, 38.16, 110.05), sprite = 527, col = 617, blipTrue = false, model = `S_M_M_HighSec_03`, scenario = "WORLD_HUMAN_VALET", },
		},
	},

------------------------------------------------------------
--Ores and Props
	OrePositions = {
		---MineShaft Locations
		vector4(-588.49, 2048.05, 129.95+1.03, 0.0),
		vector4(-580.10, 2037.82, 128.8+1.03, 180.0),
		vector4(-572.28, 2022.37, 127.93+1.03, 90.0),
		vector4(-562.8, 2011.85, 127.25+1.03, 90.0),
		vector4(-548.99, 1996.56, 127.08+1.03, 210.95),
		--Deeper Mineshaft locations
		vector4(-534.22, 1982.9, 126.98+1.03, 210.95),
		vector4(-531.43, 1979.08, 127.15+1.03, 90.95),
		vector4(-523.71, 1981.21, 126.75+1.03, 250.95),
		vector4(-516.25, 1977.32, 126.49+1.03, 250.95),
		vector4(-506.58, 1980.66, 126.14+1.03, 210.95),
		vector4(-499.52, 1981.87, 125.08+1.03, 210.95),
		vector4(-488.44, 1982.74, 124.64+1.03, 250.95),
		vector4(-469.78, 1993.57, 123.26+1.03, 250.95),
		vector4(-458.53, 2003.33, 123.33+1.03, 250.95),
		--Quarry Locations
		vector4(3000.77, 2754.15, 43.5+1.03, 0.0),
		vector4(2990.38, 2750.4, 43.46+1.03, 0.0),
		vector4(2985.77, 2751.19, 43.06+1.03, 0.0),
		vector4(2980.37, 2748.4, 43.0+1.03, 0.0),
		vector4(2977.74, 2741.16, 44.54+1.03, 180.0),
		vector4(3004.49, 2761.98, 43.54+1.03, 180.0),
		vector4(3006.38, 2768.63, 42.59+1.03, 180.0),
		vector4(3005.44, 2773.78, 43.11+1.03, 180.0),
	},

-----------------------------------------------------------

	CrackPool = {
		"carbon",
		"copperore",
		"ironore",
		"metalscrap",
	},

	WashPool = {
		"goldore",
		"uncut_ruby",
		"uncut_emerald",
		"uncut_diamond",
		"uncut_sapphire",
		"goldore",
	},

	PanPool = {
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
	SellItems = { -- Selling Prices
		['copperore'] = 100,
		['goldore'] = 100,
		['silverore'] = 100,
		['ironore'] = 100,
		['carbon'] = 100,

		['goldingot'] = 100,
		['silveringot'] = 100,

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
		['diamond_ring_silver'] = 100,
		['emerald_ring_silver'] = 100,
		['ruby_ring_silver'] = 100,
		['sapphire_ring_silver'] = 100,

		['diamond_necklace'] = 100,
		['emerald_necklace'] = 100,
		['ruby_necklace'] = 100,
		['sapphire_necklace'] = 100,
		['diamond_necklace_silver'] = 100,
		['emerald_necklace_silver'] = 100,
		['ruby_necklace_silver'] = 100,
		['sapphire_necklace_silver'] = 100,

		['diamond_earring'] = 100,
		['emerald_earring'] = 100,
		['ruby_earring'] = 100,
		['sapphire_earring'] = 100,
		['diamond_earring_silver'] = 100,
		['emerald_earring_silver'] = 100,
		['ruby_earring_silver'] = 100,
		['sapphire_earring_silver'] = 100,

		['gold_ring'] = 100,
		['goldchain'] = 100,
		['goldearring'] = 100,
		['silver_ring'] = 100,
		['silverchain'] = 100,
		['silverearring'] = 100,

	},

------------------------------------------------------------
--Added mine lighting for my first world NVE problems
--Light Up at Night..or sometimes not at all :(
	MineLights = {
		vector4(-595.52, 2086.38, 132.90+1.03, 0.0),
		vector4(-594.30, 2082.89, 132.95+1.03, 0.0),
		vector4(-591.85, 2073.95, 132.95+1.03, 0.0),
		vector4(-589.98, 2066.16, 132.52+1.03, 0.0),
		vector4(-588.92, 2059.21, 132.17+1.03, 0.0),
		vector4(-588.69, 2054.36, 131.83+1.03, 0.0),
		vector4(-587.11, 2048.25, 131.20+1.03, 0.0),
		vector4(-584.51, 2041.63, 130.76+1.03, 0.0),
		vector4(-580.87, 2035.56, 130.22+1.03, 0.0),
		vector4(-576.07, 2028.91, 129.66+1.03, 0.0),
		vector4(-571.74, 2023.9, 129.31+1.03, 0.0),
		vector4(-565.44, 2017.63, 128.97+1.03, 0.0),
		vector4(-561.39, 2012.64, 128.78+1.03, 0.0),
		vector4(-558.24, 2008.18, 128.66+1.03, 0.0),
		vector4(-553.94, 2001.05, 128.66+1.03, 0.0),
		vector4(-549.67, 1994.23, 128.66+1.03, 0.0),
		vector4(-545.35, 1986.81, 128.63+1.03, 0.0),
		vector4(-543.0, 1982.82, 128.63+1.03, 0.0),
		vector4(-534.72, 1981.34, 128.72+1.03, 0.0),
		vector4(-526.63, 1979.63, 128.64+1.03, 0.0),
		vector4(-515.62, 1979.07, 128.01+1.03, 0.0),
		vector4(-506.55, 1979.26, 127.44+1.03, 0.0),
		vector4(-499.81, 1980.19, 126.88+1.03, 0.0),
		vector4(-490.67, 1983.73, 126.01+1.03, 0.0),
		vector4(-479.18, 1987.91, 125.48+1.03, 0.0),
		vector4(-468.53, 1992.32, 125.1+1.03, 0.0),
		vector4(-462.7, 1996.76, 125.05+1.03, 0.0),
		vector4(-456.57, 2002.97, 125.02+1.03, 0.0),
		vector4(-450.79, 2009.94, 125.55+1.03, 0.0),
		vector4(-445.25, 2014.22, 125.57+1.03, 0.0),
	},
	WorkLights = {
		vector4(-593.9, 2076.57, 131.27, 233.24),
		vector4(-594.11, 2078.02, 131.3, 318.99),
		vector4(-592.11, 2069.46, 131.13, 224.91),
		vector4(-590.57, 2062.08, 130.8, 214.27),
		vector4(-589.57, 2054.82, 130.27, 217.82),
		vector4(-588.04, 2047.13, 129.65, 230.42),
		vector4(-584.95, 2039.96, 129.06, 225.12),
		vector4(-580.74, 2033.34, 128.47, 237.95),
		vector4(-576.23, 2027.24, 127.98, 242.31),
		vector4(-570.87, 2021.57, 127.5, 244.01),
		vector4(-565.69, 2015.97, 127.33, 251.45),
		vector4(-561.05, 2010.26, 127.1, 248.45),
		vector4(-557.0, 2003.95, 127.05, 242.28),
		vector4(-553.02, 1997.25, 126.99, 237.0),
		vector4(-549.29, 1990.84, 126.94, 224.48),
		vector4(-537.3, 1980.52, 126.9, 278.19),
		vector4(-529.79, 1979.09, 126.86, 295.72),
		vector4(-522.13, 1978.13, 126.59, 282.3),
		vector4(-514.44, 1977.77, 126.29, 297.0),
		vector4(-506.72, 1978.01, 126.02, 296.09),
		vector4(-498.89, 1979.11, 125.65, 316.07),
		vector4(-491.77, 1981.93, 124.82, 320.17),
		vector4(-484.83, 1984.85, 124.17, 328.43),
		vector4(-477.71, 1987.12, 123.83, 290.95),
		vector4(-470.33, 1990.0, 123.57, 307.32),
		vector4(-463.85, 1994.29, 123.46, 327.1),
		vector4(-458.09, 1999.59, 123.47, 338.54),
		vector4(-445.97, 2011.57, 123.4, 308.83),
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
Crafting = {
	SmeltMenu = {
		{ ["copper"] = { ["copperore"] = 1 }, ['amount'] = 4 },
		{ ["goldingot"] = { ["goldore"] = 1 } },
		{ ["goldingot"] = { ["goldchain"] = 3 } },
		{ ["goldingot"] = { ["gold_ring"] = 4 } },
		{ ["silveringot"] = { ["silverore"] = 1 } },
		{ ["silveringot"] = { ["silverchain"] = 3 } },
		{ ["silveringot"] = { ["silver_ring"] = 4 } },
		{ ["iron"] = { ["ironore"] = 1 } },
		{ ["steel"] = { ["ironore"] = 1, ["carbon"] = 1 } },
		{ ["aluminum"] = { ["can"] = 2, }, ['amount'] = 3 },
		{ ["glass"] = { ["bottle"] = 2, }, ['amount'] = 2 },
	},
	GemCut = {
		{ ["emerald"] = { ["uncut_emerald"] = 1, } },
		{ ["diamond"] = { ["uncut_diamond"] = 1}, },
		{ ["ruby"] = { ["uncut_ruby"] = 1 }, },
		{ ["sapphire"] = { ["uncut_sapphire"] = 1 }, },
	},
	RingCut = {
		{ ["gold_ring"] = { ["goldingot"] = 1 }, ['amount'] = 3 },
		{ ["silver_ring"] = { ["silveringot"] = 1 }, ['amount'] = 3 },
		{ ["diamond_ring"] = { ["gold_ring"] = 1, ["diamond"] = 1 }, },
		{ ["emerald_ring"] = { ["gold_ring"] = 1, ["emerald"] = 1 }, },
		{ ["ruby_ring"] = { ["gold_ring"] = 1, ["ruby"] = 1 }, },
		{ ["sapphire_ring"] = { ["gold_ring"] = 1, ["sapphire"] = 1 }, },

		{ ["diamond_ring_silver"] = { ["silver_ring"] = 1, ["diamond"] = 1 }, },
		{ ["emerald_ring_silver"] = { ["silver_ring"] = 1, ["emerald"] = 1 }, },
		{ ["ruby_ring_silver"] = { ["silver_ring"] = 1, ["ruby"] = 1 }, },
		{ ["sapphire_ring_silver"] = { ["silver_ring"] = 1, ["sapphire"] = 1 }, },
	},
	NeckCut = {
		{ ["goldchain"] = { ["goldingot"] = 1 }, ['amount'] = 3  },
		{ ["silverchain"] = { ["silveringot"] = 1 }, ['amount'] = 3  },
		{ ["diamond_necklace"] = { ["goldchain"] = 1, ["diamond"] = 1 }, },
		{ ["ruby_necklace"] = { ["goldchain"] = 1, ["ruby"] = 1 }, },
		{ ["sapphire_necklace"] = { ["goldchain"] = 1, ["sapphire"] = 1 }, },
		{ ["emerald_necklace"] = { ["goldchain"] = 1, ["emerald"] = 1 }, },

		{ ["diamond_necklace_silver"] = { ["silverchain"] = 1, ["diamond"] = 1 }, },
		{ ["ruby_necklace_silver"] = { ["silverchain"] = 1, ["ruby"] = 1 }, },
		{ ["sapphire_necklace_silver"] = { ["silverchain"] = 1, ["sapphire"] = 1 }, },
		{ ["emerald_necklace_silver"] = { ["silverchain"] = 1, ["emerald"] = 1 }, },
	},
	EarCut = {
		{ ["goldearring"] = { ["goldingot"] = 1 }, ['amount'] = 3  },
		{ ["silverearring"] = { ["silveringot"] = 1 }, ['amount'] = 3  },
		{ ["diamond_earring"] = { ["goldearring"] = 1, ["diamond"] = 1 }, },
		{ ["ruby_earring"] = { ["goldearring"] = 1, ["ruby"] = 1 }, },
		{ ["sapphire_earring"] = { ["goldearring"] = 1, ["sapphire"] = 1 }, },
		{ ["emerald_earring"] = { ["goldearring"] = 1, ["emerald"] = 1 }, },

		{ ["diamond_earring_silver"] = { ["silverearring"] = 1, ["diamond"] = 1 }, },
		{ ["ruby_earring_silver"] = { ["silverearring"] = 1, ["ruby"] = 1 }, },
		{ ["sapphire_earring_silver"] = { ["silverearring"] = 1, ["sapphire"] = 1 }, },
		{ ["emerald_earring_silver"] = { ["silverearring"] = 1, ["emerald"] = 1 }, },
	},
}