local GodMode = false
local devmodeToggle = false
local debugmodeToggle = false
local NoClip = false
local entity

local EvanInDev = false
local EvanNotInDev = false

RegisterNetEvent('evan-admin_check:dev_mode')
AddEventHandler('evan-admin_check:dev_mode', function()
    if EvanInDev then
        SendNUIMessage({
            type = 'evan_in_dev'
        })
    else
        SendNUIMessage({
            type = 'evan_not_dev'
        })
    end
end)

RegisterNetEvent('warp-admin:openMenu', function()
    SendNUIMessage({
        type = 'open'
    })
    SetNuiFocus(true, true)
    TriggerEvent('evan-admin_check:dev_mode')
end)

RegisterNetEvent('event:control:adminDev')
AddEventHandler('event:control:adminDev', function(useID)
    if not devmodeToggle then return end
    if useID == 1 then
        TriggerEvent("warp-admin:openMenu")
    elseif useID == 2 then
        local bool = not isInNoclip
        RunNclp(nil,bool)
        TriggerServerEvent('warp-admin:noclip_dev_mode')
        TriggerEvent("warp-admin:noClipToggle",bool)
    elseif useID == 4 then
        teleportMarker(nil)
    end
end)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('buttonpress', function(data, cb)
    -- print(data.id)
    if data.id == 1 then

        if exports["warp-base"]:getModule("LocalPlayer"):getVar("rank") == ('dev' or 'admin' or 'superadmin' or 'mod' or 'owner') then
            SetNuiFocus(false, false)
            cb('ok')
            SendNUIMessage({
                type = 'close'
            })
            TriggerEvent('event:control:bennys', 14)

        end

    elseif data.id == 2 then

        if exports["warp-base"]:getModule("LocalPlayer"):getVar("rank") == ('dev' or 'admin' or 'superadmin' or 'mod' or 'owner') then
            SetNuiFocus(false, false)
            cb('ok')
            SendNUIMessage({
                type = 'close'
            })
            local veh = exports["warp-applications"]:KeyboardInput({
                header = "Spawn Vehicle",
                rows = {
                {
                    id = 0,
                    txt = "Vehicle Model"
                }
                }
            })
            if veh[1] ~= nil then
                TriggerServerEvent('warp-admin:spawned_vehicle')
                TriggerEvent('warp-admin:runSpawnCommand', veh[1].input)
            end
        end

    elseif data.id == 3 then

        if exports["warp-base"]:getModule("LocalPlayer"):getVar("rank") == ('dev' or 'admin' or 'superadmin' or 'mod' or 'owner') then
            SetNuiFocus(false, false)
            cb('ok')
            SendNUIMessage({
                type = 'close'
            })
            local item = exports["warp-applications"]:KeyboardInput({
                header = "Spawn Item",
                rows = {
                    {
                        id = 0,
                        txt = "Item ID"
                    },
                    {
                        id = 1,
                        txt = "Amount"
                    }
                }
            })

            TriggerEvent('player:receiveItem', item[1].input, tonumber(item[2].input))
            TriggerServerEvent('warp-admin:spawned_a_item', item[1].input)
        end   

    elseif data.id == 4 then
        if exports["warp-base"]:getModule("LocalPlayer"):getVar("rank") == ('dev' or 'admin' or 'superadmin' or 'mod' or 'owner') then
            SetNuiFocus(false, false)
            cb('ok')
            SendNUIMessage({
                type = 'close'
            })
            local item = exports["warp-applications"]:KeyboardInput({
                header = "Set Time / Weather",
                rows = {
                    {
                        id = 0,
                        txt = "Weather"
                    },
                    {
                        id = 1,
                        txt = "Time"
                    },
                    {
                        id = 2,
                        txt = "Blackout (true, false)"
                    }
                }
            })

            if item[1] ~= nil then
                TriggerServerEvent('weather:setWeather', 1, item[1].input)
            -- elseif item[2] ~= nil then
                TriggerServerEvent('weather:time', 1, item[2].input)
            -- elseif item[3] ~= nil then
                TriggerEvent('weather:blackout', item[3].input)
            end
        end

    elseif data.id == 5 then

        if exports["warp-base"]:getModule("LocalPlayer"):getVar("rank") == ('dev' or 'admin' or 'superadmin' or 'mod' or 'owner') then
            SetNuiFocus(false, false)
            cb('ok')
            SendNUIMessage({
                type = 'close'
            })
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if not vehicle then return end
        
            SetVehicleFixed(vehicle)
            SetVehiclePetrolTankHealth(vehicle, 4000.0)
            TriggerEvent('warp-admin:FixedVehicle', vehicle)
        end
        
    elseif data.id == 6 then

        if exports["warp-base"]:getModule("LocalPlayer"):getVar("rank") == ('dev' or 'admin' or 'superadmin' or 'mod' or 'owner') then
            SetNuiFocus(false, false)
            cb('ok')
            SendNUIMessage({
                type = 'close'
            })

            local model = exports["warp-applications"]:KeyboardInput({
                header = "Become Model",
                rows = {
                {
                    id = 0,
                    txt = "Enter Model Spawn"
                }}
            })
            if model[1] ~= nil then
                TriggerEvent('raid_clothes:AdminSetModel', model[1].input)
                TriggerEvent('warp-admin:raid_clothes:model', model[1].input)
                TriggerServerEvent('warp-admin:ped_model')
            end
        end

    elseif data.id == 7 then

        if exports["warp-base"]:getModule("LocalPlayer"):getVar("rank") == ('dev' or 'admin' or 'superadmin' or 'mod' or 'owner') then
            SetNuiFocus(false, false)
            cb('ok')
            SendNUIMessage({
                type = 'close'
            })
            GodMode = not GodMode
            if GodMode then
                TriggerEvent('DoLongHudText', 'Godmode Enabled!', 1)
                TriggerServerEvent('warp-admin:godmode')
            else
                TriggerEvent('DoLongHudText', 'Godmode Disabled!', 2)
                TriggerServerEvent('warp-admin:godmode2')
            end
            SetPlayerInvincible(PlayerId(), GodMode)
        end

    elseif data.id == 8 then

        if exports["warp-base"]:getModule("LocalPlayer"):getVar("rank") == ('dev' or 'admin' or 'superadmin' or 'mod' or 'owner') then
            SetNuiFocus(false, false)
            cb('ok')
            SendNUIMessage({
                type = 'close'
            })
            teleportMarker(nil)
            TriggerServerEvent('warp-admin:teleport_to_marker')
        end

    elseif data.id == 9 then

        if exports["warp-base"]:getModule("LocalPlayer"):getVar("rank") == ('dev' or 'admin' or 'superadmin' or 'mod' or 'owner') then
            SetNuiFocus(false, false)
            cb('ok')
            SendNUIMessage({
                type = 'close'
            })
            NoClip = not NoClip
            if not NoClip then
                TriggerEvent('DoLongHudText', 'Noclip Disabled')
                TriggerServerEvent('warp-admin:noclip2')
            else
                TriggerEvent('DoLongHudText', 'Noclip Enabled')
                TriggerServerEvent('warp-admin:noclip')
            end
            TriggerEvent("warp-admin:noClipToggle", NoClip)
        end 

    elseif data.id == 10 then

        if exports["warp-base"]:getModule("LocalPlayer"):getVar("rank") == ('dev' or 'admin' or 'superadmin' or 'mod' or 'owner') then
            SetNuiFocus(false, false)
            cb('ok')
            SendNUIMessage({
                type = 'close'
            })
            TriggerEvent('warp-context:sendMenu', {
                {
                    id = 1,
                    header = 'Revive In Distance',
                    txt = 'Revive all nearby players.',
                    params = {
                        event = "warp-admin:ReviveInDistance"
                    }
                },
                {
                    id = 2,
                    header = 'Revive Player',
                    txt = 'Revive Specific Player',
                    params = {
                        event = "warp-admin:adminSpecific"
                    }
                }
            })
        end

    elseif data.id == 11 then

        if exports["warp-base"]:getModule("LocalPlayer"):getVar("rank") == ('dev' or 'admin' or 'superadmin' or 'mod' or 'owner') then
            SetNuiFocus(false, false)
            cb('ok')
            SendNUIMessage({
                type = 'close'
            })
            local coords = exports["warp-applications"]:KeyboardInput({
                header = "Teleport To Coordinates",
                rows = {
                    {
                        id = 0,
                        txt = "X (Coord X)"
                    },
                    {
                        id = 1,
                        txt = "Y (Coord Y)"
                    },
                    {
                        id = 2,
                        txt = "Z (Coord Z)"
                    }
                }
            })
            if coords[1] ~= nil and coords[2] ~= nil and coords[3] ~= nil then
                local pos = vector3(tonumber(coords[1].input),tonumber(coords[2].input),tonumber(coords[3].input))
                local ped = PlayerPedId()
        
                Citizen.CreateThread(function()
                    RequestCollisionAtCoord(pos)
                    SetPedCoordsKeepVehicle(ped, pos)
                    FreezeEntityPosition(ped, true)
                    SetPlayerInvincible(PlayerId(), true)
        
                    local startedCollision = GetGameTimer()
        
                    while not HasCollisionLoadedAroundEntity(ped) do
                        if GetGameTimer() - startedCollision > 5000 then break end
                        Citizen.Wait(0)
                    end
        
                    FreezeEntityPosition(ped, false)
                    SetPlayerInvincible(PlayerId(), false)
                end)
            end
        end

    elseif data.id == 12 then

        if exports["warp-base"]:getModule("LocalPlayer"):getVar("rank") == ('dev' or 'admin' or 'superadmin' or 'mod' or 'owner') then
            SetNuiFocus(false, false)
            cb('ok')
            SendNUIMessage({
                type = 'close'
            })
            debugmodeToggle = not debugmodeToggle
            if debugmodeToggle then
                TriggerEvent('DoLongHudText', 'Debug Enabled!', 1)
                TriggerServerEvent('warp-admin:dev_debug')
            else
                TriggerEvent('DoLongHudText', 'Debug Disabled!', 1)
                TriggerServerEvent('warp-admin:dev_debug')
            end
            TriggerEvent('warp-admin:currentDebug', debugmodeToggle)
        end

    elseif data.id == 13 then

        if exports["warp-base"]:getModule("LocalPlayer"):getVar("rank") == ('dev' or 'admin' or 'superadmin' or 'mod' or 'owner') then
            SetNuiFocus(false, false)
            cb('ok')
            SendNUIMessage({
                type = 'close'
            })
            local coordA = GetEntityCoords(PlayerPedId(), false)
            local coordB = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 5.0, 0.0)

            local offset = 0
            local rayHandle

            for i = 0, 100 do
                rayHandle = CastRayPointToPoint(coordA.x, coordA.y, coordA.z, coordB.x, coordB.y, coordB.z + offset, 10, PlayerPedId(), -1)	
                a, b, c, d, entity = GetRaycastResult(rayHandle)
                offset = offset - 1
                if entity and Vdist(GetEntityCoords(entity, false), coordA) < 150 then break end
            end
            DeleteEntity(entity)
            entity = nil
        end

    elseif data.id == 14 then

        if exports["warp-base"]:getModule("LocalPlayer"):getVar("rank") == ('dev' or 'admin' or 'superadmin' or 'mod' or 'owner') then
            SetNuiFocus(false, false)
            cb('ok')
            SendNUIMessage({
                type = 'close'
            })
            local csay = exports["warp-applications"]:KeyboardInput({
                header = "Server Announcement",
                rows = {
                {
                    id = 0,
                    txt = "Enter T-Say"
                }}
            })
            if csay[1] ~= nil then
                TriggerServerEvent('warp-admin:sendAnnoucement', csay[1].input)
            end
        end

    elseif data.id == 15 then
        if exports["warp-base"]:getModule("LocalPlayer"):getVar("rank") == ('dev' or 'admin' or 'superadmin' or 'mod' or 'owner') then
            SetNuiFocus(false, false)
            cb('ok')
            SendNUIMessage({
                type = 'close'
            })
            local plate = exports["warp-applications"]:KeyboardInput({
                header = "Enter License Plate",
                rows = {
                {
                    id = 0,
                    txt = "Enter License Plate"
                }}
            })
            if plate[1] ~= nil then
                TriggerServerEvent('warp-admin:update:vehicle', plate[1].input)
            end
        end

    elseif data.id == 16 then

        if exports["warp-base"]:getModule("LocalPlayer"):getVar("rank") == ('dev' or 'admin' or 'superadmin' or 'mod' or 'owner') then
            SetNuiFocus(false, false)
            cb('ok')
            SendNUIMessage({
                type = 'close'
            })
            TriggerEvent('raid_clothes:admin:open', 'clothing_shop')
            TriggerServerEvent('warp-admin:clothing_menu')
        end

    elseif data.id == 17 then

        if exports["warp-base"]:getModule("LocalPlayer"):getVar("rank") == ('dev' or 'admin' or 'superadmin' or 'mod' or 'owner') then
            SetNuiFocus(false, false)
            cb('ok')
            SendNUIMessage({
                type = 'close'
            })
            TriggerEvent('raid_clothes:admin:open', 'barber_shop')
            TriggerServerEvent('warp-admin:barber_menu')
        end

    elseif data.id == 18 then

        if exports["warp-base"]:getModule("LocalPlayer"):getVar("rank") == ('dev' or 'admin' or 'superadmin' or 'mod' or 'owner') then
            SetNuiFocus(false, false)
            cb('ok')
            SendNUIMessage({
                type = 'close'
            })
            TriggerEvent('police:giveweapon')
        end

    elseif data.id == 19 then

        if exports["warp-base"]:getModule("LocalPlayer"):getVar("rank") == ('dev' or 'admin' or 'superadmin' or 'mod' or 'owner') then
            SetNuiFocus(false, false)
            cb('ok')
            SendNUIMessage({
                type = 'close'
            })
            TriggerEvent('police:givehunting')
        end

    elseif data.id == 20 then

        if exports["warp-base"]:getModule("LocalPlayer"):getVar("rank") == ('dev' or 'admin' or 'superadmin' or 'mod' or 'owner') then
            SetNuiFocus(false, false)
            cb('ok')
            SendNUIMessage({
                type = 'close'
            })
            TriggerEvent('warp-admin:maxstats')
            TriggerServerEvent('warp-admin:max_stats')
        end

    elseif data.id == 21 then

        if exports["warp-base"]:getModule("LocalPlayer"):getVar("rank") == ('dev' or 'admin' or 'superadmin' or 'mod' or 'owner') then
            SetNuiFocus(false, false)
            cb('ok')
            SendNUIMessage({
                type = 'close'
            })
            devmodeToggle = not devmodeToggle
            if devmodeToggle then
                TriggerServerEvent('warp-admin:developer_mode')
                TriggerEvent('DoLongHudText', 'Dev Mode Enabled!', 1)
                EvanInDev = true
            else
                EvanNotInDev = true
                EvanInDev = false
                TriggerEvent('DoLongHudText', 'Dev Mode Disabled!', 2)
                TriggerServerEvent('warp-admin:developer_mode_2')
            end
            TriggerEvent('warp-admin:currentDevmode', devmodeToggle)
        end

    elseif data.id == 23 then

        if exports["warp-base"]:getModule("LocalPlayer"):getVar("rank") == ('dev' or 'admin' or 'superadmin' or 'mod' or 'owner') then
            SetNuiFocus(false, false)
            cb('ok')
            SendNUIMessage({
                type = 'close'
            })
            setPlayerDevSpawn()
        end

    elseif data.id == 24 then

        if exports["warp-base"]:getModule("LocalPlayer"):getVar("rank") == ('dev' or 'admin' or 'superadmin' or 'mod' or 'owner') then
            SetNuiFocus(false, false)
            cb('ok')
            SendNUIMessage({
                type = 'close'
            })
            local pPass = exports["warp-applications"]:KeyboardInput({
                header = "Set Character Pass",
                rows = {
                    {
                        id = 0,
                        txt = "CID"
                    },
                    {
                        id = 1,
                        txt = "Passtype"
                    },
                    {
                        id = 2,
                        txt = "Rank"
                    },
                    {
                        id = 3,
                        txt = "Add/Remove"
                    }
                }
            })
            if pPass[1] ~= nil then
                TriggerServerEvent("warp-admin:addCharacterPass", tonumber(pPass[1].input), pPass[2].input, tonumber(pPass[3].input), pPass[4].input)
            end
        end

    elseif data.id == 22 then

        if exports["warp-base"]:getModule("LocalPlayer"):getVar("rank") == ('dev' or 'admin' or 'superadmin' or 'mod' or 'owner') then
            SetNuiFocus(false, false)
            cb('ok')
            SendNUIMessage({
                type = 'close'
            })
            local playerid = exports["warp-applications"]:KeyboardInput({
                header = "Open Player Inventory",
                rows = {
                {
                    id = 0,
                    txt = "Enter Target ID"
                }}
            })
            if playerid[1] ~= nil then
                TriggerServerEvent("people-search", tonumber(playerid[1].input))
            end
        end
    end
