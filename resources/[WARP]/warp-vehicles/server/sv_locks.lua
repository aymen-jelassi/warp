RegisterServerEvent('warp-keys:attemptLockSV')
AddEventHandler('warp-keys:attemptLockSV', function(targetVehicle, plate)
    TriggerClientEvent('warp-keys:attemptLock', source, targetVehicle, plate)
end)