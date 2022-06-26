local blipBoostLoc = nil
local blipDropOff = nil

local spawnedVeh = nil
local StartedBoost = false
local SentEmail = false

local vehClass = nil

function DeleteBlip(blip)
	if DoesBlipExist(blip) then
		RemoveBlip(blip)
	end
end

function CreateBlipBoostLoc(x, y, z)
  blipBoostLoc = AddBlipForRadius(x, y, z, 300.0)
  SetBlipHighDetail(blipBoostLoc, true)
	SetBlipColour(blipBoostLoc, 3)
	SetBlipAlpha (blipBoostLoc, 64)
  SetBlipDisplay(blipBoostLoc, 3)
end

function CreateBlipDropOff(x, y ,z)
  blipDropOff = AddBlipForCoord(x, y, z)
  SetBlipHighDetail(blipDropOff, true)
	SetBlipColour(blipDropOff, 1)
  SetBlipScale(blipDropOff, 0.75)
	SetBlipAlpha(blipDropOff, 250)
  SetBlipDisplay(blipDropOff, 2)
  SetBlipSprite(blipDropOff, 227)
  AddTextEntry("DROP", "Drop Location")
  BeginTextCommandSetBlipName("DROP")
  SetBlipCategory(blipDropOff, 2)
  EndTextCommandSetBlipName(blipDropOff)
end

local carList = {
  ["d-class"] = {
    {name = "Declasse Asea", model = "asea"},
    {name = "Declasse Emperor",  model = "emperor"},
    {name = "Dundreary Regina",  model = "regina"},
    {name = "Chariot Romero Hearse", model = "romero"},
    {name = "Vapid Minivan", model = "minivan"},
    {name = "Bravado Paradise", model = "paradise"},
    {name = "Brute Pony", model = "pony"},
  },
  ["c-class"] = {
    {name = "Dinka Blista Compact", model = "blista2"},
    {name = "Karin Asterope", model = "asterope"},
    {name = "Vulcar Ingot", model = "ingot"},
    {name = "Albany Primo",model = "primo"},
  },
  ["b-class"] = {
    {name = "Lampadati Komoda", model = "komoda"},
    {name = "Albany VSTR", model = "vstr"},
    {name = "Dinka Blista", model = "blista"},
    {name = "Dinka Sugoi", model = "sugoi"},
  },
  ["a-class"] = {
    {name = "Obey 9F Cabrio", model = "ninef2"},
    {name = "Obey 8F Drafter", model = "drafter"},
    {name = "Albany Alpha",model = "alpha"},
  },
  ["s-class"] = {
    {name = "Declasse Hotring Sabre", model = "hotring"},
    {name = "Grotti Cheetah Classic", model = "cheetah2"},
    {name = "Grotti Furia", model = "furia"},
    {name = "Grotti Turismo Classic", model = "turismo2"},
  }
}

