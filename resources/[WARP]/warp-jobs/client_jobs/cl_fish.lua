local CaughtFishAmount = 20

-- warp RP

--//Fishing Clockin and location

RegisterNetEvent('warp-fishing:start')
AddEventHandler('warp-fishing:start', function()
    if exports['warp-inventory']:hasEnoughOfItem('fishingrod', 1) then
        TriggerEvent('DoLongHudText', 'Select A Zone', 1)
        TriggerEvent('warp-civjobs-fishing:start')
    else
        TriggerEvent('DoLongHudText', 'Looks like your not equip purchase this spare rod of mine and try again if you would like to fish.', 2)
        TriggerEvent('warp-jobs:fishing_rod_buy')
    end
end)

RegisterNetEvent('warp-fishing:stop')
AddEventHandler('warp-fishing:stop', function()
    CaughtFishAmount = 20
    fishinglocation1active = false
    fishinglocation2active = false
    fishinglocation3active = false
    fishinglocation4active = false
    fishinglocation5active = false
    TriggerEvent('DoLongHudText', 'Clocked Out', 1)
end)

--//Start fishing with rod

RegisterNetEvent('warp-fishing:start-fishing')
AddEventHandler('warp-fishing:start-fishing', function()
    if poleTimer == 0 and fishinglocation1active or fishinglocation2active or fishinglocation3active or fishinglocation4active or fishinglocation5active then 
        if CaughtFishAmount == 20 then
            SetNewWaypoint(-335.38021850586, 6106.0219726562, 31.436645507812)
            TriggerEvent('DoLongHudText', 'Return to the start', 2)
            fishinglocation1active = false
            fishinglocation2active = false
            fishinglocation3active = false
            fishinglocation4active = false
            fishinglocation5active = false
        else 
            TryToFish()
        end
    else
        TriggerEvent('DoLongHudText', 'Something went wrong', 2)
    end
end)

RegisterCommand('cba', function()
    CaughtFishAmount = 19
end)

DrawBusySpinner = function(text)
    SetLoadingPromptTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    ShowLoadingPrompt(3)
end

TryToFish = function()
    if IsPedSwimming(PlayerPedId()) then return TriggerEvent("DoLongHudText","You haven't quite learned how to multitask yet",2) end
    if IsPedInAnyVehicle(PlayerPedId()) then return TriggerEvent("DoLongHudText","Exit your vehicle first to start fishing!",2) end
    local waterValidated, castLocation = IsInWater()

    if waterValidated then
        local fishingRod = GenerateFishingRod(PlayerPedId())
        poleTimer = 5
        if baitTimer == 0 then
            CastBait(fishingRod, castLocation)
        end
    else
        TriggerEvent("DoLongHudText","You need to aim towards the fish!",2)
    end
end

