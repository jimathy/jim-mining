
if GetResourceState('qb-core') == 'started' then 
	QBCore = exports['qb-core']:GetCoreObject()
    Bridge = {
        GetPlayer = function(src)
            return QBCore.Functions.GetPlayer(src)
        end,
        GetItemByName = function(Player, name, isAmount)
            if isAmount then 
                return Player.Functions.GetItemByName(name).amount
            end
            return Player.Functions.GetItemByName(name)
        end,
        AddMoney = function(Player, account, amount)
            Player.Functions.AddMoney(account, amount)
        end,
        AddItem = function(Player, item, amount)
            return Player.Functions.AddItem(item, amount)
        end,
        PlayerInv = function(Player)
            return Player.PlayerData.items
        end
    }




end