local carSpawns = {
  [1] =  { ['x'] = 227.9091,['y'] = 681.1382,['z'] = 188.9611,['h'] = 105.5603, ["pedSpawn"] =  {
    ["x"] = 219.5656, ["y"] = 642.4722, ["z"] = 189.6874, ["h"] = 26.96800
  }},
  [2] =  { ['x'] = -1084.4571, ['y'] = -1671.9692, ['z'] = 4.0556, ['h'] = 306.1417, ["pedSpawn"] =  {
    ['x'] = -1089.4154, ['y'] = -1683.2175, ['z'] = 4.6453, ['h'] = 311.8110
  }},
  [3] =  { ['x'] = -2030.0834, ['y'] = -355.9516, ['z'] = 43.4674, ['h'] = 53.8582, ["pedSpawn"] =  {
    ['x'] = -1997.6307, ['y'] = -327.6000, ['z'] = 48.0842, ['h'] = 272.1259
  }},
  [4] =  { ['x'] = -2179.0681, ['y'] = -422.0043, ['z'] = 12.5479, ['h'] = 181.4173, ["pedSpawn"] =  {
    ['x'] = -2234.3867, ['y'] = -367.5560, ['z'] = 13.4578, ['h'] = 25.5118
  }},
  [5] =  { ['x'] = -1625.7626, ['y'] = -951.0856, ['z'] = 7.6109, ['h'] = 138.8976, ["pedSpawn"] =  {
    ['x'] = -1621.0549, ['y'] = -958.1274, ['z'] = 13.0029, ['h'] = 223.9370
  }},
  [6] =  { ['x'] = -2785.1604, ['y'] = 1434.1064, ['z'] = 100.2850, ['h'] = 53.8582, ["pedSpawn"] =  {
    ['x'] = -2783.1691, ['y'] = 1436.4000, ['z'] = 100.8916, ['h'] = 187.0866
  }},
  [7] =  { ['x'] = 1391.7098, ['y'] = 1120.0878, ['z'] = 114.1860, ['h'] = 87.8740, ["pedSpawn"] =  {
    ['x'] = 1417.8725, ['y'] = 1105.9912, ['z'] = 114.2872, ['h'] = 303.3070
  }},
  [8] =  { ['x'] = 1274.1494, ['y'] = -367.8725, ['z'] = 68.4051, ['h'] = 240.9448, ["pedSpawn"] =  {
    ['x'] = 1249.2263, ['y'] = -349.7538, ['z'] = 69.1970, ['h'] = 192.7559
  }},
  [9] =  { ['x'] = 1130.4132, ['y'] = -1302.2636, ['z'] = 34.0988, ['h'] = 172.9133, ["pedSpawn"] =  {
    ['x'] = 1156.5230, ['y'] = -1258.5230, ['z'] = 34.6043, ['h'] = 136.0629
  }},
  [10] =  { ['x'] = 1599.1252, ['y'] = -1708.4439, ['z'] = 87.4791, ['h'] = 297.6377, ["pedSpawn"] =  {
    ['x'] = 1570.8659, ['y'] = -1664.9934, ['z'] = 88.2036, ['h'] = 19.8425
  }},
}

local dropPoint = {
  [1] = {["x"] = 974.58, ["y"] = -1718.68, ["z"] = 30.6},
  [2] = {['x'] = 145.00, ['y'] = -1287.89, ['z'] = 28.67},
  [3] = {['x'] = 37.63, ['y'] = -1022.18, ['z'] = 28.84},
  [4] = {['x'] = -477.70, ['y'] = -760.21, ['z'] = 29.92},
  [5] = {['x'] = 725.98, ['y'] = -1310.40, ['z'] = 25.65},
  [6] = {['x'] = 1006.25, ['y'] = -1375.46, ['z'] = 30.71},
  [7] = {['x'] = 1125.52, ['y'] = -1405.02, ['z'] = 33.89},
  [8] = {['x'] = 1125.52, ['y'] = -1405.02, ['z'] = 33.89},
  [9] = {['x'] = 1116.50, ['y'] = -1505.77, ['z'] = 34.04},
  [10] = {['x'] = 1211.85, ['y'] = -1524.83, ['z'] = 34.04},
  [11] = {['x'] = 1217.48, ['y'] = -1071.23, ['z'] = 38.69},
  [12] = {['x'] = 1030.07, ['y'] = -788.33, ['z'] = 57.21},
  [13] = {['x'] = 844.44, ['y'] = -36.59, ['z'] = 78.11},
  [14] = {['x'] = 705.71, ['y'] = 597.05, ['z'] = 128.27},
  [15] = {['x'] = 379.35, ['y'] = 264.52, ['z'] = 102.35},
}

RegisterNUICallback("joinBoostQueue", function()
  TriggerServerEvent("ls:joinQueue")
end)

RegisterNUICallback('leaveBoostQueue', function()
  TriggerServerEvent('ls:leaveQueue')
end)

RegisterNUICallback('getXp', function()
  TriggerServerEvent('ls:checkXp')
end)

RegisterNetEvent('xpReceived')
AddEventHandler('xpReceived', function(xp, level)
  SendNUIMessage({
    type = 'xpCheck',
    xp = xp,
    level = level
  })
end)

