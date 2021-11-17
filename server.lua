QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent('jim-mining:MineReward')
AddEventHandler('jim-mining:MineReward', function()
    local Player = QBCore.Functions.GetPlayer(source)
    local randomChance = math.random(1, 3)
    Player.Functions.AddItem('stone', randomChance)
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
    Player.Functions.AddItem(Config.RewardPool[oreToGive], amount)
    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[Config.RewardPool[oreToGive]], "add", amount)
end)

RegisterServerEvent('jim-mining:SellOre')
AddEventHandler('jim-mining:SellOre', function(data)
    local src = source
	local Player = QBCore.Functions.GetPlayer(source)
	if data == 1 then
		currentore = 'copperore'
	elseif data == 2 then
		currentore = 'ironore'
	elseif data == 3 then
		currentore = 'goldore'
	elseif data == 4 then
		currentore = 'carbon'
	end
	
    if Player.Functions.GetItemByName(currentore) ~= nil then
		ore = Player.Functions.GetItemByName(currentore).amount
		pay = (ore * Config.SellItems[currentore])
		Player.Functions.RemoveItem(currentore, ore)
		Player.Functions.AddMoney('cash', pay)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[currentore], 'remove', ore)
	else
		TriggerClientEvent('QBCore:Notify', source, "You don't have any to sell.", "error")
	end
end)

RegisterServerEvent('jim-mining:SellJewel')
AddEventHandler('jim-mining:SellJewel', function(data)
    local src = source
	local Player = QBCore.Functions.GetPlayer(source)
	if data == 10 then
		currentjewel = 'emerald'
	elseif data == 11 then
		currentjewel = 'uncut_emerald'
	elseif data == 12 then
		currentjewel = 'ruby'
	elseif data == 13 then
		currentjewel = 'uncut_ruby'
	elseif data == 14 then
		currentjewel = 'diamond'
	elseif data == 15 then
		currentjewel = 'uncut_diamond'
	elseif data == 16 then
		currentjewel = 'diamond_ring'
	elseif data == 17 then
        currentjewel = 'gold_ring'
	elseif data == 18 then
		currentjewel = 'goldchain'
	end
	if Player.Functions.GetItemByName(currentjewel) ~= nil then
		jewel = Player.Functions.GetItemByName(currentjewel).amount
		pay = (jewel * Config.SellItems[currentjewel])
		Player.Functions.RemoveItem(currentjewel, jewel)
		Player.Functions.AddMoney('cash', pay)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[currentjewel], 'remove', jewel)
	else
		TriggerClientEvent('QBCore:Notify', source, "You don't have any to sell.", "error")
	end
end)