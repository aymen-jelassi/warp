Citizen.CreateThread(function()
    TriggerEvent('deleteAllTweets')
    TriggerEvent('deleteAllYP')
    TriggerEvent('deleteAllEmails')
end)

local callID = nil

RegisterNetEvent('GetTweets')
AddEventHandler('GetTweets', function(onePlayer)
    local src = source
    exports.oxmysql:execute('SELECT * FROM (SELECT * FROM tweets ORDER BY `time` DESC LIMIT 50) sub ORDER BY time ASC', {}, function(tweets) -- Get most recent 100 tweets
        if onePlayer then
            TriggerClientEvent('Client:UpdateTweets', src, tweets)
        else
            TriggerClientEvent('Client:UpdateTweets', src, tweets)
        end
    end)
end)

RegisterNetEvent('Tweet')
AddEventHandler('Tweet', function(handle, data, time)

    exports.oxmysql:execute('INSERT INTO tweets (handle, message, time) VALUES (@handle, @message, @time)', {['handle'] = handle,['message'] = data,['time'] = time}, function(result)
        TriggerEvent('GetTweets', source, true)
    end)
    local newtwat = { ['handle'] = handle, ['message'] = data, ['time'] = time}
    TriggerClientEvent('Client:UpdateTweet', -1, newtwat)
end)

RegisterNetEvent("testtweet")
AddEventHandler("testtweet", function(handle, data, time)
    local newtwat = { ['handle'] = handle, ['message'] = data, ['time'] = time}
    TriggerClientEvent('Client:UpdateTweet', -1, newtwat)
end)

RPC.register("phone:addEmail", function(pSource, pCid, pFrom, pSubject, pMessage, pTime)
    print("wwwwwww")

    local data = Await(SQL.execute("INSERT INTO character_emails (`cid`, `from`, `subject`, `message`, `time`) VALUES (@cid, @from, @subject, @message, @time)",{
        ["cid"] = pCid.param,
        ["from"] = pFrom.param,
        ["subject"] = pSubject.param,
        ["message"] = pMessage.param,
        ["time"] = pTime.param
    }))

    if not data then return false end

    return true
end)

RPC.register("phone:getOwnedVehicles", function(pSource)
    local user = exports["warp-base"]:getModule("Player"):GetUser(pSource)
    local char = user:getCurrentCharacter()

    local data = Await(SQL.execute("SELECT * FROM characters_cars WHERE cid = @cid",{
        ["cid"] = char.id
    }))

    if not data then return {} end

    return data
end)

RPC.register("phone:getEmails", function(pSource)
    local user = exports["warp-base"]:getModule("Player"):GetUser(pSource)
    local char = user:getCurrentCharacter()

    local data = Await(SQL.execute("SELECT * FROM character_emails WHERE cid = @cid ORDER BY id DESC",{
        ["cid"] = char.id
    }))

    if not data then return nil end

    if data == nil then return nil end

    return data
end)

RPC.register("phone:hasEmails", function(pSource)
    local user = exports["warp-base"]:getModule("Player"):GetUser(pSource)
    local char = user:getCurrentCharacter()

    local data = Await(SQL.execute("SELECT COUNT(*) AS total FROM character_emails WHERE cid = @cid",{
        ["cid"] = char.id
    }))

    if not data then return false end

    if data == nil then return false end

    local hasEmail

    if data[1].total > 0 then
        hasEmail = true
    else
        hasEmail = false
    end

    return hasEmail
end)

RPC.register("phone:getDarkMarketProducts", function(pSource, pZone)
    local data = Await(SQL.execute("SELECT * FROM dark_market WHERE zone = @zone", {
        ["zone"] = pZone.param
    }))

    if not data then return false end

    return data
end)

RPC.register("phone:extraInfo", function(pSource, pCid)
    local data = Await(SQL.execute("SELECT phone_number, cash, bank, bankid, casinochips FROM characters WHERE id = @cid",{
        ["cid"] = pCid.param
    }))

    return data[1].phone_number, data[1].cash, data[1].bank, data[1].bankid, data[1].casinochips
end)

RPC.register("phone:getCurrentKeys", function(pSource, pPropertyName)
    print("phone:getCurrentKeys")
    local data = Await(SQL.execute("SELECT * FROM properties WHERE propertyname = @propertyname",{
        ["propertyname"] = pPropertyName.param
    }))
    print(tostring(data[1].haskeys))
    return data[1].haskeys
end)

RPC.register("phone:updatePropertyKeys", function(pSource, pCid, pPropertyName, pCurKeys)
    print("phone:updatePropertyKeys")
    local keys
    if pCurKeys.param == "null" then
    keys = pCid.param
    else
    keys = pCurKeys.param .. "," .. pCid.param
    end
    print(tostring(keys))
    local data = Await(SQL.execute("UPDATE properties SET haskeys = @haskeys WHERE propertyname = @propertyname",{
        ["haskeys"] = keys,
        ["propertyname"] = pPropertyName.param
    }))
    return true
end)

RPC.register("phone:getCryptoBalance", function(pSource, pCid, pCryptoId)
    -- make so it for eaches all cryptos instead of adding manually new crypto
    local data = Await(SQL.execute("SELECT * FROM user_crypto WHERE cryptocid = @cid AND cryptoid = @cryptoid",{
        ["cid"] = pCid.param,
        ["cryptoid"] = pCryptoId.param
    }))

    return data[1].cryptoamount
end)

RPC.register("phone:generateWallet", function(pSource, pCid, pCryptoId)
    local insert = Await(SQL.execute("INSERT INTO user_crypto (cryptoid, cryptoamount, cryptocid) VALUES (@cryptoid, @cryptoamount, @cryptocid)",{
        ["cryptoid"] = pCryptoId.param,
        ["cryptoamount"] = 0,
        ["cryptocid"] = pCid.param
    }))

    return true
end)

RPC.register("phone:getCryptoValue", function(pSource, pCryptoId)
    local data = Await(SQL.execute("SELECT * FROM cryptos WHERE cryptoid = @cryptoid",{
        ["cryptoid"] = pCryptoId.param
    }))
    return data[1].value
end)

RPC.register("phone:getCryptos", function(pSource)
    local data = Await(SQL.execute("SELECT * FROM cryptos",{}))
    return data
end)

RPC.register("phone:getJobs", function(pSource, pCid)
    local data = Await(SQL.execute("SELECT * FROM jobs",{}))
    return data
end)

RPC.register("phone:getDebt", function(pSource, pCid)
    local data = Await(SQL.execute("SELECT * FROM user_debt WHERE debtcid = @cid",{
        ["cid"] = pCid.param
    }))

    if not data then return false end

    return data
end)

RPC.register("phone:getLoans", function(pSource, pCid)
    local data = Await(SQL.execute("SELECT * FROM user_loans WHERE loancid = @cid",{
        ["cid"] = pCid.param
    }))

    if not data then return false end

    return data
end)

RPC.register("phone:getBusinessNameFromID", function(pSource, pBusinessId)
    local data = Await(SQL.execute("SELECT * FROM business_passes WHERE business_id = @business_id",{
        ["business_id"] = pBusinessId.param
    }))

    if not data then return false end

    return data[1].business_name
end)

RPC.register("phone:getPropertyNameFromID", function(pSource, pPropertyId)
    local data = Await(SQL.execute("SELECT * FROM properties WHERE property_id = @property_id",{
        ["property_id"] = pPropertyId.param
    }))

    if not data then return nil end

    return data[1].propertyname
end)

RPC.register("phone:getCarNameFromID", function(pSource, pCarId)
    local data = Await(SQL.execute("SELECT * FROM characters_cars WHERE id = @id",{ --include cid here
        ["id"] = pCarId.param
    }))

    if not data then return nil end

    return data[1].model
end)

RPC.register("phone:getIdleGroups", function(pSource, pJob)
    print(pJob.param)
    local data = Await(SQL.execute("SELECT * FROM job_queue WHERE jobtype = @jobtype AND ready = @ready AND status = @status",{
        ["jobtype"] = pJob.param,
        ["ready"] = 0,
        ["status"] = 0
    }))
    return data
end)

RPC.register("phone:getBusyGroups", function(pSource, pJob)
    print(pJob.param)
    local data = Await(SQL.execute("SELECT * FROM job_queue WHERE jobtype = @jobtype AND status = @status",{
        ["jobtype"] = pJob.param,
        ["status"] = 1
    }))
    return data
end)