end)

function setPlayerDevSpawn()
    local loc = {}
     loc = {
     vars = {}
   }
    loc.vars.pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 0.0)
    local heading = GetEntityHeading(PlayerPedId())
    local value = vector4(loc.vars.pos.x,loc.vars.pos.y,loc.vars.pos.z,heading)
    exports["storage"]:set(value,"devspawn")
    TriggerEvent('DoShortHudText', 'Dev spawn set at : ' ..value)
end

function RunNclp(self,bool)
    local cmd = {}
    cmd = {
        vars = {}
    }
    
    if bool and isInNoclip then return end
    isInNoclip = bool
    
    TriggerEvent("warp-admin:noClipToggle", isInNoclip)
end



local noClipEnabled = false
local noClipCam = nil

local speed = 1.0
local maxSpeed = 32.0
local minY, maxY = -89.0, 89.0

local inputRotEnabled = false

function toggleNoclip()
  CreateThread(function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    local inVehicle = false

    Citizen.Wait(100)
    if veh ~= 0 then
      inVehicle = true
      ent = veh
    else
      ent = ped
    end

    local pos = GetEntityCoords(ent)
    local rot = GetEntityRotation(ent)

    noClipCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos, 0.0, 0.0, rot.z, 75.0, true, 2)
    AttachCamToEntity(noClipCam, ent, 0.0, 0.0, 0.0, true)
    RenderScriptCams(true, false, 3000, true, false)

    FreezeEntityPosition(ent, true)
    SetEntityCollision(ent, false, false)
    SetEntityAlpha(ent, 0)
    SetPedCanRagdoll(ped, false)
    SetEntityVisible(ent, false)
    ClearPedTasksImmediately(ped)

    if inVehicle then
      FreezeEntityPosition(ped, true)
      SetEntityCollision(ped, false, false)
      SetEntityAlpha(ped, 0)
      SetEntityVisible(ped, false)
    end

    while noClipEnabled do

      local rv, fv, uv, campos = GetCamMatrix(noClipCam)

      if IsDisabledControlPressed(2, 17) then -- MWheelUp
        speed = math.min(speed + 0.1, maxSpeed)
      elseif IsDisabledControlPressed(2, 16) then -- MWheelDown
        speed = math.max(0.1, speed - 0.1)
      end

      local multiplier = 1.0;

      if IsDisabledControlPressed(2, 209) then
        multiplier = 2.0
      elseif IsDisabledControlPressed(2, 19) then
        multiplier = 4.0
      elseif IsDisabledControlPressed(2, 36) then
        multiplier = 0.25
      end

      -- Forward and Backward
      if IsDisabledControlPressed(2, 32) then -- W
        local setpos = GetEntityCoords(ent) + fv * (speed * multiplier)
        SetEntityCoordsNoOffset(ent, setpos)
        if inVehicle then
          SetEntityCoordsNoOffset(ped, setpos)
        end
      elseif IsDisabledControlPressed(2, 33) then -- S
        local setpos = GetEntityCoords(ent) - fv * (speed * multiplier)
        SetEntityCoordsNoOffset(ent, setpos)
        if inVehicle then
          SetEntityCoordsNoOffset(ped, setpos)
        end
      end

      -- Left and Right
      if IsDisabledControlPressed(2, 34) then -- A
        local setpos = GetOffsetFromEntityInWorldCoords(ent, -speed * multiplier, 0.0, 0.0)
        SetEntityCoordsNoOffset(ent, setpos.x, setpos.y, GetEntityCoords(ent).z)
        if inVehicle then
          SetEntityCoordsNoOffset(ped, setpos.x, setpos.y, GetEntityCoords(ent).z)
        end
      elseif IsDisabledControlPressed(2, 35) then -- D
        local setpos = GetOffsetFromEntityInWorldCoords(ent, speed * multiplier, 0.0, 0.0)
        SetEntityCoordsNoOffset(ent, setpos.x, setpos.y, GetEntityCoords(ent).z)
        if inVehicle then
          SetEntityCoordsNoOffset(ped, setpos.x, setpos.y, GetEntityCoords(ent).z)
        end
      end

      -- Up and Down
      if IsDisabledControlPressed(2, 51) then -- E
        local setpos = GetOffsetFromEntityInWorldCoords(ent, 0.0, 0.0, multiplier * speed / 2)
        SetEntityCoordsNoOffset(ent, setpos)
        if inVehicle then
          SetEntityCoordsNoOffset(ped, setpos)
        end
      elseif IsDisabledControlPressed(2, 52) then
        local setpos = GetOffsetFromEntityInWorldCoords(ent, 0.0, 0.0, multiplier * -speed / 2) -- Q
        SetEntityCoordsNoOffset(ent, setpos)
        if inVehicle then
          SetEntityCoordsNoOffset(ped, setpos)
        end
      end

      local camrot = GetCamRot(noClipCam, 2)
      SetEntityHeading(ent, (360 + camrot.z) % 360.0)

      SetEntityVisible(ent, false)
      if inVehicle then
        SetEntityVisible(ped, false)
      end

      DisableControlAction(2, 32, true)
      DisableControlAction(2, 33, true)
      DisableControlAction(2, 34, true)
      DisableControlAction(2, 35, true)
      DisableControlAction(2, 36, true)
      DisableControlAction(2, 12, true)
      DisableControlAction(2, 13, true)
      DisableControlAction(2, 14, true)
      DisableControlAction(2, 15, true)
      DisableControlAction(2, 16, true)
      DisableControlAction(2, 17, true)

      DisablePlayerFiring(PlayerId(), true)
      Wait(0)
    end

    DestroyCam(noClipCam, false)
    noClipCam = nil
    RenderScriptCams(false, false, 3000, true, false)
    FreezeEntityPosition(ent, false)
    SetEntityCollision(ent, true, true)
    SetEntityAlpha(ent, 255)
    SetPedCanRagdoll(ped, true)
    SetEntityVisible(ent, true)
    ClearPedTasksImmediately(ped)

    if inVehicle then
      FreezeEntityPosition(ped, false)
      SetEntityCollision(ped, true, true)
      SetEntityAlpha(ped, 255)
      SetEntityVisible(ped, true)
      SetPedIntoVehicle(ped, ent, -1)
    end
  end)
