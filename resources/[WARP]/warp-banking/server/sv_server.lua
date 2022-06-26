RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount, cid ,reason, statement)
  local src = source
  local user = exports["warp-base"]:getModule("Player"):GetUser(src)
  if (tonumber(user:getCash()) >= amount) then
    user:removeMoney(amount)
    user:addBank(amount)
    TriggerEvent("bank:addlog", cid, amount, reason, statement)
    TriggerClientEvent('isPed:UpdateCash', src, user:getCash())
    TriggerEvent('warp-base:bankdeposit', src, amount, tonumber(user:getCash()), tonumber(user:getBalance()))
  else
      TriggerClientEvent('DoShortHudText', src, 'You do not have enough money to deposit!', 2)
  end
end)


RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount, cid , reason, statement)
  local src = source
  local user = exports["warp-base"]:getModule("Player"):GetUser(src)
  local char = user:getCurrentCharacter()
  if (tonumber(user:getBalance()) >= amount) then
    user:removeBank(amount)
    user:addMoney(amount)
    TriggerEvent("bank:addlog", cid, amount, reason, statement)
    TriggerClientEvent("banking:updateBalance", src, char.bank)
    TriggerClientEvent('isPed:UpdateCash', src, user:getCash())
    TriggerEvent('warp-base:bankwidthdraw', src, amount, tonumber(user:getCash()), tonumber(user:getBalance()))
  else
    TriggerClientEvent('DoShortHudText', src, 'You dont have enough money to withdraw!', 2)
  end
end)

RegisterServerEvent('bank:givemecash')
AddEventHandler('bank:givemecash', function(reciever, amount)
  local src = source
  local user = exports["warp-base"]:getModule("Player"):GetUser(src)
  local player = exports["warp-base"]:getModule("Player"):GetUser(tonumber(reciever))
  if tonumber(amount) <= user:getCash() then
    user:removeMoney(amount)
    player:addMoney(amount)    
    local pSteam = 'None'
    local pDiscord = 'None'
    local pName = GetPlayerName(tonumber(receiver))
    local pIdentifiers = GetPlayerIdentifiers(tonumber(receiver))
    for k, v in pairs(pIdentifiers) do
        if string.find(v, 'steam') then pSteam = v end
        if string.find(v, 'discord') then pDiscord = v end
    end
    TriggerEvent('warp-base:bankgivecash', src, tonumber(receiver), pName, pSteam, pDiscord, amount, tonumber(user:getCash()), tonumber(user:getBalance()), amount, tonumber(player:getCash()), tonumber(player:getBalance()))
  else
    TriggerClientEvent('DoShortHudText', src, 'Not enough money', 2)
  end
end)

RegisterServerEvent('bank:transfer')
AddEventHandler('bank:transfer', function(receiver, amount)
    local user = exports["warp-base"]:getModule("Player"):GetUser(source)
    local player = exports["warp-base"]:getModule("Player"):GetUser(tonumber(receiver))

    if tonumber(amount) <= user:getBalance() then
        user:removeBank(amount)
        player:addBank(amount)
        local pSteam = 'None'
        local pDiscord = 'None'
        local pName = GetPlayerName(tonumber(receiver))
        local pIdentifiers = GetPlayerIdentifiers(tonumber(receiver))
        for k, v in pairs(pIdentifiers) do
            if string.find(v, 'steam') then pSteam = v end
            if string.find(v, 'discord') then pDiscord = v end
        end
        TriggerEvent('warp-base:banktransfer', source, tonumber(receiver), pName, pSteam, pDiscord, amount, tonumber(user:getCash()), tonumber(user:getBalance()), amount, tonumber(player:getCash()), tonumber(player:getBalance()))
    else
        TriggerClientEvent('DoShortHudText', source, 'Not enough money', 2)
    end
end)

RegisterCommand('cash', function(source, args)
  local src = source
  local user = exports["warp-base"]:getModule("Player"):GetUser(src)
  local char = user:getCurrentCharacter()
  local cash = char.cash
  TriggerClientEvent('banking:updateCash', source, cash, true)
  TriggerClientEvent('isPed:UpdateCash', src, cash)
end)

RegisterServerEvent('bank:withdrawAmende')
AddEventHandler('bank:withdrawAmende', function(amount)
  local src = source
  local user = exports["warp-base"]:getModule("Player"):GetUser(src)
  local char = user:getCurrentCharacter()
  user:removeMoney(amount)
end)