GenerateFishingRod = function(ped)
    local pedPos = GetEntityCoords(ped)
    local fishingRodHash = `prop_fishing_rod_01`
    WaitForModel(fishingRodHash)
    rodHandle = CreateObject(fishingRodHash, pedPos, true)
    AttachEntityToEntity(rodHandle, ped, GetPedBoneIndex(ped, 18905), 0.1, 0.05, 0, 80.0, 120.0, 160.0, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(fishingRodHash)
    return rodHandle
end

WaitForModel = function(model)
    if not IsModelValid(model) then
        return
    end
    if not HasModelLoaded(model) then
        RequestModel(model)
    end
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end
end

PlayAnimation = function(ped, dict, anim, settings)
	if dict then
        Citizen.CreateThread(function()
            RequestAnimDict(dict)

            while not HasAnimDictLoaded(dict) do
                Citizen.Wait(100)
            end

            if settings == nil then
                TaskPlayAnim(ped, dict, anim, 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
            else 
                local speed = 1.0
                local speedMultiplier = -1.0
                local duration = 1.0
                local flag = 0
                local playbackRate = 0
                if settings["speed"] then
                    speed = settings["speed"]
                end

                if settings["speedMultiplier"] then
                    speedMultiplier = settings["speedMultiplier"]
                end

                if settings["duration"] then
                    duration = settings["duration"]
                end
                if settings["flag"] then
                    flag = settings["flag"]
                end
                if settings["playbackRate"] then

                    playbackRate = settings["playbackRate"]

                end
                TaskPlayAnim(ped, dict, anim, speed, speedMultiplier, duration, flag, playbackRate, 0, 0, 0)
            end
            RemoveAnimDict(dict)
		end)
	else
		TaskStartScenarioInPlace(ped, anim, 0, true)
	end
end

CastBait = function(rodHandle, castLocation)
    baitTimer = 5
    local startedCasting = GetGameTimer()
    Citizen.Wait(5)
    DisableControlAction(0, 311, true)
    DisableControlAction(0, 157, true)
    DisableControlAction(0, 158, true)
    DisableControlAction(0, 160, true)
    DisableControlAction(0, 164, true)
    if GetGameTimer() - startedCasting > 100 then
        TriggerEvent("DoLongHudText","You need to cast the bait",2)
        if DoesEntityExist(rodHandle) then
            DeleteEntity(rodHandle)
        end
    end
    PlayAnimation(PlayerPedId(), "mini@tennis", "forehand_ts_md_far", {
        ["flag"] = 48
    })
    while IsEntityPlayingAnim(PlayerPedId(), "mini@tennis", "forehand_ts_md_far", 3) do
        Citizen.Wait(0)
    end
    PlayAnimation(PlayerPedId(), "amb@world_human_stand_fishing@idle_a", "idle_c", {
        ["flag"] = 11
    })   
    local startedBaiting = GetGameTimer()
    local randomBait = math.random(10000, 30000)
    DrawBusySpinner("Waiting for a fish to bite...")
    DisableControlAction(0, 311, true)
    DisableControlAction(0, 157, true)
    DisableControlAction(0, 158, true)
    DisableControlAction(0, 160, true)
    DisableControlAction(0, 164, true)
    local interupted = false
    Citizen.Wait(1000)
    while GetGameTimer() - startedBaiting < randomBait do
        Citizen.Wait(5)
        if not IsEntityPlayingAnim(PlayerPedId(), "amb@world_human_stand_fishing@idle_a", "idle_c", 3) then
            interupted = true
            break
        end
    end
    RemoveLoadingPrompt()
    if interupted then
        ClearPedTasks(PlayerPedId())
        CastBait(rodHandle, castLocation)
        return
    end

    local caughtFish = TryToCatchFish()
    local amount = math.random(1, 3)
    ClearPedTasks(PlayerPedId())
    if caughtFish then
        if amount == 1 then
            CaughtFishAmount = CaughtFishAmount + 1
            TriggerEvent("player:receiveItem",'bass', math.random(1,1))
            TriggerEvent("DoLongHudText","You caught a bass!",1)
            TriggerEvent('phone:addJobNotify', "("..CaughtFishAmount.."/20) Test the waters")
            local shark = math.random(1, 1)
            if shark == 1 then 
                TriggerEvent("player:receiveItem",'shark', math.random(1,1))
                TriggerEvent("DoLongHudText","You caught a shark!",1)
            end
        elseif amount == 2 then
            CaughtFishAmount = CaughtFishAmount + 1
            TriggerEvent("player:receiveItem",'salmon', math.random(1,1))
            TriggerEvent("DoLongHudText","You caught a salmon!",1)
            TriggerEvent('phone:addJobNotify', "("..CaughtFishAmount.."/20) Test the waters")
            local crab = math.random(1, 1)
            if crab == 1 then 
                TriggerEvent("player:receiveItem",'crab', math.random(1,1))
                TriggerEvent("DoLongHudText","You caught a crab!",1)
            end
        elseif amount == 3 then
            CaughtFishAmount = CaughtFishAmount + 1
            TriggerEvent("player:receiveItem",'marlin', math.random(1,1))
            TriggerEvent("DoLongHudText","You caught a marlin!",1)
            TriggerEvent('phone:addJobNotify', "("..CaughtFishAmount.."/20) Test the waters")
            local shrimp = math.random(1, 1)
            if shrimp == 1 then 
                TriggerEvent("player:receiveItem",'shrimp', math.random(1,1))
                TriggerEvent("DoLongHudText","You caught a shrimp!",1)
            end
        end
    else
        TriggerEvent("DoLongHudText","The fish got loose!",2)
    end
	if DoesEntityExist(rodHandle) then
        DeleteEntity(rodHandle)
    end
end

TryToCatchFish = function()
    local minigameSprites = {
        ["powerDict"] = "custom",
        ["powerName"] = "bar",
        ["tennisDict"] = "tennis",
        ["tennisName"] = "swingmetergrad"
    }

    while not HasStreamedTextureDictLoaded(minigameSprites["powerDict"]) and not HasStreamedTextureDictLoaded(minigameSprites["tennisDict"]) do
        RequestStreamedTextureDict(minigameSprites["powerDict"], false)
        RequestStreamedTextureDict(minigameSprites["tennisDict"], false)
        Citizen.Wait(5)
    end
    local swingOffset = 0.1
    local swingReversed = false
    local DrawObject = function(x, y, width, height, red, green, blue)
        DrawRect(x + (width / 2.0), y + (height / 2.0), width, height, red, green, blue, 150)
    end
    while true do
        Citizen.Wait(5)
        TriggerEvent('DoLongHudText', 'Press [E] in the green area.')
        DrawSprite(minigameSprites["powerDict"], minigameSprites["powerName"], 0.5, 0.4, 0.01, 0.2, 0.0, 255, 0, 0, 255)
        DrawObject(0.49453227, 0.3, 0.010449, 0.03, 0, 255, 0)
        DrawSprite(minigameSprites["tennisDict"], minigameSprites["tennisName"], 0.5, 0.4 + swingOffset, 0.018, 0.002, 0.0, 0, 0, 0, 255)
        if swingReversed then
            swingOffset = swingOffset - 0.001
        else
            swingOffset = swingOffset + 0.001
        end
        if swingOffset > 0.1 then
            swingReversed = true
        elseif swingOffset < -0.1 then
            swingReversed = false
        end
        if IsControlJustPressed(0, 38) then
            swingOffset = 0 - swingOffset
            extraPower = (swingOffset + 0.1) * 250 + 1.0
            if extraPower >= 45 then
                return true
            else
                return false
            end
        end
    end
    SetStreamedTextureDictAsNoLongerNeeded(minigameSprites["powerDict"])
    SetStreamedTextureDictAsNoLongerNeeded(minigameSprites["tennisDict"])
end

poleTimer = 0
baitTimer = 0

function timerCount()
    if poleTimer ~= 0 then
        poleTimer = poleTimer - 1
    end
    if baitTimer ~= 0 then
        baitTimer = baitTimer - 1
    end
    SetTimeout(1000, timerCount)
end

local rodHandle = ""
timerCount()

IsInWater = function()
    local startedCheck = GetGameTimer()
    local ped = PlayerPedId()
    local pedPos = GetEntityCoords(ped)
    local forwardVector = GetEntityForwardVector(ped)
    local forwardPos = vector3(pedPos["x"] + forwardVector["x"] * 10, pedPos["y"] + forwardVector["y"] * 10, pedPos["z"])
    local fishHash = `a_c_fish`
    WaitForModel(fishHash)
    local waterHeight = GetWaterHeight(forwardPos["x"], forwardPos["y"], forwardPos["z"])
    local fishHandle = CreatePed(1, fishHash, forwardPos, 0.0, false)
    SetEntityAlpha(fishHandle, 0, true)
    while GetGameTimer() - startedCheck < 100 do
        Citizen.Wait(0)
    end
    RemoveLoadingPrompt()
    local fishInWater = IsEntityInWater(fishHandle)
    DeleteEntity(fishHandle)
    SetModelAsNoLongerNeeded(fishHash)
    return fishInWater, fishInWater and vector3(forwardPos["x"], forwardPos["y"], waterHeight) or false
end

--// Polyzones

warpZoneFishing1 = false
fishinglocation1active = false

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("fishing_zone_1", vector3(1641.0, 3881.09, 37.92), 250.6, 35.4, {
        name="fishing_zone_1",
        heading=305,
        debugPoly=false
    })
end)

RegisterNetEvent('warp-polyzone:enter')
AddEventHandler('warp-polyzone:enter', function(name)
    if name == "fishing_zone_1" and fishinglocation1active then
        warpZoneFishing1 = true     
    end
end)

RegisterNetEvent('warp-polyzone:exit')
AddEventHandler('warp-polyzone:exit', function(name)
    if name == "fishing_zone_1" and fishinglocation1active then
        warpZoneFishing1 = false  
    end
end)

-- Zone 2

warpZoneFishing2 = false
fishinglocation2active = false

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("fishing_zone_2", vector3(1306.75, 4252.16, 33.91), 75, 6.6, {
        name="fishing_zone_2",
        heading=350,
        --debugPoly=true,
        minZ=32.71,
        maxZ=36.71
    })
end)

