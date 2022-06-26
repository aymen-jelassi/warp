local guiEnabled = false
local hasOpened = false
local lstMsgs = {}
local lstContacts = {}
local inPhone = false
local radioChannel = math.random(1,999)
local usedFingers = false
local dead = false
local onhold = false
local YellowPageArray = {}
local YellowPages = {}
local PhoneBooth = GetEntityCoords(PlayerPedId())
local phoneNotifications = true
local insideDelivers = false
local curhrs = 9
local curmins = 2
local allowpopups = true
local vehicles = {}
local isDead = false
local isNotInCall, isDialing, isReceivingCall, isCallInProgress = 0, 1, 2, 3
local callStatus = isNotInCall
local wallPaper = ""
local pPhoneOpen = false

function pOpen()
  return pPhoneOpen
end

function phasPhone()
  return hasPhone()
end

function pNotify()
  return phoneNotifications
end

CreateThread(function ()
  while true do
    Wait(0)
      if guiEnabled == true then 
        DisableAllControlActions(0)
        DisableAllControlActions(2)
             
        EnableControlAction(0, 32, true)
        EnableControlAction(0, 34, true)
        EnableControlAction(0, 31, true)
        EnableControlAction(0, 30, true)
        EnableControlAction(0, 22, true)
        EnableControlAction(0, 21, true)

        -- car
        EnableControlAction(0, 71, true)
        EnableControlAction(0, 72, true)
        EnableControlAction(0, 59, true)

        -- push to talk
        EnableControlAction(0, 249, true)
      end
    end
end)


RegisterNetEvent("warp-phone:grabBackground")
AddEventHandler("warp-phone:grabBackground", function(link)
    wallPaper = link
end)

RegisterNetEvent("warp-jobmanager:playerBecameJob")
AddEventHandler("warp-jobmanager:playerBecameJob", function(job)
    if job == "trucker" then
        trucker = true
    end
end)

function SetCustomNuiFocus(hasKeyboard, hasMouse)
  HasNuiFocus = hasKeyboard or hasMouse

  SetNuiFocus(hasKeyboard, hasMouse)
  SetNuiFocusKeepInput(HasNuiFocus)

  TriggerEvent("warp:voice:focus:set", HasNuiFocus, hasKeyboard, hasMouse)
end

RegisterNUICallback('btnNotifyToggle', function(data, cb)
    allowpopups = not allowpopups
    if allowpopups then
      TriggerEvent("DoLongHudText","Popups Enabled", 1)
    else
      TriggerEvent("DoLongHudText","Popups Disabled", 2)
    end
end)

RegisterNUICallback('wallpaper', function(data, cb)
  wallPaper = ""
  Wait(5)
  local wallPaperSelecionado = data.wallpaper
  TriggerEvent('warp-phone:grabBackground', wallPaperSelecionado)
  TriggerServerEvent("phone:saveWallpaper", exports['isPed']:isPed('cid'), wallPaperSelecionado)
end)

activeNumbersClient = {}

RegisterNetEvent('phone:reset')
AddEventHandler('phone:reset', function(cidsent)
    closeGui()
    guiEnabled = false
    hasOpened = false
    lstMsgs = {}
    lstContacts = {}
    vehicles = {}
    radioChannel = math.random(1,999)
    dead = false
    onhold = false
    inPhone = false
    wallPaper = ""
    Wait(1)
    TriggerServerEvent('warp-phone:grabWallpaper')
end)

RegisterNetEvent('Yougotpaid')
AddEventHandler('Yougotpaid', function(cidsent)
    if tonumber(cid) == tonumber(cidsent) then
      TriggerEvent("DoLongHudText","Life Invader Payslip Generated.", 1)
    end
end)

RegisterNetEvent("phone:listunpaid")
AddEventHandler("phone:listunpaid", function(outstandingArray)

  SendNUIMessage({
    openSection = "showOutstandingPayments",
    outstandingPayments = outstandingArray
  })
end)
           
RegisterNetEvent('Payment:Successful')
AddEventHandler('Payment:Successful', function()
    SendNUIMessage({
        openSection = "error",
        textmessage = "Payment Processed.",
    })     
end)

RegisterNetEvent('warrants:AddInfo')
AddEventHandler('warrants:AddInfo', function(name, charges)

    openGuiNow()

    SendNUIMessage({
      openSection = "enableoutstanding",
    })
    for i = 1, #charges do

      SendNUIMessage({
        openSection = "inputoutstanding",
        textmessage = charges[i],
      })
    end
    
end)

RegisterNetEvent("phone:activeNumbers")
AddEventHandler("phone:activeNumbers", function(activePhoneNumbers)
  activeNumbersClient = activePhoneNumbers
  hasOpened = false
end)



RegisterNetEvent("gangTasks:updateClients")
AddEventHandler("gangTasks:updateClients", function(newTasks)
  activeTasks = newTasks
end)

TaskState = {
  [1] = "Ready For Pickup",
  [2] = "In Process",
  [3] = "Successful",
  [4] = "Failed",
  [5] = "Delivered with Damaged Goods",
}

TaskTitle = {
  [1] = "Ordering 'Take-Out'",
  [2] = "Ordering 'Disposal Service'",
  [3] = "Ordering 'Postal Delivery'",
  [4] = "Ordering 'Hot Food Room Service'",
}

function findTaskIdFromBlockChain(blockchain)
  local retnum = 1
  for i = 1, #activeTasks do
    if activeTasks[i]["BlockChain"] == blockchain then
      retnum = i
    end
  end
  return retnum
end

-- real estate nui app responses

function loading()
    SendNUIMessage({
        openSection = "error",
        textmessage = "Loading, please wait.",
    })  
end

RegisterNetEvent("phone:setServerTime")
AddEventHandler("phone:setServerTime", function(time)
  SendNUIMessage({
    openSection = "server-time",
    serverTime = time
  })
end)

RegisterNetEvent("timeheader")
AddEventHandler("timeheader", function(hrs,mins)


  if hrs < 10 then
    hrs = "0"..hrs
  end
  if mins < 10 then
    mins = "0"..mins
  end
  curhrs = hrs
  curmins = mins

  local timesent = curhrs .. ":" .. curmins
  if guiEnabled then
    SendNUIMessage({
      openSection = "timeheader",
      timestamp = timesent,
    })   
  end
end)

function doTimeUpdate()
  local timesent = curhrs .. ":" .. curmins
  if guiEnabled then
    SendNUIMessage({
      openSection = "timeheader",
      timestamp = timesent,
    })   
  end
end

RegisterNUICallback('btnGiveKey', function(data, cb)
  TriggerEvent("houses:GiveKey")
end)
RegisterNetEvent("returnPlayerKeys")
AddEventHandler("returnPlayerKeys", function(ownedkeys,sharedkeys)
  
      if not guiEnabled then
        return
      end
      SendNUIMessage({
        openSection = "keys",
        keys = {
          sharedKeys = sharedkeys,
          ownedKeys = ownedkeys
        }
      })
end)

function CellFrontCamActivate(activate)
	return Citizen.InvokeNative(0x2491A93618B7D838, activate)
end

local selfieMode = false
RegisterNUICallback('phone:selfie', function()
  selfieMode = not selfieMode
  if selfieMode then
    closeGui()
    DestroyMobilePhone()
    CreateMobilePhone(4)
    CellCamActivate(true, true)
    CellFrontCamActivate(true)
  else
    closeGui()
    CellCamActivate(false, false)
    CellFrontCamActivate(false)
    DestroyMobilePhone()
    selfieMode = false
  end
end)

RegisterNUICallback('trackTaskLocation', function(data, cb)
    local taskID = findTaskIdFromBlockChain(data.TaskIdentifier)
    TriggerEvent("DoLongHudText","Location Set", 1)

    SetNewWaypoint(activeTasks[taskID]["Location"]["x"],activeTasks[taskID]["Location"]["y"])
end)

function GroupRank(groupid)
  local rank = 0
  local mypasses = exports["isPed"]:isPed("passes")
  for i=1, #mypasses do
    if mypasses[i]["pass_type"] == groupid then
      rank = mypasses[i]["rank"]
    end 
  end
  return rank
end

RegisterNUICallback('bankGroup', function(data)
  local gangid = data.gangid
  local cashamount = data.cashamount
  TriggerServerEvent("server:gankGroup", gangid,cashamount)
end)

RegisterNUICallback('payGroup', function(data)
  local gangid = data.gangid
  local cid = data.cid
  local cashamount = data.cashamount
  TriggerServerEvent("server:givepayGroup", gangid,cashamount,cid)
end)

RegisterNUICallback('promoteGroup', function(data)
  local gangid = data.gangid
  local gangName = data.gangName
  local cid = data.cid
  local newrank = data.newrank
  SendNUIMessage({
      openSection = "error",
      textmessage = "Loading, please wait.",
  })
  TriggerServerEvent("server:givepass2", gangid, gangName, newrank, cid)
end)

RegisterNetEvent("phone:error")
AddEventHandler("phone:error", function()
    SendNUIMessage({
      openSection = "error",
      textmessage = "Network Error",
    })   
end)

RegisterNUICallback('manageGroup', function(data)
  TriggerEvent('phone:don:getStuff', data)
end)

RegisterNetEvent('phone:don:getStuff', function(data)
    local groupid = data.GroupID
    local rank = GroupRank(groupid)
    SendNUIMessage({
      openSection = "error",
      textmessage = "Loading, please wait.",
    })   

    TriggerServerEvent("group:pullinformation",groupid,rank)
end)

RegisterNUICallback('btnProperty', function(data, cb)
  loading()
    SendNUIMessage({
        openSection = "RealEstate",
        RERank = realEstateRank
    })        
end)



RegisterNUICallback('wenmo', function(data, cb)
  SendNUIMessage({
    openSection = "bankManage",
    groupData = {
      groupName = 'poop',
      bank = 'poop',
      groupId = 'poop',
      employees = 'poop',
    }
  })  
  loading()

      
  
end)


RegisterNUICallback('btnProperty2', function(data, cb)
  loading()
  TriggerServerEvent("ReturnHouseKeys", exports['isPed']:isPed('cid'))
end)

RegisterNUICallback('btnPayMortgage', function(data, cb)
  loading()
  TriggerEvent("housing:attemptpay")
end)

RegisterNUICallback('retrieveHouseKeys', function(data, cb)
  TriggerEvent("houses:retrieveHouseKeys")
  cb('ok')
end)

RegisterNUICallback('btnFurniture', function(data, cb)
  closeGui()
  --TriggerEvent("DoLongHudText", "Coming soon.", 2)
  TriggerEvent("openFurniture")
end)

RegisterNUICallback('btnPropertyModify', function(data, cb)
TriggerEvent("housing:info:realtor","modify")
end)

RegisterNUICallback('removeHouseKey', function(data, cb)
  TriggerEvent("houses:removeHouseKey", data.targetId)
  cb('ok')
end)


RegisterNUICallback('removeSharedKey', function(data, cb)
  local cid = exports["isPed"]:isPed("cid")
  TriggerServerEvent("houses:removeSharedKey", data.house_id, cid)
  cb('ok')
end)

RegisterNUICallback('btnPropertyReset', function(data, cb)
TriggerEvent("housing:info:realtor","reset")
end)

RegisterNUICallback('btnPropertyClothing', function(data, cb)
TriggerEvent("housing:info:realtor","setclothing")
end)

RegisterNUICallback('btnPropertyStorage', function(data, cb)
TriggerEvent("housing:info:realtor","setstorage")
end)

RegisterNUICallback('btnPropertySetGarage', function(data, cb)
TriggerEvent("housing:info:realtor","setgarage")
end)

RegisterNUICallback('btnPropertyWipeGarages', function(data, cb)
TriggerEvent("housing:info:realtor","wipegarages")
end)

RegisterNUICallback('btnPropertySetBackdoorInside', function(data, cb)
TriggerEvent("housing:info:realtor","backdoorinside")
end)

RegisterNUICallback('btnPropertySetBackdoorOutside', function(data, cb)
TriggerEvent("housing:info:realtor","backdooroutside")
end)

RegisterNUICallback('btnPropertyUpdateHouse', function(data, cb)
TriggerEvent("housing:info:realtor","update")
end)