RegisterNetEvent("queueReady")
AddEventHandler("queueReady", function()
  TriggerServerEvent("checkBoostLevel")
end)

RegisterNetEvent("boostLevelReceived")
AddEventHandler("boostLevelReceived", function(level)
    local carName = nil
    local carModel = nil
    local boostClass = nil

    if level == 1 then
      local random = math.random(1, #carList["d-class"])
      carName = carList["d-class"][random]["name"]
      carModel = carList["d-class"][random]["model"]
      boostClass = 'D'
    elseif level == 2 then
      if math.random(1,2) > 1 then
        local random = math.random(1, #carList["d-class"])
        carName = carList["d-class"][random]["name"]
        carModel = carList["d-class"][random]["model"]
        boostClass = 'D'
      else
        local random = math.random(1, #carList["c-class"])
        carName = carList["c-class"][random]["name"]
        carModel = carList["c-class"][random]["model"]
        boostClass = 'C'
      end
    elseif level == 3 then
      if math.random(1,2) > 1 then
        local random = math.random(1, #carList["c-class"])
        carName = carList["c-class"][random]["name"]
        carModel = carList["c-class"][random]["model"]
        boostClass = 'C'
      else
        local random = math.random(1, #carList["b-class"])
        carName = carList["b-class"][random]["name"]
        carModel = carList["b-class"][random]["model"]
        boostClass = 'B'
      end
    elseif level == 4 then
      if math.random(1,4) <= 3 then
        local random = math.random(1, #carList["b-class"])
        carName = carList["b-class"][random]["name"]
        carModel = carList["b-class"][random]["model"]
        boostClass = 'B'
      else
        local random = math.random(1, #carList["a-class"])
        carName = carList["a-class"][random]["name"]
        carModel = carList["a-class"][random]["model"]
        boostClass = 'A'
      end
    elseif level == 5 then
      if math.random(1,8) <= 6 then
        local random = math.random(1, #carList["a-class"])
        carName = carList["a-class"][random]["name"]
        carModel = carList["a-class"][random]["model"]
        boostClass = 'A'
      else
        local random = math.random(1, #carList["s-class"])
        carName = carList["s-class"][random]["name"]
        carModel = carList["s-class"][random]["model"]
        boostClass = 'S'
      end
    end
    SendNUIMessage({
        carName = carName,
        carModel = carModel,
        boostClass = boostClass,
        isBoostReady = true
    })
end)

RegisterNUICallback("startBoost", function(data, cb)
  TriggerEvent('phone:addJobNotify', "Make you way over to the spot.")
  cb("ok")
  TriggerEvent("ls:startCarBoost", data["carModel"])
  vehClass = data["carClass"]
end)

RegisterNetEvent("ls:startCarBoost")
AddEventHandler("ls:startCarBoost", function(modelName)
  local vehHash = GetHashKey(modelName)

  carSpawnRandom = math.random(1,#carSpawns)
  local x = carSpawns[carSpawnRandom]["x"]
  local y = carSpawns[carSpawnRandom]["y"]
  local z = carSpawns[carSpawnRandom]["z"]
  local h = carSpawns[carSpawnRandom]["h"]

  local pedX = carSpawns[carSpawnRandom]["pedSpawn"]["x"]
  local pedY = carSpawns[carSpawnRandom]["pedSpawn"]["y"]
  local pedZ = carSpawns[carSpawnRandom]["pedSpawn"]["z"]
  local pedH = carSpawns[carSpawnRandom]["pedSpawn"]["h"]

  if not IsModelInCdimage(vehHash) then return end
  RequestModel(vehHash)
  while not HasModelLoaded(vehHash) do
    Citizen.Wait(10)
  end
  local vehicle = CreateVehicle(vehHash, x, y, z, h, true, false)
  SetVehicleDoorsLocked(vehicle, 2)
  spawnedVeh = GetClosestVehicle(x, y, z, 3.5, 0, 70)

  CreateBlipBoostLoc(x, y, z)
  
  function SpawnPedLoc()
    local pedSpawnLoc = {["x"] = pedX, ["y"] = pedY, ["z"] = pedZ, ["h"] = pedH}
    return pedSpawnLoc
  end

  Citizen.CreateThread(function()
    while true do
      Citizen.Wait(5000)
      if GetVehiclePedIsIn(PlayerPedId(), false) == spawnedVeh then
        DeleteBlip(blipBoostLoc)
        blipBoostLoc = nil
        return
      end
    end
  end)
end)

-- post lockpick

local trackerActive = false

RegisterNetEvent("ls:boostLockPick")
AddEventHandler("ls:boostLockPick", function()
  local plyPos = GetEntityCoords(PlayerPedId())
  local targetVeh = GetClosestVehicle(plyPos.x, plyPos.y, plyPos.z, 2.5, 0, 70)
  local coords = SpawnPedLoc()
  local pedSpawnAmount = nil 
  local weapon = nil
  local lowTierGuns = {
    "weapon_bat",
    "weapon_switchblade",
    "weapon_crowbar"
  }
  local medTierGuns = {
    "weapon_combatpistol",
    "weapon_pistol",
    "weapon_switchblade",
    "weapon_musket",
  }
  local bigBoyGuns = {
    "weapon_combatpistol",
    "weapon_vintagepistol",
    "weapon_dbshotgun",
    "weapon_musket",
  }

  if vehClass == "D" then
    pedSpawnAmount = 2
    weapon = lowTierGuns[math.random(1, #lowTierGuns)]
  elseif vehClass == "C" then
    pedSpawnAmount = 2
    weapon = lowTierGuns[math.random(1, #lowTierGuns)]
  elseif vehClass == "B" then
    pedSpawnAmount = math.random(2,3)
    weapon = medTierGuns[math.random(1, #medTierGuns)]
  elseif vehClass == "A" then
    pedSpawnAmount = math.random(2,4)
    weapon = bigBoyGuns[math.random(1, #bigBoyGuns)]
  elseif vehClass == "S" then
    pedSpawnAmount = math.random(2,4)
    weapon = bigBoyGuns[math.random(1, #bigBoyGuns)]
  end
  
  -- Citizen.CreateThread(function()
    if targetVeh == spawnedVeh then
      if not pedsSpawned then
        for i = pedSpawnAmount, 1, -1 do 
          TriggerEvent("ls:spawnPed", coords["x"], coords["y"], coords["z"], coords["h"], weapon)
          pedsSpawned = true
        end  
        if vehClass == 'D' then
          if math.random(1,4) == 1 then
            TriggerEvent("warp-boosting:ping", spawnedVeh)
          end
        elseif vehClass == 'C' then
          if math.random(1,2) == 1 then
            TriggerEvent("warp-boosting:ping", spawnedVeh)
          end
        else
          TriggerEvent("warp-boosting:ping", spawnedVeh)
        end

        while not IsPedInAnyVehicle(PlayerPedId(), false) do
          Citizen.Wait(1000)
        end 

        -- local isPedInBoostCar = IsPedInVehicle(PlayerPedId(), spawnedVeh, true)

        local TrackerTriggerTime = 30000
        if vehClass == 'D' then
          TrackerTriggerTime = 80000
        elseif vehClass == 'C' then
          TrackerTriggerTime = 60000
        elseif vehClass == 'B' then
          TrackerTriggerTime = 45000
          TriggerServerEvent('warp-boosting:tracker', spawnedVeh, TrackerTriggerTime, vehClass)
        elseif vehClass == 'A' then
          TrackerTriggerTime = 30000
          TriggerServerEvent('warp-boosting:tracker', spawnedVeh, TrackerTriggerTime, vehClass)
        elseif vehClass == 'S' then
          TrackerTriggerTime = 10000
          TriggerServerEvent('warp-boosting:tracker', spawnedVeh, TrackerTriggerTime, vehClass)
        end

        TriggerEvent('phone:addJobNotify', "Looks like your in the car, the drop location will be pinged.")
        StartedBoost = true
        Wait(120000)
        pedsSpawned = false
        TriggerEvent('phone:addJobNotify', "I Pinged the drop location.")
        TriggerEvent("ls:boostDropOff") 
      end
    end
  -- end)

end)

RegisterNetEvent('trackerGoBr')
AddEventHandler('trackerGoBr', function()
  if IsPedInVehicle(PlayerPedId(),spawnedVeh, false) then
    TriggerEvent('warp-boosting:ping', spawnedVeh)
  end
end)

function mycb(success, remainingtime, finish) 
  if success and finish then
    TriggerEvent('DoLongHudText', 'Tracker Removed')
    local curVeh = GetVehiclePedIsIn(PlayerPedId(), false)
    TriggerServerEvent('setTrackFalse', curVeh)
  end
end

-- RegisterCommand('hok', function()
--   TriggerEvent("mhacking:seqstart", {7,6},90,mycb)
-- end)

RegisterNetEvent('warp-boosting:removeTracker')
AddEventHandler('warp-boosting:removeTracker', function()
  local curVeh = GetVehiclePedIsIn(PlayerPedId(), false)
  if IsPedInAnyVehicle(PlayerPedId(), false) then
    TriggerServerEvent('sv:removeTracker', curVeh)
  end
end)

-- RegisterNetEvent('warp-boosting:trackerMiniGame')
-- AddEventHandler('warp-boosting:trackerMiniGame', function()
--   if vehClass == 'B' then
--     TriggerEvent("mhacking:seqstart", {7,6,5,4},90,mycb)
--   elseif vehClass == 'A' then
--     TriggerEvent("mhacking:seqstart", {7,6,5,4},60,mycb)
--   elseif vehClass == 'S' then
--     TriggerEvent("mhacking:seqstart", {7,6,5,4},45,mycb)
--   end
-- end)

RegisterNetEvent('warp-boosting:trackerMiniGame')
AddEventHandler('warp-boosting:trackerMiniGame', function(vehicleClass)
  if vehicleClass == 'B' then
    TriggerEvent("mhacking:seqstart", {7},90,mycb)
  elseif vehicleClass == 'A' then
    TriggerEvent("mhacking:seqstart", {7},60,mycb)
  elseif vehicleClass == 'S' then
    TriggerEvent("mhacking:seqstart", {7},45,mycb)
  end
end)


-- RegisterNetEvent('warp-boosting:removeTracker')
-- AddEventHandler('warp-boosting:removeTracker', function()
--   Citizen.CreateThread(function()
--     if GetVehiclePedIsIn(PlayerPedId(), false) == spawnedVeh then
--       if vehClass == 'B' then
--         TriggerEvent("mhacking:seqstart", {7,6,5,4},90,mycb)
--       elseif vehClass == 'A' then
--         TriggerEvent("mhacking:seqstart", {7,6,5,4},60,mycb)
--       elseif vehClass == 'S' then
--         TriggerEvent("mhacking:seqstart", {7,6,5,4},45,mycb)
--       end
--     elseif GetVehiclePedIsIn(PlayerPedId(), false) ~= spawnedVeh and IsPedInAnyVehicle(PlayerPedId(), false) then
--       TriggerEvent('DoLongHudText', 'This car does not have a tracker')
--     else
--       TriggerEvent('DoLongHudText', 'You are not in a car')
--     end
--   end)
-- end)

RegisterNetEvent("ls:spawnPed")
AddEventHandler("ls:spawnPed", function(x, y, z, h, weapon)
  
  local pedModels = {
    "a_m_m_rurmeth_01", 
    "a_m_m_soucent_01", 
    "a_m_y_beach_01", 
    "a_m_y_ktown_02", 
    "cs_old_man2", 
    "cs_siemonyetarian",
    "cs_terry"
  }

  Citizen.CreateThread(function()
    AddRelationshipGroup("gangGang")
    local pedRand1 = GetHashKey(pedModels[math.random(1, #pedModels)])
    if not IsModelInCdimage(pedRand1) then return end
    RequestModel(pedRand1)
    while not HasModelLoaded(pedRand1) do
      Citizen.Wait(10)
    end
    local boostingPed1 = CreatePed(30, pedRand1, x, y, z, h, true, false)
    SetPedArmour(boostingPed1, 100)
    SetPedAsEnemy(boostingPed1, true)
    SetPedRelationshipGroupHash(boostingPed1, 'gangGang')
    GiveWeaponToPed(boostingPed1, GetHashKey(weapon), 250, false, true)
    TaskCombatPed(boostingPed1, GetPlayerPed(-1))
    SetPedAccuracy(boostingPed1, math.random(25,75))
    SetPedDropsWeaponsWhenDead(boostingPed1, false)
  end)

end)

RegisterNetEvent("ls:boostDropOff")
AddEventHandler("ls:boostDropOff", function()
  local dropRand = math.random(1, #dropPoint)
  local dropX = dropPoint[dropRand]["x"]
  local dropY = dropPoint[dropRand]["y"]
  local dropZ = dropPoint[dropRand]["z"]

  CreateBlipDropOff(dropX, dropY, dropZ)
  SetNewWaypoint(dropX, dropY)
  TriggerEvent('warp-boosting:ping')

  local isAtDrop = false

  if not isAtDrop then
    Citizen.CreateThread(function()
      while true do 
        Citizen.Wait(2500)
        plyLoc = GetEntityCoords(PlayerPedId())
        local boostCarLoc = GetEntityCoords(spawnedVeh)
        local dist = Vdist(dropX, dropY, dropZ, boostCarLoc.x, boostCarLoc.y, boostCarLoc.z)
        local plyDistFromDrop = Vdist(dropX, dropY, dropZ, plyLoc.x, plyLoc.y, plyLoc.z)
        local isCarAtDropOff = false
        if dist < 2.5 then
          isCarAtDropOff = true
        end
        if dist < 2.5 and isCarAtDropOff and not SentEmail then
          TriggerEvent('phone:addJobNotify',"Leave the car there, get out of here you will be paid.")
          isCarAtDropOff = false
          SentEmail = true
        end
        if dist < 2.5 and plyDistFromDrop > 100.0 then
          isAtDrop = true    
          isCarAtDropOff = false  
          TriggerEvent("ls:boostComplete")
          SentEmail = false
          return
        end
      end
    end)
  end

end)

RegisterNetEvent("ls:boostComplete")
AddEventHandler("ls:boostComplete", function()

  local payment = nil
  
  if vehClass == 'D' then
    payment = 5
  elseif vehClass == 'C' then
    payment = 10
  elseif vehClass == 'B' then
    payment = 15
  elseif vehClass == 'A' then
    payment = 20
  elseif vehClass == 'S' then
    payment = 30
  end

  TriggerEvent('warp-crypto:cl:receive', payment)
  DeleteEntity(spawnedVeh)
  DeleteBlip(blipDropOff)
  TriggerServerEvent("ls:updateBoostLevel", vehClass)
  SendNUIMessage({
    type = 'complete',
  })
end)

-- SHOW / HIDE NUI

local display = false
local isVisible = nil
local tabletObject = nil

-- RegisterCommand("show", function()
--   SetDisplay(not display)
-- end)

RegisterNetEvent("warp-boosting:openLaptop")
AddEventHandler("warp-boosting:openLaptop", function()
  local playerPed = PlayerPedId()
  if not isVisible then
      local dict = "amb@world_human_seat_wall_tablet@female@base"
      RequestAnimDict(dict)
      if tabletObject == nil then
          tabletObject = CreateObject(GetHashKey('prop_cs_tablet'), GetEntityCoords(playerPed), 1, 1, 1)
          AttachEntityToEntity(tabletObject, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.03, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
      end
      while not HasAnimDictLoaded(dict) do Citizen.Wait(100) end
      if not IsEntityPlayingAnim(playerPed, dict, 'base', 3) then
          TaskPlayAnim(playerPed, dict, "base", 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)
      end
  else
      DeleteEntity(tabletObject)
      ClearPedTasks(playerPed)
      tabletObject = nil
  end
  SetDisplay(not display)
end)

function SetDisplay(bool)
  local dayInt = GetClockDayOfWeek()
  local day = nil
  if dayInt == 0 then
    day = 'Sun'
  elseif dayInt == 1 then
    day = 'Mon'
  elseif dayInt == 2 then
    day = 'Tue'
  elseif dayInt == 3 then
    day = 'Wed'
  elseif dayInt == 4 then
    day = 'Thu'
  elseif dayInt == 5 then
    day = 'Fri'
  elseif dayInt == 6 then
    day = 'Sat'
  end
  local monthInt = GetClockMonth()
  local month = nil
  if monthInt == 0 then
    month = 'Jan'
  elseif monthInt == 1 then
    month = 'Feb'
  elseif monthInt == 2 then
    month = 'Mar'
  elseif monthInt == 3 then
    month = 'Apr'
  elseif monthInt == 4 then
    month = 'May'
  elseif monthInt == 5 then
    month = 'Jun'
  elseif monthInt == 6 then
    month = 'Jul'
  elseif monthInt == 7 then
    month = 'Aug'
  elseif monthInt == 8 then
    month = 'Sep'
  elseif monthInt == 9 then
    month = 'Oct'
  elseif monthInt == 10 then
    month = 'Nov'
  elseif monthInt == 11 then
    month = 'Dec'
  end
  local dayOfMonth = GetClockDayOfMonth()
  local date = day .. ' ' .. month .. ' ' .. dayOfMonth
  local hours = tostring(GetClockHours())
  local minutes = tostring(GetClockMinutes())
  local time = hours .. ':' ..  minutes

  display = bool

  if bool ~= nil then
    isVisible = bool
  else
    isVisible = not isVisible
  end

  if not bool then
    local playerPed = PlayerPedId()
    ClearPedTasks(playerPed)
    DeleteEntity(tabletObject)
    tabletObject = nil
  end

  SetNuiFocus(bool, bool)
  SendNUIMessage({
      status = bool,
      type = "ui",
      date = date,
      time = time
  })
end

RegisterNUICallback('close', function(data, cb)
  SetDisplay(false)
  cb('ok')
end)

Citizen.CreateThread(function()
  while display do
      Citizen.Wait(0)
      DisableControlAction(0, 1, guiEnabled) -- LookLeftRight
      DisableControlAction(0, 2, guiEnabled) -- LookUpDown
      DisableControlAction(0, 14, guiEnabled) -- INPUT_WEAPON_WHEEL_NEXT
      DisableControlAction(0, 15, guiEnabled) -- INPUT_WEAPON_WHEEL_PREV
      DisableControlAction(0, 16, guiEnabled) -- INPUT_SELECT_NEXT_WEAPON
      DisableControlAction(0, 17, guiEnabled) -- INPUT_SELECT_PREV_WEAPON
      DisableControlAction(0, 99, guiEnabled) -- INPUT_VEH_SELECT_NEXT_WEAPON
      DisableControlAction(0, 100, guiEnabled) -- INPUT_VEH_SELECT_PREV_WEAPON
      DisableControlAction(0, 115, guiEnabled) -- INPUT_VEH_FLY_SELECT_NEXT_WEAPON
      DisableControlAction(0, 116, guiEnabled) -- INPUT_VEH_FLY_SELECT_PREV_WEAPON
      DisableControlAction(0, 142, guiEnabled) -- MeleeAttackAlternate
      DisableControlAction(0, 106, guiEnabled) -- VehicleMouseControlOverride
  end
end)

RegisterNUICallback('cancelContract', function()
  StartedBoost = false
  DeleteEntity(spawnedVeh)
  print(spawnedVeh)
  if DoesBlipExist(blipBoostLoc) then
		RemoveBlip(blipBoostLoc)
  end
  if DoesBlipExist(blipDropOff) then
		RemoveBlip(blipDropOff)
  end
end)

RegisterNetEvent('dummie-check:boosting')
AddEventHandler('dummie-check:boosting', function()
  if StartedBoost then
    TriggerEvent('warp-boosting:ping')
    TriggerEvent('ls:boostLockPick')
  end
end)