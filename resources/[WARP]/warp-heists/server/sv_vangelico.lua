
local CooldownTimer = true

local pIsAvailable = true

RegisterServerEvent('warp-heists:start_hitting_upper_vangelico')
AddEventHandler('warp-heists:start_hitting_upper_vangelico', function()
    local src = source
    local user = exports["warp-base"]:getModule("Player"):GetUser(src)

    if CooldownTimer then
        print('[warp-heists] Someone Robbing Vangelico')
        CooldownTimer = false
        pIsAvailable = false
        TriggerClientEvent('warp-jewelry:open_doors', src)
        print('^3[warp-heists]: ^2Cooldown started^0')
        Citizen.Wait(3600000)
        print('[warp-heists] Vangelico No Longer On Cooldown')
        TriggerClientEvent('warp-heists:lock_vangelico_doors_cooldown', src)
        CooldownTimer = true
        pIsAvailable = true
    else
        print('[warp-heists] Someone Trying to Rob Vangelico But Already Been Robbed')
        TriggerClientEvent('DoLongHudText', src, 'This Jewelry Store was recently robbed.', 2)
    end
end)

RegisterServerEvent('warp-heists:vangelico_loot')
AddEventHandler('warp-heists:vangelico_loot', function()
    local src = source
    local EvanVangelicoLoot = math.random(1, 3)

    if EvanVangelicoLoot == 1 then
        TriggerClientEvent('player:receiveItem', src,'valuablegoods', math.random(5, 10))
        TriggerClientEvent('player:receiveItem', src,'goldbar', math.random(1, 5))
        TriggerClientEvent('player:receiveItem', src,'rolexwatch', math.random(10, 20))
    elseif EvanVangelicoLoot == 2 then
        TriggerClientEvent('player:receiveItem', src,'goldcoin', math.random(15, 30))
        TriggerClientEvent('player:receiveItem', src,'stolen8ctchain', math.random(3, 10))
    elseif EvanVangelicoLoot == 3 then
        TriggerClientEvent('player:receiveItem', src,'valuablegoods', math.random(5, 14))
        TriggerClientEvent('player:receiveItem', src,'goldcoin', math.random(15, 50))
        TriggerClientEvent('player:receiveItem', src,'rolexwatch', math.random(40, 60))
    end
end)

RegisterServerEvent('warp-heists:get_vangelico_availability')
AddEventHandler('warp-heists:get_vangelico_availability', function()
    local src = source

    if pIsAvailable then
        TriggerClientEvent('warp-heists:vangelico_available', src)
    else
        TriggerClientEvent('warp-heists:vangelico_unavailable', src)
    end
end)