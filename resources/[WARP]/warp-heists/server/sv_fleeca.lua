CnaRob = true

local Available = true

RegisterServerEvent("warp-fleeca:laptop1", function()
    if CnaRob then
        Available = false
        TriggerClientEvent("warp-fleeca:laptopused", source, 1)
    else
        TriggerClientEvent("DoLongHudText", source, "The bank has been robbed recently. Try again soon")
    end
end)

RegisterServerEvent("warp-fleeca:laptop1", function()
    if CnaRob then
        TriggerClientEvent("warp-fleeca:laptopused", source, 2)
    else
        TriggerClientEvent("DoLongHudText", source, "The bank has been robbed recently. Try again soon")
    end
end)

RegisterServerEvent("warp-fleeca:laptop1", function()
    if CnaRob then
        TriggerClientEvent("warp-fleeca:laptopused", source, 3)
    else
        TriggerClientEvent("DoLongHudText", source, "The bank has been robbed recently. Try again soon")
    end
end)

RegisterServerEvent("warp-fleeca:laptop1", function()
    if CnaRob then
        TriggerClientEvent("warp-fleeca:laptopused", source, 4)
    else
        TriggerClientEvent("DoLongHudText", source, "The bank has been robbed recently. Try again soon")
    end
end)

RegisterServerEvent("warp-fleeca:laptop1", function()
    if CnaRob then
        TriggerClientEvent("warp-fleeca:laptopused", source, 5)
    else
        TriggerClientEvent("DoLongHudText", source, "The bank has been robbed recently. Try again soon")
    end
end)



RegisterServerEvent("warp-fleeca:startCoolDown", function()
    CnaRob = false
    CreateThread(function()
        while true do
            Citizen.Wait(3600000)
            CnaRob = true
            Available = true
            TriggerClientEvent("warp-fleeca:resetdoors", source)
        end
    end)
end)

-- Loot 

local Loot = false

RegisterServerEvent('warp-fleeca:tut_tut')
AddEventHandler('warp-fleeca:tut_tut', function()
    local src = source
    if not Loot then
        Loot = true
        TriggerClientEvent('warp-fleeca:grab', src)
        Citizen.Wait(40000)
        Loot = false
    else
        TriggerClientEvent('DoLongHudText', src,'Fuck off you exploiting prick, CAUGHT IN 4K Ultra HD get logged.', 2)
    end
end)

-- Context Menu Shit --

RegisterServerEvent('warp-heists:fleeca_availability')
AddEventHandler('warp-heists:fleeca_availability', function()
    local src = source
    
    if Available then
        TriggerClientEvent('warp-heists:fleeca_available', src)
    else
        TriggerClientEvent('warp-heists:fleeca_unavailable', src)
    end
end)