RegisterNetEvent('warp-polyzone:enter')
AddEventHandler('warp-polyzone:enter', function(name)
    if name == "fishing_zone_2" and fishinglocation2active then
        warpZoneFishing2 = true     
    end
end)

RegisterNetEvent('warp-polyzone:exit')
AddEventHandler('warp-polyzone:exit', function(name)
    if name == "fishing_zone_2" and fishinglocation2active then
        warpZoneFishing2 = false  
    end
end)

-- Zone 3

warpZoneFishing3 = false
fishinglocation3active = false

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("fishing_zone_3", vector3(714.04, 4122.83, 35.78), 75, 67.0, {
        name="fishing_zone_3",
        heading=0,
        --debugPoly=true
    })
end)

RegisterNetEvent('warp-polyzone:enter')
AddEventHandler('warp-polyzone:enter', function(name)
    if name == "fishing_zone_3" and fishinglocation3active then
        warpZoneFishing3 = true     
    end
end)

RegisterNetEvent('warp-polyzone:exit')
AddEventHandler('warp-polyzone:exit', function(name)
    if name == "fishing_zone_3" and fishinglocation3active then
        warpZoneFishing3 = false  
    end
end)

-- Zone 4

warpZoneFishing4 = false
fishinglocation4active = false

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("fishing_zone_4", vector3(-187.49, 4139.61, 34.98), 75, 25.2, {
        name="fishing_zone_4",
        heading=320,
        --debugPoly=true
    })