end

function checkInputRotation()
  CreateThread(function()
    while inputRotEnabled do
      while noClipCam == nil do
        Wait(0)
      end

      local rightAxisX = GetDisabledControlNormal(0, 220)
      local rightAxisY = GetDisabledControlNormal(0, 221)

      if (math.abs(rightAxisX) > 0) and (math.abs(rightAxisY) > 0) then
        local rotation = GetCamRot(noClipCam, 2)
        rotz = rotation.z + rightAxisX * -10.0

        local yValue = rightAxisY * -5.0

        rotx = rotation.x

        if rotx + yValue > minY and rotx + yValue < maxY then
          rotx = rotation.x + yValue
        end

        SetCamRot(noClipCam, rotx, rotation.y, rotz, 2)
      end

      Wait(0)
    end
  end)
end

AddEventHandler("warp-admin:noClipToggle", function(pIsEnabled)
  noClipEnabled = pIsEnabled
  inputRotEnabled = pIsEnabled

  if noClipEnabled and inputRotEnabled then
    toggleNoclip()
    checkInputRotation()
  end
end)


local LastVehicle = nil
RegisterNetEvent("warp-admin:runSpawnCommand")
AddEventHandler("warp-admin:runSpawnCommand", function(model, livery)
    Citizen.CreateThread(function()

        local hash = GetHashKey(model)

        if not IsModelAVehicle(hash) then return end
        if not IsModelInCdimage(hash) or not IsModelValid(hash) then return end
        
        RequestModel(hash)

        while not HasModelLoaded(hash) do
            Citizen.Wait(0)
        end

        local localped = PlayerPedId()
        local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 1.5, 5.0, 0.0)

        local heading = GetEntityHeading(localped)
        local vehicle = CreateVehicle(hash, coords, heading, true, false)

        SetVehicleModKit(vehicle, 0)
        SetVehicleMod(vehicle, 11, 3, false)
        SetVehicleMod(vehicle, 12, 2, false)
        SetVehicleMod(vehicle, 13, 2, false)
        SetVehicleMod(vehicle, 15, 3, false)
        SetVehicleMod(vehicle, 16, 4, false)


        if model == "pol1" then
            SetVehicleExtra(vehicle, 5, 0)
        end

        if model == "police" then
            SetVehicleWheelType(vehicle, 2)
            SetVehicleMod(vehicle, 23, 10, false)
            SetVehicleColours(vehicle, 0, false)
            SetVehicleExtraColours(vehicle, 0, false)
        end

        if model == "pol7" then
            SetVehicleColours(vehicle,0)
            SetVehicleExtraColours(vehicle,0)
        end

        if model == "pol5" or model == "pol6" then
            SetVehicleExtra(vehicle, 1, -1)
        end


        local plate = GetVehicleNumberPlateText(vehicle)
        TriggerEvent("keys:addNew",vehicle,plate)
        TriggerServerEvent('garages:addJobPlate', plate)
        SetModelAsNoLongerNeeded(hash)
        TaskWarpPedIntoVehicle(localped, vehicle, -1)
        
        SetVehicleDirtLevel(vehicle, 0)
        SetVehicleWindowTint(vehicle, 0)

        if livery ~= nil then
            SetVehicleLivery(vehicle, tonumber(livery))
        end
        LastVehicle = vehicle
    end)
