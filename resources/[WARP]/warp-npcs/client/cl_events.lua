RegisterNetEvent("warp-npcs:set:ped")
AddEventHandler("warp-npcs:set:ped", function(pNPCs)
  if type(pNPCs) == "table" then
    for _, ped in ipairs(pNPCs) do
      RegisterNPC(ped, 'warp-npcs')
      EnableNPC(ped.id)
    end
  else
    RegisterNPC(ped, 'warp-npcs')
    EnableNPC(ped.id)
  end
end)

RegisterNetEvent("warp-npcs:ped:giveStolenItems")
AddEventHandler("warp-npcs:ped:giveStolenItems", function(pArgs, pEntity, pEntityFlags, pEntityCoords)
  local npcCoords = GetEntityCoords(pEntity)
  local finished = exports["warp-taskbar"]:taskBar(15000, "Preparing to receive goods, don't move.")
  if finished == 100 then
    if #(GetEntityCoords(PlayerPedId()) - npcCoords) < 2.0 then
      TriggerEvent("server-inventory-open", "1", "Stolen-Goods-1")
    else
      TriggerEvent("DoLongHudText", "You moved too far you idiot.", 2)
    end
  end
end)

RegisterNetEvent("warp-npcs:ped:exchangeRecycleMaterial")
AddEventHandler("warp-npcs:ped:exchangeRecycleMaterial", function(pArgs, pEntity, pEntityFlags, pEntityCoords)
  local npcCoords = GetEntityCoords(pEntity)
  local finished = exports["warp-taskbar"]:taskBar(3000, "Preparing to exchange material, don't move.")
  if finished == 100 then
    if #(GetEntityCoords(PlayerPedId()) - npcCoords) < 2.0 then
      TriggerEvent("server-inventory-open", "141", "Craft");
    else
      TriggerEvent("DoLongHudText", "You moved too far you idiot.", 2)
    end
  end
end)

RegisterNetEvent("warp-npcs:ped:signInJob")
AddEventHandler("warp-npcs:ped:signInJob", function(pArgs, pEntity, pEntityFlags, pEntityCoords)
  if #pArgs == 0 then
    local npcId = DecorGetInt(pEntity, 'NPC_ID')
    if npcId == `news_reporter` then
      TriggerServerEvent("jobssystem:jobs", "news")
    elseif npcId == `head_stripper` then
      TriggerServerEvent("jobssystem:jobs", "entertainer")
    end
  else
    TriggerServerEvent("jobssystem:jobs", "unemployed")
  end
end)

RegisterNetEvent("warp-npcs:ped:paycheckCollect")
AddEventHandler("warp-npcs:ped:paycheckCollect", function(pArgs, pEntity, pEntityFlags, pEntityCoords)
  TriggerServerEvent("server:paySlipPickup")
end)

RegisterNetEvent("warp-npcs:ped:receiptTradeIn")
AddEventHandler("warp-npcs:ped:receiptTradeIn", function(pArgs, pEntity, pEntityFlags, pEntityCoords)
  local cid = exports["isPed"]:isPed("cid")
  RPC.execute("ab-inventory:tradeInReceipts", cid, accountTarget)
end)

RegisterNetEvent("warp-npcs:ped:sellStolenItems")
AddEventHandler("warp-npcs:ped:sellStolenItems", function()
  RPC.execute("ab-inventory:sellStolenItems")
end)

RegisterNetEvent("warp-npcs:ped:keeper")
AddEventHandler("warp-npcs:ped:keeper", function(pArgs, pEntity, pEntityFlags, pEntityCoords)
  TriggerEvent("server-inventory-open", pArgs[1], "Shop");
end)


TriggerServerEvent("warp-npcs:location:fetch")

AddEventHandler("warp-npcs:ped:weedSales", function(pArgs, pEntity, pEntityFlags, pEntityCoords)
  local result, message = RPC.execute("warp-npcs:weedShopOpen")
  if not result then
    TriggerEvent("DoLongHudText", message, 2)
    return
  end
  TriggerEvent("server-inventory-open", "44", "Shop");
end)

AddEventHandler("warp-npcs:ped:licenseKeeper", function()
  RPC.execute("warp-npcs:purchaseDriversLicense")
end)

AddEventHandler("warp-npcs:ped:openDigitalDenShop", function()
  TriggerEvent("server-inventory-open", "42073", "Shop")
end)
RegisterNetEvent("warp-npcs:ped:giveidcard")
AddEventHandler("warp-npcs:ped:giveidcard", function()
  RPC.execute("warp-npcs:idcard")
end)

RegisterNetEvent("warp-npcs:ped:garbagejob")
AddEventHandler("warp-npcs:ped:garbagejob", function(pArgs, pEntity, pEntityFlags, pEntityCoords)
  RPC.execute("warp-npcs:GarbageVals")
end)