end)

RegisterNetEvent('warp-polyzone:enter')
AddEventHandler('warp-polyzone:enter', function(name)
    if name == "fishing_zone_4" and fishinglocation4active then
        warpZoneFishing4 = true     
    end
end)

RegisterNetEvent('warp-polyzone:exit')
AddEventHandler('warp-polyzone:exit', function(name)
    if name == "fishing_zone_4" and fishinglocation4active then
        warpZoneFishing4 = false  
    end
end)

-- Zone 5

warpZoneFishing5 = false
fishinglocation5active = false

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("fishing_zone_5", vector3(397.93, 3624.15, 33.21), 75, 19.8, {
        name="fishing_zone_5",
        heading=265,
        -- debugPoly=true,
        minZ=31.21,
        maxZ=35.21
    })
end)

RegisterNetEvent('warp-polyzone:enter')
AddEventHandler('warp-polyzone:enter', function(name)
    if name == "fishing_zone_5" and fishinglocation5active then
        warpZoneFishing5 = true     
    end
end)

RegisterNetEvent('warp-polyzone:exit')
AddEventHandler('warp-polyzone:exit', function(name)
    if name == "fishing_zone_5" and fishinglocation5active then
        warpZoneFishing5 = false  
    end
end)

--// Sell Fish

RegisterNetEvent('warp-fishing:sell')
AddEventHandler('warp-fishing:sell', function()
    TriggerEvent('warp-context:sendMenu', {
        {
            id = 1,
            header = "Bass",
            txt = "Sell Bass",
            params = {
                event = "warp-jobs:fishing_sell:bass",
            }
        },
        {
            id = 2,
            header = "Salmon",
            txt = "Sell Salmon",
            params = {
                event = "warp-jobs:fishing_sell:salmon",
            }
        },
        {
            id = 3,
            header = "Crab",
            txt = "Sell Crab",
            params = {
                event = "warp-jobs:fishing_sell:crab",
            }
        },
        {
            id = 4,
            header = "Marlin",
            txt = "Sell Marlin",
            params = {
                event = "warp-jobs:fishing_sell:marlin",
            }
        },
        {
            id = 5,
            header = "Shrimp",
            txt = "Sell Shrimp",
            params = {
                event = "warp-jobs:fishing_sell:shrimp",
            }
        },
        {
            id = 6,
            header = "Shark",
            txt = "Sell Shark",
            params = {
                event = "warp-jobs:fishing_sell:shark",
            }
        },
    })
end)

