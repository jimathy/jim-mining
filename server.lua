QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local rainbowCards = { "rainbowmewtwogx", "rainbowvmaxcharizard", "rainbowvmaxpikachu", "snorlaxvmaxrainbow"}

local basicTotal = #basicCards

RegisterServerEvent('Cards:Server:rewarditem')
AddEventHandler('Cards:Server:rewarditem', function()
    local Player = QBCore.Functions.GetPlayer(source)
    local pack = Player.Functions.GetItemByName("boosterpack")
    local amount = Config.CardsInPack
        --Player.Functions.RemoveItem('boosterpack', 1)
        --TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["boosterpack"], "remove", 1)
    while amount > 0 do
        Wait(1)
        amount = amount -1
		local randomChance = math.random(1, 1000)
        CardGive(randomChance)
        Wait(8000)
    end
end)