RPC.register("phone:getFirstName", function(pSource, pCid)
    local data = Await(SQL.execute("SELECT * FROM characters WHERE id = @cid",{
        ["cid"] = pCid.param
    }))
    return data[1].first_name
end)

RPC.register("phone:getLastName", function(pSource, pCid)
    local data = Await(SQL.execute("SELECT * FROM characters WHERE id = @cid",{
        ["cid"] = pCid.param
    }))
    return data[1].last_name
end)

RPC.register("phone:getCurJob", function(pSource, pCid)
    local data = Await(SQL.execute("SELECT * FROM characters WHERE id = @cid",{
        ["cid"] = pCid.param
    }))
    return data[1].signedinjob
end)

RPC.register("phone:isGroupOwner", function(pSource, pCid)
    local data = Await(SQL.execute("SELECT COUNT(*) AS total FROM job_queue WHERE owner = @cid",{
        ["cid"] = pCid.param
    }))

    if data[1].total > 0 then return true else return false end
end)

RPC.register("phone:isActuallyInGroup", function(pSource, pCid)
    local data = Await(SQL.execute("SELECT COUNT(*) AS total FROM job_queue WHERE cid = @cid",{
        ["cid"] = pCid.param
    }))

    if data[1].total > 0 then return true else return false end
end)

RPC.register("phone:getGroupMembers", function(pSource, pJob)
    local data = Await(SQL.execute("SELECT * FROM job_queue WHERE jobtype = @jobtype",{
        ["jobtype"] = pJob.param
    }))
    return data[1].members
end)

RPC.register("phone:getGroupByCID", function(pSource, pCid)
    local data = Await(SQL.execute("SELECT * FROM job_queue WHERE owner = @cid",{
        ["cid"] = pCid.param
    }))
    return data
end)

RPC.register("phone:getGroupMembersByCID", function(pSource, pCid)
    local data = Await(SQL.execute("SELECT * FROM job_queue WHERE cid = @cid",{
        ["cid"] = pCid.param
    }))
    return data
end)

RPC.register("phone:signIn", function(pSource, pCid, pJob)
    -- check if signed in is already 1
    local job

    if pJob.param == "fish" then
        job = "Fishing"
    elseif pJob.param == "deliveries" then
        job = "24/7 Deliveries"
    end

    local data = Await(SQL.execute("UPDATE characters SET signedin = @signedin, signedinjob = @signedinjob WHERE id = @cid",{
        ["signedin"] = 1,
        ["signedinjob"] = job,
        ["cid"] = pCid.param
    }))
    return true
end)

RPC.register("phone:createGroup", function(pSource, pCid, pJob)
    local data1 = Await(SQL.execute("INSERT INTO job_queue (owner, cid, ready, status, jobtype) VALUES (@owner,  @cid, @ready, @status, @jobtype)",{
        ["owner"] = pCid.param,
        ["cid"] = pCid.param,
        ["ready"] = 0,
        ["status"] = 0,
        ["jobtype"] = pJob.param
    }))

    local data2 = Await(SQL.execute("UPDATE characters SET ingroup = @ingroup WHERE id = @cid",{
        ["ingroup"] = 1,
        ["cid"] = pCid.param
    }))

    TriggerClientEvent("warp-phone:updateGroups", -1, pJob.param)

    return true
end)

RegisterNetEvent('updatephoneserver')
AddEventHandler('updatephoneserver', function()
    TriggerClientEvent("warp-phone:updateGroups", -1, "Fishing")
end)

RegisterNetEvent('updategroupserver')
AddEventHandler('updategroupserver', function()
    TriggerClientEvent("warp-phone:updateGroupMembers", -1, "Fishing")
end)

RPC.register("phone:joinGroup", function(pSource, pCid, pGroup, pJob)

    local data1 = Await(SQL.execute("INSERT INTO job_queue (owner, cid, ready, status, jobtype) VALUES (@owner,  @cid, @ready, @status, @jobtype)",{
        ["owner"] = pGroup.param,
        ["cid"] = pCid.param,
        ["ready"] = 0,
        ["status"] = 0,
        ["jobtype"] = pJob.param
    }))

    TriggerClientEvent("warp-phone:updateGroupMembers", -1, pJob.param)

    return true
end)

RPC.register("phone:signOut", function(pSource, pCid)
    local data = Await(SQL.execute("UPDATE characters SET signedin = @signedin, signedinjob = NULL WHERE id = @cid",{
        ["signedin"] = 0,
        ["cid"] = pCid.param
    }))
    return true
end)

RPC.register("phone:isSignedIn", function(pSource, pCid)
    local data = Await(SQL.execute("SELECT * FROM characters WHERE id = @cid",{
        ["cid"] = pCid.param
    }))
    return data[1].signedin
end)

RPC.register("phone:isInGroup", function(pSource, pCid)
    local data = Await(SQL.execute("SELECT * FROM characters WHERE id = @cid",{
        ["cid"] = pCid.param
    }))
    return data[1].ingroup
end)

--[[ RPC.register("phone:getOwnedProperties", function(pSource, pCid)
    local data = Await(SQL.execute("SELECT * FROM properties WHERE cid = @cid ORDER BY id LIMIT 6",{
        ["cid"] = pCid.param
    }))

    return data
end) ]]

--[[ RPC.register("phone:getProperties", function(pSource, pCid)
    local data = Await(SQL.execute("SELECT * FROM properties po LEFT JOIN property_keys pk on po.cid = pk.cid  WHERE po.cid = @cid ORDER BY id LIMIT 6",{
        ["cid"] = pCid.param
    }))

    return data
end) ]]
RPC.register("phone:getProperties", function(pSource)
    print("i was called")
    local user = exports["warp-base"]:getModule("Player"):GetUser(pSource)
    local charid = user:getCurrentCharacter().id
    local propertydata = Await(SQL.execute("SELECT * FROM properties", {}))
    local propertykeydata = Await(SQL.execute("SELECT * FROM property_keys WHERE cid = @cid",{["cid"] = charid}))
    local retundata = {}
    for _,pData in pairs(propertydata) do
        for _,pKey in pairs(propertykeydata) do
            if pData.property_id == pKey.property_id or pData.cid == pKey.cid  then
                retundata[#retundata + 1] = {
                    propertyname = pData.propertyname,
                    icon = pData.icon,
                    locked = pData.locked,
                    cid = pData.cid,
                    category = pData.propertycategory,
                    property_id = pData.property_id
                }
            end
        end
    end
    return retundata
end)

RPC.register("phone:getFirstLastName", function(pSource, pCid)
    local data = Await(SQL.execute("SELECT * FROM characters WHERE id = @cid",{
        ["cid"] = pCid.param
    }))

    return data[1].first_name, data[1].last_name
end)

RPC.register("phone:getPropertyKeys", function(pSource, pPropertyId)
    local data = Await(SQL.execute("SELECT * FROM property_keys WHERE property_id = @property_id",{
        ["property_id"] = pPropertyId.param
    }))

    --if not data then return {} end

    return data
end)

RPC.register("phone:addPropertyKey", function(pSource, pCid, pPropertyId)
    local data = Await(SQL.execute("INSERT INTO property_keys (property_id, cid) VALUES (@property_id, @cid)",{
        ["property_id"] = pPropertyId.param,
        ["cid"] = pCid.param
    }))

    if not data then return false end

    return true
end)

RPC.register("phone:removePropertyKey", function(pSource, pCid, pPropertyId)
    local data = Await(SQL.execute("DELETE FROM property_keys WHERE property_id = @property_id AND cid = @cid",{
        ["property_id"] = pPropertyId.param,
        ["cid"] = pCid.param
    }))

    if not data then return false end

    return true
end)

--[[ RPC.register("phone:getPropertyKeys", function(pSource, pCid)
    local data = Await(SQL.execute("SELECT * FROM property_keys WHERE cid = @cid",{
        ["cid"] = pCid.param
    }))
    local propertyid
    local keys = {}
    for i = 1, #data do
    propertyid = data[i].property_id
    local properties = Await(SQL.execute("SELECT * FROM properties WHERE property_id = @property_id",{
        ["property_id"] = propertyid
    }))
    if properties then
    print("yep add to array")
    table.insert(keys, properties)
    end
    end

    if not data then return {} end --keys?

    return keys
end) ]]