end)

function teleportMarker()

    local WaypointHandle = GetFirstBlipInfoId(8)
    if DoesBlipExist(WaypointHandle) then
        local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

        for height = 1, 1000 do
            SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

            local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

            if foundGround then
                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                break
            end
            Citizen.Wait(5)
        end
    else
        TriggerEvent("DoLongHudText", 'Failed to find marker.',2)
    end
end

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}


local inFreeze = false
local lowGrav = false

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.25, 0.25)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end


function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function GetVehicle()
    local playerped = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstVehicle()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
        if canPedBeUsed(ped) and distance < 30.0 and (distanceFrom == nil or distance < distanceFrom) then
            distanceFrom = distance
            rped = ped
           -- FreezeEntityPosition(ped, inFreeze)
	    	if IsEntityTouchingEntity(GetPlayerPed(-1), ped) then
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Veh: " .. ped .. " Model: " .. GetEntityModel(ped) .. " IN CONTACT" )
	    	else
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Veh: " .. ped .. " Model: " .. GetEntityModel(ped) .. "" )
	    	end
            if lowGrav then
            	SetEntityCoords(ped,pos["x"],pos["y"],pos["z"]+5.0)
            end
        end
        success, ped = FindNextVehicle(handle)
    until not success
    EndFindVehicle(handle)
    return rped
