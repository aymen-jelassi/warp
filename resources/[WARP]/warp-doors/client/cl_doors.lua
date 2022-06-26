local doors = {}
local currentDoorCoords, currentDoorId, currentDoorLockState, currentZone = vector3(0, 0, 0), nil, nil, nil
local listening = false
local Container1Locked = false
local Container2Locked = false
local Container3Locked = false
local bollards = {
    mrpd_bollards_01 = {
        doorId = 309,
        inside = false
    },
    mrpd_bollards_02 = {
        doorId = 310,
        inside = false
    },
}

RegisterNetEvent('warp-doors:initial-lock-state')
AddEventHandler('warp-doors:initial-lock-state', function(pDoors)
    doors = pDoors
    setSecuredAccesses(doors, 'door')
    for doorId, door in ipairs(doors) do
        if doorId ~= door.id then
            -- print("we should not see this message - door id mismatch", doorId, " - id: ", door.id) -- This doesn't even matter i don't think lol
        end
        if door.active and not IsDoorRegisteredWithSystem(doorId) then
            AddDoorToSystem(doorId, door.model, door.coords, false, false, false)
            if door.automatic then
                if door.automatic.distance then
                    DoorSystemSetAutomaticDistance(doorId, door.automatic.distance, 0, 1)
                end
                if door.automatic.rate then
                    DoorSystemSetAutomaticRate(doorId, door.automatic.rate, 0, 1)
                end
            end
            DoorSystemSetDoorState(doorId, door.lock, 0, 1)
        end
    end
end)

RegisterNetEvent("warp-doors:container_1")
AddEventHandler("warp-doors:container_1", function()
    local player = GetEntityCoords(PlayerPedId())
    local distance = #(vector3(588.5322, -1876.253, 25.1212) - player)
    if distance < 1.5 then
        if not Container1Locked then
            TriggerServerEvent('warp-doors:change-lock-state', 567, false)
            TriggerServerEvent('warp-doors:change-lock-state', 568, false)
            Container1Locked = true
        else
            TriggerServerEvent('warp-doors:change-lock-state', 567, true)
            TriggerServerEvent('warp-doors:change-lock-state', 568, true)
            Container1Locked = false
        end
    end
end)

RegisterNetEvent("warp-doors:container_2")
AddEventHandler("warp-doors:container_2", function()
    local player = GetEntityCoords(PlayerPedId())
    local distance = #(vector3(497.8145, -1959.981, 24.8232) - player)
    if distance < 1.5 then
        if not Container2Locked then
            TriggerServerEvent('warp-doors:change-lock-state', 569, false)
            TriggerServerEvent('warp-doors:change-lock-state', 570, false)
            Container2Locked = true
        else
            TriggerServerEvent('warp-doors:change-lock-state', 569, true)
            TriggerServerEvent('warp-doors:change-lock-state', 570, true)
            Container2Locked = false
        end
    end
end)

RegisterNetEvent("warp-doors:container_3")
AddEventHandler("warp-doors:container_3", function()
    local player = GetEntityCoords(PlayerPedId())
    local distance = #(vector3(667.55352, 1287.0131, 360.29592) - player)
    if distance < 1.5 then
        if not Container3Locked then
            TriggerServerEvent('warp-doors:change-lock-state', 571, false)
            TriggerServerEvent('warp-doors:change-lock-state', 572, false)
            Container3Locked = true
        else
            TriggerServerEvent('warp-doors:change-lock-state', 571, true)
            TriggerServerEvent('warp-doors:change-lock-state', 572, true)
            Container3Locked = false
        end
    end
end)