RPC.register("phone:getSendifyLogs", function(pSource, pCid)
    local data = Await(SQL.execute("SELECT * FROM sendify_logs WHERE cid = @cid ORDER BY id DESC",{
        ["cid"] = pCid.param
    }))

    return data
end)

RPC.register("phone:sendSendifyPayment", function(pSource, pSender, pReceiver, pAmount)
    local user = exports["warp-base"]:getModule("Player"):GetUser(pSource)
	local char = user:getCurrentCharacter()

    local exist = Await(SQL.execute("SELECT COUNT(*) AS total FROM characters WHERE id = @cid",{
        ["cid"] = pReceiver.param
    }))

    local sender = Await(SQL.execute("SELECT * FROM characters WHERE id = @cid",{
        ["cid"] = pSender.param
    }))

    local receiver = Await(SQL.execute("SELECT * FROM characters WHERE id = @cid",{
        ["cid"] = pReceiver.param
    }))

    local bank = sender[1].bank

    if tonumber(pAmount.param) >= tonumber(bank) then return "notenough" end
    if exist[1].total < 1 then return "invalid" end

    local elsender = Await(SQL.execute("UPDATE characters SET bank = bank - @amount WHERE id = @cid",{
        ["amount"] = pAmount.param,
        ["cid"] = pSender.param
    }))

    local elreceiver = Await(SQL.execute("UPDATE characters SET bank = bank + @amount WHERE id = @cid",{
        ["amount"] = pAmount.param,
        ["cid"] = pReceiver.param
    }))

    local sender_name = tostring(sender[1].first_name) .. " " .. tostring(sender[1].last_name)
    local receiver_name = tostring(receiver[1].first_name) .. " " .. tostring(receiver[1].last_name)

    local data1 = Await(SQL.execute("INSERT INTO sendify_logs (cid, sender, target, amount, type) VALUES (@cid, @sender, @target, @amount, @type)",{
        ["cid"] = pSender.param,
        ["sender"] = sender_name,
        ["target"] = receiver_name,
        ["amount"] = pAmount.param,
        ["type"] = "neg"
    }))

    local data2 = Await(SQL.execute("INSERT INTO sendify_logs (cid, sender, target, amount, type) VALUES (@cid, @sender, @target, @amount, @type)",{
        ["cid"] = pReceiver.param,
        ["sender"] = sender_name,
        ["target"] = receiver_name,
        ["amount"] = pAmount.param,
        ["type"] = "pos"
    }))

    if not data1 then return "error" end
    if not data2 then return "error" end

    return "success"
end)

RegisterNetEvent('Server:GetHandle')
AddEventHandler('Server:GetHandle', function()
    local src = source
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local char = user:getCurrentCharacter()
    fal = "@" .. char.first_name .. "_" .. char.last_name
    local handle = fal
    TriggerClientEvent('givemethehandle', src, handle)
    TriggerClientEvent('updateNameClient', src, char.first_name, char.last_name)
end)

--[[ Contacts stuff ]]

RegisterNetEvent('phone:addContact')
AddEventHandler('phone:addContact', function(name, number)
    local src = source
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local characterId = user:getVar("character").id
    local handle = handle

    exports.oxmysql:execute('INSERT INTO user_contacts (identifier, name, number) VALUES (@identifier, @name, @number)', {
        ['identifier'] = characterId,
        ['name'] = name,
        ['number'] = number
    }, function(result)
        TriggerEvent('getContacts', true, src)
        TriggerClientEvent('refreshContacts', src)
        TriggerClientEvent('phone:newContact', src, name, number)
    end)
end)

RegisterNetEvent('deleteContact')
AddEventHandler('deleteContact', function(name, number)
    local src = source
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local characterId = user:getVar("character").id

    exports.oxmysql:execute('DELETE FROM user_contacts WHERE name = @name AND number = @number LIMIT 1', {
        ['name'] = name,
        ['number'] = number
    }, function (result)
        TriggerEvent('getContacts', true, src)
        TriggerClientEvent('refreshContacts', src)
        TriggerClientEvent('phone:deleteContact', src, name, number)
    end)
end)

RegisterNetEvent('phone:getContacts')
AddEventHandler('phone:getContacts', function()
    local src = source
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local characterId = user:getVar("character").id

    if (user == nil) then
        TriggerClientEvent('phone:loadContacts', src, json.encode({}))
    else
        local contacts = getContacts(characterId, function(contacts)
            if (contacts) then
                TriggerClientEvent('phone:loadContacts', src, contacts)
            else
                TriggerClientEvent('phone:loadContacts', src, {})
            end
        end)
    end
end)

RPC.register('phone:getContacts', function(pSource, pCid)
    print("get contacts rpc called")
    local contacts = Await(SQL.execute("SELECT * FROM user_contacts WHERE identifier = @cid ORDER BY name ASC",{
        ["cid"] = pCid.param
    }))

    if contacts == nil then return {} end

    return contacts
end)

RPC.register('phone:getContactName', function(pSource, pCid, pNumber)
    print("get contacts rpc called")
    local contacts = Await(SQL.execute("SELECT name FROM user_contacts WHERE identifier = @cid AND number = @number",{
        ["cid"] = pCid.param,
        ["number"] = pNumber.param
    
    }))

    if contacts == nil then return {} end

    return contacts
end)

RPC.register('phone:addNewContact', function(pSource, pCid, pName, pNumber)
    -- check if number is already in phone?
    -- check if name is already used in contactlist?
    -- return error "already exists? under name: "
    local data = Await(SQL.execute("INSERT INTO user_contacts (identifier, name, number) VALUES (@identifier, @name, @number)",{
        ["identifier"] = pCid.param,
        ["name"] = pName.param,
        ["number"] = pNumber.param
    }))

    if not data then return false end

    return true
end)

RPC.register('phone:removeContact', function(pSource, pCid, pName, pNumber)
    local data = Await(SQL.execute("DELETE FROM user_contacts WHERE identifier = @cid AND name = @name AND number = @number",{
        ["cid"] = pCid.param,
        ["name"] = pName.param,
        ["number"] = pNumber.param
    }))

    if not data then return false end

    return true
end)

function getMessagesBetweenUsers(sender, recipient)
    exports.oxmysql:execute("SELECT id, sender, receiver, message, date FROM user_messages WHERE (receiver = @from OR sender = @from) and (receiver = @to or sender = @to)", {
    ['from'] = sender,
    ['to'] = recipient
    }, function(result) 
        
        print(json.encode(result))

    end)
end

RegisterNetEvent('phone:test')
AddEventHandler('phone:test', function(sender, recipient)
    getMessagesBetweenUsers(sender, recipient)
end)

function saveSMS(receiver, sender, message, callback)
    exports.oxmysql:execute("INSERT INTO user_messages (`receiver`, `sender`, `message`) VALUES (@receiver, @sender, @msg)",
    {['receiver'] = tonumber(receiver), ['sender'] = tonumber(sender), ['msg'] = message}, function(rowsChanged)
        exports.oxmysql:execute("SELECT id FROM user_messages WHERE receiver = @receiver AND sender = @sender AND message = @msg",
    {['receiver'] = tonumber(receiver), ['sender'] = tonumber(sender), ['msg'] = message}, function(result) if callback then callback(result) end end)
    end)
end

function getContacts(identifier, callback)
    exports.oxmysql:execute("SELECT name,number FROM user_contacts WHERE identifier = @identifier ORDER BY name ASC", {
        ['identifier'] = identifier
    }, function(result) callback(result) end)
end

function getContactsNew(identifier)
    exports.oxmysql:execute("SELECT name,number FROM user_contacts WHERE identifier = @identifier ORDER BY name ASC", {
        ['identifier'] = identifier
    }, function(result) 
    end)
end

RegisterNetEvent('getNM')
AddEventHandler('getNM', function(pNumber)
    local src = source
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local characterId = user:getVar("character").id
    local pNumber = getNumberPhone(characterId)
    TriggerClientEvent("client:updatePNumber",src,pNumber)
end)


