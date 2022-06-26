local PeekEntries = { ['model'] = {}, ['flag'] = {}, ['entity'] = {}, ['polytarget'] = {} }

CurrentZones, CurrentTarget, CurrentTargetType, IsPeeking, IsPeakActive, NearZones = {}, nil, nil, false, false, {}

EntryCount, ListCount, UpdateRequired, RefreshingList = 0, 0, false, false

local enableWorldPrompts = true

local function convertNpcIds(npcIds)
    if npcIds == nil then return nil end
    local idHashes = {}
    for i=1, #npcIds do
        idHashes[i] = GetHashKey(npcIds[i])
    end
    return idHashes
end

local function hasNpcId(entity, npcIds)
    if npcIds == nil then return true end
    for i=1, #npcIds do
        if DecorGetInt(entity, "NPC_ID") == npcIds[i] then
            return true
        end
    end
    return false
end

function AddPeekEntry(pType, pGroup, pData, pOptions)
    local entries = PeekEntries[pType]

    if not entries then return error(pType .. ' Is not a valid Peek Type') end

    local addEntry = function(group, data, options)
        options.npcIds = convertNpcIds(options.npcIds)
        if not entries[group] then entries[group] = {} end

        local groupEntries = entries[group]

        for _, entry in ipairs(data) do
            if not entry.id then error('Missing ID in entry for '.. group) end

            EntryCount = EntryCount + 1

            entry.index = EntryCount

            groupEntries[entry.id] = { data = entry, options = options }
        end
    end

    if type(pGroup) ~= 'table' then
        addEntry(pGroup, pData, pOptions)
        return RefreshPeekList()
    end

    for _, group in ipairs(pGroup) do
        addEntry(group, pData, pOptions)
    end

    RefreshPeekList()
end

exports('AddPeekEntry', AddPeekEntry)

function AddPeekEntryByModel(pModel, pData, pOptions)
    AddPeekEntry('model', pModel, pData, pOptions)
end

exports('AddPeekEntryByModel', AddPeekEntryByModel)

function AddPeekEntryByFlag(pFlag, pData, pOptions)
    AddPeekEntry('flag', pFlag, pData, pOptions)
end

exports('AddPeekEntryByFlag', AddPeekEntryByFlag)

function AddPeekEntryByEntityType(pEntityType, pData, pOptions)
    AddPeekEntry('entity', pEntityType, pData, pOptions)
end

exports('AddPeekEntryByEntityType', AddPeekEntryByEntityType)

function AddPeekEntryByPolyTarget(pEvent, pData, pOptions)
    AddPeekEntry('polytarget', pEvent, pData, pOptions)
end

exports('AddPeekEntryByPolyTarget', AddPeekEntryByPolyTarget)

function RefreshPeekList()
    if RefreshingList then return end

    RefreshingList = true

    Citizen.SetTimeout(250, function()
        local entries = {}

        for _, groups in pairs(PeekEntries) do
            for _, group in pairs(groups) do
                for id, entry in pairs(group) do
                    entries[id] = entry.data
                end
            end
        end

        RefreshingList = false

        exports["warp-ui"]:sendAppEvent('eye', {
            action = "refresh",
            payload = entries or {}
        })
    end)
end

function UpdatePeekEntryList(pEntries)
    local active = IsActive(pEntries)

    if not IsPeakActive and active then
        IsPeakActive = true
    elseif IsPeakActive and not active then
        IsPeakActive = false
    end

    exports["warp-ui"]:sendAppEvent('eye', {
        action = "update",
        payload = { active = IsPeakActive, options = pEntries }
    })
end