-- Fishing Select Zones

RegisterNetEvent('warp-civjobs-fishing:start')
AddEventHandler('warp-civjobs-fishing:start', function()
    TriggerEvent('warp-context:sendMenu', {
        {
            id = 1,
            header = "Select Fishing Zone",
            txt = ""
        },
        {
            id = 2,
            header = "Fishing Zone 1",
            txt = "Sandy Shores",
            url = "https://cdn.discordapp.com/attachments/901123512503267349/918934982393737246/unknown.png",
            params = {
                event = "warp-fishing:select_zone_1"
            }
        },
        {
            id = 3,
            header = "Fishing Zone 2",
            txt = "Sandy Shores",
            url = "https://cdn.discordapp.com/attachments/878754358060257320/918936121973563463/unknown.png",
            params = {
                event = "warp-fishing:select_zone_2"
            }
        },
        {
            id = 4,
            header = "Fishing Zone 3",
            txt = "Sandy Shores",
            url = "https://cdn.discordapp.com/attachments/901123512503267349/918937340439822416/unknown.png",
            params = {
                event = "warp-fishing:select_zone_3"
            }
        },
        {
            id = 5,
            header = "Fishing Zone 4",
            txt = "Sandy Shores",
            url = "https://cdn.discordapp.com/attachments/901123512503267349/918937816136831046/unknown.png",
            params = {
                event = "warp-fishing:select_zone_4"
            }
        },
        {
            id = 6,
            header = "Fishing Zone 5",
            txt = "Sandy Shores",
            url = "https://cdn.discordapp.com/attachments/918937429422010400/918939159035531304/unknown.png",
            params = {
                event = "warp-fishing:select_zone_5"
            }
        },
    })
end)

RegisterNetEvent('warp-jobs:fishing_rod_buy')
AddEventHandler('warp-jobs:fishing_rod_buy', function()
    TriggerEvent('warp-context:sendMenu', {
        {
            id = 1,
            header = "Not ready for this shit, its your lucky day",
            txt = ""
        },
        {
            id = 2,
            header = "Fishing Rod",
            txt = "Heres a spare rod of mine, Ill need $100 tho !",
            params = {
                event = "warp-fishing:buy_rod"
            }
        },
    })
end)

RegisterNetEvent('warp-fishing:buy_rod')
AddEventHandler('warp-fishing:buy_rod', function()
    TriggerServerEvent('warp-fishing:attempt_buy_rod')
end)

RegisterNetEvent('warp-fishing:select_zone_1')
AddEventHandler('warp-fishing:select_zone_1', function()
    CaughtFishAmount = 0
    fishinglocation1active = true
    SetNewWaypoint(1587.6922607422, 3841.8198242188)
    TriggerEvent('DoLongHudText', 'Your GPS was updated go to the area and fish', 1)
end)

RegisterNetEvent('warp-fishing:select_zone_2')
AddEventHandler('warp-fishing:select_zone_2', function()
    CaughtFishAmount = 0
    fishinglocation2active = true
    SetNewWaypoint(1311.7054443359, 4279.0419921875)
    TriggerEvent('DoLongHudText', 'Your GPS was updated go to the area and fish', 1)
end)

RegisterNetEvent('warp-fishing:select_zone_3')
AddEventHandler('warp-fishing:select_zone_3', function()
    CaughtFishAmount = 0
    fishinglocation3active = true
    SetNewWaypoint(714.23736572266, 4148.9936523438)
    TriggerEvent('DoLongHudText', 'Your GPS was updated go to the area and fish', 1)
end)

