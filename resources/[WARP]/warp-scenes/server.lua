local scenes = {}

RegisterNetEvent('warp-scenes:fetch', function()
    local src = source
    TriggerClientEvent('warp-scenes:send', src, scenes)
end)

RegisterNetEvent('warp-scenes:add', function(coords, message, color, distance)
    table.insert(scenes, {
        message = message,
        color = color,
        distance = distance,
        coords = coords
    })
    TriggerClientEvent('warp-scenes:send', -1, scenes)
    TriggerEvent('warp-scenes:log', source, message, coords)
end)

RegisterNetEvent('warp-scenes:delete', function(key)
    table.remove(scenes, key)
    TriggerClientEvent('warp-scenes:send', -1, scenes)
end)


RegisterNetEvent('warp-scenes:log', function(id, text, coords)
    local f, err = io.open('sceneLogging.txt', 'a')
    if not f then return print(err) end
    f:write('Player: ['..id..'] Placed Scene: ['..text..'] At Coords = '..coords..'\n')
    f:close()
end)