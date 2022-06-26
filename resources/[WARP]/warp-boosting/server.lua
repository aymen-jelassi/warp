RegisterServerEvent("ls:joinQueue")
AddEventHandler("ls:joinQueue", function()
  pSrc = source
  local user = exports["warp-base"]:getModule("Player"):GetUser(pSrc)
	local cid = user:getCurrentCharacter().id

  exports.oxmysql:execute('SELECT * FROM boost_queue WHERE id = ?', {cid}, function(result)
    if result[1] == nil then
      exports.oxmysql:execute("INSERT INTO boost_queue (id, pSrc) VALUES (@cid, @pSrc)", {['@cid'] = cid, ['@pSrc'] = pSrc })
    else
      TriggerClientEvent("DoLongHudText", pSrc, "You are already in queue")
    end
  end)
end)

RegisterServerEvent('ls:leaveQueue')
AddEventHandler('ls:leaveQueue', function()
  pSrc = source
  local user = exports["warp-base"]:getModule("Player"):GetUser(pSrc)
	local cid = user:getCurrentCharacter().id

  exports.oxmysql:execute('SELECT * FROM boost_queue WHERE id = ?', {cid}, function(result)
    if result[1] ~= nil then
      exports.oxmysql:execute("DELETE FROM boost_queue WHERE `id` = @cid", {['@cid'] = cid})
      print("removed" .. " " .. "CID: " .. cid .. " " .."ID:".. pSrc .. " " .. "from boosting queue") 
    end
  end)
end)

RegisterServerEvent("ls:checkXp")
AddEventHandler("ls:checkXp", function()
  local src = source
  local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local cid = user:getCurrentCharacter().id

  exports.oxmysql:execute('SELECT * FROM boost_levels WHERE id = ?', {cid}, function(result)
    if result[1] ~= nil then
      local xp = result[1].xp
      local level = result[1].level
      TriggerClientEvent('xpReceived', src, xp, level)
    end
  end)
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(10000 * 60)
    exports.oxmysql:execute('SELECT * FROM boost_queue', function(result)
      if #result ~= 0 then
        local random = math.random(1, #result)
        if result[random] ~= nil then
          local pSrc = result[random].pSrc
          local cid = result[random].id
          TriggerClientEvent("queueReady", pSrc)
          TriggerClientEvent("phone:addJobNotify", pSrc, "You recieved a contract")
        end
      end
    end)
  end
end)

RegisterServerEvent("checkBoostLevel")
AddEventHandler("checkBoostLevel", function()
  local src = source
  local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local cid = user:getCurrentCharacter().id

  exports.oxmysql:execute('SELECT level FROM boost_levels WHERE id = ?', {cid}, function(result)
    if result[1] ~= nil then
      local level = result[1].level
      TriggerClientEvent("boostLevelReceived", src, level)
    else
      exports.oxmysql:execute("INSERT INTO boost_levels (id, level, xp) VALUES (@cid, @level, @xp)", {['@cid'] = cid, ['@level'] = '1', ['@xp'] = '0'})
      exports.oxmysql:execute('SELECT level FROM boost_levels WHERE id = ?', {cid}, function(result2)
        local level = result2[1].level
        TriggerClientEvent("boostLevelReceived", src, level)
      end)
    end
  end)
end)

RegisterServerEvent("ls:updateBoostLevel")
AddEventHandler("ls:updateBoostLevel", function(boostClass)
  print(boostClass)
  pSrc = source
  local user = exports["warp-base"]:getModule("Player"):GetUser(pSrc)
	local cid = user:getCurrentCharacter().id
  exports.oxmysql:execute('SELECT * FROM boost_levels WHERE id = ?', {cid}, function(result)
    if result[1] ~= nil then
      local xp = result[1].xp
      local level = result[1].level
      xp = xp + math.random(5, 30)
      if xp >= 100 and level < 5 then
        level = level + 1
        xp = 0
      end
      exports.oxmysql:execute("UPDATE boost_levels SET xp = @xp WHERE id = @id", {
        ['xp'] = xp,
        ['id'] = cid
      })
      exports.oxmysql:execute("UPDATE boost_levels SET level = @level WHERE id = @id", {
        ['level'] = level,
        ['id'] = cid
      })
      
    end
  end)
end)

-- PD Tracker Stuff

function indexOf(t, object)
  for k,v in pairs(t) do
    if object == v.spawnedVeh then
      return k
    end
  end
end


local trackerActive = false
local trackers = {}

RegisterCommand('trackTest', function()
  local spawnedVeh = 124125
  trackers[#trackers + 1] = {['spawnedVeh'] = 151251, ['hasTracker'] = true}
  trackers[#trackers + 1] = {['spawnedVeh'] = 112515, ['hasTracker'] = true}
  trackers[#trackers + 1] = {['spawnedVeh'] = spawnedVeh, ['hasTracker'] = true}
  trackers[#trackers + 1] = {['spawnedVeh'] = 988771, ['hasTracker'] = true}
  print(json.encode(trackers))
end)

RegisterCommand('trackPrint', function()
  print(json.encode(trackers))
end)


RegisterServerEvent('warp-boosting:tracker')
AddEventHandler('warp-boosting:tracker', function(spawnedVeh, timer, class)
  local src = source
  local pPed = GetPlayerPed(src)
  Citizen.CreateThread(function()
    
    -- local pPed = GetPlayerPed(src)
    trackers[#trackers + 1] = {['spawnedVeh'] = spawnedVeh, ['hasTracker'] = true, ['vehicleClass'] = class}

    local index = indexOf(trackers, spawnedVeh)
   
    -- print(src)
    while trackers[index]['hasTracker'] do
      Citizen.Wait(timer) 
      -- TriggerClientEvent('warp-dispatch:boostTrackerPing', -1, spawnedVeh)
      TriggerClientEvent('trackerGoBr', src)
      -- print('big fuk')
    end
  end)
end)


RegisterServerEvent('bigFuck')
AddEventHandler('bigFuck', function()
  local src = source
  local pPed = GetPlayerPed(src)

  print(GetVehiclePedIsIn(pPed, false))
end)


RegisterServerEvent('sv:removeTracker')
AddEventHandler('sv:removeTracker', function(curVeh)
  local src = source
  local index = indexOf(trackers, curVeh)

  if index == nil then
    return
  else
    local class = trackers[index]['vehicleClass']
    if trackers[index]['hasTracker'] then
      TriggerClientEvent('warp-boosting:trackerMiniGame', src, class)
      print(class)
    else
      TriggerClientEvent('DoLongHudText', src,'This car does not have a tracker', 4)
    end
  end
  
end)


RegisterServerEvent('setTrackFalse')
AddEventHandler('setTrackFalse', function(curVeh)
  local index = indexOf(trackers, curVeh)
  trackers[index]['hasTracker'] = false
end)