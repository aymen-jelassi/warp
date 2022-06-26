--############--
--## Void RP##--
--############--

-- Start Of Clock In / Out --

local ChosenWeed = false
local ChosenCoke = false
local ChosenMeth = false

RegisterNetEvent('warp-drugsales:clockin')
AddEventHandler('warp-drugsales:clockin', function()
    if exports['warp-inventory']:hasEnoughOfItem('vpnxj', 1) then
        TriggerEvent('warp-illegal_activities:drug_run_choose')
    else
        TriggerEvent('DoLongHudText', 'You\'re Missing a VPN!', 2)
    end
end)

-- End Of Clock In / Out --

-- Start Of Picking Drug To Run --

RegisterNetEvent('warp-illegal_activities:drug_run_choose', function()
    TriggerEvent('warp-context:sendMenu', {
        {
            id = 0,
            header = "Drug Location",
            txt = "",
            params = {
                event = "",
            },
        },
        {
            id = 1,
            header = "Run Cocaine",
            txt = "Sell Cocaine To Locals",
            params = {
                event = "warp-illegalactivities:choose_coke",
            },
        },
        {
            id = 2,
            header = "Run Weed Q",
            txt = "Sell Weed To Locals",
            params = {
                event = "warp-illegalactivities:choose_weed",
            },
        },
        {
            id = 3,
            header = "Run Meth",
            txt = "Sell Meth To Locals",
            params = {
                event = "warp-illegalactivities:choose_meth",
            },
        },
    })
end)

-- Coke Run

RegisterNetEvent('warp-illegalactivities:choose_coke')
AddEventHandler('warp-illegalactivities:choose_coke', function()
    if exports['warp-inventory']:hasEnoughOfItem('coke5g', 1) then
        ChosenCoke = true
        SetNewWaypoint(1533.4417724609,793.26593017578,77.487182617188)
        TriggerEvent('warp-drugs:drop_cocaine_blip')
        TriggerEvent('warp-illegalactivities:create_coke_ped')
        TriggerEvent('phone:addJobNotify', 'You\'re GPS Has been updated.')
    else
        TriggerEvent('DoLongHudText', 'You dont got any Coke to run', 2)
    end
end)

RegisterNetEvent('warp-drugs:drop_cocaine_blip')
AddEventHandler('warp-drugs:drop_cocaine_blip', function()
    CokeDropBlip = AddBlipForCoord(1533.4417724609,793.26593017578,77.487182617188)
    SetBlipSprite(CokeDropBlip, 514)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Cocaine Drop Location")
    EndTextCommandSetBlipName(CokeDropBlip)
end)

RegisterNetEvent('warp-drugs:do_drop_coke')
AddEventHandler('warp-drugs:do_drop_coke', function()
    TriggerEvent('warp-mdt:drugsale')
    local CokePayment = math.random(500, 700)

    if exports['warp-inventory']:hasEnoughOfItem('coke5g', 1) then
        local pHowMuchCoke = exports["warp-applications"]:KeyboardInput({
            header = "",
            rows = {
            {
                id = 0,
                txt = "Input How Much Coke Baggies You Want To Sell"
            }
            }
        })
        local pPaymentAmountCoke = CokePayment*pHowMuchCoke[1].input
        if pHowMuchCoke[1] ~= nil then
            if exports['warp-inventory']:hasEnoughOfItem('coke5g', pHowMuchCoke[1].input) then
                if exports['warp-inventory']:hasEnoughOfItem('coke5g', pHowMuchCoke[1].input) then
                    TriggerEvent('inventory:removeItem', 'coke5g', pHowMuchCoke[1].input)
                    TriggerServerEvent('zyloz:payout', pPaymentAmountCoke)
                    TriggerEvent('phone:addJobNotify', 'You sold '..pHowMuchCoke[1].input..'x Coke 5G For $'..pPaymentAmountCoke)
                    DeletePed(created_ped)
                    RemoveBlip(CokeDropBlip)
                    ChosenCoke = false
                end
            else
                TriggerEvent('DoLongHudText', 'You dont have x' ..pHowMuchCoke[1].input.. ' Coke5g On you.')
            end
        end
    else
        TriggerEvent('DoLongHudText', 'I need Cocaine not thin air bwo', 2)
    end
end)

-- Coke Run End

-- Weed Run

RegisterNetEvent('warp-illegalactivities:choose_weed')
AddEventHandler('warp-illegalactivities:choose_weed', function()
    if exports['warp-inventory']:hasEnoughOfItem('weedq', 1) then
        ChosenWeed = true
        SetNewWaypoint(861.96923828125,-479.61758422852,30.00439453125)
        TriggerEvent('warp-drugs:drop_weed_blip')
        TriggerEvent('warp-illegalactivities:create_weed_ped')
        TriggerEvent('phone:addJobNotify', 'You\'re GPS Has been updated.')
    else
        TriggerEvent('DoLongHudText', 'You dont got any weed to run', 2)
    end
end)

