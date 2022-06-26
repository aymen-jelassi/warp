-- RegisterNetEvent("warp-ui:client:InitUI")
-- AddEventHandler("warp-ui:client:InitUI", function()
--     print("[warp-ui] Initalize Hud")
--     local toggleData = {
--         health = GetResourceKvpString('healthshow'),
--         armor = GetResourceKvpString('armorshow'),
--         hunger = GetResourceKvpString('hungershow'),
--         thirst = GetResourceKvpString('thirstshow'),
--         stamina = GetResourceKvpString('staminashow'),
--         oxygen = GetResourceKvpString('oxyshow'),
--         stress = GetResourceKvpString('stressshow'),
--         voice = GetResourceKvpString('voiceshow'),
--     }

--     local colorData = {
--         health = GetResourceKvpString('#health'),
--         armor = GetResourceKvpString('#armor'),
--         hunger = GetResourceKvpString('#hunger'),
--         thirst = GetResourceKvpString('#thirst'),
--         stamina = GetResourceKvpString('#stamina'),
--         oxygen = GetResourceKvpString('#oxygen'),
--         stress = GetResourceKvpString('#stress'),
--         voice = GetResourceKvpString('#voice'),
--     }

--     Citizen.Wait(500)
--     SendNUIMessage({
--         action = "initialize",
--         toggledata = toggleData,
--         colordata = colorData,
--     })
    
-- end)

function SetUIFocus(hasKeyboard, hasMouse)
    SetNuiFocus(hasKeyboard, hasMouse)
end
    
exports('SetUIFocus', SetUIFocus)

RegisterNUICallback("warp-ui:closeApp", function(data, cb)
    SetNuiFocus(false, false)
    SetUIFocus(false, false)
    cb({data = {}, meta = {ok = true, message = 'done'}})
end)

RegisterNUICallback("warp-ui:applicationClosed", function(data, cb)
    TriggerEvent("warp-ui:application-closed", data.name, data)
    cb({data = {}, meta = {ok = true, message = 'done'}})
    SetNuiFocus(false, false)
end)

-- SMALL MAP
-- RegisterCommand("warp-ui:small-map", function()
--     SetRadarBigmapEnabled(false, false)
-- end, false)

-- RegisterCommand("testbugui", function()
--     SetNuiFocus(true, true)
--     SetUIFocus(true, true)
-- end)

RegisterCommand("clearui", function()
    exports["warp-textui"]:showInteraction("Clearing UI .")
    Wait(1000)
    exports["warp-textui"]:showInteraction("Clearing UI ..")
    Wait(1000)
    exports["warp-textui"]:showInteraction("Clearing UI ...")
    Wait(1000)
    SetNuiFocus(false, false)
    SetUIFocus(false, false)
    exports["warp-textui"]:showInteraction("UI Cleared !", "success")
    Wait(1000)
    exports["warp-textui"]:hideInteraction()
    exports["warp-textui"]:hideInteraction("success")
end)

RegisterCommand("clearanim", function()
    exports["warp-textui"]:showInteraction("Stopping Animation .")
    Wait(1000)
    exports["warp-textui"]:showInteraction("Stopping Animation ..")
    Wait(1000)
    exports["warp-textui"]:showInteraction("Stopping Animation ...")
    Wait(1000)
    ClearPedTasks(GetPlayerPed(-1))
    ClearPedTasks(PlayerPedId())
    exports["warp-textui"]:showInteraction("Animation Cleared !", "success")
    Wait(1000)
    exports["warp-textui"]:hideInteraction()
    exports["warp-textui"]:hideInteraction("success")
end)
