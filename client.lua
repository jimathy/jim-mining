local QBCore = exports['qb-core']:GetCoreObject()

local PlayerJob = {}
local Props = {}
local Targets = {}
local Peds = {}
local Blip = {}

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
	QBCore.Functions.GetPlayerData(function(PlayerData)	PlayerJob = PlayerData.job end)
	if Config.Job then if PlayerJob.name == Config.Job then makeJob() else removeJob() end else makeJob() end
end)
RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
	PlayerJob = JobInfo
	if Config.Job then if PlayerJob.name == Config.Job then makeJob() else removeJob() end else makeJob() end
end)

AddEventHandler('onResourceStart', function(resource) if GetCurrentResourceName() ~= resource then return end
	QBCore.Functions.GetPlayerData(function(PlayerData) PlayerJob = PlayerData.job end)
	if Config.Job then if PlayerJob.name == Config.Job then makeJob() else removeJob() end else makeJob() end
end)

function makePed(data, name)
	RequestModel(data.model) 
	while not HasModelLoaded(data.model) do Wait(0) end
	Peds[#Peds+1] = CreatePed(0, data.model, data.coords.x, data.coords.y, data.coords.z-1.03, data.coords[4], false, false)
	SetEntityInvincible(Peds[#Peds], true)
	SetBlockingOfNonTemporaryEvents(Peds[#Peds], true)
	FreezeEntityPosition(Peds[#Peds], true)
	TaskStartScenarioInPlace(Peds[#Peds], data.scenario, 0, true)
	if Config.Debug then print("Ped Created for location: '"..name.."'") end
end

function makeBlip(data)
	Blip[#Blip+1] = AddBlipForCoord(data.coords)
	SetBlipAsShortRange(Blip[#Blip], true)
	SetBlipSprite(Blip[#Blip], data.sprite)
	SetBlipColour(Blip[#Blip], data.col)
	SetBlipScale(Blip[#Blip], 0.7)
	SetBlipDisplay(Blip[#Blip], 6)
	BeginTextCommandSetBlipName('STRING')
	if Config.BlipNamer then AddTextComponentString(data.name)
	else AddTextComponentString(tostring(data.name)) end
	EndTextCommandSetBlipName(Blip[#Blip])
	if Config.Debug then print("Blip created for location: '"..data.name.."'") end
end

function makeProp(data, name)
	RequestModel(data.prop)
	while not HasModelLoaded(data.prop) do Citizen.Wait(1) end	
	Props[#Props+1] = CreateObject(data.prop, vector3(data.coords.x, data.coords.y, data.coords.z-1.03), false, false, false)
	SetEntityHeading(Props[#Props], data.coords[4]-180.0)
	FreezeEntityPosition(Props[#Props], true)
	if Config.Debug then print("Prop Created for location: '"..name.."'") end
end

CreateModelHide(vector3(-596.04, 2089.01, 131.41), 10.5, -1241212535, true)

function removeJob()
	for k, v in pairs(Targets) do exports['qb-target']:RemoveZone(k) end		
	for k, v in pairs(Peds) do DeletePed(Peds[k]) end
	for i = 1, #Props do DeleteObject(Props[i]) end
	for i = 1, #Blip do RemoveBlip(Blip[i]) end
end

function makeJob()
	--Hide the mineshaft doors

	if Config.propSpawn then
		--Quickly add outside lighting
		makeProp({coords = vector4(-593.29, 2093.22, 131.7, 110.0), prop = `prop_worklight_02a`}, "WorkLight 1") -- Mineshaft door
		makeProp({coords = vector4(-604.55, 2089.74, 131.15, 300.0), prop = `prop_worklight_02a`}, "WorkLight 2") -- Mineshaft door 2
		makeProp({coords = vector4(2991.59, 2758.07, 42.68, 250.85), prop = `prop_worklight_02a`}, "WorkLight 3") -- Quarry Light 
		makeProp({coords = vector4(2991.11, 2758.02, 42.66, 194.6), prop = `prop_worklight_02a`}, "WorkLight 4") -- Quarry Light 
		makeProp({coords = vector4(2971.78, 2743.33, 43.29, 258.54), prop = `prop_worklight_02a`}, "WorkLight 5") -- Quarry Light 
		makeProp({coords = vector4(3000.72, 2777.08, 43.08, 211.7), prop = `prop_worklight_02a`}, "WorkLight 6") -- Quarry Light 
		makeProp({coords = vector4(2998.0, 2767.45, 42.71, 249.22), prop = `prop_worklight_02a`}, "WorkLight 7") -- Quarry Light 
		makeProp({coords = vector4(2959.93, 2755.26, 43.71, 164.24), prop = `prop_worklight_02a`}, "WorkLight 8") -- Quarry Light 
		makeProp({coords = vector4(1106.46, -1991.44, 31.49, 185.78), prop = `prop_worklight_02a`}, "WorkLight 9") -- Foundary Light
		if Config.HangingLights then
			for k, v in pairs(Config.MineLights) do
				if Config.propSpawn then makeProp({coords = v.coords, prop = `xs_prop_arena_lights_ceiling_l_c`}, "Light"..k) end
			end
		end
		if not Config.HangingLights then
			for k, v in pairs(Config.WorkLights) do
				if Config.propSpawn then makeProp({coords = v.coords, prop = `prop_worklight_03a`}, "Light"..k) end
			end
		end
	end
	
	for k, v in pairs(Config.Locations["MineStore"]) do
		local name = "Mine"..k
		Targets[name] =
		exports['qb-target']:AddCircleZone(name, vector3(v.coords.x, v.coords.y, v.coords.z), 1.0, { name=name, debugPoly=Config.Debug, useZ=true, }, 
		{ options = { { event = "jim-mining:openShop", icon = "fas fa-certificate", label = Loc[Config.Lan].info["browse_store"], job = Config.Job }, }, 
			distance = 2.0 })
		if Config.Blips and v.blipTrue then makeBlip(v) end
		if Config.pedSpawn then makePed(v, "MineStore") end
	end
	--Smelter to turn stone into ore
	for k, v in pairs(Config.Locations["Smelter"]) do
		local name = "Smelter"..k
		Targets[name] =
		exports['qb-target']:AddCircleZone(name, vector3(v.coords.x, v.coords.y, v.coords.z), 3.0, { name=name, debugPoly=Config.Debug, useZ=true, }, 
		{ options = { { event = "jim-mining:CraftMenu", icon = "fas fa-certificate", label = Loc[Config.Lan].info["use_smelter"], craftable = Crafting.SmeltMenu, job = Config.Job }, },
			distance = 10.0
		})
		if Config.Blips and v.blipTrue then makeBlip(v) end
	end
	--Ore Buying Ped
	for k, v in pairs(Config.Locations["OreBuyer"]) do
		local name = "OreBuyer"..k
		Targets[name] = 
			exports['qb-target']:AddCircleZone(name, vector3(v.coords.x, v.coords.y, v.coords.z), 0.9, { name=name, debugPoly=Config.Debug, useZ=true, }, 
			{ options = { { event = "jim-mining:SellOre", icon = "fas fa-certificate", label = Loc[Config.Lan].info["sell_ores"], job = Config.Job }, },
				distance = 2.0
			})
		if Config.pedSpawn then	makePed(v, name) end
		if Config.Blips and v.blipTrue then makeBlip(v) end
	end
	
	--Jewel Cutting Bench
	for k, v in pairs(Config.Locations["JewelCut"]) do
		local name = "JewelCut"..k
		Targets[name] =
		exports['qb-target']:AddCircleZone(name, vector3(v.coords.x, v.coords.y, v.coords.z), 2.0,{ name=name, debugPoly=Config.Debug, useZ=true, }, 
		{ options = { { event = "jim-mining:JewelCut", icon = "fas fa-certificate", label = Loc[Config.Lan].info["jewelcut"], job = Config.Job }, },
			distance = 2.0
		})
		if Config.propSpawn then makeProp(v, name) end
		if Config.Blips and v.blipTrue then makeBlip(v) end
	end
	--Cracking Bench
	for k, v in pairs(Config.Locations["Cracking"]) do
		local name = "Cracking"..k
		Targets[name] =
			exports['qb-target']:AddCircleZone(name, vector3(v.coords.x, v.coords.y, v.coords.z), 1.2, {name=name, debugPoly=Config.Debug, useZ=true, }, 
			{ options = { { event = "jim-mining:CrackStart", icon = "fas fa-certificate", item = "stone", label = Loc[Config.Lan].info["crackingbench"], coords = v.coords }, },
				distance = 2.0
			})
		if Config.propSpawn then makeProp(v, name) end
		if Config.Blips and v.blipTrue then makeBlip(v) end
	end
	
	--Stone Washing
	for k, v in pairs(Config.Locations["Washing"]) do
		local name = "Washing"..k
		Targets[name] =
			exports['qb-target']:AddCircleZone(name, vector3(v.coords.x, v.coords.y, v.coords.z), 9.0, {name=name, debugPoly=Config.Debug, useZ=true, }, 
			{ options = { { event = "jim-mining:WashStart", icon = "fas fa-certificate", item = "stone", label = Loc[Config.Lan].info["washstone"], coords = v.coords }, },
				distance = 2.0
			})
		if Config.Blips and v.blipTrue then makeBlip(v) end
	end	
	
	--Panning
	for k, v in pairs(Config.Locations["Panning"]) do
		local name = "Panning"..k
		Targets[name] =
			exports['qb-target']:AddCircleZone(name, vector3(v.coords.x, v.coords.y, v.coords.z), 9.0, {name=name, debugPoly=Config.Debug, useZ=true, }, 
			{ options = { { event = "jim-mining:PanStart", icon = "fas fa-certificate", label = Loc[Config.Lan].info["goldpan"], coords = v.coords }, },
				distance = 2.0
			})
		if Config.Blips and v.blipTrue then makeBlip(v) end
	end
	
	
	for k, v in pairs(Config.Locations["JewelBuyer"]) do
		local name = "JewelBuyer"..k
		Targets[name] = 
			exports['qb-target']:AddCircleZone(name, vector3(v.coords.x, v.coords.y, v.coords.z), 1.2, { name=name, debugPoly=Config.Debug, useZ=true, }, 
			{ options = { { event = "jim-mining:JewelSell", icon = "fas fa-certificate", label = Loc[Config.Lan].info["jewelbuyer"], job = Config.Job }, },
				distance = 2.0
			})
		if Config.pedSpawn then	makePed(v, name) end
	end

	for k,v in pairs(Config.OrePositions) do
		local name = "Ore"..k
		Targets[name] =
		exports['qb-target']:AddCircleZone(name, vector3(v.coords.x, v.coords.y, v.coords.z-1.03), 1.2, { name=name, debugPoly=Config.Debug, useZ=true, }, 
		{ options = { { event = "jim-mining:MineOre", icon = "fas fa-certificate", label = Loc[Config.Lan].info["mine_ore"], job = Config.Job, name = name , coords = v.coords }, },
			distance = 1.0
		})
		if Config.propSpawn then makeProp({coords = v.coords, prop = `cs_x_rubweec`}, "Ore"..k)
								 makeProp({coords = v.coords, prop = `prop_rock_5_a`}, "OreDead"..k) end
	end
end

--------------------------------------------------------
--Mining Store Opening
RegisterNetEvent('jim-mining:openShop', function() 
	if Config.JimShops then 
		TriggerServerEvent("jim-shops:ShopOpen", "shop", "mine", Config.Items)
	else
		TriggerServerEvent("inventory:server:OpenInventory", "shop", "mine", Config.Items)
	end
end)
------------------------------------------------------------
-- Mine Ore Command / Animations

function loadAnimDict(dict) while not HasAnimDictLoaded(dict) do RequestAnimDict(dict) Wait(5) end end 

RegisterNetEvent('jim-mining:MineOre', function(data)
	local p = promise.new()	QBCore.Functions.TriggerCallback("QBCore:HasItem", function(cb) p:resolve(cb) end, "miningdrill")
	if Citizen.Await(p) then
		Wait(10)
		local p2 = promise.new() QBCore.Functions.TriggerCallback("QBCore:HasItem", function(cb) p2:resolve(cb) end, "drillbit")
		if Citizen.Await(p2) then
			-- Sounds
			RequestAmbientAudioBank("DLC_HEIST_FLEECA_SOUNDSET", 0)
			RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL", 0)
			RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2", 0)
			soundId = GetSoundId()
			
			loadAnimDict("anim@heists@fleeca_bank@drilling")
			TaskPlayAnim(PlayerPedId(), 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle' , 3.0, 3.0, -1, 1, 0, false, false, false)
			local pos = GetEntityCoords(PlayerPedId(), true)
			local DrillObject = CreateObject(`hei_prop_heist_drill`, pos.x, pos.y, pos.z+0.5, true, true, true)
			AttachEntityToEntity(DrillObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.14, 0, -0.01, 90.0, -90.0, 180.0, true, true, false, true, 1, true)
			PlaySoundFromEntity(soundId, "Drill", DrillObject, "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
			local IsDrilling = true
			local drillcoords
			for k, v in pairs(Props) do
				if GetEntityModel(v) == `cs_x_rubweec` and #(GetEntityCoords(v) - GetEntityCoords(PlayerPedId())) <= 3.0 then
					drillcoords = GetOffsetFromEntityInWorldCoords(v, 0.0, 0.0, 0.0)
					break
				end
			end
			CreateThread(function()
				while IsDrilling do
					RequestNamedPtfxAsset("core")
					while not HasNamedPtfxAssetLoaded("core") do Citizen.Wait(10) end
					local heading = GetEntityHeading(PlayerPedId())
					UseParticleFxAssetNextCall("core")
					SetParticleFxNonLoopedColour(150 / 255, 150 / 255, 150 / 255)
					SetParticleFxNonLoopedAlpha(1.0)
					local dust = StartNetworkedParticleFxNonLoopedAtCoord("ent_dst_rocks", drillcoords.x, drillcoords.y, drillcoords.z, 0.0, 0.0, heading-180.0, 1.0, 0.0, 0.0, 0.0)
					Wait(600)
				end
			end)
			QBCore.Functions.Progressbar("open_locker_drill", Loc[Config.Lan].info["drilling_ore"], Config.Timings["Mining"], false, true, {
				disableMovement = true,	disableCarMovement = true, disableMouse = false, disableCombat = true, }, {}, {}, {}, function() -- Done
				StopAnimTask(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
				SetEntityAsMissionEntity(DrillObject)--nessesary for gta to even trigger DetachEntity
				StopSound(soundId)
				Wait(5)
				DetachEntity(DrillObject, true, true)
				Wait(5)
				DeleteObject(DrillObject)
				TriggerServerEvent('jim-mining:MineReward')
				IsDrilling = false
				
				if math.random(1,10) >= 8 then
					local breakId = GetSoundId()
					PlaySoundFromEntity(breakId, "Drill_Pin_Break", PlayerPedId(), "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
					TriggerServerEvent("QBCore:Server:RemoveItem", "drillbit", 1)
					TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items['drillbit'], 'remove', 1)
				end		
				
				--Hide stone + target
				CreateModelHide(drillcoords, 2.0, `cs_x_rubweec`, true)
				exports['qb-target']:RemoveZone(data.name) Targets[data.name] = nil
				
				Wait(Config.Timings["OreRespawn"])
				--Unhide Stone and create a new target location
				RemoveModelHide(drillcoords, 2.0, `cs_x_rubweec`, false)
				Targets[data.name] =
					exports['qb-target']:AddCircleZone(data.name, vector3(data.coords.x, data.coords.y, data.coords.z-1.03), 1.2, { name=data.name, debugPoly=Config.Debug, useZ=true, }, 
					{ options = { { event = "jim-mining:MineOre", icon = "fas fa-certificate", label = Loc[Config.Lan].info["mine_ore"], job = Config.Job, name = data.name, coords = data.coords }, },
						distance = 2.2
					})
					

			end, function() -- Cancel
				StopAnimTask(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
				StopSound(soundId)
				DetachEntity(DrillObject, true, true)
				Wait(5)
				DeleteObject(DrillObject)
				IsDrilling = false
			end, "miningdrill")
		else
			TriggerEvent('QBCore:Notify', Loc[Config.Lan].error["no_drillbit"], 'error') return
		end
	else
		TriggerEvent('QBCore:Notify', Loc[Config.Lan].error["no_drill"], 'error') return
	end
end)

------------------------------------------------------------

-- Cracking Command / Animations
-- Command Starts here where it calls to being the stone inv checking
local Cracking = false
RegisterNetEvent('jim-mining:CrackStart', function(data)
	if not Cracking then
		local p = promise.new()	QBCore.Functions.TriggerCallback("QBCore:HasItem", function(cb) p:resolve(cb) end, "stone")
		if Citizen.Await(p) then
			Cracking = true
			local pos = GetEntityCoords(PlayerPedId())
			loadAnimDict('amb@prop_human_parking_meter@male@idle_a')
			local benchcoords
			local isDrilling = true
			for k, v in pairs(Props) do
				if #(GetEntityCoords(v) - GetEntityCoords(PlayerPedId())) <= 2.0 and GetEntityModel(v) == `prop_vertdrill_01` then
					benchcoords = GetOffsetFromEntityInWorldCoords(v, 0.0, -0.2, 2.08)
					RequestAmbientAudioBank("DLC_HEIST_FLEECA_SOUNDSET", 0)
					RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL", 0)
					RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2", 0)
					soundId = GetSoundId()
					PlaySoundFromEntity(soundId, "Drill", v, "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
				end
			end
			
			makeProp({coords = vector4(benchcoords.x, benchcoords.y, benchcoords.z, data.coords[4]+90.0), prop = `prop_rock_5_smash1`}, "tempRock") -- Make Stone
					
			CreateThread(function()
				while isDrilling do
					RequestNamedPtfxAsset("core")
					while not HasNamedPtfxAssetLoaded("core") do Citizen.Wait(10) end
					local heading = GetEntityHeading(PlayerPedId())
					UseParticleFxAssetNextCall("core")
					local dust = StartNetworkedParticleFxNonLoopedAtCoord("ent_dst_rocks", benchcoords.x, benchcoords.y, benchcoords.z-0.9, 0.0, 0.0, 0.0, 0.2, 0.0, 0.0, 0.0)
					Wait(400)
				end
			end)
			
			TaskPlayAnim(PlayerPedId(), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a' , 3.0, 3.0, -1, 1, 0, false, false, false)
			LocalPlayer.state:set("inv_busy", true, true)
			QBCore.Functions.Progressbar("open_locker_drill", Loc[Config.Lan].info["cracking_stone"], Config.Timings["Cracking"], false, true, {
				disableMovement = true,	disableCarMovement = true, disableMouse = false, disableCombat = true, }, {}, {}, {}, function() -- Done
				StopAnimTask(PlayerPedId(), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 1.0)
				
				TriggerServerEvent('jim-mining:CrackReward')
				
				DeleteObject(Props[#Props])
				LocalPlayer.state:set("inv_busy", false, true)
				StopSound(soundId)
				isDrilling = false
				Cracking = false
			end, function() -- Cancel
				StopAnimTask(PlayerPedId(), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 1.0)
				DeleteObject(Props[#Props])
				LocalPlayer.state:set("inv_busy", false, true)
				StopSound(soundId)
				isDrilling = false
				Cracking = false
			end, "stone")
		else 
			TriggerEvent('QBCore:Notify', Loc[Config.Lan].error["no_stone"], 'error')
		end
	end
end)

------------------------------------------------------------

-- Cracking Command / Animations
-- Command Starts here where it calls to being the stone inv checking
local Washing = false
RegisterNetEvent('jim-mining:WashStart', function(data)
	if not Washing then
	 	--if IsEntityInWater(PlayerPedId()) then
			local p = promise.new()	QBCore.Functions.TriggerCallback("QBCore:HasItem", function(cb) p:resolve(cb) end, "stone")
			if Citizen.Await(p) then
				Washing = true
				local pos = GetEntityCoords(PlayerPedId())
				loadAnimDict('amb@prop_human_parking_meter@male@idle_a')
				local benchcoords
				local isWashing = true
				
				local Rock = CreateObject(`prop_rock_5_smash1`, pos.x, pos.y, pos.z+0.5, true, true, true)
				AttachEntityToEntity(Rock, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.1, 0.0, 0.05, 90.0, -90.0, 90.0, true, true, false, true, 1, true)
				local water
				CreateThread(function()
					Wait(3000)
					while isWashing do
						RequestNamedPtfxAsset("core")
						while not HasNamedPtfxAssetLoaded("core") do Citizen.Wait(10) end
						local heading = GetEntityHeading(PlayerPedId())
						UseParticleFxAssetNextCall("core")
						local direction = math.random(0, 359)
						water = StartNetworkedParticleFxLoopedOnEntity("water_splash_veh_out", PlayerPedId(), 0.0, 1.0, -0.2, 0.0, 0.0, 0.0, 2.0, 0, 0, 0)
						Wait(500)
					end		
				end)
				TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
				LocalPlayer.state:set("inv_busy", true, true)
				QBCore.Functions.Progressbar("open_locker_drill", Loc[Config.Lan].info["washing_stone"], Config.Timings["Washing"], false, true, {
					disableMovement = true,	disableCarMovement = true, disableMouse = false, disableCombat = true, }, {}, {}, {}, function() -- Done
					TriggerServerEvent('jim-mining:WashReward')
					LocalPlayer.state:set("inv_busy", false, true)
					StopSound(soundId)
					StopParticleFxLooped(water, 0)
					DetachEntity(Rock, true, true)
					Wait(5)
					DeleteObject(Rock)
					
					ClearPedTasksImmediately(PlayerPedId())
					TaskGoStraightToCoord(PlayerPedId(), trayCoords, 4.0, 100, GetEntityHeading(PlayerPedId()), 0)
					
					isWashing = false
					Washing = false
				end, function() -- Cancel
					LocalPlayer.state:set("inv_busy", false, true)
					StopSound(soundId)
					StopParticleFxLooped(water, 0)
					DetachEntity(Rock, true, true)
					Wait(5)
					DeleteObject(Rock)
					
					ClearPedTasksImmediately(PlayerPedId())
					TaskGoStraightToCoord(PlayerPedId(), trayCoords, 4.0, 100, GetEntityHeading(PlayerPedId()), 0)
					
					isWashing = false
					Washing = false
				end, "stone")
			else 
				TriggerEvent('QBCore:Notify', Loc[Config.Lan].error["no_stone"], 'error')
			end
		--end
	end
end)

------------------------------------------------------------

-- Cracking Command / Animations
-- Command Starts here where it calls to being the stone inv checking
local Panning = false
RegisterNetEvent('jim-mining:PanStart', function(data)
	if not Panning then
	 	if IsEntityInWater(PlayerPedId()) then
			local p = promise.new()	QBCore.Functions.TriggerCallback("QBCore:HasItem", function(cb) p:resolve(cb) end, "goldpan")
			if Citizen.Await(p) then
				Panning = true
				
				loadAnimDict('amb@prop_human_parking_meter@male@idle_a')
				local benchcoords
				local isPanning = true
				
				local trayCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.5, -0.85)

				local water
				makeProp({ coords = vector4(trayCoords.x, trayCoords.y, trayCoords.z+1.03, GetEntityHeading(PlayerPedId())), prop = `v_res_r_silvrtray`} , "tray")
				CreateThread(function()
					while isPanning do
						RequestNamedPtfxAsset("core")
						while not HasNamedPtfxAssetLoaded("core") do Citizen.Wait(10) end
						local heading = GetEntityHeading(PlayerPedId())
						UseParticleFxAssetNextCall("core")
						local direction = math.random(0, 359)
						water = StartNetworkedParticleFxLoopedOnEntity("water_splash_veh_out", Props[#Props], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 0, 0, 0)
						Wait(100)
					end		
				end)
				
				TaskStartScenarioInPlace(PlayerPedId(), "CODE_HUMAN_MEDIC_KNEEL", 0, true)

				LocalPlayer.state:set("inv_busy", true, true)
				
				QBCore.Functions.Progressbar("open_locker_drill", Loc[Config.Lan].info["goldpanning"], Config.Timings["Panning"], false, true, {
					disableMovement = true,	disableCarMovement = true, disableMouse = false, disableCombat = true, }, {}, {}, {}, function() -- Done
					StopAnimTask(PlayerPedId(), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 1.0)
					TriggerServerEvent('jim-mining:PanReward')
					
					ClearPedTasksImmediately(PlayerPedId())
					TaskGoStraightToCoord(PlayerPedId(), trayCoords, 4.0, 100, GetEntityHeading(PlayerPedId()), 0)
					
					DeleteObject(Props[#Props])
					LocalPlayer.state:set("inv_busy", false, true)
					isPanning = false
					Panning = false
				end, function() -- Cancel
					StopAnimTask(PlayerPedId(), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 1.0)
					DeleteObject(Props[#Props])
					ClearPedTasksImmediately(PlayerPedId())					
					TaskGoStraightToCoord(PlayerPedId(), trayCoords, 4.0, 100, GetEntityHeading(PlayerPedId()), 0)
					LocalPlayer.state:set("inv_busy", false, true)
					isPanning = false
					Panning = false
				end, "goldpan")
			else
				TriggerEvent('QBCore:Notify', Loc[Config.Lan].error["no_pan"], 'error')
			end
		end
	end
end)

RegisterNetEvent('jim-mining:MakeItem', function(data)
	if data.ret then 
		local p = promise.new() QBCore.Functions.TriggerCallback("QBCore:HasItem", function(cb) p:resolve(cb) end, "drillbit")
		if Citizen.Await(p) == false then TriggerEvent('QBCore:Notify', Loc[Config.Lan].error["no_drill_bit"], 'error')	TriggerEvent('jim-mining:JewelCut') return end
	end
	for k, v in pairs(data.craftable[data.tablenumber]) do
		if data.item == k then
			Wait(0) local p = promise.new()
			QBCore.Functions.TriggerCallback('jim-mining:Check', function(cb) p:resolve(cb) end, data.item, data.tablenumber, data.craftable)
			if not Citizen.Await(p) then 
				TriggerEvent('QBCore:Notify', Loc[Config.Lan].error["no_ingredients"], 'error')
				TriggerEvent('jim-mining:CraftMenu', data)
			else itemProgress(data) end		
		end
	end
end)

function itemProgress(data)
	if data.craftable then
		if not data.ret then bartext = Loc[Config.Lan].info["smelting"]..QBCore.Shared.Items[data.item].label
		else bartext = Loc[Config.Lan].info["cutting"]..QBCore.Shared.Items[data.item].label end
		animDictNow = "amb@prop_human_parking_meter@male@idle_a"
		animNow = "idle_a"
	end
	LocalPlayer.state:set("inv_busy", true, true)
	local isDrilling = true
	if data.ret then -- If jewelcutting
		local drillcoords
		for k, v in pairs(Props) do
			if #(GetEntityCoords(v) - GetEntityCoords(PlayerPedId())) <= 2.0 and GetEntityModel(v) == `xs_prop_x18_speeddrill_01c` then
				RequestAmbientAudioBank("DLC_HEIST_FLEECA_SOUNDSET", 0)
				RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL", 0)
				RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2", 0)
				soundId = GetSoundId()
				PlaySoundFromEntity(soundId, "Drill", v, "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
				drillcoords = GetOffsetFromEntityInWorldCoords(v, 0.0, -0.15, 0.0)
			end
		end
		CreateThread(function()
			while isDrilling do
				RequestNamedPtfxAsset("core")
				while not HasNamedPtfxAssetLoaded("core") do Citizen.Wait(10) end
				local heading = GetEntityHeading(PlayerPedId())
				UseParticleFxAssetNextCall("core")
				SetParticleFxNonLoopedColour(255 / 255, 255 / 255, 255 / 255)
				SetParticleFxNonLoopedAlpha(1.0)
				local direction = math.random(0, 359)
				local dust = StartNetworkedParticleFxNonLoopedAtCoord("glass_side_window", drillcoords.x, drillcoords.y, drillcoords.z+1.1, 0.0, 0.0, heading+direction, 0.2, 0.0, 0.0, 0.0)
				Wait(100)
			end
		end)

	end
	QBCore.Functions.Progressbar('making_food', bartext, Config.Timings["Crafting"], false, true, { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true, }, 
	{ animDict = animDictNow, anim = animNow, flags = 8, }, {}, {}, function()  
		TriggerServerEvent('jim-mining:GetItem', data)
		if data.ret then
			local breackChance = math.random(1,10)
			if breackChance >= 8 then
				local breakId = GetSoundId()
				PlaySoundFromEntity(breakId, "Drill_Pin_Break", PlayerPedId(), "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
				TriggerServerEvent("QBCore:Server:RemoveItem", "drillbit", 1)
				TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items['drillbit'], 'remove', 1)
			end
		end
		
		StopAnimTask(PlayerPedId(), animDictNow, animNow, 1.0)
	    LocalPlayer.state:set("inv_busy", false, true)
		StopSound(soundId)
		--DeleteObject(Props[#Props])
		isDrilling = false
	end, function() -- Cancel
		TriggerEvent('QBCore:Notify', Loc[Config.Lan].error["cancelled"], 'error')
		StopAnimTask(PlayerPedId(), animDictNow, animNow, 1.0)
	    LocalPlayer.state:set("inv_busy", false, true)
		--DeleteObject(Props[#Props])
		StopSound(soundId)
		isDrilling = false
	end, data.item)
end
------------------------------------------------------------
--These also lead to the actual selling commands

--Selling animations are simply a pass item to seller animation
--Sell Ore Animation
RegisterNetEvent('jim-mining:SellAnim', function(data)
	local pid = PlayerPedId()
	loadAnimDict("mp_common")
	TriggerServerEvent('jim-mining:Selling', data) -- Had to slip in the sell command during the animation command
	for k,v in pairs (Peds) do
        pCoords = GetEntityCoords(PlayerPedId())
        ppCoords = GetEntityCoords(v)
		ppRot = GetEntityRotation(v)
        dist = #(pCoords - ppCoords)
        if dist < 2 then 
			TaskPlayAnim(pid, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
            TaskPlayAnim(v, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
            Wait(1500)
            StopAnimTask(pid, "mp_common", "givetake2_a", 1.0)
            StopAnimTask(v, "mp_common", "givetake2_a", 1.0)
            RemoveAnimDict("mp_common")
			SetEntityRotation(v, 0,0,ppRot.z,0,0,false)		
			break
		end
	end
	TriggerEvent('jim-mining:SellOre')
end)

--Sell Anim small Test
RegisterNetEvent('jim-mining:SellAnim:Jewel', function(data)
	local pid = PlayerPedId()
	loadAnimDict("mp_common")
	TriggerServerEvent('jim-mining:SellJewel', data) -- Had to slip in the sell command during the animation command
	for k,v in pairs (Peds) do
        pCoords = GetEntityCoords(PlayerPedId())
        ppCoords = GetEntityCoords(v)
		ppRot = GetEntityRotation(v)
        dist = #(pCoords - ppCoords)
        if dist < 2 then 
			TaskPlayAnim(pid, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
            TaskPlayAnim(v, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
            Wait(1500)
            StopAnimTask(pid, "mp_common", "givetake2_a", 1.0)
            StopAnimTask(v, "mp_common", "givetake2_a", 1.0)
            RemoveAnimDict("mp_common")
			SetEntityRotation(v, 0, 0, ppRot.z, 0, 0, false)
			break
		end
	end	
	if string.find(data, "ear") then TriggerEvent('jim-mining:JewelSell:Earring') return
	elseif string.find(data, "ring") then TriggerEvent('jim-mining:JewelSell:Rings') return
	elseif string.find(data, "chain") or string.find(data, "necklace") then TriggerEvent('jim-mining:JewelSell:Necklace') return
	elseif string.find(data, "emerald") then TriggerEvent('jim-mining:JewelSell:Emerald') return
	elseif string.find(data, "ruby") then TriggerEvent('jim-mining:JewelSell:Ruby') return
	elseif string.find(data, "diamond") then TriggerEvent('jim-mining:JewelSell:Diamond') return
	elseif string.find(data, "sapphire") then TriggerEvent('jim-mining:JewelSell:Sapphire') return
	else TriggerEvent('jim-mining:JewelSell') return end
end)

------------------------------------------------------------
--Context Menus
--Selling Ore
RegisterNetEvent('jim-mining:SellOre', function()
	exports['qb-menu']:openMenu({
		{ header = Loc[Config.Lan].info["header_oresell"], txt = Loc[Config.Lan].info["oresell_txt"], isMenuHeader = true },
		{ icon = "fas fa-circle-xmark", header = "", txt = Loc[Config.Lan].info["close"], params = { event = "jim-mining:CraftMenu:Close" } },
		{ icon = "copperore", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["copperore"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["copperore"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['copperore'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim", args = 'copperore' } },
		{ icon = "ironore", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["ironore"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["ironore"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['ironore'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim", args = 'ironore' } },
		{ icon = "goldore", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["goldore"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["goldore"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['goldore'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim", args = 'goldore' } },
		{ icon = "silverore", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["silverore"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["silverore"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['goldore'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim", args = 'silverore' } },
		{ icon = "carbon", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["carbon"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["carbon"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['carbon'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim", args = 'carbon' } }, 
	})
end)
------------------------
--Jewel Selling Main Menu
RegisterNetEvent('jim-mining:JewelSell', function()
    exports['qb-menu']:openMenu({
		{ header = Loc[Config.Lan].info["jewel_buyer"], txt = Loc[Config.Lan].info["sell_jewel"], isMenuHeader = true }, 
		{ icon = "fas fa-circle-xmark", header = "", txt = Loc[Config.Lan].info["close"], params = { event = "jim-mining:CraftMenu:Close" } },
		{ header = QBCore.Shared.Items["emerald"].label, txt = Loc[Config.Lan].info["see_options"], params = { event = "jim-mining:JewelSell:Emerald", } },
		{ header = QBCore.Shared.Items["ruby"].label, txt = Loc[Config.Lan].info["see_options"], params = { event = "jim-mining:JewelSell:Ruby", } },
		{ header = QBCore.Shared.Items["diamond"].label, txt = Loc[Config.Lan].info["see_options"], params = { event = "jim-mining:JewelSell:Diamond", } },
		{ header = QBCore.Shared.Items["sapphire"].label, txt = Loc[Config.Lan].info["see_options"], params = { event = "jim-mining:JewelSell:Sapphire", } },
		{ header = Loc[Config.Lan].info["rings"], txt = Loc[Config.Lan].info["see_options"], params = { event = "jim-mining:JewelSell:Rings", } },
		{ header = Loc[Config.Lan].info["necklaces"], txt = Loc[Config.Lan].info["see_options"], params = { event = "jim-mining:JewelSell:Necklace", } },
		{ header = Loc[Config.Lan].info["earrings"], txt = Loc[Config.Lan].info["see_options"], params = { event = "jim-mining:JewelSell:Earring", } },
	})
end)
--Jewel Selling - Emerald Menu
RegisterNetEvent('jim-mining:JewelSell:Emerald', function()
    exports['qb-menu']:openMenu({
		{ header = Loc[Config.Lan].info["jewel_buyer"], txt = Loc[Config.Lan].info["sell_jewel"], isMenuHeader = true }, 
		{ icon = "fas fa-circle-arrow-left", header = "", txt = Loc[Config.Lan].info["return"], params = { event = "jim-mining:JewelSell", } },
		{ icon = "emerald", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["emerald"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["emerald"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['emerald'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'emerald' } },
		{ icon = "uncut_emerald", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["uncut_emerald"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["uncut_emerald"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['uncut_emerald'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'uncut_emerald' } }, 
	})
end)
--Jewel Selling - Ruby Menu
RegisterNetEvent('jim-mining:JewelSell:Ruby', function()
    exports['qb-menu']:openMenu({
		{ header = Loc[Config.Lan].info["jewel_buyer"], txt = Loc[Config.Lan].info["sell_jewel"], isMenuHeader = true }, 
		{ icon = "fas fa-circle-arrow-left", header = "", txt = Loc[Config.Lan].info["return"], params = { event = "jim-mining:JewelSell", } },
		{ icon = "ruby", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["ruby"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["ruby"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['ruby'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'ruby' } },
		{ icon = "uncut_ruby", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["uncut_ruby"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["uncut_ruby"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['uncut_ruby'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'uncut_ruby' } },
	})
end)
--Jewel Selling - Diamonds Menu
RegisterNetEvent('jim-mining:JewelSell:Diamond', function()
    exports['qb-menu']:openMenu({
		{ header = Loc[Config.Lan].info["jewel_buyer"], txt = Loc[Config.Lan].info["sell_jewel"], isMenuHeader = true }, 
		{ icon = "fas fa-circle-arrow-left", header = "", txt = Loc[Config.Lan].info["return"], params = { event = "jim-mining:JewelSell", } },
		{ icon = "diamond", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["diamond"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["diamond"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['diamond'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'diamond' } },
		{ icon = "uncut_diamond", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["uncut_diamond"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["uncut_diamond"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['uncut_diamond'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'uncut_diamond' } },
	})
end)
--Jewel Selling - Sapphire Menu
RegisterNetEvent('jim-mining:JewelSell:Sapphire', function()
    exports['qb-menu']:openMenu({
		{ header = Loc[Config.Lan].info["jewel_buyer"], txt = Loc[Config.Lan].info["sell_jewel"], isMenuHeader = true }, 
		{ icon = "fas fa-circle-arrow-left", header = "", txt = Loc[Config.Lan].info["return"], params = { event = "jim-mining:JewelSell", } },
		{ icon = "sapphire", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["sapphire"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["sapphire"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['sapphire'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'sapphire' } },
		{ icon = "uncut_sapphire", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["uncut_sapphire"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["uncut_sapphire"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['uncut_sapphire'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'uncut_sapphire' } },
	})
end)

--Jewel Selling - Jewellry Menu
RegisterNetEvent('jim-mining:JewelSell:Rings', function()
    exports['qb-menu']:openMenu({
		{ header = Loc[Config.Lan].info["jewel_buyer"], txt = Loc[Config.Lan].info["sell_jewel"], isMenuHeader = true }, 
		{ icon = "fas fa-circle-arrow-left", header = "", txt = Loc[Config.Lan].info["return"], params = { event = "jim-mining:JewelSell", } },
		{ icon = "gold_ring", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["gold_ring"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["gold_ring"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['gold_ring'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'gold_ring' } },
		{ icon = "silver_ring", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["silver_ring"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["silver_ring"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['silver_ring'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'silver_ring' } },
		{ icon = "diamond_ring", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["diamond_ring"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["diamond_ring"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['diamond_ring'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'diamond_ring'} },
		{ icon = "emerald_ring", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["emerald_ring"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["emerald_ring"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['emerald_ring'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'emerald_ring' } },
		{ icon = "ruby_ring", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["ruby_ring"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["ruby_ring"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['ruby_ring'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'ruby_ring' } },	
		{ icon = "sapphire_ring", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["sapphire_ring"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["sapphire_ring"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['sapphire_ring'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'sapphire_ring' } },
		{ icon = "diamond_ring_silver", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["diamond_ring_silver"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["diamond_ring_silver"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['diamond_ring_silver'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'diamond_ring_silver'} },
		{ icon = "emerald_ring_silver", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["emerald_ring_silver"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["emerald_ring_silver"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['emerald_ring_silver'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'emerald_ring_silver' } },
		{ icon = "ruby_ring_silver", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["ruby_ring_silver"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["ruby_ring_silver"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['ruby_ring_silver'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'ruby_ring_silver' } },	
		{ icon = "sapphire_ring_silver", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["sapphire_ring_silver"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["sapphire_ring_silver"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['sapphire_ring_silver'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'sapphire_ring_silver' } },


	})
end)
--Jewel Selling - Jewellery Menu
RegisterNetEvent('jim-mining:JewelSell:Necklace', function()
    exports['qb-menu']:openMenu({
		{ header = Loc[Config.Lan].info["jewel_buyer"], txt = Loc[Config.Lan].info["sell_jewel"], isMenuHeader = true }, 
		{ icon = "fas fa-circle-arrow-left", header = "", txt = Loc[Config.Lan].info["return"], params = { event = "jim-mining:JewelSell", } },
		{ icon = "goldchain", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["goldchain"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["goldchain"].label,	txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['goldchain'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'goldchain' } },
		{ icon = "silverchain", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["silverchain"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["silverchain"].label,	txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['silverchain'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'silverchain' } },
		{ icon = "diamond_necklace", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["diamond_necklace"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["diamond_necklace"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['diamond_necklace'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'diamond_necklace' } },
		{ icon = "emerald_necklace", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["emerald_necklace"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["emerald_necklace"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['emerald_necklace'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'emerald_necklace' } },
		{ icon = "ruby_necklace", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["ruby_necklace"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["ruby_necklace"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['ruby_necklace'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'ruby_necklace' } },	
		{ icon = "sapphire_necklace", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["sapphire_necklace"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["sapphire_necklace"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['sapphire_necklace'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'sapphire_necklace' } },
		{ icon = "diamond_necklace_silver", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["diamond_necklace_silver"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["diamond_necklace_silver"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['diamond_necklace_silver'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'diamond_necklace_silver' } },
		{ icon = "emerald_necklace_silver", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["emerald_necklace_silver"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["emerald_necklace_silver"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['emerald_necklace_silver'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'emerald_necklace_silver' } },
		{ icon = "ruby_necklace_silver", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["ruby_necklace_silver"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["ruby_necklace_silver"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['ruby_necklace_silver'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'ruby_necklace_silver' } },	
		{ icon = "sapphire_necklace_silver", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["sapphire_necklace_silver"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["sapphire_necklace_silver"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['sapphire_necklace_silver'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'sapphire_necklace_silver' } },
	})
end)
--Jewel Selling - Jewellery Menu
RegisterNetEvent('jim-mining:JewelSell:Earring', function()
    exports['qb-menu']:openMenu({
		{ header = Loc[Config.Lan].info["jewel_buyer"], txt = Loc[Config.Lan].info["sell_jewel"], isMenuHeader = true }, 
		{ icon = "fas fa-circle-arrow-left", header = "", txt = Loc[Config.Lan].info["return"], params = { event = "jim-mining:JewelSell", } },
		{ icon = "goldearring", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["goldearring"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["goldearring"].label,	txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['goldearring'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'goldearring' } },
		{ icon = "silverearring", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["silverearring"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["silverearring"].label,	txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['silverearring'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'silverearring' } },
		{ icon = "diamond_earring", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["diamond_earring"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["diamond_earring"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['diamond_earring'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'diamond_earring' } },
		{ icon = "emerald_earring", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["emerald_earring"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["emerald_earring"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['emerald_earring'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'emerald_earring' } },
		{ icon = "ruby_earring", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["ruby_earring"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["ruby_earring"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['ruby_earring'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'ruby_earring' } },	
		{ icon = "sapphire_earring", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["sapphire_earring"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["sapphire_earring"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['sapphire_earring'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'sapphire_earring' } },
		{ icon = "diamond_earring_silver", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["diamond_earring_silver"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["diamond_earring_silver"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['diamond_earring_silver'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'diamond_earring_silver' } },
		{ icon = "emerald_earring_silver", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["emerald_earring_silver"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["emerald_earring_silver"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['emerald_earring_silver'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'emerald_earring_silver' } },
		{ icon = "ruby_earring_silver", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["ruby_earring_silver"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["ruby_earring_silver"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['ruby_earring_silver'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'ruby_earring_silver' } },	
		{ icon = "sapphire_earring_silver", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["sapphire_earring_silver"].image.." width=30px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items["sapphire_earring_silver"].label, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['sapphire_earring_silver'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim:Jewel", args = 'sapphire_earring_silver' } },
	})
end)
------------------------

RegisterNetEvent('jim-mining:CraftMenu:Close', function() exports['qb-menu']:closeMenu() end)

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
			for k, v in pairs(data.craftable[i]) do
				if k ~= "amount" then
					local text = ""
					if data.craftable[i]["amount"] then amount = " x"..data.craftable[i]["amount"] else amount = "" end
					setheader = QBCore.Shared.Items[k].label..tostring(amount)
					Wait(0) local p = promise.new()
					QBCore.Functions.TriggerCallback('jim-mining:Check', function(cb) p:resolve(cb) end, tostring(k), i, data.craftable) --check = Citizen.Await(p)
					if Citizen.Await(p) then setheader = setheader.." ✅" end p = nil check = nil
					for l, b in pairs(data.craftable[i][tostring(k)]) do
						if b == 1 then number = "" else number = " x"..b end
						text = text.."- "..QBCore.Shared.Items[l].label..number.."<br>"
						settext = text
					end
					CraftMenu[#CraftMenu + 1] = { icon = k, header = "<img src=nui://"..Config.img..QBCore.Shared.Items[k].image.." width=30px onerror='this.onerror=null; this.remove();'> "..setheader, txt = settext, params = { event = "jim-mining:MakeItem", args = { item = k, tablenumber = i, craftable = data.craftable, ret = data.ret } } }
					settext, amount, setheader = nil
				end
			end
		end
	exports['qb-menu']:openMenu(CraftMenu)
end)

AddEventHandler('onResourceStop', function(resource) if resource == GetCurrentResourceName() then removeJob() end end)
