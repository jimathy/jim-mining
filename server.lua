QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent('jim-mining:MineReward')
AddEventHandler('jim-mining:MineReward', function()
    local Player = QBCore.Functions.GetPlayer(source)
    local randomChance = math.random(1, 3)
    Player.Functions.AddItem('stone', randomChance)
    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["stone"], "add", randomChance)
end)

RegisterServerEvent('jim-mining:CrackReward')
AddEventHandler('jim-mining:CrackReward', function()
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.RemoveItem('stone', 1)
    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["stone"], "remove", 1)
    local oreToGive = math.random(1,#RewardPool)
    local amount = math.random(1, 2)
    Player.Functions.AddItem(RewardPool[oreToGive], amount)
    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[RewardPool[oreToGive]], "add", amount)
end)

RegisterServerEvent('jim-mining:OreCheck')
AddEventHandler('jim-mining:OreCheck', function()
    local src = source
	local Player = QBCore.Functions.GetPlayer(source)
    local Ore = Player.Functions.GetItemByName("copperore")
    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[Ore], "remove", Ore.amount)
end)

QBCore.Functions.CreateCallback('jim-mining:CopperCheck',function(source, cb)
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    local Copper = Player.Functions.GetItemByName('copperore')
    if Copper then 
        cb(true)
    else 
        cb(false)
    end
end)

RegisterServerEvent('jim-mining:Sellcopper')
AddEventHandler('jim-mining:Sellcopper', function()
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src) 
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['copperore'], "remove", 1)
end)
