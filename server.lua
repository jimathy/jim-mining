RegisterServerEvent('jim-mining:Crafting:GetItem', function(ItemMake, craftable)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	local amount = 1
	if craftable then
		if craftable["amount"] then amount = craftable["amount"] end
		for k, v in pairs(craftable[ItemMake]) do
			print(k, v)
			TriggerEvent("jim-mining:server:toggleItem", false, tostring(k), v, src)
		end
	end
	TriggerEvent("jim-mining:server:toggleItem", true, ItemMake, amount, src)
end)

RegisterServerEvent("jim-mining:Reward", function(data)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	local amount = 1
	if data.mine then
		TriggerEvent("jim-mining:server:toggleItem", true, "stone", math.random(1, 3), src)
	elseif data.crack then
		TriggerEvent("jim-mining:server:toggleItem", false, "stone", data.cost, src)
		for i = 1, math.random(1,3) do
			amount = math.random(1, 2)
			TriggerEvent("jim-mining:server:toggleItem", true, Config.CrackPool[math.random(1, #Config.CrackPool)], amount, src)
		end
	elseif data.wash then
		TriggerEvent("jim-mining:server:toggleItem", false, "stone", data.cost, src)
		for i = 1, math.random(1,2) do
			TriggerEvent("jim-mining:server:toggleItem", true, Config.WashPool[math.random(1, #Config.WashPool)], amount, src)
		end
	elseif data.pan then
		for i = 1, math.random(1,3) do
			TriggerEvent("jim-mining:server:toggleItem", true, Config.PanPool[math.random(1, #Config.PanPool)], amount, src)
		end
	end
end)

RegisterNetEvent("jim-mining:Selling", function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName(data.item) ~= nil then
        local amount = Player.Functions.GetItemByName(data.item).amount
        local pay = (amount * Config.SellingPrices[data.item])
		TriggerEvent("jim-mining:server:toggleItem", false, data.item, amount, src)
        Player.Functions.AddMoney('cash', pay)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[data.item], 'remove', amount)
    else
		tirggerNotify(src, Loc[Config.Lan].error["dont_have"].." "..QBCore.Shared.Items[data.item].label, "error")
    end
end)

local function dupeWarn(src, item)
	local P = QBCore.Functions.GetPlayer(src)
	print("^5DupeWarn: ^1"..P.PlayerData.charinfo.firstname.." "..P.PlayerData.charinfo.lastname.."^7(^1"..tostring(src).."^7) ^2Tried to remove item ^7('^3"..item.."^7')^2 but it wasn't there^7")
	if not Config.Debug then DropPlayer(src, "^1Kicked for attempting to duplicate items") end
	print("^5DupeWarn: ^1"..P.PlayerData.charinfo.firstname.." "..P.PlayerData.charinfo.lastname.."^7(^1"..tostring(src).."^7) ^2Dropped from server for item duplicating^7")
end

RegisterNetEvent('jim-mining:server:toggleItem', function(give, item, amount, newsrc)
	local src = newsrc or source
	local Player = QBCore.Functions.GetPlayer(src)
	local remamount = (amount or 1)
	if give == 0 or give == false then
		if HasItem(src, item, amount or 1) then -- check if you still have the item
			if Config.Inv == "ox" then Player.Functions.RemoveItem(item, amount) else
			while remamount > 0 do if Player.Functions.RemoveItem(item, 1) then end remamount -= 1 end
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove", amount or 1) end
			if Config.Debug then print("^5Debug^7: ^1Removing ^2from Player^7(^2"..src.."^7) '^6"..QBCore.Shared.Items[item].label.."^7(^2x^6"..(amount or "1").."^7)'") end
		else dupeWarn(src, item) end -- if not boot the player
	else
		if Player.Functions.AddItem(item, amount or 1) then
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add", amount or 1)
			if Config.Debug then print("^5Debug^7: ^4Giving ^2Player^7(^2"..src.."^7) '^6"..QBCore.Shared.Items[item].label.."^7(^2x^6"..(amount or "1").."^7)'") end
		end
	end
end)

if Config.Inv == "ox" then
	exports.ox_inventory:RegisterShop("miningShop", { name = Config.Items.label, inventory = Config.Items.items })
	function HasItem(src, items, amount) local count = exports.ox_inventory:Search(src, 'count', items)
		if exports.ox_inventory:Search(src, 'count', items) >= (amount or 1) then if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^5FOUND^7 x^3"..count.."^7 ^3"..tostring(items)) end return true
        else if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Items ^1NOT FOUND^7") end return false end
	end
else
	function HasItem(source, items, amount)
		local amount, count = amount or 1, 0
		local Player = QBCore.Functions.GetPlayer(source)
		if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Checking if player has required item^7 '^3"..tostring(items).."^7'") end
		for _, itemData in pairs(Player.PlayerData.items) do
			if itemData and (itemData.name == items) then
				if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Item^7: '^3"..tostring(items).."^7' ^2Slot^7: ^3"..itemData.slot.." ^7x(^3"..tostring(itemData.amount).."^7)") end
				count += itemData.amount
			end
		end
		if count >= amount then if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Items ^5FOUND^7 x^3"..count.."^7") end return true end
		if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Items ^1NOT FOUND^7") end	return false
	end
end

AddEventHandler('onResourceStart', function(resource) if GetCurrentResourceName() ~= resource then return end
	for k, v in pairs(Config.SellingPrices) do if not QBCore.Shared.Items[k] then print("Selling: Missing Item from QBCore.Shared.Items: '"..k.."'") end end
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