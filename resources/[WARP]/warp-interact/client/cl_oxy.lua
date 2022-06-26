--#############--
--## VOID RP ##--
--#############--

-- MADE BY EVAN --

local Entries = {}

-- Sell Locations Start --

local HeadingToEastJoshua = false
local HeadingToNorthRockford = false
local HeadingToClinton = false

-- Sell Locations End

-- Start Of Pickup Locations --

local LocationPickup1 = false
local LocationPickup2 = false
local LocationPickup3  = false

-- End Of Pickup Locations --

-- Random Locals --

local OnTheWayToDropoffLocation1 = false
local CanCollectPackageLocation1 = true
local CanSell1 = false

local OnTheWayToDropoffLocation2 = false
local CanCollectPackageLocation2 = true
local CanSell2 = false

local OnTheWayToDropoffLocation3 = false
local CanCollectPackageLocation3 = true
local CanSell3 = false

-- End Of Random Locals --

-- Start Of Check For Dirty Money -- 

RegisterNetEvent('warp-illegalactivities:check_for_illegal_cash')
AddEventHandler('warp-illegalactivities:check_for_illegal_cash', function()
    if exports['warp-inventory']:hasEnoughOfItem('cashroll', 5) then
        TriggerServerEvent('warp-illegalactivities:oxy_payment', math.random(150, 250))
        TriggerEvent('inventory:removeItem', 'cashroll', 5)
    elseif exports['warp-inventory']:hasEnoughOfItem('band', 5) then
        TriggerEvent('inventory:removeItem', 'band', 5)
        TriggerServerEvent('warp-illegalactivities:oxy_payment', math.random(456, 786))
    end
end)

-- Shibiz n Dat -- 

RegisterNetEvent('warp-illegalactivities:location')
AddEventHandler('warp-illegalactivities:location', function()
    if EvanOxyLocation1 then
        TriggerEvent('warp-illegalactivities:sell_package')
        print('[EVAN 1] - VOID RP OXY RUNS - MADE BY Evan')
        TriggerEvent('warp-illegalactivities:call_cops')
    elseif EvanOxyLocation2 then
        print('[EVAN 2] - VOID RP OXY RUNS - MADE BY Evan')
        TriggerEvent('warp-illegalactivities:sell_package_location2')
        TriggerEvent('warp-illegalactivities:call_cops')
    elseif EvanOxyLocation3 then
        print('[EVAN 3] - VOID RP OXY RUNS - MADE BY Evan')
        TriggerEvent('warp-illegalactivities:sell_package_location3')
        TriggerEvent('warp-illegalactivities:call_cops')
    end
end)

local VehicleModels = {
    [1] = 'feltzer',
    [2] = 'felon',
    [3] = 'blista',
    [4] = 'jackal',
    [5] = 'oracle2',
    [6] = 'buffalo',
    [7] = 'voodoo2',
    [8] = 'premier',
    [9] = 'washington',
    [10] = 'primo2'
}

local PedModels = {
    [1] = 'a_f_y_business_02',
    [2] = 'a_f_y_tourist_01',
    [3] = 'a_f_y_tourist_01',
    [4] = 'a_m_m_socenlat_01'
}

local StartedOxyRun = false

local LocationPickup3 = false

local EvanFirstLocalStarted = false

local PackagesCollected = 0
local PackagesToDrop = 0

RegisterNetEvent('warp-oxy:start_run')
AddEventHandler('warp-oxy:start_run', function()
    if not StartedOxyRun then
        if exports['warp-inventory']:hasEnoughOfItem('vpnxj', 1) then
            print('[DEBUG] User Started Oxyrun')
            TriggerEvent('phone:addJobNotify', 'Clocked In, check your GPS.')
            TriggerEvent('warp-oxyrun:get_packagelocation')
            StartedOxyRun = true
        else
            TriggerEvent('DoLongHudText', 'You need a VPN', 2)
        end
    else
        TriggerEvent('DoLongHudText', 'You\'re already on a oxy run', 2)
    end
end)

