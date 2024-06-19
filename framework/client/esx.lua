if GetResourceState('es_extended') == 'started' then 
	ESX = exports['es_extended']:getSharedObject()
    Bridge = {
        GetPlayerData = function()
            return ESX.GetPlayerData()
        end,
        f_Progressbar = function(data)
            local result 
            ESX.Progressbar(data.label, Config.Debug and 1000 or data.time, {
                FreezePlayer = true,
                animation ={
                    type = "anim",
                    dict = data.dict, 
                    lib = data.anim
                },
                onFinish = function()
                    lockInv(false)
                    result = true
                end, 
                onCancel = function()
                    lockInv(false)
                    result = false
                end
            })
            while result == nil do Wait(10) end 
            return result
        end,
        GetItem = function(item)
            print('Insert your inventory information here framework/client/esx.lua or edit jim-mining/client.lua:13 GetItem()')
            return 
        end,
    }
    RegisterNetEvent('esx:playerLoaded', function(xPlayer, isNew, skin)
        PlayerJob = xPlayer.job
        if Config.Job then if PlayerJob.name == Config.Job then makeJob() else removeJob() end else makeJob() end
    end)
    RegisterNetEvent('esx:setJob', function(job, lastJob)
        PlayerJob = job
        if Config.Job then if PlayerJob.name == Config.Job then makeJob() else removeJob() end end
    end)


end