RegisterNUICallback('btnRemoveSharedKey', function(data, cb)
TriggerEvent("housing:info:realtor","update")
end)

RegisterNUICallback('btnPropertyOutstanding', function(data, cb)
  TriggerEvent("housing:info:realtor","PropertyOutstanding")
  end)

RegisterNUICallback('btnPropertyUnlock', function(data, cb)
  TriggerEvent("housing:info:realtor","unlock")
end)

RegisterNUICallback('btnPropertyUnlock2', function(data, cb)
  TriggerEvent("housing:info:realtor","unlock2")
end)

RegisterNUICallback('btnPropertyHouseCreationPoint', function(data, cb)
TriggerEvent("housing:info:realtor","creationpoint")
end)
RegisterNUICallback('btnPropertyStopHouse', function(data, cb)
TriggerEvent("housing:info:realtor","stop")
end)
RegisterNUICallback('btnAttemptHouseSale', function(data, cb)
TriggerEvent("housing:findsalecid",data.cid,data.price)
end)
RegisterNUICallback('btnTransferHouse', function(data, cb)
TriggerEvent("housing:transferHouseAttempt", data.cid)
end)
RegisterNUICallback('btnEvictHouse', function(data, cb)
TriggerEvent("housing:evictHouseAttempt")
end)
RegisterNUICallback('btnGiveKey', function(data, cb)
  TriggerEvent("houses:GiveKey")
end)
RegisterNUICallback('btnFurniture', function(data, cb)
  closeGui()
  TriggerEvent("openFurniture")
end)

--//3.0 housing
RegisterNUICallback('housing:checkProperty', function(data)
  local ply = PlayerPedId()
  local plyCoords = GetEntityCoords(ply, 1)  
  local propertyFound, propertyName, propertyPrice, propertyCategory = exports["warp-housing"]:checkForProperty()
  if propertyFound then
  SendNUIMessage({
	openSection = "housing:foundProperty",
  foundHouse = propertyFound,
	foundHouseName = propertyName,
	foundHousePrice = propertyPrice,
  foundHouseCategory = propertyCategory
  })
  else
    SendNUIMessage({
	  openSection = "housing:noPropertyFound",
    foundHouse = false
	})
  end
end)

RegisterNUICallback('housing:closeModal', function(data)
  SendNUIMessage({
	  openSection = "housing:closeModal"
  })
  TriggerEvent("HousesUpdatePhone")
end)

RegisterNUICallback('housing', function()
  local cid = exports["isPed"]:isPed("cid")
  TriggerEvent("HousesUpdatePhone")
end)


RegisterNUICallback('housing:buyProperty', function(data)
    local result, propertyName, propertySold, enoughMoney = exports["warp-housing"]:attemptPurchase()

    if result == "success" then
    SendNUIMessage({
	  openSection = "housing:purchaseSuccessful",
    boughtProperty = true,
	  boughtPropertyName = propertyName
	  })
    TriggerEvent("HousesUpdatePhone")
    elseif result == "sold" then
      SendNUIMessage({
        openSection = "housing:purchasePropertySold",
        boughtProperty = false,
        isPropertySold = propertySold
        })
    elseif result == "notenough" then
      SendNUIMessage({
        openSection = "housing:purchaseNotEnoughMoney",
        boughtProperty = false,
        hasEnoughMoney = false
        })
    elseif result == "toomany" then
      SendNUIMessage({
        openSection = "housing:purchaseTooManyProperties",
        boughtProperty = false,
        hasEnoughMoney = true,
        tooManyProperties = true
        })
    end
	
end)

RegisterNetEvent('HousesUpdatePhone')
AddEventHandler('HousesUpdatePhone', function()
  local wharray = RPC.execute("phone:getProperties")
  warehouses = {}

  -- for i = 1, #wharray do
  --   warehouses[#warehouses + 1] = {
  --       id = tonumber(i),
  --       warehousename = wharray[tonumber(i)].propertyname,
  --       warehouselocked = wharray[tonumber(i)].locked,
  --       propertyicon = wharray[tonumber(i)].icon,
  --       propertyowner = wharray[tonumber(i)].cid
  --     }
  -- end
  
  for _,pData in pairs(wharray) do
    if #warehouses > 0 then
      local duplicated = false
      for k,pWarehouse in pairs(warehouses) do
        if pWarehouse.warehousename == pData.propertyname then
          duplicated = true
        end
      end
      if not duplicated then
        warehouses[#warehouses + 1] = {
          warehousename = pData.propertyname,
          warehouselocked = pData.locked,
          propertyicon = pData.icon,
          propertyowner = pData.cid,
          propertycategory = pData.category,
          propertyid = pData.property_id
        }
      end
    else
      warehouses[#warehouses + 1] = {
        warehousename = pData.propertyname,
        warehouselocked = pData.locked,
        propertyicon = pData.icon,
        propertyowner = pData.cid,
        propertycategory = pData.category,
        propertyid = pData.property_id
      }
    end
  end
  
  SendNUIMessage({openSection = "housing", owned = warehouses})
end)

RegisterNUICallback('lockProperty', function(data, cb)
  local cid = exports['isPed']:isPed('cid')
  local result = RPC.execute("phone:lockProperty", data.propertyname)
  if result == "success" then
    TriggerEvent("DoLongHudText", "Locked Property!", 2)
    TriggerEvent("HousesUpdatePhone")
  end
  cb('ok')
end)

RegisterNUICallback('unlockProperty', function(data, cb)
  local cid = exports['isPed']:isPed('cid')
  local result = RPC.execute("phone:unlockProperty", data.propertyname)
  if result == "success" then
    TriggerEvent("DoLongHudText", "Unlocked Property!", 1)
    TriggerEvent("HousesUpdatePhone")
  end
  cb('ok')
end)

RegisterNUICallback('manageKeys', function(data, cb)
  local cid = exports['isPed']:isPed('cid')
  if tostring(data.propertyowner) == tostring(cid) then

    local keys = RPC.execute("phone:getPropertyKeys", data.propertyid) --use propertyid

    local allkeys = {}

    --if keys == nil then SendNUIMessage({openSection = "manageKeys", keys = allkeys}) return end

    for i = 1, #keys do

      local first_name, last_name = RPC.execute("phone:getFirstLastName", keys[tonumber(i)].cid)

      allkeys[#allkeys + 1] = {
          id = tonumber(i),
          cid = keys[tonumber(i)].cid,
          firstname = first_name,
          lastname = last_name,
          property_id = data.propertyid
        }

    end
  SendNUIMessage({openSection = "manageKeys", propertykeys = allkeys, property_id = data.propertyid})
  else
  TriggerEvent("DoLongHudText", "Only owner can manage keys.", 2)
  end 
  cb('ok')
end)

RegisterNUICallback('updatePropertyKeys', function(data, cb)
  local cid = data.cid
  local curkeys = RPC.execute("phone:getCurrentKeys", data.propertyname)
  if curkeys ~= nil then
  local result = RPC.execute("phone:updatePropertyKeys", cid, data.propertyname, curkeys)
  if result then
  TriggerEvent("DoLongHudText", "Successfully gave keys!", 1)
  cb('ok')
  SendNUIMessage({
	  openSection = "housing:propertyKeysSuccess"
  })
  else
  TriggerEvent("DoLongHudText", "Error giving keys.", 2)
  cb('ok')
  end
  else
  local result = RPC.execute("phone:updatePropertyKeys", cid, data.propertyname, "null")
  if result then
  TriggerEvent("DoLongHudText", "Successfully gave keys!", 1)
  cb('ok')
  SendNUIMessage({
	  openSection = "housing:propertyKeysSuccess"
  })
  else
  TriggerEvent("DoLongHudText", "Error giving keys.", 2)
  cb('ok')
  end
  end
end)



-- real estate nui app responses end

function GroupName(groupid)
  local name = "Error Retrieving Name"
  local mypasses = exports["isPed"]:isPed("passes")
  for i=1, #mypasses do
    if mypasses[i]["pass_type"] == groupid then
      name = mypasses[i]["business_name"]
    end 
  end
  return name
end


RegisterNetEvent("group:fullList")
AddEventHandler("group:fullList", function(result,bank,groupid)

    -- group-manage
    local groupname = GroupName(groupid)
    SendNUIMessage({
      openSection = "groupManage",
      groupData = {
        groupName = groupname,
        bank = bank,
        groupId = groupid,
        employees = result
      }
    })

end)

local recentcalls = {}

RegisterNUICallback('getCallHistory', function()
  SendNUIMessage({
    openSection = "callHistory",
    callHistory = recentcalls
  })
end)


RegisterNUICallback('btnTaskGroups', function()

  local mypasses = exports["isPed"]:isPed("passes")

  local groupObject = {}
  for i = 1, #mypasses do
      local rankConverted = "No Association"
      rank = mypasses[i]["rank"]
      if rank == 1 then
        rankConverted = "Associate"
      elseif rank == 2 then
        rankConverted = "Management"
      elseif rank == 3 then
        rankConverted = "Partner"
      elseif rank == 4 then
        rankConverted = "Part-Time Manager"
      elseif rank == 5 then
        rankConverted = "CEO"
      end
      if rank > 0 then
        table.insert(groupObject, {
          namesent = mypasses[i]["business_name"],
          ranksent = rankConverted,
          idsent = mypasses[i]["pass_type"]
        })
      end
  end

  SendNUIMessage({
    openSection = "groups",
    groups = groupObject
  })
end)

RegisterNUICallback('btnJobCenter', function()
  SendNUIMessage({
    openSection = "job-center",
  })
end)

RegisterNUICallback('btnTaskGang', function()
  TriggerEvent("gangTasks:updated")
end)



local pcs = {
  [1] = 1333557690,
  [2] = -1524180747, 
}


function IsNearPC()
  for i = 1, #pcs do
    local objFound = GetClosestObjectOfType( GetEntityCoords(PlayerPedId()), 0.75, pcs[i], 0, 0, 0)

    if DoesEntityExist(objFound) then
      TaskTurnPedToFaceEntity(PlayerPedId(), objFound, 3.0)
      return true
    end
  end

  if #(GetEntityCoords(PlayerPedId()) - vector3(1272.27, -1711.91, 54.78)) < 1.0 then
    SetEntityHeading(PlayerPedId(),14.0)
    return true
  end
  if #(GetEntityCoords(PlayerPedId()) - vector3(1275.4, -1710.52, 54.78)) < 5.0 then
    SetEntityHeading(PlayerPedId(),300.0)
    return true
  end


  return false
end

RegisterNetEvent("open:deepweb")
AddEventHandler("open:deepweb", function()
  SetNuiFocus(false,false)
  SetNuiFocus(true,true)
  guiEnabled = true
  SendNUIMessage({
    openSection = "deepweb" 
  })
end)

RegisterNetEvent("gangTasks:updated")
AddEventHandler("gangTasks:updated", function()
  local taskObject = {}
  for i = 1, #activeTasks do

    if activeTasks[i]["Gang"] ~= 0 and gang ~= 0 and tonumber(activeTasks[i]["taskOwnerCid"]) ~= cid then
      if gang == activeTasks[i]["Gang"] then
        taskObject[#taskObject + 1 ] = {
          name = TaskTitle[activeTasks[i]["TaskType"]],
          assignedTo = activeTasks[i]["taskOwnerCid"],
          status = TaskState[activeTasks[i]["TaskState"]],
          identifier = activeTasks[i]["BlockChain"],
          groupId = gang,
          retrace = 0,
        }
      end
    elseif activeTasks[i]["Gang"] == 0 and tonumber(activeTasks[i]["taskOwnerCid"]) ~= cid then
      
      local passes = exports["isPed"]:isPed("passes")
      for z = 1, #passes do

        local passType = activeTasks[i]["Group"]
        if passes[z].pass_type == passType and (passes[z].rank == 2 or passes[z].rank > 3) then
          taskObject[#taskObject + 1 ] = {
            name = activeTasks[i]["TaskNameGroup"],
            assignedTo = activeTasks[i]["taskOwnerCid"],
            status = TaskState[activeTasks[i]["TaskState"]],
            identifier = activeTasks[i]["BlockChain"],
            groupId = passType,
            retrace = 0,
          }
        end

      end

    else
      if tonumber(activeTasks[i]["taskOwnerCid"]) == cid then

        local TaskName = ""
        if activeTasks[i]["Gang"] == 0 then
          TaskName = activeTasks[i]["TaskNameGroup"]
        else
          TaskName = TaskTitle[activeTasks[i]["TaskType"]]
        end
        taskObject[#taskObject + 1 ] = {
          name = TaskName,
          assignedTo = activeTasks[i]["taskOwnerCid"],
          status = TaskState[activeTasks[i]["TaskState"]],
          identifier = activeTasks[i]["BlockChain"],
          groupId = gang,
          retrace = 1
        }
      end
    end
  end

  SendNUIMessage({
    openSection = "addTasks",
    tasks = taskObject
  })
end)