RegisterNetEvent("test:123")
AddEventHandler("test:123", function ()
    local playerPed = PlayerPedId()
  local position = GetEntityCoords(playerPed, false)
  local endPosition = position + GetEntityForwardVector(playerPed)
  local raycast = StartShapeTestSweptSphere(position.x, position.y, position.z, endPosition.x, endPosition.y, endPosition.z, 0.2, 16, playerPed, 4)
  local retval, hit, endCoords, surfaceNormal, entity = GetShapeTestResult(raycast)
  local targetDoor = GetTargetDoorId(entity)
  if not targetDoor then return end
  local isLocked = (DoorSystemGetDoorState(currentDoorId) ~= 0 and true or false)
  if not isLocked then
    return
  end
  Citizen.CreateThread(function()
    RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
    RequestModel("hei_p_m_bag_var22_arm_s")
    while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") and not HasModelLoaded("hei_p_m_bag_var22_arm_s") do
      Citizen.Wait(0)
    end
    local ped = PlayerPedId()
    Citizen.Wait(100)
    local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(ped)))
    local bagscene = NetworkCreateSynchronisedScene(endCoords.x, endCoords.y, endCoords.z, rotx, roty, rotz, 2, false, false, 1065353216, 0, 1.3)
    local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), endCoords.x, endCoords.y, endCoords.z,  true,  true, false)
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(bag), false)
    SetEntityCollision(bag, false, true)
    NetworkAddPedToSynchronisedScene(ped, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, bagscene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)
    local curVar = GetPedDrawableVariation(ped, 5)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    NetworkStartSynchronisedScene(bagscene)
    Citizen.Wait(1500)
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local bomba = CreateObject(GetHashKey("hei_prop_heist_thermite"), x, y, z + 0.2,  true,  true, true)
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(bomba), false)
    SetEntityCollision(bomba, false, true)
    AttachEntityToEntity(bomba, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
    Citizen.Wait(4000)
    DeleteObject(bag)
    if curVar > 0 then
      SetPedComponentVariation(ped, 5, curVar, 0, 0)
    end
    DetachEntity(bomba, 1, 1)
    FreezeEntityPosition(bomba, true)
    NetworkStopSynchronisedScene(bagscene)
    TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, 0, 0, 0)
    TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 6000, 49, 1, 0, 0, 0)
    Citizen.Wait(5000)
    AddExplosion(endCoords, 32, 100.0, true, false, 4.0)
    -- TriggerServerEvent("fx:DetCord", NetworkGetNetworkIdFromEntity(bomba), endCoords) PATLAMA EFEKTI SERVER SIDE
    Citizen.Wait(2000)
    ClearPedTasks(ped) 
    DeleteObject(bomba)
    TriggerServerEvent("warp-doors:change-lock-state", targetDoor, 0)
    TriggerEvent("inventory:removeItem", "detcord", 1)
end)
end)

RegisterNetEvent('warp-doors:change-lock-state')
AddEventHandler('warp-doors:change-lock-state', function(pDoorId, pDoorLockState, pDoorForceUnlock)
    if doors and doors[pDoorId] then
        doors[pDoorId].lock = pDoorLockState
        doors[pDoorId].forceUnlocked = pDoorForceUnlock
        DoorSystemSetAutomaticRate(pDoorId, 1.0, 0, 0)
        DoorSystemSetDoorState(pDoorId, pDoorLockState, 0, 1)
        if pDoorId == currentDoorId then
            currentDoorLockState = pDoorLockState
        end
    end
end)

local function listenForKeypress()
    listening = true
    Citizen.CreateThread(function()

        local newDoorId, newLockState = currentDoorId

        currentDoorLockState = (DoorSystemGetDoorState(currentDoorId) ~= 0 and true or false)

        local hasAccess = hasSecuredAccess(currentDoorId, 'door')

        local isHidden = doors[currentDoorId].hidden

        if not hasAccess and currentDoorLockState then
            exports["warp-textui"]:showInteraction('Locked', 'error')
        end

        while listening do
            local idle = 0

            if currentDoorId ~= newDoorId then
                currentDoorLockState = (DoorSystemGetDoorState(currentDoorId) ~= 0 and true or false)
                newDoorId = currentDoorId
            end

            if currentDoorLockState ~= newLockState then
                if #(GetOffsetFromEntityGivenWorldCoords(PlayerPedId(), currentDoorCoords)) <= 1.5 then
                    newLockState = currentDoorLockState
                    if hasAccess and not isHidden then
                        exports["warp-textui"]:showInteraction(("[E] %s"):format(newLockState and 'Locked' or 'Unlocked'), newLockState and 'error' or 'success')
                    else
                    end
                else
                    idle = 100
                end
            end

            if currentDoorId ~= nil and hasAccess and IsControlJustReleased(0, 38) and #(GetOffsetFromEntityGivenWorldCoords(PlayerPedId(), currentDoorCoords)) <= 1.2 then
                loadAnimDict("anim@heists@keycard@")
                TaskPlayAnim(PlayerPedId(), "anim@heists@keycard@", "exit", 8.0, 1.0, -1, 48, 0, 0, 0, 0)
                TriggerServerEvent("warp-doors:change-lock-state", currentDoorId, not currentDoorLockState)
            end

            Wait(idle)
        end

        exports["warp-textui"]:hideInteraction((not hasAccess or newLockState) and 'error' or 'success')
    end)
