RegisterNetEvent('warp-badge:client:showbadge')
AddEventHandler('warp-badge:client:showbadge', function(pid, image, grade, name)
  local person_src = pid
  local pid = GetPlayerFromServerId(person_src)
	local targetPed = GetPlayerPed(pid)
	local myCoords = GetEntityCoords(PlayerPedId())
    local targetCoords = GetEntityCoords(targetPed)
    if pid ~= -1 then
	    if GetDistanceBetweenCoords(myCoords, targetCoords, true) <= 1.5 then
		SendNUIMessage({ action = "open", img = image, grade = grade, name = name, args = cidInformation})
		Citizen.Wait(7500)
		SendNUIMessage({
			action = "close"
		})
       end
    end
end)

RegisterNetEvent('warp-badge:client:getbadge')
AddEventHandler('warp-badge:client:getbadge', function()
	TriggerServerEvent("warp-pdbadge:buy")
end)