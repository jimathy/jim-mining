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
	exports['bt-target']:AddCircleZone("MineShaft", Config.Locations['Mine'].location, 2.0, { name="MineShaft", debugPoly=false, useZ=true, }, 
	{ options = { { event = "jim-mining:openShop", icon = "fas fa-certificate", label = "Browse Store", }, },
		job = {"all"}, distance = 2.0
	})
	exports['bt-target']:AddCircleZone("Quarry", Config.Locations['Quarry'].location, 2.0, { name="Quarry", debugPoly=false, useZ=true, }, 
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
RegisterNetEvent('jim-mining:Cutting:Begin')
AddEventHandler('jim-mining:Cutting:Begin', function (data)
	QBCore.Functions.TriggerCallback("jim-mining:Cutting:Check:Tools",function(hasTools)
		if hasTools then
			QBCore.Functions.TriggerCallback("jim-mining:Cutting:Check:"..data.id,function(hasReq) 
				if hasReq then 
					local pos = GetEntityCoords(GetPlayerPed(-1))
					loadAnimDict('amb@prop_human_parking_meter@male@idle_a')
					TaskPlayAnim(GetPlayerPed(-1), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a' , 3.0, 3.0, -1, 1, 0, false, false, false)
					QBCore.Functions.Progressbar("open_locker_drill", "Cutting..", math.random(10000,15000), false, true, {
						disableMovement = true, disableCarMovement = true,disableMouse = false,	disableCombat = true, }, {}, {}, {}, function() -- Done
						StopAnimTask(GetPlayerPed(-1), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 1.0)
							TriggerServerEvent('jim-mining:Cutting:Reward', data.id)
							IsDrilling = false
					end, function() -- Cancel
						StopAnimTask(GetPlayerPed(-1), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 1.0)
						IsDrilling = false
					end)
				else
					QBCore.Functions.Notify("You don\'t have all ingredients!", "error")
				end
			end)
		else
			QBCore.Functions.Notify("You don\'t have a Hand Drill or Drill Bit", "error")
		end
	end)
end)

-- I'm proud of this whole trigger command here
-- I was worried I'd have to do loads of call backs, back and forths in the this command
-- I had a theory that (like with notifications) I'd be able to add in a dynamic variable with the trigger being called
-- IT WORKED, and here we have it calling a item check callback vite the ID it recieves from the menu buttons

-- Smelt Command / Animations
RegisterNetEvent('jim-mining:Smelting:Begin')
AddEventHandler('jim-mining:Smelting:Begin', function (data)
	QBCore.Functions.TriggerCallback("jim-mining:Smelting:Check:"..data.id,function(hasReq) 
		if hasReq then 
			local pos = GetEntityCoords(GetPlayerPed(-1))
			loadAnimDict('amb@prop_human_parking_meter@male@idle_a')
			TaskPlayAnim(GetPlayerPed(-1), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a' , 3.0, 3.0, -1, 1, 0, false, false, false)
			QBCore.Functions.Progressbar("open_locker_drill", "Smelting..", math.random(10000,15000), false, true, {
				disableMovement = true, disableCarMovement = true,disableMouse = false,	disableCombat = true, }, {}, {}, {}, function() -- Done
				StopAnimTask(GetPlayerPed(-1), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 1.0)
	
					TriggerServerEvent('jim-mining:Smelting:Reward', data) -- When animations finished this is called and does the correct reward command via the ID it received from the menu
	
					IsDrilling = false
			end, function() -- Cancel
				StopAnimTask(GetPlayerPed(-1), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 1.0)
				IsDrilling = false
			end)
		else
			QBCore.Functions.Notify("You don\'t have all ingredients!", "error")
		end
	end)
end)


------------------------------------------------------------
--These also lead to the actual selling commands

--Selling animations are simply a pass item to seller animation
--Sell Ore Animation
--Sell Anim small Test
RegisterNetEvent('jim-mining:SellAnim')
AddEventHandler('jim-mining:SellAnim', function(data)
	local pid = PlayerPedId()
	loadAnimDict("mp_common")
	TriggerServerEvent('jim-mining:Selling', data) -- Had to slip in the sell command during the animation command
	for k,v in pairs (shopPeds) do
        pCoords = GetEntityCoords(PlayerPedId())
        ppCoords = GetEntityCoords(v)
        dist = #(pCoords - ppCoords)
        if dist < 2 then 
			TaskPlayAnim(pid, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
            TaskPlayAnim(v, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
            Wait(1500)
            StopAnimTask(pid, "mp_common", "givetake2_a", 1.0)
            StopAnimTask(v, "mp_common", "givetake2_a", 1.0)
            RemoveAnimDict("mp_common")
			break
		end
	end
end)


--Sell Anim small Test
RegisterNetEvent('jim-mining:SellAnim:Jewel')
AddEventHandler('jim-mining:SellAnim:Jewel', function(data)
	local pid = PlayerPedId()
	loadAnimDict("mp_common")
	TriggerServerEvent('jim-mining:SellJewel', data.id) -- Had to slip in the sell command during the animation command
	for k,v in pairs (shopPeds) do
        pCoords = GetEntityCoords(PlayerPedId())
        ppCoords = GetEntityCoords(v)
        dist = #(pCoords - ppCoords)
        if dist < 2 then 
			TaskPlayAnim(pid, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
            TaskPlayAnim(v, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
            Wait(1500)
            StopAnimTask(pid, "mp_common", "givetake2_a", 1.0)
            StopAnimTask(v, "mp_common", "givetake2_a", 1.0)
            RemoveAnimDict("mp_common")
			break
		end
	end
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
		params = { event = "jim-mining:SellAnim",
		args = { number = 1, mat = 'copperore' } } },
	{   id = 3,	header = "Iron Ore",
		txt = "Sell ALL at $"..Config.SellItems['ironore'].." each",
		params = { event = "jim-mining:SellAnim",
		args = { number = 1,  mat = 'ironore' } } },
	{   id = 4, header = "Gold Ore",
		txt = "Sell ALL at $"..Config.SellItems['goldore'].." each",
		params = { event = "jim-mining:SellAnim",
		args = { number = 1,  mat = 'goldore' } } },
	{   id = 5, header = "Carbon",
		txt = "Sell ALL at $"..Config.SellItems['carbon'].." each",
		params = { event = "jim-mining:SellAnim",
		args = { number = 1,  mat = 'carbon' } } }, })
end)
------------------------
--Jewel Selling Main Menu
RegisterNetEvent('jim-mining:JewelSell', function()
    TriggerEvent('nh-context:sendMenu', {
	{   id = 1, header = "Sell your jewellery here",
		txt = "", }, 
	{   id = 2, header = "Emeralds",
		txt = "See all Emerald selling options",
		params = { event = "jim-mining:JewelSell:Emerald", } },
	{   id = 3, header = "Rubys",
		txt = "See all Ruby selling options",
		params = { event = "jim-mining:JewelSell:Ruby", } },
	{   id = 4, header = "Diamonds",
		txt = "See all Diamond selling options",
		params = { event = "jim-mining:JewelSell:Diamond", } },
	{   id = 5, header = "Sapphires",
		txt = "See all Sapphire selling options",
		params = { event = "jim-mining:JewelSell:Sapphire", } },
	{   id = 6, header = "Rings",
		txt = "See all Ring Options",
		params = { event = "jim-mining:JewelSell:Rings", } },
	{   id = 7, header = "Rings",
		txt = "See all Necklace Options",
		params = { event = "jim-mining:JewelSell:Necklace", } },})
end)
--Jewel Selling - Emerald Menu
RegisterNetEvent('jim-mining:JewelSell:Emerald', function()
    TriggerEvent('nh-context:sendMenu', {
	{   id = 1, header = "< Go Back",
		txt = "",
		params = { event = "jim-mining:JewelSell", } },
	{   id = 2, header = "Emeralds",
		txt = "Sell ALL at $"..Config.SellItems['emerald'].." each",
		params = { event = "jim-mining:SellAnim",
		args = { number = 1, mat = 'emerald' } } },
	{   id = 3, header = "Uncut Emeralds",
		txt = "Sell ALL at $"..Config.SellItems['uncut_emerald'].." each",
		params = { event = "jim-mining:SellAnim",
		args = { number = 1, mat = 'uncut_emerald' } } }, })
end)
--Jewel Selling - Ruby Menu
RegisterNetEvent('jim-mining:JewelSell:Ruby', function()
    TriggerEvent('nh-context:sendMenu', {
	{   id = 1, header = "< Go Back",
		txt = "",
		params = { event = "jim-mining:JewelSell", } },
	{   id = 2, header = "Rubys",
		txt = "Sell ALL at $"..Config.SellItems['ruby'].." each",
		params = { event = "jim-mining:SellAnim",
		args = { number = 1, mat = 'ruby' } } },
	{   id = 3, header = "Uncut Rubys",
		txt = "Sell ALL at $"..Config.SellItems['uncut_ruby'].." each",
		params = { event = "jim-mining:SellAnim",
		args = { number = 1, mat = 'uncut_ruby' } } }, })
end)
--Jewel Selling - Diamonds Menu
RegisterNetEvent('jim-mining:JewelSell:Diamond', function()
    TriggerEvent('nh-context:sendMenu', {
	{   id = 1, header = "< Go Back",
		txt = "",
		params = { event = "jim-mining:JewelSell", } },
	{   id = 2, header = "Diamonds",
		txt = "Sell ALL at $"..Config.SellItems['diamond'].." each",
		params = { event = "jim-mining:SellAnim",
		args = { number = 1, mat = 'diamond' } } },
	{   id = 3, header = "Uncut Diamonds",
		txt = "Sell ALL at $"..Config.SellItems['uncut_diamond'].." each",
		params = { event = "jim-mining:SellAnim",
		args = { number = 1, mat = 'uncut_diamond' } } }, })
end)
--Jewel Selling - Sapphire Menu
RegisterNetEvent('jim-mining:JewelSell:Sapphire', function()
    TriggerEvent('nh-context:sendMenu', {
	{   id = 1, header = "< Go Back",
		txt = "",
		params = { event = "jim-mining:JewelSell", } },
	{   id = 2, header = "Sapphire",
		txt = "Sell ALL at $"..Config.SellItems['sapphire'].." each",
		params = { event = "jim-mining:SellAnim",
		args = { number = 1, mat = 'sapphire' } } },
	{   id = 3, header = "Uncut Sapphire",
		txt = "Sell ALL at $"..Config.SellItems['uncut_sapphire'].." each",
		params = { event = "jim-mining:SellAnim",
		args = { number = 1, mat = 'uncut_sapphire' } } }, })
end)

--Jewel Selling - Jewellry Menu
RegisterNetEvent('jim-mining:JewelSell:Rings', function()
    TriggerEvent('nh-context:sendMenu', {
	{   id = 1, header = "< Go Back",
		txt = "",
		params = { event = "jim-mining:JewelSell", } },
	{   id = 2, header = "Gold Rings",
		txt = "Sell ALL at $"..Config.SellItems['gold_ring'].." each",
		params = { event = "jim-mining:SellAnim",
		args = { number = 1, mat = 'gold_ring' } } },
	{   id = 3, header = "Diamond Rings",
		txt = "Sell ALL at $"..Config.SellItems['diamond_ring'].." each",
		params = { event = "jim-mining:SellAnim",
		args = { number = 1, mat = 'diamond_ring'} } },
	{   id = 4, header = "Emerald Rings",
		txt = "Sell ALL at $"..Config.SellItems['emerald_ring'].." each",
		params = { event = "jim-mining:SellAnim",
		args = { number = 1, mat = 'emerald_ring' } } },
	{   id = 5, header = "Ruby Rings",
		txt = "Sell ALL at $"..Config.SellItems['ruby_ring'].." each",
		params = { event = "jim-mining:SellAnim",
		args = { number = 1, mat = 'ruby_ring' } } },	
	{   id = 6, header = "Sapphire Rings",
		txt = "Sell ALL at $"..Config.SellItems['sapphire_ring'].." each",
		params = { event = "jim-mining:SellAnim",
		args = { number = 1, mat = 'sapphire_ring' } } }, })
end)
--Jewel Selling - Jewellry Menu
RegisterNetEvent('jim-mining:JewelSell:Necklace', function()
    TriggerEvent('nh-context:sendMenu', {
	{   id = 1, header = "< Go Back",
		txt = "",
		params = { event = "jim-mining:JewelSell", } },
	{   id = 2, header = "Gold Chains",
		txt = "Sell ALL at $"..Config.SellItems['goldchain'].." each",
		params = { event = "jim-mining:SellAnim",
		args = { number = 1, mat = 'goldchain' } } },
	{   id = 3, header = "Gold Chains",
		txt = "Sell ALL at $"..Config.SellItems['10kgoldchain'].." each",
		params = { event = "jim-mining:SellAnim",
		args = { number = 1, mat = '10kgoldchain' } } },
	{   id = 4, header = "Diamond Necklace",
		txt = "Sell ALL at $"..Config.SellItems['diamond_necklace'].." each",
		params = { event = "jim-mining:SellAnim",
		args = { number = 1, mat = 'diamond_necklace' } } },
	{   id = 5, header = "Emerald Necklace",
		txt = "Sell ALL at $"..Config.SellItems['emerald_necklace'].." each",
		params = { event = "jim-mining:SellAnim",
		args = { number = 1, mat = 'emerald_necklace' } } },
	{   id = 6, header = "Ruby Necklace",
		txt = "Sell ALL at $"..Config.SellItems['ruby_necklace'].." each",
		params = { event = "jim-mining:SellAnim",
		args = { number = 1, mat = 'ruby_necklace' } } },	
	{   id = 7, header = "Sapphire Necklace",
		txt = "Sell ALL at $"..Config.SellItems['sapphire_necklace'].." each",
		params = { event = "jim-mining:SellAnim",
		args = { number = 1, mat = 'sapphire_necklace' } } }, })
end)
------------------------

--Smelting
RegisterNetEvent('jim-mining:SmeltMenu', function()
    TriggerEvent('nh-context:sendMenu', {
	{   id = 1, header = "Sell Batches of Ores for Cash",
		txt = "", }, 
	{   id = 2, header = "Smelt Copper Ore",
		txt = "Smelt Copper Ore into 10 Copper",
		params = { event = "jim-mining:Smelting:Begin",
		args = { number = 1, id = 1 } } },
	{   id = 3, header = "Smelt Gold",
		txt = "Smelt 4 Gold Ore into 1 Gold Bar",
		params = { event = "jim-mining:Smelting:Begin",
		args = { number = 1, id = 2 } } },
	{   id = 4, header = "Smelt Iron",
		txt = "Smelt Iron Ore into 10 Iron",
		params = { event = "jim-mining:Smelting:Begin",
		args = { number = 1, id = 3	} } },
	{   id = 5, header = "Smelt Steel",
		txt = "Smelt Iron Ore and Carbon into Steel",
		params = { event = "jim-mining:Smelting:Begin",
		args = { number = 1, id = 4 } } }, })
end)


------------------------

--Cutting Jewels
RegisterNetEvent('jim-mining:JewelCut', function()
    TriggerEvent('nh-context:sendMenu', {
	{   id = 1, header = "Jewellery Crafting Bench",
		txt = "Requires Hand Drill & Drill Bit", },
	{   id = 2, header = "Gem Cutting",
		txt = "Go to Gem Cutting Section",
		params = { event = "jim-mining:JewelCut:Gem", } },
	{   id = 3, header = "Make Rings",
		txt = "Go to Ring Crafting Section",
		params = { event = "jim-mining:JewelCut:Ring", } },
	{   id = 4, header = "Make Necklaces",
		txt = "Go to Necklace Crafting Section",
		params = { event = "jim-mining:JewelCut:Necklace", } }, })
end)
--Gem Section
RegisterNetEvent('jim-mining:JewelCut:Gem', function()
    TriggerEvent('nh-context:sendMenu', {
	{   id = 1, header = "< Go Back",
		txt = "",
		params = { event = "jim-mining:JewelCut", } },
	{   id = 2, header = "Emerald",
		txt = "Carefully cut to increase value",
		params = { event = "jim-mining:Cutting:Begin",
		args = { number = 1, id = 1 } } },
	{   id = 3, header = "Ruby",
		txt = "Carefully cut to increase value",
		params = { event = "jim-mining:Cutting:Begin",
		args = { number = 1, id = 2	} } },
	{   id = 4, header = "Diamond",
		txt = "Carefully cut to increase value",
		params = { event = "jim-mining:Cutting:Begin",
		args = { number = 1, id = 3 } } },
	{   id = 5, header = "Sapphire",
		txt = "Carefully cut to increase value",
		params = { event = "jim-mining:Cutting:Begin",
		args = { number = 1, id = 4 } } }, })
end)
-- Ring Section
RegisterNetEvent('jim-mining:JewelCut:Ring', function()
    TriggerEvent('nh-context:sendMenu', {
	{   id = 1, header = "< Go Back",
		txt = "",
		params = { event = "jim-mining:JewelCut", } },
	{   id = 2, header = "Gold Ring x3",
		txt = "Requires 1 Gold Bar",
		params = { event = "jim-mining:Cutting:Begin",
		args = { number = 1, id = 5 } } },
	{   id = 3, header = "Diamond Ring",
		txt = "Requires 1 Gold Ring & 1 Diamond",
		params = { event = "jim-mining:Cutting:Begin",
		args = { number = 1, id = 6 } } },
	{   id = 4, header = "Emerald Ring",
		txt = "Requires 1 Gold Ring & 1 Emerald",
		params = { event = "jim-mining:Cutting:Begin",
		args = { number = 1, id = 7 } } },
	{   id = 5, header = "Ruby Ring",
		txt = "Requires 1 Gold Ring & 1 Ruby",
		params = { event = "jim-mining:Cutting:Begin",
		args = { number = 1, id = 8 } } },
	{   id = 6, header = "Sapphire Ring",
		txt = "Requires 1 Gold Ring & 1 Sapphire",
		params = { event = "jim-mining:Cutting:Begin",
		args = { number = 1, id = 9 } } }, })
end)
--Necklace Section
RegisterNetEvent('jim-mining:JewelCut:Necklace', function()
    TriggerEvent('nh-context:sendMenu', {
	{   id = 1, header = "< Go Back",
		txt = "",
		params = { event = "jim-mining:JewelCut", } },
	{   id = 2, header = "Gold Chain x3",
		txt = "Requires 1 Gold Bar",
		params = { event = "jim-mining:Cutting:Begin",
		args = { number = 1, id = 10 } } },
	{   id = 3, header = "10k Gold Chain x2",
		txt = "Requires 1 Gold Bar",
		params = { event = "jim-mining:Cutting:Begin",
		args = { number = 1, id = 11 } } },
	{   id = 4, header = "Diamond Necklace",
		txt = "Requires 1 Gold Chain & 1 Diamond",
		params = { event = "jim-mining:Cutting:Begin",
		args = { number = 1, id = 12 } } },
	{   id = 5, header = "Emerald Necklace",
		txt = "Requires 1 Gold Chain & 1 Emerald",
		params = { event = "jim-mining:Cutting:Begin",
		args = { number = 1, id = 13 } } },
	{   id = 6, header = "Ruby Necklace",
		txt = "Requires 1 Gold Chain & 1 Ruby",
		params = { event = "jim-mining:Cutting:Begin",
		args = { number = 1, id = 14 } } },
	{   id = 7, header = "Sapphire Necklace",
		txt = "Requires 1 Gold Chain & 1 Sapphire",
		params = { event = "jim-mining:Cutting:Begin",
		args = { number = 1, id = 15 } } }, })
end)
