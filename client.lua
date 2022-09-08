local QBCore = exports['qb-core']:GetCoreObject()
RegisterNetEvent('QBCore:Client:UpdateObject', function() QBCore = exports['qb-core']:GetCoreObject() end)

local PlayerJob = {}
local Props = {}
local Targets = {}
local Peds = {}
local Blip = {}
local soundId = GetSoundId()

------------------------------------------------------------

--Hide the mineshaft doors
CreateModelHide(vector3(-596.04, 2089.01, 131.41), 10.5, -1241212535, true)

--Attempts to disable header icons if JimMenu is enabled
if Config.JimMenu then Config.img = "" end

function removeJob()
	for k in pairs(Targets) do exports['qb-target']:RemoveZone(k) end
	for _, v in pairs(Peds) do unloadModel(GetEntityModel(v)) DeletePed(v) end
	for i = 1, #Props do unloadModel(GetEntityModel(Props[i])) DeleteObject(Props[i]) end
	for i = 1, #Blip do RemoveBlip(Blip[i]) end
end

function makeJob()
	removeJob()
	if not Config.K4MB1Only then
		if Config.propSpawn then
			--Quickly add outside lighting
			Props[#Props+1] = makeProp({coords = vector4(-593.29, 2093.22, 131.7, 110.0), prop = `prop_worklight_02a`}, 1, false) -- Mineshaft door
			Props[#Props+1] = makeProp({coords = vector4(-604.55, 2089.74, 131.15, 300.0), prop = `prop_worklight_02a`}, 1, false) -- Mineshaft door 2
			Props[#Props+1] = makeProp({coords = vector4(2991.59, 2758.07, 42.68, 250.85), prop = `prop_worklight_02a`}, 1, false) -- Quarry Light
			Props[#Props+1] = makeProp({coords = vector4(2991.11, 2758.02, 42.66, 194.6), prop = `prop_worklight_02a`}, 1, false) -- Quarry Light
			Props[#Props+1] = makeProp({coords = vector4(2971.78, 2743.33, 43.29, 258.54), prop = `prop_worklight_02a`}, 1, false) -- Quarry Light
			Props[#Props+1] = makeProp({coords = vector4(3000.72, 2777.08, 43.08, 211.7), prop = `prop_worklight_02a`}, 1, false) -- Quarry Light
			Props[#Props+1] = makeProp({coords = vector4(2998.0, 2767.45, 42.71, 249.22), prop = `prop_worklight_02a`}, 1, false) -- Quarry Light
			Props[#Props+1] = makeProp({coords = vector4(2959.93, 2755.26, 43.71, 164.24), prop = `prop_worklight_02a`}, 1, false) -- Quarry Light
			Props[#Props+1] = makeProp({coords = vector4(1106.46, -1991.44, 31.49, 185.78), prop = `prop_worklight_02a`}, 1, false) -- Foundary Light
			if Config.HangingLights then
				for k, v in pairs(Config.MineLights) do
					if Config.propSpawn then Props[#Props+1] = makeProp({coords = v, prop = `xs_prop_arena_lights_ceiling_l_c`}, 1, false) end
				end
			end
			if not Config.HangingLights then
				for k, v in pairs(Config.WorkLights) do
					if Config.propSpawn then Props[#Props+1] = makeProp({coords = v, prop = `prop_worklight_03a`}, 1, false) end
				end
			end
		end
		for k, v in pairs(Config.Locations["MineStore"]) do
			if Config.Blips and v.blipTrue then Blip[#Blip+1] = makeBlip(v) end
			Peds[#Peds+1] = makePed(v.model, v.coords, 1, 1, v.scenario)
			Targets["Mine"..k] =
			exports['qb-target']:AddCircleZone("Mine"..k, v.coords.xyz, 1.0, { name="Mine"..k, debugPoly=Config.Debug, useZ=true, },
			{ options = { { event = "jim-mining:openShop", icon = "fas fa-store", label = Loc[Config.Lan].info["browse_store"], job = Config.Job }, },
				distance = 2.0 })
		end
		--Smelter to turn stone into ore
		for k, v in pairs(Config.Locations["Smelter"]) do
			if Config.Blips and v.blipTrue then Blip[#Blip+1] = makeBlip(v) end
			Targets["Smelter"..k] =
			exports['qb-target']:AddCircleZone("Smelter"..k, v.coords.xyz, 3.0, { name="Smelter"..k, debugPoly=Config.Debug, useZ=true, },
				{ options = { { event = "jim-mining:CraftMenu", icon = "fas fa-fire-burner", label = Loc[Config.Lan].info["use_smelter"], craftable = Crafting.SmeltMenu, job = Config.Job }, },
					distance = 10.0
				})
		end
		--Ore Buying Ped
		for k, v in pairs(Config.Locations["OreBuyer"]) do
			Peds[#Peds+1] = makePed(v.model, v.coords, 1, 1, v.scenario)
			if Config.Blips and v.blipTrue then Blip[#Blip+1] = makeBlip(v) end
			local name = "OreBuyer"..k
			Targets[name] =
				exports['qb-target']:AddCircleZone(name, v.coords.xyz, 0.9, { name=name, debugPoly=Config.Debug, useZ=true, },
				{ options = { { event = "jim-mining:SellOre", icon = "fas fa-sack-dollar", label = Loc[Config.Lan].info["sell_ores"], ped = Peds[#Peds], job = Config.Job }, },
					distance = 2.0
				})
		end

		--Jewel Cutting Bench
		for k, v in pairs(Config.Locations["JewelCut"]) do
			if Config.Blips and v.blipTrue then Blip[#Blip+1] = makeBlip(v) end
			Props[#Props+1] = makeProp(v, 1, false)
			Targets["JewelCut"..k] =
			exports['qb-target']:AddCircleZone("JewelCut"..k, v.coords.xyz, 2.0,{ name="JewelCut"..k, debugPoly=Config.Debug, useZ=true, },
			{ options = { { event = "jim-mining:JewelCut", icon = "fas fa-gem", label = Loc[Config.Lan].info["jewelcut"], bench = Props[#Props], job = Config.Job }, },
				distance = 2.0
			})
		end
		--Cracking Bench
		for k, v in pairs(Config.Locations["Cracking"]) do
			Props[#Props+1] = makeProp(v, 1, false)
			if Config.Blips and v.blipTrue then Blip[#Blip+1] = makeBlip(v) end
			Targets["Cracking"..k] =
				exports['qb-target']:AddCircleZone("Cracking"..k, v.coords.xyz, 1.2, {name="Cracking"..k, debugPoly=Config.Debug, useZ=true, },
				{ options = { { event = "jim-mining:CrackStart", icon = "fas fa-compact-disc", item = "stone", label = Loc[Config.Lan].info["crackingbench"], bench = Props[#Props] }, },
					distance = 2.0
				})
		end
		--Stone Washing
		--Ore Spawning
		for k, v in pairs(Config.OrePositions) do
			Props[#Props+1] = makeProp({coords = v, prop = `cs_x_rubweec`}, 1, false)
			Targets["Ore"..k] =
				exports['qb-target']:AddCircleZone("Ore"..k, vector3(v.x, v.y, v.z-1.03), 1.2, { name="Ore"..k, debugPoly=Config.Debug, useZ=true, },
				{ options = {
					{ event = "jim-mining:MineOre:Pick", icon = "fas fa-hammer", item = "pickaxe", label = Loc[Config.Lan].info["mine_ore"].." ("..QBCore.Shared.Items["pickaxe"].label..")", job = Config.Job, name = "Ore"..k, stone = Props[#Props] },
					{ event = "jim-mining:MineOre:Drill", icon = "fas fa-screwdriver", item = "miningdrill", label = Loc[Config.Lan].info["mine_ore"].." ("..QBCore.Shared.Items["miningdrill"].label..")", job = Config.Job, name = "Ore"..k, stone = Props[#Props] },
					{ event = "jim-mining:MineOre:Laser", icon = "fas fa-screwdriver-wrench", item = "mininglaser", label = Loc[Config.Lan].info["mine_ore"].." ("..QBCore.Shared.Items["mininglaser"].label..")", job = Config.Job, name = "Ore"..k, stone = Props[#Props] },
				}, distance = 1.3 })
			Props[#Props+1] = makeProp({coords = vector4(v.x, v.y, v.z+0.25, v[4]), prop = `prop_rock_5_a`}, 1, false)
		end
	else Config.K4MB1 = true end

	if Config.K4MB1 then
		for k, v in pairs(K4MB1["MineStore"]) do
			Targets["K4MB1Mine"..k] =
			exports['qb-target']:AddCircleZone("K4MB1Mine"..k, v.coords.xyz, 1.0, { name="K4MB1Mine"..k, debugPoly=Config.Debug, useZ=true, },
			{ options = { { event = "jim-mining:openShop", icon = "fas fa-store", label = Loc[Config.Lan].info["browse_store"], job = Config.Job }, },
			distance = 2.0 })
			if Config.Blips and v.blipTrue then Blip[#Blip+1] = makeBlip(v) end
			Peds[#Peds+1] = makePed(v.model, v.coords, 1, 1, v.scenario)
		end
		--Smelter to turn stone into ore
		for k, v in pairs(K4MB1["Smelter"]) do
			Targets["K4MB1Smelter"..k] =
			exports['qb-target']:AddCircleZone("K4MB1Smelter"..k, v.coords.xyz, 1.5, { name="K4MB1Smelter"..k, debugPoly=Config.Debug, useZ=true, },
			{ options = { { event = "jim-mining:CraftMenu", icon = "fas fa-fire-burner", label = Loc[Config.Lan].info["use_smelter"], craftable = Crafting.SmeltMenu, job = Config.Job }, },
					distance = 10.0
				})
			if Config.Blips and v.blipTrue then Blip[#Blip+1] = makeBlip(v) end
		end
		--Ore Buying Ped
		for k, v in pairs(K4MB1["OreBuyer"]) do
			if Config.Blips and v.blipTrue then Blip[#Blip+1] = makeBlip(v) end
			Peds[#Peds+1] = makePed(v.model, v.coords, 1, 1, v.scenario)
			Targets["K4MB1OreBuyer"..k] =
			exports['qb-target']:AddCircleZone("K4MB1OreBuyer"..k, v.coords.xyz, 0.9, { name="K4MB1OreBuyer"..k, debugPoly=Config.Debug, useZ=true, },
			{ options = { { event = "jim-mining:SellOre", icon = "fas fa-sack-dollar", label = Loc[Config.Lan].info["sell_ores"], ped = Peds[#Peds], job = Config.Job }, },
					distance = 2.0
				})
		end

		--Jewel Cutting Bench
		for k, v in pairs(K4MB1["JewelCut"]) do
			Props[#Props+1] = makeProp(v, 1, false)
			Targets["K4MB1JewelCut"..k] =
			exports['qb-target']:AddCircleZone("K4MB1JewelCut"..k, v.coords.xyz, 2.0,{ name="K4MB1JewelCut"..k, debugPoly=Config.Debug, useZ=true, },
			{ options = { { event = "jim-mining:JewelCut", icon = "fas fa-gem", label = Loc[Config.Lan].info["jewelcut"], job = Config.Job, bench = Props[#Props]}, },
				distance = 2.0
			})
			if Config.Blips and v.blipTrue then Blip[#Blip+1] = makeBlip(v) end
		end
		--Cracking Bench
		for k, v in pairs(K4MB1["Cracking"]) do
			if Config.Blips and v.blipTrue then Blip[#Blip+1] = makeBlip(v) end
			Props[#Props+1] = makeProp(v, 1, false)
			Targets["K4MB1Cracking"..k] =
				exports['qb-target']:AddCircleZone("K4MB1Cracking"..k, v.coords.xyz, 1.2, {name="K4MB1Cracking"..k, debugPoly=Config.Debug, useZ=true, },
				{ options = { { event = "jim-mining:CrackStart", icon = "fas fa-compact-disc", item = "stone", label = Loc[Config.Lan].info["crackingbench"], bench = Props[#Props] }, },
				distance = 2.0
			})
		end
		--Ore Spawning
		for k, v in pairs(K4MB1["OrePositions"]) do
			Props[#Props+1] = makeProp({coords = v, prop = `cs_x_rubweec`}, 1, false)
			Targets["K4MB1Ore"..k] =
			exports['qb-target']:AddCircleZone("K4MB1Ore"..k, vector3(v.x, v.y, v.z-1.03), 1.2, { name="K4MB1Ore"..k, debugPoly=Config.Debug, useZ=true, },
			{ options = {
				{ event = "jim-mining:MineOre:Pick", icon = "fas fa-hammer", item = "pickaxe", label = Loc[Config.Lan].info["mine_ore"].." ("..QBCore.Shared.Items["pickaxe"].label..")", job = Config.Job, name = "K4MB1Ore"..k, stone = Props[#Props] },
				{ event = "jim-mining:MineOre:Drill", icon = "fas fa-screwdriver", item = "miningdrill", label = Loc[Config.Lan].info["mine_ore"].." ("..QBCore.Shared.Items["miningdrill"].label..")", job = Config.Job, name = "K4MB1Ore"..k, stone = Props[#Props] },
				{ event = "jim-mining:MineOre:Laser", icon = "fas fa-screwdriver-wrench", item = "mininglaser", label = Loc[Config.Lan].info["mine_ore"].." ("..QBCore.Shared.Items["mininglaser"].label..")", job = Config.Job, name = "K4MB1Ore"..k, stone = Props[#Props] },
				},
				distance = 1.3
			})
			Props[#Props+1] = makeProp({coords = vector4(v.x, v.y, v.z+0.25, v[4]), prop = `prop_rock_5_a`}, 1, false)
		end
	end
	for k, v in pairs(Config.Locations["Washing"]) do
		Targets["Washing"..k] =
			exports['qb-target']:AddCircleZone("Washing"..k, v.coords.xyz, 9.0, {name="Washing"..k, debugPoly=Config.Debug, useZ=true, },
			{ options = { { event = "jim-mining:WashStart", icon = "fas fa-hands-bubbles", item = "stone", label = Loc[Config.Lan].info["washstone"], coords = v.coords }, },
				distance = 2.0
			})
		if Config.Blips and v.blipTrue then Blip[#Blip+1] = makeBlip(v) end
	end
	--Panning
	for k, v in pairs(Config.Locations["Panning"]) do
		Targets["Panning"..k] =
			exports['qb-target']:AddCircleZone("Panning"..k, v.coords.xyz, 9.0, {name="Panning"..k, debugPoly=Config.Debug, useZ=true, },
			{ options = { { event = "jim-mining:PanStart", icon = "fas fa-ring", item = "goldpan", label = Loc[Config.Lan].info["goldpan"], coords = v.coords }, },
				distance = 2.0
			})
		if Config.Blips and v.blipTrue then Blip[#Blip+1] = makeBlip(v) end
	end
	--Jewel Buyer
	for k, v in pairs(Config.Locations["JewelBuyer"]) do
		Peds[#Peds+1] = makePed(v.model, v.coords, 1, 1, v.scenario)
		Targets["JewelBuyer"..k] =
			exports['qb-target']:AddCircleZone("JewelBuyer"..k, v.coords.xyz, 1.2, { name="JewelBuyer"..k, debugPoly=Config.Debug, useZ=true, },
			{ options = { { event = "jim-mining:JewelSell", icon = "fas fa-gem", label = Loc[Config.Lan].info["jewelbuyer"], ped = Peds[#Peds], job = Config.Job }, },
				distance = 2.0
			})
	end
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
	QBCore.Functions.GetPlayerData(function(PlayerData)	PlayerJob = PlayerData.job end)
	if Config.Job then if PlayerJob.name == Config.Job then makeJob() else removeJob() end else makeJob() end
end)
RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
	PlayerJob = JobInfo
	if Config.Job then if PlayerJob.name == Config.Job then makeJob() else removeJob() end end
end)
AddEventHandler('onResourceStart', function(resource) if GetCurrentResourceName() ~= resource then return end
QBCore.Functions.GetPlayerData(function(PlayerData) PlayerJob = PlayerData.job end)
if Config.Job then if PlayerJob.name == Config.Job then makeJob() else removeJob() end else makeJob() end
end)

--------------------------------------------------------
RegisterNetEvent('jim-mining:openShop', function()
	if Config.JimShops then event = "jim-shops:ShopOpen" else event = "inventory:server:OpenInventory" end
	TriggerServerEvent(event, "shop", "mine", Config.Items)
end)

function stoneBreak(name, stone)
	local rockcoords = GetEntityCoords(stone)
	if Config.Debug then print("^5Debug^7: ^2Hiding prop and target^7: '^6"..name.."^7' ^2at coords^7: ^6"..rockcoords) end
	--Stone CoolDown + Recreation
	SetEntityAlpha(stone, 0)
	--CreateModelHide(rockcoords, 1.0, `cs_x_rubweec`, true)
	exports['qb-target']:RemoveZone(name) Targets[name] = nil
	Wait(Config.Timings["OreRespawn"])
	--Unhide Stone and create a new target location
	SetEntityAlpha(stone, 255)
	--RemoveModelHide(rockcoords, 1.0, `cs_x_rubweec`, true)
	Targets[name] =
		exports['qb-target']:AddCircleZone(name, vector3(rockcoords.x, rockcoords.y, rockcoords.z), 1.2, { name=name, debugPoly=Config.Debug, useZ=true, },
		{ options = {
			{ event = "jim-mining:MineOre:Pick", icon = "fas fa-hammer", item = "pickaxe", label = Loc[Config.Lan].info["mine_ore"].." ("..QBCore.Shared.Items["pickaxe"].label..")", job = Config.Job, name = name, stone = stone },
			{ event = "jim-mining:MineOre:Drill", icon = "fas fa-screwdriver", item = "miningdrill", label = Loc[Config.Lan].info["mine_ore"].." ("..QBCore.Shared.Items["miningdrill"].label..")", job = Config.Job, name = name, stone = stone },
			{ event = "jim-mining:MineOre:Laser", icon = "fas fa-screwdriver-wrench", item = "mininglaser", label = Loc[Config.Lan].info["mine_ore"].." ("..QBCore.Shared.Items["mininglaser"].label..")", job = Config.Job, name = name, stone = stone },
			}, distance = 1.3 })
end

local isMining = false
RegisterNetEvent('jim-mining:MineOre:Drill', function(data)
	if isMining then return else isMining = true end -- Stop players from doubling up the event
	if HasItem("drillbit", 1) then
		-- Sounds & Anim loading
		loadDrillSound()
		local dict = "anim@heists@fleeca_bank@drilling"
		local anim = "drill_straight_fail"
		loadAnimDict(tostring(dict))
		--Create Drill and Attach
		local DrillObject = CreateObject(`hei_prop_heist_drill`, GetEntityCoords(PlayerPedId(), true), true, true, true)
		AttachEntityToEntity(DrillObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.14, 0, -0.01, 90.0, -90.0, 180.0, true, true, false, true, 1, true)
		local IsDrilling = true
		local rockcoords = GetEntityCoords(data.stone)
		--Calculate if you're heading is within 20.0 degrees -
		lookEnt(data.stone)
		if #(rockcoords - GetEntityCoords(PlayerPedId())) > 1.5 then TaskGoStraightToCoord(PlayerPedId(), rockcoords, 0.5, 400, 0.0, 0) Wait(400) end
		TaskPlayAnim(PlayerPedId(), tostring(dict), tostring(anim), 3.0, 3.0, -1, 1, 0, false, false, false)
		Wait(200)
		PlaySoundFromEntity(soundId, "Drill", DrillObject, "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
		CreateThread(function() -- Dust/Debris Animation
			loadPtfxDict("core")
			while IsDrilling do
				UseParticleFxAssetNextCall("core")
				local dust = StartNetworkedParticleFxNonLoopedAtCoord("ent_dst_rocks", rockcoords.x, rockcoords.y, rockcoords.z, 0.0, 0.0, GetEntityHeading(PlayerPedId())-180.0, 1.0, 0.0, 0.0, 0.0)
				Wait(600)
			end
		end)
		QBCore.Functions.Progressbar("open_locker_drill", Loc[Config.Lan].info["drilling_ore"], Config.Timings["Mining"], false, true, {
			disableMovement = true,	disableCarMovement = true, disableMouse = false, disableCombat = true, }, {}, {}, {}, function() -- Done
			StopAnimTask(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_fail", 1.0)
			destroyProp(DrillObject)
			unloadPtfxDict("core")
			unloadAnimDict(dict)
			TriggerServerEvent('jim-mining:MineReward')
			--Destroy drill bit chances
			if math.random(1,10) >= 8 then
				local breakId = GetSoundId()
				PlaySoundFromEntity(breakId, "Drill_Pin_Break", PlayerPedId(), "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
				toggleItem(0, "drillbit", 1)
			end
			unloadDrillSound()
			StopSound(soundId)
			IsDrilling = false
			isMining = false
			stoneBreak(data.name, data.stone)
		end, function() -- Cancel
			StopAnimTask(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
			unloadDrillSound()
			StopSound(soundId)
			destroyProp(DrillObject)
			unloadPtfxDict("core")
			unloadAnimDict(dict)
			IsDrilling = false
			isMining = false
		end, "miningdrill")
	else
		triggerNotify(nil, Loc[Config.Lan].error["no_drillbit"], nil) isMining = false return
	end
end)

RegisterNetEvent('jim-mining:MineOre:Pick', function(data)
	if isMining then return else isMining = true end -- Stop players from doubling up the event
	-- Anim Loading
	local dict = "amb@world_human_hammering@male@base"
	local anim = "base"
	loadAnimDict(tostring(dict))
	loadDrillSound()
	--Create Pickaxe and Attach
	local PickAxe = CreateObject(`prop_tool_pickaxe`, GetEntityCoords(PlayerPedId(), true), true, true, true)
	DisableCamCollisionForObject(PickAxe)
	DisableCamCollisionForEntity(PickAxe)
	AttachEntityToEntity(PickAxe, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.09, -0.53, -0.22, 252.0, 180.0, 0.0, false, true, true, true, 0, true)
	local IsDrilling = true
	local rockcoords = GetEntityCoords(data.stone)
	--Calculate if you're facing the stone--
	lookEnt(data.stone)
	if #(rockcoords - GetEntityCoords(PlayerPedId())) > 1.5 then TaskGoStraightToCoord(PlayerPedId(), rockcoords, 0.5, 400, 0.0, 0) Wait(400) end
	loadPtfxDict("core")
	CreateThread(function()
		while IsDrilling do
			UseParticleFxAssetNextCall("core")
			TaskPlayAnim(PlayerPedId(), tostring(dict), tostring(anim), 8.0, -8.0, -1, 2, 0, false, false, false)
			Wait(200)
			local pickcoords = GetOffsetFromEntityInWorldCoords(PickAxe, -0.4, 0.0, 0.7)
			local dust = StartNetworkedParticleFxNonLoopedAtCoord("ent_dst_rocks", pickcoords.x, pickcoords.y, pickcoords.z, 0.0, 0.0, 0.0, 0.4, 0.0, 0.0, 0.0)
			Wait(350)
		end
	end)
	QBCore.Functions.Progressbar("open_locker_drill", Loc[Config.Lan].info["drilling_ore"], Config.Timings["Pickaxe"], false, true, {
		disableMovement = true,	disableCarMovement = true, disableMouse = false, disableCombat = true, }, {}, {}, {}, function() -- Done
		StopAnimTask(PlayerPedId(), tostring(dict), tostring(anim), 1.0)
		destroyProp(PickAxe)
		unloadPtfxDict("core")
		unloadAnimDict(dict)
		TriggerServerEvent('jim-mining:MineReward')
		if math.random(1,10) >= 9 then
			local breakId = GetSoundId()
			PlaySoundFromEntity(breakId, "Drill_Pin_Break", PlayerPedId(), "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
			toggleItem(false, "pickaxe", 1)
		end
		unloadDrillSound()
		StopSound(soundId)
		IsDrilling = false
		isMining = false
		stoneBreak(data.name, data.stone)
	end, function() -- Cancel
		StopAnimTask(PlayerPedId(), tostring(dict), tostring(anim), 1.0)
		destroyProp(PickAxe)
		unloadPtfxDict("core")
		unloadAnimDict(dict)
		unloadDrillSound()
		StopSound(soundId)
		IsDrilling = false
		isMining = false
	end, "pickaxe")
end)

RegisterNetEvent('jim-mining:MineOre:Laser', function(data)
	if isMining then return else isMining = true end -- Stop players from doubling up the event
	-- Sounds & Anim Loading
	RequestAmbientAudioBank("DLC_HEIST_BIOLAB_DELIVER_EMP_SOUNDS", 0)
	RequestAmbientAudioBank("dlc_xm_silo_laser_hack_sounds", 0)
	local dict = "anim@heists@fleeca_bank@drilling"
	local anim = "drill_straight_fail"
	loadAnimDict(tostring(dict))
	--Create Drill and Attach
	local DrillObject = CreateObject(`ch_prop_laserdrill_01a`, GetEntityCoords(PlayerPedId(), true), true, true, true)
	AttachEntityToEntity(DrillObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.14, 0, -0.01, 90.0, -90.0, 180.0, true, true, false, true, 1, true)
	local IsDrilling = true
	local rockcoords = GetEntityCoords(data.stone)
	--Calculate if you're facing the stone--
	lookEnt(data.stone)
	--Activation noise & Anims
	TaskPlayAnim(PlayerPedId(), tostring(dict), 'drill_straight_idle' , 3.0, 3.0, -1, 1, 0, false, false, false)
	PlaySoundFromEntity(soundId, "Pass", DrillObject, "dlc_xm_silo_laser_hack_sounds", 1, 0) Wait(1000)
	TaskPlayAnim(PlayerPedId(), tostring(dict), tostring(anim), 3.0, 3.0, -1, 1, 0, false, false, false)
	PlaySoundFromEntity(soundId, "EMP_Vehicle_Hum", DrillObject, "DLC_HEIST_BIOLAB_DELIVER_EMP_SOUNDS", 1, 0) --Not sure about this sound, best one I could find as everything else wouldn't load
	--Laser & Debris Effect
	local lasercoords = GetOffsetFromEntityInWorldCoords(DrillObject, 0.0,-0.5, 0.02)
	CreateThread(function()
		loadPtfxDict("core")
		while IsDrilling do
			UseParticleFxAssetNextCall("core")
			local laser = StartNetworkedParticleFxNonLoopedAtCoord("muz_railgun", lasercoords.x, lasercoords.y, lasercoords.z, 0, -10.0, GetEntityHeading(DrillObject)+270, 1.0, 0.0, 0.0, 0.0)
			UseParticleFxAssetNextCall("core")
			local dust = StartNetworkedParticleFxNonLoopedAtCoord("ent_dst_rocks", rockcoords.x, rockcoords.y, rockcoords.z, 0.0, 0.0, GetEntityHeading(PlayerPedId())-180.0, 1.0, 0.0, 0.0, 0.0)
			Wait(60)
		end
	end)
	QBCore.Functions.Progressbar("open_locker_drill", Loc[Config.Lan].info["drilling_ore"], (Config.Timings["Laser"]), false, true, {
		disableMovement = true,	disableCarMovement = true, disableMouse = false, disableCombat = true, }, {}, {}, {}, function() -- Done
		IsDrilling = false
		isMining = false
		StopAnimTask(PlayerPedId(), tostring(dict), tostring(anim), 1.0)
		ReleaseAmbientAudioBank("DLC_HEIST_BIOLAB_DELIVER_EMP_SOUNDS")
		ReleaseAmbientAudioBank("dlc_xm_silo_laser_hack_sounds")
		StopSound(soundId)
		destroyProp(DrillObject)
		unloadPtfxDict("core")
		unloadAnimDict(dict)
		TriggerServerEvent('jim-mining:MineReward')
		stoneBreak(data.name, data.stone)
	end, function() -- Cancel
		IsDrilling = false
		isMining = false
		StopAnimTask(PlayerPedId(), tostring(dict), tostring(anim), 1.0)
		ReleaseAmbientAudioBank("DLC_HEIST_BIOLAB_DELIVER_EMP_SOUNDS")
		ReleaseAmbientAudioBank("dlc_xm_silo_laser_hack_sounds")
		StopSound(soundId)
		destroyProp(DrillObject)
		unloadPtfxDict("core")
		unloadAnimDict(dict)
		stoneBreak(data.name, data.stone)
		IsDrilling = false
		isMining = false
	end, "mininglaser")
end)
------------------------------------------------------------
-- Cracking Command / Animations
local Cracking = false
RegisterNetEvent('jim-mining:CrackStart', function(data)
	if Cracking then return end
	local cost = 1
	if HasItem("stone", cost) then
		Cracking = true
		LocalPlayer.state:set("inv_busy", true, true) TriggerEvent('inventory:client:busy:status', true) TriggerEvent('canUseInventoryAndHotbar:toggle', false)
		-- Sounds & Anim Loading
		local dict ="amb@prop_human_parking_meter@male@idle_a"
		local anim = "idle_a"
		loadAnimDict(dict)
		loadDrillSound()
		local benchcoords = GetOffsetFromEntityInWorldCoords(data.bench, 0.0, -0.2, 2.08)
		--Calculate if you're facing the bench--
		lookEnt(data.bench)
		if #(benchcoords - GetEntityCoords(PlayerPedId())) > 1.5 then TaskGoStraightToCoord(PlayerPedId(), benchcoords, 0.5, 400, 0.0, 0) Wait(400) end

		local Rock = CreateObject(`prop_rock_5_smash1`, vector3(benchcoords.x, benchcoords.y, benchcoords.z-1.03), true, true, true)
		PlaySoundFromCoord(soundId, "Drill", benchcoords, "DLC_HEIST_FLEECA_SOUNDSET", 0, 4.5, 0)
		loadPtfxDict("core")
		CreateThread(function()
			while Cracking do
				UseParticleFxAssetNextCall("core")
				local dust = StartNetworkedParticleFxNonLoopedAtCoord("ent_dst_rocks", benchcoords.x, benchcoords.y, benchcoords.z-0.9, 0.0, 0.0, 0.0, 0.2, 0.0, 0.0, 0.0)
				Wait(400)
			end
		end)
		TaskPlayAnim(PlayerPedId(), dict, anim, 3.0, 3.0, -1, 1, 0, false, false, false)
		QBCore.Functions.Progressbar("open_locker_drill", Loc[Config.Lan].info["cracking_stone"], Config.Timings["Cracking"], false, true, {
			disableMovement = true,	disableCarMovement = true, disableMouse = false, disableCombat = true, }, {}, {}, {}, function() -- Done
			StopAnimTask(PlayerPedId(), dict, anim, 1.0)
			unloadDrillSound()
			StopSound(soundId)
			unloadPtfxDict("core")
			unloadAnimDict(dict)
			destroyProp(Rock)
			TriggerServerEvent('jim-mining:CrackReward', cost)
			LocalPlayer.state:set("inv_busy", false, true) TriggerEvent('inventory:client:busy:status', false) TriggerEvent('canUseInventoryAndHotbar:toggle', true)
			Cracking = false
		end, function() -- Cancel
			StopAnimTask(PlayerPedId(), dict, anim, 1.0)
			unloadDrillSound()
			StopSound(soundId)
			unloadPtfxDict("core")
			unloadAnimDict(dict)
			destroyProp(Rock)
			LocalPlayer.state:set("inv_busy", false, true) TriggerEvent('inventory:client:busy:status', false) TriggerEvent('canUseInventoryAndHotbar:toggle', true)
			Cracking = false
		end, "stone")
	else
		triggerNotify(nil, Loc[Config.Lan].error["no_stone"], 'error')
	end
end)
------------------------------------------------------------
-- Washing Command / Animations
local Washing = false
RegisterNetEvent('jim-mining:WashStart', function(data)
	if Washing then return end
	local cost = 1
	if HasItem("stone", cost) then
		Washing = true
		LocalPlayer.state:set("inv_busy", true, true) TriggerEvent('inventory:client:busy:status', true) TriggerEvent('canUseInventoryAndHotbar:toggle', false)
		--Create Rock and Attach
		local Rock = CreateObject(`prop_rock_5_smash1`, GetEntityCoords(PlayerPedId()), true, true, true)
		local rockcoords = GetEntityCoords(Rock)
		AttachEntityToEntity(Rock, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.1, 0.0, 0.05, 90.0, -90.0, 90.0, true, true, false, true, 1, true)
		TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
		local water
		CreateThread(function()
			Wait(3000)
			loadPtfxDict("core")
			while Washing do
				UseParticleFxAssetNextCall("core")
				water = StartNetworkedParticleFxLoopedOnEntity("water_splash_veh_out", PlayerPedId(), 0.0, 1.0, -0.2, 0.0, 0.0, 0.0, 2.0, 0, 0, 0)
				Wait(500)
			end
		end)
		QBCore.Functions.Progressbar("open_locker_drill", Loc[Config.Lan].info["washing_stone"], Config.Timings["Washing"], false, true, {
			disableMovement = true,	disableCarMovement = true, disableMouse = false, disableCombat = true, }, {}, {}, {}, function() -- Done
			TriggerServerEvent('jim-mining:WashReward', cost)
			LocalPlayer.state:set("inv_busy", false, true) TriggerEvent('inventory:client:busy:status', false) TriggerEvent('canUseInventoryAndHotbar:toggle', true)
			StopParticleFxLooped(water, 0)
			destroyProp(Rock)
			unloadPtfxDict("core")
			Washing = false
		end, function() -- Cancel
			LocalPlayer.state:set("inv_busy", false, true) TriggerEvent('inventory:client:busy:status', false) TriggerEvent('canUseInventoryAndHotbar:toggle', true)
			StopParticleFxLooped(water, 0)
			destroyProp(Rock)
			unloadPtfxDict("core")
			Washing = false
		end, "stone")
	else
		triggerNotify(nil, Loc[Config.Lan].error["no_stone"], 'error')
	end
end)
------------------------------------------------------------
-- Gold Panning Command / Animations
local Panning = false
RegisterNetEvent('jim-mining:PanStart', function(data)
	if IsEntityInWater(PlayerPedId()) then
		if Panning then return else Panning = true end
		LocalPlayer.state:set("inv_busy", true, true) TriggerEvent('inventory:client:busy:status', true) TriggerEvent('canUseInventoryAndHotbar:toggle', false)
		--Create Rock and Attach
		local trayCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.5, -0.9)
		Props[#Props+1] = makeProp({ coords = vector4(trayCoords.x, trayCoords.y, trayCoords.z+1.03, GetEntityHeading(PlayerPedId())), prop = `bkr_prop_meth_tray_01b`} , 1, 1)
		CreateThread(function()
			loadPtfxDict("core")
			while Panning do
				UseParticleFxAssetNextCall("core")
				local water = StartNetworkedParticleFxLoopedOnEntity("water_splash_veh_out", Props[#Props], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 0, 0, 0)
				Wait(100)
			end
		end)
		--Start Anim
		TaskStartScenarioInPlace(PlayerPedId(), "CODE_HUMAN_MEDIC_KNEEL", 0, true)
		QBCore.Functions.Progressbar("open_locker_drill", Loc[Config.Lan].info["goldpanning"], Config.Timings["Panning"], false, true, {
			disableMovement = true,	disableCarMovement = true, disableMouse = false, disableCombat = true, }, {}, {}, {}, function() -- Done
			TriggerServerEvent('jim-mining:PanReward')
			ClearPedTasksImmediately(PlayerPedId())
			TaskGoStraightToCoord(PlayerPedId(), trayCoords, 4.0, 100, GetEntityHeading(PlayerPedId()), 0)
			destroyProp(Props[#Props])
			unloadPtfxDict("core")
			LocalPlayer.state:set("inv_busy", false, true) TriggerEvent('inventory:client:busy:status', false) TriggerEvent('canUseInventoryAndHotbar:toggle', true)
			Panning = false
		end, function() -- Cance
			ClearPedTasksImmediately(PlayerPedId())
			TaskGoStraightToCoord(PlayerPedId(), trayCoords, 4.0, 100, GetEntityHeading(PlayerPedId()), 0)
			destroyProp(Props[#Props])
			unloadPtfxDict("core")
			LocalPlayer.state:set("inv_busy", false, true) TriggerEvent('inventory:client:busy:status', false) TriggerEvent('canUseInventoryAndHotbar:toggle', true)
			Panning = false
		end, "goldpan")
	end
end)

RegisterNetEvent('jim-mining:MakeItem', function(data)
	if data.ret then
		if not HasItem("drillbit", 1) then triggerNotify(nil, Loc[Config.Lan].error["no_drillbit"], 'error') TriggerEvent('jim-mining:JewelCut') return end
	end
	itemProgress(data)
end)

function itemProgress(data)
	if data.craftable then
		if not data.ret then bartext = Loc[Config.Lan].info["smelting"]..QBCore.Shared.Items[data.item].label
		else bartext = Loc[Config.Lan].info["cutting"]..QBCore.Shared.Items[data.item].label end
	end
	LocalPlayer.state:set("inv_busy", true, true) TriggerEvent('inventory:client:busy:status', true) TriggerEvent('canUseInventoryAndHotbar:toggle', false)
	local isDrilling = true
	if data.ret then -- If jewelcutting
		local drillcoords
		local scene
		local dict = "anim@amb@machinery@speed_drill@"
		local anim = "operate_02_hi_amy_skater_01"
		loadAnimDict(tostring(dict))
		for _, v in pairs(Props) do
			if #(GetEntityCoords(v) - GetEntityCoords(PlayerPedId())) <= 2.0 and GetEntityModel(v) == `gr_prop_gr_speeddrill_01c` then
				loadDrillSound()
				PlaySoundFromEntity(soundId, "Drill", v, "DLC_HEIST_FLEECA_SOUNDSET", 0.5, 0)
				drillcoords = GetOffsetFromEntityInWorldCoords(v, 0.0, -0.15, 0.0)
				scene = NetworkCreateSynchronisedScene(GetEntityCoords(v), GetEntityRotation(v), 2, false, false, 1065353216, 0, 1.3)
				NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, tostring(dict), tostring(anim), 0, 0, 0, 16, 1148846080, 0)
				NetworkStartSynchronisedScene(scene)
				break
			end
		end
		CreateThread(function()
			loadPtfxDict("core")
			while isDrilling do
				UseParticleFxAssetNextCall("core")
				local dust = StartNetworkedParticleFxNonLoopedAtCoord("glass_side_window", drillcoords.x, drillcoords.y, drillcoords.z+1.1, 0.0, 0.0, GetEntityHeading(PlayerPedId())+math.random(0, 359), 0.2, 0.0, 0.0, 0.0)
				Wait(100)
			end
		end)
	else -- If not Jewel Cutting, you'd be smelting (need to work out what is possible for this)
		animDictNow = "amb@prop_human_parking_meter@male@idle_a"
		animNow = "idle_a"
	end
	QBCore.Functions.Progressbar('making_food', bartext, Config.Timings["Crafting"], false, true, { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true, },
	{ animDict = animDictNow, anim = animNow, flags = 8, }, {}, {}, function()
		TriggerServerEvent('jim-mining:GetItem', data)
		if data.ret then
			if math.random(1,10) >= 8 then
				local breakId = GetSoundId()
				PlaySoundFromEntity(breakId, "Drill_Pin_Break", PlayerPedId(), "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
				toggleItem(false, "drillbit", 1)
			end
		end
		LocalPlayer.state:set("inv_busy", false, true) TriggerEvent('inventory:client:busy:status', false) TriggerEvent('canUseInventoryAndHotbar:toggle', true)
		unloadDrillSound()
		StopSound(soundId)
		unloadPtfxDict("core")
		isDrilling = false
		NetworkStopSynchronisedScene(scene)
	end, function() -- Cancel
		triggerNotify(nil, Loc[Config.Lan].error["cancelled"], 'error')
		StopAnimTask(PlayerPedId(), animDictNow, animNow, 1.0)
		LocalPlayer.state:set("inv_busy", false, true) TriggerEvent('inventory:client:busy:status', false) TriggerEvent('canUseInventoryAndHotbar:toggle', true)
		unloadDrillSound()
		StopSound(soundId)
		unloadPtfxDict("core")
		unloadAnimDict(dict)
		isDrilling = false
		NetworkStopSynchronisedScene(scene)
	end, data.item)
end
------------------------------------------------------------
--Selling animations are simply a pass item to seller animation
RegisterNetEvent('jim-mining:SellAnim', function(data)
	if not HasItem(data.item, 1) then triggerNotify(nil, Loc[Config.Lan].error["dont_have"].." "..QBCore.Shared.Items[data.item].label, "error") return end
	loadAnimDict("mp_common")
	TriggerServerEvent('jim-mining:Selling', data) -- Had to slip in the sell command during the animation command
	loadAnimDict("mp_common")
	lookEnt(data.ped)
	TaskPlayAnim(PlayerPedId(), "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 1, 0.2, 0, 0, 0)	--Start animations
	TaskPlayAnim(data.ped, "mp_common", "givetake2_b", 100.0, 200.0, 0.3, 1, 0.2, 0, 0, 0)
	Wait(2000)
	StopAnimTask(PlayerPedId(), "mp_common", "givetake2_a", 1.0)
	StopAnimTask(data.ped, "mp_common", "givetake2_b", 1.0)
	unloadAnimDict("mp_common")
	if data.sub then TriggerEvent('jim-mining:JewelSell:Sub', { sub = data.sub, ped = data.ped }) return
	else TriggerEvent('jim-mining:SellOre', data) return end
end)

------------------------------------------------------------
RegisterNetEvent('jim-mining:SellOre', function(data)
	local list = {"goldingot", "silveringot", "copperore", "ironore", "goldore", "silverore", "carbon"}
	local sellMenu = {
		{ header = Loc[Config.Lan].info["header_oresell"], txt = Loc[Config.Lan].info["oresell_txt"], isMenuHeader = true },
		{ icon = "fas fa-circle-xmark", header = "", txt = Loc[Config.Lan].info["close"], params = { event = "jim-mining:CraftMenu:Close" } } }
	for _, v in pairs(list) do
		local setheader = "<img src=nui://"..Config.img..QBCore.Shared.Items[v].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items[v].label
		local disable = true
		if HasItem(v, 1) then setheader = setheader.." 💰" disable = false end
			sellMenu[#sellMenu+1] = { icon = v, disabled = disable, header = setheader, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems[v].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim", args = { item = v, ped = data.ped } } }
		Wait(0)
	end
	exports['qb-menu']:openMenu(sellMenu)
end)
------------------------
--Jewel Selling Main Menu
RegisterNetEvent('jim-mining:JewelSell', function(data)
    exports['qb-menu']:openMenu({
		{ header = Loc[Config.Lan].info["jewel_buyer"], txt = Loc[Config.Lan].info["sell_jewel"], isMenuHeader = true },
		{ icon = "fas fa-circle-xmark", header = "", txt = Loc[Config.Lan].info["close"], params = { event = "jim-mining:CraftMenu:Close" } },
		{ header = QBCore.Shared.Items["emerald"].label, txt = Loc[Config.Lan].info["see_options"], params = { event = "jim-mining:JewelSell:Sub", args = { sub = "emerald", ped = data.ped } } },
		{ header = QBCore.Shared.Items["ruby"].label, txt = Loc[Config.Lan].info["see_options"], params = { event = "jim-mining:JewelSell:Sub", args = { sub = "ruby", ped = data.ped } } },
		{ header = QBCore.Shared.Items["diamond"].label, txt = Loc[Config.Lan].info["see_options"], params = { event = "jim-mining:JewelSell:Sub", args = { sub = "diamond", ped = data.ped } } },
		{ header = QBCore.Shared.Items["sapphire"].label, txt = Loc[Config.Lan].info["see_options"], params = { event = "jim-mining:JewelSell:Sub", args = { sub = "sapphire", ped = data.ped } } },
		{ header = Loc[Config.Lan].info["rings"], txt = Loc[Config.Lan].info["see_options"], params = { event = "jim-mining:JewelSell:Sub", args = { sub = "rings", ped = data.ped } } },
		{ header = Loc[Config.Lan].info["necklaces"], txt = Loc[Config.Lan].info["see_options"], params = { event = "jim-mining:JewelSell:Sub", args = { sub = "necklaces", ped = data.ped } } },
		{ header = Loc[Config.Lan].info["earrings"], txt = Loc[Config.Lan].info["see_options"], params = { event = "jim-mining:JewelSell:Sub", args = { sub = "earrings", ped = data.ped } } },
	})
end)
--Jewel Selling - Sub Menu Controller
RegisterNetEvent('jim-mining:JewelSell:Sub', function(data)
	local list = {}
	local sellMenu = {
		{ header = Loc[Config.Lan].info["jewel_buyer"], txt = Loc[Config.Lan].info["sell_jewel"], isMenuHeader = true },
		{ icon = "fas fa-circle-arrow-left", header = "", txt = Loc[Config.Lan].info["return"], params = { event = "jim-mining:JewelSell", args = data } }, }
	if data.sub == "emerald" then list = {"emerald", "uncut_emerald"} end
	if data.sub == "ruby" then list = {"ruby", "uncut_ruby"} end
	if data.sub == "diamond" then list = {"diamond", "uncut_diamond"} end
	if data.sub == "sapphire" then list = {"sapphire", "uncut_sapphire"} end
	if data.sub == "rings" then list = {"gold_ring", "silver_ring", "diamond_ring", "emerald_ring", "ruby_ring", "sapphire_ring", "diamond_ring_silver", "emerald_ring_silver", "ruby_ring_silver", "sapphire_ring_silver"} end
	if data.sub == "necklaces" then list = {"goldchain", "silverchain", "diamond_necklace", "emerald_necklace", "ruby_necklace", "sapphire_necklace", "diamond_necklace_silver", "emerald_necklace_silver", "ruby_necklace_silver", "sapphire_necklace_silver"} end
	if data.sub == "earrings" then list = {"goldearring", "silverearring", "diamond_earring", "emerald_earring", "ruby_earring", "sapphire_earring", "diamond_earring_silver", "emerald_earring_silver", "ruby_earring_silver", "sapphire_earring_silver"} end
	for _, v in pairs(list) do
		local disable = true
		local setheader = "<img src=nui://"..Config.img..QBCore.Shared.Items[v].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items[v].label
		if HasItem(v, 1) then setheader = setheader.." 💰" disable = false end
		sellMenu[#sellMenu+1] = { disabled = disable, icon = v, header = setheader, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems[v].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim", args = { item = v, sub = data.sub, ped = data.ped } } }
		Wait(0)
	end
	exports['qb-menu']:openMenu(sellMenu)
end)
--Cutting Jewels
RegisterNetEvent('jim-mining:JewelCut', function()
    exports['qb-menu']:openMenu({
	{ header = Loc[Config.Lan].info["craft_bench"], txt = Loc[Config.Lan].info["req_drill_bit"], isMenuHeader = true },
	{ icon = "fas fa-circle-xmark", header = "", txt = Loc[Config.Lan].info["close"], params = { event = "jim-mining:CraftMenu:Close" } },
	{ header = Loc[Config.Lan].info["gem_cut"],	txt = Loc[Config.Lan].info["gem_cut_section"], params = { event = "jim-mining:CraftMenu", args = { craftable = Crafting.GemCut, ret = true  } } },
	{ header = Loc[Config.Lan].info["make_ring"], txt = Loc[Config.Lan].info["ring_craft_section"], params = { event = "jim-mining:CraftMenu", args = { craftable = Crafting.RingCut, ret = true  } } },
	{ header = Loc[Config.Lan].info["make_neck"], txt = Loc[Config.Lan].info["neck_craft_section"], params = { event = "jim-mining:CraftMenu", args = { craftable = Crafting.NeckCut, ret = true } } },
	{ header = Loc[Config.Lan].info["make_ear"], txt = Loc[Config.Lan].info["ear_craft_section"], params = { event = "jim-mining:CraftMenu", args = { craftable = Crafting.EarCut, ret = true } } },
	})
end)

RegisterNetEvent('jim-mining:CraftMenu', function(data)
	local CraftMenu = {}
	if data.ret then
		CraftMenu[#CraftMenu + 1] = { header = Loc[Config.Lan].info["craft_bench"], txt = Loc[Config.Lan].info["req_drill_bit"], isMenuHeader = true }
		CraftMenu[#CraftMenu + 1] = { icon = "fas fa-circle-arrow-left", header = "", txt = Loc[Config.Lan].info["return"], params = { event = "jim-mining:JewelCut" } }
	else
		CraftMenu[#CraftMenu + 1] = { header = Loc[Config.Lan].info["smelter"], txt = Loc[Config.Lan].info["smelt_ores"], isMenuHeader = true }
		CraftMenu[#CraftMenu + 1] = { icon = "fas fa-circle-xmark", header = "", txt = Loc[Config.Lan].info["close"], params = { event = "jim-mining:CraftMenu:Close" } }
	end
		for i = 1, #data.craftable do
			for k in pairs(data.craftable[i]) do
				if k ~= "amount" then
					local text = ""
					if data.craftable[i]["amount"] then amount = " x"..data.craftable[i]["amount"] else amount = "" end
					setheader = "<img src=nui://"..Config.img..QBCore.Shared.Items[k].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items[k].label..tostring(amount)
					local disable = false
					local checktable = {}
					for l, b in pairs(data.craftable[i][tostring(k)]) do
						if b == 1 then number = "" else number = " x"..b end
						text = text.."- "..QBCore.Shared.Items[l].label..number.."<br>"
						settext = text
						checktable[l] = HasItem(l, b)
					end
					for _, v in pairs(checktable) do if v == false then disable = true break end end
					if not disable then setheader = setheader.." ✔️" end
					CraftMenu[#CraftMenu + 1] = { isMenuHeader = disable, icon = k, header = setheader, txt = settext, params = { event = "jim-mining:MakeItem", args = { item = k, tablenumber = i, craftable = data.craftable, ret = data.ret } } }
					settext, amount, setheader = nil
				end
			end
		end
	exports['qb-menu']:openMenu(CraftMenu)
end)

AddEventHandler('onResourceStop', function(resource) if resource == GetCurrentResourceName() then removeJob() end end)