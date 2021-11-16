local QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

function CreateBlips()
	for k, v in pairs(Config.Locations) do
		if Config.Locations[k].blipTrue then
			local blip = AddBlipForCoord(v.location)
			SetBlipAsShortRange(blip, true)
			SetBlipSprite(blip, 527)
			SetBlipColour(blip, 81)
			SetBlipScale(blip, 0.7)
			SetBlipDisplay(blip, 6)

			BeginTextCommandSetBlipName('STRING')
			if Config.BlipNamer then
				AddTextComponentString(Config.Locations[k].name)
			else
				AddTextComponentString("Mining")
			end
			EndTextCommandSetBlipName(blip)
		end
	end
end

Citizen.CreateThread(function()
    if Config.Blips == true then
		CreateBlips()
	end
end)
Citizen.CreateThread(function()
	if Config.PropSpawn == true then
		CreateProps()
	end
end)
Citizen.CreateThread(function()
	if Config.Pedspawn == true then
		CreatePeds()
	end
end)
-----------------------------------------------------------

local peds = {}

function CreatePeds()
	for k = 1, #Config.PedList, 1 do
		v = Config.PedList[k]
		local playerCoords = GetEntityCoords(PlayerPedId())
		local dist = #(playerCoords - v.coords)
		if dist < Config.Distance and not peds[k] then
			local ped = nearPed(v.model, v.coords, v.heading, v.gender, v.animDict, v.animName, v.scenario)
			peds[k] = {ped = ped}
		end
		if dist >= Config.Distance and peds[k] then
			if Config.Fade then
				for i = 255, 0, -51 do
					Citizen.Wait(50)
					SetEntityAlpha(peds[k].ped, i, false)
				end
			end
			DeletePed(peds[k].ped)
			peds[k] = nil
		end
	end
end

function nearPed(model, coords, heading, gender, animDict, animName, scenario)
	RequestModel(GetHashKey(model))
	while not HasModelLoaded(GetHashKey(model)) do
		Citizen.Wait(1)
	end
	if gender == 'male' then
		genderNum = 4
	elseif gender == 'female' then 
		genderNum = 5
	else
		print("No gender provided! Check your configuration!")
	end
	if Config.MinusOne then 
		local x, y, z = table.unpack(coords)
		ped = CreatePed(genderNum, GetHashKey(model), x, y, z - 1, heading, false, true)
	else
		ped = CreatePed(genderNum, GetHashKey(v.model), coords, heading, false, true)
	end
	SetEntityAlpha(ped, 0, false)
	if Config.Frozen then
		FreezeEntityPosition(ped, true) --Don't let the ped move.
	end
	if Config.Invincible then
		SetEntityInvincible(ped, true) --Don't let the ped die.
	end
	if Config.Stoic then
		SetBlockingOfNonTemporaryEvents(ped, true) --Don't let the ped react to his surroundings.
	end
	--Add an animation to the ped, if one exists.
	if animDict and animName then
		RequestAnimDict(animDict)
		while not HasAnimDictLoaded(animDict) do
			Citizen.Wait(1)
		end
		TaskPlayAnim(ped, animDict, animName, 8.0, 0, -1, 1, 0, 0, 0)
	end
	if scenario then
		TaskStartScenarioInPlace(ped, scenario, 0, true) -- begins peds animation
	end
	if Config.Fade then
		for i = 0, 255, 51 do
			Citizen.Wait(50)
			SetEntityAlpha(ped, i, false)
		end
	end
	return ped
end

-----------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		for k, v in pairs(Config.OrePositions) do
			if GetDistanceBetweenCoords(coords, v.coords, true) < 5 then
				DrawMarker(20, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 255, 255, 255, 100, 0, 0, 0, true, 0, 0, 0)
			else
				Citizen.Wait(500)
			end
		end
	end
end)