end

function AllowsKeyFob(pDoorId)
    if not doors[pDoorId] then return false end

    return doors[pDoorId]['keyFob'] == true
end

function GetTargetDoorId(pEntity)
    local activeDoors = DoorSystemGetActive()

    for _, activeDoor in pairs(activeDoors) do
        if activeDoor[2] == pEntity then
            return activeDoor[1]
        end
    end
end

exports('GetTargetDoorId', GetTargetDoorId)

local printEntityDetails = false
RegisterCommand("doors:print-entity", function()
    printEntityDetails = not printEntityDetails
end)

AddEventHandler("warp-target:inFront", function(pEntity, pEntityType, pEntityCoords)
    if pEntityType == nil or pEntityType ~= 3 then
        listening, currentDoorCoords, currentDoorId, currentDoorLockState = nil
        return
    end

    if printEntityDetails then
        print(pEntity, pEntityType, pEntityCoords, GetEntityModel(pEntity), GetEntityCoords(pEntity))
    end

    local doorId = GetTargetDoorId(pEntity)

    if printEntityDetails then
        print(doorId)
    end

    if (doorId) then
        currentDoorId = doorId
        currentDoorCoords = pEntityCoords

        if not listening then
            listenForKeypress()
        end
    end
end)



Citizen.CreateThread(function()
    while true do
        local idle = 250

        PlayerPed = PlayerPedId()
      
        local entity, entityType, entityCoords = exports['warp-targetinteract']:GetEntityPlayerIsLookingAt(3.0, 0.2, 286, PlayerPed)

        if entity and entityType ~= 0 then
            if entity ~= CurrentTarget then
                
                CurrentTarget = entity
             
                TriggerEvent('warp-target:inFront', CurrentTarget, entityType, entityCoords)
            end
        elseif CurrentTarget then
            CurrentTarget = nil
            TriggerEvent('warp-target:inFront', CurrentTarget)
        end

        Citizen.Wait(idle)
    end
end)

AddEventHandler("warp-doors:doorKeyFob", function()
    local doorId, isBollard = -1, false

    if currentZone ~= nil and bollards[currentZone].inside then
        doorId = bollards[currentZone].doorId
        isBollard = true
    else
        local entity = exports['warp-targetinteract']:GetEntityPlayerIsLookingAt(10.0, 2.0, 16)

        if not entity then
            return TriggerEvent("DoLongHudText","Door not found.",2)
        end
    
        if printEntityDetails then
            print(entity, GetEntityType(entity), GetEntityCoords(entity), GetEntityModel(entity), GetEntityCoords(entity))
        end
    
        doorId = GetTargetDoorId(entity)
    
        if printEntityDetails then
            print(doorId)
        end
    end


    if not doorId then
        return TriggerEvent("DoLongHudText","Door not found.",2)
    end

    if (not hasSecuredAccess(doorId, 'door') or not AllowsKeyFob(doorId)) then
        PlaySoundFromEntity(-1, "Keycard_Fail", PlayerPedId(), "DLC_HEISTS_BIOLAB_FINALE_SOUNDS", 1, 5.0);
        return TriggerEvent("DoLongHudText", "The key fob is not working for this door.",2)
    end

    local isLocked = (DoorSystemGetDoorState(doorId) ~= 0 and true or false)
    TriggerEvent('InteractSound_CL:PlayOnOne', 'GarageOpen', 0.3)
    -- PlaySoundFromEntity(-1, "Keycard_Success", PlayerPedId(), "DLC_HEISTS_BIOLAB_FINALE_SOUNDS", 1, 5.0);

    TriggerServerEvent("warp-doors:change-lock-state", doorId, isBollard and (not isLocked and 6 or 0) or (not isLocked))
end)

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("mrpd_bollards_01", vector3(411.66, -1027.95, 29.24), 7.8, 23.4, {
        heading=0,
        minZ=28.14,
        maxZ=32.14
    })
    exports["warp-polyzone"]:AddBoxZone("mrpd_bollards_02", vector3(411.66, -1020.09, 29.34), 7.8, 23.4, {
        heading=0,
        minZ=28.14,
        maxZ=32.14
    })
    TriggerServerEvent("warp-doors:request-lock-state")
