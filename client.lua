local QBCore = exports['qb-core']:GetCoreObject()
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
	--Hide the mineshaft doors
	CreateModelHide(vector3(-596.04, 2089.01, 131.41), 10.5, -1241212535, true)

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
local shopPeds = {}
function CreatePeds()
	while true do
		Citizen.Wait(500)
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
		table.insert(shopPeds, ped)
	else
		ped = CreatePed(genderNum, GetHashKey(v.model), coords, heading, false, true)
		table.insert(shopPeds, ped)
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

function CreateProps()

	--Quickly add outside lighting
		if minelight1 == nil then
			RequestModel(GetHashKey("prop_worklight_03a"))
			while not HasModelLoaded(GetHashKey("prop_worklight_03a")) do Citizen.Wait(1) end
			local minelight1 = CreateObject(GetHashKey("prop_worklight_03a"),-593.29, 2093.22, 131.7-1.05,false,false,false)
			SetEntityHeading(minelight1,GetEntityHeading(minelight1)-80)
			FreezeEntityPosition(minelight1, true)
		end		
		if minelight2 == nil then
			RequestModel(GetHashKey("prop_worklight_03a"))
			while not HasModelLoaded(GetHashKey("prop_worklight_03a")) do Citizen.Wait(1) end
			local minelight2 = CreateObject(GetHashKey("prop_worklight_03a"),-604.55, 2089.74, 131.15-1.05,false,false,false)
			SetEntityHeading(minelight2,GetEntityHeading(minelight2)-260)
			FreezeEntityPosition(minelight2, true)
		end

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
	exports['qb-target']:AddCircleZone("MineShaft", Config.Locations['Mine'].location, 2.0, { name="MineShaft", debugPoly=false, useZ=true, }, 
	{ options = { { event = "jim-mining:openShop", icon = "fas fa-certificate", label = "Browse Store", }, },
		distance = 2.0
	})
	exports['qb-target']:AddCircleZone("Quarry", Config.Locations['Quarry'].location, 2.0, { name="Quarry", debugPoly=false, useZ=true, }, 
	{ options = { { event = "jim-mining:openShop", icon = "fas fa-certificate", label = "Browse Store", }, },
		distance = 2.0
	})
	--Smelter to turn stone into ore
	exports['qb-target']:AddCircleZone("Smelter", Config.Locations['Smelter'].location, 3.0, { name="Smelter", debugPoly=false, useZ=true, }, 
	{ options = { { event = "jim-mining:SmeltMenu", icon = "fas fa-certificate", label = "Use Smelter", }, },
		distance = 10.0
	})
	--Ore Buyer
	exports['qb-target']:AddCircleZone("Buyer", Config.Locations['Buyer'].location, 2.0, { name="Buyer", debugPoly=false, useZ=true, }, 
	{ options = { { event = "jim-mining:SellOre", icon = "fas fa-certificate", label = "Sell Ores", },	},
		distance = 2.0
	})
	--Jewel Cutting Bench
	exports['qb-target']:AddCircleZone("JewelCut", Config.Locations['JewelCut'].location, 2.0, { name="JewelCut", debugPoly=false, useZ=true, }, 
	{ options = { { event = "jim-mining:JewelCut", icon = "fas fa-certificate", label = "Use Jewel Cutting Bench", },	},
		distance = 2.0
	})
	--Jewel Buyer
	exports['qb-target']:AddCircleZone("JewelBuyer", Config.Locations['Buyer2'].location, 2.0, { name="JewelBuyer", debugPoly=false, useZ=true, }, 
	{ options = { { event = "jim-mining:JewelSell", icon = "fas fa-certificate", label = "Talk To Jewel Buyer", },	},
		distance = 2.0
	})
	--Cracking Bench
	exports['qb-target']:AddCircleZone("CrackingBench", Config.Locations['Cracking'].location, 2.0, { name="CrackingBench", debugPoly=false, useZ=true, }, 
	{ options = { { event = "jim-mining:CrackStart", icon = "fas fa-certificate", label = "Use Cracking Bench", },	},
		distance = 2.0
	})
	local ore = 0
	for k,v in pairs(Config.OrePositions) do
		ore = ore+1
		exports['qb-target']:AddCircleZone(ore, v.coords, 2.0, { name=ore, debugPoly=false, useZ=true, }, 
		{ options = { { event = "jim-mining:MineOre", icon = "fas fa-certificate", label = "Mine ore", },	},
			distance = 2.5
		})
	end
