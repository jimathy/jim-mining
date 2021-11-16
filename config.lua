Config = {}

-- The Good Ol' Classic way of getting key numbers

Config.Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
------------------------------------------------------------

Config = {
	Blips = true, -- Enable Blips?
	BlipNamer = true, -- Enable to Name Blips different things, disable if you already have too many blips as this will group them together
	PropSpawn = true, -- Enable Ore Props
	Pedspawn = true, -- Do you want to spawn peds for main locations?
	Invincible = true, --Do you want the peds to be invincible?
	Frozen = true, --Do you want the peds to be unable to move? It's probably a yes, so leave true in there.
	Stoic = true, --Do you want the peds to react to what is happening in their surroundings?
	Fade = true, -- Do you want the peds to fade into/out of existence? It looks better than just *POP* its there.
	Distance = 40.0, --The distance you want peds to spawn at
}

--Blips and Locations
-- Each one has individual blip enablers
-- Mine and Mine Leave have headings for the player locations
Config.Locations =  {
	['Mine'] = { name = "Mine", location = vector3(-599.25,2089.29,131.91-1.03), heading = 15.0, blipTrue = true }, -- The location where you enter the mine 
	['MineLeave'] = { name = "Leave Mine", location = vector3(-594.88,2087.71,131.5-1.03), heading = 169.83, blipTrue = false }, -- The location where you enter the mine 
	['Smelter'] = {	name = "Smelter", location = vector3(1112.29, -2009.9, 31.46), blipTrue = true }, -- The location of the smelter
	['Buyer'] = { name = "Ore Buyer", location = vector3(758.87,-816.09,26.29-1.03), blipTrue = true }, -- The Location of the ore buyer
	['JewelCut'] = { name = "Jewel Cutting", location = vector3(1077.24, -1984.22, 31.0-0.97), heading = 300.0, blipTrue = false }, -- The Location of the jewel buyer, most likely leave this as Vangelico Jeweler
	['Buyer2'] = { name = "Jewel Buyer", location = vector3(-629.85, -240.31, 38.16-1.03), heading = 105.74, blipTrue = false }, -- The Location of the jewel buyer, most likely leave this as Vangelico Jeweler
}

------------------------------------------------------------
--Ores and Props

Config.OrePositions = {
	{ coords = vector3(-587.5, 2060.54, 129.75), },
	{ coords = vector3(-588.49, 2048.05, 129.95-1.0), },
	{ coords = vector3(-580.46, 2037.82, 128.8-1.0), },
}

-----------------------------------------------------------
--Mining rewards stone
Config.MineReward = { "stone" }

--Smelting rewards ores/diamonds
--Need to find a better way to do random chance.
--Easiest way seems to add multiples to this section. More names, more chance to drop them.
Config.RewardPool = {
	'copperore', 'copperore', 'copperore', 'copperore', 'copperore', 'copperore', -- 6x
	'goldore', 'goldore', 'goldore', -- 3x
	'ironore', 'ironore', 'ironore', 'ironore', 'ironore', 'ironore', -- 6x
	'tinore', 'tinore', 'tinore', 'tinore', 'tinore', 'tinore', 'tinore', 'tinore', 'tinore', -- 9x
	'coal', 'coal', 'coal', 'coal', 'coal', 'coal', 'coal', 'coal', 'coal', 'coal', --10x
	'uncut_ruby',
	'uncut_emerald',
	'uncut_diamond',
}
------------------------------------------------------------
Config.SellItems = { -- Not working on yet
	['copperore'] = 100,
	['goldore'] = 100,
	['ironore'] = 100,
	['tinore'] = 100,
	['coal'] = 100,
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
	{ model = "s_m_y_xmech_02", coords = Config.Locations['Mine'].location, heading = Config.Locations['Mine'].heading, gender = "male", }, -- Outside Mine
	{ model = "s_m_y_xmech_02", coords = Config.Locations['MineLeave'].location, heading = Config.Locations['MineLeave'].heading, gender = "male", }, -- Inside Mine
	{ model = "s_m_y_xmech_02", coords = Config.Locations['Buyer'].location, heading = Config.Locations['Buyer'].heading, gender = "male", }, -- Ore Buyer
	{ model = "s_m_y_xmech_02", coords = Config.Locations['Buyer2'].location, heading = Config.Locations['Buyer2'].heading, gender = "male", }, -- Jewel Buyer
}

------------------------------------------------------------
--These wouldn't spawn on my server and no idea why..
Config.MineLights = {
	{ coords = vector3(-591.85, 2073.95, 131.35), },
	{ coords = vector3(-589.98, 2066.16, 131.02), },
	{ coords = vector3(600.53, 2093.63, 131.18-2.0), },
	{ coords = vector3(-549.11, 2030.52, 233.49), },
	--{ coords = vector3(-587.5, 2060.54, 129.75), },
	--{ coords = vector3(-587.5, 2060.54, 129.75), },
	--{ coords = vector3(-587.5, 2060.54, 129.75), },
}