RegisterNetEvent("purchasePhone")
AddEventHandler("purchasePhone", function()
  TriggerServerEvent("purchasePhone")
end)

RegisterNUICallback('btnMute', function()
  if phoneNotifications then
    TriggerEvent("DoLongHudText","Notifications Disabled.", 2)
  else
    TriggerEvent("DoLongHudText","Notifications Enabled.", 1)
  end
  phoneNotifications = not phoneNotifications
end)

RegisterNetEvent("tryTweet")
AddEventHandler("tryTweet", function(tweetinfo,message,user)
  if hasPhone() then
    TriggerServerEvent("AllowTweet",tweetinfo,message)
  end
end)

RegisterNUICallback('btnDecrypt', function()
  TriggerEvent("secondaryjob:accepttask")
end)



RegisterNUICallback('btnGarage', function()
  TriggerServerEvent("garages:loaded:in")
end)

RegisterNUICallback('btnHelp', function()
  closeGui()
  TriggerEvent("openWiki")
end)

RegisterNUICallback('carpaymentsowed', function()
  TriggerEvent("car:carpaymentsowed")
end)

RegisterNUICallback('vehspawn', function(data)
  RPC.execute("phone:attempt:sv", data.vehplate)
end)

RegisterNUICallback('vehtrack', function(data)
  TriggerServerEvent("get:vehicle:coords", data.vehplate)
end)


RegisterNUICallback('vehiclePay', function(data)
  TriggerServerEvent('car:dopayment', data.vehiclePlate)
end)

RegisterNetEvent("phone:carspawn", function(data,coords,state)
  for ind, value in pairs(data) do
    if state == "Out" then
      if #(vector3(coords[1],coords[2],coords[3]) - GetEntityCoords(PlayerPedId())) < 10.0 then
       -- DeleteBlip()
        trackVehicle = false
        SpawnVehicle(value.model, coords[1],coords[2],coords[3], value.fuel, value.data, value.license_plate, true,value.engine_damage,value.body_damage)
      else
        TriggerEvent("DoLongHudText","Nao podes tirar o veiculo de tao longe.", 2)
      end
    else
      TriggerEvent("DoLongHudText","Veiculo esta numa garagem.", 2)
    end
  end
end)

CurrentDisplayVehicle, ParkingSpot = nil, nil

function SpawnVehicle(vehicle, x,y,z, Fuel, customized, plate, IsViewing, enginehealth, bodyhealth)
	local car = GetHashKey(vehicle)
	local customized = json.decode(customized)
	Citizen.CreateThread(function()			
		Citizen.Wait(100)
        RequestModel(car)
        while not HasModelLoaded(car) do
            Citizen.Wait(0)
        end
        veh = CreateVehicle(car, x, y, z, true, false)
        SetModelAsNoLongerNeeded(car)
        DecorSetBool(veh, "PlayerVehicle", true)
        SetVehicleOnGroundProperly(veh)
        SetVehicleDirtLevel(veh, 0.0)
        SetEntityInvincible(veh, false) 
        SetVehicleNumberPlateText(veh, plate)
        SetVehicleProps(veh, customized)
        TriggerEvent("keys:addNew",veh, plate)
        SetVehicleHasBeenOwnedByPlayer(veh,true)
        local id = NetworkGetNetworkIdFromEntity(veh)
        SetNetworkIdCanMigrate(id, true)
        if not IsViewing then    
            CurrentDisplayVehicle = nil
            RPC.execute("warp-garages:states", "Out", plate, exports['warp-menu']:currentGarage(), pUpdatedFuel)
        end
    end)
end

function SetVehicleProps(veh, customized)
  SetVehicleModKit(veh, 0)
  if customized then
      
      SetVehicleWheelType(veh, customized.wheeltype)
      SetVehicleNumberPlateTextIndex(veh, 3)

      for i = 0, 16 do
          SetVehicleMod(veh, i, customized.mods[tostring(i)])
      end

      for i = 17, 22 do
          ToggleVehicleMod(veh, i, customized.mods[tostring(i)])
      end

      for i = 23, 24 do
          local isCustom = customized.mods[tostring(i)]
          if (isCustom == nil or isCustom == "-1" or isCustom == false or isCustom == 0) then
              isSet = false
          else
              isSet = true
          end
          SetVehicleMod(veh, i, customized.mods[tostring(i)], isCustom)
      end

      for i = 23, 48 do
          SetVehicleMod(veh, i, customized.mods[tostring(i)])
      end

      for i = 0, 3 do
          SetVehicleNeonLightEnabled(veh, i, customized.neon[tostring(i)])
      end

      if customized.extras ~= nil then
          for i = 1, 12 do
              local onoff = tonumber(customized.extras[i])
              if onoff == 1 then
                  SetVehicleExtra(veh, i, 0)
              else
                  SetVehicleExtra(veh, i, 1)
              end
          end
      end

      if customized.oldLiveries ~= nil and customized.oldLiveries ~= 24  then
          SetVehicleLivery(veh, customized.oldLiveries)
      end

      if customized.plateIndex ~= nil and customized.plateIndex ~= 4 then
          SetVehicleNumberPlateTextIndex(veh, customized.plateIndex)
      end

      -- Xenon Colors
      SetVehicleXenonLightsColour(veh, (customized.xenonColor or -1))
      SetVehicleColours(veh, customized.colors[1], customized.colors[2])
      SetVehicleExtraColours(veh, customized.extracolors[1], customized.extracolors[2])
      SetVehicleNeonLightsColour(veh, customized.lights[1], customized.lights[2], customized.lights[3])
      SetVehicleTyreSmokeColor(veh, customized.smokecolor[1], customized.smokecolor[2], customized.smokecolor[3])
      SetVehicleWindowTint(veh, customized.tint)
      SetVehicleInteriorColour(veh, customized.dashColour)
      SetVehicleDashboardColour(veh, customized.interColour)
  else

      SetVehicleColours(veh, 0, 0)
      SetVehicleExtraColours(veh, 0, 0)

  end
end

function findVehFromPlateAndLocate(plate)

  for ind, value in pairs(vehicles) do

    vehPlate = value.license_plate
  if vehPlate == plate then
    coordlocation = value.coords
    SetNewWaypoint(coordlocation[1], coordlocation[2], coordlocation[3])
    end
  end
end