function GetCurrentPeekEntryList()
    local entity, context = CurrentTarget, GetEntityContext(CurrentTarget)

    ListCount = ListCount + 1

    local listId, entries, tracked = ListCount, {}, {}

    local addEntry = function(pId, pEntry, pContext, pRelated)
        local data, options = pEntry.data, pEntry.options

        if options.job then
            local hasJob = false

            for _, job in ipairs(options.job) do
                if job == exports["isPed"]:isPed("myJob") or job == exports["isPed"]:isPed("myJob") then
                    hasJob = true
                    break
                end
            end

            if not hasJob then return end
        end

        if options.business then
            local isEmployed = false
            local cid = exports["isPed"]:isPed("cid")
            for _, business in ipairs(options.business) do
                local IsEmployedAt = RPC.execute("IsEmployedAt", business)
                if IsEmployedAt then
                    if options.permission then
                        local perm = options.permission
                        local hasPermission = RPC.execute("mizrp-business:business:hasPermission", business, perm)
                        if hasPermission then
                            isEmployed = true
                            break
                        end
                    else
                    isEmployed = true
                    break
                    end
                end
            end

            if not isEmployed then return end
        end

        if options.npcIds then
            if not hasNpcId(entity, options.npcIds) then return end
        end

        local hasChecks = options.isEnabled or options.distance

        entries[pId] = not hasChecks

        if not hasChecks then return end

        if options.distance and pContext.zones[pRelated] then
            options.distance.zone = pRelated
        end

        tracked[pId] = options
    end

    if CurrentTarget then
        if PeekEntries['model'][context.model] then
            for id, entry in pairs(PeekEntries['model'][context.model]) do
                addEntry(id, entry, context, entity)
            end
        end

        for flag, active in pairs(context.flags) do
            if active and PeekEntries['flag'][flag] then
                for id, entry in pairs(PeekEntries['flag'][flag]) do
                    addEntry(id, entry, context, entity)
                end
            end
        end

        if PeekEntries['entity'][context.type] then
            for id, entry in pairs(PeekEntries['entity'][context.type]) do
                addEntry(id, entry, context, entity)
            end
        end
    end

    for zoneName, zone in pairs(CurrentZones) do
        if zone then
            context.zones[zoneName] = zone.data

            if PeekEntries['polytarget'][zoneName] then
                for id, entry in pairs(PeekEntries['polytarget'][zoneName]) do
                    addEntry(id, entry, context, zoneName)
                end
            end
        end
    end

    StartTrackerThread(listId, entries, tracked, context)

    return entries, context
end

