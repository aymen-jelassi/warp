

RegisterNetEvent('warp-smelter:getrefined_aluminium')
AddEventHandler('warp-smelter:getrefined_aluminium', function()
    if exports['warp-inventory']:hasEnoughOfItem('aluminium', 1) then
        FreezeEntityPosition(PlayerPedId(), true)
        local Evan1 = exports['warp-taskbar']:taskBar(5000, 'Turning Aluminium into refined Aluminium')
        if Evan1 == 100 then
            TriggerEvent('inventory:removeItem', 'aluminium', 1)
            TriggerEvent('player:receiveItem', 'refinedaluminium', 5)
            TriggerEvent('DoLongHudText', 'Successfully turned Aluminium into Refined Aluminium.', 1)
            FreezeEntityPosition(PlayerPedId(), false)
        else
            FreezeEntityPosition(PlayerPedId(), false)
        end
    else
        TriggerEvent('DoLongHudText', 'You do not have 1x Aluminium.', 2)
    end
end)

RegisterNetEvent('warp-smelter:getrefined_plastic')
AddEventHandler('warp-smelter:getrefined_plastic', function()
    if exports['warp-inventory']:hasEnoughOfItem('plastic', 1) then
        FreezeEntityPosition(PlayerPedId(), true)
        local Evan2 = exports['warp-taskbar']:taskBar(5000, 'Turning plastic into Refined Plastic')
        if Evan2 == 100 then
            TriggerEvent('inventory:removeItem', 'plastic', 1)
            TriggerEvent('player:receiveItem', 'refinedplastic', 5)
            TriggerEvent('DoLongHudText', 'Successfully turned Plastic into Refined Plastic', 1)
            FreezeEntityPosition(PlayerPedId(), false)
        else
            FreezeEntityPosition(PlayerPedId(), false)
        end
    else
        TriggerEvent('DoLongHudText', 'You do not have 1x Plastic', 1)
    end
end)

RegisterNetEvent('warp-smelter:getrefined_copper')
AddEventHandler('warp-smelter:getrefined_copper', function()
    if exports['warp-inventory']:hasEnoughOfItem('copper', 1) then
        FreezeEntityPosition(PlayerPedId(), true)
        local Evan3 = exports['warp-taskbar']:taskBar(5000, 'Turning Copper into refined Copper')
        if Evan3 == 100 then
            TriggerEvent('inventory:removeItem', 'copper', 1)
            TriggerEvent('player:receiveItem', 'refinedcopper', 5)
            TriggerEvent('DoLongHudText', 'Successfully turned Copper into refined Copper', 1)
            FreezeEntityPosition(PlayerPedId(), false)
        else
            FreezeEntityPosition(PlayerPedId(), false)
        end
    else
        TriggerEvent('DoLongHudText', 'You do not have 1x Copper', 1)
    end
end)

RegisterNetEvent('warp-smelter:getrefined_glass')
AddEventHandler('warp-smelter:getrefined_glass', function()
    if exports['warp-inventory']:hasEnoughOfItem('glass', 1) then
        FreezeEntityPosition(PlayerPedId(), true)
        local Evan4 = exports['warp-taskbar']:taskBar(5000, 'Turning Glass into Refined Glass')
        if Evan4 == 100 then
            TriggerEvent('inventory:removeItem', 'glass', 1)
            TriggerEvent('player:receiveItem', 'refinedglass', 5)
            TriggerEvent('DoLongHudText', 'Successfully turned Glass into Refined Glass')
            FreezeEntityPosition(PlayerPedId(), false)
        else
            FreezeEntityPosition(PlayerPedId(), false)
        end
    else
        TriggerEvent('DoLongHudText', 'You do not have 1x Glass', 1)
    end
end)

RegisterNetEvent('warp-smelter:getrefined_rubber')
AddEventHandler('warp-smelter:getrefined_rubber', function()
    if exports['warp-inventory']:hasEnoughOfItem('rubber', 1) then
        FreezeEntityPosition(PlayerPedId(), true)
        local Evan5 = exports['warp-taskbar']:taskBar(5000, 'Turning Rubber into Refined Rubber')
        if Evan5 == 100 then
            TriggerEvent('inventory:removeItem', 'rubber', 1)
            TriggerEvent('player:receiveItem', 'refinedrubber', 5)
            TriggerEvent('DoLongHudText', 'Successfully turned Rubber into Refined Rubber')
            FreezeEntityPosition(PlayerPedId(), false)
        else
            FreezeEntityPosition(PlayerPedId(), false)
        end
    else
        TriggerEvent('DoLongHudText', 'You do not have 1x Rubber', 1)
    end
end)