end

function GetObject()
    local playerped = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstObject()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
        if distance < 10.0 then
            distanceFrom = distance
            rped = ped
            --FreezeEntityPosition(ped, inFreeze)
	    	if IsEntityTouchingEntity(GetPlayerPed(-1), ped) then
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Obj: " .. ped .. " Model: " .. GetEntityModel(ped) .. " IN CONTACT" )
	    	else
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Obj: " .. ped .. " Model: " .. GetEntityModel(ped) .. "" )
	    	end

            if lowGrav then
            	--ActivatePhysics(ped)
            	SetEntityCoords(ped,pos["x"],pos["y"],pos["z"]+0.1)
            	FreezeEntityPosition(ped, false)
            end
        end

        success, ped = FindNextObject(handle)
    until not success
    EndFindObject(handle)
    return rped
end

function getNPC()
    local playerped = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
        if canPedBeUsed(ped) and distance < 30.0 and (distanceFrom == nil or distance < distanceFrom) then
            distanceFrom = distance
            rped = ped

	    	if IsEntityTouchingEntity(GetPlayerPed(-1), ped) then
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"], "Ped: " .. ped .. " Model: " .. GetEntityModel(ped) .. " Relationship HASH: " .. GetPedRelationshipGroupHash(ped) .. " IN CONTACT" )
	    	else
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"], "Ped: " .. ped .. " Model: " .. GetEntityModel(ped) .. " Relationship HASH: " .. GetPedRelationshipGroupHash(ped) )
	    	end

            FreezeEntityPosition(ped, inFreeze)
            if lowGrav then
            	SetPedToRagdoll(ped, 511, 511, 0, 0, 0, 0)
            	SetEntityCoords(ped,pos["x"],pos["y"],pos["z"]+0.1)
            end
        end
        success, ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)
    return rped