RegisterCommand('givecash', function(source, args)
  local src = source
  local user = exports["warp-base"]:getModule("Player"):GetUser(src)
  local char = user:getCurrentCharacter()
  local cash = char.cash
  if tonumber(args[1]) == src or tonumber(args[2]) <= 0 then
    TriggerClientEvent('DoShortHudText', src, 'Invaild Action!', 2)
  else
    if tonumber(args[2]) then
      TriggerClientEvent("bank:givecash", src, args[1], tonumber(args[2]))
    end
  end
end)

RegisterServerEvent("bank:addlog")
AddEventHandler("bank:addlog", function(cid, amount, reason, statement, bussiness)
  if statement == false then
    if bussiness == "1" then
      exports.oxmysql:execute('INSERT INTO __banking_logs (cid, amount, reason, withdraw) VALUES(?, ?, ?, ?)', {cid, amount, reason, "1", '1'})
    else
      exports.oxmysql:execute('INSERT INTO __banking_logs (cid, amount, reason, withdraw) VALUES(?, ?, ?, ?)', {cid, amount, reason, "0"})
    end
  else
    if bussiness == "1" then
      exports.oxmysql:execute('INSERT INTO __banking_logs (cid, amount, reason, withdraw) VALUES(?, ?, ?, ?)', {cid, amount, reason, "1", '1'})
    else
      exports.oxmysql:execute('INSERT INTO __banking_logs (cid, amount, reason, withdraw) VALUES(?, ?, ?, ?)', {cid, amount, reason, "0"})
    end
  end
end)

RegisterServerEvent('bank:BussinessDeposit')
AddEventHandler("bank:BussinessDeposit", function(bussiness, amount, cid, reason, statement)
  local src = source
  local user = exports["warp-base"]:getModule("Player"):GetUser(src)
  if user:getCash() >= tonumber(amount) or user:getCash() > 0 then
    exports.oxmysql:execute('SELECT * FROM group_banking WHERE `group_type`= ?', {bussiness}, function(data)
      if data[1] then
        if user:getCash() >= tonumber(amount) then
          user:removeMoney(tonumber(amount))
          local updated = data[1].bank + tonumber(amount)
          exports.oxmysql:execute("UPDATE group_banking SET `bank` = @bank WHERE `group_type` = @group_type", {
            ['@bank'] = updated,
            ['@group_type'] = bussiness
          })
          TriggerEvent("bank:addlog", cid, amount, reason, statement, "1")
          Citizen.Wait(1000)
          TriggerClientEvent('isPed:UpdateCash', src, user:getCash())
        else
          TriggerClientEvent('DoLongHudText', src, 'Not enough money on you!', 2)
        end
      end
    end)
  else
    TriggerClientEvent('DoLongHudText', src, 'Not enough money on you!', 2)
  end
end)

RegisterServerEvent("society:update", function(amt, account, case)
  local pAmount = tonumber(amt)
  if case == "remove" then
      exports.oxmysql:execute("SELECT `bank` FROM group_banking WHERE group_type = ?", {account}, function(data)	
          local NewAmount = data[1].bank - pAmount
          exports.oxmysql:execute("UPDATE group_banking SET `bank` = ? WHERE group_type = ?", {NewAmount, account})
      end)
  elseif case == "add" then
      exports.oxmysql:execute("SELECT `bank` FROM group_banking WHERE group_type = ?", {account}, function(data)	
          local NewAmount = data[1].bank + pAmount
          exports.oxmysql:execute("UPDATE group_banking SET `bank` = ? WHERE group_type = ?", {NewAmount, account})
      end)
  end
end)

RegisterServerEvent('bank:BussinessWithdraw')
AddEventHandler("bank:BussinessWithdraw", function(bussiness, amount, cid ,reason, statement)
  local src = source
  local user = exports["warp-base"]:getModule("Player"):GetUser(src)
  exports.oxmysql:execute('SELECT * FROM group_banking WHERE `group_type`= ?', {bussiness}, function(data)
    if data[1] then
      if data[1].bank >= tonumber(amount) then
        local updatedBal = data[1].bank - tonumber(amount)
        exports.oxmysql:execute("UPDATE group_banking SET `bank` = @bank WHERE `group_type` = @group_type", {
          ['@bank'] = updatedBal,
          ['@group_type'] = bussiness
        })
        TriggerEvent("bank:addlog", cid, amount, reason, statement, "1")
        TriggerClientEvent("bank:getBussinessCashBal", src, updatedBal)
        user:addMoney(tonumber(amount))
        Citizen.Wait(1000)
        TriggerClientEvent('isPed:UpdateCash', src, user:getCash())
      else
        TriggerClientEvent('DoLongHudText', src, 'Not enough money in the bank!', 2)
      end
    end
  end)
end)