RegisterNetEvent('warp-fishing:select_zone_4')
AddEventHandler('warp-fishing:select_zone_4', function()
    CaughtFishAmount = 0
    fishinglocation4active = true
    SetNewWaypoint(-183.74505615234, 4140.6328125)
    TriggerEvent('DoLongHudText', 'Your GPS was updated go to the area and fish', 1)
end)

RegisterNetEvent('warp-fishing:select_zone_5')
AddEventHandler('warp-fishing:select_zone_5', function()
    CaughtFishAmount = 0
    fishinglocation5active = true
    SetNewWaypoint(413.43298339844, 3622.5363769531)
    TriggerEvent('DoLongHudText', 'Your GPS was updated go to the area and fish', 1)
end)

-- Sale System

-- Bass

RegisterNetEvent('warp-jobs:fishing_sell:bass')
AddEventHandler('warp-jobs:fishing_sell:bass', function()
    local bassAmount = exports["warp-applications"]:KeyboardInput({
        header = "How Much Bass?",
        rows = {
        {
            id = 0,
            txt = "Input How Much Bass You Want To Sell"
        }
        }
    })
    if bassAmount[1] ~= nil then
        if exports['warp-inventory']:hasEnoughOfItem('bass', bassAmount[1].input) then
            FreezeEntityPosition(PlayerPedId(), true)
            local finished = exports['warp-taskbar']:taskBar(2000*bassAmount[1].input, 'Selling Bass')
            if finished == 100 then
                if exports['warp-inventory']:hasEnoughOfItem('bass', bassAmount[1].input) then
                    TriggerEvent('inventory:removeItem', 'bass', bassAmount[1].input)
                    TriggerServerEvent('warp-fishing:PayPlayer', 20*bassAmount[1].input)
                    FreezeEntityPosition(PlayerPedId(), false)
                else
                    FreezeEntityPosition(PlayerPedId(), false)
                    TriggerEvent('DoLongHudText', 'Might wanna try again', 2)
                end
            end
        end
    end
end)

-- Salmon

RegisterNetEvent('warp-jobs:fishing_sell:salmon')
AddEventHandler('warp-jobs:fishing_sell:salmon', function()
    local salmonAmount = exports["warp-applications"]:KeyboardInput({
        header = "How Much Salmon?",
        rows = {
        {
            id = 0,
            txt = "Input How Much Salmon You Want To Sell"
        }
        }
    })
    if salmonAmount[1] ~= nil then
        if exports['warp-inventory']:hasEnoughOfItem('salmon', salmonAmount[1].input) then
            FreezeEntityPosition(PlayerPedId(), true)
            local finished = exports['warp-taskbar']:taskBar(2000*salmonAmount[1].input, 'Selling Salmon')
            if finished == 100 then
                if exports['warp-inventory']:hasEnoughOfItem('salmon', salmonAmount[1].input) then
                    TriggerEvent('inventory:removeItem', 'salmon', salmonAmount[1].input)
                    TriggerServerEvent('warp-fishing:PayPlayer', 25*salmonAmount[1].input)
                    FreezeEntityPosition(PlayerPedId(), false)
                else
                    FreezeEntityPosition(PlayerPedId(), false)
                    TriggerEvent('DoLongHudText', 'Might wanna try again', 2)
                end
            end
        end
    end
end)

-- Crab

RegisterNetEvent('warp-jobs:fishing_sell:crab')
AddEventHandler('warp-jobs:fishing_sell:crab', function()
    local crabAmount = exports["warp-applications"]:KeyboardInput({
        header = "How Much Crab?",
        rows = {
        {
            id = 0,
            txt = "Input How Much Crab You Want To Sell"
        }
        }
    })
    if crabAmount[1] ~= nil then
        if exports['warp-inventory']:hasEnoughOfItem('crab', crabAmount[1].input) then
            FreezeEntityPosition(PlayerPedId(), true)
            local finished = exports['warp-taskbar']:taskBar(2000*crabAmount[1].input, 'Selling Crab')
            if finished == 100 then
                if exports['warp-inventory']:hasEnoughOfItem('crab', crabAmount[1].input) then
                    TriggerEvent('inventory:removeItem', 'crab', crabAmount[1].input)
                    TriggerServerEvent('warp-fishing:PayPlayer', 35*crabAmount[1].input)
                    FreezeEntityPosition(PlayerPedId(), false)
                else
                    FreezeEntityPosition(PlayerPedId(), false)
                    TriggerEvent('DoLongHudText', 'Might wanna try again', 2)
                end
            end
        end
    end
end)