function StartTrackerThread(pTrackerId, pEntries, pTracked, pContext)
    local entity = CurrentTarget or 0
    local playerPed = PlayerPedId()

    local bones, normal, zones = {}, {}, {}

    local entries, updateRequired = pEntries, true

    for id, options in pairs(pTracked) do
        local distance = options.distance

        local visible, callbacks = false, normal

        if distance and distance.boneId then
            local bone = distance.boneId
            local boneIndex = type(bone) == 'string' and GetEntityBoneIndexByName(entity, bone) or GetPedBoneIndex(entity, bone)

            if not bones[boneIndex] then bones[boneIndex] = {} end

            callbacks = bones[boneIndex]
        elseif distance and distance.zone then
            if not zones[distance.zone] then zones[distance.zone] = {} end

            callbacks = zones[distance.zone]
        end

        callbacks[#callbacks + 1] = function(pDistance)
            local inRange = not distance or pDistance <= distance.radius
            local isEnabled = inRange and (not options.isEnabled or options.isEnabled(entity, pContext))

            if inRange and isEnabled and not visible then
                visible = true
                updateRequired = true
                entries[id] = true
            elseif not inRange or not isEnabled and visible then
                visible = false
                updateRequired = true
                entries[id] = false
            end
        end
    end

    Citizen.CreateThread(function()
        while IsPeeking and ListCount == pTrackerId do
            local playerCoords = GetEntityCoords(playerPed)

            if entity then
                for boneIndex, callbacks in pairs(bones) do
                    local targetCoords = GetWorldPositionOfEntityBone(entity, boneIndex)
                    local targetDistance = #(playerCoords - targetCoords)

                    for _, callback in ipairs(callbacks) do
                        callback(targetDistance)
                    end
                end

                if #normal > 0 then
                    local targetCoords = GetEntityCoords(entity)
                    local targetDistance = #(playerCoords - targetCoords)

                    for _, callback in ipairs(normal) do
                        callback(targetDistance)
                    end
                end
            end

            for zoneId, callbacks in pairs(zones) do
                local zone = CurrentZones[zoneId]
                local targetDistance = not zone and 9999.9 or #(playerCoords - zone.vectors)

                for _, callback in ipairs(callbacks) do
                    callback(targetDistance)
                end
            end

            if updateRequired then
                updateRequired = false
                UpdatePeekEntryList(entries)
            end

            if enableWorldPrompts then
                FindNearestZones(playerCoords, 3, entity, pContext)
            end
            Citizen.Wait(150)
        end
    end)
end

function FindNearestZones(playerCoords, count, entity, context)
    NearZones = {}

    local function checkIsEnabled(zone)
        local peekEntries = PeekEntries['polytarget'][zone.name]
        local isEnabled = not peekEntries
        if peekEntries then
            for id,entry in pairs(peekEntries) do
                isEnabled = isEnabled or (not entry.options.isEnabled or entry.options.isEnabled(entity, context))
            end
        end
        return isEnabled
    end

    -- Add `CurrentZones` to `NearZones` first
    for _, zone in ipairs(nearbyZones) do
        local currentZone = CurrentZones[zone.name]
        if currentZone and currentZone.vectors == zone.center and checkIsEnabled(zone) then
            NearZones[#NearZones+1] = {
                id = zone.id,
                center = zone.center,
                active = true,
                dist = #(playerCoords - zone.center),
                opacity = 255
            }
        end
    end

    -- Filter `nearbyZones` to all zones that are not in `CurrentZones` and are closer than 10.0 units from the player
    -- and sort them by their distance to the player
    local sortedNearbyZones = Array(nearbyZones)
        :Filter(function (zone)
            local currentZone = CurrentZones[zone.name]
            zone.distanceToPlayer = #(playerCoords - zone.center)
            return (currentZone == nil or currentZone.vectors ~= zone.center) and zone.distanceToPlayer < 10.0 and checkIsEnabled(zone)
        end)
        :Sort(-1, function (a, b) return (a.distanceToPlayer - b.distanceToPlayer) > 0 end)

    -- Until `NearZones` has `count` number of zones, keep popping zones off the end of `sortedNearbyZones`
    while #NearZones < count and not sortedNearbyZones:isEmpty() do
        local zone = sortedNearbyZones:Pop()
        NearZones[#NearZones+1] = {
            id = zone.id,
            center = zone.center,
            active = false,
            dist = zone.distanceToPlayer,
            opacity = 200
        }
    end
end

function IsActive(pEntries)
    if not pEntries then return end

    for _, active in pairs(pEntries) do
        if active then return true end
    end

    return false
end

function StartPeekin()
    if IsPeeking then return end
    if IsPedArmed(PlayerPedId(), 6) then return end

    local entries, context

    IsPeeking = true
    UpdateRequired = true

    NearZones = {}
    nearbyZones = exports["warp-polytarget"]:GetZones(GetEntityCoords(PlayerPedId())) or {}

    Citizen.CreateThread(function()
        local rgbGreen, rgbWhite = {208, 16, 230}, {255, 255, 255}
        local previousZones = {}
        local drawingZones = {}
        local lastUpdate = GetGameTimer()

        RequestStreamedTextureDict("shared")
        while IsPeeking do
            DisablePlayerFiring(PlayerPedId(), true)

            if UpdateRequired then
                UpdateRequired = false
                entries, context = GetCurrentPeekEntryList()
            end

            if IsPeakActive and (IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24)) then
                SetCursorLocation(0.5, 0.5)

                exports["warp-ui"]:openApplication("eye", {
                    action = "interact",
                    payload = { active = true, display = true, context = context, entity = CurrentTarget }
                })
            end

            if enableWorldPrompts then
                local activeZones, nearZoneLookup = {}, {}

                -- Insert all `NearZones` that aren't already being drawn into `drawingZones`
                for _, zone in ipairs(NearZones) do
                    nearZoneLookup[zone.id] = true
                    if zone.active then activeZones[zone.id] = true end
                    if not drawingZones[zone.id] then
                        drawingZones[zone.id] = { zone = zone, type = "in", fade = 0 }
                    end
                end

                -- Insert all `previousZones` that aren't in `NearZones` and aren't already being drawn (or whose fade type == 'in') into `drawingZones`
                for _, zone in ipairs(previousZones) do
                    local inNear = nearZoneLookup[zone.id]
                    if not inNear and (not drawingZones[zone.id] or drawingZones[zone.id].type == "in") then
                        drawingZones[zone.id] = { zone = zone, type = "out", fade = 100 }
                    end
                end

                -- Draw prompts for all zones in `drawingZones`
                local currentTime = GetGameTimer()
                for id, fz in pairs(drawingZones) do
                    local isActive = activeZones[fz.zone.id] ~= nil
                    local opacity = map_range(fz.fade, 0, 100, 0, isActive and 255 or 200)
                    if fz.type == "in" then
                        fz.fade = math.min(fz.fade + 0.15 * (currentTime - lastUpdate), 100)
                    elseif fz.type == "out" then
                        fz.fade = math.max(fz.fade - 0.15 * (currentTime - lastUpdate), 0)
                        if fz.fade == 0 then drawingZones[id] = nil end
                    end

                    SetDrawOrigin(fz.zone.center, 0)
                    local rgb = isActive and rgbGreen or rgbWhite
                    DrawSprite("shared", "emptydot_32", 0, 0, 0.02, 0.035, 0, rgb[1], rgb[2], rgb[3], math.floor(opacity + 0.5))
                    ClearDrawOrigin()
                end

                lastUpdate = currentTime
                previousZones = {table.unpack(NearZones)}
            end

            Citizen.Wait(0)
        end
    end)

    exports["warp-ui"]:sendAppEvent('eye', { action = "peek", payload = { display = true, active = false } })
