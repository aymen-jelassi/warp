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
local AnonCall = false
local phoneNotifications = true
local insideDelivers = false
local curhrs = 9
local curmins = 2
local allowpopups = true
local vehicles = {}
local isDead = false
local isNotInCall, isDialing, isReceivingCall, isCallInProgress = 0, 1, 2, 3
local callStatus = isNotInCall
local hiddenapp = false
local heistzone = nil

RegisterNUICallback('btnNotifyToggle', function(data, cb)
    allowpopups = not allowpopups
    if allowpopups then
      TriggerEvent("DoLongHudText","Popups Enabled", 1)
    else
      TriggerEvent("DoLongHudText","Popups Disabled", 2)
    end
end)

activeNumbersClient = {}

RegisterNetEvent('phone:reset')
AddEventHandler('phone:reset', function(cidsent)
    if guiEnabled then
      closeGui2()
    end
    guiEnabled = false
    hasOpened = false
    lstMsgs = {}
    lstContacts = {}
    vehicles = {}
    radioChannel = math.random(1,999)
    dead = false
    onhold = false
    inPhone = false
end)

RegisterNetEvent('Yougotpaid')
AddEventHandler('Yougotpaid', function(cidsent)
  local cid = exports["isPed"]:isPed("cid")
  if tonumber(cid) == tonumber(cidsent) then
    TriggerEvent("DoLongHudText","Life Invader Payslip Genewarp.", 1)
  end
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
AddEventHandler("timeheader", function()
  doTimeUpdate()
end)

function doTimeUpdate()
  hour = GetClockHours()
  minute = GetClockMinutes()

  if minute <= 9 then
		minute = "0" .. minute
  end

  local timesent = hour .. ":" .. minute
  if guiEnabled then
    SendNUIMessage({
      openSection = "timeheader",
      timestamp = timesent,
    })   
  end
end


Citizen.CreateThread(function()
  while true do
    if guiEnabled then
      doTimeUpdate()
    end
      Citizen.Wait(1000)
  end
end)

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
    local cid = data.cid
    local newrank = data.newrank
    SendNUIMessage({
        openSection = "error",
        textmessage = "Loading, please wait.",
    })
    TriggerServerEvent("server:givepass", gangid,newrank,cid)
end)

RegisterNUICallback('manageGroup', function(data)
  local groupid = data.GroupID
  local rank = GroupRank(groupid)
  local businessName = GroupName(groupid)
  if rank >= 2 then
    TriggerServerEvent("group:pullinformation",groupid,rank)
  else
    TriggerEvent("DoLongHudText", "You cant access this!")
  end
end)

RegisterNetEvent("phone:error")
AddEventHandler("phone:error", function()
  TriggerEvent("DoLongHudText", "Error")
end)