end)

RegisterNetEvent("warp-doors:add")
AddEventHandler("warp-doors:add", function(pArgs, pEntity, pContext)
  if GetConvar("sv_environment", "prod") == "debug" then
    TriggerServerEvent("warp-door:add", GetEntityCoords(pEntity), GetEntityModel(pEntity))
  end
end)

AddEventHandler("warp-polyzone:enter", function(zone, data)
    if zone == "mrpd_bollards_01" or zone == "mrpd_bollards_02" then
        bollards[zone].inside = true
        currentZone = zone
    end
end)

AddEventHandler("warp-polyzone:exit", function(zone)
    if zone == "mrpd_bollards_01" or zone == "mrpd_bollards_02" then
        bollards[zone].inside = false
        currentZone = nil
    end
end)


-- GetUserInput function inspired by vMenu (https://github.com/TomGrobbe/vMenu/blob/master/vMenu/CommonFunctions.cs)
-- function GetUserInput(windowTitle, defaultText, maxInputLength)
--     -- Create the window title string.
--     local resourceName = string.upper(GetCurrentResourceName())
--     local textEntry = resourceName .. "_WINDOW_TITLE"
--     if windowTitle == nil then
--       windowTitle = "Enter:"
--     end
--     AddTextEntry(textEntry, windowTitle)
  
--     -- Display the input box.
--     DisplayOnscreenKeyboard(1, textEntry, "", defaultText or "", "", "", "", maxInputLength or 30)
--     Wait(0)
--     -- Wait for a result.
--     while true do
--       local keyboardStatus = UpdateOnscreenKeyboard();
--       if keyboardStatus == 3 then -- not displaying input field anymore somehow
--         return nil
--       elseif keyboardStatus == 2 then -- cancelled
--         return nil
--       elseif keyboardStatus == 1 then -- finished editing
--         return GetOnscreenKeyboardResult()
--       else
--         Wait(0)
--       end
--     end
--   end

-- local doorIndex = 0
-- local doorsCache = {}
-- RegisterCommand("door-next", function()
--     doorIndex = doorIndex + 1
--     local door = doors[doorIndex]
--     doorsCache[doorIndex] = door
--     doorsCache[doorIndex]["id"] = doorIndex
--     doorsCache[doorIndex]["access"] = {
--         job = { "PD" },
--         business = {},
--     }
--     doorsCache[doorIndex]["forceOpened"] = false
--     SetEntityCoords(PlayerPedId(), door.coords)

--     Wait(1000)
--     doorsCache[doorIndex]["desc"] = GetUserInput("Desc")
--     Wait(0)
--     doorsCache[doorIndex]["access"]["job"][#doorsCache[doorIndex]["access"]["job"] + 1] = GetUserInput("Job")
--     Wait(0)
--     doorsCache[doorIndex]["access"]["business"][#doorsCache[doorIndex]["access"]["business"] + 1] = GetUserInput("Business")
-- end)
-- -- RegisterCommand("door-desc", function(s, args)
-- --     doorsCache[doorIndex]["desc"] = args[1]
-- -- end)
-- -- RegisterCommand("door-business", function(s, args)
-- --     doorsCache[doorIndex]["access"]["business"][#doorsCache[doorIndex]["access"]["business"] + 1] = args[1]
-- -- end)
-- -- RegisterCommand("door-job", function(s, args)
-- --     doorsCache[doorIndex]["access"]["job"][#doorsCache[doorIndex]["access"]["job"] + 1] = args[1]
-- -- end)
-- RegisterCommand("door-print", function()
--     print(json.encode(doorsCache, { indent = true }))
-- end)
-- RegisterCommand("doors-save", function()
--     TriggerServerEvent("warp-doors:save-config", doorsCache)
-- end)



function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end