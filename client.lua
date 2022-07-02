local QBCore = exports['qb-core']:GetCoreObject()

local PlayerJob = {}
local Props = {}
local Targets = {}
local Peds = {}
local Blip = {}

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

if Config.JimMenu then Config.img = "" else Config.img = "<img src=nui://"..Config.img..QBCore.Shared.Items[v].image.." width=30px onerror='this.onerror=null; this.remove();'>" end

function removeJob()
	for k in pairs(Targets) do exports['qb-target']:RemoveZone(k) end		
	for k in pairs(Peds) do DeletePed(Peds[k]) end
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
			distance = 1.3
		})
		if Config.propSpawn then makeProp({coords = v.coords, prop = `cs_x_rubweec`}, "Ore"..k)
								 makeProp({coords = v.coords, prop = `prop_rock_5_a`}, "OreDead"..k) end
	end
end

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

--------------------------------------------------------
--Mining Store Opening
RegisterNetEvent('jim-mining:openShop', function() 
	if Config.JimShops then event = "jim-shops:ShopOpen" else event = "inventory:server:OpenInventory" end
	TriggerServerEvent(event, "shop", "mine", Config.Items)
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
				SetEntityAsMissionEntity(DrillObject) --nessesary for gta to even trigger DetachEntity
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
	for k in pairs(data.craftable[data.tablenumber]) do
		if data.item == k then
			Wait(0) local p = promise.new()
			QBCore.Functions.TriggerCallback('jim-mining:Check', function(cb) p:resolve(cb) end, data.item, data.craftable[data.tablenumber])
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
		for _, v in pairs(Props) do
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
--Sell Animation
RegisterNetEvent('jim-mining:SellAnim', function(data)
	local p = promise.new() QBCore.Functions.TriggerCallback("QBCore:HasItem", function(cb) p:resolve(cb) end, data.item)
	if Citizen.Await(p) == false then TriggerEvent("QBCore:Notify", Loc[Config.Lan].error["dont_have"].." "..QBCore.Shared.Items[data.item].label, "error") return end
	local pid = PlayerPedId()
	loadAnimDict("mp_common")
	TriggerServerEvent('jim-mining:Selling', data) -- Had to slip in the sell command during the animation command
	for _, v in pairs (Peds) do
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
	if data.sub then TriggerEvent('jim-mining:JewelSell:Sub', { sub = data.sub }) return
	else TriggerEvent('jim-mining:SellOre') return end
end)

------------------------------------------------------------
--Context Menus
--Selling Ore
RegisterNetEvent('jim-mining:SellOre', function()
	local list = {"copperore", "ironore", "goldore", "silverore", "carbon"}
	local sellMenu = {
		{ header = Loc[Config.Lan].info["header_oresell"], txt = Loc[Config.Lan].info["oresell_txt"], isMenuHeader = true },
		{ icon = "fas fa-circle-xmark", header = "", txt = Loc[Config.Lan].info["close"], params = { event = "jim-mining:CraftMenu:Close" } } }
	for _, v in pairs(list) do
		local setheader = Config.img..QBCore.Shared.Items[v].label
		local p = promise.new()	QBCore.Functions.TriggerCallback("QBCore:HasItem", function(cb) p:resolve(cb) end, v)
		if Citizen.Await(p) then setheader = setheader.." 💰" end
			sellMenu[#sellMenu+1] = { icon = v, header = setheader, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems[v].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim", args = { item = v } } }
		Wait(0)
	end
	exports['qb-menu']:openMenu(sellMenu)
end)
------------------------
--Jewel Selling Main Menu
RegisterNetEvent('jim-mining:JewelSell', function()
    exports['qb-menu']:openMenu({
		{ header = Loc[Config.Lan].info["jewel_buyer"], txt = Loc[Config.Lan].info["sell_jewel"], isMenuHeader = true }, 
		{ icon = "fas fa-circle-xmark", header = "", txt = Loc[Config.Lan].info["close"], params = { event = "jim-mining:CraftMenu:Close" } },
		{ header = QBCore.Shared.Items["emerald"].label, txt = Loc[Config.Lan].info["see_options"], params = { event = "jim-mining:JewelSell:Sub", args = { sub = "emerald" } } },
		{ header = QBCore.Shared.Items["ruby"].label, txt = Loc[Config.Lan].info["see_options"], params = { event = "jim-mining:JewelSell:Sub", args = { sub = "ruby" } } },
		{ header = QBCore.Shared.Items["diamond"].label, txt = Loc[Config.Lan].info["see_options"], params = { event = "jim-mining:JewelSell:Sub", args = { sub = "diamond" } } },
		{ header = QBCore.Shared.Items["sapphire"].label, txt = Loc[Config.Lan].info["see_options"], params = { event = "jim-mining:JewelSell:Sub", args = { sub = "sapphire" } } },
		{ header = Loc[Config.Lan].info["rings"], txt = Loc[Config.Lan].info["see_options"], params = { event = "jim-mining:JewelSell:Sub", args = { sub = "rings" } } },
		{ header = Loc[Config.Lan].info["necklaces"], txt = Loc[Config.Lan].info["see_options"], params = { event = "jim-mining:JewelSell:Sub", args = { sub = "necklaces" } } },
		{ header = Loc[Config.Lan].info["earrings"], txt = Loc[Config.Lan].info["see_options"], params = { event = "jim-mining:JewelSell:Sub", args = { sub = "earrings" } } },
	})
end)
--Jewel Selling - Sub Menu Controller
RegisterNetEvent('jim-mining:JewelSell:Sub', function(data)
	local list = {}
	local sellMenu = {
		{ header = Loc[Config.Lan].info["jewel_buyer"], txt = Loc[Config.Lan].info["sell_jewel"], isMenuHeader = true },
		{ icon = "fas fa-circle-arrow-left", header = "", txt = Loc[Config.Lan].info["return"], params = { event = "jim-mining:JewelSell", } }, }
	if data.sub == "emerald" then list = {"emerald", "uncut_emerald"} end
	if data.sub == "ruby" then list = {"ruby", "uncut_ruby"} end
	if data.sub == "diamond" then list = {"diamond", "uncut_diamond"} end
	if data.sub == "sapphire" then list = {"sapphire", "uncut_sapphire"} end
	if data.sub == "rings" then list = {"gold_ring", "silver_ring", "diamond_ring", "emerald_ring", "ruby_ring", "sapphire_ring", "diamond_ring_silver", "emerald_ring_silver", "ruby_ring_silver", "sapphire_ring_silver"} end
	if data.sub == "necklaces" then list = {"goldchain", "silverchain", "diamond_necklace", "emerald_necklace", "ruby_necklace", "sapphire_necklace", "diamond_necklace_silver", "emerald_necklace_silver", "ruby_necklace_silver", "sapphire_necklace_silver"} end
	if data.sub == "earrings" then list = {"goldearring", "silverearring", "diamond_earring", "emerald_earring", "ruby_earring", "sapphire_earring", "diamond_earring_silver", "emerald_earring_silver", "ruby_earring_silver", "sapphire_earring_silver"} end
	for _, v in pairs(list) do
		local setheader = Config.img..QBCore.Shared.Items[v].label
		local p = promise.new()	QBCore.Functions.TriggerCallback("QBCore:HasItem", function(cb) p:resolve(cb) end, v)
		if Citizen.Await(p) then setheader = setheader.." 💰" end
		sellMenu[#sellMenu+1] = { icon = v, header = setheader, txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems[v].." "..Loc[Config.Lan].info["sell_each"], params = { event = "jim-mining:SellAnim", args = { item = v, sub = data.sub } } }
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
					setheader = QBCore.Shared.Items[k].label..tostring(amount)
					if Config.CheckMarks then
						Wait(0)
						local p = promise.new()
						QBCore.Functions.TriggerCallback('jim-mining:Check', function(cb) p:resolve(cb) end, tostring(k), data.craftable[i]) check = Citizen.Await(p)
						if Citizen.Await(p) then setheader = setheader.." ✅" end
					end
					--p = nil check = nil
					for l, b in pairs(data.craftable[i][tostring(k)]) do
						if b == 1 then number = "" else number = " x"..b end
						text = text.."- "..QBCore.Shared.Items[l].label..number.."<br>"
						settext = text
					end
					CraftMenu[#CraftMenu + 1] = { icon = k, header = Config.img..setheader, txt = settext, params = { event = "jim-mining:MakeItem", args = { item = k, tablenumber = i, craftable = data.craftable, ret = data.ret } } }
					settext, amount, setheader = nil
				end
			end
		end
	exports['qb-menu']:openMenu(CraftMenu)
end)

AddEventHandler('onResourceStop', function(resource) if resource == GetCurrentResourceName() then removeJob() end end)
