RegisterNetEvent('warp-illegalactivities:check_availability')
AddEventHandler('warp-illegalactivities:check_availability', function()
    TriggerEvent('warp-context:sendMenu', {
        {
            id = 1,
            header = "Heist Availability",
            txt = "",
        },
        {
            id = 2,
            header = "Fleeca Bank",
            txt = "Check Fleeca Bank Availability",
            params = {
                event = 'warp-illegalactivities:avail_fleeca',
            }
        },
        {
            id = 3,
            header = "Jewelry Store",
            txt = "Check Jewelry Store Availability",
            params = {
                event = 'warp-illegalactivities:avail_jewel',
            }
        },
        {
            id = 4,
            header = "Paleto Bank",
            txt = "Check Paleto Bank Availability",
            params = {
                event = 'warp-illegalactivities:avail_paleto',
            }
        },
    })
end)

RegisterNetEvent('warp-illegalactivities:avail_fleeca')
AddEventHandler('warp-illegalactivities:avail_fleeca', function()
    TriggerServerEvent('warp-heists:fleeca_availability')
end)

RegisterNetEvent('warp-illegalactivities:avail_jewel')
AddEventHandler('warp-illegalactivities:avail_jewel', function()
    TriggerServerEvent('warp-heists:get_vangelico_availability')
end)

RegisterNetEvent('warp-illegalactivities:avail_paleto')
AddEventHandler('warp-illegalactivities:avail_paleto', function()
    TriggerServerEvent('warp-heists:paleto_avail_check')
end)