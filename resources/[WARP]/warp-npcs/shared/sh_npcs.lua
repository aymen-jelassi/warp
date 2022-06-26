Generic = {}
Generic.NPCS = {}

Generic.SpawnLocations = {
  -- vector4(620.48, 2752.6, 42.09 - 1.0, 359.94)
  vector4(-1605.03,-994.58,7.53 - 1.0,136.79),
}

Generic.ShopKeeperLocations = {
  vector4(-3037.773, 584.8989, 6.97, 30.0),
  vector4(1960.64, 3739.03, 31.50, 321.36),
  vector4(1393.84,3606.8,33.99,172.8),
  vector4(549.01,2672.44,41.16,122.33),
  vector4(2558.39,380.74,107.63,21.54),
  vector4(-1819.57,793.59,137.09,134.3),
  vector4(-1221.26,-907.92,11.3,54.44),
  vector4(-706.12,-914.56,18.22,94.66),
  vector4(24.47,-1348.47,28.5,298.26),
  vector4(-47.36,-1758.68,28.43,50.84),
  vector4(1164.95,-323.7,68.21,101.73),
  vector4(372.19,325.74,102.57,276.17),
  vector4(2678.63,3278.86,54.25,344.4),
  vector4(1727.3,6414.27,34.04,259.1),
  vector4(-160.56,6320.76,30.59,319.99),
  vector4(1165.29,2710.85,37.16,178.47),
  vector4(1697.23,4923.42,41.07,327.94),
  vector4(159.84,6640.89,30.7,242.18),
  vector4(-1486.81,-377.38,39.17,143.01),
  vector4(-3241.1,999.93,11.84,10.23),
  vector4(-2966.38,391.79,14.05,99.55),
  vector4(1134.29,-983.39,45.42,292.7)
}

Generic.SportsShopLocations = {
  vector4(-703.37164306641, -1179.4047851562, 9.609468460083, 122.92682647705),
  vector4(-23.520534515381, -106.42227935791, 56.061752319336, 154.0001373291)
}

Generic.DigitalShopLocations = {
  vector4(1134.5090332031, -468.16110229492, 65.485946655273, 165.39506530762)
}

Generic.HuntingShopLocations = {
  vector4(-679.46, 5839.32, 16.34, 218.69),
}

Generic.WeaponShopLocations = {
  vector4(23.36,-1105.82,28.8,156.03),
  vector4(1696.02,3760.72,33.71,193.37),
  vector4(808.26,-2157.71,28.62,276.46),
  vector4(254.32,-49.28,68.95,70.86),
  vector4(840.21,-1032.9,27.2,289.83),
  vector4(-331.75,6084.95,30.46,224.64),
  vector4(-666.13,-938.73,20.83,269.52),
  vector4(-1310.05,-389.17,35.7,144.36),
  vector4(-1116.51,2700.33,17.58,149.9),
  vector4(2571.79,298.1,107.74,84.22),
  vector4(-3169.53,1089.59,19.84,237.35),
}

Generic.ToolShopLocations = {
  vector4(44.838947296143, -1748.5364990234, 28.549386978149, 35.3),
  vector4(2749.2309570313, 3472.3308105469, 54.679393768311, 244.4),
}

Generic.LaptopVendors = {
  vector4(-1358.93, -759.38, 21.32, 346.47),
}

Generic.CasinoLocations = {
  {
    coords = vector4(966.29,47.52,70.72,145.85), -- coat check
    flags = { "isCasinoMembershipGiver" },
  },
  {
    coords = vector4(1030.35,71.56,68.88,238.32), -- rest room 1
  },
  {
    coords = vector4(1039.24,33.85,68.88,321.23), -- rest room 2
  },
  {
    coords = vector4(963.25,19.07,70.48,276.73), -- jewel store
  },
  {
    coords = vector4(990.79,30.95,70.48,58.76), -- casino chips
    flags = { "isCasinoChipSeller" },
  },
  {
    coords = vector4(988.61,42.97,70.28,201.73), -- wheel of fortune
    npcId = "casino_wheel_spin_npc",
  },
  {
    coords = vector4(978.4,25.39,70.48,43.67), -- drinks bar
    flags = { "isCasinoDrinkGiver" },
  },
}

-- Start Of All NPC Interacts --

-- Recycling --

Generic.NPCS[#Generic.NPCS + 1] = {
  id = "recycle_exchange",
  name = "Recycle Exchange",
  pedType = 4,
  model = "s_m_y_garbage",
  networked = false,
  distance = 150.0,
  position = {
    coords = vector3(-355.76, -1556.04, 24.18),
    heading = 179.96,
    random = false
  },
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true }
  },
  flags = {
      ['isNPC'] = true,
      ['isRecycleExchange'] = true
  }
}

-- Laptop Guy --

Generic.NPCS[#Generic.NPCS + 1] = {
  id = "laptop_1",
  name = "laptop vendor",
  pedType = 2,
  model = "a_m_y_stwhi_01",
  networked = false,
  distance = 50.0,
  position = {
    coords = vector3(-1358.93, -759.38, 21.32 - 1.0), --   -1358.93, -759.38, 21.32, 346.47
    heading = 346.47,
},
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true },
  },
  flags = {
    ['isNPC'] = true,
    --isLaptopInst = true,
  },
}

-- Drug Dealer --

