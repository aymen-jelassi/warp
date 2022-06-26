RPC.register("warp-garages:selectMenu", function(pGarage, pJob)
	local pSrc = source
	if pGarage == 'garagepd' then
		if pJob == 'police' or pJob == 'state' or pJob == 'sheriff' then
			TriggerClientEvent('warp-context:sendMenu', pSrc, {
				{
					id = 1,
					header = "Shared Vehicles",
					txt = "List of all the shared vehicles.",
					params = {
						arrow = true,
						event = "warp-garages:openSharedGarage"
					}
				},
				{
					id = 2,
					header = "Personal Vehicles",
					txt = "List of all the personal vehicles.",
					params = {
						arrow = true,
						event = "warp-garages:openPersonalGarage"
					}
				},
			})
		else
			TriggerClientEvent('warp-context:sendMenu', pSrc, {
				{
					id = 1,
					header = "Personal Vehicles",
					txt = "List of all the personal vehicles.",
					params = {
						arrow = true,
						event = "warp-garages:openPersonalGarage"
					}
				},
			})
		end
	elseif pGarage == 'garagesandy' then
		if pJob == 'police' or pJob == 'state' or pJob == 'sheriff' then
			TriggerClientEvent('warp-context:sendMenu', pSrc, {
				{
					id = 1,
					header = "Shared Vehicles",
					txt = "List of all the shared vehicles.",
					params = {
						arrow = true,
						event = "warp-garages:openSharedGarage"
					}
				},
				{
					id = 2,
					header = "Personal Vehicles",
					txt = "List of all the personal vehicles.",
					params = {
						arrow = true,
						event = "warp-garages:openPersonalGarage"
					}
				},
			})
		else
			TriggerClientEvent('warp-context:sendMenu', pSrc, {
				{
					id = 1,
					header = "Personal Vehicles",
					txt = "List of all the personal vehicles.",
					params = {
						arrow = true,
						event = "warp-garages:openPersonalGarage"
					}
				},
			})
		end
	elseif pGarage == 'garageems' then
		if pJob == 'ems' then
			TriggerClientEvent('warp-context:sendMenu', pSrc, {
				{
					id = 1,
					header = "Shared Vehicles",
					txt = "List of all the shared vehicles.",
					params = {
						arrow = true,
						event = "warp-garages:openSharedGarage"
					}
				},
				{
					id = 2,
					header = "Personal Vehicles",
					txt = "List of all the personal vehicles.",
					params = {
						arrow = true,
						event = "warp-garages:openPersonalGarage"
					}
				},
			})
		else
			TriggerClientEvent('warp-context:sendMenu', pSrc, {
				{
					id = 1,
					header = "Personal Vehicles",
					txt = "List of all the personal vehicles.",
					params = {
						arrow = true,
						event = "warp-garages:openPersonalGarage"
					}
				},
			})
		end
	else
		TriggerClientEvent('warp-context:sendMenu', pSrc, {
			{
				id = 1,
				header = "Personal Vehicles",
				txt = "List of all the personal vehicles.",
				params = {
					arrow = true,
					event = "warp-garages:openPersonalGarage"
				}
			},
		})
	end
end)

RPC.register("warp-garages:select", function(pGarage)
    local pSrc = source
    local user = exports["warp-base"]:getModule("Player"):GetUser(pSrc)
    local char = user:getCurrentCharacter()
	exports.oxmysql:execute('SELECT * FROM characters_cars WHERE cid = @cid AND current_garage = @garage', { ['@cid'] = char.id, ['@garage'] = pGarage}, function(vehicles)
        if vehicles[1] ~= nil then
            for i = 1, #vehicles do
				if vehicles[i].vehicle_state ~= "Out" then
					TriggerClientEvent('warp-context:sendMenu', pSrc, {
						{
							id = vehicles[i].id,
							header = vehicles[i].model,
							txt = "Plate: "..vehicles[i].license_plate,
							params = {
								event = "warp-garages:attempt:spawn",
								args = {
									id = vehicles[i].id,
									engine_damage = vehicles[i].engine_damage,
									current_garage = vehicles[i].current_garage,
									body_damage = vehicles[i].body_damage,
									model = vehicles[i].model,
									fuel = vehicles[i].fuel, 
									customized = vehicles[i].data,
									plate = vehicles[i].license_plate
								}
							}
						},
					})
					pPassed = json.encode(vehicles)
				end
            end
        else
			TriggerClientEvent('warp-context:sendMenu', pSrc, {
				{
					id = 1,
					header = "No Vehicles",
					txt = "All vehicles are out!"
				},
			})
            return
        end
	end)
end)