RegisterNetEvent('phone:deleteYP')
AddEventHandler('phone:deleteYP', function(number)
    local src = source
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
    local characterId = user:getVar("character").id
    local myNumber = getNumberPhone(characterId)
    exports.oxmysql:execute('DELETE FROM phone_yp WHERE phoneNumber = @phoneNumber', {
        ['phoneNumber'] = myNumber
    }, function (result)
        TriggerClientEvent('refreshYP', src)
  
    end)
end)

--[[ Phone calling stuff ]]

function getNumberPhone(identifier)
    local result = MySQL.Sync.fetchAll("SELECT characters.phone_number FROM characters WHERE characters.id = @id", {
        ['@id'] = identifier
    })
    if result[1] ~= nil then
        return result[1].phone_number
    end
    return nil
end
function getIdentifierByPhoneNumber(phone_number) 
    local result = MySQL.Sync.fetchAll("SELECT characters.id FROM characters WHERE characters.phone_number = @phone_number", {
        ['@phone_number'] = phone_number
    })
    if result[1] ~= nil then
        return result[1].id
    end
    return nil
end


RegisterServerEvent('requestPing')
AddEventHandler('requestPing', function(target, x,y,z, pIsAnon)
    local src = source
    TriggerClientEvent('AllowedPing', tonumber(target), x,y,z, src, name, pIsAnon)
end)

RegisterServerEvent('pingAccepted')
AddEventHandler('pingAccepted', function(target)
    local target = tonumber(target)
    TriggerClientEvent('DoLongHudText', target, "You ping was accepted!", 5)
end)

RegisterServerEvent('pingDeclined')
AddEventHandler('pingDeclined', function(target)
    local target = tonumber(target)
    TriggerClientEvent('DoLongHudText', target, "You ping was declined!", 5)
end)


RegisterNetEvent('phone:callContact')
AddEventHandler('phone:callContact', function(cid, targetnumber, toggle)
    local src = source
    local targetid = 0
    local targetIdentifier = getIdentifierByPhoneNumber(targetnumber)
    local srcPhone = getNumberPhone(cid)

    if not toggle then
        TriggerClientEvent('phone:initiateCall', src)
        for _, player in ipairs(GetPlayers()) do
            local user = exports["warp-base"]:getModule("Player"):GetUser(tonumber(player))
            local char = user:getVar("character")
            if char.id == targetIdentifier then
                TriggerClientEvent('phone:receiveCall', tonumber(player), targetnumber, src, getPhoneRandomNumber())
            end
        end
    else
        TriggerClientEvent('phone:initiateCall', src)
        
        for _, player in ipairs(GetPlayers()) do
            local user = exports["warp-base"]:getModule("Player"):GetUser(tonumber(player))
            local char = user:getVar("character")
            if char.id == targetIdentifier then
                TriggerClientEvent('phone:receiveCall', tonumber(player), targetnumber, src, srcPhone)
            end
        end
    end
end)

RegisterNetEvent('phone:messageSeen')
AddEventHandler('phone:messageSeen', function(id)
    id = tonumber(id)
    if id ~= nil then
        exports.oxmysql:execute("UPDATE user_messages SET isRead = 1 WHERE id = @id", {['id'] = tonumber(id)})
    end
end)

RPC.register("phone:getMessages", function(pSource, pCid)
    print("called rpc getmessages")
    local phone_number = Await(SQL.execute("SELECT * FROM characters WHERE id = @id",{
        ["id"] = pCid.param
    }))
    local mynumber = math.floor(phone_number[1].phone_number)

    local result = Await(SQL.execute("SELECT * FROM user_messages WHERE receiver = @mynumber OR sender = @mynumber ORDER BY id DESC",{
        ["mynumber"] = mynumber
    }))

    local numbers = {}
    local convos = {}
    local valid

    for k, v in pairs(result) do
        print("for k,v result")
        print(v.sender)
        valid = true
        if tonumber(v.sender) == tonumber(mynumber) then
            print("v sender == my number")
            for i=1, #numbers, 1 do
                print("for loop")
                if tonumber(v.receiver) == tonumber(numbers[i]) then
                    print("v receiver == numbers in for loop valid false")
                    valid = false
                end
            end
            if valid then
                print("valid sender/mynumber")
                table.insert(numbers, v.receiver)
            end
        elseif tonumber(v.receiver) == tonumber(mynumber) then
            print("elseif receiver == mynumber")
            for i=1, #numbers, 1 do
                print("for loop numbers")
                if tonumber(v.sender) == tonumber(numbers[i]) then
                    print("v sender == numbers in for loop valid false")
                    valid = false
                end
            end
            if valid then
                print("valid receiver/mynumber")
                table.insert(numbers, v.sender)
            end
        end
    end
    
    for i, j in pairs(numbers) do
        print("for i,j numbers")
        for g, f in pairs(result) do
            print("for g,f result")
            if j == f.sender or j == f.receiver then
                print("if j == f.sender or j == f.receiver INSERT TABLE BRUH, SO YU CAN DISPLEYYY!")
                table.insert(convos, {
                    id = f.id,
                    sender = f.sender,
                    receiver = f.receiver,
                    message = f.message,
                    date = f.date
                })
                break
            end
        end
    end

    local data = ReverseTable(convos)
    print(json.encode(data), mynumber)
    return data, mynumber
end)

RegisterNetEvent('phone:getSMS')
AddEventHandler('phone:getSMS', function(cid)
    local src = source
    exports.oxmysql:execute("SELECT phone_number FROM characters WHERE id = @id", {['id'] = cid}, function(result2)
        local mynumber = result2[1].phone_number
        exports.oxmysql:execute("SELECT * FROM user_messages WHERE receiver = @mynumber OR sender = @mynumber ORDER BY id DESC", {['mynumber'] = mynumber}, function(result)

            local numbers ={}
            local convos = {}
            local valid
            
            for k, v in pairs(result) do
                valid = true
                if v.sender == mynumber then
                    for i=1, #numbers, 1 do
                        if v.receiver == numbers[i] then
                            valid = false
                        end
                    end
                    if valid then
                        table.insert(numbers, v.receiver)
                    end
                elseif v.receiver == mynumber then
                    for i=1, #numbers, 1 do
                        if v.sender == numbers[i] then
                            valid = false
                        end
                    end
                    if valid then
                        table.insert(numbers, v.sender)
                    end
                end
            end
            
            for i, j in pairs(numbers) do
                for g, f in pairs(result) do
                    if j == f.sender or j == f.receiver then
                        table.insert(convos, {
                            id = f.id,
                            sender = f.sender,
                            receiver = f.receiver,
                            message = f.message,
                            date = f.date
                        })
                        break
                    end
                end
            end
        
            local data = ReverseTable(convos)
            TriggerClientEvent('phone:loadSMS', src, data, mynumber)
        end)
    end)
end)

function ReverseTable(t)
    local reversedTable = {}
    local itemCount = #t
    for k, v in ipairs(t) do
        reversedTable[itemCount + 1 - k] = v
    end
    return reversedTable
end

RegisterServerEvent('phone:getServerTime')
AddEventHandler('phone:getServerTime', function()
    local src= source
    TriggerClientEvent('phone:setServerTime', src, os.date('%H:%M:%S', os.time()))
end)

RegisterNetEvent('phone:sendSMS')
AddEventHandler('phone:sendSMS', function(cid, receiver, message)
    local src = source
    local mynumber = getNumberPhone(cid)
    local target = getIdentifierByPhoneNumber(receiver)
    local Players = GetPlayers()
    --if receiver ~= mynumber then
    exports.oxmysql:execute('INSERT INTO user_messages (sender, receiver, message) VALUES (@sender, @receiver, @message)', {
        ['sender'] = mynumber,
        ['receiver'] = receiver,
        ['message'] = message
    }, function(result)
    end)
    
    for _, player in ipairs(GetPlayers()) do
        local user = exports["warp-base"]:getModule("Player"):GetUser(tonumber(player))
        local characterId = user:getVar("character").id
        if characterId ~= nil then
            if characterId == target then
                TriggerClientEvent('phone:newSMS', tonumber(player), 1, mynumber, message, os.time())
                TriggerClientEvent('DoLongHudText', src, "Message Sent!", 16)
            end
        end
    end
end)

