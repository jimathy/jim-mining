
if GetResourceState('qb-core') == 'started' then 
	QBCore = exports['qb-core']:GetCoreObject()
    Bridge = {
        GetPlayerData = function ()
            return QBCore.Functions.GetPlayerData()
        end,
        f_Progressbar = function(data)
            local result 
            QBCore.Functions.Progressbar("mechbar",	data.label,	Config.Debug and 1000 or data.time, data.dead, data.cancel or true,
            { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true, },
            { animDict = data.dict, anim = data.anim, flags = (data.flag == 8 and 32 or data.flag) or nil, task = data.task }, {}, {}, 
            function()
                lockInv(false)
                result = true
            end, function()
                lockInv(false)
                result = false
            end, data.icon)
            while result == nil do Wait(10) end 
            return result
        end,
        GetItem = function(item)
            return QBCore.Shared.Items[item]
        end,

    }
    
    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        QBCore.Functions.GetPlayerData(function(PlayerData)	PlayerJob = PlayerData.job end)
        if Config.Job then if PlayerJob.name == Config.Job then makeJob() else removeJob() end else makeJob() end
    end)
    RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
        PlayerJob = JobInfo
        if Config.Job then if PlayerJob.name == Config.Job then makeJob() else removeJob() end end
    end)
end