Void.SpawnManager = {}

function Void.SpawnManager.Initialize(self)
    Citizen.CreateThread(function()

        FreezeEntityPosition(PlayerPedId(), true)

        DoScreenFadeOut(500)

        local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)

        SetCamRot(cam, 0.0, 0.0, -45.0, 2)
        SetCamCoord(cam, -682.0, -1092.0, 226.0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, true)

        local ped = PlayerPedId()

        SetEntityCoordsNoOffset(ped, -682.0, -1092.0, 200.0, false, false, false, true)

        DoScreenFadeIn(2000)

        while IsScreenFadingIn() do
            Citizen.Wait(0)
        end

        Citizen.Wait(5000)

        TriggerEvent("warp-base:spawnInitialized")
        TriggerServerEvent("warp-base:spawnInitialized")
        TriggerServerEvent('warp-scoreboard:updatePlayerCount')
    end)
end

function Void.SpawnManager.InitialSpawn(self)
    Citizen.CreateThread(function()
        DisableAllControlActions(0)
      
        DoScreenFadeOut(10)

        while IsScreenFadingOut() do
            Citizen.Wait(0)
        end

        local character = Void.LocalPlayer:getCurrentCharacter()

        local ped = PlayerPedId()

        SetEntityVisible(ped, true)
        FreezeEntityPosition(PlayerPedId(), false)
        
        ClearPedTasksImmediately(ped)
        RemoveAllPedWeapons(ped)
        --ClearPlayerWantedLevel(PlayerId())

        EnableAllControlActions(0)

        TriggerEvent("character:finishedLoadingChar")
    end)
end

AddEventHandler("warp-base:firstSpawn", function()
    Void.SpawnManager:InitialSpawn()
end)

RegisterNetEvent('warp-base:clearStates')
AddEventHandler('warp-base:clearStates', function()
    TriggerServerEvent("reset:blips")
    TriggerEvent("nowEMSDeathOff")
    TriggerEvent("nowCopDeathOff")
    TriggerEvent("stopSpeedo")
    TriggerEvent("wk:disableRadar")
    exports['warp-voice']:removePlayerFromRadio()
    exports["warp-voice"]:setVoiceProperty("radioEnabled", false)
end)