RegisterNetEvent('warp-oxy:clock_out')
AddEventHandler('warp-oxy:clock_out', function()
    if StartedOxyRun then
        TriggerEvent('phone:addJobNotify', 'Clocked Out.')
        StartedOxyRun = false
        PackagesCollected = 0
        PackagesToDrop = 0
    end
end)

-- Package Location --

RegisterNetEvent('warp-oxyrun:get_packagelocation')
AddEventHandler('warp-oxyrun:get_packagelocation', function()
    local PedLoc = math.random(1, 3)
    if PedLoc == 1 then
        print('LOCATION 1')
        LocationPickup1 = true
        TriggerEvent('warp-illegalactivities:create_location1_oxy_ped_and_blip')
    elseif PedLoc == 2 then
        print('LOCATION 2')
        LocationPickup2 = true
        TriggerEvent('warp-illegalactivities:create_location2_oxy_ped_and_blip')
    elseif PedLoc == 3 then
        print('LOCATION 3')
        LocationPickup3 = true
        TriggerEvent('warp-illegalactivities:create_location3_oxy_ped_and_blip')
    end
end)

RegisterNetEvent('warp-illegalactivities:call_cops')
AddEventHandler('warp-illegalactivities:call_cops', function()
    local EvanChance = math.random(1, 2)
    if EvanChance == 1 then
        TriggerEvent('warp-mdt:drugsale')
    elseif EvanChance == 2 then
        print('[warp] RND')
    end
end)

-- Package Location End --

-- Sell Location --

RegisterNetEvent('warp-illegalactivities:go_to_sell_location')
AddEventHandler('warp-illegalactivities:go_to_sell_location', function()
    local EvanOxySellLocations = math.random(1, 2)
    if EvanOxySellLocations == 1 then
        print('GO TO SELL LOCATION 1')
        EvanFirstLocalStarted = false
        HeadingToNorthRockford = true
        TriggerEvent('phone:addJobNotify', 'Head over to North Rockford Drive')

        OxyLocationSell1 = AddBlipForCoord(-1945.648, 324.43765, 89.591361)
        SetBlipSprite(OxyLocationSell1, 473)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Oxy Sales Location")
        EndTextCommandSetBlipName(OxyLocationSell1)
        SetBlipRoute(OxyLocationSell1, true)
        SetBlipRouteColour(OxyLocationSell1, 3)
    elseif EvanOxySellLocations == 2 then
        print('GO TO SELL LOCATION 2')
        EvanFirstLocalStarted = false
        HeadingToEastJoshua = true
        TriggerEvent('phone:addJobNotify', 'Head over to Seaview Road')
        EvanFirstLocalStarted = false

        OxyLocationSell2 = AddBlipForCoord(1809.3687, 4581.3452, 36.135059)
        SetBlipSprite(OxyLocationSell2, 473)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Oxy Sales Location")
        EndTextCommandSetBlipName(OxyLocationSell2)
        SetBlipRoute(OxyLocationSell2, true)
        SetBlipRouteColour(OxyLocationSell2, 3)
    end
end)

-- Sell Location End --

-- Location 1 --

EvanOxyLocation1 = false

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("evan_oxy_location_inside_1", vector3(-1931.29, 327.56, 89.75), 25, 40, {
        name="evan_oxy_location_inside_1",
        heading=10,
    })
end)

RegisterNetEvent('warp-polyzone:enter')
AddEventHandler('warp-polyzone:enter', function(name)
    if name == "evan_oxy_location_inside_1" then
        EvanOxyLocation1 = true     
        if EvanOxyLocation1 and not EvanFirstLocalStarted and HeadingToNorthRockford then
            print('SENDING FIRST LOCAL TO LOCATION | Location 1')
            OnTheWayToDropoffLocation1 = true
            TriggerEvent('warp-illegalactivities:ped_to_sellpoint1')
        else
            print('NOT ON THE RUN 1')
        end
    end
end)

RegisterNetEvent('warp-polyzone:exit')
AddEventHandler('warp-polyzone:exit', function(name)
    if name == "evan_oxy_location_inside_1" then
        EvanOxyLocation1 = false
    end
end)

