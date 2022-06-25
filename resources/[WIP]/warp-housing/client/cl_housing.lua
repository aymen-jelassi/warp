local display = false
local instash = 0
local inhouse = 0
local whcoords = 0
local housecoords = 0
local datarevhousing = {}

function string:split( inSplitPattern, outResults )
    if not outResults then
      outResults = { }
    end
    local theStart = 1
    local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
    while theSplitStart do
      table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
      theStart = theSplitEnd + 1
      theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
    end
    table.insert( outResults, string.sub( self, theStart ) )
    return outResults
end

Citizen.CreateThread(function()
    datarevhousing = RPC.execute("housing:getProperties")
    for k,v in pairs(datarevhousing) do
        local coordstring = v.coords
        local warehousecoord = coordstring:split(",")
        datarevhousing[k][1]= vector3(tonumber(warehousecoord[1]), tonumber(warehousecoord[2]), tonumber(warehousecoord[3])) 
        datarevhousing[k]["Street"] =  v.propertyname
        if v.cid ~= nil then
            datarevhousing[k]["assigned"] = false
        else
            datarevhousing[k]["assigned"] = true
        end
    end
end)    

function retriveHousingTable() 
	return datarevhousing
end

RegisterCommand('enterProperty', function()
    local availableWarehouses = RPC.execute("housing:getProperties")
    local closestDoorDistance, closestDoorId = 9999.9, -1
    local currentPos = GetEntityCoords(PlayerPedId())
    for k, v in pairs(availableWarehouses) do
        local coordstring = availableWarehouses[k].coords
        local warehousecoord = coordstring:split(",")
        local warehousecoords = vector3(tonumber(warehousecoord[1]), tonumber(warehousecoord[2]), tonumber(warehousecoord[3]))        
        local currentDoorDistance = #(warehousecoords - currentPos)
        if v and currentDoorDistance < closestDoorDistance then
            closestDoorDistance = currentDoorDistance
            closestDoorId = k
            if closestDoorId ~= -1 then
                local whdistance = 1
                if whdistance > closestDoorDistance then
                    if availableWarehouses[k].locked == 0 then
                        if availableWarehouses[k].propertycategory == "warehouse" then
                            secureWarehouseEnter(availableWarehouses[k], warehousecoords)
                        elseif availableWarehouses[k].propertycategory == "housing" then
                            secureHousingEnter(availableWarehouses[k], warehousecoords)
                        end
                    else
                        TriggerEvent("DoLongHudText", "Property Locked!", 2)
                    end
                end
            end
        end
    end
end)

function checkForProperty()
    local availableWarehouses = RPC.execute("housing:getProperties")
    local closestDoorDistance, closestDoorId = 9999.9, -1
    local currentPos = GetEntityCoords(PlayerPedId())
    for k, v in pairs(availableWarehouses) do
        local coordstring = availableWarehouses[k].coords
        local warehousecoord = coordstring:split(",")
        local warehousecoords = vector3(tonumber(warehousecoord[1]), tonumber(warehousecoord[2]), tonumber(warehousecoord[3]))
        --print(warehousecoords)
        local currentDoorDistance = #(warehousecoords - currentPos)
        if v and currentDoorDistance < closestDoorDistance then
            closestDoorDistance = currentDoorDistance
            closestDoorId = id
            if closestDoorId ~= -1 then
                local whdistance = 1
                if whdistance > closestDoorDistance then
                    return true, availableWarehouses[k].propertyname, availableWarehouses[k].propertyprice, availableWarehouses[k].propertycategory
                end
            end
        end
    end
end

function attemptPurchase()
    local availableWarehouses = RPC.execute("housing:getProperties")
    local closestDoorDistance, closestDoorId = 9999.9, -1
    local currentPos = GetEntityCoords(PlayerPedId())
    for k, v in pairs(availableWarehouses) do
        local coordstring = availableWarehouses[k].coords
        local warehousecoord = coordstring:split(",")
        local warehousecoords = vector3(tonumber(warehousecoord[1]), tonumber(warehousecoord[2]), tonumber(warehousecoord[3]))
        local currentDoorDistance = #(warehousecoords - currentPos)
        if v and currentDoorDistance < closestDoorDistance then
            closestDoorDistance = currentDoorDistance
            closestDoorId = id
            if closestDoorId ~= -1 then
                local whdistance = 1
                if whdistance > closestDoorDistance then
                        function propertyResult()
                           if availableWarehouses[k].propertysold == 1 then
                            print("propertyResult sold")
                            return "sold"
                           end
                           local propcid = exports["isPed"]:isPed("cid")
                           local propertycount = RPC.execute("housing:getPropertyCount", propcid)
                           if(propertycount >= 6) then
                           print("propertyResult too many properties")
                           return "toomany"
                           end
                           local playercid = exports["isPed"]:isPed("cid")
                           local bankbalance = RPC.execute("housing:getBankBalance", playercid)
                           print(bankbalance)
                           if availableWarehouses[k].propertyprice > bankbalance then
                            print("propertyResult notenough")
                            return "notenough"
                           end
                           local cid = exports["isPed"]:isPed("cid")
                           print(cid)
                           local buyResult = RPC.execute("housing:buyProperty", cid, availableWarehouses[k].id, availableWarehouses[k].propertyname, availableWarehouses[k].propertyprice)
                           if buyResult == "success" then
                            print("propertyResult success")
                            return "success"
                           end
                        end
                        local result = propertyResult()
                        local isPropSold = false
                        if availableWarehouses[k].propertysold == 1 then
                            isPropSold = true
                        else
                            isPropSold = false
                        end
                        if result == "success" then
                        print("result: success")
                        return "success", availableWarehouses[k].propertyname, isPropSold, true
                        elseif result == "sold" then
                        print("result: sold")
                        return "sold", availableWarehouses[k].propertyname, isPropSold, true
                        elseif result == "notenough" then
                        print("result: notenough")
                        return "notenough", availableWarehouses[k].propertyname, isPropSold, false
                        elseif result == "toomany" then
                        print("result: too many properties")
                        return "toomany", availableWarehouses[k].propertyname, isPropSold, false
                        end
                end
            end
        end
    end