end

function StopPeekin()
    if not IsPeeking then return end
    if not IsPeakActive then
        IsPeeking = false

        exports["warp-ui"]:sendAppEvent('eye', {
            action = "peek",
            payload = { display = false, active = false }
        })
    end
end

RegisterNetEvent('warp-interact:ResetUI')
AddEventHandler('warp-interact:ResetUI', function()
    IsPeeking = false

    exports["warp-ui"]:sendAppEvent('eye', {
        action = "peek",
        payload = { display = false, active = false }
    })
end)

RegisterNetEvent('warp-interact:detali')
AddEventHandler('warp-interact:detali', function()
    IsPeeking = false
    -- exports["tp-ui"]:closeApplication("eye")
    exports["warp-ui"]:sendAppEvent('eye', {
        action = "peek",
        payload = { display = false, active = false}
    })
end)

function CanSellOrBuyCar(pEntity, pSell)
  local vehicleOwner = getVehicleOwner(pEntity)

  if pSell and vehicleOwner == 2 then return true end
  if not pSell and vehicleOwner ~= 2 and vehicleOwner ~= -1 then return true end

  return false
end


AddEventHandler("drp:target:changed", function(pTarget, pEntityType, pEntityOffset)
    CurrentTarget = pTarget
    CurrentTargetType = pEntityType
    CurrentTargetOffset = pEntityOffset

    UpdateRequired = true
end)

AddEventHandler('warp-polyzone:enter', function(zoneName, zoneData, zoneCenter)
    if not PeekEntries['polytarget'][zoneName] then return end

    CurrentZones[zoneName] = { data = zoneData, vectors = zoneCenter }

    if not IsPeeking then return end

    UpdateRequired = true
end)

AddEventHandler('warp-polyzone:exit', function(zoneName)
    if not PeekEntries['polytarget'][zoneName] then return end

    CurrentZones[zoneName] = nil

    UpdateRequired = true
end)

RegisterUICallback("warp-ui:targetSelectOption", function(data, cb)
    cb({ data = {}, meta = { ok = true, message = 'done' } })

    IsPeeking = false

    exports["warp-ui"]:closeApplication("eye")

    Wait(100)

    local option = data.option
    local context = data.context or {}

    local event = option.event
    local target = CurrentTarget or 0
    local parameters = option.parameters or {}

    TriggerEvent(event, parameters, target, context)
end)

AddEventHandler('warp-ui:phoneReady', function()
    RefreshPeekList()
end)

RegisterCommand('+targetInteract', StartPeekin, false)

RegisterCommand('-targetInteract', StopPeekin, false)

Citizen.CreateThread(function()
    exports["warp-binds"]:registerKeyMapping("", "Player", "Peek at Target", "+targetInteract", "-targetInteract", "LMENU")
end)