end

function canPedBeUsed(ped)
    if ped == nil then
        return false
    end
    if ped == GetPlayerPed(-1) then
        return false
    end
    if not DoesEntityExist(ped) then
        return false
    end
    return true
end



Citizen.CreateThread( function()

    while true do 
        
        Citizen.Wait(1)
        
        if debugmodeToggle == true then
            local pos = GetEntityCoords(GetPlayerPed(-1))

            local forPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 1.0, 0.0)
            local backPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, -1.0, 0.0)
            local LPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 1.0, 0.0, 0.0)
            local RPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), -1.0, 0.0, 0.0) 

            local forPos2 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 2.0, 0.0)
            local backPos2 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, -2.0, 0.0)
            local LPos2 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 2.0, 0.0, 0.0)
            local RPos2 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), -2.0, 0.0, 0.0)    

            local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
            local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
            currentStreetName = GetStreetNameFromHashKey(currentStreetHash)

            drawTxt(0.8, 0.50, 0.4,0.4,0.30, "Heading: " .. GetEntityHeading(GetPlayerPed(-1)), 55, 155, 55, 255)
            drawTxt(0.8, 0.52, 0.4,0.4,0.30, "Coords: " .. pos, 55, 155, 55, 255)
            drawTxt(0.8, 0.54, 0.4,0.4,0.30, "Attached Ent: " .. GetEntityAttachedTo(GetPlayerPed(-1)), 55, 155, 55, 255)
            drawTxt(0.8, 0.56, 0.4,0.4,0.30, "Health: " .. GetEntityHealth(GetPlayerPed(-1)), 55, 155, 55, 255)
            drawTxt(0.8, 0.58, 0.4,0.4,0.30, "H a G: " .. GetEntityHeightAboveGround(GetPlayerPed(-1)), 55, 155, 55, 255)
            drawTxt(0.8, 0.60, 0.4,0.4,0.30, "Model: " .. GetEntityModel(GetPlayerPed(-1)), 55, 155, 55, 255)
            drawTxt(0.8, 0.62, 0.4,0.4,0.30, "Speed: " .. GetEntitySpeed(GetPlayerPed(-1)), 55, 155, 55, 255)
            drawTxt(0.8, 0.64, 0.4,0.4,0.30, "Frame Time: " .. GetFrameTime(), 55, 155, 55, 255)
            drawTxt(0.8, 0.66, 0.4,0.4,0.30, "Street: " .. currentStreetName, 55, 155, 55, 255)
            
            
            DrawLine(pos,forPos, 255,0,0,115)
            DrawLine(pos,backPos, 255,0,0,115)

            DrawLine(pos,LPos, 255,255,0,115)
            DrawLine(pos,RPos, 255,255,0,115)           

            DrawLine(forPos,forPos2, 255,0,255,115)
            DrawLine(backPos,backPos2, 255,0,255,115)

            DrawLine(LPos,LPos2, 255,255,255,115)
            DrawLine(RPos,RPos2, 255,255,255,115)     

            local nearped = getNPC()

            local veh = GetVehicle()

            local nearobj = GetObject()

            if IsControlJustReleased(0, 38) then
                if inFreeze then
                    inFreeze = false
                    TriggerEvent("DoShortHudText",'Freeze Disabled',3)          
                else
                    inFreeze = true             
                    TriggerEvent("DoShortHudText",'Freeze Enabled',3)               
                end
            end

            if IsControlJustReleased(0, 47) then
                if lowGrav then
                    lowGrav = false
                    TriggerEvent("DoShortHudText",'Low Grav Disabled',3)            
                else
                    lowGrav = true              
                    TriggerEvent("DoShortHudText",'Low Grav Enabled',3)                 
                end
            end

        else
            Citizen.Wait(5000)
        end
    end
