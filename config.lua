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

--Blips and Locations
Config.Blips = true -- Enable Blips?
Config.BlipNamer = true -- Enable to Name Blips different things, disable if you already have too many blips as this will group them together
-- Each one has individual blip enablers
-- Mine and Mine Leave have headings for the player locations
Config.Locations =  {
	['Mine'] = { name = "Mine", location = vector3(758.87,-816.09,26.29), heading = 100.0, blipTrue = true }, -- The location where you enter the mine 
	['MineLeave'] = { name = "Leave Mine", location = vector3(758.87,-816.09,26.29), heading = 100.0, blipTrue = false }, -- The location where you enter the mine 
	['Smelter'] = {	name = "Smelter", location = vector3(758.87,-816.09,26.29), blipTrue = true }, -- The location of the smelter
	['Buyer'] = { name = "Ore Buyer", location = vector3(758.87,-816.09,26.29), blipTrue = true}, -- The Location of the ore buyer
}

------------------------------------------------------------
--Ores and Props
Config.PropSpawn = true -- Enable Ore Props

Config.OrePositions = {
	{ coords = vector3(-493.01, 5395.37, 77.18-0.97), },
	{ coords = vector3(-503.69, 5392.12, 75.98-0.97), },
	{ coords = vector3(-456.85, 5397.37, 79.49-0.97), },
	{ coords = vector3(-499.55, 5401.11, 75.15-0.97), },
	{ coords = vector3(-457.18, 5409.11, 78.78-0.97), },
	{ coords = vector3(-446.59, 5396.92, 79.78-0.97), },
	{ coords = vector3(-492.71, 5418.52, 67.52-0.97), },
	{ coords = vector3(-512.87, 5419.67, 65.78-0.97), },
	{ coords = vector3(-531.41, 5419.53, 63.35-0.97), },
},

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

Config.PedList = {
	{ model = "s_m_y_xmech_02", coords = vector3(-198.76,-1321.91,31.13), heading = 183.0, gender = "male", }, -- Outside Mine
	{ model = "s_m_y_xmech_02", coords = vector3(101.29,6621.64,31.83), heading = 313.0, gender = "male", }, -- Inside Mine
}