function map_range(s, a1, a2, b1, b2)
    return b1 + (s - a1) * (b2 - b1) / (a2 - a1)
end

AddEventHandler("mizrp-preferences:setPreferences", function(data)
    enableWorldPrompts = not data["interact.disablePrompts"]
end)

exports('IsPeeking', function() return IsPeeking end)

-- Shit

RegisterNetEvent("warp-emsjob:cabinet")
AddEventHandler("warp-emsjob:cabinet", function()
    TriggerEvent("server-inventory-open", "47", "Shop");
end)

RegisterNetEvent("warp-foodchain:pickupPrompt")
AddEventHandler("warp-foodchain:pickupPrompt", function()
    TriggerEvent("server-inventory-open", "1", "burgerjob_counter");
end)

RegisterNetEvent("warp-foodchain:shelfPrompt")
AddEventHandler("warp-foodchain:shelfPrompt", function()
    TriggerEvent("server-inventory-open", "1", "burgerjob_shelf");
end)

RegisterNetEvent("warp-casinocounter:pickupPrompt")
AddEventHandler("warp-casinocounter:pickupPrompt", function()
    TriggerEvent("server-inventory-open", "1", "membership_counter");
end)

RegisterNetEvent("warp-artcounter:pickupPrompt")
AddEventHandler("warp-artcounter:pickupPrompt", function()
    TriggerEvent("server-inventory-open", "1", "art_counter");
end)

RegisterNetEvent("warp-vu:pickupPrompt1")
AddEventHandler("warp-vu:pickupPrompt1", function()
    TriggerEvent("server-inventory-open", "1", "vu_pickup1")
end)

RegisterNetEvent("warp-vu:pickupPrompt2")
AddEventHandler("warp-vu:pickupPrompt2", function()
    TriggerEvent("server-inventory-open", "1", "vu_pickup2")
end)

RegisterNetEvent("warp-casino:barPickup1")
AddEventHandler("warp-casino:barPickup1", function()
    TriggerEvent("server-inventory-open", "1", "casino_barPickup1")
end)

RegisterNetEvent("warp-casino:barPickup2")
AddEventHandler("warp-casino:barPickup2", function()
    TriggerEvent("server-inventory-open", "1", "casino_barPickup2")
end)

RegisterNetEvent("warp-casino:barPickup3")
AddEventHandler("warp-casino:barPickup3", function()
    TriggerEvent("server-inventory-open", "1", "casino_barPickup3")
end)

RegisterNetEvent("warp-pearls:tablePickup1")
AddEventHandler("warp-pearls:tablePickup1", function()
    TriggerEvent("server-inventory-open", "1", "pearls_tablePickup1")
end)

RegisterNetEvent("warp-pearls:tablePickup2")
AddEventHandler("warp-pearls:tablePickup2", function()
    TriggerEvent("server-inventory-open", "1", "pearls_tablePickup2")
end)

RegisterNetEvent("warp-pearls:tablePickup3")
AddEventHandler("warp-pearls:tablePickup3", function()
    TriggerEvent("server-inventory-open", "1", "pearls_tablePickup3")
end)

RegisterNetEvent("warp-pearls:tablePickup4")
AddEventHandler("warp-pearls:tablePickup4", function()
    TriggerEvent("server-inventory-open", "1", "pearls_tablePickup4")
end)

RegisterNetEvent("warp-pearls:tablePickup5")
AddEventHandler("warp-pearls:tablePickup5", function()
    TriggerEvent("server-inventory-open", "1", "pearls_tablePickup5")
end)

RegisterNetEvent("warp-pearls:tablePickup6")
AddEventHandler("warp-pearls:tablePickup6", function()
    TriggerEvent("server-inventory-open", "1", "pearls_tablePickup6")
end)

RegisterNetEvent("warp-pearls:tablePickup7")
AddEventHandler("warp-pearls:tablePickup7", function()
    TriggerEvent("server-inventory-open", "1", "pearls_tablePickup7")
end)

RegisterNetEvent("warp-pearls:tablePickup8")
AddEventHandler("warp-pearls:tablePickup8", function()
    TriggerEvent("server-inventory-open", "1", "pearls_tablePickup8")
end)