RegisterNetEvent('warp-drugs:drop_weed_blip')
AddEventHandler('warp-drugs:drop_weed_blip', function()
    WeedDropBlip = AddBlipForCoord(861.96923828125,-479.61758422852,30.00439453125)
    SetBlipSprite(WeedDropBlip, 469)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Weed Drop Location")
    EndTextCommandSetBlipName(WeedDropBlip)
end)

RegisterNetEvent('warp-drugs:do_drop')
AddEventHandler('warp-drugs:do_drop', function()
    TriggerEvent('warp-mdt:drugsale')
    local WeedPayment = math.random(150, 250)

    if exports['warp-inventory']:hasEnoughOfItem('weedq', 1) then
        local pHowMuchWeed = exports["warp-applications"]:KeyboardInput({
            header = "",
            rows = {
            {
                id = 0,
                txt = "Input How Much Weed Baggies You Want To Sell"
            }
            }
        })
        local pPaymentAmount = WeedPayment*pHowMuchWeed[1].input
        if pHowMuchWeed[1] ~= nil then
            if exports['warp-inventory']:hasEnoughOfItem('weedq', pHowMuchWeed[1].input) then
                if exports['warp-inventory']:hasEnoughOfItem('weedq', pHowMuchWeed[1].input) then
                    TriggerEvent('inventory:removeItem', 'weedq', pHowMuchWeed[1].input)
                    TriggerServerEvent('zyloz:payout', pPaymentAmount)
                    TriggerEvent('phone:addJobNotify', 'You sold '..pHowMuchWeed[1].input..'x Weed Q For $'..pPaymentAmount)
                    DeletePed(created_ped)
                    RemoveBlip(WeedDropBlip)
                    ChosenWeed = false
                end
            else
                TriggerEvent('DoLongHudText', 'You dont have x' ..pHowMuchWeed[1].input.. ' Weed Q On you.')
            end
        end
    else
        TriggerEvent('DoLongHudText', 'I need Weed Q\'s not thin air bwo', 2)
    end
end)

-- Weed Run End --

-- Meth Run --

RegisterNetEvent('warp-illegalactivities:choose_meth')
AddEventHandler('warp-illegalactivities:choose_meth', function()
    if exports['warp-inventory']:hasEnoughOfItem('methlabproduct', 1) then
        ChosenMeth = true
        SetNewWaypoint(-1584.9099121094,-838.73406982422,10.138427734375)
        TriggerEvent('warp-drugs:drop_meth_blip')
        TriggerEvent('warp-illegalactivities:create_meth_ped')
        TriggerEvent('phone:addJobNotify', 'You\'re GPS Has been updated.')
    else
        TriggerEvent('DoLongHudText', 'You dont got any Meth to run', 2)
    end
end)

RegisterNetEvent('warp-drugs:drop_meth_blip')
AddEventHandler('warp-drugs:drop_meth_blip', function()
    MethDropBlip = AddBlipForCoord(-1584.9099121094,-838.73406982422,10.138427734375)
    SetBlipSprite(MethDropBlip, 514)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Meth Drop Location")
    EndTextCommandSetBlipName(MethDropBlip)
end)

RegisterNetEvent('warp-drugs:do_drop_meth')
AddEventHandler('warp-drugs:do_drop_meth', function()
    TriggerEvent('warp-mdt:drugsale')
    local MethDropPayment = math.random(1500, 2000)

    if exports['warp-inventory']:hasEnoughOfItem('methlabproduct', 1) then
        local pHowMuchMeth = exports["warp-applications"]:KeyboardInput({
            header = "",
            rows = {
            {
                id = 0,
                txt = "Input How Much Meth Batches You Want To Sell"
            }
            }
        })
        local pPaymentAmountMeth = MethDropPayment*pHowMuchMeth[1].input
        if pHowMuchMeth[1] ~= nil then
            if exports['warp-inventory']:hasEnoughOfItem('methlabproduct', pHowMuchMeth[1].input) then
                if exports['warp-inventory']:hasEnoughOfItem('methlabproduct', pHowMuchMeth[1].input) then
                    TriggerEvent('inventory:removeItem', 'methlabproduct', pHowMuchMeth[1].input)
                    TriggerServerEvent('zyloz:payout', pPaymentAmountMeth)
                    TriggerEvent('phone:addJobNotify', 'You sold '..pHowMuchMeth[1].input..'x Meth Baggies For $'..pPaymentAmountMeth)
                    DeletePed(created_ped)
                    RemoveBlip(MethDropBlip)
                    ChosenMeth = false
                end
            else
                TriggerEvent('DoLongHudText', 'You dont have x' ..pHowMuchMeth[1].input.. ' Meth Baggies On you.')
            end
        end
    else
        TriggerEvent('DoLongHudText', 'I need Meth not thin air bwo', 2)
    end
end)