end)


RegisterNetEvent("warp-admin:adminSpecific")
AddEventHandler("warp-admin:adminSpecific", function()
    local res = exports["warp-applications"]:KeyboardInput({
        header = "Revive Player",
        rows = {
        {
            id = 0,
            txt = "Player ID"
        }
        }
    })
    if res[1] ~= nil then
        TriggerServerEvent('warp-admin:revive_in_distance')
        TriggerServerEvent("warp-death:reviveSV", res[1].input)
        TriggerServerEvent("reviveGranted", res[1].input)
        TriggerServerEvent("ems:healplayer", res[1].input)
    end
end)


function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end

RegisterNetEvent("warp-admin:ReviveInDistance")
AddEventHandler("warp-admin:ReviveInDistance", function()
    local playerList = {}

    local players = GetPlayers()
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)


    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
        local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
        if(distance < 50) then
            TriggerServerEvent('warp-admin:revive_in_distance')
            playerList[index] = GetPlayerServerId(value)
        end
    end

    if playerList ~= {} and playerList ~= nil then

        for k,v in pairs(playerList) do
            TriggerServerEvent("warp-death:reviveSV", v)
            TriggerServerEvent("reviveGranted", v)
             TriggerEvent("Hospital:HealInjuries",true) 
             TriggerServerEvent("ems:healplayer", v)
             TriggerEvent("heal")
        end
    end
end)

-- New Functions --

RegisterNUICallback('evan-rev-dist', function(cb)
    TriggerEvent('warp-admin:ReviveInDistance')
end)