RPC.register('phone:sendSMS', function(pSource, pCid, pReceiver, pMessage)
    local mynumber = getNumberPhone(pCid.param)
    local target = getIdentifierByPhoneNumber(pReceiver.param)
    --local Players = GetPlayers()

    local data = Await(SQL.execute("INSERT INTO user_messages (sender, receiver, message) VALUES (@sender, @receiver, @message)",{
        ["sender"] = mynumber,
        ["receiver"] = pReceiver.param,
        ["message"] = pMessage.param
    }))
    
--[[     for _, player in ipairs(GetPlayers()) do
        local user = exports["warp-base"]:getModule("Player"):GetUser(tonumber(player))
        local characterId = user:getVar("character").id
        if characterId ~= nil then
            if characterId == target then
                TriggerClientEvent('phone:newSMS', tonumber(player), 1, mynumber, message, os.time())
                TriggerClientEvent('DoLongHudText', src, "Message Sent!", 16)
            end
        end
    end ]]
end)

RPC.register("spawncar", function(pSource)
    TriggerEvent("spawncar")
end)

RegisterCommand("tozz", function()
    print("triggered")
    local model = "adder"
    local veh = CreateVehicle(model, -264.56085205078, -991.99346923828, 30.568334579468, 82.006553649902, true, true)
    print(veh)
end)

RegisterNetEvent('spawncar')
AddEventHandler('spawncar', function()
    local veh = CreateVehicle(model, -264.56085205078, -991.99346923828, 30.568334579468, 82.006553649902, true, true)

    print(veh)
end)

RegisterNetEvent('phone:serverGetMessagesBetweenParties')
AddEventHandler('phone:serverGetMessagesBetweenParties', function(sender, receiver, displayName)
    local src = source
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
    local characterId = user:getVar("character").id
    local mynumber = getNumberPhone(characterId)
    exports.oxmysql:execute("SELECT * FROM user_messages WHERE (sender = @sender AND receiver = @receiver) OR (sender = @receiver AND receiver = @sender) ORDER BY id ASC",
    {['sender'] = sender,
    ['receiver'] = receiver},
    function(result)
        if result ~= nil then
            TriggerClientEvent('phone:clientGetMessagesBetweenParties', src, result, displayName, mynumber)
        end
    end)
end)

RPC.register('phone:GetMessagesBetweenParties', function(pSource, pSender, pReceiver, pDisplayName)
	local user = exports["warp-base"]:getModule("Player"):GetUser(pSource)
    local characterId = user:getVar("character").id
    local mynumber = getNumberPhone(characterId)

    local data = Await(SQL.execute("SELECT * FROM user_messages WHERE (sender = @sender AND receiver = @receiver) OR (sender = @receiver AND receiver = @sender) ORDER BY id ASC",{
        ["sender"] = pSender.param,
        ["receiver"] = pReceiver.param
    }))
        if data ~= nil then
            return data, pDisplayName.param, math.floor(mynumber)
        else
            return nil
        end
end)

RegisterNetEvent('phone:StartCallConfirmed')
AddEventHandler('phone:StartCallConfirmed', function(mySourceID)
    local channel = math.random(10000, 99999)
    local src = source

    TriggerClientEvent('phone:callFullyInitiated', mySourceID, mySourceID, src)
    TriggerClientEvent('phone:callFullyInitiated', src, src, mySourceID)

    TriggerClientEvent('phone:addToCall', source, channel)
    TriggerClientEvent('phone:addToCall', mySourceID, channel)

    TriggerClientEvent('phone:id', src, channel)
    TriggerClientEvent('phone:id', mySourceID, channel)
end)


RegisterNetEvent('phone:EndCall')
AddEventHandler('phone:EndCall', function(mySourceID, stupidcallnumberidk, somethingextra)
    local src = source
    TriggerClientEvent('phone:removefromToko', source, stupidcallnumberidk)

    if mySourceID ~= 0 or mySourceID ~= nil then
        TriggerClientEvent('phone:removefromToko', mySourceID, stupidcallnumberidk)
        TriggerClientEvent('phone:otherClientEndCall', mySourceID)
    end

    if somethingextra then
        TriggerClientEvent('phone:otherClientEndCall', src)
    end
end)

RegisterCommand("answer", function(source, args, rawCommand)
    local src = source
    TriggerClientEvent('phone:answercall', src)
end, false)

RegisterCommand("a", function(source, args, rawCommand)
    local src = source
    TriggerClientEvent('phone:answercall', src)
end, false)

RegisterCommand("h", function(source, args, rawCommand)
    local src = source
    TriggerClientEvent('phone:endCalloncommand', src)
end, false)


RegisterCommand("hangup", function(source, args, rawCommand)
    local src = source
    TriggerClientEvent('phone:endCalloncommand', src)
end, false)


function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end
function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end

RPC.register("phone:buyProduct", function(pSource, pCid, pProductId, pProductPrice, pCryptoId)
    takeCrypto(pCid.param, pProductPrice.param, pCryptoId.param)
    local data = Await(SQL.execute("SELECT * FROM dark_market WHERE id = @id",{
        ["id"] = pProductId.param,
    }))

    local itemid = tostring(data[1].product_itemid)

    if not data then return "error" end

    local data1 = Await(SQL.execute("INSERT INTO pickups (cid, itemid) VALUES (@cid, @itemid)", {
        ["cid"] = pCid.param,
        ["itemid"] = itemid
    }))

    if not data1 then return "error" end

    return "success"
end)

RPC.register("phone:buyShungite", function(pSource, pCid, pShungiteAmount, pTotal)
    local user = exports["warp-base"]:getModule("Player"):GetUser(pSource)
    --user:removeBank(pTotal)
    Await(SQL.execute("UPDATE characters SET bank = bank - @total WHERE id = @cid",{
        ["total"] = pTotal.param,
        ["cid"] = pCid.param
    }))
    local data = Await(SQL.execute("UPDATE characters SET shungite = shungite + @shungamount WHERE id = @cid",{
        ["shungamount"] = pShungiteAmount.param,
        ["cid"] = pCid.param
    }))

    return "success"
end)

RPC.register("phone:buyCrypto", function(pSource, pCid, pAmount, pTotal, pCryptoId)
    local user = exports["warp-base"]:getModule("Player"):GetUser(pSource)
    Await(SQL.execute("UPDATE characters SET bank = bank - @total WHERE id = @cid",{
        ["total"] = pTotal.param,
        ["cid"] = pCid.param
    }))

    addCrypto(pCid.param, pAmount.param, pCryptoId.param)

    return "success"
end)

RPC.register("phone:sellCrypto", function(pSource, pCid, pAmount, pTotal, pCryptoId)
    local user = exports["warp-base"]:getModule("Player"):GetUser(pSource)
    Await(SQL.execute("UPDATE characters SET bank = bank + @total WHERE id = @cid",{
        ["total"] = pTotal.param,
        ["cid"] = pCid.param
    }))

    takeCrypto(pCid.param, pAmount.param, pCryptoId.param)

    return "success"
end)

function addCrypto(cid, amount, cryptoid)
    exports.oxmysql:execute("UPDATE user_crypto SET cryptoamount = cryptoamount + @cryptoamount WHERE cryptoid = @cryptoid AND cryptocid = @cryptocid",{['cryptoamount'] = amount, ['cryptoid'] = cryptoid, ['cryptocid'] = cid}, function(result)    
    end)
end

RPC.register("phone:getCryptoNameFromID", function(pSource, pCryptoId)
    local data = Await(SQL.execute("SELECT * FROM cryptos WHERE cryptoid = @cryptoid",{
        ["cryptoid"] = pCryptoId.param
    }))

    return data[1].cryptoname
end)

RPC.register("phone:exchangeShungite", function(pSource, pCid, pShungiteAmount, pReceiver)
    local data1 = Await(SQL.execute("UPDATE characters SET shungite = shungite - @shungamount WHERE id = @cid",{
        ["shungamount"] = pShungiteAmount.param,
        ["cid"] = pCid.param
    }))

    local data2 = Await(SQL.execute("UPDATE characters SET shungite = shungite + @shungamount WHERE phone_number = @receiver",{
        ["shungamount"] = pShungiteAmount.param,
        ["receiver"] = pReceiver.param
    }))

    return "success"
end)

RPC.register("phone:exchangeCrypto", function(pSource, pCid, pAmount, pReceiver, pCryptoId)

    local receiver = Await(SQL.execute("SELECT * FROM characters WHERE phone_number = @phone_number",{
        ["phone_number"] = pReceiver.param
    }))

    local receivercid = receiver[1].id

    takeCrypto(pCid.param, pAmount.param, pCryptoId.param)
    giveCrypto(receivercid, pAmount.param, pCryptoId.param)


    return "success"
end)