RegisterNetEvent('warp-illegalactivities:evan_oxyrun:getpackages_1')
AddEventHandler('warp-illegalactivities:evan_oxyrun:getpackages_1', function()
    if not exports['warp-inventory']:hasEnoughOfItem('darkmarketpackage', 1) then
        if CanCollectPackageLocation1 then
            TriggerEvent('player:receiveItem', 'darkmarketpackage', 1)
            CanCollectPackageLocation1 = false
            PackagesCollected = PackagesCollected + 1
            RemoveBlip(OxyLocation1Collect)
            TriggerEvent('phone:addJobNotify', '('..PackagesCollected..'/5) Packages Collected')
            if PackagesCollected == 5 then
                Citizen.Wait(14000)
                DeleteEntity(created_ped)
                LocationPickup1 = false
                PackagesCollected = 0
                TriggerEvent('warp-illegalactivities:go_to_sell_location')
                OnTheWayToDropoffLocation1 = true
            else
                Citizen.Wait(10000)
                CanCollectPackageLocation1 = true
            end
        else
            TriggerEvent('DoLongHudText', 'You feel a little tired, wait a few seconds', 2)
        end
    elseif exports['warp-inventory']:hasEnoughOfItem('darkmarketpackage', 1) then
        TriggerEvent('DoLongHudText', 'You aint quite learnt how to multitask yet', 2)
    end
end)

RegisterNetEvent('warp-illegalactivities:create_location1_oxy_ped_and_blip')
AddEventHandler('warp-illegalactivities:create_location1_oxy_ped_and_blip', function()
    modelHash = GetHashKey("csb_ramp_gang")
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(1)
    end
    created_ped = CreatePed(0, modelHash , 558.92376, -1037.308, 31.779758 -1, true)
    FreezeEntityPosition(created_ped, true)
    SetEntityHeading(created_ped, 89.084686)
    SetEntityInvincible(created_ped, true)
    SetBlockingOfNonTemporaryEvents(created_ped, true)
    TaskStartScenarioInPlace(created_ped, "WORLD_HUMAN_AA_SMOKE", 0, true)

    OxyLocation1Collect = AddBlipForCoord(557.91583, -1025.197, 31.534187)
    SetBlipSprite(OxyLocation1Collect, 524)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Oxy Collect Location")
    EndTextCommandSetBlipName(OxyLocation1Collect)
    SetBlipRoute(OxyLocation1Collect, true)
    SetBlipRouteColour(OxyLocation1Collect, 3)
end)

exports["warp-polytarget"]:AddBoxZone("evan_oxyruns_ped_1", vector3(559.0, -1037.3, 31.34), 0.8, 0.8, {
    heading=0,
    minZ=28.74,
    maxZ=32.74
})

exports["warp-interact"]:AddPeekEntryByPolyTarget("evan_oxyruns_ped_1", {{
    event = "warp-illegalactivities:evan_oxyrun:getpackages_1",
    id = "evan_oxyruns_ped_1",
    icon = "circle",
    label = "Collect Package",
    parameters = {},
}}, {
    distance = { radius = 2.5 },
    isEnabled = function()
        return LocationPickup1
    end,
});

RegisterNetEvent('warp-illegalactivities:sell_package')
AddEventHandler('warp-illegalactivities:sell_package', function()
    local OxyChance = math.random(1, 2)

    if OnTheWayToDropoffLocation1 then
        if CanSell2 or CanSell3 or CanSell1 then
            if exports['warp-inventory']:hasEnoughOfItem('darkmarketpackage', 1) then
                HeadingToNorthRockford = false
                TriggerEvent('inventory:removeItem', 'darkmarketpackage', 1)
                TriggerServerEvent('warp-illegalactivities:oxy_payment', math.random(500, 1150))
                TriggerEvent('player:receiveItem', 'oxy', math.random(1, 5))
                TriggerEvent('warp-illegalactivities:check_for_illegal_cash')
                PackagesToDrop = PackagesToDrop + 1 
                TriggerEvent('phone:addJobNotify', '('..PackagesToDrop..'/5) Packages Dropped Off.')
                RemoveBlip(OxyLocationSell1)
                print(Vehicle)

                DeleteEntity(veh)
                DeleteEntity(driverPed)
                CanSell1 = false
                Citizen.Wait(7000)
                print('PASSED')
                TriggerEvent('warp-illegalactivities:ped_to_sellpoint1')
            else
                TriggerEvent('DoLongHudText', 'Well I need one of those packages to buy ...', 2)
            end
        else
            TriggerEvent('DoLongHudText', 'This is not your customer', 2)
        end
    end
end)

