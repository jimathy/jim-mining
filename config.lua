Config = {}

-- Ped Spawning Variables
Config.Pedspawn = true
Config.Invincible = false --Do you want the peds to be invincible?
Config.Frozen = true --Do you want the peds to be unable to move? It's probably a yes, so leave true in there.
Config.Stoic = true --Do you want the peds to react to what is happening in their surroundings?
Config.Fade = true-- Do you want the peds to fade into/out of existence? It looks better than just *POP* its there.
Config.Distance = 40.0 --The distance you want peds to spawn at

Config.Locations =  {
	['Mine'] = { location = vector3(758.87,-816.09,26.29), },
	['Smelter'] = {	location = vector3(758.87,-816.09,26.29), },
	['Buyer'] = { location = vector3(758.87,-816.09,26.29), },
}

Config.MineSpots = {
	['Spot1'] = { location = vector3(758.87,-816.09,26.29), },
	['Spot2'] = { location = vector3(758.87,-816.09,26.29), },
	['Spot3'] = { location = vector3(758.87,-816.09,26.29), },
	['Spot4'] = { location = vector3(758.87,-816.09,26.29), },
	['Spot5'] = { location = vector3(758.87,-816.09,26.29), },
	['Spot6'] = { location = vector3(758.87,-816.09,26.29), },
	['Spot7'] = { location = vector3(758.87,-816.09,26.29), },
	['Spot8'] = { location = vector3(758.87,-816.09,26.29), },
	['Spot9'] = { location = vector3(758.87,-816.09,26.29), },
	['Spot10'] = { location = vector3(758.87,-816.09,26.29), },
}
Config.SellItems = {
	['copperore'] = 100,
	['goldore'] = 100,
	['ironore'] = 100,
	['tinore'] = 100,
	['coal'] = 100,
}

Config.PedList = {
	{ model = "s_m_y_xmech_02", coords = vector3(-198.76,-1321.91,31.13), heading = 183.0, gender = "male", },
	{ model = "s_m_y_xmech_02", coords = vector3(101.29,6621.64,31.83), heading = 313.0, gender = "male", },
}