Generic.NPCS[#Generic.NPCS + 1] = {
  id = "druggy",
  name = "",
  pedType = 2,
  model = "a_m_m_afriamer_01",
  networked = false,
  distance = 50.0,
  position = {
    coords = vector3(1080.3134, -2412.861, 30.167449 - 1.0),
    heading = 270.0801,
},
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true },
  },
  flags = {
    ['isNPC'] = true,
  },
}

-- Car Rental --

Generic.NPCS[#Generic.NPCS + 1] = {
  id = "vehicle_rental",
  name = "",
  pedType = 2,
  model = "a_m_y_smartcaspat_01",
  networked = false,
  distance = 50.0,
  position = {
    coords = vector3(110.59, -1090.72, 29.31 - 1.0),
    heading = 17.39,
},
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true },
  },
  flags = {
    ['isNPC'] = true,
  },
}

-- Chop Shop --

Generic.NPCS[#Generic.NPCS + 1] = {
  id = "chop_shop",
  name = "",
  pedType = 2,
  model = "a_f_m_eastsa_01",
  networked = false,
  distance = 50.0,
  position = {
    coords = vector3(340.51779, -1260.857, 32.495662 - 1.0),
    heading = 286.36419,
},
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true },
  },
  flags = {
    ['isNPC'] = true,
  },
}

-- House Robberies --

Generic.NPCS[#Generic.NPCS + 1] = {
  id = "void_house_robberies",
  name = "",
  pedType = 2,
  model = "a_m_m_beach_01",
  networked = false,
  distance = 50.0,
  position = {
    coords = vector3(206.33532, -1851.644, 27.480291 - 1.0),
    heading = 146.43402,
},
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true },
  },
  flags = {
    ['isNPC'] = true,
  },
}

-- Fishing --

Generic.NPCS[#Generic.NPCS + 1] = {
  id = "evan_fishing",
  name = "",
  pedType = 2,
  model = "a_m_m_fatlatin_01",
  networked = false,
  distance = 50.0,
  position = {
    coords = vector3(1530.3297119141, 3778.4174804688, 34.503295898438 - 1.0),
    heading = 226.77166748047,
},
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true },
  },
  flags = {
    ['isNPC'] = true,
  },
}

-- Post OP --

Generic.NPCS[#Generic.NPCS + 1] = {
  id = "evan_post_op",
  name = "",
  pedType = 2,
  model = "ig_floyd",
  networked = false,
  distance = 50.0,
  position = {
    coords = vector3(-417.9560546875, -2792.6110839844, 5.993408203125 - 1.0),
    heading = 226.7716674804,
},
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true },
  },
  flags = {
    ['isNPC'] = true,
  },
}

-- Hunting --

Generic.NPCS[#Generic.NPCS + 1] = {
  id = "evan_hunting",
  name = "",
  pedType = 2,
  model = "cs_hunter",
  networked = false,
  distance = 50.0,
  position = {
    coords = vector3(-678.97583007812, 5834.3603515625, 17.316528320312 - 1.0),
    heading = 144.56690979004,
},
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true },
  },
  flags = {
    ['isNPC'] = true,
  },
}

-- Garbage --

Generic.NPCS[#Generic.NPCS + 1] = {
  id = "evan_garbage",
  name = "",
  pedType = 2,
  model = "s_m_y_dockwork_01",
  networked = false,
  distance = 50.0,
  position = {
    coords = vector3(-354.22418212891, -1545.876953125, 27.712768554688 - 1.0),
    heading = 269.29135131836,
},
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true },
  },
  flags = {
    ['isNPC'] = true,
  },
}

-- PD Heli --

Generic.NPCS[#Generic.NPCS + 1] = {
  id = "pd_heli",
  name = "",
  pedType = 2,
  model = "s_m_y_dockwork_01",
  networked = false,
  distance = 50.0,
  position = {
    coords = vector3(441.92965698242, -974.62414550781, 43.686401367188 - 1.0),
    heading = 232.44094848633,
},
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true },
  },
  flags = {
    ['isNPC'] = true,
  },
}

Generic.NPCS[#Generic.NPCS + 1] = {
  id = "cayo_heli",
  name = "",
  pedType = 2,
  model = "s_m_y_westsec_01",
  networked = false,
  distance = 50.0,
  position = {
    coords = vector3(4877.9404, -5729.412, 26.371034 - 1.0),
    heading = 230.98074,
},
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true },
  },
  flags = {
    ['isNPC'] = true,
  },
}

-- EMS Buy Car --

Generic.NPCS[#Generic.NPCS + 1] = {
  id = "purchase_car_ems",
  name = "",
  pedType = 2,
  model = "s_m_y_dockwork_01",
  networked = false,
  distance = 50.0,
  position = {
    coords = vector3(340.49670410156, -582.72528076172, 28.791259765625 - 1.0),
    heading = 70.866142272949,
},
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true },
  },
  flags = {
    ['isNPC'] = true,
  },
}

-- EMS Heli --

Generic.NPCS[#Generic.NPCS + 1] = {
  id = "ems_heli",
  name = "",
  pedType = 2,
  model = "s_m_y_dockwork_01",
  networked = false,
  distance = 50.0,
  position = {
    coords = vector3(351.24395751953, -575.05053710938, 74.15087890625 - 1.0),
    heading = 192.75592041016,
},
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true },
  },
  flags = {
    ['isNPC'] = true,
  },
}