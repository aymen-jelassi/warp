RegisterServerEvent("warp-base:sv:player_control_set")
AddEventHandler("warp-base:sv:player_control_set", function(controlsTable)
    local src = source
    Void.DB:UpdateControls(src, controlsTable, function(UpdateControls, err)
            if UpdateControls then
                -- we are good here.
            end
    end)
end)

RegisterServerEvent("warp-base:sv:player_controls")
AddEventHandler("warp-base:sv:player_controls", function()
    local src = source
    Void.DB:GetControls(src, function(loadedControls, err)
        if loadedControls ~= nil then 
            TriggerClientEvent("warp-base:cl:player_control", src, loadedControls) 
        else 
            TriggerClientEvent("warp-base:cl:player_control",src, nil)
        end
    end)
end)