RPC.register("warp-garages:selectSharedGarage", function(pGarage, pJob)
    local pSrc = source
    local user = exports["warp-base"]:getModule("Player"):GetUser(pSrc)
    local char = user:getCurrentCharacter()
	if pJob == 'police' or pJob == 'state' or pJob == 'sheriff' then
		pType = 'law'
	elseif pJob == 'ems' then
		pType = 'medical'
	end
	exports.oxmysql:execute('SELECT * FROM characters_cars WHERE garage_info = @garage_info AND current_garage = @garage', { ['@garage_info'] = pType, ['@garage'] = pGarage}, function(vehicles)
        if vehicles[1] ~= nil then
            for i = 1, #vehicles do
				if vehicles[i].vehicle_state ~= "Out" then
					TriggerClientEvent('warp-context:sendMenu', pSrc, {
						{
							id = vehicles[i].id,
							header = vehicles[i].name,
							txt = "Plate: "..vehicles[i].license_plate,
							params = {
								event = "warp-garages:attempt:spawn",
								args = {
									id = vehicles[i].id,
									engine_damage = vehicles[i].engine_damage,
									current_garage = vehicles[i].current_garage,
									body_damage = vehicles[i].body_damage,
									model = vehicles[i].model,
									fuel = vehicles[i].fuel, 
									customized = vehicles[i].data,
									plate = vehicles[i].license_plate
								}
							}
						},
					})
					pPassed = json.encode(vehicles)
				end
            end
        else
			TriggerClientEvent('warp-context:sendMenu', pSrc, {
				{
					id = 1,
					header = "No Vehicles",
					txt = "All vehicles are out!"
				},
			})
            return
        end
	end)
end)


RPC.register("warp-garages:attempt:sv", function(data)
    local pSrc = source
    local user = exports["warp-base"]:getModule("Player"):GetUser(pSrc)
    local char = user:getCurrentCharacter()


    local enginePercent = data.engine_damage / 10
	local bodyPercent = data.body_damage / 10
	TriggerClientEvent('warp-context:sendMenu', pSrc, {
		{
			id = 1,
			header = "< Go Back",
			txt = "Return to your list of all your vehicles.",
			params = {
				event = "warp-garages:open"
			}
		},
		{
			id = 2,
			header = "Take Out Vehicle",
			txt = "Spawn the vehicle!",
			params = {
				event = "warp-garages:takeout",
				args = {
					pVeh = data.id
				}
			}
			
		},
		{
			id = 3,
			header = "Vehicle Status",
			txt = "Garage: "..data.current_garage.." | Engine: "..enginePercent.."% | Body: "..bodyPercent.."%"
		},
	})
end)

RPC.register("warp-garages:spawned:get", function(pID)
    local pSrc = source
    local user = exports["warp-base"]:getModule("Player"):GetUser(pSrc)
    local char = user:getCurrentCharacter()
	exports.oxmysql:execute('SELECT * FROM characters_cars WHERE id = @id', {['@id'] = pID}, function(vehicles)
		args = {
			model = vehicles[1].model,
			fuel = vehicles[1].fuel, 
			customized = vehicles[1].data,
			plate = vehicles[1].license_plate,
		}

		if vehicles[1].current_garage == "Impound Lot" and vehicles[1].vehicle_state == 'Normal Impound' then
			if user:getCash() >= 100 then
				user:removeMoney(100)
				TriggerClientEvent("warp-garages:attempt:spawn", pSrc, args, true)
			else
				TriggerClientEvent('DoLongHudText', pSrc, "You need $100", 2)
				return
			end
		else
			TriggerClientEvent("warp-garages:attempt:spawn", pSrc, args, true)
		end

	end)
end)

RPC.register("warp-garages:states", function(pState, plate, garage, fuel)
    local pSrc = source
	exports.oxmysql:execute('SELECT * FROM characters_cars WHERE license_plate = ?', {plate}, function(pIsValid)
		if pIsValid[1] then
			pExist = true
			exports.oxmysql:execute("UPDATE characters_cars SET vehicle_state = @state, current_garage = @garage, fuel = @fuel, coords = @coords WHERE license_plate = @plate", {
				['garage'] = garage, 
				['state'] = pState, 
				['plate'] = plate,  
				['fuel'] = fuel, 
				['coords'] = nil
			})
		else
			pExist = false
		end
	end)

	Citizen.Wait(100)
	return pExist
end)

RegisterServerEvent('updateVehicle')
AddEventHandler('updateVehicle', function(vehicleMods,plate)
	vehicleMods = json.encode(vehicleMods)
	exports.oxmysql:execute("UPDATE characters_cars SET data=@mods WHERE license_plate = @plate",{['mods'] = vehicleMods, ['plate'] = plate})
end)


RegisterNetEvent("garages:loaded:in", function()
    local src = source
    local user = exports["warp-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local owner = char.id

    exports.oxmysql:execute('SELECT * FROM characters_cars WHERE cid = @cid', { ['@cid'] = owner}, function(vehicles)
		TriggerClientEvent('phone:Garage', src, vehicles)
    end)
end)

function ResetGaragesServer()
	exports.oxmysql:execute('SELECT * FROM characters_cars WHERE repoed = ?', {"0"}, function(vehicles)
		for k, v in ipairs(vehicles) do
			if v.vehicle_state == "Out" then
				exports.oxmysql:execute("UPDATE characters_cars SET vehicle_state = @state, coords = @coords WHERE license_plate = @plate", {['state'] = 'In', ['coords'] = nil, ['plate'] = v.license_plate})
			end
		end
	end)
end

Citizen.CreateThread(function()
    ResetGaragesServer();
end)