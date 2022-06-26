--Example

RegisterNUICallback("warp-ui:test:input", function(data, cb)
    print("warp-ui:test:input",json.encode(data))
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback("guccimanecancel", function(data, cb)
    print("warp-ui:test:input",json.encode(data))
    SetNuiFocus(false)
    cb("ok")
end)