Config = {
	Lan = "en", -- Pick your language here
	System = {
		Debug = false, -- enable debug mode

		Menu = "ox",			-- "qb", "ox", "gta"
		ProgressBar = "gta",	-- "qb", "ox", "gta"
		Notify = "gta",			-- "qb", "ox", "gta"
		drawText = "gta"			-- "qb", "ox", "gta"

	},
	General = {
		JimShops = false, 		-- Set this to true if using jim-shops for the shops
		DrillSound = true,		-- enable/disable drill sounds

		K4MB1Prop = false, 		-- Enable this to make use of K4MB1's ore props provided with their Mining Cave MLO

		AltMining = false,		-- Enables Alternate mining (enhanced with k4mb1's mining ore props)
								-- Changes system to one based on rarity of ores specified in setMiningTable below
								-- Every ore that spawns will give specific ores

		K4MB1Cart = false,		-- If using k4mb1's shaftcave mlo + caveprops
								-- Allow players to use a minecart to get to the chambers faster
								-- Add's target option to the store ped at the mine shaft

		requiredJob = nil,

		crackingRequiresDrillbit = true,	-- Toggle for if cracking stone requires a drillbit

	},
	Crafting = {
		craftCam = false,
		MultiCraft = true,		-- Enable multicraft
	},

	BreakTool = {				-- BreakTool lowers the durability by default of a math.random(2, 3)
		Pickaxe = true,
		MiningDrill = false,
		DrillBit = false,
		MiningLaser = false,
		GoldPan = false,
	},

	Timings = { -- Time it takes to do things
		Cracking = { 15000, 25000 }, -- 15 - 25 seconds
		Washing = { 15000, 25000 }, -- 15 - 25 seconds
		Panning = { 45000, 50000 },-- 45 - 50 seconds
		Pickaxe = { 30000, 45000 }, --  30 - 45 seconds
		Mining = { 45000, 50000 }, -- 45 - 50 seconds
		Laser = { 7000, 10000 },
		OreRespawn = math.random(55000, 75000),
		Crafting = 5000, -- 5 seconds
	},

	PoolAmounts = {
		Mining = {
			AmountPerSuccess = { 1, 3 }		-- Per success, this will give 1 - 3 of the selected item
		},
		Cracking = {
			AmountPerSuccess = { 1, 3 }		-- Per success, this will give 1 - 3 of the selected item
		},
		Panning = {
			Successes = { 1, 2 },			-- When complete, default will give 1 or 2 items
			AmountPerSuccess = { 1, 3 }		-- Per success, this will give 1 - 3 of the selected item
		},
		Washing = {
			Successes = { 1, 2 },			-- When complete, default will give 1 or 2 items
			AmountPerSuccess = { 1, 3 }		-- Per success, this will give 1 - 3 of the selected item
		},

	},

	CrackPool = { -- Rewards from cracking stone
		{ item = "carbon", rarity = "70",},
		{ item = "copperore",rarity = "10",},
		{ item = "ironore", rarity = "10",},
		{ item = "metalscrap", rarity = "90",},
	},

	WashPool = {	-- Rewards from washing stone
		{ item = "goldore", rarity = "10",},
		{ item = "copperore",rarity = "80",},
		{ item = "uncut_ruby", rarity = "50" },
		{ item = "uncut_emerald", rarity = "50"},
		{ item = "uncut_diamond", rarity = "10"},
		{ item = "uncut_sapphire", rarity = "50"},
	},

	PanPool = {		-- Rewards from panning
		{ item = "can", rarity = "90", },
		{ item = "goldore", rarity = "10", },
		{ item = "bottle", rarity = "10", },
		{ item = "stone", rarity = "90", },
		{ item = "silverore", rarity = "10", },
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
			{ name = "water_bottle", price = 2, amount = 100, info = {}, type = "item", slot = 1, },
			{ name = "sandwich", price = 2, amount = 250, info = {}, type = "item", slot = 2, },
			{ name = "bandage", price = 25, amount = 100, info = {}, type = "item", slot = 3, },
			{ name = "weapon_flashlight", price = 75, amount = 100, info = {}, type = "item", slot = 4, },
			{ name = "goldpan", price = 25, amount = 100, info = {}, type = "item", slot = 5, },
			{ name = "pickaxe",	price = 100, amount = 100, info = {}, type = "item", slot = 6, },
			{ name = "miningdrill",	price = 10000, amount = 50, info = {}, type = "item", slot = 7, },
			{ name = "mininglaser",	price = 60000, amount = 5, info = {}, type = "item", slot = 8, },
			{ name = "drillbit", price = 0, amount = 100, info = {}, type = "item", slot = 9, },
		},
	},
}

-- Function for locales
-- Don't touch unless you know what you're doing
-- This needs to be here because it loads before everything else
function locale(section, string)
    if not Config.Lan or Config.Lan == "" then
        print("^1Error^7: ^3Config^7.^3Lan ^1not set^7, ^2falling back to Config.Lan = 'en'")
        Config = Config or {}
        Config.Lan = "en"
    end

    local localTable = Loc[Config.Lan]
    -- If Loc[..] doesn't exist, warn user
    if not localTable then
		print("Locale Table '"..Config.Lan.."' Not Found")
        return "Locale Table '"..Config.Lan.."' Not Found"
    end

    -- If Loc[..].section doesn't exist, warn user
    if not localTable[section] then
		print("^1Error^7: Locale Section: ['"..section.."'] Invalid")
        return "Locale Section: ['"..section.."'] Invalid"
    end

    -- If Loc[..].section.string doesn't exist, warn user
    if not localTable[section][string] then
		print("^1Error^7: Locale String: ['"..section.."']['"..string.."'] Invalid")
        return "Locale String: ['"..string.."'] Invalid"
    end

    -- If no issues, return the string
    return localTable[section][string]
end