local blips = {
    {title="Fishing", colour=47, id=68, scale=0.7, x = 1530.3297119141, y = 3778.4174804688, z = 34.503295898438},
    {title="Fishing Sales", colour=47, id=68, scale=0.7, x = -371.57, y = 277.15, z = 86.42},
    {title="Mine", colour=3, id=617, scale=0.7, x = -595.25274658203, y = 2086.6682128906, z = 131.37292480469},
    {title="Post OP", colour=40, id=616, scale=0.9, x = -416.05712890625, y = -2793.1516113281, z = 5.993408203125},
    {title="Water & Power", colour=46, id=354, scale=0.7, x = 448.74725341797, y = -1970.3472900391, z = 22.961181640625},
    {title="Vehicle Rental", colour=0, id=227, scale=0.7, x = 111.05934143066, y = -1088.4791259766, z = 29.296752929688},
    -- {title="Pearls", colour=3, id=304, scale=0.7, x = -1809.4417724609, y = -1187.0900878906, z = 13.424194335938},
    -- {title="Winery", colour=3, id=351, scale=1.0, x = -1883.2879638672, y = 2070.5012207031, z = 145.56042480469},
    -- {title="In N Out", colour=3, id=364, scale=0.7, x = 80.901100158691, y = 273.75823974609, z = 110.19262695312},
    -- {title="Red Circle", colour=1, id=394, scale=0.7, x = -310.27252197266, y = 219.13845825195, z = 87.86669921875},
    -- {title="Cosmic Cannabis", colour=25, id=140, scale=0.7, x = 201.82418823242, y = -238.48352050781, z = 53.96484375},
    -- {title="Drift School", colour=0, id=227, scale=0.7, x = -126.40878295898, y = -2535.0461425781, z = 5.993408203125},
    -- {title="Tuner Shop", colour=3, id=669, scale=0.7, x = 144.19779968262, y = -3050.6638183594, z = 7.0380859375},
    {title="Hayes Autos", colour=46, id=428, scale=0.7, x = -1425.8110351562, y = -442.58901977539, z = 35.885009765625},
    {title="Harmony Repairs", colour=0, id=566, scale=0.7, x = 1180.8791503906, y = 2645.0900878906, z = 37.738403320312},
    {title="Garbage Depo", colour=0, id=318, scale=0.7, x = -351.79779052734, y = -1544.2681884766, z = 27.712768554688},
    {title="Alta Street Apartments", colour=3, id=475, scale=0.9, x = -267.45495605469, y = -960.69891357422, z = 31.234375},
    {title="Sandy Shores PD", colour=0, id=60, scale=0.7, x = 1855.2, y = 3685.72, z = 34.272},
    -- {title="Sasha's Diving", colour=29, id=356, scale=0.7, x = -1613.079, y = 5262.372, z = 3.974097}
}

Citizen.CreateThread(function()
    for _, info in pairs(blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, info.scale)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end
  end)