RegisterNetEvent('warp-illegalactivities:ped_to_sellpoint1')
AddEventHandler('warp-illegalactivities:ped_to_sellpoint1', function()
    EvanFirstLocalStarted = true

    local radius = 1.00
    local x = -1971.042 + math.random(-radius,radius)
    local y = 272.2846 + math.random(-radius,radius)
    local z = 87.226432 + math.random(-radius,radius)

    local model = VehicleModels[math.random(10)]
    local vehicaleHash = GetHashKey(model)
    RequestModel(vehicaleHash)
    while not HasModelLoaded(vehicaleHash) do
        Wait(1)
    end

    local npcped = PedModels[math.random(4)]
    local npcpedhash = GetHashKey(npcped)
    RequestModel(npcpedhash)
    while not HasModelLoaded(npcpedhash) do
        Wait(1)
    end

    if PackagesToDrop == 5 then
        print(PackagesToDrop)
        PackagesToDrop = 0
        print(PackagesToDrop)
        Citizen.Wait(13000)
        TriggerEvent('warp-phone:job_done_noti')
    else
        veh = CreateVehicle(vehicaleHash, x, y, z, 0.0, true, false)
        driverPed = CreatePed(0, npcpedhash, x+2, y+2, z+1, 0, true, false)
        print(x, y, z)
        TaskWarpPedIntoVehicle(driverPed, veh, -1)
        SetModelAsNoLongerNeeded(npcpedhash)
        SetBlockingOfNonTemporaryEvents(driverPed, true)
        SetModelAsNoLongerNeeded(model)

        Citizen.Wait(5000)
        TaskVehicleDriveToCoord(driverPed, veh, -1945.648, 324.43765, 89.591361, 10.0, false, model, 8388614, 2.0, 0)
        CanSell2 = true
        print(CanSell2)
    end
end)

-- End Location 1 Shit --

-- Location 2 --

EvanOxyLocation2 = false

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("evan_oxy_location_inside_2", vector3(1807.56, 4577.12, 36.14), 25, 30, {
        name="evan_oxy_location_inside_2",
        heading=0,
    })
end)

RegisterNetEvent('warp-polyzone:enter')
AddEventHandler('warp-polyzone:enter', function(name)
    if name == "evan_oxy_location_inside_2" then
        EvanOxyLocation2 = true     
        if EvanOxyLocation2 and not EvanFirstLocalStarted and HeadingToEastJoshua then
            print('SENDING FIRST LOCAL TO LOCATION | Location 2')
            OnTheWayToDropoffLocation2 = true
            TriggerEvent('warp-illegalactivities:ped_to_sellpoint2')
        else
            print('NOT ON THE RUN 2')
        end
    end
end)

RegisterNetEvent('warp-polyzone:exit')
AddEventHandler('warp-polyzone:exit', function(name)
    if name == "evan_oxy_location_inside_2" then
        EvanOxyLocation2 = false
    end
end)

