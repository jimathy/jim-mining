local QBCore = exports['qb-core']:GetCoreObject()

AddEventHandler('onResourceStart', function(resource)
    if GetCurrentResourceName() == resource then 
		for k, v in pairs(Config.SellItems) do if not QBCore.Shared.Items[k] then print("Missing Item from QBCore.Shared.Items: '"..k.."'") end end		
		for i = 1, #Config.RewardPool do if not QBCore.Shared.Items[Config.RewardPool[i]] then print("Missing Item from QBCore.Shared.Items: '"..Config.RewardPool[i].."'") end end
	end
end)

QBCore.Functions.CreateCallback('jim-mining:Check', function(source, cb, item, tablenumber, table)
	local hasitem = false
	local hasanyitem = nil
	for k, v in pairs(table[tablenumber]) do
		if k == "amount" then else
			for l, b in pairs(v) do
				if QBCore.Functions.GetPlayer(source).Functions.GetItemByName(l) and QBCore.Functions.GetPlayer(source).Functions.GetItemByName(l).amount >= b then hasitem = true
				else hasanyitem = false
				end
			end
		end
	end
	if hasanyitem ~= nil then hasitem = false end
	if hasitem then cb(true) else cb(false) end 
end)

RegisterServerEvent('jim-mining:GetItem', function(data)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	local amount = 1
	--This grabs the table from client and removes the item requirements
	if data.craftable then
		if data.craftable[data.tablenumber]["amount"] then amount = tonumber(data.craftable[data.tablenumber]["amount"]) else amount = 1 end
		for l, b in pairs(data.craftable[data.tablenumber][data.item]) do
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[tostring(l)], "remove", b) 
			Player.Functions.RemoveItem(tostring(l), b)
		end
	end
	if data.ret then
		local breackChance = math.random(1,10)
		if breackChance >= 8 then
			Player.Functions.RemoveItem('drillbit', 1)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['drillbit'], 'remove', 1)
		end
	end
	Player.Functions.AddItem(data.item, amount, false, {["quality"] = nil})
	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[data.item], "add", amount)
	TriggerClientEvent("jim-mining:CraftMenu", src, data)
end)

RegisterServerEvent('jim-mining:MineReward', function()
    local Player = QBCore.Functions.GetPlayer(source)
    local randomChance = math.random(1, 3)
    Player.Functions.AddItem('stone', randomChance, false, {["quality"] = nil})
    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["stone"], "add", randomChance)
end)

--Stone Cracking Checking Triggers
--Command here to check if any stone is in inventory
RegisterServerEvent('jim-mining:CrackReward', function()
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem('stone', 1)
    TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["stone"], "remove", 1)
	for i = 1, math.random(1,3) do
		local randItem = Config.RewardPool[math.random(1, #Config.RewardPool)]
		amount = math.random(1, 2)
		Player.Functions.AddItem(randItem, amount)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[randItem], 'add', amount)
	end
end)

RegisterNetEvent("jim-mining:Selling", function(data)
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
        TriggerClientEvent("QBCore:Notify", src, Loc[Config.Lan].error["dont_have"].." "..QBCore.Shared.Items[data].label, "error")
    end
end)

RegisterNetEvent("jim-mining:SellJewel", function(data)
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
        TriggerClientEvent("QBCore:Notify", src, Loc[Config.Lan].error["dont_have"].." "..QBCore.Shared.Items[data].label, "error")
    end
end)

----------------------------------------------

QBCore.Functions.CreateCallback('jim-mining:Cutting:Check:Tools', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('handdrill') ~= nil and Player.Functions.GetItemByName('drillbit') ~= nil then cb(true) else cb(false) end
end)
