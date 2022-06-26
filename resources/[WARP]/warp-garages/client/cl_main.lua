RegisterNetEvent("warp-garages:open")
AddEventHandler("warp-garages:open", function()
    local pJob = exports["isPed"]:isPed("myJob")
    local pGarage = exports['warp-menu']:currentGarage()
    RPC.execute("warp-garages:selectMenu", pGarage, pJob)
end)

RegisterNetEvent("warp-garages:openSharedGarage")
AddEventHandler("warp-garages:openSharedGarage", function()
    local pJob = exports["isPed"]:isPed("myJob")
    exports['warp-garages']:DeleteViewedCar()
    RPC.execute("warp-garages:selectSharedGarage", exports['warp-menu']:currentGarage(), pJob)
end)

exports("fake", function(p_type, plate_number)
    if p_type == "active" then
        isActive = RPC.execute('warp-garages:fake:plate:data', "active", plate_number)
        return isActive
    elseif p_type == "real_plate" then
        real_plate_from_fake = RPC.execute('warp-garages:fake:plate:data', "real_plate", plate_number)
        return real_plate_from_fake
    elseif p_type == "update" then
        real_plate_from_fake = RPC.execute('warp-garages:fake:plate:data', "real_plate", plate_number)
        if real_plate_from_fake == nil then
            TriggerServerEvent("vehicleMod:getHarness", plate_number)
        else
            TriggerServerEvent("vehicleMod:getHarness", real_plate_from_fake)
        end
    end
end)

RegisterNetEvent("warp-garages:openPersonalGarage")
AddEventHandler("warp-garages:openPersonalGarage", function()
    exports['warp-garages']:DeleteViewedCar()
    RPC.execute("warp-garages:select", exports['warp-menu']:currentGarage())
end)

RegisterNetEvent("warp-garages:attempt:spawn", function(data, pRealSpawn)
    if not pRealSpawn then
        RPC.execute("warp-garages:attempt:sv", data)
        SpawnVehicle(data.model, exports['warp-menu']:currentGarage(), data.fuel, data.customized, data.plate, true)
    else
        SpawnVehicle(data.model, exports['warp-menu']:currentGarage(), data.fuel, data.customized, data.plate, false)
    end
end)

RegisterNetEvent("warp-garages:takeout", function(pData)
    RPC.execute("warp-garages:spawned:get", pData.pVeh)
end)

RegisterNetEvent("warp-garages:store", function()
    local pos = GetEntityCoords(PlayerPedId())
    local Stored = RPC.execute("warp-garages:states", "In", exports["warp-vehicles"]:NearVehicle("plate"), exports['warp-menu']:currentGarage(), exports["warp-vehicles"]:NearVehicle("Fuel"))
    local coordA = GetEntityCoords(PlayerPedId(), 1)
    local coordB = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 100.0, 0.0)
    local curVeh = exports['warp-vehicles']:getVehicleInDirection(coordA, coordB)
    if DoesEntityExist(curVeh) then
        if Stored then
            DeleteVehicle(curVeh)
            DeleteEntity(curVeh)
            TriggerEvent('keys:remove', exports["warp-vehicles"]:NearVehicle("plate"))
            TriggerEvent('DoLongHudText', "Vehicle stored in garage: " ..exports['warp-menu']:currentGarage(), 1)
        else
            TriggerEvent('DoLongHudText', "You cant store local cars!", 2)
        end
    else
        TriggerEvent("DoLongHudText", "No vehicle near by!" , 2)
    end
end)