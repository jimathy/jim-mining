local QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

function CreateBlips()
	for k, v in pairs(Config.Locations) do
		local blip = AddBlipForCoord(v.location)
		SetBlipAsShortRange(blip, true)
		SetBlipSprite(blip, 500)
		SetBlipColour(blip, 2)
		SetBlipScale(blip, 0.3)
		SetBlipDisplay(blip, 6)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString(v.label)
		EndTextCommandSetBlipName(blip)
	end
end

Citizen.CreateThread(function()
    if Config.Blips then
		CreateBlips()
	end
	if Config.Pedspawn then
		CreatePeds()
	end
	if Config.PropSpawn then
		CreateProps()
	end
end)

-----------------------------------------------------------

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

function CreateProps()
	local prop = 0
	for k,v in pairs(Config.OrePositions) do
		prop = prop+1
		local prop = CreateObject(GetHashKey("prop_rock_2_a"),v.coords,false,false,false)
		--SetEntityHeading(prop,GetEntityHeading(prop)-90)
		FreezeEntityPosition(prop, true)           
    end
	local bench = CreateObject(GetHashKey("prop_rock_2_a"),v.coords,false,false,false)
	SetEntityHeading(bench,GetEntityHeading(bench)-90)
	FreezeEntityPosition(bench, true)  
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
	{ options = { { event = "", icon = "fas fa-certificate", label = "Use Smelter", }, },
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
end)

-----------------------------------------------------------

--Teleporters for mineshaft doors
RegisterNetEvent('jim-mining:enterMine')
AddEventHandler('jim-mining:enterMine', function ()
    DoScreenFadeOut(500)
        while not IsScreenFadedOut() do
            Citizen.Wait(10)
        end
        SetEntityCoords(PlayerPedId(), Config.Locations['MineLeave'].location, 0, 0, 0, false)
        SetEntityHeading(PlayerPedId(), Config.TeleLocations['MineLeave'].heading)
        Citizen.Wait(100)
    DoScreenFadeIn(1000)
end)

RegisterNetEvent('jim-mining:exitMine')
AddEventHandler('jim-mining:exitMine', function ()
    DoScreenFadeOut(500)
        while not IsScreenFadedOut() do
            Citizen.Wait(10)
        end
        SetEntityCoords(PlayerPedId(), Config.TeleLocations['Mine'].location, 0, 0, 0, false)
        SetEntityHeading(PlayerPedId(), onfig.TeleLocations['Mine'].heading)
        Citizen.Wait(100)
    DoScreenFadeIn(1000)
end)

-----------------------------------------------------------

--Ore Usage 3D Text's
Citizen.CreateThread(function()
    local pos = GetEntityCoords(GetPlayerPed(-1))
	for k, v in pairs(Config.OrePositions) do
		if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 4.5) then
			if onDuty then
				if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 1.5) then
					DrawText3D(v.x, v.y, v.z, "[~g~E~w~] - Mine Ore")
					if IsControlJustReleased(0, Config.Keys["E"]) then
						TriggerServerEvent("")
					end
				elseif (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 2.5) then
					DrawText3D(v.x, v.y, v.z, "Mine Ore")
				end  
			end
		end
	end
end)

------------------------------------------------------------


function JewelCutting(menu)
		_menuPool = NativeUI.CreatePool()
		mainMenu = NativeUI.CreateMenu("", "Cut your jewels", "", "", "shopui_title_exec_vechupgrade", "shopui_title_exec_vechupgrade")
		_menuPool:Add(mainMenu)

		_menuPool:ControlDisablingEnabled(false)
		_menuPool:MouseControlsEnabled(false)

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

function OreSeller(menu)
		_menuPool = NativeUI.CreatePool()
		mainMenu = NativeUI.CreateMenu("", "Sell your ores for Cash", "", "", "shopui_title_exec_vechupgrade", "shopui_title_exec_vechupgrade")
		_menuPool:Add(mainMenu)

		_menuPool:ControlDisablingEnabled(false)
		_menuPool:MouseControlsEnabled(false)

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

OreSeller(mainMenu)
_menuPool:RefreshIndex()

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		_menuPool:ProcessMenus()
	end
end)