function takeCrypto(cid, amount, cryptoid)
    print(cid, amount, cryptoid)
    exports.oxmysql:execute("UPDATE user_crypto SET cryptoamount = cryptoamount - @cryptoamount WHERE cryptoid = @cryptoid AND cryptocid = @cryptocid",{['cryptoamount'] = amount, ['cryptoid'] = cryptoid, ['cryptocid'] = cid}, function(result)    
    end)
end

function giveCrypto(cid, amount, cryptoid)
    print(cid, amount, cryptoid)
    exports.oxmysql:execute("UPDATE user_crypto SET cryptoamount = cryptoamount + @cryptoamount WHERE cryptoid = @cryptoid AND cryptocid = @cryptocid",{['cryptoamount'] = amount, ['cryptoid'] = cryptoid, ['cryptocid'] = cid}, function(result)    
    end)
end

RPC.register("phone:exchangeGuinea", function(pSource, pCid, pGuineaAmount, pReceiver)
    local data1 = Await(SQL.execute("UPDATE characters SET guinea = guinea - @gneamount WHERE id = @cid",{
        ["gneamount"] = pGuineaAmount.param,
        ["cid"] = pCid.param
    }))

    local data2 = Await(SQL.execute("UPDATE characters SET guinea = guinea + @gneamount WHERE phone_number = @receiver",{
        ["gneamount"] = pGuineaAmount.param,
        ["receiver"] = pReceiver.param
    }))

    return "success"
end)

AddEventHandler('playerSpawned',function(source)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    getOrGeneratePhoneNumber(sourcePlayer, identifier, function (myPhoneNumber)
    end)
end)

function getOrGeneratePhoneNumber (sourcePlayer, identifier, cb)
    local sourcePlayer = sourcePlayer
    local identifier = identifier
    local user = exports["warp-base"]:getModule("Player"):GetUser(sourcePlayer)
    local char = user:getVar("character")
    local myPhoneNumber = getNumberPhone(char.id)
    if myPhoneNumber == '0' or myPhoneNumber == nil then
        repeat
            myPhoneNumber = getPhoneRandomNumber()
            local id = getIdentifierByPhoneNumber(myPhoneNumber)
        until id == nil
        exports.oxmysql:execute("UPDATE users SET phone_number = @myPhoneNumber WHERE identifier = @identifier", {
            ['myPhoneNumber'] = myPhoneNumber,
            ['identifier'] = identifier
        }, function ()
            cb(myPhoneNumber)
        end)
    else
        cb(myPhoneNumber)
    end
end

function getPhoneRandomNumber()
    local numBase0 = 4
    local numBase1 = 15
    local numBase2 = math.random(100,999)
    local numBase3 = math.random(1000,9999)
    local num = string.format(numBase0 .. "" .. numBase1 .. "" .. numBase2 .. "" .. numBase3)
    return num
end

RegisterNetEvent('phone:getServerTime')
AddEventHandler('phone:getServerTime', function()
    local hours, minutes, seconds = Citizen.InvokeNative(0x50C7A99057A69748, Citizen.PointerValueInt(), Citizen.PointerValueInt(), Citizen.PointerValueInt())
    TriggerClientEvent('timeheader', -1, tonumber(hours), tonumber(minutes))
end)

--[[ Yellow Pages ]]

RegisterNetEvent('getYP')
AddEventHandler('getYP', function()
    local source = source
    exports.oxmysql:execute('SELECT * FROM phone_yp LIMIT 30', {}, function(yp)
        local deorencoded = json.encode(yp)
        TriggerClientEvent('YellowPageArray', -1, yp)
        TriggerClientEvent('YPUpdatePhone', source)
    end)
end)

RegisterNetEvent('phone:updatePhoneJob')
AddEventHandler('phone:updatePhoneJob', function(advert)
    --local handle = handle
    local src = source
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local mynumber = char.phone_number

    fal = char.first_name .. " " .. char.last_name

    exports.oxmysql:execute('INSERT INTO phone_yp (name, job, phoneNumber) VALUES (@name, @job, @phoneNumber)', {
        ['name'] = fal,
        ['job'] = advert,
        ['phoneNumber'] = mynumber
    }, function(result)
        TriggerClientEvent('refreshYP', src)
    end)
end)

RegisterNetEvent('deleteAllYP')
AddEventHandler('deleteAllYP', function()
    local src = source
    exports.oxmysql:execute('DELETE FROM phone_yp', {}, function (result) end)
end)

RegisterNetEvent('deleteAllTweets')
AddEventHandler('deleteAllTweets', function()
    local src = source
    exports.oxmysql:execute('DELETE FROM tweets', {}, function (result) end)
end)

RegisterNetEvent('deleteAllEmails')
AddEventHandler('deleteAllEmails', function()
    local src = source
    exports.oxmysql:execute('DELETE FROM character_emails', {}, function (result) end)
end)

--Racing
local BuiltMaps = {}
local Races = {}

RegisterServerEvent('racing-global-race')
AddEventHandler('racing-global-race', function(map, laps, counter, reverseTrack, uniqueid, cid, raceName, startTime, mapCreator, mapDistance, mapDescription, street1, street2)
    Races[uniqueid] = { 
        ["identifier"] = uniqueid, 
        ["map"] = map, 
        ["laps"] = laps,
        ["counter"] = counter,
        ["reverseTrack"] = reverseTrack, 
        ["cid"] = cid, 
        ["racers"] = {}, 
        ["open"] = true, 
        ["raceName"] = raceName, 
        ["startTime"] = startTime, 
        ["mapCreator"] = mapCreator, 
        ["mapDistance"] = mapDistance, 
        ["mapDescription"] = mapDescription,
        ["raceComplete"] = false
    }

    TriggerEvent('racing:server:sendData', uniqueid, -1, 'event', 'open')
    local waitperiod = (counter * 1000)
    Wait(waitperiod)
    Races[uniqueid]["open"] = false
    -- if(math.random(1, 10) >= 5) then
    --     TriggerEvent("dispatch:svNotify", {
    --         dispatchCode = "10-94",
    --         firstStreet = street1,
    --         secondStreet = street2,
    --         origin = {
    --             x = BuiltMaps[map]["checkpoints"][1].x,
    --             y = BuiltMaps[map]["checkpoints"][1].y,
    --             z = BuiltMaps[map]["checkpoints"][1].z
    --         }
    -- })
    -- end
    TriggerEvent('racing:server:sendData', uniqueid, -1, 'event', 'close')
end)

RegisterServerEvent('racing-join-race')
AddEventHandler('racing-join-race', function(identifier)
    local src = source
    local player = exports["warp-base"]:getModule("Player"):GetUser(src)
    local char = player:getCurrentCharacter()
    local cid = char.id
    local playername = ""..char.first_name.." "..char.last_name..""
    Races[identifier]["racers"][cid] = {["name"] = PlayerName, ["cid"] = cid, ["total"] = 0, ["fastest"] = 0 }
    TriggerEvent('racing:server:sendData', identifier, src, 'event')
end)

RegisterServerEvent('race:completed2')
AddEventHandler('race:completed2', function(fastestLap, overall, sprint, identifier)
    local src = source
    local player = exports["warp-base"]:getModule("Player"):GetUser(src)
    local char = player:getCurrentCharacter()
    local cid = char.id
    local playername = ""..char.first_name.." "..char.last_name..""
    Races[identifier]["racers"][cid] = { ["name"] = PlayerName, ["cid"] = cid, ["total"] = overall, ["fastest"] = fastestLap}
    Races[identifier].sprint = sprint
    TriggerEvent('racing:server:sendData', identifier, -1, 'event')

    if not Races[identifier]["raceComplete"] then
        exports.oxmysql:execute("UPDATE racing_tracks SET races = races+1 WHERE id = '"..tonumber(Races[identifier].map).."'", function(results)
            if results.changedRows > 0 then
                Races[identifier]["raceComplete"] = true
            end
        end)
    end

    if(Races[identifier].sprint and Races[identifier]["racers"][cid]["total"]) then
        exports.oxmysql:execute("UPDATE racing_tracks SET fastest_sprint = "..tonumber(Races[identifier]["racers"][cid]["total"])..", fastest_sprint_name = '"..tostring(PlayerName).."' WHERE id = "..tonumber(Races[identifier].map).." and (fastest_sprint IS NULL or fastest_sprint > "..tonumber(Races[identifier]["racers"][cid]["total"])..")", function(results)
            if results.changedRows > 0 then
            end
        end)
    else
        exports.oxmysql:execute("UPDATE racing_tracks SET fastest_lap = "..tonumber(Races[identifier]["racers"][cid]["fastest"])..", fastest_name = '"..tostring(PlayerName).."' WHERE id = "..tonumber(Races[identifier].map).." and (fastest_lap IS NULL or fastest_lap > "..tonumber(Races[identifier]["racers"][cid]["fastest"])..")", function(results)
            if results.changedRows > 0 then
            end
        end)
    end
end)