end

function secureWarehouseEnter(closeststashid, coords)
    local metd = `ghost_stash_house_01`
    RequestModel(metd)
    while not HasModelLoaded(metd) do
        Citizen.Wait(0)
        print('no load')
    end
    warehouse = CreateObject(GetHashKey("ghost_stash_house_01"), tonumber(coords.x), tonumber(coords.y), -72.61, false, false, false)
    FreezeEntityPosition(warehouse, true)
    instash = closeststashid
    whcoords = coords
    isinstash = true
    local targetPed = GetPlayerPed(-1)
    if(IsPedInAnyVehicle(targetPed))then
    targetPed = GetVehiclePedIsUsing(targetPed)
    DoScreenFadeOut(1000)
    Wait(1000)
    SetEntityHeading(PlayerPedId(), 88.27)
    SetEntityCoordsNoOffset(targetPed, tonumber(coords.x) + 7, tonumber(coords.y) - 3.5, -72.0, 0, 0, 1)
    Wait(1000)
    DoScreenFadeIn(1000)
    else
    DoScreenFadeOut(1000)
    Wait(1000)
    SetEntityCoords(PlayerPedId(), tonumber(coords.x) + 7, tonumber(coords.y) - 3.5, -72.0)
    Wait(1000)
    DoScreenFadeIn(1000)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if isinstash == true then
            local curcid = exports["isPed"]:isPed("cid")
            --hasAccess bool set to true if CID and keys match
            --if hasAccess then
            if tonumber(curcid) == tonumber(instash.cid) then --check people who have keys
            local playerPos = GetEntityCoords(PlayerPedId())
            local targetPos = vector3(tonumber(whcoords.x) - 7.5, tonumber(whcoords.y) - 4.0, -72.00)
            local distance = #(playerPos - targetPos)
            if distance < 5 then
                DrawText3Ds(tonumber(whcoords.x) - 7.5, tonumber(whcoords.y) - 4.0, -72.00, '~g~E~w~ - open stash')
                if IsControlJustReleased(0, 38) then
                    local cid = exports["isPed"]:isPed("cid")
                    TriggerEvent("server-inventory-open", "1", 'warehouse-' .. instash.id)
                end
            end
            end
        else
            Wait(5000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if isinstash == true then
            local playerPos = GetEntityCoords(PlayerPedId())
            local targetPos = vector3(tonumber(whcoords.x) + 7, tonumber(whcoords.y) -3.5, -72.0)
            local distance = #(playerPos - targetPos)
            if distance < 5 then
                if IsControlJustReleased(0, 38) then
                    TriggerEvent("warp-housing:leave_warehouse")
                end
            end
        else
            Wait(2000)
        end
    end
end)

RegisterNetEvent('warp-housing:leave_warehouse')
AddEventHandler('warp-housing:leave_warehouse', function()
    local targetPed = GetPlayerPed(-1)
    if(IsPedInAnyVehicle(targetPed))then
    targetPed = GetVehiclePedIsUsing(targetPed)
    DoScreenFadeOut(1000)
    Wait(1000)
    SetEntityCoordsNoOffset(targetPed, tonumber(whcoords.x), tonumber(whcoords.y), tonumber(whcoords.z), -53.0, 0, 0, 1)
    Wait(1000)
    DoScreenFadeIn(1000)
    else
    DoScreenFadeOut(1000)
    Wait(1000)
    SetEntityCoords(PlayerPedId(), tonumber(whcoords.x), tonumber(whcoords.y), tonumber(whcoords.z))
    secureWareHouseleave()
    Wait(1000)
    DoScreenFadeIn(1000)
    end
end)

function secureWareHouseleave()
    isinstash = false
    DeleteObject(warehouse)
    FreezeEntityPosition(warehouse, false)
end