function Trim(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end



local recentspawnrequest = false
function findVehFromPlateAndSpawn(plate)

  if IsPedInAnyVehicle(PlayerPedId(), false) then
    return
  end

  for ind, value in pairs(vehicles) do

    vehPlate = value.license_plate
    if vehPlate == plate then
      state = value.vehicle_state
      coordlocation = value.coords

      if #(vector3(coordlocation[1],coordlocation[2],coordlocation[3]) - GetEntityCoords(PlayerPedId())) < 10.0 and state == "Out" then

        local DoesVehExistInProximity = CheckExistenceOfVehWithPlate(vehPlate)

        if not DoesVehExistInProximity and not recentspawnrequest then
          recentspawnrequest = true
          TriggerServerEvent("garages:phonespawn",vehPlate)
          Wait(10000)
          recentspawnrequest = false
        else
          print("Found vehicle already existing!")
        end

      end

    end

  end

end

RegisterNetEvent("phone:SpawnVehicle")
AddEventHandler('phone:SpawnVehicle', function(vehicle, plate, customized, state, Fuel, coordlocation)
  TriggerEvent("garages:SpawnVehicle", vehicle, plate, customized, state, Fuel, coordlocation)
end)




Citizen.CreateThread(function()
  local invehicle = false
  local plateupdate = "None"
  local vehobj = 0
  while true do
      Wait(1000)
      if not invehicle and IsPedInAnyVehicle(PlayerPedId(), false) then
        local playerPed = PlayerPedId()
        local veh = GetVehiclePedIsIn(playerPed, false)
          if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
            vehobj = veh
            local checkplate = GetVehicleNumberPlateText(veh)
            invehicle = true
            plateupdate = checkplate
            local coords = GetEntityCoords(vehobj)
            coords = { coords["x"], coords["y"], coords["z"] }
            TriggerServerEvent("vehicle:coords",plateupdate,coords)
          end
      end
      if invehicle and not IsPedInAnyVehicle(PlayerPedId(), false) then
        local coords = GetEntityCoords(vehobj)
        coords = { coords["x"], coords["y"], coords["z"] }
        TriggerServerEvent("vehicle:coords",plateupdate,coords)
        invehicle = false
        plateupdate = "None"
        vehobj = 0
      end  
  end
end)



function CheckExistenceOfVehWithPlate(platesent)
  local playerped = PlayerPedId()
  local playerCoords = GetEntityCoords(playerped)
  local handle, scannedveh = FindFirstVehicle()
  local success
  local rped = nil
  local distanceFrom
  repeat
      local pos = GetEntityCoords(scannedveh)
      local distance = #(playerCoords - pos)
        if distance < 50.0 then
          local checkplate = GetVehicleNumberPlateText(scannedveh)
          if checkplate == platesent then
            return true
          end
        end
      success, scannedveh = FindNextVehicle(handle)
  until not success
  EndFindVehicle(handle)
  return false
end

local currentVehicles = {}

RegisterNetEvent("phone:Garage")
AddEventHandler("phone:Garage", function(vehs)
  vehicles = vehs
  local showCarPayments = false
  local rankCarshop = exports["isPed"]:GroupRank("car_shop")
  local rankImport = exports["isPed"]:GroupRank("illegal_carshop")
  local job = exports["isPed"]:isPed("myjob")


  if rankCarshop > 0 or rankImport > 0 or job == "judge" or job == "police" or job == "sheriff" or job == "state"then
    showCarPayments = true
  end

  local parsedVehicleData = {}
  for ind, value in pairs(vehs) do
    enginePercent = value.engine_damage / 10
    bodyPercent = value.body_damage / 10
    vehName = value.name
    vehPlate = value.license_plate
    currentGarage = value.current_garage
    state = value.vehicle_state
    
    -- coordlocation = value.coords
    -- local carcoords = json.decode(coordlocation)
   -- coordlocation = vehCoords
    --local coordlocation = RPC.execute("GetVehCoords",vehPlate)
   -- print(carcoords[1])
   -- allowspawnattempt = 0
    --canSpawn = 0
    -- if #(vector3(coordlocation[1], coordlocation[2], coordlocation[3]) - GetEntityCoords(PlayerPedId())) < 20.0 and state == "Out" then
    --   allowspawnattempt = 1
    --   canSpawn = 1
    -- end
  
    table.insert(parsedVehicleData, {
      name = vehName,
      plate = vehPlate,
      garage = currentGarage,
      state = state,
      enginePercent = enginePercent,
      bodyPercent = bodyPercent,
      payments = value.payments_left, -- total payments left
      lastPayment = value.last_payment, -- Days left
      amountDue = value.financed, -- amount due
      coordlocation = coordlocation,
      canSpawn = 1
    })
  end
  
  SendNUIMessage({ openSection = "Garage", showCarPaymentsOwed = showCarPayments, vehicleData = parsedVehicleData})
end)



local pickuppoints = {
  [1] =  { ['x'] = 923.94,['y'] = -3037.88,['z'] = 5.91,['h'] = 270.81, ['info'] = ' Shipping Container BMZU 822693' },
  [2] =  { ['x'] = 938.02,['y'] = -3026.28,['z'] = 5.91,['h'] = 265.85, ['info'] = ' Shipping Container BMZU 822693' },
  [3] =  { ['x'] = 1006.17,['y'] = -3028.94,['z'] = 5.91,['h'] = 269.31, ['info'] = ' Shipping Container BMZU 822693' },
  [4] =  { ['x'] = 1020.42,['y'] = -3044.91,['z'] = 5.91,['h'] = 87.37, ['info'] = ' Shipping Container BMZU 822693' },
  [5] =  { ['x'] = 1051.75,['y'] = -3045.09,['z'] = 5.91,['h'] = 268.37, ['info'] = ' Shipping Container BMZU 822693' },
  [6] =  { ['x'] = 1134.92,['y'] = -2992.22,['z'] = 5.91,['h'] = 87.9, ['info'] = ' Shipping Container BMZU 822693' },
  [7] =  { ['x'] = 1149.1,['y'] = -2976.06,['z'] = 5.91,['h'] = 93.23, ['info'] = ' Shipping Container BMZU 822693' },
  [8] =  { ['x'] = 1121.58,['y'] = -3042.39,['z'] = 5.91,['h'] = 88.49, ['info'] = ' Shipping Container BMZU 822693' },
  [9] =  { ['x'] = 830.58,['y'] = -3090.46,['z'] = 5.91,['h'] = 91.15, ['info'] = ' Shipping Container BMZU 822693' },
  [10] =  { ['x'] = 830.81,['y'] = -3082.63,['z'] = 5.91,['h'] = 271.61, ['info'] = ' Shipping Container BMZU 822693' },
  [11] =  { ['x'] = 909.91,['y'] = -2976.51,['z'] = 5.91,['h'] = 271.02, ['info'] = ' Shipping Container BMZU 822693' },
}


function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end
blip = 0

function CreateBlip(location)
    DeleteBlip()
    blip = AddBlipForCoord(location["x"],location["y"],location["z"])
    SetBlipSprite(blip, 514)
    SetBlipScale(blip, 1.0)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Pick Up")
    EndTextCommandSetBlipName(blip)
end
function DeleteBlip()
  if DoesBlipExist(blip) then
    RemoveBlip(blip)
  end
end

function refreshmail()
    lstnotifications = {}
    for i = 1, #curNotifications do

        local message2 = {
          id = tonumber(i),
          name = curNotifications[tonumber(i)].name,
          message = curNotifications[tonumber(i)].message
        }
        lstnotifications[#lstnotifications+1]= message2
    end
    SendNUIMessage({openSection = "notifications", list = lstnotifications})
end

local weaponList = {
  [1] = 324215364,
  [2] = 736523883,
  [3] = 4024951519,
  [4] = 1627465347,
}

local weaponListSmall = {
  [1] = 2017895192,
  [2] = 584646201,
  [3] = 3218215474,
}

local luckList = {
  [1] =  "extended_ap",
  [2] =  "extended_sns",
  [3] =  "extended_micro",
  [4] =  "rifleammo",
  [5] =  "heavyammo",
  [6] =  "lmgammo",
}

-- RegisterNUICallback('btnDelivery', function()
--   TriggerEvent("trucker:confirmation")
-- end)

-- RegisterNUICallback('btnPackages', function()
--   insideDelivers = true
--   TriggerEvent("Trucker:GetPackages")
-- end)

-- RegisterNUICallback('btnTrucker', function()
--   TriggerEvent("Trucker:GetJobs")
-- end)

-- RegisterNUICallback('resetPackages', function()
--   insideDelivers = false
-- end)


-- RegisterNetEvent("phone:trucker")
-- AddEventHandler("phone:trucker", function(jobList)

--   local deliveryObjects = {}
--   for i, v in pairs(jobList) do
--     local nameTag = ""
--     local itemTag
--     local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(v.pickup[1], v.pickup[2], v.pickup[3], currentStreetHash, intersectStreetHash)
--     local currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
--     local intersectStreetName = GetStreetNameFromHashKey(intersectStreetHash)

--     local currentStreetHash2, intersectStreetHash2 = GetStreetNameAtCoord(v.drop[1], v.drop[2], v.drop[3], currentStreetHash2, intersectStreetHash2)
--     local currentStreetName2 = GetStreetNameFromHashKey(currentStreetHash2)
--     local intersectStreetName2 = GetStreetNameFromHashKey(intersectStreetHash2)
--     if v.active == 0 then
--         table.insert(deliveryObjects, {
--           targetStreet = currentStreetName2,
--           jobId = v.id,
--           jobType = v.JobType
--         })
--     end
--   end 
--   SendNUIMessage({
--     openSection = "deliveryJob",
--     deliveries = deliveryObjects
--   })
    
-- end)

-- local requestHolder = 0

-- RegisterNetEvent("phone:packages")
-- AddEventHandler("phone:packages", function(packages)
--   while insideDelivers do
--     if requestHolder ~= 0 then
--       SendNUIMessage({
--         openSection = "packagesWith"
--       })
--     else
--       SendNUIMessage({
--         openSection = "packages"
--       })
--     end
    
    
--     for i, v in pairs(packages) do
--       if GetPlayerServerId(PlayerId()) == v.source then
--         local currentStreetHash2, intersectStreetHash2 = GetStreetNameAtCoord(v.drop[1], v.drop[2], v.drop[3], currentStreetHash2, intersectStreetHash2)
--         local currentStreetName2 = GetStreetNameFromHashKey(currentStreetHash2)
--         local intersectStreetName2 = GetStreetNameFromHashKey(intersectStreetHash2)

--         SendNUIMessage({openSection = "addPackages", street2 = currentStreetName2, jobId = v.id ,distance = getDriverDistance(v.driver , v.drop)})
--       end
--     end 
--     Wait(4000)
--   end
-- end)


-- RegisterNetEvent("phone:OwnerRequest")
-- AddEventHandler("phone:OwnerRequest", function(holder)
--   requestHolder = holder
-- end)

-- RegisterNUICallback('btnRequest', function()
--   TriggerServerEvent("trucker:confirmRequest",requestHolder)
--   requestHolder = 0
-- end)




-- function getDriverDistance(driver , drop)
--   local dist = 0

--   local ped = GetPlayerPed(value)
--   if driver ~= 0 then
--     local current = #(vector3(drop[1],drop[2],drop[3]) - GetEntityCoords(ped))
--     if current < 15 then
--       dist = "Driver at store"
--     else
--       dist = current
--       dist = math.ceil(dist)
--     end
    
--   else
--     dist = "Waiting for driver"
--   end

--   return dist
-- end

RegisterNUICallback('selectedJob', function(data, cb)
    TriggerEvent("Trucker:SelectJob",data)
end)

-- gurgleList = {}
-- RegisterNetEvent('websites:updateClient')
-- AddEventHandler('websites:updateClient', function(passedList)
--   gurgleList = passedList

--   local gurgleObjects = {}

--   if not guiEnabled then
--     return
--   end

--   for i = 1, #gurgleList do
--     table.insert(gurgleObjects, {
--       webTitle = gurgleList[i]["Title"], 
--       webKeywords = gurgleList[i]["Keywords"], 
--       webDescription = gurgleList[i]["Description"] 
--     })
--   end

--   SendNUIMessage({ openSection = "gurgleEntries", gurgleData = gurgleObjects})
-- end)

function hasPhone()
  return true
end


function DrawRadioChatter(x,y,z, text,opacity)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    if opacity > 215 then
      opacity = 215
    end
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, opacity)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end
local activeMessages = 0

RegisterNetEvent('radiotalkcheck')
AddEventHandler('radiotalkcheck', function(args,senderid)

  if hasRadio() and radioChannel ~= 0 then
    randomStatic(true)

    local ped = GetPlayerPed( -1 )

      if ( DoesEntityExist( ped ) and not IsEntityDead( ped )) then

        loadAnimDict( "random@arrests" )

        TaskPlayAnim(ped, "random@arrests", "generic_radio_chatter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )

        SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
      end


    TriggerServerEvent("radiotalkconfirmed",args,senderid,radioChannel)
    Citizen.Wait(2500)
    ClearPedSecondaryTask(PlayerPedId())
  end

end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

function randomStatic(loud)
  local vol = 0.05
  if loud then
    vol = 0.9
  end
  local pickS = math.random(4)
  if pickS == 4 then
    TriggerEvent("InteractSound_CL:PlayOnOne","radiostatic1",vol)
  elseif pickS == 3 then
    TriggerEvent("InteractSound_CL:PlayOnOne","radiostatic2",vol)
  elseif pickS == 2 then
    TriggerEvent("InteractSound_CL:PlayOnOne","radiostatic3",vol)
  else
    TriggerEvent("InteractSound_CL:PlayOnOne","radioclick",vol)
  end

end

RegisterNetEvent('radiotalk')
AddEventHandler('radiotalk', function(args,senderid,channel)

    local senderid = tonumber(senderid)

    table.remove(args,1)
    local radioMessage = ""
    for i = 1, #args do
        radioMessage = radioMessage .. " " .. args[i]
    end

    if channel == radioChannel and hasRadio() and radioMessage ~= nil then
      -- play radio click sound locally.
      TriggerEvent('chatMessage', "RADIO #" .. channel, 3, radioMessage, 5000)
      randomStatic(true)

      local radioMessage = ""
      for i = 1, #args do
        if math.random(50) > 25 then
          radioMessage = radioMessage .. " " .. args[i]
        else
          radioMessage = radioMessage .. " **BZZZ** "
        end
      end
      TriggerServerEvent("radiochatter:server",radioMessage)
    end
end)

RegisterNetEvent('radiochatter:client')
AddEventHandler('radiochatter:client', function(radioMessage,senderid)

    local senderid = tonumber(senderid) 
    local location = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(senderid)))
    local dst = #(GetEntityCoords(PlayerPedId()) - location)
    activeMessages = activeMessages + 0.1
    if dst < 5.0 then
      -- play radio static sound locally.
      local counter = 350
      local msgZ = location["z"]+activeMessages
      if PlayerPedId() ~= GetPlayerPed(GetPlayerFromServerId(senderid)) then
        randomStatic(false)
        while counter > 0 and dst < 5.0 do
          location = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(senderid)))
          dst = #(GetEntityCoords(PlayerPedId()) - location)
          DrawRadioChatter(location["x"],location["y"],msgZ, "Radio Chatter: " .. radioMessage, counter)
          counter = counter - 1
          Citizen.Wait(1)
        end
      end
    end
    activeMessages = activeMessages - 0.1 
end)


RegisterNetEvent('radiochannel')
AddEventHandler('radiochannel', function(chan)
  local chan = tonumber(chan)
  if hasRadio() and chan < 1000 and chan > -1 then
    radioChannel = chan
    TriggerEvent("InteractSound_CL:PlayOnOne","radioclick",0.4)
    -- TriggerEvent('chatMessage', "RADIO CHANNEL " .. radioChannel, 3, "Active", 5000)
  end
end)

function isRealEstateAgent()
  local myjob = exports["isPed"]:isPed("myjob")
  if myjob == "real_estate" then
    print("is a realtor")
    return true
  else
    return false
  end
end

RegisterNetEvent('canPing')
AddEventHandler('canPing', function(target)
  if hasPhone() and not isDead then
    local crds = GetEntityCoords(PlayerPedId())
    TriggerServerEvent("requestPing", target, crds["x"],crds["y"],crds["z"])
  else
    TriggerEvent("DoLongHudText","You need a phone to use GPS!",2)
  end
end)

local pingcount = 0
local currentblip = 0
local currentping = { ["x"] = 0.0,["y"] = 0.0,["z"] = 0.0, ["src"] = 0 }
RegisterNetEvent('allowedPing')
AddEventHandler('allowedPing', function(x,y,z,src,name)
  if pingcount > 0 then
    TriggerEvent("DoLongHudText","Somebody sent you a GPS flag but you already have one in process!",2)
    return
  end
  
  if hasPhone() and not isDead then
    pingcount = 5
    currentping = { ["x"] = x,["y"] = y,["z"] = z, ["src"] = src }
    while pingcount > 0 do
      TriggerEvent("DoLongHudText",name .. " has given you a ping location, type /pingaccept to accept",1)
      Citizen.Wait(5000)
      pingcount = pingcount - 1
    end
  else
    TriggerEvent("DoLongHudText","Somebody sent you a GPS flag but you have no phone!",2)
  end
  pingcount = 0
  currentping = { ["x"] = 0.0,["y"] = 0.0,["z"] = 0.0, ["src"] = 0 }
end)


