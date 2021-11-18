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
	elseif data == 19 then
		currentjewel = '10kgoldchain'
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


--Attempt at making simple crafting/smelting recipies
--Basically choose from the menus which provides an ID, it reads what is required, then gives the result
--shows error if requirements aren't met

--These command checks the requirements for each recipe, had to keep separate to keep control of when it happens.
QBCore.Functions.CreateCallback('jim-mining:Smelting:Check:1', function(source, cb)
	local src = source
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('copperore') ~= nil then
		cb(true)
	else 
		cb(false)
	end
end)

QBCore.Functions.CreateCallback('jim-mining:Smelting:Check:2', function(source, cb)
	local src = source
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('goldore').amount >= 4 then
		cb(true)
	else 
		cb(false)
	end
end)

QBCore.Functions.CreateCallback('jim-mining:Smelting:Check:3', function(source, cb)
	local src = source
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('ironore') ~= nil then
		cb(true)
	else 
		cb(false)
	end
end)

QBCore.Functions.CreateCallback('jim-mining:Smelting:Check:4', function(source, cb)
	local src = source
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('ironore') ~= nil and Player.Functions.GetItemByName('carbon') ~= nil then
		cb(true)
	else 
		cb(false)
	end
end)

--These obviously are the rewards for each ID
--This is called after the animation/progressbar is completed
RegisterServerEvent('jim-mining:Smelting:Reward')
AddEventHandler('jim-mining:Smelting:Reward', function(data)
    local src = source
	local Player = QBCore.Functions.GetPlayer(source)
	if data.id == 1 then
		Player.Functions.RemoveItem('copperore', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['copperore'], 'remove', 1)
		Player.Functions.AddItem("copper", 10)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["copper"], 'add', 10)
	elseif data.id == 2 then
		Player.Functions.RemoveItem('goldore', 4)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['goldore'], 'remove', 4)
		Player.Functions.AddItem("goldbar", 1)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["goldbar"], 'add', 1)
	elseif data.id == 3 then
		Player.Functions.RemoveItem('ironore', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['ironore'], 'remove', 1)
		Player.Functions.AddItem("iron", 10)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["iron"], 'add', 10)
	elseif data.id == 4 then
		Player.Functions.RemoveItem('ironore', 1)
		Player.Functions.RemoveItem('carbon', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['ironore'], 'remove', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['carbon'], 'remove', 1)
		Player.Functions.AddItem("steel", 2)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["steel"], 'add', 2)
	end
end)

------------------------------------------------------------

QBCore.Functions.CreateCallback('jim-mining:Cutting:Check:1', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('uncut_emerald') ~= nil then
		cb(true)
	else 
		cb(false)
	end
end)

QBCore.Functions.CreateCallback('jim-mining:Cutting:Check:2', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('uncut_ruby') ~= nil then
		cb(true)
	else 
		cb(false)
	end
end)

QBCore.Functions.CreateCallback('jim-mining:Cutting:Check:3', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('uncut_diamond') ~= nil then
		cb(true)
	else 
		cb(false)
	end
end)

QBCore.Functions.CreateCallback('jim-mining:Cutting:Check:4', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('goldbar') ~= nil then
		cb(true)
	else 
		cb(false)
	end
end)

QBCore.Functions.CreateCallback('jim-mining:Cutting:Check:5', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('gold_ring') ~= nil and Player.Functions.GetItemByName('diamond') ~= nil then
		cb(true)
	else 
		cb(false)
	end
end)

QBCore.Functions.CreateCallback('jim-mining:Cutting:Check:6', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('goldbar') ~= nil then
		cb(true)
	else 
		cb(false)
	end
end)

QBCore.Functions.CreateCallback('jim-mining:Cutting:Check:7', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('goldbar') ~= nil then
		cb(true)
	else 
		cb(false)
	end
end)

RegisterServerEvent('jim-mining:Cutting:Reward')
AddEventHandler('jim-mining:Cutting:Reward', function(data)
    local src = source
	local Player = QBCore.Functions.GetPlayer(source)
	if data == 1 then
		Player.Functions.RemoveItem('uncut_emerald', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['uncut_emerald'], 'remove', 1)
		Player.Functions.AddItem("emerald", 1)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["emerald"], 'add', 1)
	elseif data == 2 then
		Player.Functions.RemoveItem('uncut_ruby', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['uncut_ruby'], 'remove', 1)
		Player.Functions.AddItem("ruby", 1)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["ruby"], 'add', 1)
	elseif data == 3 then
		Player.Functions.RemoveItem('uncut_diamond', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['uncut_diamond'], 'remove', 1)
		Player.Functions.AddItem("diamond", 1)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["diamond"], 'add', 1)
	elseif data == 4 then
		Player.Functions.RemoveItem('goldbar', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['goldbar'], 'remove', 1)
		Player.Functions.AddItem("gold_ring", 3)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["gold_ring"], 'add', 3)
	elseif data == 5 then
		Player.Functions.RemoveItem('gold_ring', 1)
		Player.Functions.RemoveItem('diamond', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['gold_ring'], 'remove', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['diamond'], 'remove', 1)
		Player.Functions.AddItem("diamond_ring", 1)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["diamond_ring"], 'add', 1)
	elseif data == 6 then
		Player.Functions.RemoveItem('goldbar', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['goldbar'], 'remove', 1)
		Player.Functions.AddItem("goldchain", 3)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["goldchain"], 'add', 3)
	elseif data == 7 then
		Player.Functions.RemoveItem('goldbar', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['goldbar'], 'remove', 1)
		Player.Functions.AddItem("10kgoldchain", 2)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["10kgoldchain"], 'add', 2)
	end
end)