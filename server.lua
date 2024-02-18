RegisterServerEvent("jim-mining:Reward", function(data)
	local src = source
	local amount = 1
	if data.setReward then
		TriggerEvent("jim-mining:server:toggleItem", true, data.setReward, math.random(1, 3), src)
		TriggerEvent("jim-mining:server:toggleItem", true, "stone", math.random(1, 2), src)
	else
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
	end
end)

if GetResourceState(OXInv):find("start") then
	exports[OXInv]:RegisterShop("miningShop", { name = Config.Items.label, inventory = Config.Items.items })
end

AddEventHandler('onResourceStart', function(resource) if GetCurrentResourceName() ~= resource then return end
Wait(1000)
	for k in pairs(Selling) do
		if Selling[k].Items then
			for b in pairs(Selling[k].Items) do
				if not Items[b] then print("Selling: Missing Item from Items: '"..b.."'") end
			end
		else
			for l in pairs(Selling[k]) do
				if l ~= "Header" then
					for b in pairs(Selling[k][l].Items) do
						if not Items[b] then print("Selling: Missing Item from Items: '"..b.."'") end
					end
				end
			end
		end
	end
	for i = 1, #Config.CrackPool do if not Items[Config.CrackPool[i]] then print("CrackPool: Missing Item from Items: '"..Config.CrackPool[i].."'") end end
	for i = 1, #Config.WashPool do if not Items[Config.WashPool[i]] then print("WashPool: Missing Item from Items: '"..Config.WashPool[i].."'") end end
	for i = 1, #Config.PanPool do if not Items[Config.PanPool[i]] then print("PanPool: Missing Item from Items: '"..Config.PanPool[i].."'") end end
	for i = 1, #Config.Items.items do if not Items[Config.Items.items[i].name] then print("Shop: Missing Item from Items: '"..Config.Items.items[i].name.."'") end end
	local itemcheck = {}
	for _, v in pairs(Crafting) do
		if type(v) == "table" then
			for _, b in pairs(v.Recipes) do
				for k, l in pairs(b) do
					if k ~= "amount" then
						itemcheck[k] = {}
						for j in pairs(l) do
							itemcheck[j] = {}
						end
					end
				end
			end
		end
	end
	for k in pairs(itemcheck) do
		if not Items[k] then print("Crafting recipe couldn't find item '"..k.."' in the shared") end
	end
end)