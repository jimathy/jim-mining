local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('jim-mining:get', function(source, cb, item, tablenumber, craftable)
	local hasitem = false
	local hasanyitem = nil
		for l, b in pairs(craftable[tablenumber][item]) do
			if QBCore.Functions.GetPlayer(source).Functions.GetItemByName(l) and QBCore.Functions.GetPlayer(source).Functions.GetItemByName(l).amount >= b then hasitem = true
			else hasanyitem = false
		end
	end
	if hasanyitem ~= nil then hasitem = false end
if hasitem then cb(true) else cb(false) end end)

RegisterServerEvent('jim-mining:GetItem', function(ItemMake, tablenumber, craftable)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	local amount = 0
	--This grabs the table from client and removes the item requirements
	if craftable then
			if craftable[tablenumber]["amount"] then amount = tonumber(craftable[tablenumber]["amount"]) else amount = 1 end
			for l, b in pairs(craftable[tablenumber][ItemMake]) do
				TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[tostring(l)], "remove", b) 
				Player.Functions.RemoveItem(tostring(l), b)
			end
	end
	--Dodgy check for if the table thats been copied through the events
	--if you are making 4 items copper, goldbar, iron or steel then you are smelting
	--the rest would be cutting, which would result in the ability to break drilbits
	if ItemMake == "copper" or ItemMake == "goldbar" or ItemMake == "iron" or ItemMake == "steel" then
	else
		local breackChance = math.random(1,10)
		if breackChance >= 8 then
			Player.Functions.RemoveItem('drillbit', 1)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['drillbit'], 'remove', 1)
		end
	end
	Player.Functions.AddItem(ItemMake, amount, false, {["quality"] = nil})
	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[ItemMake], "add", amount)
end)

RegisterServerEvent('jim-mining:MineReward')
AddEventHandler('jim-mining:MineReward', function()
    local Player = QBCore.Functions.GetPlayer(source)
    local randomChance = math.random(1, 3)
    Player.Functions.AddItem('stone', randomChance, false, {["quality"] = nil})
    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["stone"], "add", randomChance)
end)

--Stone Cracking Checking Triggers
--Command here to check if any stone is in inventory

RegisterServerEvent('jim-mining:CrackReward')
AddEventHandler('jim-mining:CrackReward', function()
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.RemoveItem('stone', 1)
    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["stone"], "remove", 1)
    local oreToGive = nil
    oreToGive = math.random(1,#Config.RewardPool)
    local amount = math.random(1, 2)
    Player.Functions.AddItem(Config.RewardPool[oreToGive], amount, false, {["quality"] = nil})
    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[Config.RewardPool[oreToGive]], "add", amount)
end)

RegisterNetEvent("jim-mining:Selling")
AddEventHandler("jim-mining:Selling", function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local currentitem = data
    if Player.Functions.GetItemByName(data) ~= nil then
        local amount = Player.Functions.GetItemByName(data).amount
        local pay = (amount * Config.SellItems[data])
        Player.Functions.RemoveItem(data, amount)
        Player.Functions.AddMoney('cash', pay)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[data], 'remove', amount)
    else
        TriggerClientEvent("QBCore:Notify", src, "You don't have any "..QBCore.Shared.Items[data].label, "error")
    end
    Citizen.Wait(1000)
end)

RegisterNetEvent("jim-mining:SellJewel")
AddEventHandler("jim-mining:SellJewel", function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local currentitem = data
    if Player.Functions.GetItemByName(data) ~= nil then
        local amount = Player.Functions.GetItemByName(data).amount
        local pay = (amount * Config.SellItems[data])
        Player.Functions.RemoveItem(data, amount)
        Player.Functions.AddMoney('cash', pay)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[data], 'remove', amount)
    else
        TriggerClientEvent("QBCore:Notify", src, "You don't have any "..QBCore.Shared.Items[data].label, "error")
    end
    Citizen.Wait(1000)
end)

----------------------------------------------

QBCore.Functions.CreateCallback('jim-mining:Cutting:Check:Tools', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('handdrill') ~= nil and Player.Functions.GetItemByName('drillbit') ~= nil then
		cb(true)
	else 
		cb(false)
	end
end)