RegisterNUICallback('btnProperty', function(data, cb)
  loading()
  local realEstateRank = GroupRank("realtor")
  if realEstateRank > 0 then
    SendNUIMessage({
        openSection = "RealEstate",
        RERank = realEstateRank
    })        
  end
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
  TriggerEvent("DoLongHudText", "Coming soon.", 2)
  --TriggerEvent("openFurniture")
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
TriggerEvent("housing:sendPurchaseAttempt",data.cid,data.price)
end)
RegisterNUICallback('btnTransferHouse', function(data, cb)
TriggerEvent("housing:transferHouseAttempt", data.cid)
end)
RegisterNUICallback('btnEvictHouse', function(data, cb)
TriggerEvent("housing:evictHouseAttempt")
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

RegisterNetEvent("warp-npcs:ped:signIn")
AddEventHandler("warp-npcs:ped:signIn", function(job)
  local jobname = job[1]
  local cid = exports["isPed"]:isPed("cid")
  local result = RPC.execute("phone:signIn", cid, jobname)
  if result then
    TriggerEvent("DoLongHudText", "Signed In.", 1)
  end
end)

RegisterCommand("updatephone", function()
  TriggerServerEvent("updatephoneserver")
end)

RegisterCommand("updategroup", function()
  TriggerServerEvent("updategroupserver", 12)
end)

RegisterNetEvent("warp-phone:updateGroups")
AddEventHandler("warp-phone:updateGroups", function(job)
  local cid = exports["isPed"]:isPed("cid")
  local curjob = RPC.execute("phone:getCurJob", cid)
  local signedIn = RPC.execute("phone:isSignedIn", cid)
  local inGroup = RPC.execute("phone:isInGroup", cid)
  if tostring(curjob) ~= tostring(job) then return end
  if signedIn ~= 1 or signedIn ~= nil then return end --0
  if inGroup ~= 0 or inGroup ~= nil then return end
  
  TriggerEvent("GroupsUpdatePhone")
end)

RegisterNetEvent("warp-phone:updateGroupMembers")
AddEventHandler("warp-phone:updateGroupMembers", function(job)
  local cid = exports["isPed"]:isPed("cid")
  local curjob = RPC.execute("phone:getCurJob", cid)
  local signedIn = RPC.execute("phone:isSignedIn", cid)
  local inGroup = RPC.execute("phone:isInGroup", cid)
  local actuallyInGroup = RPC.execute("phone:isActuallyInGroup", cid)
  if tostring(curjob) ~= tostring(job) then return end
  if signedIn == 0 or signedIn == nil then return end
  if inGroup == 0 or inGroup == nil then return end
  if not actuallyInGroup then return end
  TriggerEvent("GroupsUpdatePhone")
end)

RegisterNUICallback('signOut', function()
  local cid = exports["isPed"]:isPed("cid")
  local result = RPC.execute("phone:signOut", cid)
  if result then
    TriggerEvent("GroupsUpdatePhone")
    TriggerEvent("DoLongHudText", "Signed Out.", 2)
  end
end)

RegisterNUICallback('createGroup', function()
  -- in this rpc you should call a client event to update the app for everyone who is signed in to the current job
  -- same with if the owner ready the group it should trigger it, and then check the owner cids group and all the members in it etc
  -- same with disband group.
  -- add disband group for group owner
  local cid = exports["isPed"]:isPed("cid")
  local curjob = RPC.execute("phone:getCurJob", cid)
  local result = RPC.execute("phone:createGroup", cid, curjob)
  if result then
    TriggerEvent("GroupsUpdatePhone")
    TriggerEvent("DoLongHudText", "Created Group!", 1)
  end
end)

RegisterNUICallback('joinGroup', function(data)
  -- Joing groups should also call a update so you can see the member count of group increase
  -- also to update to the people who are inside the group aswell
  -- just update for everyone where CID matches and groupowner is groupowner
  local cid = exports["isPed"]:isPed("cid")
  local curjob = RPC.execute("phone:getCurJob", cid)
  local result = RPC.execute("phone:joinGroup", cid, data.groupowner, curjob)
  if result then
  TriggerEvent("GroupsUpdatePhone")
  TriggerEvent("DoLongHudText", "Joined Group!", 1)
  end
end)

RegisterNUICallback('groups', function()
  TriggerEvent("GroupsUpdatePhone")
end)

RegisterNetEvent('GroupsUpdatePhone')
AddEventHandler('GroupsUpdatePhone', function()
  local cid = exports["isPed"]:isPed("cid")
  local signedIn = RPC.execute("phone:isSignedIn", cid)
  local inGroup = RPC.execute("phone:isInGroup", cid)

  if signedIn == 0 or signedIn == nil then
    local jobarray = RPC.execute("phone:getJobs")
    jobs = {}
  
    for i = 1, #jobarray do
      jobs[#jobs + 1] = {
          id = tonumber(i),
          jobname = jobarray[tonumber(i)].jobname,
          jobtype = jobarray[tonumber(i)].jobtype,
          jobicon = jobarray[tonumber(i)].jobicon
      }
    end
    SendNUIMessage({openSection = "joblist", joblist = jobs, signedIn = false})
  end
  if signedIn == 1 then
  if inGroup == 0 or inGroup == nil then
    local curjob = RPC.execute("phone:getCurJob", cid)
    local availgroups = RPC.execute("phone:getIdleGroups", curjob)
    local busygroups = RPC.execute("phone:getBusyGroups", curjob)
    groups = {}
  
    for i = 1, #availgroups do
      local first_name = RPC.execute("phone:getFirstName", availgroups[tonumber(i)].owner)
      local last_name =  RPC.execute("phone:getLastName", availgroups[tonumber(i)].owner)

      groups[#groups + 1] = {
          id = tonumber(i),
          groupowner = availgroups[tonumber(i)].owner,
          firstname = first_name,
          lastname = last_name,
          members = availgroups[tonumber(i)].members,
          jobtype = availgroups[tonumber(i)].jobtype
      }
    end

    nonidle = {}  
    for i = 1, #busygroups do


      local first_name = RPC.execute("phone:getFirstName", busygroups[tonumber(i)].owner)
      local last_name =  RPC.execute("phone:getLastName", busygroups[tonumber(i)].owner)

      nonidle[#nonidle + 1] = {
          id = tonumber(i),
          groupowner = busygroups[tonumber(i)].owner,
          firstname = first_name,
          lastname = last_name,
          members = busygroups[tonumber(i)].members,
          jobtype = busygroups[tonumber(i)].jobtype
      }
    end

    if availgroups ~= nil and busygroups ~= nil then 
      SendNUIMessage({openSection = "jobgroups", grouplist = groups, busygrouplist = nonidle, signedIn = true})
    end
    if availgroups == nil and busygroups == nil then 
      SendNUIMessage({openSection = "jobgroups", grouplist = {}, busygrouplist = {}, signedIn = true})
    end
    if availgroups ~= nil and busygroups == nil then 
      SendNUIMessage({openSection = "jobgroups", grouplist = groups, busygrouplist = {}, signedIn = true})
    end
    if availgroups == nil and busygroups ~= nil then 
      SendNUIMessage({openSection = "jobgroups", grouplist = {}, busygrouplist = nonidle, signedIn = true})
    end
    else
      print("in group")
      -- in group
      -- loop thru all members and see if you match one or owner
      -- when creating a group you auto set yourself to ingroup
      local group = RPC.execute("phone:getGroupByCID", cid)
      jobmembers = {}

      for i = 1, #group do

    
          local first_name = RPC.execute("phone:getFirstName", group[tonumber(i)].cid)
          local last_name =  RPC.execute("phone:getLastName", group[tonumber(i)].cid)
    
          jobmembers[#jobmembers + 1] = {
              id = tonumber(i),
              groupowner = group[tonumber(i)].owner,
              firstname = first_name,
              lastname = last_name,
              jobtype = group[tonumber(i)].jobtype
          }

          -- another for loop checking job_members table where CID is owner cid and then add to the table jobmembers[#jobmembers + 1]
        end
        local inAGroup
  
        if isInGroup == 1 then inAGroup = true else inAGroup = false end
  
        SendNUIMessage({openSection = "ingroup", groupmembers = jobmembers, members = {}, signedIn = true, ingroup = true})
    end
  end
end)

RegisterNUICallback('sendify', function()
  local cid = exports["isPed"]:isPed("cid")

  local logs = RPC.execute("phone:getSendifyLogs", cid)

  if logs == nil then local alllogs = {} SendNUIMessage({openSection = "sendify", transactions = alllogs}) return end

  local transactionlogs = {}

  for i = 1, #logs do
    transactionlogs[#transactionlogs + 1] = {
        id = tonumber(i),
        cid = logs[tonumber(i)].cid,
        sender = logs[tonumber(i)].sender,
        target = logs[tonumber(i)].target,
        comment = logs[tonumber(i)].comment,
        amount = logs[tonumber(i)].amount,
        date = logs[tonumber(i)].date,
        type = logs[tonumber(i)].type
      }
  end
  SendNUIMessage({openSection = "sendify", transactions = transactionlogs})
end)

RegisterNUICallback('employmenttest', function()
  local cid = exports["isPed"]:isPed("cid")

  local employedat = RPC.execute("warp-business:business:GetEmploymentInformation")

  if employedat == nil then local employed = {} SendNUIMessage({openSection = "employment", employment = employed}) return end

  local employment = {}

  for i = 1, #employedat do
    employment[#employment + 1] = {
        id = tonumber(i),
        businessid = employedat[tonumber(i)].business_id,
        businessname = employedat[tonumber(i)].business_name,
        businessrole = employedat[tonumber(i)].role,
        businessicon = "fa-business-time"
      }
  end
  SendNUIMessage({openSection = "employment", employment = employment})
end)

RegisterNUICallback('employment', function()
  local cid = exports["isPed"]:isPed("cid")

  local employedat = RPC.execute("warp-business:business:GetEmploymentInformation")

  if employedat == nil then local employed = {} SendNUIMessage({openSection = "employment", employment = employed}) return end

  SendNUIMessage({openSection = "employment", employment = employedat})

  local employment = {}

  for i = 1, #employedat do
    employment[#employment + 1] = {
        id = tonumber(i),
        businessid = employedat[tonumber(i)].business_id,
        businessname = employedat[tonumber(i)].business_name,
        businessrole = employedat[tonumber(i)].role,
        businessicon = "fa-business-time"
      }
  end
  SendNUIMessage({openSection = "employment", employment = employment})
end)

RegisterNUICallback('darkmarket', function()
  local productarray = RPC.execute("phone:getDarkMarketProducts", heistzone)
  products = {}

  for i = 1, #productarray do
    products[#products + 1] = {
        id = tonumber(i),
        dbid = productarray[tonumber(i)].id,
        name = productarray[tonumber(i)].product_name,
        price = productarray[tonumber(i)].product_price,
        itemid = productarray[tonumber(i)].product_itemid,
        cryptoid = productarray[tonumber(i)].cryptoid,
        icon = productarray[tonumber(i)].product_icon
      }
  end
  SendNUIMessage({openSection = "darkmarket", marketProducts = products})
end)

RegisterNUICallback('debt', function()
  local cid = exports["isPed"]:isPed("cid")
  local assetfees = RPC.execute("phone:getDebt", cid)
  local loans = RPC.execute("phone:getLoans", cid)
  --if not debt then SendNUIMessage({openSection = "debt", debt = mydebt})
  --get house & vehicle asset fees
  --get loans
  allfees = {}
  for i = 1, #assetfees do

    --debt_propertyid (get prop name from this)
    --debt_carid (get model from this)

    local propertyid = assetfees[tonumber(i)].debt_propertyid
    local carid = assetfees[tonumber(i)].debt_carid
    local propname = nil
    local carname = nil
    if propertyid ~= nil then
      propname = RPC.execute("phone:getPropertyNameFromID", propertyid)
    end
    if carid ~= nil then
      carname = RPC.execute("phone:getCarNameFromID", carid)
    end

    allfees[#allfees + 1] = {
        id = assetfees[tonumber(i)].id,
        debtid = assetfees[tonumber(i)].debtid,
        debtcid = assetfees[tonumber(i)].debtcid,
        debttype = assetfees[tonumber(i)].debttype,
        debtowed = assetfees[tonumber(i)].debtowed,
        debtdue = assetfees[tonumber(i)].debtdue,
        debtcarname = carname,
        debtpropname = propname
      }
  end

  allloans = {}
  for i = 1, #loans do

    local issuername = RPC.execute("phone:getBusinessNameFromID", loans[tonumber(i)].loanissuer)

    allloans[#allloans + 1] = {
        id = loans[tonumber(i)].id,
        loanid = loans[tonumber(i)].loanid,
        loanissuer = loans[tonumber(i)].loanissuer,
        loanissuername = issuername,
        loancid = loans[tonumber(i)].loancid,
        loanphonenr = loans[tonumber(i)].loanphonenr,
        loanamount = loans[tonumber(i)].loanamount,
        loantotalpayments = loans[tonumber(i)].loantotalpayments,
        loantotalpaymentspaid = loans[tonumber(i)].loantotalpaymentspaid,
        loandue = loans[tonumber(i)].loandue,
        loantype = loans[tonumber(i)].loantype,
        loaninterest = loans[tonumber(i)].loaninterest,
        loanowed = loans[tonumber(i)].loanowed
      }
  end

  SendNUIMessage({openSection = "debt", fees = allfees, loans = allloans})
end)

RegisterNUICallback('crypto', function()
  local cid = exports["isPed"]:isPed("cid")
  local cryptoarray = RPC.execute("phone:getCryptos")
  allcryptos = {}

  for i = 1, #cryptoarray do

    local cryptoamount = RPC.execute("phone:getCryptoBalance", cid, cryptoarray[tonumber(i)].cryptoid)
    if cryptoamount == nil then
      RPC.execute("phone:generateWallet", cid, cryptoarray[tonumber(i)].cryptoid)
    end

    allcryptos[#allcryptos + 1] = {
        id = cryptoarray[tonumber(i)].cryptoid,
        name = cryptoarray[tonumber(i)].cryptoname,
        tag = cryptoarray[tonumber(i)].cryptotag,
        icon = cryptoarray[tonumber(i)].cryptoicon,
        canbuy = cryptoarray[tonumber(i)].buyable,
        canexchange = cryptoarray[tonumber(i)].exchangeable,
        cansell = cryptoarray[tonumber(i)].sellable,
        value = cryptoarray[tonumber(i)].value,
        amount = cryptoamount
      }
  end
  SendNUIMessage({openSection = "crypto", cryptos = allcryptos})
end)

RegisterNUICallback('email', function()
  local emailarray = RPC.execute("phone:getEmails")
  local hasEmail = RPC.execute("phone:hasEmails")

  if not hasEmail then SendNUIMessage({openSection = "nothing"}) return end

  emails = {}

  for i = 1, #emailarray do
    emails[#emails + 1] = {
        id = tonumber(i),
        from = emailarray[tonumber(i)].from,
        subject = emailarray[tonumber(i)].subject,
        message = emailarray[tonumber(i)].message,
        time = emailarray[tonumber(i)].time
      }
  end
  SendNUIMessage({openSection = "email", emailist = emails})
end)

RegisterNUICallback('garage', function()
  local vehiclearray = RPC.execute("phone:getOwnedVehicles")
  vehicles = {}

  for i = 1, #vehiclearray do

    local enginePercent = vehiclearray[tonumber(i)].engine_damage / 10
    local bodyPercent = vehiclearray[tonumber(i)].body_damage / 10

    vehicles[#vehicles + 1] = {
        id = tonumber(i),
        name = vehiclearray[tonumber(i)].name,
        state = vehiclearray[tonumber(i)].vehicle_state,
        engine_damage = enginePercent,
        body_damage = bodyPercent,
        curgarage = vehiclearray[tonumber(i)].current_garage,
        license_plate = vehiclearray[tonumber(i)].license_plate
      }
  end
  SendNUIMessage({openSection = "garage", ownedVehicles = vehicles})
end)

RegisterNUICallback('housing', function()
  local cid = exports["isPed"]:isPed("cid")
  TriggerEvent("HousesUpdatePhone")
end)

RegisterNUICallback('addKeyPropertyModal', function(data)
  SendNUIMessage({openSection = "addPropertyKeyModal", propid = data.propertyid})
end)

RegisterNUICallback('addPropertyKey', function(data)
  -- check if they have more than 2 keys if they do, fail.
  local result = RPC.execute("phone:addPropertyKey", data.cid, data.propertyid)
  if not result then TriggerEvent("DoLongHudText", "Couldn't add property key.", 2) return end
  
  --update key section
  local keys = RPC.execute("phone:getPropertyKeys", data.propertyid) --use propertyid
  local allkeys = {}
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
end)

RegisterNUICallback('removePropertyKey', function(data)
  local result = RPC.execute("phone:removePropertyKey", data.cid, data.propertyid)
  if not result then TriggerEvent("DoLongHudText", "Couldn't remove property key.", 2) return end
  --update key section
  local keys = RPC.execute("phone:getPropertyKeys", data.propertyid) --use propertyid
  local allkeys = {}
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

-- RegisterNUICallback('vehspawn', function(data)
--   findVehFromPlateAndSpawn(data.vehplate)
-- end)

RegisterNUICallback('vehtrack', function(data)
  TriggerServerEvent("get:vehicle:coords", data.vehplate)
end)

RegisterNUICallback('trackVehicle', function(data)
  print(data.plate)
  local coords = RPC.execute("phone:trackCar", data.plate)
  SetNewWaypoint(coords.x, coords.y)
end)

RegisterNUICallback('vehiclePay', function(data)
  TriggerServerEvent('car:dopayment', data.vehiclePlate)
end)

RegisterNetEvent("pass:coords:vehicle")
AddEventHandler("pass:coords:vehicle", function(coords)
  local VehicleCoords = coords
  SetNewWaypoint(VehicleCoords.x,VehicleCoords.y)
  TriggerEvent("DoLongHudText", "Your vehicle's location is marked on the map!")
end)

RegisterNUICallback('carpaymentsowed', function()
  TriggerServerEvent("car:Outstanding")
end)

RegisterNetEvent("phone:listunpaid")
AddEventHandler("phone:listunpaid", function(outstandingArray)

  SendNUIMessage({
    openSection = "showOutstandingPayments",
    outstandingPayments = outstandingArray
  })
    -- finish outstanding payments here.
end)

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
              TriggerServerEvent("vehicle:coords",plateupdate,coords)
            end
        end
        if invehicle and not IsPedInAnyVehicle(PlayerPedId(), false) then
          local coords = GetEntityCoords(vehobj)
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

RegisterNetEvent("phone:Garage")
AddEventHandler("phone:Garage", function(plyvehs)

  local showCarPayments = false
  local rankCarshop = exports["isPed"]:GroupRank("car_shop")

  if rankCarshop > 0 then
    showCarPayments = true
  end

  local parsedVehicleData = {}
  for ind, value in pairs(plyvehs) do
    enginePercent = value.engine_damage / 10
    bodyPercent = value.body_damage / 10
    vehName = value.name
    vehPlate = value.license_plate
    currentGarage = value.current_garage
    state = value.vehicle_state
    allowspawnattempt = 0  
    table.insert(parsedVehicleData, {
      name = vehName,
      plate = vehPlate,
      garage = currentGarage,
      state = state,
      enginePercent = enginePercent,
      bodyPercent = bodyPercent,
      payments = value.payments_left, -- total payments left
      lastPayment = value.finance_time, -- Days left
      amountDue = math.floor(value.financed/value.payments_left), -- amount due
      canSpawn = 0
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


function rundropoff(boxcount,costs)
  local success = true
  local timer = 600000
  TriggerEvent("chatMessagess", "EMAIL ", 8, "Yo, here are the coords for the drop off, you have 10 minutes - leave $" .. costs .. " in cash there!")
  refreshmail()
  local location = pickuppoints[math.random(#pickuppoints)]
  CreateBlip(location)
  while timer > 0 do
    Citizen.Wait(1)
    local plycoords = GetEntityCoords(PlayerPedId())
    local dstcheck = #(plycoords - vector3(location["x"],location["y"],location["z"])) 
    if dstcheck < 5.0 then
      DrawText3Ds(location["x"],location["y"],location["z"], "Press E to pickup the dropoff.")
       if dstcheck < 3.0 and IsControlJustReleased(0,38) then
          success = true
          timer = 0
       end
    end
    timer = timer - 1
    if timer == 1 then
      success = false
    end
  end
  if success then
    TriggerServerEvent("weed:phone:buybox",boxcount,costs)
  end
  DeleteBlip()
end


-- turn this to false to re-enable weed purchases.
local waiting = false
RegisterNUICallback('btnBox1', function()
  if waiting then
    return
  end
  waiting = true
  
  Citizen.Wait(math.random(100000))
  rundropoff(1,1500)
  waiting = false
end)

RegisterNUICallback('btnBox2', function()
  if waiting then
    return
  end
  waiting = true
  
  Citizen.Wait(math.random(100000))
  rundropoff(5,4500)
  waiting = false
end)

RegisterNUICallback('btnBox3', function()
  if waiting then
    return
  end
  waiting = true
  
  Citizen.Wait(math.random(100000))
  rundropoff(10,8500)
  waiting = false
end)


RegisterNUICallback('btnBox6', function()
  closeGui()
  TriggerEvent("hacking:attemptHackCrypto","weapon")
end)

RegisterNUICallback('btnBox5', function()
  closeGui()
  TriggerEvent("hacking:attemptHackCrypto","crack")
end)

RegisterNUICallback('btnBox4', function()
  closeGui()
  TriggerEvent("hacking:attemptHackCrypto","bigweapon")
end)

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

RegisterNetEvent("stocks:timedEvent")
AddEventHandler("stocks:timedEvent", function(typeSent)
  local success = true
  local timer = 600000
  TriggerEvent("chatMessagess", "EMAIL ", 8, "Yo, here are the coords for the drop off, you have 10 minutes - I already zoinked your Pixerium Credits")
  refreshmail()
  local location = pickuppoints[math.random(#pickuppoints)]
  CreateBlip(location)
  while timer > 0 do
    Citizen.Wait(1)
    local plycoords = GetEntityCoords(PlayerPedId())
    local dstcheck = #(plycoords - vector3(location["x"],location["y"],location["z"])) 
    if dstcheck < 5.0 then
      DrawText3Ds(location["x"],location["y"],location["z"], "Press E to pickup the dropoff.")
       if dstcheck < 3.0 and IsControlJustReleased(0,38) then
          success = true
          timer = 0
       end
    end
    timer = timer - 1
    if timer == 1 then
      success = false
    end
  end

  if success then

    if math.random(1000) == 69 then
      TriggerEvent("player:receiveItem", "741814745", 1)
    end

    if math.random(10) == 1 then
      TriggerEvent("player:receiveItem", ""..luckList[math.random(6)].."", 1)
    end


    if typeSent == "bigweapon" then
      TriggerEvent("player:receiveItem", ""..weaponList[math.random(4)].."", 1)
    end

    if typeSent == "weapon" then
      TriggerEvent("player:receiveItem", ""..weaponListSmall[math.random(3)].."", 1)
    end

  end

  DeleteBlip()
 
end)


function buyItem(typeSent)
  local success = true
  local timer = 600000
  TriggerEvent("chatMessage", "EMAIL ", 8, "Yo, here are the coords for the drop off, you have 10 minutes - it will cost " .. costs .. " Pixerium")
  refreshmail()
  local location = pickuppoints[math.random(#pickuppoints)]
  CreateBlip(location)
  while timer > 0 do
    Citizen.Wait(1)
    local plycoords = GetEntityCoords(PlayerPedId())
    local dstcheck = #(plycoords - vector3(location["x"],location["y"],location["z"])) 
    if dstcheck < 5.0 then
      DrawText3Ds(location["x"],location["y"],location["z"], "Press E to pickup the dropoff.")
       if dstcheck < 3.0 and IsControlJustReleased(0,38) then
          success = true
          timer = 0
       end
    end
    timer = timer - 1
    if timer == 1 then
      success = false
    end
  end
  if success then
    TriggerEvent("crypto:buybox",typeSent,costs)
  end
  DeleteBlip()
end


RegisterNUICallback('btnDelivery', function()
  TriggerEvent("trucker:confirmation")
end)

RegisterNUICallback('btnPackages', function()
  insideDelivers = true
  TriggerEvent("Trucker:GetPackages")
end)

RegisterNUICallback('btnTrucker', function()
  TriggerEvent("Trucker:GetJobs")
end)

RegisterNUICallback('resetPackages', function()
  insideDelivers = false
end)


RegisterNetEvent("phone:trucker")
AddEventHandler("phone:trucker", function(jobList)

  local deliveryObjects = {}
  for i, v in pairs(jobList) do
    local nameTag = ""
    local itemTag
    local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(v.pickup[1], v.pickup[2], v.pickup[3], currentStreetHash, intersectStreetHash)
    local currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
    local intersectStreetName = GetStreetNameFromHashKey(intersectStreetHash)

    local currentStreetHash2, intersectStreetHash2 = GetStreetNameAtCoord(v.drop[1], v.drop[2], v.drop[3], currentStreetHash2, intersectStreetHash2)
    local currentStreetName2 = GetStreetNameFromHashKey(currentStreetHash2)
    local intersectStreetName2 = GetStreetNameFromHashKey(intersectStreetHash2)
    if v.active == 0 then
        table.insert(deliveryObjects, {
          targetStreet = currentStreetName2,
          jobId = v.id,
          jobType = v.JobType
        })
    end
  end 
  SendNUIMessage({
    openSection = "deliveryJob",
    deliveries = deliveryObjects
  })
    
end)

local requestHolder = 0

RegisterNetEvent("phone:packages")
AddEventHandler("phone:packages", function(packages)
  while insideDelivers do
    if requestHolder ~= 0 then
      SendNUIMessage({
        openSection = "packagesWith"
      })
    else
      SendNUIMessage({
        openSection = "packages"
      })
    end
    
    
    for i, v in pairs(packages) do
      if GetPlayerServerId(PlayerId()) == v.source then
        local currentStreetHash2, intersectStreetHash2 = GetStreetNameAtCoord(v.drop[1], v.drop[2], v.drop[3], currentStreetHash2, intersectStreetHash2)
        local currentStreetName2 = GetStreetNameFromHashKey(currentStreetHash2)
        local intersectStreetName2 = GetStreetNameFromHashKey(intersectStreetHash2)

        SendNUIMessage({openSection = "addPackages", street2 = currentStreetName2, jobId = v.id ,distance = getDriverDistance(v.driver , v.drop)})
      end
    end 
    Wait(4000)
  end
end)


RegisterNetEvent("phone:OwnerRequest")
AddEventHandler("phone:OwnerRequest", function(holder)
  requestHolder = holder
end)

RegisterNUICallback('btnRequest', function()
  TriggerServerEvent("trucker:confirmRequest",requestHolder)
  requestHolder = 0
end)




function getDriverDistance(driver , drop)
  local dist = 0

  local ped = GetPlayerPed(value)
  if driver ~= 0 then
    local current = #(vector3(drop[1],drop[2],drop[3]) - GetEntityCoords(ped))
    if current < 15 then
      dist = "Driver at store"
    else
      dist = current
      dist = math.ceil(dist)
    end
    
  else
    dist = "Waiting for driver"
  end

  return dist
end

RegisterNUICallback('selectedJob', function(data, cb)
    TriggerEvent("Trucker:SelectJob",data)
end)

gurgleList = {}
RegisterNetEvent('websites:updateClient')
AddEventHandler('websites:updateClient', function(passedList)
  gurgleList = passedList

  local gurgleObjects = {}

  if not guiEnabled then
    return
  end

  for i = 1, #gurgleList do
    table.insert(gurgleObjects, {
      webTitle = gurgleList[i]["Title"], 
      webKeywords = gurgleList[i]["Keywords"], 
      webDescription = gurgleList[i]["Description"] 
    })
  end

  SendNUIMessage({ openSection = "gurgleEntries", gurgleData = gurgleObjects})
end)

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
    -- TriggerEvent('chatMessagess', "RADIO CHANNEL " .. radioChannel, 3, "Active", 5000)
  end
end)


function isRealEstateAgent()
  local myjob = exports["isPed"]:isPed("myjob")
  if myjob == "realtor" then
    print("is a realtor")
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


function hasDecrypt()
    if exports["warp-inventory"]:hasEnoughOfItem("decrypterenzo",1,false) or exports["warp-inventory"]:hasEnoughOfItem("decryptersess",1,false) or exports["warp-inventory"]:hasEnoughOfItem("decrypterfv2",1,false) and not exports["isPed"]:isPed("disabled") or exports["warp-inventory"]:hasEnoughOfItem(80,1,false) and not exports["isPed"]:isPed("disabled") then
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

function sendAppEvent(bool, data)
  if not bool then SendNUIMessage({showWifi = false, showHiddenApp = false}) hiddenapp = false return end
  heistzone = data.id
  SendNUIMessage({showWifi = true})
end

RegisterCommand("show", function()
  TriggerEvent("showphonenotify")
end)

RegisterCommand("hide", function()
  TriggerEvent("hidephonenotify")
end)

RegisterNetEvent("showphonenotify")
AddEventHandler("showphonenotify", function()
  SendNUIMessage({phonenotification = true})
end)

RegisterNetEvent("hidephonenotify")
AddEventHandler("hidephonenotify", function()
  SendNUIMessage({phonenotification = false})
end)

local recentopen = false
function openGuiNow()
 
  if hasPhone() then
    
    GiveWeaponToPed(PlayerPedId(), 0xA2719263, 0, 0, 1)
    guiEnabled = true
      SetNuiFocus(false,false)
      SetNuiFocus(true,true)

    local isREAgent = false
    if isRealEstateAgent() then
      isREAgent = true
    end

    local hasDong = false
    if exports["warp-inventory"]:hasEnoughOfItem("racingusb2", 1, false) then
      hasDong = true
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

    trucker = true

    SendNUIMessage({openPhone = true, showHiddenApp = hiddenapp, hasDevice = device, hasDecrypt = decrypt, hasDecrypt2 = decrypt2,hasTrucker = trucker, isRealEstateAgent = isREAgent, hasRacingDongle = hasDong, playerId = GetPlayerServerId(PlayerId())})

    TriggerEvent('phoneEnabled',true)
    TriggerEvent('animation:sms',true)

        --TaskStartScenarioInPlace(PlayerPedId(), "CODE_HUMAN_MEDIC_TIME_OF_DEATH", 0, 1)
        
    -- If this is the first time we've opened the phone, load all contacts
  
    lstContacts = {}
    --TriggerServerEvent('phone:getContacts')
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


function openGui()

  if recentopen then
    return
  end
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


    trucker = true
   

    SendNUIMessage({openPhone = true, hasDevice = device, hasDecrypt = decrypt, hasDecrypt2 = decrypt2,hasTrucker = trucker, isRealEstateAgent = isREAgent, playerId = GetPlayerServerId(PlayerId())})

    TriggerEvent('phoneEnabled',true)
    TriggerEvent('animation:sms',true)

        --TaskStartScenarioInPlace(PlayerPedId(), "CODE_HUMAN_MEDIC_TIME_OF_DEATH", 0, 1)
        
    -- If this is the first time we've opened the phone, load all contacts
    
    lstContacts = {}
    --TriggerServerEvent('phone:getContacts')
    doTimeUpdate()
  else
    closeGui()
    if not exports["isPed"]:isPed("disabled") then
      TriggerEvent("DoLongHudText","You do not have a phone.",2)
    else
      TriggerEvent("DoLongHudText","You cannot use your phone right now.",2)
    end
  end
  Citizen.Wait(3000)
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
  TriggerEvent('chatMessagess', "", 2, "Searching for a lawyer...")
  for i = 1, #YellowPageArray do
    local job = string.lower(YellowPageArray[tonumber(i)].job)
    if string.find(job, 'attorney') or string.find(job, 'lawyer') or string.find(job, 'public defender') then
      isFound = true
      TriggerEvent('chatMessagess', "", 2, "⚖️ " .. YellowPageArray[i].name .. " ☎️ " .. YellowPageArray[i].phonenumber)
    end
  end
  if not isFound then
    TriggerEvent('chatMessagess', "", 2, "There are no lawyers available right now. 😢")
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
  recentopen = true
  Citizen.Wait(3000)
  recentopen = false
  insideDelivers = false
end

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
  TriggerEvent("closeInventoryGui")
  SetNuiFocus(false,false)
  SendNUIMessage({openPhone = false})
  guiEnabled = false
  recentopen = true
  Citizen.Wait(3000)
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

local currentMap = {}
local customMaps = {}
local dst = 30.0
local creatingMap = false
local SetBlips = {}
local particleList = {}
local currentRaces = {}
local JoinedRaces = {}
local racing = false
local racesStarted = 0
local mylastid = "NA"

-- Disable controls while GUI open
Citizen.CreateThread(function()
  local focus = true
  
  while true do

    if guiEnabled then
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
      if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
        SendNUIMessage({type = "click"})
      end

    else
      mousemovement = 0
    end

    if selfieMode then
        if IsControlJustPressed(0, 177) then
          selfieMode = false
          DestroyMobilePhone()
          CellCamActivate(false, false)
        end
        HideHudComponentThisFrame(7)
        HideHudComponentThisFrame(8)
        HideHudComponentThisFrame(9)
        HideHudComponentThisFrame(6)
        HideHudComponentThisFrame(19)
        HideHudAndRadarThisFrame()
    else
      selfieMode = false
      DestroyMobilePhone()
      CellCamActivate(false, false)
    end

    if creatingMap then

      local plycoords = GetEntityCoords(GetPlayerPed(-1))

      DrawMarker(27,plycoords.x,plycoords.y,plycoords.z,0,0,0,0,0,0,dst,dst,0.3001,255,255,255,255,0,0,0,0)
      
      if #currentMap == 0 then
        DrawText3Ds(plycoords.x,plycoords.y,plycoords.z,"[E] to add start point, up/down for size, phone to save or cancel.")
      else
        DrawText3Ds(plycoords.x,plycoords.y,plycoords.z,"[E] to add check point, up/down for size, phone to save or cancel.")
      end

      if IsControlPressed(0,27) then
        dst = dst + 1
        if dst > 60.0 then
          dst = 60.0
        end
      end

      if IsControlPressed(0,173) then
        dst = dst - 1
        if dst < 4 then
          dst = 3.0
        end
      end

      if IsControlJustReleased(0,38) then
        if (IsControlPressed(0,21)) then
          PopLastCheckpoint()
        else
          AddCheckPoint()
        end
        Wait(1000)
      end

    end
    Citizen.Wait(1)
  end
end)

function StartMapCreation()
  currentMap = {}
  dst = 30.0;
  creatingMap = true
end

function CancelMap()
  -- get distance here between checkpoints
  creatingMap = false
end

function ClearBlips()
  for i = 1, #SetBlips do
    RemoveBlip(SetBlips[i])
  end
  SetBlips = {}
end

function AddCheckPoint()
  loadCheckpointModels()
  local plycoords = GetEntityCoords(GetPlayerPed(-1))
  local ballsdick = dst/2
  local fx,fy,fz = table.unpack(GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1),  ballsdick, 0.0, -0.25))

  local fx2,fy2,fz2 = table.unpack(GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0 - ballsdick, 0.0, -0.25))
  
  addCheckpointMarker(vector3(fx,fy,fz), vector3(fx2,fy2,fz2))

  local start = false

  if #currentMap == 0 then
    start = true
  end

  local checkcounter = #currentMap + 1
  currentMap[checkcounter] = { 
    ["flare1x"] = FUCKK(fx), ["flare1y"] = FUCKK(fy), ["flare1z"] = FUCKK(fz),
    ["flare2x"] = FUCKK(fx2), ["flare2y"] = FUCKK(fy2), ["flare2z"] = FUCKK(fz2),
    ["x"] = FUCKK(plycoords.x),  ["y"] = FUCKK(plycoords.y), ["z"] = FUCKK(plycoords.z-1.1), ["start"] = start, ["dist"] = ballsdick, 
  }

  local key = #SetBlips+1
  SetBlips[key] = AddBlipForCoord(plycoords.x,plycoords.y,plycoords.z)
  SetBlipAsFriendly(SetBlips[key], true)
  SetBlipSprite(SetBlips[key], 1)
  ShowNumberOnBlip(SetBlips[key], key)
  BeginTextCommandSetBlipName("STRING");
  AddTextComponentString(tostring("Checkpoint " .. key))
  EndTextCommandSetBlipName(SetBlips[key])

end

local checkpointMarkers = {}
local isModelsLoaded = false
function loadCheckpointModels()
  local models = {}
  models[1] = "prop_offroad_tyres02"
  models[2] = "prop_beachflag_01"
  for i = 1, #models do
    local checkpointModel = GetHashKey(models[i])
    RequestModel(checkpointModel)
    while not HasModelLoaded(checkpointModel) do
      Citizen.Wait(1)
    end
  end
  isModelsLoaded = true
end

function addCheckpointMarker(leftMarker, rightMarker)
  local model = #checkpointMarkers == 0 and 'prop_beachflag_01' or 'prop_offroad_tyres02'

  local checkpointLeft = CreateObject(GetHashKey(model), leftMarker, false, false, false)
  local checkpointRight = CreateObject(GetHashKey(model), rightMarker, false, false, false)
  checkpointMarkers[#checkpointMarkers+1] = {
    left = checkpointLeft,
    right = checkpointRight
  }
  PlaceObjectOnGroundProperly(checkpointLeft)
  SetEntityAsMissionEntity(checkpointLeft)
  PlaceObjectOnGroundProperly(checkpointRight)
  SetEntityAsMissionEntity(checkpointRight)
end

function LoadMapBlips(id, reverseTrack, laps)
  local id = tostring(id)
  ClearBlips()
  loadCheckpointModels()
  if(customMaps[id].checkpoints ~= nil) then
    local checkpoints = customMaps[id].checkpoints
    if reverseTrack then
      local newCheckpoints = {}
      local count = 1
      for i=#checkpoints, 1, -1 do
        newCheckpoints[count] = checkpoints[i]
        count = count + 1
      end
      if laps ~= 0 then
        table.insert(newCheckpoints, 1, checkpoints[1])
        newCheckpoints[#newCheckpoints] = nil
      end
      checkpoints = newCheckpoints
    end

    for mId, map in pairs(checkpoints) do
      local key = #SetBlips+1
      SetBlips[key] = AddBlipForCoord(map["x"],map["y"],map["z"])
      SetBlipAsFriendly(SetBlips[key], true)
      SetBlipAsShortRange(SetBlips[key], true)
      SetBlipSprite(SetBlips[key], 1)
      ShowNumberOnBlip(SetBlips[key], key)
      BeginTextCommandSetBlipName("STRING");
      AddTextComponentString(tostring("Checkpoint " .. key))
      EndTextCommandSetBlipName(SetBlips[key])

      addCheckpointMarker(vector3(map["flare1x"], map["flare1y"], map["flare1z"]), vector3(map["flare2x"], map["flare2y"], map["flare2z"]))
    end
  end
end

function PopLastCheckpoint()
  if #currentMap > 1 then
    local lastCheckpoint = #currentMap
    SetEntityAsNoLongerNeeded(checkpointMarkers[lastCheckpoint].left)
    DeleteObject(checkpointMarkers[lastCheckpoint].left)
    SetEntityAsNoLongerNeeded(checkpointMarkers[lastCheckpoint].right)
    DeleteObject(checkpointMarkers[lastCheckpoint].right)
    RemoveBlip(SetBlips[lastCheckpoint])
    table.remove(checkpointMarkers)
    table.remove(currentMap)
    table.remove(SetBlips)
  end
end

function ShowText(text)
  TriggerEvent("DoLongHudText",text)
end

function StartEvent(map, laps, counter, reverseTrack, raceName, startTime,
  mapCreator, mapDistance, mapDescription)

local map = tostring(map)
local laps = tonumber(laps)
local counter = tonumber(counter)
local mapCreator = tostring(mapCreator)
local mapDistance = tonumber(mapDistance)
local mapDescription = tostring(mapDescription)
local reverseTrack = reverseTrack

if map == 0 then
ShowText("Pick a map or use the old racing system.")
return
end

local mapCheckpoints = customMaps[map]["checkpoints"]
local checkPointIndex = 1
if reverseTrack and laps == 0 then checkPointIndex = #mapCheckpoints end

local ped = GetPlayerPed(-1)
local plyCoords = GetEntityCoords(ped)
local dist = Vdist(mapCheckpoints[checkPointIndex]["x"],
     mapCheckpoints[checkPointIndex]["y"],
     mapCheckpoints[checkPointIndex]["z"], plyCoords.x,
     plyCoords.y, plyCoords.z)

if dist > 40.0 then
ShowText("You are too far away!")
EndRace()
return
end

ShowText("Race Starting on " .. customMaps[map]["track_name"] .. " with " ..
laps .. " laps in " .. counter .. " seconds!")
racesStarted = racesStarted + 1
local cid = exports["isPed"]:isPed("cid")
local uniqueid = cid .. "-" .. racesStarted

local s1, s2 = GetStreetNameAtCoord(mapCheckpoints[checkPointIndex].x,mapCheckpoints[checkPointIndex].y, mapCheckpoints[checkPointIndex].z)
local street1 = GetStreetNameFromHashKey(s1)
zone = tostring(GetNameOfZone(mapCheckpoints[checkPointIndex].x,mapCheckpoints[checkPointIndex].y,mapCheckpoints[checkPointIndex].z))
local playerStreetsLocation = GetLabelText(zone)
local dir = getCardinalDirectionFromHeading()
local street1 = street1 .. ", " .. playerStreetsLocation
local street2 = GetStreetNameFromHashKey(s2) .. " " .. dir
TriggerServerEvent("racing-global-race", map, laps, counter, reverseTrack,uniqueid, cid, raceName, startTime, mapCreator,mapDistance, mapDescription, street1, street2)
end

function hudUpdate(pHudState, pHudData)
  pHudState = pHudState or 'finished'
  pHudData = pHudData or '{}'
  SendNUIMessage({
    openSection = "racing:hud:update",
    hudState = pHudState,
    hudData = pHudData
  })
end

function RunRace(identifier)
  local map = currentRaces[identifier].map
  local laps = currentRaces[identifier].laps
  local counter = currentRaces[identifier].counter
  local sprint = false

  if laps == 0 then
      laps = 1
      sprint = true
  end
  local myLap = 0

  local checkpoints = #customMaps[map]["checkpoints"]
  local mycheckpoint = 1
  local ped = GetPlayerPed(-1)

  SetBlipColour(SetBlips[1], 3)
  SetBlipScale(SetBlips[1], 1.6)

  TriggerEvent("DoLongHudText","Race Starts in 3",14)
  PlaySound(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
  Citizen.Wait(1000)
  TriggerEvent("DoLongHudText","Race Starts in 2",14)
  PlaySound(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
  Citizen.Wait(1000)
  TriggerEvent("DoLongHudText","Race Starts in 1",14)
  PlaySound(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
  Citizen.Wait(1000)
  PlaySound(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
  TriggerEvent("DoLongHudText","GO!",14)
  hudUpdate("start",
            {isSprint = sprint, maxLaps = laps, maxCheckpoints = checkpoints})
  while myLap < laps + 1 and racing do
      Wait(1)
      local plyCoords = GetEntityCoords(ped)

      if (Vdist(customMaps[map]["checkpoints"][mycheckpoint]["x"],customMaps[map]["checkpoints"][mycheckpoint]["y"], customMaps[map]["checkpoints"][mycheckpoint]["z"],plyCoords.x, plyCoords.y, plyCoords.z)) < customMaps[map]["checkpoints"][mycheckpoint]["dist"] then
          SetBlipColour(SetBlips[mycheckpoint], 3)
          SetBlipScale(SetBlips[mycheckpoint], 1.0)

          -- PlaySound(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
          mycheckpoint = mycheckpoint + 1

          SetBlipColour(SetBlips[mycheckpoint], 2)
          SetBlipScale(SetBlips[mycheckpoint], 1.6)
          SetBlipAsShortRange(SetBlips[mycheckpoint - 1], true)
          SetBlipAsShortRange(SetBlips[mycheckpoint], false)

          if mycheckpoint > checkpoints then mycheckpoint = 1 end

          SetNewWaypoint(customMaps[map]["checkpoints"][mycheckpoint]["x"],
                         customMaps[map]["checkpoints"][mycheckpoint]["y"])

          if not sprint and mycheckpoint == 1 then
              SetBlipColour(SetBlips[1], 2)
              SetBlipScale(SetBlips[1], 1.6)
          end

          if not sprint and mycheckpoint == 2 then
              myLap = myLap + 1
              SetBlipColour(SetBlips[1], 3)
              SetBlipScale(SetBlips[1], 1.0)
              SetBlipColour(SetBlips[2], 2)
              SetBlipScale(SetBlips[2], 1.6)
          elseif sprint and mycheckpoint == 1 then
              myLap = myLap + 2
          end

          hudUpdate("update",
                    {curLap = myLap, curCheckpoint = (mycheckpoint - 1)})
      end
  end

  hudUpdate("finished", {eventId = identifier})

  PlaySound(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
  TriggerEvent("DoLongHudText","You have finished!",1)
  Wait(10000)
  racing = false
  hudUpdate("clear")
  ClearBlips()
  RemoveCheckpoints()
end

function EndRace()
  ClearBlips()
  RemoveCheckpoints()
end

function RemoveCheckpoints()
  for i = 1, #checkpointMarkers do
      SetEntityAsNoLongerNeeded(checkpointMarkers[i].left)
      DeleteObject(checkpointMarkers[i].left)
      SetEntityAsNoLongerNeeded(checkpointMarkers[i].right)
      DeleteObject(checkpointMarkers[i].right)
      checkpointMarkers[i] = nil
  end
end

function FUCKK(num)
  local new = math.ceil(num*100)
  new = new / 100
  return new
end

function SaveMap(name,description)
  -- get distance here between checkpoints

  local distanceMap = 0.0
  for i = 1, #currentMap do
    if i == #currentMap then
      distanceMap = Vdist(currentMap[i]["x"],currentMap[i]["y"],currentMap[i]["z"], currentMap[1]["x"],currentMap[1]["y"],currentMap[1]["z"]) + distanceMap
    else
      distanceMap = Vdist(currentMap[i]["x"],currentMap[i]["y"],currentMap[i]["z"], currentMap[i+1]["x"],currentMap[i+1]["y"],currentMap[i+1]["z"]) + distanceMap
    end
  end
  distanceMap = math.ceil(distanceMap)

  if #currentMap > 1 then
    TriggerEvent("DoLongHudText","The map is being processed and should be available shortly.",2)
    TriggerServerEvent("racing-save-map", currentMap, name, description, distanceMap)
  else
    TriggerEvent("DoLongHudText","Failed due to lack of checkpoints",2)
  end
  currentMap = {}
  creatingMap = false
end

RegisterNUICallback('racing:events:list', function()
  local rank = exports["isPed"]:GroupRank("ug_racing")
  if exports["warp-inventory"]:hasEnoughOfItem("racingusb2",1,false) then
  SendNUIMessage({
    openSection = "racing:events:list",
      races = currentRaces,
      canMakeMap = (rank >= 4 and true or false)
    });
   TriggerServerEvent("racing-retreive-maps")
   else
      TriggerEvent("DoLongHudText", "You need a dongle.", 2)
  end
end)

RegisterNUICallback('racing:events:highscore', function()
  TriggerServerEvent("racing-retreive-maps")
  Wait(300)
  local highScoreObject = {}
  for k,v in pairs(customMaps) do
    highScoreObject[k] = {
      fastestLap = v.fastest_lap,
      fastestName = v.fastest_name,
      fastestSprint = v.fastest_sprint,
      fastestSprintName = v.fastest_sprint_name,
      map = v.track_name,
      noOfRaces = v.races,
      mapDistance = v.distance
    }
  end

  SendNUIMessage({
    openSection = "racing:events:highscore",
    highScoreList = highScoreObject
  });
end)

-- Callback when setting up new Event
RegisterNUICallback('racing:event:setup', function()
  TriggerServerEvent("racing-build-maps")
end)

-- Fix
RegisterNUICallback('racing:event:leave', function()
  hudUpdate('clear')
  ClearBlips()
  RemoveCheckpoints()
  racing = false
end)

-- Fix
RegisterNUICallback('racing:event:join', function(data)
  RemoveCheckpoints()
  local id = data.identifier
  local ped = GetPlayerPed(-1)
  local IsPlayerDriver = GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1)), -1) == GetPlayerPed(-1)
  local plyCoords = GetEntityCoords(ped)

  if not IsPlayerDriver then
      TriggerEvent("DoLongHudText","You must be the driver of the vehicle to join this race.",2)
      return
  end

  local mapCheckpoints = customMaps[currentRaces[id]["map"]]["checkpoints"]
  local checkPointIndex = 1
  if currentRaces[id]["reverseTrack"] and currentRaces[id]["laps"] == 0 then
      checkPointIndex = #mapCheckpoints
  end

  if Vdist(mapCheckpoints[checkPointIndex]["x"],mapCheckpoints[checkPointIndex]["y"],mapCheckpoints[checkPointIndex]["z"], plyCoords.x, plyCoords.y,plyCoords.z) < 40 then
      -- IF the race is OPEN and you are not in the race and youre not racing
      if currentRaces[id]["open"] and not JoinedRaces[id] and not racing then
          racing = true
          JoinedRaces[id] = true
          TriggerServerEvent("racing-join-race", id)
          hudUpdate('starting')
          ShowText("Joining Race!")
          LoadMapBlips(currentRaces[id]["map"],currentRaces[id]["reverseTrack"],currentRaces[id]["laps"])
      else
          -- IF youre in this race and youre not racing
          if (JoinedRaces[id] and not racing) then
              racing = true
              hudUpdate('starting')
          else
              ShowText("This race is closed or you are already in it!")
          end
      end
  else
      ShowText("You are too far away!")
  end
end)

-- Fix
RegisterNUICallback('racing:event:start', function(data)
  StartEvent(data.raceMap, data.raceLaps, data.raceCountdown, data.reverseTrack, data.raceName, data.raceStartTime, data.mapCreator, data.mapDistance, data.mapDescription)
  Wait(500)
  SendNUIMessage({openSection = "racing:events:list", races = currentRaces});
end)

-- Fix this
RegisterNUICallback('race:completed', function(data)
  JoinedRaces[data.identifier] = nil
  TriggerServerEvent("race:completed2",data.fastestlap, data.overall, data.sprint, data.identifier)
  EndRace()
end)

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

-- Racing:Map
RegisterNUICallback('racing:map:create', function()
  StartMapCreation()
end)

RegisterNUICallback('racing:map:load', function(data)
  ClearBlips()
  RemoveCheckpoints()
  if(data.id ~= nil) then
    LoadMapBlips(data.id)
  end
end)

RegisterNUICallback('racing:map:delete', function(data)
  ClearBlips()
  RemoveCheckpoints()
  if data.id ~= "0" then
    TriggerServerEvent("racing-map-delete",customMaps[tonumber(data.id)]["dbid"])
  end
end)

RegisterNUICallback('racing:map:removeBlips', function()
  EndRace()
end)

RegisterNUICallback('racing:map:cancel', function()
  EndRace()
  CancelMap()
end)

RegisterNUICallback('racing:map:save', function(data)
  EndRace()
  SaveMap(data.name,data.desc)
end)

RegisterNetEvent('racing:data:set')
AddEventHandler('racing:data:set', function(data)
  if(data.event == "map") then
    if (data.eventId ~= -1) then
      customMaps[data.eventId] = data.data
    else
      customMaps = data.data
      if(data.subEvent == nil or data.subEvent ~= "noNUI") then
        SendNUIMessage({
          openSection = 'racing-start',
          maps = customMaps
        })
      end
    end
  elseif (data.event == "event") then
    if (data.eventId ~= -1) then
      currentRaces[data.eventId] = data.data
      if JoinedRaces[data.eventId] and racing and data.subEvent == "close" then
        RunRace(data.eventId)
      end
      SendNUIMessage({
        openSection = "racing:event:update",
        eventId = data.eventId,
        raceData = currentRaces[data.eventId]
      })
    else
      currentRaces = data.data
      SendNUIMessage({
        openSection = "racing:event:update",
        raceData = currentRaces
      })
    end
  end
end)

RegisterNetEvent('racing:clearFinishedRaces')
AddEventHandler('racing:clearFinishedRaces', function(id)
  if(JoinedRaces[id] ~= nil) then
    JoinedRaces[id] = nil
    ClearBlips()
    RemoveCheckpoints()
  end
end)

-- Opens our phone
RegisterNetEvent('phoneGui2')
AddEventHandler('phoneGui2', function()
  openGui()
end)

-- NUI Callback Methods
RegisterNUICallback('close', function(data, cb)
  closeGui()
  cb('ok')
end)

RegisterNetEvent('phone:close')
AddEventHandler('phone:close', function(number, message)
  closeGui()

end)

-- SMS Callbacks
RegisterNUICallback('messages', function(data, cb)
  print("messages, main lua")
  local cid = exports['isPed']:isPed('cid')
  local messages, mynumber = RPC.execute("phone:getMessages", cid)

  lstMsgs = {}
  if (#messages ~= 0) then
    for k,v in pairs(messages) do
      if v ~= nil then
        local msgDisplayName = ""
        if tonumber(v.receiver) == tonumber(mynumber) then
          msgDisplayName = getContactName(v.sender)
        else
          msgDisplayName = getContactName(v.receiver)
        end
        local message = {
          id = tonumber(v.id),
          msgDisplayName = msgDisplayName,
          sender = tonumber(v.sender),
          receiver = tonumber(v.receiver),
          date = v.date,
          message = v.message
        }
        lstMsgs[#lstMsgs+1]= message
      end
    end
  end
  SendNUIMessage({openSection = "messagesnew", list = lstMsgs, clientNumber = mynumber})
  cb('ok')
end)

RegisterNetEvent('phone:clientGetMessagesBetweenParties')
AddEventHandler('phone:clientGetMessagesBetweenParties', function(messages, displayName, clientNumber)
  SendNUIMessage({openSection = "messageRead", messages = messages, displayName = displayName, clientNumber = clientNumber})
end)

--$.post...
RegisterNUICallback('messageRead', function(data, cb)
  TriggerServerEvent('phone:serverGetMessagesBetweenParties', data.sender, data.receiver, data.displayName)
  cb('ok')
end)

RegisterNUICallback('messageDelete', function(data, cb)
  TriggerServerEvent('phone:removeSMS', data.id, data.number)
  cb('ok')
end)

RegisterNUICallback('newMessage', function(data, cb)
  SendNUIMessage({openSection = "newMessage"})
  cb('ok')
end)





RegisterNUICallback('messageReply', function(data, cb)
  SendNUIMessage({openSection = "newMessageReply", number = data.number})
  cb('ok')
end)

RegisterNUICallback('newMessageSubmit', function(data, cb)
  if not isDead then
    TriggerEvent('phone:sendSMS', tonumber(data.number), data.message, data.sender, data.receiver, data.displayname)
    cb('ok')
  else
    TriggerEvent("DoLongHudText","You can not do this while injured.",2)
  end
end)


function testfunc()

end
RegisterNetEvent("TokoVoip:UpVolume");
AddEventHandler("TokoVoip:UpVolume", setVolumeUp);

RegisterNetEvent('refreshContacts')
AddEventHandler('refreshContacts', function()
  TriggerServerEvent('getContacts', exports['isPed']:isPed('cid'))
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

RegisterNetEvent('refreshSMS')
AddEventHandler('refreshSMS', function()
  TriggerServerEvent('phone:getSMS', exports['isPed']:isPed('cid'))
  Citizen.Wait(250)
  SendNUIMessage({openSection = "messages"})
end)

RegisterNUICallback('contactsnew', function(data, cb)
  local cid = exports["isPed"]:isPed("cid")
  local contactarray = RPC.execute("phone:getContacts", cid)
  allcontacts = {}

  if contactarray == nil then SendNUIMessage({openSection = "contactsnew", contacts = allcontacts}) return end 

  for i = 1, #contactarray do
    allcontacts[#allcontacts + 1] = {
        id = tonumber(i),
        cid = contactarray[tonumber(i)].identifier,
        name = contactarray[tonumber(i)].name,
        number = contactarray[tonumber(i)].number
      }
  end
  SendNUIMessage({openSection = "contactsnew", contacts = allcontacts})
  cb('ok')
end)

RegisterNUICallback('addNewContactModal', function(data)
  SendNUIMessage({openSection = "addNewContactModal"})
end)

RegisterNUICallback('addContactPhone', function(data)
  local cid = exports["isPed"]:isPed("cid")
  local result = RPC.execute("phone:addNewContact", cid, data.name, data.number)
  if not result then return end

  local contactarray = RPC.execute("phone:getContacts", cid)
  allcontacts = {}

  if contactarray == nil then SendNUIMessage({openSection = "contactsnew", contacts = allcontacts}) return end 

  for i = 1, #contactarray do
    allcontacts[#allcontacts + 1] = {
        id = tonumber(i),
        cid = contactarray[tonumber(i)].identifier,
        name = contactarray[tonumber(i)].name,
        number = contactarray[tonumber(i)].number
      }
  end

  SendNUIMessage({openSection = "contactsnew", contacts = allcontacts})
end)

RegisterNUICallback('removeContactPhone', function(data)
  local cid = exports["isPed"]:isPed("cid")
  local result = RPC.execute("phone:removeContact", cid, data.name, data.number)
  if not result then return end

  local contactarray = RPC.execute("phone:getContacts", cid)
  allcontacts = {}

  if contactarray == nil then SendNUIMessage({openSection = "contactsnew", contacts = allcontacts}) return end 

  for i = 1, #contactarray do
    allcontacts[#allcontacts + 1] = {
        id = tonumber(i),
        cid = contactarray[tonumber(i)].identifier,
        name = contactarray[tonumber(i)].name,
        number = contactarray[tonumber(i)].number
      }
  end

  SendNUIMessage({openSection = "contactsnew", contacts = allcontacts})
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

RegisterNUICallback('removeContact', function(data, cb)
  TriggerServerEvent('phone:removeContact', data.name, data.number)
  cb('ok')
end)

RegisterNUICallback('createRole', function(data, cb)
  SendNUIMessage({openSection = "createrole", bizid = data.businessid})
end)

RegisterNUICallback('hireEmployee', function(data, cb)
  local roles = RPC.execute("warp-business:business:GetBusinessRoles", data.businessid)

  local allroles = {}

  for i = 1, #roles do
    allroles[#allroles + 1] = {
        id = tonumber(i),
        role = roles[tonumber(i)].rolename
      }
  end
  SendNUIMessage({openSection = "hireEmployeeModal", bizid = data.businessid, roles = allroles})
end)

RegisterNUICallback('editRole', function(data, cb)
  local perm_hire, perm_fire, perm_changeroles, perm_keys, perm_stash, perm_craft = RPC.execute("warp-business:business:GetRole", data.businessid, data.role)

  SendNUIMessage({openSection = "editroleModal", biz_id = data.businessid, biz_role = data.role, can_hire = perm_hire, can_fire = perm_fire, can_changeroles = perm_changeroles, has_keys = perm_keys, has_stash = perm_stash, can_craft = perm_craft})
end)

RegisterNUICallback('createRoleBusiness', function(data, cb)
  if data == nil then return end
  
  local doesExist = RPC.execute("warp-business:business:checkRoleExistance", data.businessid, data.newrole)

  if doesExist then return TriggerEvent("DoLongHudText", "Role name already exists!", 2) end

  local perm_fire, perm_hire, perm_changeroles, perm_keys, perm_stash, perm_craft

  if data.fire == "on" then
    perm_fire = 1
  else
    perm_fire = 0
  end

  if data.hire == "on" then
    perm_hire = 1
  else
    perm_hire = 0
  end

  if data.changeroles == "on" then
    perm_changeroles = 1
  else
    perm_changeroles = 0
  end

  if data.keys == "on" then
    perm_keys = 1
  else
    perm_keys = 0
  end

  if data.stash == "on" then
    perm_stash = 1
  else
    perm_stash = 0
  end

  if data.craft == "on" then
    perm_craft = 1
  else
    perm_craft = 0
  end

  local result = RPC.execute("warp-business:business:createRole", data.businessid, data.newrole, perm_fire, perm_hire, perm_changeroles, perm_keys, perm_stash, perm_stash, perm_craft)
  if not result then return TriggerEvent("DoLongHudText", "Error", 2) end
  -- replace with success modal instead.
  -- update manage business also, so no old roles stay
  SendNUIMessage({openSection = "closemodals"})
end)

function firstToUpper(str)
  return (str:gsub("^%l", string.upper))
end

RegisterNUICallback('editRoleBusiness', function(data, cb)
  if data == nil then return end

  local roles = RPC.execute("warp-business:business:GetBusinessRoles", data.businessid)

  local current_role = firstToUpper(data.cur_role)
  local new_role = firstToUpper(data.rolename)
  if tostring(current_role) == "Owner" then return TriggerEvent("DoLongHudText", "Can't edit Owner role.", 2) end

  if tostring(current_role) ~= tostring(new_role) then
  local doesExist = RPC.execute("warp-business:business:checkRoleExistance", data.businessid, data.rolename)
  if doesExist then return TriggerEvent("DoLongHudText", "Role name already exists.", 2) end
  end

  -- Check if they have over role limit (8)

  local perm_fire, perm_hire, perm_changeroles, perm_keys, perm_stash, perm_craft

  if data.fire == true then
    perm_fire = 1
  else
    perm_fire = 0
  end

  if data.hire == true then
    perm_hire = 1
  else
    perm_hire = 0
  end

  if data.changeroles == true then
    perm_changeroles = 1
  else
    perm_changeroles = 0
  end

  if data.keys == true then
    perm_keys = 1
  else
    perm_keys = 0
  end

  if data.stash == true then
    perm_stash = 1
  else
    perm_stash = 0
  end

  if data.craft == true then
    perm_craft = 1
  else
    perm_craft = 0
  end

  local result = RPC.execute("warp-business:business:editRole", data.businessid, data.cur_role, data.rolename, perm_fire, perm_hire, perm_changeroles, perm_keys, perm_stash, perm_stash, perm_craft)
  if not result then return TriggerEvent("DoLongHudText", "Error", 2) end
  -- replace with success modal instead.
  -- update manage business also, so no old roles stay

  local allroles = {}

  for i = 1, #roles do
    allroles[#allroles + 1] = {
        id = tonumber(i),
        role = roles[tonumber(i)].rolename
      }
  end

  SendNUIMessage({openSection = "editbusiness", business_id = data.businessid, businessroles = allroles})
end)

RegisterNUICallback('deleteRoleBusiness', function(data, cb)
  if data == nil then return end


  local role = firstToUpper(data.role)
  if tostring(role) == "Owner" then return TriggerEvent("DoLongHudText", "Can't delete Owner role.", 2) end

  local result = RPC.execute("warp-business:business:deleteRole", data.businessid, data.role)
  if not result then return TriggerEvent("DoLongHudText", "Error", 2) end
  -- replace with success modal instead.
  -- update manage business also, so no old roles stay

  local allroles = {}

  for i = 1, #roles do
    allroles[#allroles + 1] = {
        id = tonumber(i),
        role = roles[tonumber(i)].rolename
      }
  end

  SendNUIMessage({openSection = "editbusiness", business_id = data.businessid, businessroles = allroles})
end)

RegisterNUICallback('optionsModal', function(data, cb)
  SendNUIMessage({openSection = "openoptionmodal", bizid = data.businessid})
end)

RegisterNUICallback('sendMoneySendifyModal', function(data, cb)
  SendNUIMessage({openSection = "sendMoneySendifyModal"})
end)

RegisterNUICallback('sendifySendPayment', function(data, cb)
  -- success modal if success, or error if error.
  local cid = exports['isPed']:isPed('cid')
  local result = RPC.execute("phone:sendSendifyPayment", cid, data.cid, data.amount)
  print(result)
  if result == "success" then
    SendNUIMessage({openSection = "refreshSendify"})
    print("success")
  elseif result == "notenough" then
    -- show not enough error
    print("not enough")
    return
  elseif result == "invalid" then
    -- show invalid cid error
    print("invalid cid")
    return
  elseif result == "error" then
    -- show general error
    print("general error")
    return
  end
  -- show success modal

end)

RegisterNUICallback('updateEmployeeBusiness', function(data, cb)
  if data == nil then return end
  local result = RPC.execute("warp-business:business:updateEmployee", data.cid, data.businessid, data.newrole)
  if not result then return TriggerEvent("DoLongHudText", "Error", 2) end

  -- Go Manage Business, and close modal in manageBusiness

  local business = RPC.execute("warp-business:business:GetBusiness", data.businessid)
  local owner = RPC.execute("warp-business:business:GetOwner", data.businessid)

  if business == nil then local employed = {} SendNUIMessage({openSection = "managebusiness", curbusiness = employed}) return end

  local employment = {}

  for i = 1, #business do
    local myIcon = "fa-user-tie"
    if tostring(business[tonumber(i)].role) == "Owner" then
      myIcon = "fa-user-secret"
    end

    employment[#employment + 1] = {
        id = tonumber(i),
        businessid = business[tonumber(i)].business_id,
        businessname = business[tonumber(i)].business_name,
        businessrole = business[tonumber(i)].role,
        first_name = business[tonumber(i)].first_name,
        last_name = business[tonumber(i)].last_name,
        icon = myIcon,
        cid = business[tonumber(i)].cid
      }
  end
  local cid = exports['isPed']:isPed('cid')
  if tonumber(owner) == tonumber(cid) then
  SendNUIMessage({openSection = "managebusiness", curbusiness = employment, biz_id = data.businessid})
  else
  TriggerEvent("DoLongHudText", "Only owner can manage business!", 2)
  end

end)

RegisterNUICallback('hireEmployeeBusiness', function(data, cb)
  if data == nil then return end
  local result = RPC.execute("warp-business:business:hireEmployee", data.cid, data.role, data.businessid)
  if not result then return TriggerEvent("DoLongHudText", "Error", 2) end

  local business = RPC.execute("warp-business:business:GetBusiness", data.businessid)
  local owner = RPC.execute("warp-business:business:GetOwner", data.businessid)

  if business == nil then local employed = {} SendNUIMessage({openSection = "managebusiness", curbusiness = employed}) return end

  local employment = {}

  for i = 1, #business do
    local myIcon = "fa-user-tie"
    if tostring(business[tonumber(i)].role) == "Owner" then
      myIcon = "fa-user-secret"
    end

    employment[#employment + 1] = {
        id = tonumber(i),
        businessid = business[tonumber(i)].business_id,
        businessname = business[tonumber(i)].business_name,
        businessrole = business[tonumber(i)].role,
        first_name = business[tonumber(i)].first_name,
        last_name = business[tonumber(i)].last_name,
        icon = myIcon,
        cid = business[tonumber(i)].cid
      }
  end
  local cid = exports['isPed']:isPed('cid')
  SendNUIMessage({openSection = "managebusiness", curbusiness = employment, biz_id = data.businessid})
  

end)

RegisterNUICallback('fireEmployeeBusiness', function(data, cb)
  if data == nil then return end
  local result = RPC.execute("warp-business:business:fireEmployee", data.cid, data.businessid)
  if not result then return TriggerEvent("DoLongHudText", "Error", 2) end

  -- Go Manage Business, and close modal in manageBusiness

  local business = RPC.execute("warp-business:business:GetBusiness", data.businessid)
  local owner = RPC.execute("warp-business:business:GetOwner", data.businessid)

  if business == nil then local employed = {} SendNUIMessage({openSection = "managebusiness", curbusiness = employed}) return end

  local employment = {}

  for i = 1, #business do
    local myIcon = "fa-user-tie"
    if tostring(business[tonumber(i)].role) == "Owner" then
      myIcon = "fa-user-secret"
    end

    employment[#employment + 1] = {
        id = tonumber(i),
        businessid = business[tonumber(i)].business_id,
        businessname = business[tonumber(i)].business_name,
        businessrole = business[tonumber(i)].role,
        first_name = business[tonumber(i)].first_name,
        last_name = business[tonumber(i)].last_name,
        icon = myIcon,
        cid = business[tonumber(i)].cid
      }
  end
  local cid = exports['isPed']:isPed('cid')
  SendNUIMessage({openSection = "managebusiness", curbusiness = employment, biz_id = data.businessid})
end)

RegisterNUICallback('manageUser', function(data, cb)
  local role, firstname, lastname = RPC.execute("warp-business:business:GetEmploymentInformationBusinessID", data.cid, data.businessid)
  local roles = RPC.execute("warp-business:business:GetBusinessRoles", data.businessid)

  local allroles = {}

  for i = 1, #roles do
    allroles[#allroles + 1] = {
        id = tonumber(i),
        role = roles[tonumber(i)].rolename
      }
  end


  if tonumber(data.cid) == tonumber(exports['isPed']:isPed('cid')) then TriggerEvent("DoLongHudText", "You can't edit yourself!", 2) return end


  SendNUIMessage({openSection = "manageuser", curusercid = data.cid, businessid = data.businessid, curuserrole = role, curuserfirstname = firstname, curuserlastname = lastname, roles = allroles})
end)

RegisterNUICallback('editBusiness', function(data, cb)

  local business = RPC.execute("warp-business:business:GetBusiness", data.businessid)
  local owner = RPC.execute("warp-business:business:GetOwner", data.businessid)
  local roles = RPC.execute("warp-business:business:GetBusinessRoles", data.businessid)

  if business == nil then return end

  local allroles = {}

  for i = 1, #roles do
    allroles[#allroles + 1] = {
        id = tonumber(i),
        role = roles[tonumber(i)].rolename
      }
  end

  SendNUIMessage({openSection = "editbusiness", business_id = data.businessid, businessroles = allroles})

  cb('ok')
end)

RegisterNUICallback('manageBusiness', function(data, cb)

  local business = RPC.execute("warp-business:business:GetBusiness", data.businessid)
  local owner = RPC.execute("warp-business:business:GetOwner", data.businessid)

  if business == nil then local employed = {} SendNUIMessage({openSection = "managebusiness", curbusiness = employed}) return end

  local employment = {}

  for i = 1, #business do
    local myIcon = "fa-user-tie"
    if tostring(business[tonumber(i)].role) == "Owner" then
      myIcon = "fa-user-secret"
    end

    employment[#employment + 1] = {
        id = tonumber(i),
        businessid = business[tonumber(i)].business_id,
        businessname = business[tonumber(i)].business_name,
        businessrole = business[tonumber(i)].role,
        first_name = business[tonumber(i)].first_name,
        last_name = business[tonumber(i)].last_name,
        icon = myIcon,
        cid = business[tonumber(i)].cid
      }
  end
  local cid = exports['isPed']:isPed('cid')
  if tonumber(owner) == tonumber(cid) then
  SendNUIMessage({openSection = "managebusiness", curbusiness = employment, biz_id = data.businessid})
  else
    TriggerEvent("DoLongHudText", "Only owner can manage business!", 2)
  end

  cb('ok')
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

RegisterNUICallback('checkWifi', function(data, cb)
  SendNUIMessage({openSection = "wifiModal"})
  cb('ok')
end)

RegisterNUICallback('connectWifi', function(data, cb)
  hiddenapp = true
  SendNUIMessage({showHiddenApp = true, closeModal = true})
  cb('ok')
end)

RegisterNUICallback('exchangeGuineaModal', function(data, cb)
  SendNUIMessage({openSection = "crypto:exchangeGuinea"})
  cb('ok')
end)

function exchangeGuinea(data)
  if data.gneamount ~= nil then
    local gneamount = data.gneamount
    local receiver = data.gnephone_number
    local cid = exports["isPed"]:isPed("cid")
    local shungiteamount, guineaamount = RPC.execute("phone:getCryptoBalance", cid)
    local gnesendamount = tonumber(gneamount)
    local gnetotal = tonumber(guineaamount)
    if gnesendamount >= gnetotal then
      return "notenough"
    end
    local result = RPC.execute("phone:exchangeGuinea", cid, gneamount, receiver)
    if result == "success" then
      return "success"
    else
      return "error"
    end
  end
end

RegisterNUICallback('exchangeGuinea', function(data, cb)
  local result = exchangeGuinea(data)
  if result == "success" then
    local cid = exports["isPed"]:isPed("cid")
    local shungiteamount, guineaamount = RPC.execute("phone:getCryptoBalance", cid)
    SendNUIMessage({openSection = "crypto:exchangeGuineaSuccessModal", shungite = shungiteamount, guinea = guineaamount})
  elseif result == "notenough" then
    SendNUIMessage({openSection = "crypto:exchangeGuineaErrorModal"})
  end
  cb('ok')
end)

RegisterNUICallback('exchangeShungiteModal', function(data, cb)
  SendNUIMessage({openSection = "crypto:exchangeShungite"})
  cb('ok')
end)

function exchangeShungite(data)
  if data.amount ~= nil then
    local shungamount = data.amount
    local receiver = data.phone_number
    local cid = exports["isPed"]:isPed("cid")
    local shungiteamount, guineaamount = RPC.execute("phone:getCryptoBalance", cid)
    local shungsendamount = tonumber(shungamount)
    local shungtotal = tonumber(shungiteamount)
    if shungsendamount >= shungtotal then
      return "notenough"
    end
    local result = RPC.execute("phone:exchangeShungite", cid, shungamount, receiver)
    if result == "success" then
      return "success"
    else
      return "error"
    end
  end
end

RegisterNUICallback('exchangeShungite', function(data, cb)
  local result = exchangeShungite(data)
  if result == "success" then
    local cid = exports["isPed"]:isPed("cid")
    local shungiteamount, guineaamount = RPC.execute("phone:getCryptoBalance", cid)
    SendNUIMessage({openSection = "crypto:exchangeShungiteSuccessModal", shungite = shungiteamount, guinea = guineaamount})
  elseif result == "notenough" then
    SendNUIMessage({openSection = "crypto:exchangeShungiteErrorModal"})
  end
  cb('ok')
end)

RegisterNUICallback('buyCryptoModal', function(data, cb)
  SendNUIMessage({openSection = "crypto:buyCryptoModal", cryptoid = data.cryptoid})
  cb('ok')
end)

RegisterNUICallback('exchangeCryptoModal', function(data, cb)
  SendNUIMessage({openSection = "crypto:exchangeCryptoModal", cryptoid = data.cryptoid})
  cb('ok')
end)

RegisterNUICallback('sellCryptoModal', function(data, cb)
  SendNUIMessage({openSection = "crypto:sellCryptoModal", cryptoid = data.cryptoid})
  cb('ok')
end)

function buyShungite(data)
  if data.amount ~= nil then
    local total = data.amount * 100
    local shungamount = data.amount
    local bank = exports["isPed"]:isPed("mybank")
    local cid = exports["isPed"]:isPed("cid")

    if total >= bank then
      return "notenough"
    end

    local result = RPC.execute("phone:buyShungite", cid, shungamount, total)
    if result == "success" then
    return "success"
    else
      return "error"
    end
  end
end

function buyCrypto(data)
  if data.amount ~= nil then
    local price = RPC.execute("phone:getCryptoValue", data.cryptoid)
    local total = tonumber(data.amount) * tonumber(price)
    local amount = data.amount
    local bank = exports["isPed"]:isPed("mybank")
    local cid = exports["isPed"]:isPed("cid")

    if total >= bank then
      return "notenough"
    end

    local result = RPC.execute("phone:buyCrypto", cid, amount, total, data.cryptoid)
    if result == "success" then
    return "success"
    else
      return "error"
    end
  end
end

function exchangeCrypto(data)
  print(data.amount, data.phone_number, data.cryptoid)
  if data.amount ~= nil then
    local amount = data.amount
    local receiver = data.phone_number
    local cid = exports["isPed"]:isPed("cid")
    local cryptoamount = RPC.execute("phone:getCryptoBalance", cid, data.cryptoid)
    if tonumber(amount) > tonumber(cryptoamount) then
      return "notenough"
    end
    local result = RPC.execute("phone:exchangeCrypto", cid, amount, receiver, data.cryptoid)
    if result == "success" then
      return "success"
    else
      return "error"
    end
  end
end

function sellCrypto(data)
  if data.amount ~= nil then
    local price = RPC.execute("phone:getCryptoValue", data.cryptoid)
    local total = tonumber(data.amount) * tonumber(price)
    local amount = data.amount
    local bank = exports["isPed"]:isPed("mybank")
    local cid = exports["isPed"]:isPed("cid")
    local cryptoamount = RPC.execute("phone:getCryptoBalance", cid, data.cryptoid)

    if tonumber(amount) > tonumber(cryptoamount) then
      return "notenough"
    end

    local result = RPC.execute("phone:sellCrypto", cid, amount, total, data.cryptoid)
    if result == "success" then
    return "success"
    else
      return "error"
    end
  end
end

RegisterNUICallback('exchangeCrypto', function(data, cb)
  local result = exchangeCrypto(data)
  if result == "success" then
    local cid = exports["isPed"]:isPed("cid")
    local cryptoarray = RPC.execute("phone:getCryptos")
    local name = RPC.execute("phone:getCryptoNameFromID", data.cryptoid)
    allcryptos = {}
  
    for i = 1, #cryptoarray do
  
      local cryptoamount = RPC.execute("phone:getCryptoBalance", cid, cryptoarray[tonumber(i)].cryptoid)
      if cryptoamount == nil then
        RPC.execute("phone:generateWallet", cid, cryptoarray[tonumber(i)].cryptoid)
      end
  
      allcryptos[#allcryptos + 1] = {
          id = cryptoarray[tonumber(i)].cryptoid,
          name = cryptoarray[tonumber(i)].cryptoname,
          tag = cryptoarray[tonumber(i)].cryptotag,
          icon = cryptoarray[tonumber(i)].cryptoicon,
          canbuy = cryptoarray[tonumber(i)].buyable,
          canexchange = cryptoarray[tonumber(i)].exchangeable,
          cansell = cryptoarray[tonumber(i)].sellable,
          value = cryptoarray[tonumber(i)].value,
          amount = cryptoamount
        }
    end
    SendNUIMessage({openSection = "crypto:exchangeCryptoSuccessModal", cryptos = allcryptos, cryptoname = name}) --give crypto data here
    --SendNUIMessage({openSection = "crypto:exchangeShungiteSuccessModal", shungite = shungiteamount, guinea = guineaamount})
  elseif result == "notenough" then
    local name = RPC.execute("phone:getCryptoNameFromID", data.cryptoid)
    SendNUIMessage({openSection = "crypto:exchangeCryptoErrorModal", cryptoname = name})
  end
  cb('ok')
end)

RegisterNUICallback('buyShungite', function(data, cb)
  local result = buyShungite(data)
  if result == "success" then
    local cid = exports["isPed"]:isPed("cid")
    local shungiteamount, guineaamount = RPC.execute("phone:getCryptoBalance", cid)
    SendNUIMessage({openSection = "crypto:buyShungiteSuccessModal", shungite = shungiteamount, guinea = guineaamount})
  elseif result == "notenough" then
    SendNUIMessage({openSection = "crypto:buyShungiteErrorModal"})
  end
  cb('ok')
end)

RegisterNUICallback('buyCrypto', function(data, cb)
  local result = buyCrypto(data)
  if result == "success" then
    local cid = exports["isPed"]:isPed("cid")
    local cryptoarray = RPC.execute("phone:getCryptos")
    local name = RPC.execute("phone:getCryptoNameFromID", data.cryptoid)
    allcryptos = {}
  
    for i = 1, #cryptoarray do
  
      local cryptoamount = RPC.execute("phone:getCryptoBalance", cid, cryptoarray[tonumber(i)].cryptoid)
      if cryptoamount == nil then
        RPC.execute("phone:generateWallet", cid, cryptoarray[tonumber(i)].cryptoid)
      end
  
      allcryptos[#allcryptos + 1] = {
          id = cryptoarray[tonumber(i)].cryptoid,
          name = cryptoarray[tonumber(i)].cryptoname,
          tag = cryptoarray[tonumber(i)].cryptotag,
          icon = cryptoarray[tonumber(i)].cryptoicon,
          canbuy = cryptoarray[tonumber(i)].buyable,
          canexchange = cryptoarray[tonumber(i)].exchangeable,
          cansell = cryptoarray[tonumber(i)].sellable,
          value = cryptoarray[tonumber(i)].value,
          amount = cryptoamount
        }
    end
    SendNUIMessage({openSection = "crypto:buyCryptoSuccessModal", cryptos = allcryptos, cryptoname = name}) --give crypto data here
  elseif result == "notenough" then
    SendNUIMessage({openSection = "crypto:buyCryptoErrorModal"})
  end
  cb('ok')
end)

RegisterNUICallback('sellCrypto', function(data, cb)
  local result = sellCrypto(data)
  if result == "success" then
    local cid = exports["isPed"]:isPed("cid")
    local cryptoarray = RPC.execute("phone:getCryptos")
    local name = RPC.execute("phone:getCryptoNameFromID", data.cryptoid)
    allcryptos = {}
  
    for i = 1, #cryptoarray do
  
      local cryptoamount = RPC.execute("phone:getCryptoBalance", cid, cryptoarray[tonumber(i)].cryptoid)
      if cryptoamount == nil then
        RPC.execute("phone:generateWallet", cid, cryptoarray[tonumber(i)].cryptoid)
      end
  
      allcryptos[#allcryptos + 1] = {
          id = cryptoarray[tonumber(i)].cryptoid,
          name = cryptoarray[tonumber(i)].cryptoname,
          tag = cryptoarray[tonumber(i)].cryptotag,
          icon = cryptoarray[tonumber(i)].cryptoicon,
          canbuy = cryptoarray[tonumber(i)].buyable,
          canexchange = cryptoarray[tonumber(i)].exchangeable,
          cansell = cryptoarray[tonumber(i)].sellable,
          value = cryptoarray[tonumber(i)].value,
          amount = cryptoamount
        }
    end
    SendNUIMessage({openSection = "crypto:sellCryptoSuccessModal", cryptos = allcryptos, cryptoname = name}) --give crypto data here
  elseif result == "notenough" then
    local name = RPC.execute("phone:getCryptoNameFromID", data.cryptoid)
    SendNUIMessage({openSection = "crypto:sellCryptoErrorModal", cryptoname = name})
  end
  cb('ok')
end)

RegisterNUICallback('setGps', function(data, cb)
  local propertyCoords = RPC.execute("phone:setGps", data.propertyname)
  SetNewWaypoint(propertyCoords.x, propertyCoords.y)
  TriggerEvent("DoLongHudText", "Updated GPS.", 1)
  cb('ok')
end)

function buyProduct(data)
  if data.productid ~= nil then
    local cid = exports["isPed"]:isPed("cid")
    local cryptoamount = RPC.execute("phone:getCryptoBalance", cid, data.cryptoid)


    if tonumber(data.productprice) >= tonumber(cryptoamount) then
      return "notenough"
    end
    local result = RPC.execute("phone:buyProduct", cid, data.productid, data.productprice, data.cryptoid)
    if result == "success" then
    return "success", productdata
    else
      return "error"
    end
  end
end

function addPickUpBlip()
  local pickupLocation = vector3(436.36608886719, 2996.1928710938, 41.283821105957)
  local blip = AddBlipForCoord(pickupLocation)
  SetBlipSprite(blip, 440)
  SetBlipScale(blip, 1.2)
  SetBlipColour(blip, 5)
  SetBlipAsShortRange(blip, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Item Pickup")
  EndTextCommandSetBlipName(blip)
end

RegisterNUICallback('buyDarkmarketProduct', function(data, cb)
  local result = buyProduct(data) -- maybe return message also depending if cryptid is 1 or 2
  if result == "success" then
    -- show success modal shungite here or just dolonghudtext
    addPickUpBlip()
    TriggerEvent("DoLongHudText", "You know where to go", 1)
    SendNUIMessage({openSection = "successboughtproduct"})
    -- Send event to show success here
  elseif result == "notenough" then
    TriggerEvent("DoLongHudText", "Not Enough", 2)
  else
    TriggerEvent("DoLongHudText", "Error", 2)
  end
  cb('ok')
end)

RegisterNUICallback('buyDarkmarketProductModal', function(data, cb)
  SendNUIMessage({ openSection = "confirmPurchaseModal", productdata = data })
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
  TriggerEvent("DoLongHudText","[E] Toggles Call.", 6)


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

    if AnonCall then
       local dPB = #(PhoneBooth - GetEntityCoords( PlayerPedId()))
       if dPB > 2.0 then
        TriggerEvent("DoLongHudText","Moved too far.", 2)
        endCall()
       end
    end



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

RegisterNetEvent('phone:makecall')
AddEventHandler('phone:makecall', function(pnumber)

  local pnumber = tonumber(pnumber)
  AnonCall = false
  if callStatus == isNotInCall and not isDead and hasPhone() then
    local dialingName = getContactName(pnumber)
    TriggerEvent('phone:setCallState', isDialing, dialingName)
    TriggerEvent("animation:phonecallstart")
    recentcalls[#recentcalls + 1] = { ["type"] = 2, ["number"] = pnumber, ["name"] = dialingName }
    TriggerServerEvent('phone:callContact', exports['isPed']:isPed('cid'), pnumber, true)
  else
    TriggerEvent("It appears you are already in a call, injured or with out a phone, please type /hangup to reset your calls.", 2)
  end
end)



local PayPhoneHex = {
  [1] = 1158960338,
  [2] = -78626473,
  [3] = 1281992692,
  [4] = -1058868155,
  [5] = -429560270,
  [6] = -2103798695,
  [7] = 295857659,
  [8] = -1559354806,
}

function checkForPayPhone()
  for i = 1, #PayPhoneHex do
    local objFound = GetClosestObjectOfType( GetEntityCoords(PlayerPedId()), 5.0, PayPhoneHex[i], 0, 0, 0)
    if DoesEntityExist(objFound) then
      return true
    end
  end
  return false
end

RegisterNetEvent('phone:makepayphonecall')
AddEventHandler('phone:makepayphonecall', function(pnumber) 
    if not checkForPayPhone() then
      TriggerEvent("DoLongHudText","You are not near a payphone.",2)
      return
    end

    PhoneBooth = GetEntityCoords( PlayerPedId() )
    AnonCall = true

    local pnumber = tonumber(pnumber)
    if callStatus == isNotInCall and not isDead then
      TriggerEvent('phone:setCallState', isDialing)
      TriggerEvent("animation:phonecallstart")
      TriggerEvent("InteractSound_CL:PlayOnOne","payphonestart",0.5)
      TriggerServerEvent('phone:callContact', exports['isPed']:isPed('cid'), pnumber, false)
      TriggerServerEvent("phone:RemovePayPhoneMoney")
    else
      TriggerEvent("DoLongHudText","It appears you are already in a call, injured or with out a phone, please type /hangup to reset your calls.",2)
    end
end)


RegisterCommand('+usePhone', function()
  -- local isDead = exports["warp-ambulance"]:GetDeath()
  -- if isDead then
  --     TriggerEvent('notification', 'You cannot do that.')
  -- else
      openGuiNow()
      DisableControlAction(0, 199)
end, false)
RegisterCommand('-usePhone', function() end, false)
exports["warp-keybinds"]:registerKeyMapping("", "Phone", "Open", "+usePhone", "-usePhone", "P")



RegisterNetEvent("payphone:ui")
AddEventHandler("payphone:ui", function()
  local ph = exports["warp-applications"]:KeyboardInput({
    header = "Payphone",
    rows = {
      {
        id = 1,
        txt = "Number"
      }
    }
  })
  if ph then
    if ph[1].input ~= nil then
      TriggerEvent("phone:makepayphonecall", ph[1].input)
    end
  end
end)


--[[ The following happens for regular calls too ]]

RegisterNUICallback('callContact', function(data, cb)
  closeGui()
  AnonCall = false
  Wait(1500)
  if callStatus == isNotInCall and not isDead and hasPhone() then
    TriggerEvent('phone:setCallState', isDialing, data.name == "" and data.number or data.name)
    TriggerEvent("animation:phonecallstart")
    TriggerServerEvent('phone:callContact', exports['isPed']:isPed('cid'), data.number, true)
  else
    TriggerEvent("DoLongHudText","It appears you are already in a call, injured or with out a phone, please type /hangup to reset your calls.",2)
  end
  cb('ok')
end)

debugn = false
function t(trace)
end

RegisterNetEvent('phone:failedCall')
AddEventHandler('phone:failedCall', function()
    t("Failed Call")
    endCall()
end)


RegisterNetEvent('phone:hangup')
AddEventHandler('phone:hangup', function(AnonCall)
    if AnonCall then
      t("Call Anon Hangup")
      endCall2()
    else
      t("Call Hangup")
      endCall()
    end
end)

local callid = 0

RegisterNetEvent('phone:hangupcall')
AddEventHandler('phone:hangupcall', function()
    if AnonCall then
      t("Call Anon Hangup 2")
      endCall2()
    else
      t("Call Hangup 2")
      endCall()
    end
end)

RegisterNetEvent('phone:endCalloncommand')
AddEventHandler('phone:endCalloncommand', function()
  TriggerServerEvent('phone:EndCall', mySourceID, callid, true)
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
end)

RegisterNUICallback('btnAnswer', function()
    closeGui()
    TriggerEvent("phone:answercall")
end)
RegisterNUICallback('btnHangup', function()
    closeGui()
    TriggerEvent("phone:hangup")
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
    initiatingCall()
    if not AnonCall then
      TriggerEvent("InteractSound_CL:PlayOnOne","demo",0.1)
    end
end)

RegisterNetEvent('phone:addToCall')
AddEventHandler('phone:addToCall', function(voipchannel)
  exports['warp-voice']:addPlayerToCall(tonumber(voipchannel))
end)

RegisterNetEvent('phone:callFullyInitiated')
AddEventHandler('phone:callFullyInitiated', function(srcID,sentSource)
 TriggerEvent("InteractSound_CL:PlayOnOne","demo",0.1)
  myID = srcID
  mySourceID = sentSource
  local penis = isCallInProgress
  TriggerEvent('phone:setCallState', penis)
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
          TriggerEvent("DoLongHudText","You have put the caller on hold.",1)
          held1 = true
        end
      else
        phoneString = phoneString .. "Call Active | "
        if held1 then
          TriggerEvent("DoLongHudText","Your call is no longer on hold.",1)
          held1 = false
        end
      end

      if mySourceHoldStatus then
        phoneString = phoneString .. "You are on hold"
        if not held2 then
          TriggerEvent("DoLongHudText", "You are on hold.", 2)
          held2 = true
        end
      else
        phoneString = phoneString .. "Caller Active"
        if held2 then
          TriggerEvent("DoLongHudText", "You are no longer on hold.", 1)
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
    if AnonCall and callTimer < 7 then
      TriggerEvent("InteractSound_CL:PlayOnOne","payphoneringing", 0.5)
    elseif not AnonCall then
      TriggerEvent("InteractSound_CL:PlayOnOne","cellcall",0.5)
    end
    
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

function answerCall()
    if mySourceID ~= 0 then
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
  onhold = false
  mySourceHoldStatus = false
  AnonCall = false
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
  AnonCall = false
  callid = 0
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

      TriggerEvent("DoLongHudText","Call on hold", 2)

      onhold = true

    

      TriggerServerEvent("OnHold:Server",mySourceID,true)
    else
      TriggerEvent("DoLongHudText","No longer on hold.", 1)
      TriggerServerEvent("OnHold:Server",mySourceID,false)
      onhold = false

    end
  else

    if mySourceID ~= 0 then
      if not onhold then
        TriggerEvent("DoLongHudText","Call on hold.", 2)
        
        onhold = true


        TriggerServerEvent("OnHold:Server",mySourceID,true)
      else
        TriggerEvent("DoLongHudText","No longer on hold.", 1)
    
        TriggerServerEvent("OnHold:Server",mySourceID,false)
        onhold = false
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

RegisterCommand("testemail", function()
  local cid = exports["isPed"]:isPed("cid")
  local pTime = GetCloudTimeAsInt()
  RPC.execute("phone:addEmail", cid, "Test Department", "Testing Emails", "Testing the email system.", pTime)
end)

curNotifications = {}

RegisterNetEvent('phone:addnotification')
AddEventHandler('phone:addnotification', function(name,message)
    if not guiEnabled then
      SendNUIMessage({
          openSection = "newemail"
      }) 
    end 
    curNotifications[#curNotifications+1] = { ["name"] = name, ["message"] = message }
end)

RegisterNetEvent('YellowPageArray')
AddEventHandler('YellowPageArray', function(pass)
    local notdecoded = json.encode(pass)
    YellowPages = notdecoded

    YellowPageArray = pass
end)

RegisterCommand("testtweet", function(handle, data, time)
  TriggerServerEvent("testtweet", handle, data, time)
end)

local currentTwats = {}

RegisterNetEvent('Client:UpdateTweets')
AddEventHandler('Client:UpdateTweets', function(data)
  SendNUIMessage({openSection = "twatter", twats = data, myhandle = handle})
end)

local currentTwats = {}

RegisterNetEvent('Client:UpdateTweet')
AddEventHandler('Client:UpdateTweet', function(tweet)

    local handle = exports["isPed"]:isPed("twitterhandle")
    currentTwats[#currentTwats+1] = tweet 
    
    if not hasPhone() then
      return
    end


    if currentTwats[#currentTwats]["handle"] == handle then
      SendNUIMessage({openSection = "twatter", twats = currentTwats, myhandle = handle})
    end

--[[     if string.find(currentTwats[#currentTwats]["message"],handle) then
      --
      if currentTwats[#currentTwats]["handle"] ~= handle then
        SendNUIMessage({openSection = "newtweet"})
      end


      if phoneNotifications then
        PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
        TriggerEvent("DoLongHudText","You were just mentioned in a tweet on your phone.",15)
      end
    end ]]

    if allowpopups and not guiEnabled then
      SendNUIMessage({openSection = "notify", handle = currentTwats[#currentTwats]["handle"], message =currentTwats[#currentTwats]["message"]})
    end

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

RegisterNetEvent('phone:triggerHOAAlert')
AddEventHandler('phone:triggerHOAAlert', function(pAlertLocation, pAlertX, pAlertY, pAlertZ)
  local hoaRank = GroupRank("hoa")
  if hoaRank > 0 then
    SendNUIMessage({
      openSection = "hoa-notification",
      alertLocation = pAlertLocation
    })
    createGeneralAreaBlip(pAlertX, pAlertY, pAlertZ)
  end
end)

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
  [14] = { ["x"] = 549.47796630859, ["y"] = -55.197559356689, ["z"] = 71.069190979004, ["info"] = "Garage Impound Lot"},
  [15] = { ["x"] = 364.27685546875, ["y"] = 297.84490966797, ["z"] = 103.49515533447, ["info"] = "Garage O"},
  [16] = { ["x"] = -338.31619262695, ["y"] = 266.79782104492, ["z"] = 85.741966247559, ["info"] = "Garage P"},
  [17] = { ["x"] = 273.66683959961, ["y"] = -343.83737182617, ["z"] = 44.919876098633, ["info"] = "Garage Q"},
  [18] = { ["x"] = 66.215492248535, ["y"] = 13.700443267822, ["z"] = 69.047248840332, ["info"] = "Garage R"},
  [19] = { ["x"] = 3.3330917358398, ["y"] = -1680.7877197266, ["z"] = 29.170293807983, ["info"] = "Garage Imports"},
  [20] = { ["x"] = 286.67013549805, ["y"] = 79.613700866699, ["z"] = 94.362899780273, ["info"] = "Garage S"},
  [21] = { ["x"] = 211.79, ["y"] = -808.38, ["z"] = 30.833, ["info"] = "Garage T"},
  [22] = { ["x"] = 447.65, ["y"] = -1021.23, ["z"] = 28.45, ["info"] = "Garage Police Department"},
  [23] = { ["x"] = -25.59, ["y"] = -720.86, ["z"] = 32.22, ["info"] = "Garage House"},
  [24] =  { ['x'] = -836.93,['y'] = -1273.09,['z'] = 5.01, ['info'] = 'Garage U' },
  [25] = { ['x'] = -1563.23,['y'] = -257.64,['z'] = 48.28, ['info'] = 'Garage V' },
  [26] = { ['x'] = -1327.67,['y'] = -927.44,['z'] = 11.21, ['info'] = 'Garage W' },
  [27] = { ['x'] = 1519.34,['y'] = 3764.54,['z'] =  34.03, ['info'] = 'Sandy Shores' },



}
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
  SetNuiFocus(true,true)
end)

RegisterNUICallback('btnTwatter', function()
  local handle = exports["isPed"]:isPed("twitterhandle")
  SendNUIMessage({openSection = "twatter", twats = currentTwats, myhandle = handle})
end)

RegisterNUICallback('newTwatSubmit', function(data, cb)
  local handle = exports["isPed"]:isPed("twitterhandle")
  TriggerServerEvent('Tweet', handle, data.twat, data.time)   
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

RegisterNetEvent('phone:loadSMSOther')
AddEventHandler('phone:loadSMSOther', function(messages,mynumber)
  openGui()
  lstMsgs = {}
  if (#messages ~= 0) then
    for k,v in pairs(messages) do
      if v ~= nil then
        local msgDisplayName = ""
        if v.receiver == mynumber then
          msgDisplayName = getContactName(v.sender)
        else
          msgDisplayName = getContactName(v.receiver)
        end
        local message = {
          id = tonumber(v.id),
          msgDisplayName = msgDisplayName,
          sender = tonumber(v.sender),
          receiver = tonumber(v.receiver),
          date = tonumber(v.date),
          message = v.message
        }
        lstMsgs[#lstMsgs+1]= message
      end
    end
  end
  SendNUIMessage({openSection = "messagesOther", list = lstMsgs, clientNumber = mynumber})
end)

RegisterNUICallback('btnPagerToggle', function()
  TriggerEvent("togglePager")
end)

RegisterNUICallback('accountInformation', function()
  TriggerServerEvent("account:information:sv", exports['isPed']:isPed('cid'))
end)


RegisterNetEvent("account:information:cl")
AddEventHandler("account:information:cl", function(licences, paycheck, pChips)
  local playercid = exports["isPed"]:isPed("cid")
  local phone_number, mycash, mybank, mybankid, mychips = RPC.execute("phone:extraInfo", playercid)
  local responseObject = {
    cid = exports["isPed"]:isPed("cid"),
    bankid = mybankid,
    paycheck = paycheck,
    chips = mychips,
    cash = mycash,
    bank = mybank,
    job = exports["isPed"]:isPed("myjob"),
    secondaryJob = exports["isPed"]:isPed("secondaryjob"),
    licenses = licences, 
    pagerStatus = exports["isPed"]:isPed("pagerstatus"),
    phonenumber = phone_number
    
  }
  SendNUIMessage({openSection = "accountInformation", response = responseObject})

end)

RegisterNetEvent('phone:newSMS')
AddEventHandler('phone:newSMS', function(id, number, message, mypn, date, recip)
  lastnumber = number
  if hasPhone() then
    SendNUIMessage({
        openSection = "newsms"
    })
      TriggerServerEvent('phone:getSMS', exports['isPed']:isPed('cid')) 
    if phoneNotifications then
      TriggerEvent("DoLongHudText", "You just received a new SMS.", 1)
      PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
    end
  end
end)

-- SMS Events
RegisterNetEvent('phone:loadSMS')
AddEventHandler('phone:loadSMS', function(messages,mynumber)

  lstMsgs = {}
  if (#messages ~= 0) then
    for k,v in pairs(messages) do
      if v ~= nil then
        local msgDisplayName = ""
        if v.receiver == mynumber then
          msgDisplayName = getContactName(v.sender)
        else
          msgDisplayName = getContactName(v.receiver)
        end
        local message = {
          id = tonumber(v.id),
          msgDisplayName = msgDisplayName,
          sender = tonumber(v.sender),
          receiver = tonumber(v.receiver),
          date = v.date,
          message = v.message
        }
        lstMsgs[#lstMsgs+1]= message
      end
    end
  end
  SendNUIMessage({openSection = "messages", list = lstMsgs, clientNumber = mynumber})
end)

RegisterNetEvent('phone:sendSMS')
AddEventHandler('phone:sendSMS', function(number, message, sender, receiver, displayname)
  if(number ~= nil and message ~= nil) then
    --TriggerServerEvent('phone:sendSMS', exports['isPed']:isPed('cid'), number, message)
    --Citizen.Wait(1000)
    RPC.execute("phone:sendSMS", exports['isPed']:isPed('cid'), number, message)
    --TriggerServerEvent('phone:getSMSc', exports['isPed']:isPed('cid'))
    --TriggerServerEvent('phone:serverGetMessagesBetweenParties', sender, receiver, displayname)

    local result, name, mynumber = RPC.execute("phone:GetMessagesBetweenParties", sender, receiver, displayname)

    SendNUIMessage({openSection = "messageRead", messages = result, displayName = name, clientNumber = mynumber})


    
  else
    phoneMsg("You must fill in a number and message!")
  end
end)

local lastnumber = 0

RegisterNetEvent('animation:sms')
AddEventHandler('animation:sms', function(enable)
  TriggerEvent("destroyPropPhone")
  local lPed = PlayerPedId()
  inPhone = enable

  RequestAnimDict("cellphone@")
  while not HasAnimDictLoaded("cellphone@") do
    Citizen.Wait(0)
  end

  if not isInTrunk then
    TaskPlayAnim(lPed, "cellphone@", "cellphone_text_in", 2.0, 3.0, -1, 49, 0, 0, 0, 0)
  end
  Citizen.Wait(300)
  if inPhone then
    TriggerEvent("attachItemPhone","phone01")
    Citizen.Wait(150)
    while inPhone do
      if isDead then
        closeGui()
        inPhone = false
      end
      if not isInTrunk and not IsEntityPlayingAnim(lPed, "cellphone@", "cellphone_text_read_base", 3) and not IsEntityPlayingAnim(lPed, "cellphone@", "cellphone_swipe_screen", 3) then
        TaskPlayAnim(lPed, "cellphone@", "cellphone_text_read_base", 2.0, 3.0, -1, 49, 0, 0, 0, 0)
      end    
      Citizen.Wait(1)
    end
    if not isInTrunk then
      ClearPedTasks(PlayerPedId())
    end
  else
    if not isInTrunk then
      Citizen.Wait(100)
      ClearPedTasks(PlayerPedId())
      TaskPlayAnim(lPed, "cellphone@", "cellphone_text_out", 2.0, 1.0, 5.0, 49, 0, 0, 0, 0)
      Citizen.Wait(400)
      TriggerEvent("destroyPropPhone")
      Citizen.Wait(400)
      ClearPedTasks(PlayerPedId())
    else
      TriggerEvent("destroyPropPhone")
    end
  end
end)


RegisterNetEvent('phone:reply')
AddEventHandler('phone:reply', function(message)
  if lastnumber ~= 0 then
    TriggerServerEvent('phone:sendSMS', exports['isPed']:isPed('cid'), lastnumber, message)
    TriggerEvent("chatMessagess", "You", 6, message)
  else
    phoneMsg("No user has recently SMS'd you.")
  end
end)



function phoneMsg(inputText)
  TriggerEvent("chatMessagess", "Service ", 5, inputText)
end


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
  local cid = exports["isPed"]:isPed("cid")
  local mycontacts = RPC.execute("phone:getContacts", cid, number)

  if (#mycontacts ~= 0) then
    for k,v in pairs(mycontacts) do
      if v ~= nil then
        if (v.number ~= nil and tonumber(v.number) == tonumber(number)) then
          print(v.name)
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
  TriggerServerEvent('phone:getContacts')
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

RRP = RRP or {}
RRP.DataControls = RRP.DataControls or {}

function RRP.DataControls.getBindTable()

	local i = 1
	local controlTable = {}
	for k,v in pairs(RRP.Controls.Current) do
		controlTable[i] = {k,v}
		i = i+1
	end

    return controlTable
end
RRP.SettingsData = RRP.SettingsData or {}
RRP.Settings = RRP.Settings or {}

RRP.Settings.Current = {}
-- Current bind name and keys
RRP.Settings.Default = {
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
RRP.Controls = RRP.Controls or {}
RRP.Controls.Current = {}
-- Current bind name and keys
RRP.Controls.Default = {
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

function RRP.SettingsData.getSettingsTable()
  return RRP.Settings.Current
end

RegisterNUICallback('settings', function()
  local controls = exports["warp-base"]:getModule("DataControls"):getBindTable()
  local settings = exports["warp-base"]:getModule("SettingsData"):getSettingsTable()
  SendNUIMessage({openSection = "settings", currentControls = controls, currentSettings = settings})
end)

RegisterNUICallback('settingsUpdateToko', function(data, cb)
  if data.tag == "settings" then
    exports["warp-base"]:getModule("SettingsData"):setSettingsTableGlobal(data.settings, true)
  elseif data.tag == "controlUpdate" then
    exports["warp-base"]:getModule("DataControls"):encodeSetBindTable(data.controls)
  end
end)

RegisterNUICallback('settingsResetToko', function()
  TriggerEvent("warp-base:cl:player_reset", "tokovoip")
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

RegisterNetEvent("Passes:RequestUpdate")
AddEventHandler("Passes:RequestUpdate", function(cidsent)
  local cid = exports["isPed"]:isPed("cid")
  if tonumber(cid) == tonumber(cidsent) then
    TriggerServerEvent("server:currentpasses")
    TriggerEvent("DoLongHudText", "Your job has been updated!", 1)
  end
end)

RegisterCommand("closephone", function(source, args)
  closeGui()
  SetNuiFocus(false, false)
  SendNUIMessage({
    state = 'destroy'
  })
end)

local lastping = 0
local blipgps = {}
RegisterNetEvent('GPSTrack:Accepted')
AddEventHandler('GPSTrack:Accepted', function(x,y,z,srcid,stage)

	local job = exports["isPed"]:isPed("myjob")
	if job == "police" or job == "ems" then
		if blipgps.srcid then
			RemoveBlip(blipgps.srcid)
		end
		blipgps.srcid = AddBlipForCoord(x,y,z) 
	    SetBlipColour(blipgps.srcid,1)
		SetBlipSprite(blipgps.srcid, 459)
		SetBlipColour(blipgps.srcid, 8)
		SetBlipScale(blipgps.srcid, 1.5)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Help Call")
		EndTextCommandSetBlipName(blipgps.srcid)
		Citizen.Wait(55000)
		RemoveBlip(blipgps.srcid)
	end
end)

RegisterNetEvent('GPSTrack:Create')
AddEventHandler('GPSTrack:Create', function()

	if lastping == 0 then
		lastping = 1
		x,y,z = GPSTrack(1)
		TriggerServerEvent("GPSTrack:Accepted",x,y,z,1)
		Citizen.Wait(60000)
		x,y,z = GPSTrack(2)
		TriggerServerEvent("GPSTrack:Accepted",x,y,z,2)
		Citizen.Wait(60000)
		x,y,z = GPSTrack(3)
		TriggerServerEvent("GPSTrack:Accepted",x,y,z,3)
		Citizen.Wait(120000)
		lastping = 0
	end
end)




function GPSTrack(stage)
	local multi = 50
	if stage == 1 then
		multi = 110
	elseif stage == 2 then
		multi = 55
	else
		multi = 5
	end
	local luck = math.random(2)
	local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, math.random(multi) + 0.0, 0.0))
	if luck == 1 then
		x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), math.random(multi) + 0.0, 0.0, 0.0))
	end
	return x,y,z
end