function secureHousingEnter(closesthouseid, housingcoords)
    local metd = closesthouseid.shell
    RequestModel(metd)
    while not HasModelLoaded(metd) do
        Citizen.Wait(0)
        print('no load')
    end
    houseshell = CreateObject(GetHashKey(closesthouseid.shell), tonumber(housingcoords.x), tonumber(housingcoords.y), -72.61, false, false, false)
    FreezeEntityPosition(houseshell, true)
    inhouse = closesthouseid
    housecoords = housingcoords
    isinhouse = true
    local targetPed = GetPlayerPed(-1)
    if(IsPedInAnyVehicle(targetPed))then
    targetPed = GetVehiclePedIsUsing(targetPed)
    DoScreenFadeOut(1000)
    Wait(1000)
    SetEntityHeading(PlayerPedId(), 181.8563)
    SetEntityCoordsNoOffset(targetPed, tonumber(housingcoords.x) + 7, tonumber(housingcoords.y) + 0.1, -71.0, 0, 0, 1)
    Wait(1000)
    DoScreenFadeIn(1000)
    else
    DoScreenFadeOut(1000)
    Wait(1000)
    SetEntityCoords(PlayerPedId(), tonumber(housingcoords.x) + 7, tonumber(housingcoords.y) + 0.1, -71.0)
    Wait(1000)
    DoScreenFadeIn(1000)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if isinhouse == true then
            local playerPos = GetEntityCoords(PlayerPedId())
            local targetPos = vector3(tonumber(housecoords.x) + 5, tonumber(housecoords.y) + 5, -72.0)
            local distance = #(playerPos - targetPos)
            if distance <= 1.0 then
                DrawText3Ds(tonumber(housecoords.x) + 5, tonumber(housecoords.y) + 5, -72.0, '~g~E~w~ - open stash')
                if IsControlJustReleased(0, 38) then
                    local cid = exports["isPed"]:isPed("cid")
                    TriggerEvent("server-inventory-open", "1", 'house-' .. inhouse.id)
                end
            end
        else
            Wait(5000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if isinhouse == true then
            local playerPos = GetEntityCoords(PlayerPedId())
            local targetPos = vector3(tonumber(housecoords.x) + 7, tonumber(housecoords.y) + 0.1, -71.0)
            local distance = #(playerPos - targetPos)
            if distance <= 2.0 then
                if IsControlJustReleased(0, 38) then
                    TriggerEvent("warp-housing:leaveHousing")
                end
            end
        else
            Wait(2000)
        end
    end
end)

RegisterNetEvent('warp-housing:leaveHousing')
AddEventHandler('warp-housing:leaveHousing', function()
    local targetPed = GetPlayerPed(-1)
    if(IsPedInAnyVehicle(targetPed))then
    targetPed = GetVehiclePedIsUsing(targetPed)
    DoScreenFadeOut(1000)
    Wait(1000)
    SetEntityCoordsNoOffset(targetPed, tonumber(housecoords.x), tonumber(housecoords.y), tonumber(housecoords.z), -53.0, 0, 0, 1)
    Wait(1000)
    DoScreenFadeIn(1000)
    else
    DoScreenFadeOut(1000)
    Wait(1000)
    SetEntityCoords(PlayerPedId(), tonumber(housecoords.x), tonumber(housecoords.y), tonumber(housecoords.z))
    secureHousingleave()
    Wait(1000)
    DoScreenFadeIn(1000)
    end
end)

function secureHousingleave()
    isinhouse = false
    DeleteObject(houseshell)
    FreezeEntityPosition(houseshell, false)
end

-- Housing --

function DrawText3Ds(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end

Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
    end
end)

RegisterCommand('addproperty', function(source,args)
    local plycoords = GetEntityCoords(PlayerPedId())
    local propertyname = args[3]
    local propertyprice = args[2]
    local propertycategory = args[1]
    local result = RPC.execute("housing:addProperty", propertyname, propertyprice, propertycategory, plycoords.x, plycoords.y, plycoords.z)
    if result then
        TriggerEvent("DoLongHudText", "Successfully added property!", 1)
    else
        TriggerEvent("DoLongHudText", "Error adding property.", 2)
    end

end)

RegisterCommand('resetproperty', function(source,args)
    local propertyid = args[1]
    RPC.execute("housing:resetProperty", propertyid)
end)

-- Chat suggestion
Citizen.CreateThread(function()
    TriggerEvent("chat:addSuggestion", "/addproperty", "Add a property!", {
        {name = "category", help = "Property Category"},
        {name = "price", help = "Property Price"}
    })
end)

RegisterKeyMapping('enterProperty', 'Enter', 'keyboard', 'e')

RegisterNetEvent("housing:playerSpawned")
AddEventHandler("housing:playerSpawned", function(pSpawnInfo)
    print(json.encode(pSpawnInfo))
    if datarevhousing then
        for k,v in pairs(datarevhousing) do
            if v.Street == pSpawnInfo then
                if v.propertycategory == "warehouse" then
                    secureWarehouseEnter(v, v[1])
                elseif v.propertycategory == "housing" then
                    secureHousingEnter(v, v[1])
                end
            end

        end
    end
end)