function CreateProps()
	local prop = 0
	for k,v in pairs(Config.OrePositions) do
		prop = prop+1
		local prop = CreateObject(GetHashKey("cs_x_rubweec"),v.coords.x, v.coords.y, v.coords.z+1.03,false,false,false)
		SetEntityHeading(prop,GetEntityHeading(prop)-90)
		FreezeEntityPosition(prop, true)           
    end
	for k,v in pairs(Config.MineLights) do
		prop = prop+1
		local prop = CreateObject(GetHashKey("xs_prop_arena_lights_ceiling_l_c"),v.coords.x,false,false,false)
		--SetEntityHeading(prop,GetEntityHeading(prop)-90)
		FreezeEntityPosition(prop, true)           
    end
	local bench = CreateObject(GetHashKey("gr_prop_gr_bench_04b"),Config.Locations['JewelCut'].location,false,false,false)
	SetEntityHeading(bench,GetEntityHeading(bench)-Config.Locations['JewelCut'].heading)
	FreezeEntityPosition(bench, true)
	local bench2 = CreateObject(GetHashKey("prop_tool_bench02"),Config.Locations['Cracking'].location,false,false,false)
	SetEntityHeading(bench2,GetEntityHeading(bench2)-Config.Locations['Cracking'].heading)
	FreezeEntityPosition(bench2, true)
end

-----------------------------------------------------------

Citizen.CreateThread(function()
	exports['bt-target']:AddCircleZone("MineStart", Config.Locations['Mine'].location, 2.0, { name="MineStart", debugPoly=false, useZ=true, }, 
	{ options = { { event = "jim-mining:enterMine", icon = "fas fa-certificate", label = "Enter Mine", }, },
		job = {"all"}, distance = 1.5
	})
	exports['bt-target']:AddCircleZone("MineLeave", Config.Locations['MineLeave'].location, 2.0, { name="MineLeave", debugPoly=false, useZ=true, }, 
	{ options = { { event = "jim-mining:exitMine", icon = "fas fa-certificate", label = "Leave Mine", }, },
		job = {"all"}, distance = 1.5
	})
	--Smelter to turn stone into ore
	exports['bt-target']:AddCircleZone("Smelter", Config.Locations['Smelter'].location, 3.0, { name="Smelter", debugPoly=false, useZ=true, }, 
	{ options = { { event = "jim-mining:SmeltStart", icon = "fas fa-certificate", label = "Use Smelter", }, },
		job = {"all"}, distance = 10.0
	})
	--Ore Buyer
	exports['bt-target']:AddCircleZone("Buyer", Config.Locations['Buyer'].location, 2.0, { name="Buyer", debugPoly=false, useZ=true, }, 
	{ options = { { event = "", icon = "fas fa-certificate", label = "Talk to Ore Buyer", },	},
		job = {"all"}, distance = 1.5
	})
	--Jewel Cutting Bench
	exports['bt-target']:AddCircleZone("JewelCut", Config.Locations['JewelCut'].location, 2.0, { name="JewelCut", debugPoly=false, useZ=true, }, 
	{ options = { { event = "", icon = "fas fa-certificate", label = "Use Jewel Cutting Bench", },	},
		job = {"all"}, distance = 1.5
	})
	--Jewel Buyer
	exports['bt-target']:AddCircleZone("JewelBuyer", Config.Locations['Buyer2'].location, 2.0, { name="JewelBuyer", debugPoly=false, useZ=true, }, 
	{ options = { { event = "", icon = "fas fa-certificate", label = "Talk To Jewel Buyer", },	},
		job = {"all"}, distance = 1.5
	})
	--Cracking Bench
	exports['bt-target']:AddCircleZone("CrackingBench", Config.Locations['Cracking'].location, 2.0, { name="CrackingBench", debugPoly=false, useZ=true, }, 
	{ options = { { event = "jim-mining:CrackStart", icon = "fas fa-certificate", label = "Use Cracking Bench", },	},
		job = {"all"}, distance = 1.5
	})
	local ore = 0
	for k,v in pairs(Config.OrePositions) do
		ore = ore+1
		exports['bt-target']:AddCircleZone(ore, v.coords, 2.0, { name=ore, debugPoly=false, useZ=true, }, 
		{ options = { { event = "jim-mining:MineOre", icon = "fas fa-certificate", label = "Mine ore", },	},
			job = {"all"}, distance = 2.5
		})
	end
end)

-----------------------------------------------------------

--Teleporters for mineshaft doors
RegisterNetEvent('jim-mining:enterMine')
AddEventHandler('jim-mining:enterMine', function ()
    DoScreenFadeOut(500)
        while not IsScreenFadedOut() do
            Citizen.Wait(10)
        end
        SetEntityCoords(PlayerPedId(), 
									Config.Locations['MineLeave'].location.x+0.2,
									Config.Locations['MineLeave'].location.y-0.3,
									Config.Locations['MineLeave'].location.z, 0, 0, 0, false)
        SetEntityHeading(PlayerPedId(), Config.Locations['MineLeave'].heading)
        Citizen.Wait(100)
    DoScreenFadeIn(1000)
end)