RegisterNetEvent('warp-illegalactivities:evan_oxyrun:getpackages_2')
AddEventHandler('warp-illegalactivities:evan_oxyrun:getpackages_2', function()
    if not exports['warp-inventory']:hasEnoughOfItem('darkmarketpackage', 1) then
        if CanCollectPackageLocation2 then
            TriggerEvent('player:receiveItem', 'darkmarketpackage', 1)
            CanCollectPackageLocation2 = false
            PackagesCollected = PackagesCollected + 1
            RemoveBlip(OxyLocation2Collect)
            TriggerEvent('phone:addJobNotify', '('..PackagesCollected..'/5) Packages Collected')
            if PackagesCollected == 5 then
                Citizen.Wait(14000)
                DeleteEntity(ped_created)
                LocationPickup2 = false
                PackagesCollected = 0
                TriggerEvent('warp-illegalactivities:go_to_sell_location')
                OnTheWayToDropoffLocation2 = true
            else
                Citizen.Wait(10000)
                CanCollectPackageLocation2 = true
            end
        else
            TriggerEvent('DoLongHudText', 'You feel a little tired, wait a few seconds', 2)
        end
    elseif exports['warp-inventory']:hasEnoughOfItem('darkmarketpackage', 1) then
        TriggerEvent('DoLongHudText', 'You aint quite learnt how to multitask yet', 2)
    end
end)

-- Create Ped For Sale Start --

RegisterNetEvent('warp-illegalactivities:create_location2_oxy_ped_and_blip')
AddEventHandler('warp-illegalactivities:create_location2_oxy_ped_and_blip', function()
    modelHash = GetHashKey("csb_ramp_gang")
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(1)
    end
    ped_created = CreatePed(0, modelHash , -1024.586, 2892.2041, 6.3962297 -1, true)
    FreezeEntityPosition(ped_created, true)
    SetEntityHeading(ped_created, 276.82211)
    SetEntityInvincible(ped_created, true)
    SetBlockingOfNonTemporaryEvents(ped_created, true)
    TaskStartScenarioInPlace(ped_created, "WORLD_HUMAN_AA_SMOKE", 0, true)

    OxyLocation2Collect = AddBlipForCoord(-1024.586, 2892.2041, 6.3962297)
    SetBlipSprite(OxyLocation2Collect, 524)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Oxy Collect Location")
    EndTextCommandSetBlipName(OxyLocation2Collect)
    SetBlipRoute(OxyLocation2Collect, true)
    SetBlipRouteColour(OxyLocation2Collect, 3)
end)

exports["warp-polytarget"]:AddBoxZone("evan_oxyruns_ped_2", vector3(-1024.59, 2892.2, 6.4), 0.8, 0.8, {
    heading=0,
    --debugPoly=true,
    minZ=3.4,
    maxZ=7.4
})

exports["warp-interact"]:AddPeekEntryByPolyTarget("evan_oxyruns_ped_2", {{
    event = "warp-illegalactivities:evan_oxyrun:getpackages_2",
    id = "evan_oxyruns_ped_2",
    icon = "circle",
    label = "Collect Package",
    parameters = {},
}}, {
    distance = { radius = 2.5 },
    isEnabled = function()
        return LocationPickup2
    end,
});

-- Create Ped For Sale End --

-- Sell Location Start --

RegisterNetEvent('warp-illegalactivities:sell_package_location2')
AddEventHandler('warp-illegalactivities:sell_package_location2', function()
    local OxyChance = math.random(1, 2)

    if OnTheWayToDropoffLocation2 then
        if CanSell2 or CanSell3 or CanSell1 then
            if exports['warp-inventory']:hasEnoughOfItem('darkmarketpackage', 1) then
                HeadingToEastJoshua = false
                TriggerEvent('inventory:removeItem', 'darkmarketpackage', 1)
                TriggerServerEvent('warp-illegalactivities:oxy_payment', math.random(500, 1150))
                TriggerEvent('player:receiveItem', 'oxy', math.random(1, 5))
                TriggerEvent('warp-illegalactivities:check_for_illegal_cash')
                PackagesToDrop = PackagesToDrop + 1 
                TriggerEvent('phone:addJobNotify', '('..PackagesToDrop..'/5) Packages Dropped Off.')
                RemoveBlip(OxyLocationSell2)
                
                DeleteEntity(veh)
                DeleteEntity(driverPed)
                CanSell2 = false
                Citizen.Wait(7000)
                TriggerEvent('warp-illegalactivities:ped_to_sellpoint2')
            else
                TriggerEvent('DoLongHudText', 'Well I need one of those packages to buy ...', 2)
            end
        else
            TriggerEvent('DoLongHudText', 'This is not your customer', 2)
        end
    end
end)