RegisterNetEvent('warp-smelter:getrefined_scrap')
AddEventHandler('warp-smelter:getrefined_scrap', function()
    if exports['warp-inventory']:hasEnoughOfItem('scrapmetal', 1) then
        FreezeEntityPosition(PlayerPedId(), true)
        local Evan6 = exports['warp-taskbar']:taskBar(5000, 'Turning Scrap Metal into Refined Scrap')
        if Evan6 == 100 then
            TriggerEvent('inventory:removeItem', 'scrapmetal', 1)
            TriggerEvent('player:receiveItem', 'refinedscrap', 5)
            TriggerEvent('DoLongHudText', 'Successfully turned Scrap Metal into Refined Rubber')
            FreezeEntityPosition(PlayerPedId(), false)
        else
            FreezeEntityPosition(PlayerPedId(), false)
        end
    else
        TriggerEvent('DoLongHudText', 'You do not have 1x Scrap Metal', 1)
    end
end)

RegisterNetEvent('warp-smelter:getrefined_steel')
AddEventHandler('warp-smelter:getrefined_steel', function()
    if exports['warp-inventory']:hasEnoughOfItem('steel', 1) then
        FreezeEntityPosition(PlayerPedId(), true)
        local Evan7 = exports['warp-taskbar']:taskBar(5000, 'Turning Steel into Refined Rubber')
        if Evan7 == 100 then
            TriggerEvent('inventory:removeItem', 'steel', 1)
            TriggerEvent('player:receiveItem', 'refinedsteel', 5)
            TriggerEvent('DoLongHudText', 'Successfully turned Steel into Refined Rubber')
            FreezeEntityPosition(PlayerPedId(), false)
        else
            FreezeEntityPosition(PlayerPedId(), false)
        end
    else
        TriggerEvent('DoLongHudText', 'You do not have 1x Steel', 1)
    end
end)

-- Context Menu --

RegisterNetEvent('warp-jobs:refined_materials', function()
    TriggerEvent('warp-context:sendMenu', {
        {
            id = 0,
            header = "Smelter",
            txt = "",
            params = {
                event = "",
            },
        },
        {
            id = 1,
            header = "Get Refined Aluminium",
            txt = "Requirements: 1x Aluminium",
            params = {
                event = "warp-smelter:getrefined_aluminium",
            },
        },
        {
            id = 2,
            header = "Get Refined Plastic",
            txt = "Requirements: 1x Plastic",
            params = {
                event = "warp-smelter:getrefined_plastic",
            },
        },
        {
            id = 3,
            header = "Get Refined Copper",
            txt = "Requirements: 1x Copper",
            params = {
                event = "warp-smelter:getrefined_copper",
            },
        },
        {
            id = 4,
            header = "Get Refined Glass",
            txt = "Requirements: 1x Glass",
            params = {
                event = "warp-smelter:getrefined_glass",
            },
        },
        {
            id = 5,
            header = "Get Refined Rubber",
            txt = "Requirements: 1x Rubber",
            params = {
                event = "warp-smelter:getrefined_rubber",
            },
        },
        {
            id = 6,
            header = "Get Refined Scrap",
            txt = "Requirements: 1x Scrap Metal",
            params = {
                event = "warp-smelter:getrefined_scrap",
            },
        },
        {
            id = 7,
            header = "Get Refined Steel",
            txt = "Requirements: 1x Steel",
            params = {
                event = "warp-smelter:getrefined_steel",
            },
        },
        {
            id = 8,
            header = "Close Smelter",
			txt = "",
			params = {
                event = "",
            }
        },
    })
end)

-- Interact --

exports["warp-polytarget"]:AddBoxZone("smelter_shit", vector3(1111.36, -2009.1, 31.04), 5, 1.6, {
    heading=325,
    --debugPoly=true,
    minZ=29.24,
    maxZ=33.24
})

exports["warp-interact"]:AddPeekEntryByPolyTarget("smelter_shit", {{
    event = "warp-jobs:refined_materials",
    id = "smelter_shit",
    icon = "warehouse",
    label = "Use Smelter",
    parameters = {},
}}, {
    distance = { radius = 2.5 },
});