RegisterNetEvent('jim-mining:exitMine')
AddEventHandler('jim-mining:exitMine', function ()
    DoScreenFadeOut(500)
        while not IsScreenFadedOut() do
            Citizen.Wait(10)
        end
        SetEntityCoords(PlayerPedId(), 
									Config.Locations['Mine'].location.x-0.2,
									Config.Locations['Mine'].location.y+0.3,
									Config.Locations['Mine'].location.z, 0, 0, 0, false)
        SetEntityHeading(PlayerPedId(), Config.Locations['Mine'].heading)
        Citizen.Wait(100)
    DoScreenFadeIn(1000)
end)

------------------------------------------------------------
-- Mine Ore Command / Animations
RegisterNetEvent('jim-mining:MineOre')
AddEventHandler('jim-mining:MineOre', function ()
	local pos = GetEntityCoords(GetPlayerPed(-1))
	loadAnimDict("anim@heists@fleeca_bank@drilling")
	TaskPlayAnim(GetPlayerPed(-1), 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle' , 3.0, 3.0, -1, 1, 0, false, false, false)
	local pos = GetEntityCoords(GetPlayerPed(-1), true)
	local DrillObject = CreateObject(GetHashKey("hei_prop_heist_drill"), pos.x, pos.y, pos.z, true, true, true)
	AttachEntityToEntity(DrillObject, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.14, 0, -0.01, 90.0, -90.0, 180.0, true, true, false, true, 1, true)

	QBCore.Functions.Progressbar("open_locker_drill", "Drilling Ore..", math.random(10000,15000), false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function() -- Done
		StopAnimTask(GetPlayerPed(-1), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
		DetachEntity(DrillObject, true, true)
		DeleteObject(DrillObject)
			TriggerServerEvent('jim-mining:MineReward')
			QBCore.Functions.Notify("Success!", "success")
			IsDrilling = false
	end, function() -- Cancel
		StopAnimTask(GetPlayerPed(-1), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
		--TriggerServerEvent('qb-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
		DetachEntity(DrillObject, true, true)
		DeleteObject(DrillObject)
		QBCore.Functions.Notify("Cancelled..", "error")
		IsDrilling = false
	end)
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 
------------------------------------------------------------
-- Smelt Command / Animations
RegisterNetEvent('jim-mining:CrackStart')
AddEventHandler('jim-mining:CrackStart', function ()
	local pos = GetEntityCoords(GetPlayerPed(-1))
	--loadAnimDict("anim@heists@fleeca_bank@drilling")
	--TaskPlayAnim(GetPlayerPed(-1), 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle' , 3.0, 3.0, -1, 1, 0, false, false, false)
	--local pos = GetEntityCoords(GetPlayerPed(-1), true)
	--local DrillObject = CreateObject(GetHashKey("hei_prop_heist_drill"), pos.x, pos.y, pos.z, true, true, true)
	--AttachEntityToEntity(DrillObject, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.14, 0, -0.01, 90.0, -90.0, 180.0, true, true, false, true, 1, true)

	QBCore.Functions.Progressbar("open_locker_drill", "Cracking Stone..", math.random(10000,15000), false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function() -- Done
		--StopAnimTask(GetPlayerPed(-1), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
		--DetachEntity(DrillObject, true, true)
		--DeleteObject(DrillObject)
			TriggerServerEvent('jim-mining:CrackReward')
			QBCore.Functions.Notify("Success!", "success")
			IsDrilling = false
	end, function() -- Cancel
		--StopAnimTask(GetPlayerPed(-1), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
		--TriggerServerEvent('qb-bankrobbery:server:setLockerState', bankId, lockerId, 'isBusy', false)
		--DetachEntity(DrillObject, true, true)
		--DeleteObject(DrillObject)
		QBCore.Functions.Notify("Cancelled..", "error")
		IsDrilling = false
	end)
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 
------------------------------------------------------------
--[[_JewelPool = NativeUI.CreatePool()
JewelMenu = NativeUI.CreateMenu("", "Cut your jewels", "", "", "shopui_title_exec_vechupgrade", "shopui_title_exec_vechupgrade")
_JewelPool:Add(JewelMenu)

_JewelPool:ControlDisablingEnabled(false)
_JewelPool:MouseControlsEnabled(false)

function JewelCutting(menu)
		Emerald = NativeUI.CreateItem("Emerald", "")
		Ruby = NativeUI.CreateItem("Ruby", "")
		Diamond = NativeUI.CreateItem("Diamond", "")

		menu:AddItem(Emerald)
		menu:AddItem(Ruby)
		menu:AddItem(Diamond)
		menu.OnItemSelect = function(sender, item, index)
		
		if item == Emerald then
			--TriggerServerEvent('')
		elseif item == Ruby then
			--TriggerServerEvent('')
		elseif item == Diamond then
			--TriggerServerEvent('')
		end
	end   
end


JewelCutting(JewelMenu)
_JewelPool:RefreshIndex()

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		_JewelPool:ProcessMenus()
	end
end)

------------------------------
_OrePool = NativeUI.CreatePool()
OreMenu = NativeUI.CreateMenu("", "Sell your ores for Cash", "", "", "shopui_title_exec_vechupgrade", "shopui_title_exec_vechupgrade")
_OrePool:Add(mainMenu)

_OrePool:ControlDisablingEnabled(false)
_OrePool:MouseControlsEnabled(false)

function OreSeller(menu)

		CopperOre = NativeUI.CreateItem("Copper Ore - $"..Config.SellItems['copperore'].amount.." each", "")
		IronOre = NativeUI.CreateItem("Iron Ore $"..Config.SellItems['copperore'].amount.." each", "")
		GoldOre = NativeUI.CreateItem("Gold Ore $"..Config.SellItems['copperore'].amount.." each", "")
		TinOre = NativeUI.CreateItem("Tin Ore $"..Config.SellItems['copperore'].amount.." each", "")
		Coal = NativeUI.CreateItem("Coal $"..Config.SellItems['copperore'].amount.." each", "")

		menu:AddItem(CopperOre)
		menu:AddItem(IronOre)
		menu:AddItem(GoldOre)
		menu:AddItem(TinOre)
		menu:AddItem(Coal)
		
		menu.OnItemSelect = function(sender, item, index)
		
		if item == CopperOre then
			--TriggerServerEvent('')
		elseif item == IronOre then
			--TriggerServerEvent('')
		elseif item == GoldOre then
			--TriggerServerEvent('')
		elseif item == TinOre then
			--TriggerServerEvent('')
		elseif item == Coal then
			--TriggerServerEvent('')
		end
	end   
end

OreSeller(OreMenu)
_OrePool:RefreshIndex()

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		_OrePool:ProcessMenus()
	end
end)

------------------------------
_SmeltPool = NativeUI.CreatePool()
SmeltMenu = NativeUI.CreateMenu("", "Sell your ores for Cash", "", "", "shopui_title_exec_vechupgrade", "shopui_title_exec_vechupgrade")
_SmeltPool:Add(mainMenu)

_SmeltPool:ControlDisablingEnabled(false)
_SmeltPool:MouseControlsEnabled(false)

function SmeltMenu(menu)

		CopperOre = NativeUI.CreateItem("Copper Ore - $"..Config.SellItems['copperore'].amount.." each", "")
		IronOre = NativeUI.CreateItem("Iron Ore $"..Config.SellItems['copperore'].amount.." each", "")
		GoldOre = NativeUI.CreateItem("Gold Ore $"..Config.SellItems['copperore'].amount.." each", "")
		TinOre = NativeUI.CreateItem("Tin Ore $"..Config.SellItems['copperore'].amount.." each", "")
		Coal = NativeUI.CreateItem("Coal $"..Config.SellItems['copperore'].amount.." each", "")

		menu:AddItem(CopperOre)
		menu:AddItem(IronOre)
		menu:AddItem(GoldOre)
		menu:AddItem(TinOre)
		menu:AddItem(Coal)
		
		menu.OnItemSelect = function(sender, item, index)
		
		if item == CopperOre then
			--TriggerServerEvent('')
		elseif item == IronOre then
			--TriggerServerEvent('')
		elseif item == GoldOre then
			--TriggerServerEvent('')
		elseif item == TinOre then
			--TriggerServerEvent('')
		elseif item == Coal then
			--TriggerServerEvent('')
		end
	end   
end

SmeltMenu(SmeltMenu)
_SmeltPool:RefreshIndex()

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		_SmeltPool:ProcessMenus()
	end
end)

]]