-- Marlin

RegisterNetEvent('warp-jobs:fishing_sell:marlin')
AddEventHandler('warp-jobs:fishing_sell:marlin', function()
    local marlinAmount = exports["warp-applications"]:KeyboardInput({
        header = "How Much Marlin?",
        rows = {
        {
            id = 0,
            txt = "Input How Much Marlin You Want To Sell"
        }
        }
    })
    if marlinAmount[1] ~= nil then
        if exports['warp-inventory']:hasEnoughOfItem('marlin', marlinAmount[1].input) then
            FreezeEntityPosition(PlayerPedId(), true)
            local finished = exports['warp-taskbar']:taskBar(2000*marlinAmount[1].input, 'Selling Marlin')
            if finished == 100 then
                if exports['warp-inventory']:hasEnoughOfItem('marlin', marlinAmount[1].input) then
                    TriggerEvent('inventory:removeItem', 'marlin', marlinAmount[1].input)
                    TriggerServerEvent('warp-fishing:PayPlayer', 50*marlinAmount[1].input)
                    FreezeEntityPosition(PlayerPedId(), false)
                else
                    FreezeEntityPosition(PlayerPedId(), false)
                    TriggerEvent('DoLongHudText', 'Might wanna try again', 2)
                end
            end
        end
    end
end)

-- Shrimp

RegisterNetEvent('warp-jobs:fishing_sell:shrimp')
AddEventHandler('warp-jobs:fishing_sell:shrimp', function()
    local shrimpAmount = exports["warp-applications"]:KeyboardInput({
        header = "How Much Shrimp?",
        rows = {
        {
            id = 0,
            txt = "Input How Much Shrimp You Want To Sell"
        }
        }
    })
    if shrimpAmount[1] ~= nil then
        if exports['warp-inventory']:hasEnoughOfItem('shrimp', shrimpAmount[1].input) then
            FreezeEntityPosition(PlayerPedId(), true)
            local finished = exports['warp-taskbar']:taskBar(2000*shrimpAmount[1].input, 'Selling Shrimp')
            if finished == 100 then
                if exports['warp-inventory']:hasEnoughOfItem('shrimp', shrimpAmount[1].input) then
                    TriggerEvent('inventory:removeItem', 'shrimp', shrimpAmount[1].input)
                    TriggerServerEvent('warp-fishing:PayPlayer', 70*shrimpAmount[1].input)
                    FreezeEntityPosition(PlayerPedId(), false)
                else
                    FreezeEntityPosition(PlayerPedId(), false)
                    TriggerEvent('DoLongHudText', 'Might wanna try again', 2)
                end
            end
        end
    end
end)

-- Shark

RegisterNetEvent('warp-jobs:fishing_sell:shark')
AddEventHandler('warp-jobs:fishing_sell:shark', function()
    local sharkAmount = exports["warp-applications"]:KeyboardInput({
        header = "How Much Shark?",
        rows = {
        {
            id = 0,
            txt = "Input How Much Shark You Want To Sell"
        }
        }
    })
    if sharkAmount[1] ~= nil then
        if exports['warp-inventory']:hasEnoughOfItem('shark', sharkAmount[1].input) then
            FreezeEntityPosition(PlayerPedId(), true)
            local finished = exports['warp-taskbar']:taskBar(2000*sharkAmount[1].input, 'Selling Shark')
            if finished == 100 then
                if exports['warp-inventory']:hasEnoughOfItem('shark', sharkAmount[1].input) then
                    TriggerEvent('inventory:removeItem', 'shark', sharkAmount[1].input)
                    TriggerServerEvent('warp-fishing:PayPlayer', 100*sharkAmount[1].input)
                    FreezeEntityPosition(PlayerPedId(), false)
                else
                    FreezeEntityPosition(PlayerPedId(), false)
                    TriggerEvent('DoLongHudText', 'Might wanna try again', 2)
                end
            end
        end
    end
end)