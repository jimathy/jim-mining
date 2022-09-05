local QBCore = exports['qb-core']:GetCoreObject()
RegisterNetEvent('QBCore:Server:UpdateObject', function() if source ~= '' then return false end QBCore = exports['qb-core']:GetCoreObject() end)

---Crafting
RegisterServerEvent('jim-mining:GetItem', function(data)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	--This grabs the table from client and removes the item requirements
	if data.craftable[data.tablenumber]["amount"] then amount = data.craftable[data.tablenumber]["amount"] else amount = 1 end
	for k,v in pairs(data.craftable[data.tablenumber][data.item]) do
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[tostring(k)], "remove", v)
		Player.Functions.RemoveItem(tostring(k), v)
		if Config.Debug then print("^5Debug^7: ^1Removing ^2from Player^7(^2"..src.."^7) '^6"..QBCore.Shared.Items[k].label.."^7(^2x^6"..v.."^7)'") end
	end
	--This should give the item, while the rest removes the requirements
	Player.Functions.AddItem(data.item, amount)
	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[data.item], "add", amount)
	if Config.Debug then print("^5Debug^7: ^4Giving ^2Player^7(^2"..src.."^7) '^6"..QBCore.Shared.Items[data.item].label.."^7(^2x^6"..amount.."^7)'") end
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
RegisterServerEvent('jim-mining:CrackReward', function(cost)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem('stone', cost)
    TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["stone"], "remove", 1)
	for i = 1, math.random(1,3) do
		local randItem = Config.CrackPool[math.random(1, #Config.CrackPool)]
		amount = math.random(1, 2)
		if Player.Functions.AddItem(randItem, amount) then
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[randItem], 'add', amount)
		else print("error, no space") end
	end
end)

--Stone Cracking Checking Triggers
--Command here to check if any stone is in inventory
RegisterServerEvent('jim-mining:WashReward', function(cost)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem('stone', cost)
    TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["stone"], "remove", cost)
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
    if Player.Functions.GetItemByName(data.item) ~= nil then
        local amount = Player.Functions.GetItemByName(data.item).amount
        local pay = (amount * Config.SellItems[data.item])
        Player.Functions.RemoveItem(data.item, amount)
        Player.Functions.AddMoney('cash', pay)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[data.item], 'remove', amount)
    else
        TriggerClientEvent("QBCore:Notify", src, Loc[Config.Lan].error["dont_have"].." "..QBCore.Shared.Items[data.item].label, "error")
    end
end)

RegisterNetEvent('jim-mining:server:toggleItem', function(give, item, amount)
	local src = source
	if give == 0 or give == false then
		if HasItem(src, item, amount or 1) then -- check if you still have the item
			if QBCore.Functions.GetPlayer(src).Functions.RemoveItem(item, amount or 1) then
				TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove", amount or 1)
			end
		else TriggerEvent("jim-mining:server:DupeWarn", item, src) end -- if not boot the player
	else
		if QBCore.Functions.GetPlayer(src).Functions.AddItem(item, amount or 1) then
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add", amount or 1)
		end
	end
end)

RegisterNetEvent("jim-mining:server:DupeWarn", function(item, newsrc)
	local src = newsrc or source
	local P = QBCore.Functions.GetPlayer(src)
	print("^5DupeWarn: ^1"..P.PlayerData.charinfo.firstname.." "..P.PlayerData.charinfo.lastname.."^7(^1"..tostring(src).."^7) ^2Tried to remove item ^7('^3"..item.."^7')^2 but it wasn't there^7")
	DropPlayer(src, "Kicked for attempting to duplicate items")
	print("^5DupeWarn: ^1"..P.PlayerData.charinfo.firstname.." "..P.PlayerData.charinfo.lastname.."^7(^1"..tostring(src).."^7) ^2Dropped from server for item duplicating^7")
end)

function HasItem(source, items, amount)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return false end
    local isTable = type(items) == 'table'
    local isArray = isTable and table.type(items) == 'array' or false
    local totalItems = #items
    local count = 0
    local kvIndex = 2
    if isTable and not isArray then
        totalItems = 0
        for _ in pairs(items) do totalItems += 1 end
        kvIndex = 1
    end
    if isTable then
	if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Checking if player^7(^6"..source.."^7)^2 has items^7") end
        for k, v in pairs(items) do
            local itemKV = {k, v}
            local item = Player.Functions.GetItemByName(itemKV[kvIndex])
            if item and ((amount and item.amount >= amount) or (not isArray and item.amount >= v) or (not amount and isArray)) then
                count += 1
            end
        end
        if count == totalItems then
			if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Items FOUND^7") end
            return true
        end
    else -- Single item as stringHasItem(v, 1)
		if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Checking if player^7(^6"..source.."^7)^2 has items^7") end
		local item = Player.Functions.GetItemByName(items)
        if item and (not amount or (item and amount and item.amount >= amount)) then
            return true
        end
    end
	if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Items Not FOUND^7") end
    return false
end

AddEventHandler('onResourceStart', function(resource) if GetCurrentResourceName() ~= resource then return end
	for k, v in pairs(Config.SellItems) do if not QBCore.Shared.Items[k] then print("Selling: Missing Item from QBCore.Shared.Items: '"..k.."'") end end
	for i = 1, #Config.CrackPool do if not QBCore.Shared.Items[Config.CrackPool[i]] then print("CrackPool: Missing Item from QBCore.Shared.Items: '"..Config.CrackPool[i].."'") end end
	for i = 1, #Config.WashPool do if not QBCore.Shared.Items[Config.WashPool[i]] then print("WashPool: Missing Item from QBCore.Shared.Items: '"..Config.WashPool[i].."'") end end
	for i = 1, #Config.PanPool do if not QBCore.Shared.Items[Config.PanPool[i]] then print("PanPool: Missing Item from QBCore.Shared.Items: '"..Config.PanPool[i].."'") end end
	for i = 1, #Config.Items.items do if not QBCore.Shared.Items[Config.Items.items[i].name] then print("Shop: Missing Item from QBCore.Shared.Items: '"..Config.Items.items[i].name.."'") end end
	local itemcheck = {}
	for _, v in pairs(Crafting) do for _, b in pairs(v) do for k, l in pairs(b) do if k ~= "amount" then itemcheck[k] = {} for j in pairs(l) do itemcheck[j] = {} end end end end end
	for k in pairs(itemcheck) do
		if not QBCore.Shared.Items[k] then print("Crafting recipe couldn't find item '"..k.."' in the shared") end
	end
end)