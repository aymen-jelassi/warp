RegisterServerEvent("warp-base:sv:player_settings_set")
AddEventHandler("warp-base:sv:player_settings_set", function(settingsTable)
    local src = source
    Void.DB:UpdateSettings(src, settingsTable, function(UpdateSettings, err)
            if UpdateSettings then
                -- we are good here.
            end
    end)
end)

RegisterServerEvent("warp-base:sv:player_settings")
AddEventHandler("warp-base:sv:player_settings", function()
    local src = source
    Void.DB:GetSettings(src, function(loadedSettings, err)
        if loadedSettings ~= nil then 
            TriggerClientEvent("warp-base:cl:player_settings", src, loadedSettings) 
        else 
            TriggerClientEvent("warp-base:cl:player_settings",src, nil) 
        end
    end)
end)
