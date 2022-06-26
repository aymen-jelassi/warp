RegisterNUICallback("dataPost", function(data, cb)
    SetNuiFocus(false)
    print(data.event, data.args)
    TriggerEvent(data.event, data.args)
    cb('ok')
end)

RegisterNUICallback("cancel", function(cb)
    SetNuiFocus(false)
    TriggerEvent('warp-context:cancel')
end)


RegisterNetEvent('warp-context:sendMenu', function(data)
    if not data then return end
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "OPEN_MENU",
        data = data
    })
end)
