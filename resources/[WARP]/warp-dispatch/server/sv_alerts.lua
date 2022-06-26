RegisterServerEvent("warp-dispatch:teenA")
AddEventHandler("warp-dispatch:teenA",function(targetCoords)
    TriggerClientEvent('warp-dispatch:policealertA', -1, targetCoords)
	return
end)

RegisterServerEvent("warp-dispatch:teenB")
AddEventHandler("warp-dispatch:teenB",function(targetCoords)
    TriggerClientEvent('warp-dispatch:policealertB', -1, targetCoords)
	return
end)

RegisterServerEvent("warp-dispatch:teenpanic")
AddEventHandler("warp-dispatch:teenpanic",function(targetCoords)
    TriggerClientEvent('warp-dispatch:panic', -1, targetCoords)
	return
end)

RegisterServerEvent("warp-dispatch:empanic")
AddEventHandler("warp-dispatch:empanic",function(targetCoords)
    TriggerClientEvent('warp-dispatch:epanic', -1, targetCoords)
	return
end)

RegisterServerEvent("warp-dispatch:gaexplosion")
AddEventHandler("warp-dispatch:gaexplosion",function(targetCoords)
    TriggerClientEvent('warp-dispatch:gexplosion', -1, targetCoords)
	return
end)

RegisterServerEvent("warp-dispatch:fourA")
AddEventHandler("warp-dispatch:fourA",function(targetCoords)
    TriggerClientEvent('warp-dispatch:tenForteenA', -1, targetCoords)
	return
end)

RegisterServerEvent("warp-dispatch:fourB")
AddEventHandler("warp-dispatch:fourB",function(targetCoords)
    TriggerClientEvent('warp-dispatch:tenForteenB', -1, targetCoords)
	return
end)

RegisterServerEvent("warp-dispatch:downperson")
AddEventHandler("warp-dispatch:downperson",function(targetCoords)
    TriggerClientEvent('warp-dispatch:downalert', -1, targetCoords)
	return
end)

-- RegisterServerEvent("warp-dispatch:assistancen")
-- AddEventHandler("warp-dispatch:assistancen",function(targetCoords)
--     TriggerClientEvent('warp-dispatch:assistance', -1, targetCoords)
-- 	return
-- end)


RegisterServerEvent("warp-dispatch:sveh")
AddEventHandler("warp-dispatch:sveh",function(targetCoords)
    TriggerClientEvent('warp-dispatch:vehiclesteal', -1, targetCoords)
	return
end)

RegisterServerEvent("warp-dispatch:svCarBoost")
AddEventHandler("warp-dispatch:svCarBoost", function(targetCoords)
    TriggerClientEvent("warp-dispatch:carBoostBlip", -1, targetCoords)
end)

RegisterServerEvent("warp-dispatch:svCarBoostTracker")
AddEventHandler("warp-dispatch:svCarBoostTracker", function(targetCoords)
    TriggerClientEvent("warp-dispatch:carBoostBlipTracker", -1, targetCoords)
end)

RegisterServerEvent("warp-dispatch:shoot")
AddEventHandler("warp-dispatch:shoot",function(targetCoords)
    TriggerClientEvent('warp-dispatch:gunShot', -1, targetCoords)
	return
end)

-- RegisterServerEvent("warp-dispatch:figher")
-- AddEventHandler("warp-dispatch:figher",function(targetCoords)
--     TriggerClientEvent('vrp-outlawalert:combatInProgress', -1, targetCoords)
-- 	return
-- end)

RegisterServerEvent("warp-dispatch:storerob")
AddEventHandler("warp-dispatch:storerob",function(targetCoords)
    TriggerClientEvent('warp-dispatch:storerobbery', -1, targetCoords)
	return
end)

RegisterServerEvent("warp-dispatch:houserob")
AddEventHandler("warp-dispatch:houserob",function(targetCoords)
    TriggerClientEvent('warp-dispatch:houserobbery2', -1, targetCoords)
	return
end)

RegisterServerEvent("warp-dispatch:tbank")
AddEventHandler("warp-dispatch:tbank",function(targetCoords)
    TriggerClientEvent('warp-dispatch:banktruck', -1, targetCoords)
	return
end)

RegisterServerEvent("warp-dispatch:robjew")
AddEventHandler("warp-dispatch:robjew",function()
    TriggerClientEvent('warp-dispatch:jewelrobbey', -1)
	return
end)

-- RegisterServerEvent("warp-dispatch:bjail")
-- AddEventHandler("warp-dispatch:bjail",function()
--     TriggerClientEvent('warp-dispatch:jewelrobbey', -1)
-- 	return
-- end)


RegisterServerEvent("warp-dispatch:bankrobberyfuck")
AddEventHandler("warp-dispatch:bankrobberyfuck",function(targetCoords)
    TriggerClientEvent('warp-dispatch:bankrob', -1, targetCoords)
	return
end)

RegisterServerEvent("warp-dispatch:drugg23")
AddEventHandler("warp-dispatch:drugg23",function(targetCoords)
    TriggerClientEvent('warp-dispatch:drugdealreport', -1, targetCoords)
	return
end)


RegisterServerEvent("warp-dispatch:bobbycat")
AddEventHandler("warp-dispatch:bobbycat",function(targetCoords)
    TriggerClientEvent('warp-dispatch:bobcatreport', -1, targetCoords)
	return
end)



RegisterServerEvent("warp-dispatch:vaulttt")
AddEventHandler("warp-dispatch:vaulttt",function(targetCoords)
    TriggerClientEvent('warp-dispatch:vaultreport', -1, targetCoords)
	return
end)

RegisterServerEvent("warp-dispatch:unauth_plane")
AddEventHandler("warp-dispatch:unauth_plane",function(targetCoords)
    TriggerClientEvent('warp-dispatch:coke_plane', -1, targetCoords)
	return
end)