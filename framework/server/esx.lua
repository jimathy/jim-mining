if GetResourceState('es_extended') == 'started' then 
	ESX = exports['es_extended']:getSharedObject()
    Bridge = {
        GetPlayer = function(src)
            return ESX.GetPlayerFromId(src)
        end,
        GetItemByName = function(xPlayer, name, isAmount)
            if isAmount then 
                return xPlayer.getInventoryItem(name).count
            end
            return xPlayer.getInventoryItem(name)
        end,
        AddMoney = function(xPlayer, account, amount)
            if account == 'cash' then account = 'money' end 
            xPlayer.addAccountMoney(account, amount)
        end,
        AddItem = function(xPlayer, item, amount)
            if xPlayer.canCarryItem(item, amount) then 
                xPlayer.addInventoryItem(item, amount)
                return true 
            else
                return false 
            end
        end,
        PlayerInv = function(xPlayer)
            return xPlayer.getInventory(true)
        end

        
    }





end