RegisterNetEvent("warp-pearls:tablePickup9")
AddEventHandler("warp-pearls:tablePickup9", function()
    TriggerEvent("server-inventory-open", "1", "pearls_tablePickup9")
end)

RegisterNetEvent("warp-pearls:tablePickup10")
AddEventHandler("warp-pearls:tablePickup10", function()
    TriggerEvent("server-inventory-open", "1", "pearls_tablePickup10")
end)

RegisterNetEvent("warp-pearls:tablePickup11")
AddEventHandler("warp-pearls:tablePickup11", function()
    TriggerEvent("server-inventory-open", "1", "pearls_tablePickup11")
end)

RegisterNetEvent("warp-pearls:tablePickup12")
AddEventHandler("warp-pearls:tablePickup12", function()
    TriggerEvent("server-inventory-open", "1", "pearls_tablePickup12")
end)

RegisterNetEvent("warp-pearls:tablePickup13")
AddEventHandler("warp-pearls:tablePickup13", function()
    TriggerEvent("server-inventory-open", "1", "pearls_tablePickup13")
end)

RegisterNetEvent("warp-aod-AODTable1")
AddEventHandler("warp-aod-AODTable1", function()
    TriggerEvent("server-inventory-open", "1", "AOD Bar")
end)

RegisterNetEvent("warp-ugCasino:barPickup")
AddEventHandler("warp-ugCasino:barPickup", function()
    TriggerEvent("server-inventory-open", "1", "UG_barPickup")
end)

RegisterNetEvent("warp-jobs:BurgerShotTray-1")
AddEventHandler("warp-jobs:BurgerShotTray-1", function()
    TriggerEvent("server-inventory-open", "1", "burgerjob_counter_1");
end)

RegisterNetEvent("warp-jobs:BurgerShotTray-2")
AddEventHandler("warp-jobs:BurgerShotTray-2", function()
    TriggerEvent("server-inventory-open", "1", "burgerjob_counter_2");
end)

RegisterNetEvent("warp-jobs:BurgerShotTray-3")
AddEventHandler("warp-jobs:BurgerShotTray-3", function()
    TriggerEvent("server-inventory-open", "1", "burgerjob_counter_3");
end)

RegisterNetEvent("warp-jobs:BurgerShotTray-4")
AddEventHandler("warp-jobs:BurgerShotTray-4", function()
    TriggerEvent("server-inventory-open", "1", "burgerjob_counter_4");
end)

RegisterNetEvent("warp-jobs:in-n-out_tray")
AddEventHandler("warp-jobs:in-n-out_tray", function()
    TriggerEvent("server-inventory-open", "1", "in-n-out");
end)

RegisterNetEvent("warp-jobs:in-n-out_storage")
AddEventHandler("warp-jobs:in-n-out_storage", function()
    TriggerEvent("server-inventory-open", "1", "in-n-out_storage");
end)

RegisterNetEvent("warp-jobs:UwUCafe-1")
AddEventHandler("warp-jobs:UwUCafe-1", function()
    TriggerEvent("server-inventory-open", "1", "UwUCafe_counter_1");
end)

RegisterNetEvent("warp-jobs:UwUCafe-2")
AddEventHandler("warp-jobs:UwUCafe-2", function()
    TriggerEvent("server-inventory-open", "1", "UwUCafe_counter_2");
end)

--// Maldinis

RegisterNetEvent("warp-jobs:maldinis-1")
AddEventHandler("warp-jobs:maldinis-1", function()
    TriggerEvent("server-inventory-open", "1", "maldinis-table-1");
end)

RegisterNetEvent("warp-jobs:maldinis-2")
AddEventHandler("warp-jobs:maldinis-2", function()
    TriggerEvent("server-inventory-open", "1", "maldinis-table-2");
end)

RegisterNetEvent("warp-jobs:maldinis-3")
AddEventHandler("warp-jobs:maldinis-3", function()
    TriggerEvent("server-inventory-open", "1", "maldinis-table-3");
end)

RegisterNetEvent("warp-jobs:maldinis-4")
AddEventHandler("warp-jobs:maldinis-4", function()
    TriggerEvent("server-inventory-open", "1", "maldinis-table-4");
end)

