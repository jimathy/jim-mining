local QBCore = exports['qb-core']:GetCoreObject()

AddEventHandler('onResourceStart', function(resource) if GetCurrentResourceName() ~= resource then return end
	for k, v in pairs(Config.SellItems) do if not QBCore.Shared.Items[k] then print("Selling: Missing Item from QBCore.Shared.Items: '"..k.."'") end end		
	for i = 1, #Config.CrackPool do if not QBCore.Shared.Items[Config.CrackPool[i]] then print("Reward Pool: Missing Item from QBCore.Shared.Items: '"..Config.CrackPool[i].."'") end end
	for i = 1, #Config.WashPool do if not QBCore.Shared.Items[Config.WashPool[i]] then print("Reward Pool: Missing Item from QBCore.Shared.Items: '"..Config.WashPool[i].."'") end end
	for i = 1, #Config.PanPool do if not QBCore.Shared.Items[Config.PanPool[i]] then print("Reward Pool: Missing Item from QBCore.Shared.Items: '"..Config.PanPool[i].."'") end end
	for i = 1, #Config.Items.items do if not QBCore.Shared.Items[Config.Items.items[i].name] then print("Shop: Missing Item from QBCore.Shared.Items: '"..Config.Items.items[i].name.."'") end end
	local itemcheck = {}
	for _, v in pairs(Crafting) do for _, b in pairs(v) do for k, l in pairs(b) do if k ~= "amount" then itemcheck[k] = {} for j in pairs(l) do itemcheck[j] = {} end end end end end
	for k in pairs(itemcheck) do
		if not QBCore.Shared.Items[k] then print("Crafting recipe couldn't find item '"..k.."' in the shared") end
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

RegisterServerEvent('jim-mining:CrackReward', function()
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem('stone', 1)
    TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["stone"], "remove", 1)
	for i = 1, math.random(1,3) do
		local randItem = Config.CrackPool[math.random(1, #Config.CrackPool)]
		amount = math.random(1, 2)
		Player.Functions.AddItem(randItem, amount)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[randItem], 'add', amount)
	end
end)

RegisterServerEvent('jim-mining:WashReward', function()
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem('stone', 1)
    TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["stone"], "remove", 1)
	for i = 1, math.random(1,2) do
		local randItem = Config.WashPool[math.random(1, #Config.WashPool)]
		amount = 1
		Player.Functions.AddItem(randItem, amount)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[randItem], 'add', amount)
		randItem = nil
	end
end)

RegisterServerEvent('jim-mining:PanReward', function()
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	for i = 1, math.random(1,3) do
		local randItem = Config.PanPool[math.random(1, #Config.PanPool)]
		amount = 1
		Player.Functions.AddItem(randItem, amount)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[randItem], 'add', amount)
		randItem = nil
	end
end)

RegisterNetEvent("jim-mining:Selling", function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
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
