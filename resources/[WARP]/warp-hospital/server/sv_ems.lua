RegisterServerEvent('admin:revivePlayer')
AddEventHandler('admin:revivePlayer', function(target)
	if target ~= nil then
		TriggerClientEvent('admin:revivePlayerClient', target)
		TriggerClientEvent('warp-hospital:client:RemoveBleed', target) 
        TriggerClientEvent('warp-hospital:client:ResetLimbs', target)
	end
end)

RegisterServerEvent('warp-ems:heal')
AddEventHandler('warp-ems:heal', function(target)
	TriggerClientEvent('warp-ems:heal', target) 	
end)

RegisterServerEvent('warp-ems:heal2')
AddEventHandler('warp-ems:heal2', function(target)
	TriggerClientEvent('warp-ems:big', target)
end)