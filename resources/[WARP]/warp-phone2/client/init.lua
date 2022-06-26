Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("heist_wifi_spot_1", vector3(-223.06, -1329.84, 30.89), 10, 10, {
        heading = 0,
        minZ = 29.89,
        maxZ = 33.89,
        data = {
            id = "heist1"
        }
    })
    exports["warp-polyzone"]:AddBoxZone("heist_wifi_spot_2", vector3(-1358.46, -756.37, 22.3), 6.4, 7.4, {
        heading = 37,
        minZ = 21.3,
        maxZ = 23.5,
        data = {
            id = "heist2"
        }
    })
    exports["warp-polyzone"]:AddBoxZone("heist_wifi_spot_3", vector3(-1147.9, -2008.66, 13.39), 10, 10, {
        heading = 315,
        minZ = 11.99,
        maxZ = 15.99,
        data = {
            id = "heist3"
        }
    })
    exports["warp-polyzone"]:AddBoxZone("heist_wifi_spot_4", vector3(-83.88, 367.21, 112.46), 10, 10, {
        heading = 335,
        minZ = 111.26,
        maxZ = 114.26,
        data = {
            id = "heist4"
        }
    })
    exports["warp-polyzone"]:AddBoxZone("heist_wifi_spot_5", vector3(964.08, -1856.62, 31.2), 5.2, 7.2, {
      heading = 355,
      minZ = 30.0,
      maxZ = 33.0,
      data = {
          id = "heist5"
      }
    })
end)

local validZones = {
  ["heist_wifi_spot_1"] = true,
  ["heist_wifi_spot_2"] = true,
  ["heist_wifi_spot_3"] = true,
  ["heist_wifi_spot_4"] = true,
  ["heist_wifi_spot_5"] = true,
}
AddEventHandler("warp-polyzone:enter", function(zone, data)
    if validZones[zone] ~= true then return end
    --exports["warp-ui"]:sendAppEvent("game", { location = zone })
    sendAppEvent(true, data)
end)
AddEventHandler("warp-polyzone:exit", function(zone, data)
    if validZones[zone] ~= true then return end
    --exports["warp-ui"]:sendAppEvent("game", { location = "world" })
    sendAppEvent(false, data)
end)