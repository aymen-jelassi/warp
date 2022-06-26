function SendUIMessage(data)
    SendNUIMessage(data)
end

function sendAppEvent(app, data)
    SendUIMessage({
        action = app,
        data = data or {},
    })
end

exports("sendAppEvent", sendAppEvent)

function closeApplication(app, data)
    SendUIMessage({
        action = app,
        show = false,
        data = data or {},
    })
    SetNuiFocus(false,false)
    TriggerEvent("warp-casinoui:application-closed", app, { fromEscape = false })
end

exports("closeApplication", closeApplication)