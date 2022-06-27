local QBCore = exports['qb-core']:GetCoreObject()

isLoggedIn = false
local PlayerJob = {}

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData) PlayerJob = PlayerData.job if PlayerData.job.onduty then if PlayerData.job.name == Config.JobRole then TriggerServerEvent("QBCore:ToggleDuty") end end end)
end)

local onDuty = false
RegisterNetEvent('QBCore:Client:SetDuty') AddEventHandler('QBCore:Client:SetDuty', function(duty) onDuty = duty end)

AddEventHandler('onResourceStart', function(resource) if GetCurrentResourceName() ~= resource then return end
	QBCore.Functions.GetPlayerData(function(PlayerData) PlayerJob = PlayerData.job if PlayerData.job.name == Config.JobRole then onDuty = PlayerJob.onduty end end)
end)

local peds = {}
local shopPeds = {}
--- Blips + Peds here
CreateThread(function()
	--if Config.Pedspawn then	CreatePeds() end
    if Config.Blips then
		for k, v in pairs(Config.Locations) do
			if Config.Locations[k].blipTrue then
				local blip = AddBlipForCoord(v.location.x,v.location.y,v.location.z)
				SetBlipAsShortRange(blip, true)
				SetBlipSprite(blip, v.Sprite)
				SetBlipColour(blip, v.Colour)
				SetBlipScale(blip, v.Scale)
				SetBlipDisplay(blip, 6)
				BeginTextCommandSetBlipName('STRING')
				if Config.BlipNamer then AddTextComponentString(v.name)
				else AddTextComponentString("Recycling")
				end	EndTextCommandSetBlipName(blip)
			end
		end
	end
	if Config.Pedspawn then
		for k, v in pairs(Config.PedList) do
			RequestModel(v.model) while not HasModelLoaded(v.model) do Wait(0) end
			peds[#peds+1] = CreatePed(0, v.model, v.coords.x, v.coords.y, v.coords.z, v.coords[4], false, false)
			shopPeds[#shopPeds+1] = peds[#peds]
			SetEntityInvincible(peds[#peds], true)
			SetBlockingOfNonTemporaryEvents(peds[#peds], true)
			FreezeEntityPosition(peds[#peds], true)
			TaskStartScenarioInPlace(peds[#peds], v.scenario, 0, true)
			if Config.Debug then print("Ped Created") end
		end
	end
end)

props = {}
---- Render Props -------
function renderPropsWareHouse()
	props[#props+1] = CreateObject(`ex_prop_crate_bull_sc_02`,1003.63013,-3108.50415,-39.9669662,false,false,false)
	props[#props+1] = CreateObject(`ex_prop_crate_wlife_bc`,1018.18011,-3102.8042,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_prop_crate_closed_bc`,1006.05511,-3096.954,-37.8179666,false,false,false)
	props[#props+1] = CreateObject(`ex_prop_crate_wlife_sc`,1003.63013,-3102.8042,-37.81769,false,false,false)
	props[#props+1] = CreateObject(`ex_prop_crate_jewels_racks_sc`,1003.63013,-3091.604,-37.8179666,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_BC`,1013.330000003,-3102.80400000,-35.62896000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_BC`,1015.75500000,-3102.80400000,-35.62796000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_BC`,1015.75500000,-3102.80400000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Jewels_BC`,1018.18000000,-3091.60400000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_BC`,1026.75500000,-3111.38400000,-37.81797000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Jewels_BC`,1003.63000000,-3091.60400000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Jewels_BC`,1026.75500000,-3106.52900000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_BC`,1026.75500000,-3106.52900000,-35.62796000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Art_02_SC`,1010.90500000,-3108.50400000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Art_BC`,1013.33000000,-3108.50400000,-35.62796000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Art_BC`,1015.75500000,-3108.50400000,-35.62796000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Bull_SC_02`,1010.90500000,-3096.95400000,-39.86697000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Art_SC`,993.35510000,-3111.30400000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Art_BC`,993.35510000,-3108.95400000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Gems_SC`,1013.33000000,-3096.95400000,-37.8177600,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_clothing_BC`,1018.180000000,-3096.95400000,-35.62796000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_clothing_BC`,1008.48000000,-3096.95400000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Gems_BC`,1003.63000000,-3108.50400000,-35.61234000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Narc_BC`,1026.75500000,-3091.59400000,-37.81797000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Narc_BC`,1026.75500000,-3091.59400000,-37.81797000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Elec_SC`,1008.48000000,-3108.50400000,-37.81797000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Tob_SC`,1018.18000000,-3096.95400000,-37.81240000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Wlife_BC`,1018.18000000,-3091.60400000,-35.74857000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Med_BC`,1008.48000000,-3091.60400000,-35.62796000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Elec_SC`,1013.33000000,-3108.50400000,-37.81797000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_BC`,1026.75500000,-3108.88900000,-35.62796000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_biohazard_BC`,1010.90500000,-3102.80400000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Wlife_BC`,1015.75500000,-3091.60400000,-35.74857000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_biohazard_BC`,1003.63000000,-3108.50400000,-37.81561000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Elec_BC`,1008.48000000,-3096.954000000,-35.60529000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Bull_BC_02`,1006.05500000,-3108.50400000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_RW`,1013.33000000,-3091.60400000,-37.81797000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Narc_SC`,1026.75500000,-3094.014000000,-37.81684000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Art_BC`,1015.75500000,-3108.50400000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Elec_BC`,1010.90500000,-3096.95400000,-35.60529000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Ammo_BC`,1013.33000000,-3102.80400000,-37.81427000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Money_BC`,1003.63000000,-3096.95400000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Gems_BC`,1003.63000000,-3096.95400000,-37.81187000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_BC`,1010.90500000,-3091.60400000,-35.62796000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_furJacket_BC`,1013.33000000,-3091.60400000,-35.74885000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_furJacket_BC`,1026.75500000,-3091.59400000,-35.74885000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_furJacket_BC`,1026.75500000,-3094.0140000,-35.74885000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_furJacket_BC`,1026.75500000,-3096.43400000,-35.74885000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_clothing_SC`,1013.33000000,-3091.604000000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_biohazard_SC`,1006.05500000,-3108.50400000,-37.81576000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Elec_BC`,993.35510000,-3106.60400000,-35.60529000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_BC`,1026.75500000,-3111.38400000,-35.62796000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Bull_BC_02`,1026.75500000,-3096.4340000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_BC`,1015.75500000,-3096.95400000,-37.81797000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_HighEnd_pharma_BC`,1003.63000000,-3091.60400000,-35.62571000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_HighEnd_pharma_SC`,1015.75500000,-3091.60400000,-37.81797000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Art_02_BC`,1013.330000000,-3096.95400000,-35.62796000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Gems_SC`,1018.18000000,-3102.80400000,-37.81776000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Art_02_BC`,1013.33000000,-3108.50400000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Gems_BC`,1018.18000000,-3108.50400000,-37.81234000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Tob_BC`,1010.90500000,-3108.50400000,-35.75240000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Med_SC`,1026.75500000,-3108.88900000,-37.81797000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Money_SC`,1010.90500000,-3091.60400000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Med_SC`,1008.48000000,-3091.60400000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Art_02_BC`,1018.180000000,-3108.50400000,-35.62796000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Bull_SC_02`,1008.48000000,-3108.50400000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Art_02_BC`,993.35510000,-3106.60400000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_BC`,1008.480000000,-3102.804000000,-37.81797000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Elec_BC`,993.35510000,-3111.30400000,-35.60529000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_HighEnd_pharma_BC`,1018.18000000,-3091.60400000,-37.81572000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Gems_BC`,1015.75500000,-3102.80400000,-37.81234000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Jewels_racks_BC`,1003.63000000,-3102.80400000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Money_SC`,1006.05500000,-3096.95400000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_BC`,1003.630000000,-3096.95400000,-35.62796000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_furJacket_SC`,1006.05500000,-3102.80400000,-37.81544000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Expl_bc`,1010.90500000,-3102.80400000,-37.81982000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Elec_BC`,1006.05500000,-3096.9540000,-35.60529000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Elec_BC`,1006.05500000,-3102.80400000,-35.60529000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Elec_BC`,1010.90500000,-3108.50400000,-37.81529000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Art_BC`,1015.75500000,-3096.95400000,-35.62796000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Gems_BC`,1010.90500000,-3096.95400000,-37.81234000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Elec_BC`,1010.90500000,-3102.804000000,-35.60529000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Elec_BC`,1008.48000000,-3102.80400000,-35.60529000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Bull_BC_02`,993.35510000,-3106.60400000,-37.81342000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Money_SC`,1015.75500000,-3091.604000000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Med_BC`,1026.75500000,-3106.52900000,-37.81797000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Bull_SC_02`,1015.75500000,-3096.95400000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Tob_SC`,1010.905000000,-3091.60400000,-37.81240000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_BC`,1006.05500000,-3091.60400000,-35.62796000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_pharma_SC`,1026.75500000,-3096.43400000,-37.81797000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_BC`,1006.05500000,-3108.50400000,-35.62796000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Gems_SC`,1015.75500000,-3108.504000000,-37.81776000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Tob_BC`,1018.18000000,-3102.80400000,-35.75240000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Tob_BC`,1008.48000000,-3108.50400000,-35.75240000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Bull_BC_02`,993.35510000,-3111.30400000,-37.81342000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Jewels_racks_SC`,1026.75500000,-3111.384000000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Jewels_SC`,1006.05500000,-3102.80400000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Bull_BC_02`,1013.33000000,-3096.95400000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Gems_SC`,1013.33000000,1013.33000000,1013.33000000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Jewels_BC`,1026.75500000,-3108.889000000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Bull_SC_02`,993.35510000,-3108.95400000,-37.81797000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_BC`,1008.48000000,-3091.60400000,-37.81797000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Elec_SC`,993.35510000,-3108.95400000,-35.62796000,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_XLDiam`,1026.75500000,-3094.01400000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_watch`,1013.33000000,-3102.80400000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_SHide`,1018.18000000,-3096.95400000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Oegg`,1006.05500000,-3091.60400000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_MiniG`,1018.18000000,-3108.50400000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_FReel`,11008.48000000,-3102.80400000,-39.99757,false,false,false)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_SC`,1006.05500000,-3091.60400000,-37.81985000,false,false,false) 
	props[#props+1] = CreateObject(`ex_Prop_Crate_Bull_BC_02`,1026.75500000,-3091.59400000,-39.99757,false,false,false)

	props[#props+1] = CreateObject(`prop_toolchest_05`,1002.0411987305,-3108.3645019531,-39.999897003174,false,false,false)
	SetEntityHeading(props[#props],90.0)
end

local Targets = {}
--Recycling Center thirdeye commands
CreateThread(function()
	if Config.RequireJob then
		Targets["RecyclingEnter"] =
		exports['qb-target']:AddBoxZone("RecyclingEnter", vector3(746.82, -1398.93, 26.55), 0.4, 1.6, { name="RecyclingEnter", debugPoly=Config.Debug, minZ=25.2, maxZ=28.0 },
		{ options = { { event = "jim-recycle:EnterTradeWarehouse", icon = "fas fa-recycle", label = "Enter Warehouse", job = Config.Job }, },
						distance = 1.5 })
	else
		Targets["RecyclingEnter"] =
		exports['qb-target']:AddBoxZone("RecyclingEnter", vector3(746.82, -1398.93, 26.55), 0.4, 1.6, { name="RecyclingEnter", debugPoly=Config.Debug, minZ=25.2, maxZ=28.0 },
		{ options = { { event = "jim-recycle:EnterTradeWarehouse", icon = "fas fa-recycle", label = "Enter Warehouse", }, },
						distance = 1.5 })
	end
	Targets["RecyclingExit"] =
	exports['qb-target']:AddBoxZone("RecyclingExit", vector3(991.97, -3097.81, -39.0), 1.6, 0.4, { name="RecyclingExit", debugPoly=Config.Debug, useZ=true, },
    { options = { { event = "jim-recycle:ExitTradeWarehouse", icon = "fas fa-recycle", label = "Exit Warehouse", }, },
					distance = 1.5 })
	Targets["recycleduty"] =
    exports['qb-target']:AddCircleZone("recycleduty", vector3(994.64,-3100.07,-39.0), 0.8, { name="recycleduty", debugPoly=Config.Debug, useZ=true, },
    { options = { { event = "jim-recycle:dutytoggle", icon = "fas fa-hard-hat", label = "Toggle Recycling Duty", }, },
					distance = 1.5 })
	Targets["tradeitems"] =
    exports['qb-target']:AddCircleZone("tradeitems", vector3(Config.Locations['Trade'].location.x, Config.Locations['Trade'].location.y, Config.Locations['Trade'].location.z), 2.0, { name="tradeitems", debugPoly=Config.Debug, useZ=true, },
    { options = { { event = "jim-recycle:Trade:Menu", icon = "fas fa-box", label = "Trade Materials", }, },
					distance = 1.5 })
	Targets["sellmats"] =
    exports['qb-target']:AddCircleZone("sellmats", vector3(Config.Locations['Recycle'].location.x, Config.Locations['Recycle'].location.y, Config.Locations['Recycle'].location.z), 2.0, { name="sellmats", debugPoly=Config.Debug, useZ=true, },
    { options = { { event = "jim-recycle:Selling:Menu", icon = "fas fa-box", label = "Sell Materials", }, },
					distance = 2.5 })
	--Bottle Selling Third Eyes
	for i = 1, 6 do
		Targets["BottleBank"..i] =
		exports['qb-target']:AddCircleZone("BottleBank"..i, vector3(Config.Locations["BottleBank"..i].location.x, Config.Locations["BottleBank"..i].location.y, Config.Locations["BottleBank"..i].location.z), 2.0, 
		{ name="BottleBank"..i, debugPoly=Config.Debug, useZ=true, }, 
		{ options = { { event = "jim-recycle:Bottle:Menu", icon = "fas fa-certificate", label = "Sell Bottles", },	},
						distance = 2.5 })
	end
end)

local carryPackage = nil
RegisterNetEvent('jim-recycle:EnterTradeWarehouse', function()
	if Config.EnableOpeningHours then
		local ClockTime = GetClockHours()
		if ClockTime >= Config.OpenHour and ClockTime <= Config.CloseHour - 1 then
			if (ClockTime >= Config.OpenHour and ClockTime < 24) or (ClockTime <= Config.CloseHour -1 and ClockTime > 0) then
				renderPropsWareHouse()
				DoScreenFadeOut(500)
				while not IsScreenFadedOut() do
					Citizen.Wait(10)
				end
				SetEntityCoords(PlayerPedId(), Config['delivery'].InsideLocation.x, Config['delivery'].InsideLocation.y, Config['delivery'].InsideLocation.z)
				DoScreenFadeIn(500)
			else
				TriggerEvent("QBCore:Notify", "We're currently closed, we're open from "..Config.OpenHour..":00am till "..Config.CloseHour..":00pm", "error")
			end
		else
			TriggerEvent("QBCore:Notify", "We're currently closed, we're open from 9:00am till 21:00pm", "error")
		end
	else
		renderPropsWareHouse()
		DoScreenFadeOut(500)
		while not IsScreenFadedOut() do
			Citizen.Wait(10)
		end
		SetEntityCoords(PlayerPedId(), Config['delivery'].InsideLocation.x, Config['delivery'].InsideLocation.y, Config['delivery'].InsideLocation.z)
		DoScreenFadeIn(500)
	end
end)

RegisterNetEvent('jim-recycle:ExitTradeWarehouse', function()
	for k, v in pairs(props) do DeleteObject(props[k]) end props = {} 
	DoScreenFadeOut(500)
	while not IsScreenFadedOut() do
		Citizen.Wait(10)
	end
	if onDuty then TriggerEvent('jim-recycle:dutytoggle') end
	SetEntityCoords(PlayerPedId(), Config['delivery'].OutsideLocation.x, Config['delivery'].OutsideLocation.y, Config['delivery'].OutsideLocation.z)
	DoScreenFadeIn(500)
end)

local packagePos = nil

--
CreateThread(function ()
    while true do
        Citizen.Wait(1)
        if onDuty then
            if packagePos ~= nil then
                local pos = GetEntityCoords(PlayerPedId(), true)
                if carryPackage == nil then
                    if #(vector3(pos.x, pos.y, pos.z) - packagePos) < 2.3 then
                        DrawText3D(packagePos.x,packagePos.y,packagePos.z+ 1, "~g~E~w~ - Grab Junk")
                        if IsControlJustReleased(0, 38) then
                            TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
                            QBCore.Functions.Progressbar("pickup_reycle_package", "Picking up the junk..", 5000, false, true, {}, {}, {}, {}, function() -- Done
                                ClearPedTasks(PlayerPedId())
                                PickupPackage()
                            end)
                        end
                    elseif #(vector3(pos.x, pos.y, pos.z) - packagePos) < 100 then
                        DrawText3D(packagePos.x, packagePos.y, packagePos.z + 1, "Pallet")
                    end
                else
                    if #(vector3(pos.x, pos.y, pos.z) - vector3(Config['delivery'].DropLocation.x, Config['delivery'].DropLocation.y, Config['delivery'].DropLocation.z)) < 2.0 then
                        DrawText3D(Config['delivery'].DropLocation.x, Config['delivery'].DropLocation.y, Config['delivery'].DropLocation.z, "~g~E~w~ - Transfer to Recyclable Box")
                        if IsControlJustReleased(0, 38) then
                            DropPackage()
                            ScrapAnim()
                            QBCore.Functions.Progressbar("deliver_reycle_package", "Packing into recyclable box..", 5000, false, true, { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true, }, 
								{}, {}, {}, function() -- Done
                                StopAnimTask(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 1.0)
                                TriggerServerEvent('jim-recycle:getrecyclablematerial')
                                GetRandomPackage()
                            end)
                        end
                    else
                        DrawText3D(Config['delivery'].DropLocation.x, Config['delivery'].DropLocation.y, Config['delivery'].DropLocation.z, "Transfer")
                    end
                end
            else
                GetRandomPackage()
            end
        end
    end
end)

function GetRandomPackage()
    local randSeed = math.random(1, #Config["delivery"].PackagePickupLocations)
    packagePos = vector3(Config["delivery"].PackagePickupLocations[randSeed].x, Config["delivery"].PackagePickupLocations[randSeed].y, Config["delivery"].PackagePickupLocations[randSeed].z)
end

--Third Eye Commands
RegisterNetEvent('jim-recycle:dutytoggle', function()
	if Config.RequireJob then
		TriggerServerEvent("QBCore:ToggleDuty")
	else
		onDuty = not onDuty
		if onDuty then TriggerEvent('QBCore:Notify', 'You went on duty', 'success')
		else TriggerEvent('QBCore:Notify', 'You went off duty', 'error') end
	end
end)

RegisterNetEvent("jim-recycle:CloseMenu", function() exports['qb-menu']:closeMenu() end)

--Sell Anim small Test
RegisterNetEvent('jim-recycle:SellAnim', function(data)
	local pid = PlayerPedId()
	loadAnimDict("mp_common")
	if data == 1 then
		TriggerServerEvent('jim-recycle:Selling:All')
	else
		TriggerServerEvent('jim-recycle:Selling:Mat', data)
	end
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
end)

--Sell Anim small Test
RegisterNetEvent('jim-recycle:TradeAnim', function(data)
	local pid = PlayerPedId()
	loadAnimDict("mp_common")
	TriggerServerEvent('jim-recycle:TradeItems', data) -- Had to slip in the sell command during the animation command
	for k,v in pairs (shopPeds) do
        pCoords = GetEntityCoords(PlayerPedId())
        ppCoords = GetEntityCoords(v)
		ppRot = GetEntityRotation(v)
        dist = #(pCoords - ppCoords)
			oldRot = GetEntityRotation(v)
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
end)

--Material Buyer
local function imghead(image) -- Trying to tidy the code up
	local header = "<img src=nui://"..Config.img..QBCore.Shared.Items[image].image.." width=30px onerror='this.onerror=null; this.remove();'> "..QBCore.Shared.Items[image].label
	return header
end
RegisterNetEvent('jim-recycle:Selling:Menu', function()
    exports['qb-menu']:openMenu({
		{ header = "Material Selling", txt = "Sell batches of materials", isMenuHeader = true },
		{ icon = "fas fa-circle-xmark", header = "", txt = "Close", params = { event = "jim-recycle:CloseMenu" } },
		{ icon = "copper", header = imghead("copper"), params = { event = "jim-recycle:SellAnim", args = 'copper' } },
		{ icon = "plastic", header = imghead("plastic"), params = { event = "jim-recycle:SellAnim", args = 'plastic' } },
		{ icon = "aluminum", header = imghead("aluminum"), params = { event = "jim-recycle:SellAnim", args = 'aluminum' } },
		{ icon = "metalscrap", header = imghead("metalscrap"), params = { event = "jim-recycle:SellAnim", args = 'metalscrap' }  },
		{ icon = "steel", header = imghead("steel"), params = { event = "jim-recycle:SellAnim", args = 'steel' } },
		{ icon = "glass", header = imghead("glass"), params = { event = "jim-recycle:SellAnim", args = 'glass' } },
		{ icon = "iron", header = imghead("iron"), params = { event = "jim-recycle:SellAnim", args = 'iron' } },
		{ icon = "rubber", header = imghead("rubber"), params = { event = "jim-recycle:SellAnim", args = 'rubber' } },
		{ icon = "recyclablematerial", header = "- ALL -", params = { event = "jim-recycle:SellAnim", args = 1 } }, 
    })
end)

--Recyclable Trader
RegisterNetEvent('jim-recycle:Trade:Menu', function()
    exports['qb-menu']:openMenu({
		{ header = "Material Trading", txt = "Trade collected materials", isMenuHeader = true },
		{ icon = "fas fa-circle-xmark", header = "", txt = "Close", params = { event = "jim-recycle:CloseMenu" } },
		{ icon = "recyclablematerial", header = "Trade 10 Materials", params = { event = "jim-recycle:TradeAnim", args = 1 } },
		{ icon = "recyclablematerial", header = "Trade 100 Materials", params = { event = "jim-recycle:TradeAnim", args = 2 } },
    })
end)

--Recyclable Trader
RegisterNetEvent('jim-recycle:Bottle:Menu', function()
    exports['qb-menu']:openMenu({
		{ header = "Material Selling", txt = "Sell batches of recyclables", isMenuHeader = true },
		{ icon = "fas fa-circle-xmark", header = "", txt = "Close", params = { event = "jim-recycle:CloseMenu" } },
		{ icon = "bottle", header = imghead("bottle"), params = { event = "jim-recycle:SellAnim", args = 'bottle' } },
		{ icon = "can", header =  imghead("can"), params = { event = "jim-recycle:SellAnim", args = 'can' } },
    })
end)

--- 3D Text Shit---
function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

---Animations---
function ScrapAnim()
    local time = 5
    loadAnimDict("mp_car_bomb")
    TaskPlayAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic" ,3.0, 3.0, -1, 16, 0, false, false, false)
    openingDoor = true
    Citizen.CreateThread(function()
        while openingDoor do
            TaskPlayAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Citizen.Wait(1000)
            time = time - 1
            if time <= 0 then
                openingDoor = false
                StopAnimTask(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 1.0)
            end
        end
    end)
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

local randommodel = nil

function PickupPackage()
    local pos = GetEntityCoords(PlayerPedId(), true)
    RequestAnimDict("anim@heists@box_carry@")
    while (not HasAnimDictLoaded("anim@heists@box_carry@")) do
        Citizen.Wait(7)
    end
    TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
	randommodel = math.random(1,3)
	if randommodel == 1 then model = `prop_cs_cardbox_01` rot1 = 300.0 rot2 = 250.0
	elseif randommodel == 2 then model = `prop_rub_scrap_06` rot1 = 300.0 rot2 = 130.0
	elseif randommodel == 3 then model = `v_ret_gc_bag01` rot1 = 300.0 rot2 = 130.0 end
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(0) end
    local object = CreateObject(model, pos.x, pos.y, pos.z, true, true, true)
    AttachEntityToEntity(object, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.05, 0.1, -0.3, rot1, rot2, 20.0, true, true, false, true, 1, true)
    carryPackage = object
end

function DropPackage()
    ClearPedTasks(PlayerPedId())
    DetachEntity(carryPackage, true, true)
    DeleteObject(carryPackage)
    carryPackage = nil
end

AddEventHandler('onResourceStop', function(resource) if resource ~= GetCurrentResourceName() then return end
	for k, v in pairs(Targets) do exports['qb-target']:RemoveZone(k) end		
	for k, v in pairs(peds) do DeletePed(peds[k]) end
end)
