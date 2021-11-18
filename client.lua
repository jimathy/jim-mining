local QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
	print("Jim-Mining - Mining Script by Jimathy")
end)

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
		local prop = CreateObject(GetHashKey("xs_prop_arena_lights_ceiling_l_c"),v.coords.x, v.coords.y, v.coords.z+1.03,false,false,false)
		--SetEntityHeading(prop,GetEntityHeading(prop)-90)
		FreezeEntityPosition(prop, true)           
    end
	--Jewel Cutting Bench
	local bench = CreateObject(GetHashKey("gr_prop_gr_bench_04b"),Config.Locations['JewelCut'].location,false,false,false)
	SetEntityHeading(bench,GetEntityHeading(bench)-Config.Locations['JewelCut'].heading)
	FreezeEntityPosition(bench, true)

	--Stone Cracking Bench
	local bench2 = CreateObject(GetHashKey("prop_tool_bench02"),Config.Locations['Cracking'].location,false,false,false)
	SetEntityHeading(bench2,GetEntityHeading(bench2)-Config.Locations['Cracking'].heading)
	FreezeEntityPosition(bench2, true)
	--Stone Prop for bench
	local bench2prop = CreateObject(GetHashKey("cs_x_rubweec"),Config.Locations['Cracking'].location.x, Config.Locations['Cracking'].location.y, Config.Locations['Cracking'].location.z+0.83,false,false,false)
	SetEntityHeading(bench2prop,GetEntityHeading(bench2prop)-Config.Locations['Cracking'].heading+90)
	FreezeEntityPosition(bench2prop, true)
	local bench2prop2 = CreateObject(GetHashKey("prop_worklight_03a"),Config.Locations['Cracking'].location.x-1.4, Config.Locations['Cracking'].location.y+1.08, Config.Locations['Cracking'].location.z,false,false,false)
	SetEntityHeading(bench2prop2,GetEntityHeading(bench2prop2)-Config.Locations['Cracking'].heading+180)
	FreezeEntityPosition(bench2prop2, true)
end

-----------------------------------------------------------