end)

-----------------------------------------------------------
--Mining Store Opening
RegisterNetEvent('jim-mining:openShop', function ()
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
				SetEntityAsMissionEntity(DrillObject)--nessesary for gta to even trigger DetachEntity
				Wait(5)
				DetachEntity(DrillObject, true, true)
				Wait(5)
				DeleteObject(DrillObject)
				TriggerServerEvent('jim-mining:MineReward')
				IsDrilling = false
				TriggerServerEvent('jim-mining:MineReward')	
				IsDrilling = false
			end, function() -- Cancel
				StopAnimTask(GetPlayerPed(-1), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
				DetachEntity(DrillObject, true, true)
				DeleteObject(DrillObject)
				IsDrilling = false
			end)
		else
			TriggerEvent('QBCore:Notify', "You dont have a drill", 'error')
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
			TriggerEvent('QBCore:Notify', "You don't have any Stone", 'error')
		end 
	end, "stone")
end)

-- I'm proud of this whole trigger command here
-- I was worried I'd have to do loads of call backs, back and forths in the this command
-- I had a theory that (like with notifications) I'd be able to add in a dynamic variable with the trigger being called
-- IT WORKED, and here we have it calling a item check callback via the ID it recieves from the menu buttons

RegisterNetEvent('jim-mining:MakeItem')
AddEventHandler('jim-mining:MakeItem', function(data)
	for k, v in pairs(data.craftable[data.tablenumber]) do
		QBCore.Functions.TriggerCallback('jim-mining:get', function(amount) 
			if not amount then 
				TriggerEvent('QBCore:Notify', "You don't have the correct ingredients", 'error')
				TriggerEvent('jim-mining:SmeltMenu')
			else itemProgress(data.item, data.tablenumber, data.craftable) end		
		end, data.item, data.tablenumber, data.craftable)
	end
end)

RegisterNetEvent('jim-mining:MakeItem:Cutting')
AddEventHandler('jim-mining:MakeItem:Cutting', function(data)
	QBCore.Functions.TriggerCallback("jim-mining:Cutting:Check:Tools",function(hasTools)
		if hasTools then
			for k, v in pairs(data.craftable[data.tablenumber]) do
				QBCore.Functions.TriggerCallback('jim-mining:get', function(amount) 
					if not amount then 
						TriggerEvent('QBCore:Notify', "You don't have the correct ingredients", 'error')
					else itemProgress(data.item, data.tablenumber, data.craftable) end		
				end, data.item, data.tablenumber, data.craftable)
			end
		else
			TriggerEvent('QBCore:Notify', "You don\'t have a Hand Drill or Drill Bit", 'error')
			TriggerEvent('jim-mining:JewelCut')
		end
	end)
end)

function itemProgress(ItemMake, tablenumber, craftable)
	if craftable then
		for i = 1, #Crafting.SmeltMenu do
			for k, v in pairs(Crafting.SmeltMenu[i]) do
				if ItemMake == k then
					bartext = "Smelting "..QBCore.Shared.Items[ItemMake].label
					bartime = 7000
					animDictNow = "amb@prop_human_parking_meter@male@idle_a"
					animNow = "idle_a"
				end
			end
		end
		for i = 1, #Crafting.GemCut do
			for k, v in pairs(Crafting.GemCut[i]) do
				if ItemMake == k then
					bartext = "Cutting "..QBCore.Shared.Items[ItemMake].label
					bartime = 7000
					animDictNow = "amb@prop_human_parking_meter@male@idle_a"
					animNow = "idle_a"
				end
			end
		end
		for i = 1, #Crafting.RingCut do	
			for k, v in pairs(Crafting.RingCut[i]) do
				if ItemMake == k then
					bartext = "Cutting "..QBCore.Shared.Items[ItemMake].label
					bartime = 7000
					animDictNow = "amb@prop_human_parking_meter@male@idle_a"
					animNow = "idle_a"
				end
			end
		end
		for i = 1, #Crafting.NeckCut do
			for k, v in pairs(Crafting.NeckCut[i]) do
				if ItemMake == k then
					bartext = "Cutting "..QBCore.Shared.Items[ItemMake].label
					bartime = 7000
					animDictNow = "amb@prop_human_parking_meter@male@idle_a"
					animNow = "idle_a"
				end
			end
		end
	end
	QBCore.Functions.Progressbar('making_food', bartext, bartime, false, false, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = animDictNow,
		anim = animNow,
		flags = 8,
	}, {}, {}, function()  
		TriggerServerEvent('jim-mining:GetItem', ItemMake, tablenumber, craftable)
		StopAnimTask(GetPlayerPed(-1), animDictNow, animNow, 1.0)
	end, function() -- Cancel
		TriggerEvent('inventory:client:busy:status', false)
		TriggerEvent('QBCore:Notify', "Cancelled!", 'error')
	end)