RegisterServerEvent("racing:server:sendData")
AddEventHandler('racing:server:sendData', function(pEventId, clientId, changeType, pSubEvent)
    local dataObject = {
        eventId = pEventId, 
        event = changeType,
        subEvent = pSubEvent,
        data = {}
    }
    if (changeType =="event") then
        dataObject.data = (pEventId ~= -1 and Races[pEventId] or Races)
    elseif (changeType == "map") then
        dataObject.data = (pEventId ~= -1 and BuiltMaps[pEventId] or BuiltMaps)
    end
    TriggerClientEvent("racing:data:set", -1, dataObject)
end)

function buildMaps(subEvent)
    local src = source
    subEvent = subEvent or nil
    BuiltMaps = {}
    exports.oxmysql:execute("SELECT * FROM racing_tracks", {}, function(result)
        for i=1, #result do
            local correctId = tostring(result[i].id)
            BuiltMaps[correctId] = {
                checkpoints = json.decode(result[i].checkpoints),
                track_name = result[i].track_name,
                creator = result[i].creator,
                distance = result[i].distance,
                races = result[i].races,
                fastest_car = result[i].fastest_car,
                fastest_name = result[i].fastest_name,
                fastest_lap = result[i].fastest_lap,
                fastest_sprint = result[i].fastest_sprint, 
                fastest_sprint_name = result[i].fastest_sprint_name,
                description = result[i].description
            }
        end
        local target = -1
        if(subEvent == 'mapUpdate') then
            target = src
        end
        TriggerEvent('racing:server:sendData', -1, target, 'map', subEvent)
    end)
end

RegisterServerEvent('racing-build-maps')
AddEventHandler('racing-build-maps', function()
    buildMaps('mapUpdate')
end)

RegisterServerEvent('racing-map-delete')
AddEventHandler('racing-map-delete', function(deleteID)
    exports.oxmysql.execute("DELETE FROM racing_tracks WHERE id = @id", {
        ['id'] = deleteID })
    Wait(1000)
    buildMaps()
end)

RegisterServerEvent('racing-retreive-maps')
AddEventHandler('racing-retreive-maps', function()
    local src = source
    buildMaps('noNUI', src)
end)

RegisterServerEvent('racing-save-map')
AddEventHandler('racing-save-map', function(currentMap,name,description,distanceMap)
    local src = source
    local player = exports['warp-base']:getModule("Player"):GetUser(src)
    local char = player:getCurrentCharacter()
    local playername = char.first_name .." ".. char.last_name

    -- exports.oxmysql:execute("INSERT INTO racing_tracks_new ('checkpoints', 'creator', 'track_name', 'distance', 'description') VALUES (@currentMap, @creator, @trackname, @distance, @description)",
    -- {['currentMap'] = json.encode(currentMap), ['creator'] = playername, ['trackname'] = name, ['distance'] = distanceMap, ['description'] = description})

    exports.oxmysql:execute("INSERT INTO `racing_tracks` (`checkpoints`, `creator`, `track_name`, `distance`, `description`) VALUES ('"..json.encode(currentMap).."', '"..tostring(playername).."', '"..tostring(name).."', '"..distanceMap.."',  '"..description.."')", function(results)
        Wait(1000)
        buildMaps()
    end)
end)

RegisterServerEvent('phone:RemovePayPhoneMoney')
AddEventHandler('phone:RemovePayPhoneMoney', function()
    local src = source
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
    user:removeMoney(25)
end)

RegisterServerEvent('phone:RemovePhoneJobSourceSend')
AddEventHandler('phone:RemovePhoneJobSourceSend', function(srcsent)
    local src = srcsent
    for i = 1, #YellowPageArray do
        if YellowPageArray[i]
        then 
          local a = tonumber(YellowPageArray[i]["src"])
          local b = tonumber(src)

          if a == b then
            table.remove(YellowPageArray,i)
          end
        end
    end
    TriggerClientEvent("YellowPageArray", -1 , YellowPageArray)
end)