RegisterServerEvent("bank:get:money")
AddEventHandler("bank:get:money", function(bussiness)
  local src = source
  local user = exports["warp-base"]:getModule("Player"):GetUser(src)
  local char = user:getCurrentCharacter()
  exports.oxmysql:execute('SELECT * FROM character_passes WHERE `cid`= ?', {char.id}, function(pre)
    if pre[1] then
      exports.oxmysql:execute('SELECT * FROM group_banking WHERE `group_type`= ?', {bussiness}, function(data)
        if data[1] then
          TriggerClientEvent("bank:getBussinessCashBal", src, data[1].bank)
          TriggerClientEvent("bank:getbankAccountNumber", src, char.id)
        end
      end)
    end
  end)
end)

RegisterServerEvent("bank:getLogs")
AddEventHandler("bank:getLogs", function()
  local srcID = source
  local user = exports["warp-base"]:getModule("Player"):GetUser(srcID)
  local char = user:getCurrentCharacter()
  exports.oxmysql:execute('SELECT * FROM __banking_logs WHERE `cid`= ?', {char.id}, function(data)
    if data[1] then
      TriggerClientEvent("bank:getLogsUpdates", srcID, data)
    end
  end)
end)

function UpdateSociety(amt, account, case)
  if account == "car_shop" and case == "add" then
      local pNewAmt = math.ceil(amt / 3)
      TriggerEvent('society:update', pNewAmt, account, case)
  else
      TriggerEvent('society:update', amt, account, case)
  end
end

function UpdateSociety(amt, account, case)
  if account == "redline_performance" and case == "add" then
      local pNewAmt = math.ceil(amt / 3)
      TriggerEvent('society:update', pNewAmt, account, case)
  else
      TriggerEvent('society:update', amt, account, case)
  end
end

function UpdateBennys(amt, account, case)
  if account == "bennys_motors" and case == "add" then
      local pNewAmt = math.ceil(amt / 3)
      TriggerEvent('society:update', pNewAmt, account, case)
  else
      TriggerEvent('society:update', amt, account, case)
  end
end

exports('UpdateSociety', UpdateSociety)

exports('UpdateBennys', UpdateBennys)

RegisterServerEvent("bank:get:balance")
AddEventHandler("bank:get:balance", function()
  local src = source
  local user = exports["warp-base"]:getModule("Player"):GetUser(src)
  local char = user:getCurrentCharacter()
  Citizen.Wait(2000)
  TriggerClientEvent("banking:updateBalance", src, char.bank)
  TriggerClientEvent('banking:updateCash', src, char.cash)
  TriggerClientEvent("bank:getbankAccountNumber", src, char.id)
end)

function sendToDiscord5(name, message, color)
  local connect = {
    {
      ["color"] = color,
      ["title"] = "**".. name .."**",
      ["description"] = message,
    }
  }
  PerformHttpRequest(DISCORD_WEBHOOK5, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME5, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent("warp-banking:GetCharacterBanking")
AddEventHandler("warp-banking:GetCharacterBanking", function(cid)
    local src = source
    exports.oxmysql:execute('SELECT * FROM character_passes WHERE `cid`= ?', {cid}, function(data)
    if data[1] ~= nil then 
      TriggerClientEvent('warp-banking:UpdatedAccounts', src, data)
    end
  end)
end)

RegisterServerEvent('cash:remove')
AddEventHandler('cash:remove', function(src, amount)
    local user = exports["warp-base"]:getModule("Player"):GetUser(src)
    user:removeMoney(tonumber(amount))
end)

RegisterServerEvent('warp-banking:addMoney')
AddEventHandler('warp-banking:addMoney', function(amount)
    local src = source
    local user = exports["warp-base"]:getModule("Player"):GetUser(src)
    user:addMoney(tonumber(amount))
end)

RegisterServerEvent('warp-banking:removeMoney')
AddEventHandler('warp-banking:removeMoney', function(amount)
    local src = source
    local user = exports["warp-base"]:getModule("Player"):GetUser(src)
    user:removeMoney(tonumber(amount))
end)