RegisterNetEvent('warp-illegalactivities:ped_to_sellpoint2')
AddEventHandler('warp-illegalactivities:ped_to_sellpoint2', function()
    EvanFirstLocalStarted = true

    local radius = 1.00
    local x = 1702.3515 + math.random(-radius,radius)
    local y = 4648.0332 + math.random(-radius,radius)
    local z = 43.573268 + math.random(-radius,radius)

    local model = VehicleModels[math.random(10)]
    local vehicaleHash = GetHashKey(model)
    RequestModel(vehicaleHash)
    while not HasModelLoaded(vehicaleHash) do
        Wait(1)
    end

    local npcped = PedModels[math.random(4)]
    local npcpedhash = GetHashKey(npcped)
    RequestModel(npcpedhash)
    while not HasModelLoaded(npcpedhash) do
        Wait(1)
    end

    if PackagesToDrop == 5 then
        print(PackagesToDrop)
        PackagesToDrop = 0
        print(PackagesToDrop)
        Citizen.Wait(13000)
        TriggerEvent('warp-phone:job_done_noti')
    else
        veh = CreateVehicle(vehicaleHash, x, y, z, 0.0, true, false)
        driverPed = CreatePed(0, npcpedhash, x+2, y+2, z+1, 0, true, false)
        print(x, y, z)
        TaskWarpPedIntoVehicle(driverPed, veh, -1)
        SetModelAsNoLongerNeeded(npcpedhash)
        SetBlockingOfNonTemporaryEvents(driverPed, true)
        SetModelAsNoLongerNeeded(model)

        Citizen.Wait(5000)
        TaskVehicleDriveToCoord(driverPed, veh, 1806.6345, 4581.7597, 36.228626, 10.0, false, model, 8388614, 2.0, 0)
        CanSell2 = true
        print(CanSell2)
    end
end)

-- Sell Location End --

-- End Location 2 Shit --

-- Location 3 --

EvanOxyLocation3 = false

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("evan_oxy_location_inside_3", vector3(673.85, 197.74, 94.65), 25, 40.4, {
        name="evan_oxy_location_inside_3",
        heading=345,
    })
end)

RegisterNetEvent('warp-polyzone:enter')
AddEventHandler('warp-polyzone:enter', function(name)
    if name == "evan_oxy_location_inside_3" then
        EvanOxyLocation3 = true     
        if EvanOxyLocation3 and not EvanFirstLocalStarted and HeadingToClinton then
            print('SENDING FIRST LOCAL TO LOCATION | Location 3')
            CanCollectPackageLocation3 = true
            TriggerEvent('warp-illegalactivities:ped_to_sellpoint3')
        else
            print('NOT ON THE RUN 3')
        end
    end
end)

RegisterNetEvent('warp-polyzone:exit')
AddEventHandler('warp-polyzone:exit', function(name)
    if name == "evan_oxy_location_inside_3" then
        EvanOxyLocation3 = false
    end
end)

RegisterNetEvent('warp-illegalactivities:evan_oxyrun:getpackages_3')
AddEventHandler('warp-illegalactivities:evan_oxyrun:getpackages_3', function()
    if not exports['warp-inventory']:hasEnoughOfItem('darkmarketpackage', 1) then
        if CanCollectPackageLocation3 then
            TriggerEvent('player:receiveItem', 'darkmarketpackage', 1)
            CanCollectPackageLocation3 = false
            PackagesCollected = PackagesCollected + 1
            RemoveBlip(OxyLocation3Collect)
            TriggerEvent('phone:addJobNotify', '('..PackagesCollected..'/5) Packages Collected')
            if PackagesCollected == 5 then
                Citizen.Wait(14000)
                DeleteEntity(evan_ped_dog_innit)
                LocationPickup3 = false
                PackagesCollected = 0
                TriggerEvent('warp-illegalactivities:go_to_sell_location')
                CanCollectPackageLocation3 = true
            else
                Citizen.Wait(10000)
                CanCollectPackageLocation3 = true
            end
        else
            TriggerEvent('DoLongHudText', 'You feel a little tired, wait a few seconds', 2)
        end
    elseif exports['warp-inventory']:hasEnoughOfItem('darkmarketpackage', 1) then
        TriggerEvent('DoLongHudText', 'You aint quite learnt how to multitask yet', 2)
    end
end)

