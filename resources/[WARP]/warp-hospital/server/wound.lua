local playerInjury = {}

function GetCharsInjuries(source)
    return playerInjury[source]
end

RegisterServerEvent('warp-hospital:server:SyncInjuries')
AddEventHandler('warp-hospital:server:SyncInjuries', function(data)
    playerInjury[source] = data
end)