end
------------------------------------------------------------
--These also lead to the actual selling commands

--Selling animations are simply a pass item to seller animation
--Sell Ore Animation
--Sell Anim small Test
RegisterNetEvent('jim-mining:SellAnim')
AddEventHandler('jim-mining:SellAnim', function(data)
	if data == -2 then
		exports['qb-menu']:closeMenu()
		return
	end
	local pid = PlayerPedId()
	loadAnimDict("mp_common")
	TriggerServerEvent('jim-mining:Selling', data) -- Had to slip in the sell command during the animation command
	for k,v in pairs (shopPeds) do
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
RegisterNetEvent('jim-mining:SellAnim:Jewel')
AddEventHandler('jim-mining:SellAnim:Jewel', function(data)
	if data == -2 then
		exports['qb-menu']:closeMenu()
		return
	end	
	local pid = PlayerPedId()
	loadAnimDict("mp_common")
	TriggerServerEvent('jim-mining:SellJewel', data) -- Had to slip in the sell command during the animation command
	for k,v in pairs (shopPeds) do
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
	if string.find(data, "ring") then TriggerEvent('jim-mining:JewelSell:Rings')
	elseif string.find(data, "chain") or string.find(data, "necklace") then TriggerEvent('jim-mining:JewelSell:Necklace')
	elseif string.find(data, "emerald") then TriggerEvent('jim-mining:JewelSell:Emerald')
	elseif string.find(data, "ruby") then TriggerEvent('jim-mining:JewelSell:Ruby')
	elseif string.find(data, "diamond") then TriggerEvent('jim-mining:JewelSell:Diamond')
	elseif string.find(data, "sapphire") then TriggerEvent('jim-mining:JewelSell:Sapphire') end
end)


------------------------------------------------------------
--Context Menus
--Selling Ore
RegisterNetEvent('jim-mining:SellOre', function()
	exports['qb-menu']:openMenu({
		{ header = "Ore Selling", txt = "Sell Batches of Ore for cash", isMenuHeader = true },
		{ header = "", txt = "✘ Close", params = { event = "jim-mining:SellAnim", args = -2 } },
		{ header = "Copper Ore", txt = "Sell ALL at $"..Config.SellItems['copperore'].." each", params = { event = "jim-mining:SellAnim", args = 'copperore' } },
		{ header = "Iron Ore", txt = "Sell ALL at $"..Config.SellItems['ironore'].." each", params = { event = "jim-mining:SellAnim", args = 'ironore' } },
		{ header = "Gold Ore", txt = "Sell ALL at $"..Config.SellItems['goldore'].." each", params = { event = "jim-mining:SellAnim", args = 'goldore' } },
		{ header = "Carbon", txt = "Sell ALL at $"..Config.SellItems['carbon'].." each", params = { event = "jim-mining:SellAnim", args = 'carbon' } }, 
	})
end)
------------------------
--Jewel Selling Main Menu
RegisterNetEvent('jim-mining:JewelSell', function()
    exports['qb-menu']:openMenu({
		{ header = "Jewellery Buyer", txt = "Sell your jewellery here", isMenuHeader = true }, 
		{ header = "", txt = "✘ Close", params = { event = "jim-mining:SellAnim:Jewel", args = -2 } },
		{ header = "Emeralds", txt = "See all Emerald selling options", params = { event = "jim-mining:JewelSell:Emerald", } },
		{ header = "Rubys", txt = "See all Ruby selling options", params = { event = "jim-mining:JewelSell:Ruby", } },
		{ header = "Diamonds", txt = "See all Diamond selling options", params = { event = "jim-mining:JewelSell:Diamond", } },
		{ header = "Sapphires", txt = "See all Sapphire selling options", params = { event = "jim-mining:JewelSell:Sapphire", } },
		{ header = "Rings", txt = "See all Ring Options", params = { event = "jim-mining:JewelSell:Rings", } },
		{ header = "Necklaces", txt = "See all Necklace Options", params = { event = "jim-mining:JewelSell:Necklace", } },
	})
end)
--Jewel Selling - Emerald Menu
RegisterNetEvent('jim-mining:JewelSell:Emerald', function()
    exports['qb-menu']:openMenu({
		{ header = "Jewellery Buyer", txt = "Sell your jewellery here", isMenuHeader = true }, 
		{ header = "", txt = "⬅ Return", params = { event = "jim-mining:JewelSell", } },
		{ header = "Emeralds", txt = "Sell ALL at $"..Config.SellItems['emerald'].." each", params = { event = "jim-mining:SellAnim:Jewel", args = 'emerald' } },
		{ header = "Uncut Emeralds", txt = "Sell ALL at $"..Config.SellItems['uncut_emerald'].." each", params = { event = "jim-mining:SellAnim:Jewel", args = 'uncut_emerald' } }, 
	})
end)
--Jewel Selling - Ruby Menu
RegisterNetEvent('jim-mining:JewelSell:Ruby', function()
    exports['qb-menu']:openMenu({
		{ header = "Jewellery Buyer", txt = "Sell your jewellery here", isMenuHeader = true }, 
		{ header = "", txt = "⬅ Return", params = { event = "jim-mining:JewelSell", } },
		{ header = "Rubys", txt = "Sell ALL at $"..Config.SellItems['ruby'].." each", params = { event = "jim-mining:SellAnim:Jewel", args = 'ruby' } },
		{ header = "Uncut Rubys", txt = "Sell ALL at $"..Config.SellItems['uncut_ruby'].." each", params = { event = "jim-mining:SellAnim:Jewel", args = 'uncut_ruby' } },
	})
end)
--Jewel Selling - Diamonds Menu
RegisterNetEvent('jim-mining:JewelSell:Diamond', function()
    exports['qb-menu']:openMenu({
		{ header = "Jewellery Buyer", txt = "Sell your jewellery here", isMenuHeader = true }, 
		{ header = "", txt = "⬅ Return", params = { event = "jim-mining:JewelSell", } },
		{ header = "Diamonds", txt = "Sell ALL at $"..Config.SellItems['diamond'].." each", params = { event = "jim-mining:SellAnim:Jewel", args = 'diamond' } },
		{ header = "Uncut Diamonds", txt = "Sell ALL at $"..Config.SellItems['uncut_diamond'].." each", params = { event = "jim-mining:SellAnim:Jewel", args = 'uncut_diamond' } },
	})
end)
--Jewel Selling - Sapphire Menu
RegisterNetEvent('jim-mining:JewelSell:Sapphire', function()
    exports['qb-menu']:openMenu({
		{ header = "Jewellery Buyer", txt = "Sell your jewellery here", isMenuHeader = true }, 
		{ header = "", txt = "⬅ Return", params = { event = "jim-mining:JewelSell", } },
		{ header = "Sapphires", txt = "Sell ALL at $"..Config.SellItems['sapphire'].." each", params = { event = "jim-mining:SellAnim:Jewel", args = 'sapphire' } },
		{ header = "Uncut Sapphires", txt = "Sell ALL at $"..Config.SellItems['uncut_sapphire'].." each", params = { event = "jim-mining:SellAnim:Jewel", args = 'uncut_sapphire' } },
	})
end)

--Jewel Selling - Jewellry Menu
RegisterNetEvent('jim-mining:JewelSell:Rings', function()
    exports['qb-menu']:openMenu({
		{ header = "Jewellery Buyer", txt = "Sell your jewellery here", isMenuHeader = true }, 
		{ header = "", txt = "⬅ Return", params = { event = "jim-mining:JewelSell", } },
		{ header = "Gold Rings", txt = "Sell ALL at $"..Config.SellItems['gold_ring'].." each", params = { event = "jim-mining:SellAnim:Jewel", args = 'gold_ring' } },
		{ header = "Diamond Rings", txt = "Sell ALL at $"..Config.SellItems['diamond_ring'].." each", params = { event = "jim-mining:SellAnim:Jewel", args = 'diamond_ring'} },
		{ header = "Emerald Rings", txt = "Sell ALL at $"..Config.SellItems['emerald_ring'].." each", params = { event = "jim-mining:SellAnim:Jewel", args = 'emerald_ring' } },
		{ header = "Ruby Rings", txt = "Sell ALL at $"..Config.SellItems['ruby_ring'].." each", params = { event = "jim-mining:SellAnim:Jewel", args = 'ruby_ring' } },	
		{ header = "Sapphire Rings", txt = "Sell ALL at $"..Config.SellItems['sapphire_ring'].." each", params = { event = "jim-mining:SellAnim:Jewel", args = 'sapphire_ring' } },
	})
end)
--Jewel Selling - Jewellery Menu
RegisterNetEvent('jim-mining:JewelSell:Necklace', function()
    exports['qb-menu']:openMenu({
		{ header = "Jewellery Buyer", txt = "Sell your jewellery here", isMenuHeader = true }, 
		{ header = "", txt = "⬅ Return", params = { event = "jim-mining:JewelSell", } },
		{ header = "Gold Chains",	txt = "Sell ALL at $"..Config.SellItems['goldchain'].." each", params = { event = "jim-mining:SellAnim:Jewel", args = 'goldchain' } },
		{ header = "Gold Chains", txt = "Sell ALL at $"..Config.SellItems['10kgoldchain'].." each", params = { event = "jim-mining:SellAnim:Jewel", args = '10kgoldchain' } },
		{ header = "Diamond Necklace", txt = "Sell ALL at $"..Config.SellItems['diamond_necklace'].." each", params = { event = "jim-mining:SellAnim:Jewel", args = 'diamond_necklace' } },
		{ header = "Emerald Necklace", txt = "Sell ALL at $"..Config.SellItems['emerald_necklace'].." each", params = { event = "jim-mining:SellAnim:Jewel", args = 'emerald_necklace' } },
		{ header = "Ruby Necklace", txt = "Sell ALL at $"..Config.SellItems['ruby_necklace'].." each", params = { event = "jim-mining:SellAnim:Jewel", args = 'ruby_necklace' } },	
		{ header = "Sapphire Necklace", txt = "Sell ALL at $"..Config.SellItems['sapphire_necklace'].." each", params = { event = "jim-mining:SellAnim:Jewel", args = 'sapphire_necklace' } },
	})
end)
------------------------

--Smelting
RegisterNetEvent('jim-mining:SmeltMenu', function()
	local SmeltMenu = {}
	SmeltMenu[#SmeltMenu + 1] = { header = "Smelter", txt = "Smelt ores down into usable materials", isMenuHeader = true }
	SmeltMenu[#SmeltMenu + 1] = { header = "", txt = "✘ Close", params = { event = "jim-mining:SellAnim", args = -2 } }
		for i = 1, #Crafting.SmeltMenu do
			for k, v in pairs(Crafting.SmeltMenu[i]) do
				if k ~= "amount" then
					local text = ""
					if Crafting.SmeltMenu[i]["amount"] then amount = " x"..Crafting.SmeltMenu[i]["amount"] else amount = "" end
					setheader = QBCore.Shared.Items[k].label..tostring(amount)
					for l, b in pairs(Crafting.SmeltMenu[i][tostring(k)]) do
						if b == 1 then number = "" else number = " x"..b end
						text = text.."- "..QBCore.Shared.Items[l].label..number.."<br>"
						settext = text
					end
					SmeltMenu[#SmeltMenu + 1] = { header = "<img src=nui://"..Config.ImageLink..QBCore.Shared.Items[k].image.." width=35px> "..setheader, txt = settext, params = { event = "jim-mining:MakeItem", args = { item = k, tablenumber = i, craftable = Crafting.SmeltMenu } } }
					settext, amount, setheader = nil
				end
			end
		end
	exports['qb-menu']:openMenu(SmeltMenu)
end)
------------------------

--Cutting Jewels
RegisterNetEvent('jim-mining:JewelCut', function()
    exports['qb-menu']:openMenu({
	{ header = "Jewellery Crafting Bench", txt = "Requires Hand Drill & Drill Bit", isMenuHeader = true },
	{ header = "", txt = "✘ Close", params = { event = "jim-mining:SellAnim", args = -2 } },
	{ header = "Gem Cutting",	txt = "Go to Gem Cutting Section", params = { event = "jim-mining:JewelCut:Gem", } },
	{ header = "Make Rings", txt = "Go to Ring Crafting Section", params = { event = "jim-mining:JewelCut:Ring", } },
	{ header = "Make Necklaces", txt = "Go to Necklace Crafting Section", params = { event = "jim-mining:JewelCut:Necklace", } },
	})
end)

--Gem Section
RegisterNetEvent('jim-mining:JewelCut:Gem', function()
	local GemCut = {}
	GemCut[#GemCut + 1] = { header = "Jewellery Crafting Bench", txt = "Requires Hand Drill & Drill Bit", isMenuHeader = true }
	GemCut[#GemCut + 1] = { header = "", txt = "⬅ Return", params = { event = "jim-mining:JewelCut", } }
		for i = 1, #Crafting.GemCut do
			for k, v in pairs(Crafting.GemCut[i]) do
				if k ~= "amount" then
					local text = ""
					if Crafting.GemCut[i]["amount"] then amount = " x"..Crafting.GemCut[i]["amount"] else amount = "" end
					setheader = QBCore.Shared.Items[k].label..tostring(amount)
					for l, b in pairs(Crafting.GemCut[i][tostring(k)]) do
						if b == 1 then number = "" else number = " x"..b end
						text = text.."- "..QBCore.Shared.Items[l].label..number.."<br>"
						settext = text
					end
					GemCut[#GemCut + 1] = { header = "<img src=nui://"..Config.ImageLink..QBCore.Shared.Items[k].image.." width=35px> "..setheader, txt = settext, params = { event = "jim-mining:MakeItem:Cutting", args = { item = k, tablenumber = i, craftable = Crafting.GemCut } } }
					settext, setheader = nil
				end
			end
		end
	exports['qb-menu']:openMenu(GemCut)
end)

-- Ring Section
RegisterNetEvent('jim-mining:JewelCut:Ring', function()
	local RingCut = {}
	RingCut[#RingCut + 1] = { header = "Jewellery Crafting Bench", txt = "Requires Hand Drill & Drill Bit", isMenuHeader = true }
	RingCut[#RingCut + 1] = { header = "", txt = "⬅ Return", params = { event = "jim-mining:JewelCut", } }
		for i = 1, #Crafting.RingCut do
			for k, v in pairs(Crafting.RingCut[i]) do
				if k ~= "amount" then
					local text = ""
					if Crafting.RingCut[i]["amount"] then amount = " x"..Crafting.RingCut[i]["amount"] else amount = "" end
					setheader = QBCore.Shared.Items[k].label..tostring(amount)
					for l, b in pairs(Crafting.RingCut[i][tostring(k)]) do
						if b == 1 then number = "" else number = " x"..b end
						text = text.."- "..QBCore.Shared.Items[l].label..number.."<br>"
						settext = text
					end
					RingCut[#RingCut + 1] = { header = "<img src=nui://"..Config.ImageLink..QBCore.Shared.Items[k].image.." width=35px>"..setheader, txt = settext, params = { event = "jim-mining:MakeItem:Cutting", args = { item = k, tablenumber = i, craftable = Crafting.RingCut } } }
					settext, setheader = nil
				end
			end
		end
	exports['qb-menu']:openMenu(RingCut)
end)

--Necklace Section
RegisterNetEvent('jim-mining:JewelCut:Necklace', function()
	local NeckCut = {}
	NeckCut[#NeckCut + 1] = { header = "Jewellery Crafting Bench", txt = "Requires Hand Drill & Drill Bit", isMenuHeader = true }
	NeckCut[#NeckCut + 1] = { header = "", txt = "⬅ Return", params = { event = "jim-mining:JewelCut", } }
		for i = 1, #Crafting.NeckCut do
			for k, v in pairs(Crafting.NeckCut[i]) do
				if k ~= "amount" then
					local text = ""
					if Crafting.NeckCut[i]["amount"] then amount = " x"..Crafting.NeckCut[i]["amount"] else amount = "" end
					setheader = QBCore.Shared.Items[k].label..tostring(amount)
					for l, b in pairs(Crafting.NeckCut[i][tostring(k)]) do
						if b == 1 then number = "" else number = " x"..b end
						text = text.."- "..QBCore.Shared.Items[l].label..number.."<br>"
						settext = text
					end
					NeckCut[#NeckCut + 1] = { header = "<img src=nui://"..Config.ImageLink..QBCore.Shared.Items[k].image.." width=35px>"..setheader, txt = settext, params = { event = "jim-mining:MakeItem:Cutting", args = { item = k, tablenumber = i, craftable = Crafting.NeckCut } } }
					settext, setheader = nil
				end
			end
		end
	exports['qb-menu']:openMenu(NeckCut)
end)