-- Meth Run End --

-- Start Of Weed Interact --

-- Weed Ped --
exports["warp-polytarget"]:AddBoxZone("evan_weed_do_drop", vector3(862.07, -479.68, 30.01), 0.8, 0.8, {
    heading=0,
    --debugPoly=true,
    minZ=27.01,
    maxZ=31.01
})

exports["warp-interact"]:AddPeekEntryByPolyTarget("evan_weed_do_drop", {{
    event = "warp-drugs:do_drop",
    id = "evan_weed_do_drop",
    icon = "comment-dollar",
    label = "Sell",
    parameters = {},
}}, {
    distance = { radius = 2.5 },
    isEnabled = function()
        return ChosenWeed
    end,
});
-- End Weed Ped --

-- Start Coke Ped -- 

exports["warp-polytarget"]:AddBoxZone("evan_coke_do_drop", vector3(1533.38, 793.12, 77.51), 1, 1, {
    heading=330,
    --debugPoly=true,
    minZ=74.71,
    maxZ=78.71
})

exports["warp-interact"]:AddPeekEntryByPolyTarget("evan_coke_do_drop", {{
    event = "warp-drugs:do_drop_coke",
    id = "evan_coke_do_drop",
    icon = "comment-dollar",
    label = "Sell",
    parameters = {},
}}, {
    distance = { radius = 2.5 },
    isEnabled = function()
        return ChosenCoke
    end,
});

-- End Coke Ped --

-- Start Meth Ped -- 

exports["warp-polytarget"]:AddBoxZone("evan_meth_do_drop", vector3(-1584.65, -838.81, 9.96), 1.5, 1.3, {
    heading=320,
    --debugPoly=true,
    minZ=7.36,
    maxZ=11.36
})

exports["warp-interact"]:AddPeekEntryByPolyTarget("evan_meth_do_drop", {{
    event = "warp-drugs:do_drop_meth",
    id = "evan_meth_do_drop",
    icon = "comment-dollar",
    label = "Sell",
    parameters = {},
}}, {
    distance = { radius = 2.5 },
    isEnabled = function()
        return ChosenMeth
    end,
});

-- End Meth Ped --

-- End Of Weed Interact --

-- Start Of All Peds --

RegisterNetEvent('warp-illegalactivities:create_weed_ped')
AddEventHandler('warp-illegalactivities:create_weed_ped', function()
    modelHash = GetHashKey("csb_ramp_gang")
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(1)
    end
    created_ped = CreatePed(0, modelHash , 861.96923828125,-479.61758422852,30.00439453125  -1, true)
    FreezeEntityPosition(created_ped, true)
    SetEntityHeading(created_ped, 51.0)
    SetEntityInvincible(created_ped, true)
    SetBlockingOfNonTemporaryEvents(created_ped, true)
    TaskStartScenarioInPlace(created_ped, "WORLD_HUMAN_AA_SMOKE", 0, true)
end)

RegisterNetEvent('warp-illegalactivities:create_coke_ped')
AddEventHandler('warp-illegalactivities:create_coke_ped', function()
    modelHash = GetHashKey("g_m_importexport_01")
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(1)
    end
    created_ped = CreatePed(0, modelHash , 1533.4417724609,793.26593017578,77.487182617188  -1, true)
    FreezeEntityPosition(created_ped, true)
    SetEntityHeading(created_ped, 180.0)
    SetEntityInvincible(created_ped, true)
    SetBlockingOfNonTemporaryEvents(created_ped, true)
    TaskStartScenarioInPlace(created_ped, "WORLD_HUMAN_AA_SMOKE", 0, true)
end)

RegisterNetEvent('warp-illegalactivities:create_meth_ped')
AddEventHandler('warp-illegalactivities:create_meth_ped', function()
    modelHash = GetHashKey("g_m_importexport_01")
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(1)
    end
    created_ped = CreatePed(0, modelHash , -1584.9099121094,-838.73406982422,10.138427734375  -1, true)
    FreezeEntityPosition(created_ped, true)
    SetEntityHeading(created_ped, 45.0)
    SetEntityInvincible(created_ped, true)
    SetBlockingOfNonTemporaryEvents(created_ped, true)
    TaskStartScenarioInPlace(created_ped, "WORLD_HUMAN_AA_SMOKE", 0, true)
end)

-- End Of Peds --