QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent('jim-mining:MineReward')
AddEventHandler('jim-mining:MineReward', function()
    local Player = QBCore.Functions.GetPlayer(source)
    local randomChance = math.random(1, 3)
    Player.Functions.AddItem('stone', randomChance)
    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["stone"], "add", randomChance)
end)

--Not sure why, but had to put the reward pool here as it claimed the Config version was NIL
RewardPool = {
	'copperore', 'copperore', 'copperore', 'copperore', 'copperore', 'copperore', -- 6x
	'goldore', 'goldore', 'goldore', -- 3x
	'ironore', 'ironore', 'ironore', 'ironore', 'ironore', 'ironore', -- 6x
	--'tinore', 'tinore', 'tinore', 'tinore', 'tinore', 'tinore', 'tinore', 'tinore', 'tinore', -- 9x
	--'coal', 'coal', 'coal', 'coal', 'coal', 'coal', 'coal', 'coal', 'coal', 'coal', --10x
	--'uncut_ruby',
	--'uncut_emerald',
	--'uncut_diamond',
}

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