-- Create Ped For Sale Start --

RegisterNetEvent('warp-illegalactivities:create_location3_oxy_ped_and_blip')
AddEventHandler('warp-illegalactivities:create_location3_oxy_ped_and_blip', function()
    modelHash = GetHashKey("csb_ramp_gang")
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(1)
    end
    evan_ped_dog_innit = CreatePed(0, modelHash , 1161.2382, -1383.723, 34.740676 -1, true)
    FreezeEntityPosition(evan_ped_dog_innit, true)
    SetEntityHeading(evan_ped_dog_innit, 355.30395)
    SetEntityInvincible(evan_ped_dog_innit, true)
    SetBlockingOfNonTemporaryEvents(evan_ped_dog_innit, true)
    TaskStartScenarioInPlace(evan_ped_dog_innit, "WORLD_HUMAN_AA_SMOKE", 0, true)

    OxyLocation3Collect = AddBlipForCoord(1161.2382, -1383.723, 34.740676)
    SetBlipSprite(OxyLocation3Collect, 524)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Oxy Collect Location")
    EndTextCommandSetBlipName(OxyLocation3Collect)
    SetBlipRoute(OxyLocation3Collect, true)
    SetBlipRouteColour(OxyLocation3Collect, 3)
end)

exports["warp-polytarget"]:AddBoxZone("evan_oxyruns_ped_3", vector3(1161.24, -1383.72, 34.74), 0.8, 0.8, {
    heading=0,
    --debugPoly=true,
    minZ=31.74,
    maxZ=35.74
})

exports["warp-interact"]:AddPeekEntryByPolyTarget("evan_oxyruns_ped_3", {{
    event = "warp-illegalactivities:evan_oxyrun:getpackages_3",
    id = "evan_oxyruns_ped_3",
    icon = "circle",
    label = "Collect Package",
    parameters = {},
}}, {
    distance = { radius = 2.5 },
    isEnabled = function()
        return LocationPickup3
    end,
});

-- Create Ped For Sale End --

-- Sell Location Start --

RegisterNetEvent('warp-illegalactivities:sell_package_location3')
AddEventHandler('warp-illegalactivities:sell_package_location3', function()
    local OxyChance = math.random(1, 2)

    if CanCollectPackageLocation3 then
        if CanSell2 or CanSell3 or CanSell1 then
            if exports['warp-inventory']:hasEnoughOfItem('darkmarketpackage', 1) then
                HeadingToClinton = false
                TriggerEvent('inventory:removeItem', 'darkmarketpackage', 1)
                TriggerServerEvent('warp-illegalactivities:oxy_payment', math.random(500, 1150))
                TriggerEvent('player:receiveItem', 'oxy', math.random(1, 5))
                TriggerEvent('warp-illegalactivities:check_for_illegal_cash')
                PackagesToDrop = PackagesToDrop + 1 
                TriggerEvent('phone:addJobNotify', '('..PackagesToDrop..'/5) Packages Dropped Off.')
                RemoveBlip(OxyLocationSell3)
                
                DeleteEntity(veh)
                DeleteEntity(driverPed)
                CanSell3 = false
                Citizen.Wait(7000)
                TriggerEvent('warp-illegalactivities:ped_to_sellpoint3')
            else
                TriggerEvent('DoLongHudText', 'Well I need one of those packages to buy ...', 2)
            end
        else
            TriggerEvent('DoLongHudText', 'This is not your customer', 2)
        end
    end
end)