RegisterNetEvent("warp-jobs:maldinis-5")
AddEventHandler("warp-jobs:maldinis-5", function()
    TriggerEvent("server-inventory-open", "1", "maldinis-table-5");
end)

RegisterNetEvent("warp-jobs:maldinis-6")
AddEventHandler("warp-jobs:maldinis-6", function()
    TriggerEvent("server-inventory-open", "1", "maldinis-table-6");
end)

RegisterNetEvent("warp-jobs:maldinis-7")
AddEventHandler("warp-jobs:maldinis-7", function()
    TriggerEvent("server-inventory-open", "1", "maldinis-table-7");
end)

RegisterNetEvent("warp-jobs:maldinis-8")
AddEventHandler("warp-jobs:maldinis-8", function()
    TriggerEvent("server-inventory-open", "1", "maldinis-table-8");
end)

RegisterNetEvent("warp-jobs:maldinis-9")
AddEventHandler("warp-jobs:maldinis-9", function()
    TriggerEvent("server-inventory-open", "1", "maldinis-table-9");
end)

RegisterNetEvent("warp-jobs:maldinis-10")
AddEventHandler("warp-jobs:maldinis-10", function()
    TriggerEvent("server-inventory-open", "1", "maldinis-table-10");
end)

RegisterNetEvent("warp-jobs:maldinis-11")
AddEventHandler("warp-jobs:maldinis-11", function()
    TriggerEvent("server-inventory-open", "1", "maldinis-table-11");
end)

RegisterNetEvent("warp-jobs:maldinis-12")
AddEventHandler("warp-jobs:maldinis-12", function()
    TriggerEvent("server-inventory-open", "1", "maldinis-table-12");
end)


-----Humane Lab ---------------------------

RegisterNetEvent('humane:lowerFloorTp')
AddEventHandler('humane:lowerFloorTp', function()
  DoScreenFadeOut(1)
  Citizen.Wait(100)
  SetEntityCoords(PlayerPedId(),3540.403, 3674.875, 20.9918)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

RegisterNetEvent('humane:upperFloorTp')
AddEventHandler('humane:upperFloorTp', function()
  DoScreenFadeOut(1)
  Citizen.Wait(100)
  SetEntityCoords(PlayerPedId(),3540.722, 3675.159, 28.12114)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

-----FIB building ---------------------------

RegisterNetEvent('fib:47FloorTp')
AddEventHandler('fib:47FloorTp', function()
  DoScreenFadeOut(1)
  Citizen.Wait(100)
  SetEntityCoords(PlayerPedId(),136.2636, -761.9683, 234.152)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

RegisterNetEvent('fib:GroundFloorTp')
AddEventHandler('fib:GroundFloorTp', function()
    DoScreenFadeOut(1)
    Citizen.Wait(100)
    SetEntityCoords(PlayerPedId(),136.1349, -761.8865, 45.75204)
    DoScreenFadeIn(1000)
    Citizen.Wait(1000)
end)

--------- Maze building ----------------------------

RegisterNetEvent('maze:RoofTp')
AddEventHandler('maze:RoofTp', function()
  DoScreenFadeOut(1)
  Citizen.Wait(100)
  SetEntityCoords(PlayerPedId(),-75.1, -824.79, 321.29)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

RegisterNetEvent('maze:GroundFloorTp')
AddEventHandler('maze:GroundFloorTp', function()
  DoScreenFadeOut(1)
  Citizen.Wait(100)
  SetEntityCoords(PlayerPedId(),-83.93, -823.77, 36.03)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

--------- Recycle building ----------------------------

RegisterNetEvent('recycle:OutsideTP')
AddEventHandler('recycle:OutsideTP', function()
  DoScreenFadeOut(1)
  Citizen.Wait(100)
  SetEntityCoords(PlayerPedId(),746.7163, -1399.731, 26.59665)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

RegisterNetEvent('recycle:InsideTP')
AddEventHandler('recycle:InsideTP', function()
  DoScreenFadeOut(1)
  Citizen.Wait(100)
  SetEntityCoords(PlayerPedId(),1026.828, -3101.091, -38.99987)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)