RegisterNetEvent('phone:deleteYP')
AddEventHandler('phone:deleteYP', function(number)
    local src = source
    local user = exports["warp-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local cid = char.id
    local mynumber = getNumberPhone(cid)
    exports.oxmysql:execute('DELETE FROM phone_yp WHERE phoneNumber = @phoneNumber', {
        ['@phoneNumber'] = mynumber
    }, function (result)
        TriggerClientEvent('refreshYP', src)
    end)
end)

-- RegisterServerEvent("stocks:clientvalueupdate")
-- AddEventHandler("stocks:clientvalueupdate", function(table)
--     local src = source
--     local user = exports["warp-base"]:getModule("Player"):GetUser(src)
--     local char = user:getCurrentCharacter()
--     local tableinsert =  json.encode(table)
--     exports.oxmysql:execute("UPDATE characters SET stocks = @stock WHERE id = @cid",{
--         ['@stock'] = tableinsert,
--         ['@cid'] = char.id
--       }, function(data)
--     end)
-- end)

-- RegisterServerEvent("stocks:retrieve")
-- AddEventHandler("stocks:retrieve", function()
--     local src = source
--     local user = exports["warp-base"]:getModule("Player"):GetUser(src)
--     local char = user:getCurrentCharacter()

--     exports.oxmysql:execute("SELECT stocks FROM characters WHERE id = @id", {['id'] = char.id}, function(result)
--         if result[1].stocks then
--         TriggerClientEvent("stocks:clientvalueupdate", src, json.decode(result[1].stocks))
--         end
--     end)
-- end)

-- RegisterServerEvent("phone:stockTradeAttempt")
-- AddEventHandler("phone:stockTradeAttempt", function(index, id, sending)
--     local src = source
--     local user = exports["warp-base"]:getModule("Player"):GetUser(tonumber(id))
--     local char = user:getCurrentCharacter()

--     if user ~= nil then
--         TriggerClientEvent("Crypto:GivePixerium", id, sending)
--     end
-- end)

RegisterServerEvent('phone:triggerPager')
AddEventHandler('phone:triggerPager', function()
    TriggerClientEvent('phone:triggerPager', -1)
end)

RegisterNetEvent('message:tome')
AddEventHandler('message:tome', function(messagehueifh)
    local src = source		
    local first = messagehueifh:sub(1, 3)
    local second = messagehueifh:sub(4, 6)
    local third = messagehueifh:sub(7, 11)

    local msg = first .. "-" .. second .. "-" .. third
    TriggerClientEvent('chatMessage', src, 'Phone Number ', 4, msg)
end)

RegisterNetEvent('message:inDistanceZone')
AddEventHandler('message:inDistanceZone', function(somethingsomething, messagehueifh)
    local src = source		
    local first = messagehueifh:sub(1, 3)
    local second = messagehueifh:sub(4, 6)
    local third = messagehueifh:sub(7, 11)

    local msg = first .. "-" .. second .. "-" .. third
    TriggerClientEvent('chatMessage', somethingsomething, 'Phone Number ', 4, msg)
end)

RegisterCommand("pnum", function(source, args, rawCommand)
    local src = source
    local user = exports["warp-base"]:getModule("Player"):GetUser(src)
    local char = user:getVar("character")
    local srcPhone = getNumberPhone(char.id)
    TriggerClientEvent('sendMessagePhoneN', src, srcPhone)
end, false)

RegisterNetEvent('account:information:sv')
AddEventHandler('account:information:sv', function(cid)
    local src = source
    local licenceTable = {}
    exports.oxmysql:execute("SELECT type, status FROM user_licenses WHERE owner = @owner",{['owner'] = cid}, function(result)
        for i=1, #result do
            table.insert(licenceTable,{
                type = result[i].type,
                status = result[i].status,
            })
        end        
    end)

    exports.oxmysql:execute("SELECT `paycheck` FROM characters WHERE id = @id",{['id'] = cid}, function(data)
        payslips = data[1].paycheck
    end)
    exports.oxmysql:execute("SELECT `casino` FROM characters WHERE id = @id",{['id'] = cid}, function(data)
        pChips = data[1].casino
    end)
    
    Citizen.Wait(100)
    TriggerClientEvent('account:information:cl', src, licenceTable, payslips, pChips)
end)



RegisterServerEvent('group:pullinformation')
AddEventHandler('group:pullinformation', function(groupid,rank)
    local src = source
    exports.oxmysql:execute("SELECT * FROM character_passes WHERE pass_type = @groupid and rank > 0 ORDER BY rank DESC", {['groupid'] = groupid}, function(results)
        if results ~= nil then
            exports.oxmysql:execute("SELECT bank FROM group_banking WHERE group_type = @groupid", {['groupid'] = groupid}, function(result)
                local bank = 0
                if result[1] ~= nil then
                    bank = result[1].bank
                end
                TriggerClientEvent("group:fullList", src, results, bank, groupid)
            end)
        else
            TriggerClientEvent("phone:error", src)
        end
    end)
end)

RegisterServerEvent('server:currentpasses')
AddEventHandler('server:currentpasses', function()
    local src = source
    local user = exports["warp-base"]:getModule("Player"):GetUser(src)
    local ply = user:getCurrentCharacter()
    exports.oxmysql:execute("SELECT * FROM character_passes WHERE cid = @cid", {['cid'] = ply.id}, function(result)
        if result[1] ~= nil then
            TriggerClientEvent("client:passes", src, result)
            if result[1].pass_type == "police" or result[1].pass_type == "ems" then
            else
                TriggerClientEvent("warp-jobmanager:playerBecameJob", src, result[1].pass_type, result[1].pass_type, false)
            end
        end
    end)
end)

RegisterServerEvent('server:givepass')
AddEventHandler('server:givepass', function(pass_type, rank, cid)
    local src = source
    local user = exports["warp-base"]:getModule("Player"):GetUser(src)
    local ply = user:getCurrentCharacter()
    local SrcName = ply.first_name .. " " ..ply.last_name
    exports.oxmysql:execute("SELECT * FROM character_passes WHERE pass_type = ? AND cid = ?", {pass_type, cid}, function(data)
        if not data[1] then
            exports.oxmysql:execute("SELECT * FROM characters WHERE id = ?", {cid}, function(name)
                if name[1] then
                    local name = name[1].first_name.. ' ' ..name[1].last_name
                    exports.oxmysql:execute('INSERT INTO character_passes (cid, rank, name, giver, pass_type, business_name) VALUES (@cid, @rank, @name, @giver, @pass_type, @business_name)', {
                        ['cid'] = cid,
                        ['rank'] = rank,
                        ['name'] = name,
                        ['giver'] = SrcName,
                        ['pass_type'] = pass_type,
                        ['business_name'] = pass_type
                    })
                    exports.oxmysql:execute("SELECT * FROM characters WHERE id = ?", {cid}, function(data2)
                        if data2[1] then
                            local pSteam = data2[1].owner
                            exports.oxmysql:execute('INSERT INTO jobs_whitelist (owner, cid, job, rank) VALUES (@owner, @cid, @job, @rank)', {
                                ['owner'] = pSteam,
                                ['cid'] = cid,
                                ['job'] = pass_type,
                                ['rank'] = rank
                            })

                        end
                    end)
                    TriggerClientEvent("DoLongHudText", src, "You hired " ..name.. " !")
                    TriggerClientEvent("Passes:RequestUpdate", -1, cid)
                else
                    TriggerClientEvent("DoLongHudText", src, "CID does not exist!")
                end
            end)
        else
            exports.oxmysql:execute("UPDATE character_passes SET `rank` = ? WHERE cid = ? AND pass_type = ?", {rank, cid, pass_type})
            TriggerClientEvent("DoLongHudText", src, "You have updated their rank!")
            TriggerClientEvent("Passes:RequestUpdate", -1, cid)
        end
    end)
end)


RegisterServerEvent('server:givepayGroup')
AddEventHandler('server:givepayGroup', function(groupname, amount, cid)
    local src = source
    exports.oxmysql:execute("SELECT * FROM group_banking WHERE group_type = @id", {['id'] = groupname}, function(data)
        if data[1].bank >= tonumber(amount) then
            exports.oxmysql:execute("SELECT paycheck FROM characters WHERE id = @id", {['id'] = cid}, function(result)
                exports.oxmysql:execute("UPDATE characters SET `paycheck` = @paycheck WHERE id = @id", { ['id'] = cid, ['paycheck'] = result[1].paycheck + tonumber(amount)})
                TriggerClientEvent("Yougotpaid", -1, cid)
                exports.oxmysql:execute("UPDATE group_banking SET `bank` = @bank WHERE group_type = @group_type", { ['group_type'] = groupname, ['bank'] = data[1].bank - tonumber(amount)})
            end)
        else
        TriggerClientEvent('DoLongHudText', src, 'You do not have enough money in your account to perform this transaction', 2)
        end
    end)
end)

RegisterServerEvent('server:gankGroup')
AddEventHandler('server:gankGroup', function(groupid, amount)
    local src = source
    local user = exports["warp-base"]:getModule("Player"):GetUser(src)
    if user:getCash() >= tonumber(amount) then
        user:removeMoney(tonumber(amount))
        exports.oxmysql:execute("SELECT * FROM group_banking WHERE group_type = @id", {['id'] = groupid}, function(result)
            exports.oxmysql:execute("UPDATE group_banking SET `bank` = @bank WHERE `group_type` = @id", { ['id'] = groupid, ['bank'] = result[1].bank + amount})
        end)
    end
end)

RegisterServerEvent("get:vehicle:coords")
AddEventHandler("get:vehicle:coords", function(plate)
    local src = source
    exports.oxmysql:execute("SELECT `coords` FROM characters_cars WHERE license_plate = @license_plate", {['license_plate'] = plate}, function(result)
        if result[1] then
            TriggerClientEvent("pass:coords:vehicle", src, json.decode(result[1].coords))
        end
    end)
end)

RPC.register("phone:trackCar", function(pSource, pPlate)
    local data = Await(SQL.execute("SELECT `coords` FROM characters_cars WHERE license_plate = @license_plate",{
        ["license_plate"] = pPlate.param
    }))

    return json.decode(data[1].coords)
end)

RegisterServerEvent("vehicle:coords")
AddEventHandler("vehicle:coords", function(plate, coords)
    local updatecoords = json.encode(coords)
    exports.oxmysql:execute("UPDATE characters_cars SET `coords` = @coords WHERE `license_plate` = @license_plate", { ['license_plate'] = plate, ['coords'] = updatecoords})
end)

RegisterServerEvent("car:Outstanding")
AddEventHandler("car:Outstanding", function()
    local src = source
    exports.oxmysql:execute("SELECT * FROM characters_cars WHERE finance_time = ? AND payments_left >= ? AND repoed = ?", {"0", "1", "0"}, function(result)
        local FinalResult = {}
        for _, v in pairs(result) do
            local vname = v.name
            local plate = v.license_plate
            local finance = v.financed
            local payments = v.payments_left
            owner = v.cid
            exports.oxmysql:execute('SELECT * FROM characters WHERE `id`= ?', {owner}, function(data)
                for _, d in pairs(data) do
                    phonenum = d.phone_number
                    local name = d.first_name .. ' ' .. d.last_name
                    local string = {
                        Plate = ('Vehicle: %s (%s)'):format(vname, plate),
                        AmountDue = ('Amount Due: $%s'):format(math.floor(finance/payments)),
                        cid = ('CID: %s'):format(owner),
                        Info = ('%s | %s'):format(phonenum, name)
                    }
                    
                    table.insert(FinalResult, string)
                    TriggerClientEvent("phone:listunpaid", src, FinalResult)
                end
            end) 
        end
    end)
end)