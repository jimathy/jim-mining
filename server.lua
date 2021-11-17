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
RegisterServerEvent('jim-mining:Smelting')
AddEventHandler('jim-mining:Smelting', function(data)
    local src = source
	local Player = QBCore.Functions.GetPlayer(source)
	if data == 1 then
		if Player.Functions.GetItemByName('copperore') ~= nil then
			Player.Functions.RemoveItem('copperore', 1)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['copperore'], 'remove', 1)
			Player.Functions.AddItem("copper", 10)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["copper"], 'add', 10)
		else
			TriggerClientEvent('QBCore:Notify', source, "You don't have enough copper ore.", "error")
		end
	elseif data == 2 then
		if Player.Functions.GetItemByName('goldore') >= 4 then
			Player.Functions.RemoveItem('goldore', 4)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['goldore'], 'remove', 4)
			Player.Functions.AddItem("goldbar", 1)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["goldbar"], 'add', 1)
		else
			TriggerClientEvent('QBCore:Notify', source, "You don't have enough gold ore.", "error")
		end
	elseif data == 3 then
		if Player.Functions.GetItemByName('ironore') ~= nil then
			Player.Functions.RemoveItem('ironore', 1)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['ironore'], 'remove', 1)
			Player.Functions.AddItem("iron", 10)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["iron"], 'add', 10)
		else
			TriggerClientEvent('QBCore:Notify', source, "You don't have enough iron ore.", "error")
		end
	elseif data == 4 then
		if Player.Functions.GetItemByName('ironore') ~= nil and Player.Functions.GetItemByName('carbon') ~= nil then
			Player.Functions.RemoveItem('ironore', 1)
			Player.Functions.RemoveItem('carbon', 1)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['ironore'], 'remove', 1)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['carbon'], 'remove', 1)
			Player.Functions.AddItem("steel", 2)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["steel"], 'add', 2)
		else
			TriggerClientEvent('QBCore:Notify', source, "You don't have enough materials.", "error")
		end
	end
end)

RegisterServerEvent('jim-mining:Cutting')
AddEventHandler('jim-mining:Cutting', function(data)
    local src = source
	local Player = QBCore.Functions.GetPlayer(source)
	if data == 1 then
		if Player.Functions.GetItemByName('uncut_emerald') ~= nil then
			Player.Functions.RemoveItem('uncut_emerald', 1)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['uncut_emerald'], 'remove', 1)
			Player.Functions.AddItem("emerald", 1)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["emerald"], 'add', 1)
		else
			TriggerClientEvent('QBCore:Notify', source, "You don't have an Uncut Emerald", "error")
		end
	elseif data == 2 then
		if Player.Functions.GetItemByName('uncut_ruby') ~= nil then
			Player.Functions.RemoveItem('uncut_ruby', 1)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['uncut_ruby'], 'remove', 1)
			Player.Functions.AddItem("ruby", 1)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["ruby"], 'add', 1)
		else
			TriggerClientEvent('QBCore:Notify', source, "You don't have an Uncut Ruby", "error")
		end
	elseif data == 3 then
		if Player.Functions.GetItemByName('uncut_diamond') ~= nil then
			Player.Functions.RemoveItem('uncut_diamond', 1)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['uncut_diamond'], 'remove', 1)
			Player.Functions.AddItem("diamond", 1)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["diamond"], 'add', 1)
		else
			TriggerClientEvent('QBCore:Notify', source, "You don't have an Uncut Ruby", "error")
		end
	elseif data == 4 then
		if Player.Functions.GetItemByName('goldbar') ~= nil then
			Player.Functions.RemoveItem('goldbar', 1)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['goldbar'], 'remove', 1)
			Player.Functions.AddItem("gold_ring", 3)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["gold_ring"], 'add', 3)
		else
			TriggerClientEvent('QBCore:Notify', source, "You don't have a gold bar", "error")
		end
	elseif data == 5 then
		if Player.Functions.GetItemByName('goldring') ~= nil and Player.Functions.GetItemByName('diamond') ~= nil then
			Player.Functions.RemoveItem('goldring', 1)
			Player.Functions.RemoveItem('diamond', 1)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['goldring'], 'remove', 1)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['diamond'], 'remove', 1)
			Player.Functions.AddItem("diamond_ring", 1)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["diamond_ring"], 'add', 1)
		else
			TriggerClientEvent('QBCore:Notify', source, "You don't have enough materials.", "error")
		end
	elseif data == 6 then
		if Player.Functions.GetItemByName('goldbar') ~= nil then
			Player.Functions.RemoveItem('goldbar', 1)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['goldbar'], 'remove', 1)
			Player.Functions.AddItem("goldchain", 3)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["goldchain"], 'add', 3)
		else
			TriggerClientEvent('QBCore:Notify', source, "You don't have a gold bar", "error")
		end
	elseif data == 6 then
		if Player.Functions.GetItemByName('goldbar') ~= nil then
			Player.Functions.RemoveItem('goldbar', 1)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['goldbar'], 'remove', 1)
			Player.Functions.AddItem("10kgoldchain", 2)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["10kgoldchain"], 'add', 2)
		else
			TriggerClientEvent('QBCore:Notify', source, "You don't have a gold bar", "error")
		end
	end
end)