Citizen.CreateThread(function()
	exports['bt-target']:AddCircleZone("MineStart", Config.Locations['Mine'].location, 2.0, { name="MineStart", debugPoly=false, useZ=true, }, 
	{ options = { { event = "jim-mining:openShop", icon = "fas fa-certificate", label = "Browse Store", }, },
		job = {"all"}, distance = 2.0
	})
	--Smelter to turn stone into ore
	exports['bt-target']:AddCircleZone("Smelter", Config.Locations['Smelter'].location, 3.0, { name="Smelter", debugPoly=false, useZ=true, }, 
	{ options = { { event = "jim-mining:SmeltMenu", icon = "fas fa-certificate", label = "Use Smelter", }, },
		job = {"all"}, distance = 10.0
	})
	--Ore Buyer
	exports['bt-target']:AddCircleZone("Buyer", Config.Locations['Buyer'].location, 2.0, { name="Buyer", debugPoly=false, useZ=true, }, 
	{ options = { { event = "jim-mining:SellOre", icon = "fas fa-certificate", label = "Sell Ores", },	},
		job = {"all"}, distance = 2.0
	})
	--Jewel Cutting Bench
	exports['bt-target']:AddCircleZone("JewelCut", Config.Locations['JewelCut'].location, 2.0, { name="JewelCut", debugPoly=false, useZ=true, }, 
	{ options = { { event = "jim-mining:JewelCut", icon = "fas fa-certificate", label = "Use Jewel Cutting Bench", },	},
		job = {"all"}, distance = 2.0
	})
	--Jewel Buyer
	exports['bt-target']:AddCircleZone("JewelBuyer", Config.Locations['Buyer2'].location, 2.0, { name="JewelBuyer", debugPoly=false, useZ=true, }, 
	{ options = { { event = "jim-mining:JewelSell", icon = "fas fa-certificate", label = "Talk To Jewel Buyer", },	},
		job = {"all"}, distance = 2.0
	})
	--Cracking Bench
	exports['bt-target']:AddCircleZone("CrackingBench", Config.Locations['Cracking'].location, 2.0, { name="CrackingBench", debugPoly=false, useZ=true, }, 
	{ options = { { event = "jim-mining:CrackStart", icon = "fas fa-certificate", label = "Use Cracking Bench", },	},
		job = {"all"}, distance = 2.0
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
--Mining Store Opening
RegisterNetEvent('jim-mining:openShop')
AddEventHandler('jim-mining:openShop', function ()
	TriggerServerEvent("inventory:server:OpenInventory", "shop", "mine", Config.Items)
end)
------------------------------------------------------------
-- Mine Ore Command / Animations

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

RegisterNetEvent('jim-mining:MineOre')
AddEventHandler('jim-mining:MineOre', function ()
QBCore.Functions.TriggerCallback("QBCore:HasItem", function(item) 
		if item then 
			local pos = GetEntityCoords(GetPlayerPed(-1))
			loadAnimDict("anim@heists@fleeca_bank@drilling")
			TaskPlayAnim(GetPlayerPed(-1), 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle' , 3.0, 3.0, -1, 1, 0, false, false, false)
			local pos = GetEntityCoords(GetPlayerPed(-1), true)
			local DrillObject = CreateObject(GetHashKey("hei_prop_heist_drill"), pos.x, pos.y, pos.z, true, true, true)
			AttachEntityToEntity(DrillObject, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.14, 0, -0.01, 90.0, -90.0, 180.0, true, true, false, true, 1, true)
			QBCore.Functions.Progressbar("open_locker_drill", "Drilling Ore..", math.random(10000,15000), false, true, {
				disableMovement = true,	disableCarMovement = true, disableMouse = false, disableCombat = true, }, {}, {}, {}, function() -- Done
				StopAnimTask(GetPlayerPed(-1), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
				DetachEntity(DrillObject, true, true)
				DeleteObject(DrillObject)
					TriggerServerEvent('jim-mining:MineReward')
					IsDrilling = false
			end, function() -- Cancel
				StopAnimTask(GetPlayerPed(-1), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
				DetachEntity(DrillObject, true, true)
				DeleteObject(DrillObject)
				IsDrilling = false
			end)
					else 
			QBCore.Functions.Notify("No Stone to Crack", "error")
		end 
	end, "drill")
end)

------------------------------------------------------------

-- Cracking Command / Animations
-- Command Starts here where it calls to being the stone inv checking


RegisterNetEvent('jim-mining:CrackStart')
AddEventHandler('jim-mining:CrackStart', function ()
	QBCore.Functions.TriggerCallback("QBCore:HasItem", function(item) 
		if item then 
			local pos = GetEntityCoords(GetPlayerPed(-1))
			loadAnimDict('amb@prop_human_parking_meter@male@idle_a')
			TaskPlayAnim(GetPlayerPed(-1), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a' , 3.0, 3.0, -1, 1, 0, false, false, false)
			QBCore.Functions.Progressbar("open_locker_drill", "Cracking Stone..", math.random(10000,15000), false, true, {
				disableMovement = true,	disableCarMovement = true, disableMouse = false, disableCombat = true, }, {}, {}, {}, function() -- Done
				StopAnimTask(GetPlayerPed(-1), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 1.0)
				TriggerServerEvent('jim-mining:CrackReward')
				IsDrilling = false
			end, function() -- Cancel
				StopAnimTask(GetPlayerPed(-1), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 1.0)
				IsDrilling = false
			end)
		else 
			QBCore.Functions.Notify("No Stone to Crack", "error")
		end 
	end, "stone")
end)

-- Cut Command / Animations
-- Requires a drill
RegisterNetEvent('jim-mining:CutStart')
AddEventHandler('jim-mining:CutStart', function (data)
	QBCore.Functions.TriggerCallback("QBCore:HasItem", function(item) 
		if item then 
			local pos = GetEntityCoords(GetPlayerPed(-1))
			loadAnimDict('amb@prop_human_parking_meter@male@idle_a')
			TaskPlayAnim(GetPlayerPed(-1), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a' , 3.0, 3.0, -1, 1, 0, false, false, false)
			QBCore.Functions.Progressbar("open_locker_drill", "Cutting..", math.random(10000,15000), false, true, {
				disableMovement = true, disableCarMovement = true,disableMouse = false,	disableCombat = true, }, {}, {}, {}, function() -- Done
				StopAnimTask(GetPlayerPed(-1), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 1.0)
					TriggerServerEvent('jim-mining:Cutting', data.id)
					IsDrilling = false
			end, function() -- Cancel
				StopAnimTask(GetPlayerPed(-1), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 1.0)
				IsDrilling = false
			end)
		else 
			QBCore.Functions.Notify("You need a drill to make jewellery", "error")
		end 
	end, "drill")
end)

-- Smelt Command / Animations
RegisterNetEvent('jim-mining:SmeltStart')
AddEventHandler('jim-mining:SmeltStart', function ()
	local pos = GetEntityCoords(GetPlayerPed(-1))
	loadAnimDict('amb@prop_human_parking_meter@male@idle_a')
	TaskPlayAnim(GetPlayerPed(-1), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a' , 3.0, 3.0, -1, 1, 0, false, false, false)
	QBCore.Functions.Progressbar("open_locker_drill", "Smelting..", math.random(10000,15000), false, true, {
		disableMovement = true, disableCarMovement = true,disableMouse = false,	disableCombat = true, }, {}, {}, {}, function() -- Done
		StopAnimTask(GetPlayerPed(-1), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 1.0)
			TriggerServerEvent('jim-mining:Smelting', data.id)
			IsDrilling = false
	end, function() -- Cancel
		StopAnimTask(GetPlayerPed(-1), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 1.0)
		IsDrilling = false
	end)
end)


--Menu Animation commands
------------------------------------------------------------
--These also lead to the actual selling commands

--Selling animations are simply a pass item to seller animation
--Sell Ore Animation
RegisterNetEvent('jim-mining:SellAnim:Ore')
AddEventHandler('jim-mining:SellAnim:Ore', function(data)
	local pid = PlayerPedId()
	loadAnimDict("mp_common")
	TaskPlayAnim(pid, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
	TriggerServerEvent('jim-mining:SellOre', data.id) -- Had to slip in the sell command during the animation command
	Wait(1500)
	StopAnimTask(pid, "mp_common", "givetake2_a", 1.0)
end)

--Sell Anim small Test
RegisterNetEvent('jim-mining:SellAnim:Jewel')
AddEventHandler('jim-mining:SellAnim:Jewel', function(data)
	local pid = PlayerPedId()
	loadAnimDict("mp_common")
	TaskPlayAnim(pid, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
	TriggerServerEvent('jim-mining:SellJewel', data.id) -- Had to slip in the sell command during the animation command
	Wait(1500)
	StopAnimTask(pid, "mp_common", "givetake2_a", 1.0)
end)

------------------------------------------------------------
--Context Menus
--Selling Ore
RegisterNetEvent('jim-mining:SellOre', function()
	TriggerEvent('nh-context:sendMenu', {
	{   id = 1, header = "Sell Batches of Ores for Cash",
		txt = "", }, 
	{   id = 2, header = "Copper Ore",
		txt = "Sell ALL at $"..Config.SellItems['copperore'].." each",
		params = { event = "jim-mining:SellAnim:Ore",
		args = { number = 1, id = 1 } } },
	{   id = 3,	header = "Iron Ore",
		txt = "Sell ALL at $"..Config.SellItems['ironore'].." each",
		params = { event = "jim-mining:SellAnim:Ore",
		args = { number = 1, id = 2 } } },
	{   id = 4, header = "Gold Ore",
		txt = "Sell ALL at $"..Config.SellItems['goldore'].." each",
		params = { event = "jim-mining:SellAnim:Ore",
		args = { number = 1, id = 3 } } },
	{   id = 5, header = "Carbon",
		txt = "Sell ALL at $"..Config.SellItems['carbon'].." each",
		params = { event = "jim-mining:SellAnim:Ore",
		args = { number = 1, id = 4 } } }, })
end)
------------------------
--Jewel Selling Main Menu
RegisterNetEvent('jim-mining:JewelSell', function()
    TriggerEvent('nh-context:sendMenu', {
	{   id = 1, header = "Sell your jewellery here",
		txt = "", }, 
	{   id = 2, header = "Emeralds",
		txt = "See all Emerald selling options",
		params = { event = "jim-mining:JewelSell:Emerald",
		args = { number = 1, id = 1 } } },
	{   id = 3, header = "Rubys",
		txt = "See all Ruby selling options",
		params = { event = "jim-mining:JewelSell:Ruby",
		args = { number = 1, id = 2	} } },
	{   id = 4, header = "Diamonds",
		txt = "See all Diamond selling options",
		params = { event = "jim-mining:JewelSell:Diamond",
		args = { number = 1, id = 3 } } },
	{   id = 5, header = "Jewellery",
		txt = "Sells all Rings",
		params = { event = "jim-mining:JewelSell:Jewellery",
		args = { number = 1, id = 4 } } }, })
end)
--Jewel Selling - Emerald Menu
RegisterNetEvent('jim-mining:JewelSell:Emerald', function()
    TriggerEvent('nh-context:sendMenu', {
	{   id = 1, header = "< Go Back",
		txt = "",
		params = { event = "jim-mining:JewelSell",
		args = { number = 1, id = 1 } } },
	{   id = 2, header = "Emeralds",
		txt = "Sell ALL at $"..Config.SellItems['emerald'].." each",
		params = { event = "jim-mining:SellAnim:Jewel",
		args = { number = 1, id = 10 } } },
	{   id = 3, header = "Uncut Emeralds",
		txt = "Sell ALL at $"..Config.SellItems['uncut_emerald'].." each",
		params = { event = "jim-mining:SellAnim:Jewel",
		args = { number = 1, id = 11 } } }, })
end)
--Jewel Selling - Ruby Menu
RegisterNetEvent('jim-mining:JewelSell:Ruby', function()
    TriggerEvent('nh-context:sendMenu', {
	{   id = 1, header = "< Go Back",
		txt = "",
		params = { event = "jim-mining:JewelSell",
		args = { number = 1, id = 1 } } },
	{   id = 2, header = "Rubys",
		txt = "Sell ALL at $"..Config.SellItems['ruby'].." each",
		params = { event = "jim-mining:SellAnim:Jewel",
		args = { number = 1, id = 12 } } },
	{   id = 3, header = "Uncut Rubys",
		txt = "Sell ALL at $"..Config.SellItems['uncut_ruby'].." each",
		params = { event = "jim-mining:SellAnim:Jewel",
		args = { number = 1, id = 13 } } }, })
end)
--Jewel Selling - Diamonds Menu
RegisterNetEvent('jim-mining:JewelSell:Diamond', function()
    TriggerEvent('nh-context:sendMenu', {
	{   id = 1, header = "< Go Back",
		txt = "",
		params = { event = "jim-mining:JewelSell",
		args = { number = 1, id = 1 } } },
	{   id = 2, header = "Diamonds",
		txt = "Sell ALL at $"..Config.SellItems['diamond'].." each",
		params = { event = "jim-mining:SellAnim:Jewel",
		args = { number = 1, id = 14 } } },
	{   id = 3, header = "Uncut Diamonds",
		txt = "Sell ALL at $"..Config.SellItems['uncut_diamond'].." each",
		params = { event = "jim-mining:SellAnim:Jewel",
		args = { number = 1, id = 15 } } }, })
end)
--Jewel Selling - Jewellry Menu
RegisterNetEvent('jim-mining:JewelSell:Jewellery', function()
    TriggerEvent('nh-context:sendMenu', {
	{   id = 1, header = "< Go Back",
		txt = "",
		params = { event = "jim-mining:JewelSell",
		args = { number = 1, id = 1 } } },
	{   id = 2, header = "Diamond Rings",
		txt = "Sell ALL at $"..Config.SellItems['diamond_ring'].." each",
		params = { event = "jim-mining:SellAnim:Jewel",
		args = { number = 1, id = 16 } } },
	{   id = 3, header = "Gold Rings",
		txt = "Sell ALL at $"..Config.SellItems['gold_ring'].." each",
		params = { event = "jim-mining:SellAnim:Jewel",
		args = { number = 1, id = 17 } } },
	{   id = 3, header = "Gold Chain",
		txt = "Sell ALL at $"..Config.SellItems['goldchain'].." each",
		params = { event = "jim-mining:SellAnim:Jewel",
		args = { number = 1, id = 18 } } },	
	{   id = 5, header = "10k Gold Chain",
		txt = "Sell ALL at $"..Config.SellItems['10kgoldchain'].." each",
		params = { event = "jim-mining:SellAnim:Jewel",
		args = { number = 1, id = 19 } } }, })
end)

------------------------

--Smelting
RegisterNetEvent('jim-mining:SmeltMenu', function()
    TriggerEvent('nh-context:sendMenu', {
	{   id = 1, header = "Sell Batches of Ores for Cash",
		txt = "", }, 
	{   id = 2, header = "Smelt Copper Ore",
		txt = "Smelt Copper Ore into 10 Copper",
		params = { event = "jim-mining:SmeltStart",
		args = { number = 1, id = 1 } } },
	{   id = 3, header = "Smelt Gold",
		txt = "Smelt 4 Gold Ore into 1 Gold Bar",
		params = { event = "jim-mining:SmeltStart",
		args = { number = 1, id = 2 } } },
	{   id = 4, header = "Smelt Iron",
		txt = "Smelt Iron Ore into 10 Iron",
		params = { event = "jim-mining:SmeltStart",
		args = { number = 1, id = 3	} } },
	{   id = 5, header = "Smelt Steel",
		txt = "Smelt Iron Ore and Carbon into Steel",
		params = { event = "jim-mining:SmeltStart",
		args = { number = 1, id = 4 } } }, })
end)


------------------------

--Cutting Jewels
RegisterNetEvent('jim-mining:JewelCut', function()
    TriggerEvent('nh-context:sendMenu', {
	{   id = 1, header = "Jewelry Crafting Bench",
		txt = "", },
	{   id = 2, header = "Cut Emerald",
		txt = "Carefully cut to increase value",
		params = { event = "jim-mining:CutStart",
		args = { number = 1, id = 1 } } },
	{   id = 3, header = "Cut Ruby",
		txt = "Carefully cut to increase value",
		params = { event = "jim-mining:CutStart",
		args = { number = 1, id = 2	} } },
	{   id = 4, header = "Cut Diamond",
		txt = "Carefully cut to increase value",
		params = { event = "jim-mining:CutStart",
		args = { number = 1, id = 3 } } },
	{   id = 5, header = "Make Rings",
		txt = "Go to Ring Crafting Section",
		params = { event = "jim-mining:JewelCut:Ring",
		args = { number = 1, id = 4 } } },
	{   id = 6, header = "Make Necklaces",
		txt = "Go to Necklace Crafting Section",
		params = { event = "jim-mining:JewelCut:Necklace",
		args = { number = 1, id = 4 } } }, })
end

RegisterNetEvent('jim-mining:JewelCut:Ring', function()
    TriggerEvent('nh-context:sendMenu', {
	{   id = 1, header = "< Go Back",
		txt = "",
		params = { event = "jim-mining:JewelCut",
		args = { number = 1, id = 1 } } },
	{   id = 2, header = "Gold Ring x3",
		txt = "Carefully cut to increase value",
		params = { event = "jim-mining:CutStart",
		args = { number = 1, id = 4 } } },
	{   id = 3, header = "Diamond Ring",
		txt = "Requires: 1 Drill - 1 Gold Ore",
		params = { event = "jim-mining:CutStart",
		args = { number = 1, id = 5 } } }, })
end)

RegisterNetEvent('jim-mining:JewelCut:Necklace', function()
    TriggerEvent('nh-context:sendMenu', {
	{   id = 1, header = "< Go Back",
		txt = "",
		params = { event = "jim-mining:JewelCut",
		args = { number = 1, id = 1 } } },
	{   id = 2, header = "Gold Chain x3",
		txt = "Requires 1 Gold Bar",
		params = { event = "jim-mining:CutStart",
		args = { number = 1, id = 6 } } },
	{   id = 3, header = "10k Gold Chain x2",
		txt = "Requires 1 Gold Bar",
		params = { event = "jim-mining:CutStart",
		args = { number = 1, id = 7 } } }, })
end)