RegisterNetEvent("phoneEnabled")
AddEventHandler("phoneEnabled", function(phoneopensent)
  phoneopen = phoneopensent
end)


--- PINGER
local pingCoords = vector3(0, 0, 0)
local lastPingerId = -1

RegisterNetEvent("warp-phone:ping:receive")
AddEventHandler("warp-phone:ping:receive", function(pCoords, pSrc)
  pingCoords = pCoords
  lastPingerId = pSrc
  PlaySound(-1, "Click_Fail", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
  local n = ShowDialogNotify('<span style="font-size:1vmin;padding-right:0.5vh;margin-left: -0.8vh" class="fa-stack fa-2x"> <i style="color: #ff8862;" class="fas fa-square fa-stack-2x"></i><i style="color: white;" class="fas fa-map-pin fa-stack-1x"></i></span>'..pSrc:upper() , 30000 )
    if(n == 'confirm') then
        if DoesBlipExist(blipMarker) then
            RemoveBlip(blipMarker)
        end
        blipMarker = AddBlipForCoord(pingCoords)
        SetBlipSprite(blipMarker, 280)
        SetBlipAsShortRange(blipMarker, false)
        BeginTextCommandSetBlipName("STRING")
        SetBlipColour(blipMarker, 4)
        SetBlipScale(blipMarker, 1.2)
        AddTextComponentString("Accepted GPS Marker")
        EndTextCommandSetBlipName(blipMarker)
        TriggerEvent("DoLongHudText", "Their GPS ping has been marked on the map")
        TriggerServerEvent("warp-phone:pingAccepted", lastPingerId)
        SetTimeout(60000, function()
        if DoesBlipExist(blipMarker) then
            RemoveBlip(blipMarker)
        end
          end)
    end
end)


RegisterNUICallback("pingSend", function(data, cb)
  local targetId, coords = data.number, GetEntityCoords(PlayerPedId())
  TriggerServerEvent("warp-phone:ping:request", targetId, coords)
end)



RegisterNUICallback("warp-phone:pingReject", function(data, cb)
  TriggerServerEvent("warp-ping:rejected", lastPingerId)
  lastPingerId = -1
  pingCoords = vector3(0, 0, 0)
end)

function isRealEstateAgent()
  if GroupRank("real_estate") > 0 then
    return true
  else
    return false
  end
end

function hasDecrypt2()
    if exports["warp-inventory"]:hasEnoughOfItem("vpnxj",1,false) and not exports["isPed"]:isPed("disabled") then
      return true
    else
      return false
    end
end

function hasTrucker()
    if exports["warp-base"]:getModule("LocalPlayer"):getVar("job") == "trucker"  then
      return true
    else
      return false
    end
end

function hasDecrypt()
    if exports["warp-inventory"]:hasEnoughOfItem("racingusb",1,false) then
      return true
    else
      return false
    end
end

function hasDevice()
    if exports["warp-inventory"]:hasEnoughOfItem("mk2usbdevice",1,false) and not exports["isPed"]:isPed("disabled") then
      return true
    else
      return false
    end
end

function hasPhone()
    if
      (
      (exports["warp-inventory"]:hasEnoughOfItem("mobilephone",1,false) or 
      exports["warp-inventory"]:hasEnoughOfItem("stoleniphone",1,false) or 
      exports["warp-inventory"]:hasEnoughOfItem("stolens8",1,false) or
      exports["warp-inventory"]:hasEnoughOfItem("stolennokia",1,false) or
      exports["warp-inventory"]:hasEnoughOfItem("stolenpixel3",1,false) or
      exports["warp-inventory"]:hasEnoughOfItem("assphone",1,false) or
      exports["warp-inventory"]:hasEnoughOfItem("boomerphone",1,false))
      and not exports["isPed"]:isPed("disabled") and not exports["isPed"]:isPed("handcuffed")
      ) 
    then
      return true
    else
      return false
    end
end

function hasRadio()
    if exports["warp-inventory"]:hasEnoughOfItem("radio",1,false) and not exports["isPed"]:isPed("disabled") then
      return true
    else
      return false
    end
end

function openGui()

  if recentopen then
    return
  end
  pPhoneOpen = true
  if hasPhone() then
    GiveWeaponToPed(PlayerPedId(), 0xA2719263, 0, 0, 1)
    guiEnabled = true
    SetNuiFocus(false,false)
    SetNuiFocus(true,true)

    local isREAgent = false
    if isRealEstateAgent() then
      isREAgent = true
    end

    local device = false
    if hasDevice() then
      device = true
    end

    local decrypt = false
    if hasDecrypt() then
      decrypt = true
    end

    local decrypt2 = false
    if hasDecrypt2() then
      decrypt2 = true
    end

    local trucker = false
    if hasTrucker() then
      trucker = true
    end 
    SendNUIMessage({openPhone = true, pOpenPhone = true, hasDevice = device, hasDecrypt = decrypt, hasDecrypt2 = decrypt2,hasTrucker = trucker, isRealEstateAgent = isREAgent, playerId = GetPlayerServerId(PlayerId()),wallpaper = wallPaper})
    TriggerEvent('phoneEnabled',true)
    TriggerEvent('animation:sms',true)

        --TaskStartScenarioInPlace(PlayerPedId(), "CODE_HUMAN_MEDIC_TIME_OF_DEATH", 0, 1)
        
    -- If this is the first time we've opened the phone, load all contacts
    
    lstContacts = {}
    TriggerServerEvent('phone:getContacts', exports['isPed']:isPed('cid'))
    doTimeUpdate()
  else
    closeGui()
    if not exports["isPed"]:isPed("disabled") then
      TriggerEvent("DoLongHudText","You do not have a phone.",2)
    else
      TriggerEvent("DoLongHudText","You cannot use your phone right now.",2)
    end
  end
  recentopen = false
end

RegisterNUICallback('btnPagerType', function(data, cb)
  TriggerServerEvent("secondaryjob:ServerReturnDate")
end)
local jobnames = {
  ["taxi"] = "Taxi Driver",
  ["towtruck"] = "Tow Truck Driver",
  ["trucker"] = "Delivery Driver",
}

RegisterNUICallback('newPostSubmit', function(data, cb)
    TriggerServerEvent('phone:updatePhoneJob', data.advert)
end)

RegisterNUICallback('btnDecrypt', function()
  TriggerEvent("secondaryjob:accepttask")
end)


function miTrabajo()
    return exports['isPed']:isPed('job')
end

RegisterNUICallback('deleteYP', function()
  TriggerServerEvent('phone:deleteYP')
end)

RegisterNetEvent("yellowPages:retrieveLawyersOnline")
AddEventHandler("yellowPages:retrieveLawyersOnline", function()
  local isFound = false
  TriggerEvent('chatMessage', "", 2, "Searching for a lawyer...")
  for i = 1, #YellowPageArray do
    local job = string.lower(YellowPageArray[tonumber(i)].job)
    if string.find(job, 'attorney') or string.find(job, 'lawyer') or string.find(job, 'public defender') then
      isFound = true
      TriggerEvent('chatMessage', "", 2, "⚖️ " .. YellowPageArray[i].name .. " ☎️ " .. YellowPageArray[i].phonenumber)
    end
  end
  if not isFound then
    TriggerEvent('chatMessage', "", 2, "There are no lawyers available right now. 😢")
  end
end)


RegisterNUICallback('notificationsYP', function()
  TriggerServerEvent('getYP')
  Citizen.Wait(200)
  TriggerEvent("YPUpdatePhone")
end)


RegisterNetEvent('YPUpdatePhone')
AddEventHandler('YPUpdatePhone', function()

  lstnotifications = {}

  for i = 1, #YellowPageArray do
      lstnotifications[#lstnotifications + 1] = {
        id = tonumber(i),
        name = YellowPageArray[tonumber(i)].name,
        message = YellowPageArray[tonumber(i)].job,
        phoneNumber = YellowPageArray[tonumber(i)].phonenumber
      }
  end
  SendNUIMessage({openSection = "notificationsYP", list = lstnotifications})
end)

-- Close Gui and disable NUI
function closeGui()
  TriggerEvent("closeInventoryGui")
  SetNuiFocus(false,false)
  SendNUIMessage({openPhone = false})
  guiEnabled = false
  TriggerEvent('animation:sms',false)
  TriggerEvent('phoneEnabled',false)
  TriggerEvent('warp-phone:UpdateStatePhone')
  pPhoneOpen = false
  recentopen = true
  Citizen.Wait(500)
  recentopen = false
  insideDelivers = false
end

RegisterNetEvent('warp-phone:UpdateStatePhone')
AddEventHandler('warp-phone:UpdateStatePhone', function()
    Wait(5)
    if callStatus == isCallInProgress then 
      SendNUIMessage({openSection = "phonemedio"}) 
    end
end)

function getCardinalDirectionFromHeading()
  local heading = GetEntityHeading(PlayerPedId())
  if heading >= 315 or heading < 45 then
      return "North Bound"
  elseif heading >= 45 and heading < 135 then
      return "West Bound"
  elseif heading >= 135 and heading < 225 then
      return "South Bound"
  elseif heading >= 225 and heading < 315 then
      return "East Bound"
  end
end

function closeGui2()
  SetNuiFocus(false,false)
  SendNUIMessage({openPhone = false})
  guiEnabled = false
  recentopen = true
  Citizen.Wait(500)
  recentopen = false  
end

local mousenumbers = {
  [1] = 1,
  [2] = 2,
  [3] = 3, 
  [4] = 4, 
  [5] = 5, 
  [6] = 6, 
  [7] = 12, 
  [8] = 13, 
  [9] = 66, 
  [10] = 67, 
  [11] = 95, 
  [12] = 96,   
  [13] = 97,   
  [14] = 98,
  [15] = 169,
   [16] = 170,
}



-- Opens our phone
RegisterNetEvent('phoneGui2')
AddEventHandler('phoneGui2', function()
  openGui()
end)

-- NUI Callback Methods
RegisterNUICallback('close', function(data, cb)
  closeGui()
  cb('ok')
  TriggerEvent('AttachWeapons')
end)

RegisterNetEvent('phone:close')
AddEventHandler('phone:close', function(number, message)
  closeGui()

end)



function testfunc()

end
RegisterNetEvent("TokoVoip:UpVolume");
AddEventHandler("TokoVoip:UpVolume", setVolumeUp);

RegisterNetEvent('refreshContacts')
AddEventHandler('refreshContacts', function()
  TriggerServerEvent('phone:getContacts', exports['isPed']:isPed('cid'))
  SendNUIMessage({openSection = "contacts"})
end)

RegisterNetEvent('refreshYP')
AddEventHandler('refreshYP', function()
  if guiEnabled then
    TriggerServerEvent('getYP')
    Citizen.Wait(250)
    TriggerEvent('YPUpdatePhone')
  end
end)



-- Contact Callbacks
RegisterNUICallback('contacts', function(data, cb)
  TriggerServerEvent('phone:getSMSc')
  SendNUIMessage({openSection = "contacts"})
  cb('ok')
end)

RegisterNUICallback('newContact', function(data, cb)
  SendNUIMessage({openSection = "newContact"})
  cb('ok')
end)

RegisterNUICallback('newContactSubmit', function(data, cb)
  TriggerEvent('phone:addContact', data.name, tonumber(data.number))
  cb('ok')
end)

RegisterNUICallback('updateMyWallpaper', function(data, cb)
  wallPaper = ""
  Wait(5)
  TriggerEvent('warp-phone:grabBackground', data.name .."?auto=compress&cs=tinysrgb&h=350")
  TriggerServerEvent("phone:saveWallpaper",exports['isPed']:isPed('cid'), data.name .."?auto=compress&cs=tinysrgb&h=350")
  cb('ok')
end)

RegisterNUICallback('removeContact', function(data, cb)
  TriggerServerEvent('phone:removeContact', data.name, data.number)
  cb('ok')
end)


myID = 0
mySourceID = 0

mySourceHoldStatus = false
TriggerEvent('phone:setCallState', isNotInCall)
costCount = 1

RegisterNetEvent('animation:phonecallstart')
AddEventHandler('animation:phonecallstart', function()
  TriggerEvent("destroyPropPhone")
  TriggerEvent("incall",true)
  local lPed = PlayerPedId()
  RequestAnimDict("cellphone@")
  while not HasAnimDictLoaded("cellphone@") do
    Citizen.Wait(0)
  end
  local count = 0
  costCount = 1
  inPhone = false
  Citizen.Wait(200)
  ClearPedTasks(lPed)
  
  TriggerEvent("attachItemPhone","phone01")

  while callStatus ~= isNotInCall do

    if isDead then
      endCall()
    end


    if IsEntityPlayingAnim(lPed, "cellphone@", "cellphone_call_listen_base", 3) and not IsPedRagdoll(PlayerPedId()) then
    else 



      if IsPedRagdoll(PlayerPedId()) then
        Citizen.Wait(1000)
      end
      TaskPlayAnim(lPed, "cellphone@", "cellphone_call_listen_base", 1.0, 1.0, -1, 49, 0, 0, 0, 0)
    end
    Citizen.Wait(1)
    count = count + 1

    if IsControlJustPressed(0, 38) then
      TriggerEvent("phone:holdToggle")
    end

    if onhold then
      if count == 800 then
         count = 0
         TriggerEvent("DoLongHudText","Call On Hold.", 1)
      end
    end

      --check if not unarmed
    local curw = GetSelectedPedWeapon(PlayerPedId())
    noweapon = `WEAPON_UNARMED`
    if noweapon ~= curw then
      SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
    end

  end
  ClearPedTasks(lPed)
  TaskPlayAnim(lPed, "cellphone@", "cellphone_call_out", 2.0, 2.0, 800, 49, 0, 0, 0, 0)
  Citizen.Wait(700)
  TriggerEvent("destroyPropPhone")
  TriggerEvent("incall",false)
end)

-- RegisterNetEvent('phone:makecall')
-- AddEventHandler('phone:makecall', function(pnumber)

--   local pnumber = tonumber(pnumber)
--   if callStatus == isNotInCall and not isDead and hasPhone() then
--     local dialingName = getContactName(pnumber)
--     TriggerEvent('phone:setCallState', isDialing, dialingName)
--     TriggerEvent("animation:phonecallstart")
--     print(pnumber)
--     print(dialingName)
--     recentcalls[#recentcalls + 1] = { 
--       ["type"] = 2, 
--       ["number"] = pnumber, 
--       ["name"] = dialingName
--     }
--     TriggerServerEvent('phone:callContact', exports['isPed']:isPed('cid'), pnumber, true)
--   else
--     TriggerEvent("It appears you are already in a call, injured or with out a phone, please type /hangup to reset your calls.", 2)
--   end
-- end)




local PayPhoneHex = {
  [1] = 1158960338,
  [2] = -78626473,
  [3] = 1281992692,
  [4] = -1058868155,
  [5] = -429560270,
  [6] = -2103798695,
  [7] = 295857659,
}

RegisterNetEvent("pass:coords:vehicle")
AddEventHandler("pass:coords:vehicle", function(coords)
  vehCoords = coords
  local VehicleCoords = coords
  local car = AddBlipForCoord(VehicleCoords[1],VehicleCoords[2],VehicleCoords[3])
  SetBlipSprite(car, 225)
  SetBlipScale(car, 1.2)
  SetBlipAsShortRange(car, false)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Carro Perdido")
  EndTextCommandSetBlipName(car)
  TriggerEvent("DoLongHudText", "Veiculo marcado no mapa!")
  trackVehicle = true
  Citizen.CreateThread(function()
    while trackVehicle do
      local dist = #(vector3(VehicleCoords[1],VehicleCoords[2],VehicleCoords[3]) - GetEntityCoords(PlayerPedId()))
      Wait(1000)
      if dist < 5.0 then
        RemoveBlip(car)
      end
    end
  end)
  if displaymarker then
    print("OK")
  else
    print("NOK")
  end
end)



function checkForPayPhone()
  for i = 1, #PayPhoneHex do
    local objFound = GetClosestObjectOfType( GetEntityCoords(PlayerPedId()), 5.0, PayPhoneHex[i], 0, 0, 0)
    if DoesEntityExist(objFound) then
      return true
    end
  end
  return false
end


--[[ The following happens for regular calls too ]]

RegisterNUICallback('callContact', function(data, cb)
  -- closeGui()
  if callStatus == isNotInCall and not isDead and hasPhone() then
    local dialingName = getContactName(data.number)
    SendNUIMessage({
      openSection = 'callnotify',
      pCNumber = dialingName
    })
    if exports['warp-phone']:pOpen() == false then 
        SendNUIMessage({openSection = "phonemedio"}) 
    end
    TriggerEvent('phone:setCallState', isDialing, data.name == "" and data.number or data.name)
    TriggerEvent("animation:phonecallstart")
    recentcalls[#recentcalls + 1] = { 
      ["type"] = 2, 
      ["number"] = data.number, 
      ["name"] = dialingName
    }
    TriggerServerEvent('phone:callContact', exports['isPed']:isPed('cid'), data.number, true)
  else
    TriggerEvent("DoLongHudText","It appears you are already in a call, injured or with out a phone, please type /hangup to reset your calls.",2)
  end
  cb('ok')
end)

debugn = false
function t(trace)
  print(trace)
end

RegisterNetEvent('phone:failedCall')
AddEventHandler('phone:failedCall', function()
    t("Failed Call")
    endCall()
end)


RegisterNetEvent('phone:hangup')
AddEventHandler('phone:hangup', function()
    endCall()
end)

local callid = 0

RegisterNetEvent('phone:endCalloncommand')
AddEventHandler('phone:endCalloncommand', function()
    TriggerServerEvent('phone:EndCall', mySourceID, callid, true)
    SendNUIMessage({
      openSection = 'callnotifyEnd'
    })
    SendNUIMessage({
      openSection = 'phonemedioclose'
    })
end)

RegisterNetEvent('phone:otherClientEndCall')
AddEventHandler('phone:otherClientEndCall', function()
    TriggerEvent("InteractSound_CL:PlayOnOne","demo",0.1)
    TriggerEvent("DoLongHudText", "Your call was ended!", 2)
    callid = 0
    myID = 0
    mySourceID = 0
    mySourceHoldStatus = false
    TriggerEvent('phone:setCallState', isNotInCall)
    onhold = false
    SendNUIMessage({
      openSection = 'callnotifyEnd'
    })
    SendNUIMessage({
      openSection = 'phonemedioclose'
    })
end)

RegisterNUICallback('btnAnswer', function()
    -- closeGui()
    TriggerEvent("phone:answercall")
end)

RegisterNUICallback('btnHangup', function()
    -- closeGui()
    TriggerEvent("phone:hangup")
    SendNUIMessage({
      openSection = 'callnotifyEnd'
    })
end)

RegisterNetEvent('phone:answercall')
AddEventHandler('phone:answercall', function()
    if callStatus == isReceivingCall and not isDead then
    answerCall()
    TriggerEvent("animation:phonecallstart")
    TriggerEvent("DoLongHudText","You have answered a call.", 1)
    callTimer = 0
  else
    TriggerEvent("DoLongHudText","You are not being called, injured, or you took too long.", 2)
  end
end)


RegisterNetEvent('phone:initiateCall')
AddEventHandler('phone:initiateCall', function(srcID)
    TriggerEvent("DoLongHudText","You have started a call.",1)
    initiatingCall()
end)


RegisterNetEvent('phone:addToCall')
AddEventHandler('phone:addToCall', function(voipchannel)
  exports['warp-voice']:addPlayerToCall(tonumber(voipchannel))
  if exports['warp-phone']:pOpen() == false then 
    SendNUIMessage({openSection = "phonemedio"}) 
  end
end)

RegisterNetEvent('phone:callFullyInitiated')
AddEventHandler('phone:callFullyInitiated', function(srcID,sentSource)
 TriggerEvent("InteractSound_CL:PlayOnOne","demo",0.1)
  myID = srcID
  mySourceID = sentSource
  TriggerEvent('phone:setCallState', isCallInProgress)
  callTimer = 0
  TriggerEvent("phone:callactive")
  
end)


function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end
RegisterNetEvent('phone:callactive')
AddEventHandler('phone:callactive', function()
    Citizen.Wait(100)
    local held1 = false
    local held2 = false
    while callStatus == isCallInProgress do
      local phoneString = ""
      Citizen.Wait(1)

      if onhold then
        phoneString = phoneString .. "They are on Hold | "
        if not held1 then
          TriggerEvent("DoLongHudText","You have put the caller on hold.",888)
          held1 = true
        end
      else
        phoneString = phoneString .. "Call Active | "
        if held1 then
          TriggerEvent("DoLongHudText","Your call is no longer on hold.",888)
          held1 = false
        end
      end

      if mySourceHoldStatus then
        phoneString = phoneString .. "You are on hold"
        if not held2 then
          TriggerEvent("DoLongHudText","You are on hold.",2)
          held2 = true
        end
      else
        phoneString = phoneString .. "Caller Active"
        if held2 then
          TriggerEvent("DoLongHudText","You are no longer on hold.",2)
          held2 = false
        end
      end
      drawTxt(0.97, 1.46, 1.0,1.0,0.33, phoneString, 255, 255, 255, 255)  -- INT: kmh
    end
end)



RegisterNetEvent('phone:id')
AddEventHandler('phone:id', function(sentcallid)
  callid = sentcallid
end)

RegisterNetEvent('phone:setCallState')
AddEventHandler('phone:setCallState', function(pCallState, pCallInfo)
  callStatus = pCallState
  SendNUIMessage({
    openSection = 'callState',
    callState = pCallState,
    callInfo = pCallInfo
  })
end)

RegisterNetEvent('phone:receiveCall')
AddEventHandler('phone:receiveCall', function(phoneNumber, srcID, calledNumber)
  local callFrom = getContactName(calledNumber)

  SendNUIMessage({
    openSection = 'callnotify',
    pCNumber = callFrom
  })

  if exports['warp-phone']:pOpen() == false then 
    SendNUIMessage({openSection = "phonemedio"}) 
  end
  
  recentcalls[#recentcalls + 1] = { ["type"] = 1, ["number"] = calledNumber, ["name"] = callFrom }

  if callStatus == isNotInCall then
    myID = 0
    mySourceID = srcID
    TriggerEvent('phone:setCallState', isReceivingCall, callFrom)

    receivingCall(callFrom) -- Send contact name if exists, if not send number
  else
    TriggerEvent("DoLongHudText","You are receiving a call from " .. callFrom .. " but are currently already in one, sending busy response.",2)
  end
end)
callTimer = 0
function initiatingCall()
  callTimer = 8
  TriggerEvent("DoLongHudText","You are making a call, please hold.", 1)
  while (callTimer > 0 and callStatus == isDialing) do
    TriggerEvent("InteractSound_CL:PlayOnOne","cellcall",0.5)
    Citizen.Wait(2500)
    callTimer = callTimer - 1
  end
  if callStatus == isDialing or callTimer == 0 then
    endCall()
  end
end

function receivingCall(callFrom)
  callTimer = 8
  while (callTimer > 0 and callStatus == isReceivingCall) do
    if hasPhone() then
      Citizen.Wait(1)
      TriggerEvent("DoLongHudText","Call from: " .. callFrom .. " /answer | /hangup", 1)
      if phoneNotifications then
        TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'cellcall', 0.5)
      end
    end
    Citizen.Wait(2500)
    callTimer = callTimer - 1
  end
  if callStatus ~= isCallInProgress then
    endCall()
  end
end

RegisterNetEvent('warp-phone:RemoveCall')
AddEventHandler('warp-phone:RemoveCall', function()
    SendNUIMessage({
      openSection = 'callnotifyEnd'
    })
    SendNUIMessage({
      openSection = 'phonemedioclose'
    })
end)

function answerCall()

  if mySourceID ~= 0 then

    --NetworkSetVoiceChannel(mySourceID+1)
    --NetworkSetTalkerProximity(0.0)

    TriggerServerEvent("phone:StartCallConfirmed",mySourceID)
    TriggerEvent('phone:setCallState', isCallInProgress)
    TriggerEvent("phone:callactive")
  end
end

RegisterNetEvent('phone:removefromToko')
AddEventHandler('phone:removefromToko', function(playerRadioChannel)
  exports['warp-voice']:removePlayerFromCall()
end)

function endCall()
  TriggerEvent("InteractSound_CL:PlayOnOne","demo",0.1)
  if tonumber(mySourceID) ~= 0 then
    TriggerServerEvent("phone:EndCall",mySourceID,callid)
  end

  if tonumber(myID) ~= 0 then
    TriggerServerEvent("phone:EndCall",myID,callid)
  end 

  myID = 0
  mySourceID = 0
  TriggerEvent('phone:setCallState', isNotInCall)
  TriggerEvent('warp-phone:RemoveCall')
  onhold = false
  mySourceHoldStatus = false
  callid = 0
end

function endCall2()
  TriggerEvent("InteractSound_CL:PlayOnOne","payphoneend",0.1)
  if tonumber(mySourceID) ~= 0 then
    TriggerServerEvent("phone:EndCall",mySourceID,callid)
  end

  if tonumber(myID) ~= 0 then
    TriggerServerEvent("phone:EndCall",myID,callid)
  end 

  myID = 0
  mySourceID = 0
  TriggerEvent('phone:setCallState', isNotInCall)
  onhold = false
  mySourceHoldStatus = false
  callid = 0
  --closeGui()
  --[[ 
  NetworkSetTalkerProximity(1.0)
  Citizen.Wait(300)
  NetworkClearVoiceChannel()
  Citizen.Wait(300)
  NetworkSetTalkerProximity(18.0)
  ]]
end


RegisterNetEvent('phone:holdToggle')
AddEventHandler('phone:holdToggle', function()
  if myID == nil then
    myID = 0
  end
  if myID ~= 0 then
    if not onhold then
      TriggerEvent("DoShortHudText", "Call on hold.",10)
      onhold = true

      --[[  
      NetworkSetTalkerProximity(1.0)
      Citizen.Wait(300)
      NetworkClearVoiceChannel()
      Citizen.Wait(300)
      NetworkSetTalkerProximity(18.0)
      ]]

      TriggerServerEvent("OnHold:Server",mySourceID,true)
    else
      TriggerEvent("DoShortHudText", "No longer on hold.",10)
      TriggerServerEvent("OnHold:Server",mySourceID,false)
      onhold = false

      --NetworkSetVoiceChannel(myID+1)
      --NetworkSetTalkerProximity(0.0)
    end
  else

    if mySourceID ~= 0 then
      if not onhold then
        TriggerEvent("DoShortHudText", "Call on hold.",10)
        onhold = true

        --[[ 
        NetworkSetTalkerProximity(1.0)
        Citizen.Wait(300)
        NetworkClearVoiceChannel()
        Citizen.Wait(300)
        NetworkSetTalkerProximity(18.0)
        ]]

        TriggerServerEvent("OnHold:Server",mySourceID,true)
      else
        TriggerEvent("DoShortHudText", "No longer on hold.",10)
        TriggerServerEvent("OnHold:Server",mySourceID,false)
        onhold = false

        --NetworkSetVoiceChannel(mySourceID+1)
        --NetworkSetTalkerProximity(0.0)
      end
    end
  end
end)



RegisterNetEvent('OnHold:Client')
AddEventHandler('OnHold:Client', function(newHoldStatus,srcSent)
    mySourceHoldStatus = newHoldStatus
    if mySourceHoldStatus then
        local playerId = GetPlayerFromServerId(srcSent)
        MumbleSetVolumeOverride(playerId, -1.0)
        TriggerEvent("DoLongHudText","You just got put on hold.", 1)
    else
        if not onhold then
          local playerId = GetPlayerFromServerId(srcSent)
          MumbleSetVolumeOverride(playerId, 1.0)
        end
        TriggerEvent("DoLongHudText","Your caller is back on the line.", 1)
    end
end)
----------


curNotifications = {}

RegisterNetEvent('phone:addnotification')
AddEventHandler('phone:addnotification', function(name, message)
    SendNUIMessage({openSection = "emailnotify", pEHandle = 'Email Received.', pEMessages = message})
    if exports['warp-phone']:pOpen() == false then 
      SendNUIMessage({openSection = "emailnotify", pEHandle = 'Email Received.', pEMessages = message})
      SendNUIMessage({openSection = "phonemedio", timeout = "5200", pOpen = exports['warp-phone']:pOpen()}) 
    end
    curNotifications[#curNotifications+1] = { ["name"] = name, ["message"] = message, ['time'] = time }
end)

RegisterNetEvent('phone:addJobNotify')
AddEventHandler('phone:addJobNotify', function(message)
    SendNUIMessage({openSection = "jobNotify", pEHandle = 'CURRENT', pEMessages = message})
    if exports['warp-phone']:pOpen() == false then 
      SendNUIMessage({openSection = "jobNotify", pEHandle = 'CURRENT', pEMessages = message})
      SendNUIMessage({openSection = "phonemedio", timeout = "5200", pOpen = exports['warp-phone']:pOpen()}) 
    end
end)

RegisterNetEvent('phone:addJobOfferCompleteNoti')
AddEventHandler('phone:addJobOfferCompleteNoti', function(message)
    SendNUIMessage({openSection = "jobNotify", pEHandle = 'JOB OFFER', pEMessages = message})
    if exports['warp-phone']:pOpen() == false then 
      SendNUIMessage({openSection = "jobNotify", pEHandle = 'CURRENT', pEMessages = message})
      SendNUIMessage({openSection = "phonemedio", timeout = "5200", pOpen = exports['warp-phone']:pOpen()}) 
    end
end)

RegisterNetEvent('warp-phone:job_done_noti')
AddEventHandler('warp-phone:job_done_noti', function()
  TriggerEvent('phone:addJobOfferCompleteNoti', 'The offer was completed successfully.')
end)

RegisterNetEvent('YellowPageArray')
AddEventHandler('YellowPageArray', function(pass)
    local notdecoded = json.encode(pass)
    YellowPages = notdecoded

    YellowPageArray = pass
end)


function createGeneralAreaBlip(alertX, alertY, alertZ)
  local genX = alertX + math.random(-50, 50)
  local genY = alertY + math.random(-50, 50)
  local alertBlip = AddBlipForRadius(genX,genY,alertZ,75.0) 
  SetBlipColour(alertBlip,1)
  SetBlipAlpha(alertBlip,80)
  SetBlipSprite(alertBlip,9)
  Wait(60000)
  RemoveBlip(alertBlip)
end

local lastTime = 0;
RegisterNetEvent('phone:triggerPager')
AddEventHandler('phone:triggerPager', function()
  local job = exports["isPed"]:isPed("myjob")
  if job == "doctor" or job == "ems" then
    local currentTime = GetGameTimer()
    if lastTime == 0 or lastTime + (5 * 60 * 1000) < currentTime then
      TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'pager', 0.4)
      SendNUIMessage({
        openSection = "newpager"
      })
      lastTime = currentTime
    end
  end
end)


local customGPSlocations = {
  [1] = { ["x"] = 484.77066040039, ["y"] = -77.643089294434, ["z"] = 77.600166320801, ["info"] = "Garage A"},
  [2] = { ["x"] = -331.96115112305, ["y"] = -781.52337646484, ["z"] = 33.964477539063,  ["info"] = "Garage B"},
  [3] = { ["x"] = -451.37295532227, ["y"] = -794.06591796875, ["z"] = 30.543809890747, ["info"] = "Garage C"},
  [4] = { ["x"] = 399.51190185547, ["y"] = -1346.2742919922, ["z"] = 31.121940612793, ["info"] = "Garage D"},
  [5] = { ["x"] = 598.77319335938, ["y"] = 90.707237243652, ["z"] = 92.829048156738, ["info"] = "Garage E"},
  [6] = { ["x"] = 641.53442382813, ["y"] = 205.42562866211, ["z"] = 97.186958312988, ["info"] = "Garage F"},
  [7] = { ["x"] = 82.359413146973, ["y"] = 6418.9575195313, ["z"] = 31.479639053345, ["info"] = "Garage G"},
  [8] = { ["x"] = -794.578125, ["y"] = -2020.8499755859, ["z"] = 8.9431390762329, ["info"] = "Garage H"},
  [9] = { ["x"] = -669.15631103516, ["y"] = -2001.7552490234, ["z"] = 7.5395741462708, ["info"] = "Garage I"},
  [10] = { ["x"] = -606.86322021484, ["y"] = -2236.7624511719, ["z"] = 6.0779848098755, ["info"] = "Garage J"},
  [11] = { ["x"] = -166.60482788086, ["y"] = -2143.9333496094, ["z"] = 16.839847564697, ["info"] = "Garage K"},
  [12] = { ["x"] = -38.922565460205, ["y"] = -2097.2663574219, ["z"] = 16.704851150513, ["info"] = "Garage L"},
  [13] = { ["x"] = -70.179389953613, ["y"] = -2004.4139404297, ["z"] = 18.016941070557, ["info"] = "Garage M"},
  [14] = { ["x"] = -195.1579, ["y"] = -1172.7583, ["z"] = 23.0440, ["info"] = "Garage Impound Lot"},
  [15] = { ["x"] = 364.27685546875, ["y"] = 297.84490966797, ["z"] = 103.49515533447, ["info"] = "Garage O"},
  [16] = { ["x"] = -338.31619262695, ["y"] = 266.79782104492, ["z"] = 85.741966247559, ["info"] = "Garage P"},
  [17] = { ["x"] = 273.66683959961, ["y"] = -343.83737182617, ["z"] = 44.919876098633, ["info"] = "Garage Q"},
  [18] = { ["x"] = 66.215492248535, ["y"] = 13.700443267822, ["z"] = 69.047248840332, ["info"] = "Garage R"},
  [19] = { ["x"] = 3.3330917358398, ["y"] = -1680.7877197266, ["z"] = 29.170293807983, ["info"] = "Garage Imports"},
  [20] = { ["x"] = 286.67013549805, ["y"] = 79.613700866699, ["z"] = 94.362899780273, ["info"] = "Garage S"},
  [21] = { ["x"] = 211.79, ["y"] = -808.38, ["z"] = 30.833, ["info"] = "Garage T"},
  [22] = { ["x"] = 447.65, ["y"] = -1021.23, ["z"] = 28.45, ["info"] = "Garage Police Department"},
  [23] = { ["x"] = -25.59, ["y"] = -720.86, ["z"] = 32.22, ["info"] = "Garage House"},
}

local loadedGPS = false

RegisterNetEvent('openGPS')

AddEventHandler('openGPS', function(mansions,houses,rented)

  

  SendNUIMessage({openSection = "GPS"})

  if loadedGPS then

    return

  end

  for i = 1, #customGPSlocations do

    SendNUIMessage({openSection = "AddGPSLocation", info = customGPSlocations[i]["info"], house_id = i, house_type = 69})

    Citizen.Wait(1)

  end



  loadedGPS = true

end)



RegisterNetEvent('GPSLocations')

AddEventHandler('GPSLocations', function()

	if GPSblip ~= nil then

		RemoveBlip(GPSblip)

		GPSblip = nil

	end	

	TriggerEvent("GPSActivated",false)

	TriggerEvent("openGPS",robberycoordsMansions,robberycoords,rentedOffices)

end)



RegisterNUICallback('loadUserGPS', function(data)

     TriggerEvent("GPS:SetRoute",data.house_id,data.house_type)

end)



RegisterNUICallback('btnCamera', function()

  SetNuiFocus(true,true)

end)



local loadedGPS = false

RegisterNetEvent('openGPS')

AddEventHandler('openGPS', function(mansions,house,rented)

  -- THIS IS FUCKING PEPEGA TOO.....





  if loadedGPS then

    SendNUIMessage({openSection = "GPS"})

    return

  end

  local mapLocationsObject = {

    custom = { info = customGPSlocations, houseType = 69 },

    mansions = { info = mansions, houseType = 2 },

    houses = { info = house, houseType = 1 },

    rented = { info = rented, houseType = 3 }

  }

  SendNUIMessage({openSection = "GPS", locations = mapLocationsObject })

  loadedGPS = true

end)



RegisterNUICallback('loadGPS', function()

  TriggerEvent("GPSLocations")

end)




RegisterNUICallback('btnCamera', function()
  SetNuiFocus(false,false)
  SetNuiFocus(true,true)
end)

RegisterNUICallback('notifications', function()

    lstnotifications = {}

    for i = 1, #curNotifications do

        local message2 = {
          id = tonumber(i),
          name = curNotifications[tonumber(i)].name,
          message = curNotifications[tonumber(i)].message
        }

        lstnotifications[#lstnotifications+1]= message2
    end

    
  SendNUIMessage({openSection = "notifications", list = lstnotifications})

end)



RegisterNUICallback('btnPagerToggle', function()
  TriggerEvent("togglePager")
end)

RegisterNetEvent("house:returnKeys")
AddEventHandler("house:returnKeys", function(pSharedKeys)
  SendNUIMessage({
    openSection = "manageKeys",
    sharedKeys = pSharedKeys
  })
end)


RegisterNetEvent('phone:deleteSMS')
AddEventHandler('phone:deleteSMS', function(id)
  table.remove( lstMsgs, tablefindKeyVal(lstMsgs, 'id', tonumber(id)))
  phoneMsg("Message Removed!")
end)

function getContactName(number)
  if (#lstContacts ~= 0) then
    for k,v in pairs(lstContacts) do
      if v ~= nil then
        if (v.number ~= nil and tonumber(v.number) == tonumber(number)) then
          return v.name
        end
      end
    end
  end

  return number
end

-- Contact Events
RegisterNetEvent('phone:loadContacts')
AddEventHandler('phone:loadContacts', function(contacts)

  lstContacts = {}

  if (#contacts ~= 0) then
    for k,v in pairs(contacts) do
      if v ~= nil then
        local contact = {
        }
        if activeNumbersClient['active' .. tonumber(v.number)] then
        
          contact = {
            name = v.name,
            number = v.number,
            activated = 1
          }
        else
    
          contact = {
            name = v.name,
            number = v.number,
            activated = 0
          }
        end
        lstContacts[#lstContacts+1]= contact

        SendNUIMessage({
          newContact = true,
          contact = contact,
        })
      end
    end
  else
       SendNUIMessage({
        emptyContacts = true
      })
  end
end)

RegisterNetEvent('phone:addContact')
AddEventHandler('phone:addContact', function(name, number)
  if(name ~= nil and number ~= nil) then
    number = tonumber(number)
    TriggerServerEvent('phone:addContact', name, number)
  else
     phoneMsg("You must fill in a name and number!")
  end
end)

RegisterNetEvent('phone:newContact')
AddEventHandler('phone:newContact', function(name, number)
  local contact = {
      name = name,
      number = number
  }
  lstContacts[#lstContacts+1]= contact

  SendNUIMessage({
    newContact = true,
    contact = contact,
  })
  phoneMsg("Contact Saved!")
  TriggerServerEvent('phone:getContacts', exports['isPed']:isPed('cid'))
end)

RegisterNetEvent('phone:deleteContact')
AddEventHandler('phone:deleteContact', function(name, number)

  local contact = {
      name = name,
      number = number
  }

  table.remove( lstContacts, tablefind(lstContacts, contact))
  
  SendNUIMessage({
    removeContact = true,
    contact = contact,
  })
  
end)

RegisterNUICallback('removeContact', function(data, cb)
  TriggerServerEvent('deleteContact', data.name, data.number)
  cb('ok')
end)

function tablefind(tab,el)
  for index, value in pairs(tab) do
    if value == el then
      return index
    end
  end
end

function tablefindKeyVal(tab,key,val)
  for index, value in pairs(tab) do
    if value ~= nil  and value[key] ~= nil and value[key] == val then
      return index
    end
  end
end


RegisterNetEvent('resetPhone')
AddEventHandler('resetPhone', function()
     SendNUIMessage({
      emptyContacts = true
    })

end)

local weather = ""
RegisterNetEvent("kWeatherSync")
AddEventHandler("kWeatherSync", function(pWeather)
  weather = pWeather
end)

RegisterNUICallback('getWeather', function(data, cb)
  SendNUIMessage({openSection = "weather", weather = weather})
  cb("ok")
end)

function MyPlayerId()
  for i=0,256 do
    if(NetworkIsPlayerActive(i) and GetPlayerPed(i) == PlayerPedId()) then return i end
  end
  return nil
end



function Voip(intPlayer, boolSend)
end

warp = warp or {}
warp.DataControls = warp.DataControls or {}

function warp.DataControls.getBindTable()

	local i = 1
	local controlTable = {}
	for k,v in pairs(warp.Controls.Current) do
		controlTable[i] = {k,v}
		i = i+1
	end

    return controlTable
end
warp.SettingsData = warp.SettingsData or {}
warp.Settings = warp.Settings or {}

warp.Settings.Current = {}
-- Current bind name and keys
warp.Settings.Default = {
  ["tokovoip"] = {
    ["stereoAudio"] = true,
    ["localClickOn"] = true,
    ["localClickOff"] = true,
    ["remoteClickOn"] = true,
    ["remoteClickOff"] = true,
    ["mainVolume"] = 6.0,
    ["clickVolume"] = 10.0,
    ["radioVolume"] = 5.0,
  },
  ["hud"] = {

  }

}
warp.Controls = warp.Controls or {}
warp.Controls.Current = {}
-- Current bind name and keys
warp.Controls.Default = {
  ["tokoptt"] = "caps",
  ["loudSpeaker"] = "-",
  ["distanceChange"] = "g",
  ["tokoToggle"] = "leftctrl",
  ["handheld"] = "leftshift+p",
  ["carStereo"] = "leftalt+p",
  ["switchRadioEmergency"] = "9",
  ["actionBar"] = "tab",
  ["generalUse"] = "e",
  ["generalPhone"] = "p",
  ["generalInventory"] = "k",
  ["generalChat"] = "t",
  ["generalEscapeMenu"] = "esc",
  ["generalUseSecondary"] = "enter",
  ["generalUseSecondaryWorld"] = "f",
  ["generalUseThird"] = "g",
  ["generalTackle"] = "leftalt",
  ["generalMenu"] = "f1",
  ["generalProp"] = "7",
  ["generalScoreboard"] = "u",
  ["movementCrouch"] = "x",
  ["movementCrawl"] = "z",
  ["vehicleCruise"] = "x",
  ["vehicleSearch"] = "g",
  ["vehicleHotwire"] = "h",
  ["vehicleBelt"] = "b",
  ["vehicleDoors"] = "l",
  ["vehicleSlights"] = "q",
  ["vehicleSsound"] = "leftalt",
  ["vehicleSnavigate"] = "r",
  ["newsTools"] = "h",
  ["newsNormal"] = "e",
  ["newsMovie"] = "m",
  ["housingMain"] = "h",
  ["housingSecondary"] = "g",
  ["heliCam"] = "e",
  ["helivision"] = "inputaim",
  ["helirappel"] = "x",
  ["helispotlight"] = "g",
  ["helilockon"] = "space",
}

function warp.SettingsData.getSettingsTable()
  return warp.Settings.Current
end

RegisterNUICallback('settings', function()
  local controls = exports["warp-base"]:getModule("DataControls"):getBindTable()
  local settings = exports["warp-base"]:getModule("SettingsData"):getSettingsTable()
  SendNUIMessage({openSection = "settings", currentControls = controls, currentSettings = settings})
end)

RegisterNUICallback('settingsResetControls', function()
  TriggerEvent("warp-base:cl:player_control", nil)
end)
RegisterNetEvent('sendMessagePhoneN')
AddEventHandler('sendMessagePhoneN', function(phonenumberlol)
  TriggerServerEvent('message:tome', phonenumberlol)

  local closestPlayer, closestDistance = GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 5.0 then
    TriggerServerEvent('message:inDistanceZone', GetPlayerServerId(closestPlayer), phonenumberlol)
  else    
  end
end)
function GetClosestPlayer()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local closestPed = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)
	if not IsPedInAnyVehicle(PlayerPedId(), false) then

		for index,value in ipairs(players) do
			local target = GetPlayerPed(value)
			if(target ~= ply) then
				local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
				local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
				if(closestDistance == -1 or closestDistance > distance) then
					closestPlayer = value
					closestPed = target
					closestDistance = distance
				end
			end
		end
		return closestPlayer, closestDistance, closestPed
	end
end

local selfieMode = false
RegisterNetEvent('phone:selfie2')
AddEventHandler('phone:selfie2', function(cod)
  if cod then
    closeGui()
    DestroyMobilePhone()
    CreateMobilePhone(4)
    CellCamActivate(true, true)
    CellFrontCamActivate(true)
  else
    closeGui()
    CellCamActivate(false, false)
    CellFrontCamActivate(false)
    DestroyMobilePhone()
    cod = false
  end
end)

-- Job Center App NUI Callbacks

RegisterNUICallback('SetPostOpNewWaypoint', function()
  TriggerEvent('DoLongHudText', 'A new waypoint has been set to Post OP down by the docks')
  SetNewWaypoint(-410.42636108398,-2794.7868652344)
end)

RegisterNUICallback('SetMiningNewWaypoint', function()
  TriggerEvent('DoLongHudText', 'A new waypoint has been set to Mining Up in the hills')
  SetNewWaypoint(-596.71649169922,2092.03515625)
end)

RegisterNUICallback('SetWaterNPowerNewWaypoint', function()
  TriggerEvent('DoLongHudText', 'A new waypoint has been set to Water N Power down in Southside', 1)
  SetNewWaypoint(448.54943847656,-1970.4132080078)
end)

RegisterNUICallback('SetGarbageNewWaypoint', function()
  TriggerEvent('DoLongHudText', 'A new waypoint has been set to Garbage down in Southside', 1)
  SetNewWaypoint(-351.79779052734,-1544.2813720703)
end)

RegisterNUICallback('SetChickenNewWaypoint', function()
  TriggerEvent('DoLongHudText', 'A new waypoint has been set to Chicken Job up north near Paleto Bay', 1)
  SetNewWaypoint(2384.6110839844,5045.68359375)
end)

RegisterNUICallback('SetFishingNewWaypoint', function()
  TriggerEvent('DoLongHudText', 'A new waypoint has been set to Fishing Job up north in Sandy Shores', 1)
  SetNewWaypoint(1530.33, 3778.43, 34.51)
end)

RegisterNUICallback('SetHuntingNewWaypoint', function()
  TriggerEvent('DoLongHudText', 'A new waypoint has been set to Hunting Shop up north in Paleto Bay', 1)
  SetNewWaypoint(-681.19122314453,5831.89453125)
end)

RegisterNUICallback('SetFarmerJobWaypoint', function()
  TriggerEvent('DoLongHudText', 'A new waypoint has been set to Farming Job up north in Grapeseed', 1)
  SetNewWaypoint(2563.8857421875, 4680.7119140625, 34.065185546875)
end)

RegisterNUICallback('SetFarmerJobWaypointProcess', function()
  TriggerEvent('DoLongHudText', 'A new waypoint has been set to Farming Job Processing Location up north in Grapeseed', 1)
  SetNewWaypoint(2531.1032714844, 4114.298828125, 38.732543945312)
end)

RegisterNUICallback('SetFarmerJobWaypointSale', function()
  TriggerEvent('DoLongHudText', 'A new waypoint has been set to Farmers Market by the Diamond Casino', 1)
  SetNewWaypoint(1169.0769042969,-291.42855834961,69.01171875)
end)

-- Sales

RegisterNUICallback('SetMiningSalesLocation', function()
  TriggerEvent('DoLongHudText', 'A new waypoint has been set to Mining Sales by Great Ocean Highway', 1)
  SetNewWaypoint(-1464.4219970703,-181.85934448242,48.808837890625)
end)

RegisterNUICallback('SetChickenSalesLocation', function()
  TriggerEvent('DoLongHudText', 'A new waypoint has been set to Chicken Sales in Little Seoul', 1)
  SetNewWaypoint(-591.54724121094,-892.66815185547,25.943603515625)
end)

RegisterNUICallback('SetFishingSalesLocation', function()
  TriggerEvent('DoLongHudText', 'A new waypoint has been set to Fishing Sales by Red Circle', 1)
  SetNewWaypoint(-371.72308349609,277.04174804688,84.800048828125)
end)

RegisterNUICallback('SetHuntingSalesLocation', function()
  TriggerEvent('DoLongHudText', 'A new waypoint has been set to Hunting Sales by southside', 1)
  SetNewWaypoint(12.237363815308,-1299.9296875,29.229248046875)
end)