RegisterNetEvent('warp-illegalactivities:ped_to_sellpoint3')
AddEventHandler('warp-illegalactivities:ped_to_sellpoint3', function()
    EvanFirstLocalStarted = true

    local radius = 1.00
    local x = 586.74444 + math.random(-radius,radius)
    local y = 268.70654 + math.random(-radius,radius)
    local z = 102.95005 + math.random(-radius,radius)

    local model = VehicleModels[math.random(10)]
    local vehicaleHash = GetHashKey(model)
    RequestModel(vehicaleHash)
    while not HasModelLoaded(vehicaleHash) do
        Wait(1)
    end

    local npcped = PedModels[math.random(4)]
    local npcpedhash = GetHashKey(npcped)
    RequestModel(npcpedhash)
    while not HasModelLoaded(npcpedhash) do
        Wait(1)
    end

    if PackagesToDrop == 5 then
        print(PackagesToDrop)
        PackagesToDrop = 0
        print(PackagesToDrop)
        Citizen.Wait(13000)
        TriggerEvent('warp-phone:job_done_noti')
    else
        veh = CreateVehicle(vehicaleHash, x, y, z, 0.0, true, false)
        driverPed = CreatePed(0, npcpedhash, x+2, y+2, z+1, 0, true, false)
        print(x, y, z)
        TaskWarpPedIntoVehicle(driverPed, veh, -1)
        SetModelAsNoLongerNeeded(npcpedhash)
        SetBlockingOfNonTemporaryEvents(driverPed, true)
        SetModelAsNoLongerNeeded(model)

        Citizen.Wait(5000)
        TaskVehicleDriveToCoord(driverPed, veh, 669.72314, 203.28317, 94.130302, 10.0, false, model, 8388614, 2.0, 0)
        CanSell3 = true
        print(CanSell3)
    end
end)

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "handoff_package",
            label = "Handoff Package",
            icon = "hand-holding",    
            event = "warp-illegalactivities:location",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 1.8 },
        isEnabled = function(pEntity, pContext)
            return CanSell3 or CanSell2 or CanSell1
        end
    }
}

-- Sell Location End --

-- End Location 3 Shit --

Citizen.CreateThread(function()
    for _, entry in ipairs(Entries) do
        if entry.type == 'flag' then
            AddPeekEntryByFlag(entry.group, entry.data, entry.options)
        elseif entry.type == 'model' then
            AddPeekEntryByModel(entry.group, entry.data, entry.options)
        elseif entry.type == 'entity' then
            AddPeekEntryByEntityType(entry.group, entry.data, entry.options)
        elseif entry.type == 'polytarget' then
            AddPeekEntryByPolyTarget(entry.group, entry.data, entry.options)
        end
    end
end)

Citizen.CreateThread(function()
    PedOxy()
end)

function PedOxy()
    modelHash = GetHashKey("a_m_m_hillbilly_01")
	RequestModel(modelHash)
	while not HasModelLoaded(modelHash) do
		Wait(1)
	end
	created_ped = CreatePed(0, modelHash , -1564.48, -441.2231, 36.882148  -1, true)
	FreezeEntityPosition(created_ped, true)
	SetEntityHeading(created_ped, 109.17327)
	SetEntityInvincible(created_ped, true)
	SetBlockingOfNonTemporaryEvents(created_ped, true)
end

exports["warp-polytarget"]:AddBoxZone("evan_oxyruns_clockin", vector3(-1564.46, -441.2, 36.81), 0.8, 0.8, {
    heading=20,
    --debugPoly=true,
    minZ=33.81,
    maxZ=37.81
})

exports["warp-interact"]:AddPeekEntryByPolyTarget("evan_oxyruns_clockin", {
    {
        event = "warp-oxy:start_run",
        id = "evan_oxyruns_clockin",
        icon = "circle",
        label = "Clock In",
        parameters = {},
    },
    {
        event = "warp-oxy:clock_out",
        id = "evan_oxyruns_clockout",
        icon = "circle",
        label = "Clock Out",
        parameters = {},
    }
}, {
    distance = { radius = 2.5 },
});