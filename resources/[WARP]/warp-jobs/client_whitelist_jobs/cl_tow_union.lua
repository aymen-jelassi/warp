
--// Union Bay 1
DreamsUnionJobBay1 = false

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("dreams_tow_union_shit", vector3(-205.5, -1169.08, 23.04), 10, 5, {
        name="dreams_tow_union_shit",
        heading=0,
        debugPoly=false,
        minZ=22.04,
        maxZ=26.04
    })
end)

RegisterNetEvent('warp-polyzone:enter')
AddEventHandler('warp-polyzone:enter', function(name)
    if name == "dreams_tow_union_shit" then
        DreamsUnionJobBay1 = true     
        TowUnionBay1PullTruck()
            if exports["isPed"]:isPed("myJob") == 'towunion' then
            exports['warp-textui']:showInteraction("[E] Pull Out Vehicle [Bay 1]")
        end
    end
end)

RegisterNetEvent('warp-polyzone:exit')
AddEventHandler('warp-polyzone:exit', function(name)
    if name == "dreams_tow_union_shit" then
        DreamsUnionJobBay1 = false
        exports['warp-textui']:hideInteraction()
    end
end)

function TowUnionBay1PullTruck()
	Citizen.CreateThread(function()
        while DreamsUnionJobBay1 do
            Citizen.Wait(5)
			if IsControlJustReleased(0, 38) then
                TriggerEvent('warp-jobs:union-tow-vehicle-garage-bay-1')
			end
		end
	end)
end

RegisterNetEvent("warp-jobs:union-tow-vehicle-garage-bay-1")
AddEventHandler("warp-jobs:union-tow-vehicle-garage-bay-1", function()
  if exports["isPed"]:isPed("myJob") == 'towunion' then
    TriggerEvent('warp-context:sendMenu', {
        {
            id = 1,
            header = "Tow Union",
            txt = "",
            params = {
                event = ""
            }
        },
        {
          id = 2, 
          header = "Take Out Towtruck",
          txt = "Small Towtruck",
          params = {
            event = "warp-jobs:attempt-union-spawn-veh-1",
            args = {
              vehicle = "towtruck2",
            }
          }
        },
        {
          id = 3, 
          header = "Take Out Towtruck",
          txt = "Medium Towtruck",
          params = {
            event = "warp-jobs:attempt-union-spawn-veh-1",
            args = {
              vehicle = "towtruck",
            }
          }
        },
        {
          id = 4, 
          header = "Take Out Flatbed",
          txt = "Large Flatbed",
          params = {
            event = "warp-jobs:attempt-union-spawn-veh-1",
            args = {
              vehicle = "flatbed",
            }
          }
        },
        {
          id = 5, 
          header = "Close Garage",
          txt = "",
          params = {
            event = "",
          }
        },
      })
    end
end)

RegisterNetEvent("warp-jobs:attempt-union-spawn-veh-1")
AddEventHandler("warp-jobs:attempt-union-spawn-veh-1", function(data)
  local TowUnionCar = data.vehicle
  if IsAnyVehicleNearPoint(-204.96263122559, -1169.7362060547, 23.129638671875, 1.0) then
    TriggerEvent("DoLongHudText", "There's a vehicle in the way!", 2)
    return
  else
    TriggerServerEvent("warp-jobs:union-towing-bay-2",TowUnionCar)
  end 
end)


RegisterNetEvent("dreams-jobs:tow-union-bay-1")
AddEventHandler("dreams-jobs:tow-union-bay-1", function(data, cb)

  print(data)

  local model = data

  RequestModel(model)
  while not HasModelLoaded(model) do
      Citizen.Wait(0)
  end
  SetModelAsNoLongerNeeded(model)

  local DreamsTowUnionBay1Vehicle = CreateVehicle(model, vector4(-204.96263122559, -1169.7362060547, 23.129638671875, 178.58267211914), true, false)

  Citizen.Wait(100)

  SetEntityAsMissionEntity(DreamsTowUnionBay1Vehicle, true, true)
  SetModelAsNoLongerNeeded(model)
  SetVehicleOnGroundProperly(DreamsTowUnionBay1Vehicle)

  SetVehicleNumberPlateText(DreamsTowUnionBay1Vehicle, "TowUnion"..tostring(math.random(1000, 9999)))
  TriggerEvent("keys:addNew",DreamsTowUnionBay1Vehicle,plate)

  local plateText = GetVehicleNumberPlateText(DreamsTowUnionBay1Vehicle)
  local player = exports["warp-base"]:getModule("LocalPlayer")

  local timeout = 10
  while not NetworkDoesEntityExistWithNetworkId(DreamsTowUnionBay1Vehicle) and timeout > 0 do
      timeout = timeout - 1
      Wait(1000)
  end

end)

--// Union Bay 2
DreamsUnionJobBay2 = false

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("dreams_tow_union_shit_bay_2", vector3(-212.82, -1169.06, 23.04), 10, 5, {
        name="dreams_tow_union_shit_bay_2",
        heading=0,
        debugPoly=false,
        minZ=21.84,
        maxZ=25.84
    })
end)

RegisterNetEvent('warp-polyzone:enter')
AddEventHandler('warp-polyzone:enter', function(name)
    if name == "dreams_tow_union_shit_bay_2" then
        DreamsUnionJobBay2 = true     
        TowUnionBay2PullTruck()
            if exports["isPed"]:isPed("myJob") == 'towunion' then
            exports['warp-textui']:showInteraction("[E] Pull Out Vehicle [Bay 2]")
        end
    end
end)

RegisterNetEvent('warp-polyzone:exit')
AddEventHandler('warp-polyzone:exit', function(name)
    if name == "dreams_tow_union_shit_bay_2" then
        DreamsUnionJobBay2 = false
        exports['warp-textui']:hideInteraction()
    end
end)

function TowUnionBay2PullTruck()
	Citizen.CreateThread(function()
        while DreamsUnionJobBay2 do
            Citizen.Wait(5)
			if IsControlJustReleased(0, 38) then
                TriggerEvent('warp-jobs:union-tow-vehicle-garage-bay-2')
			end
		end
	end)
end

RegisterNetEvent("warp-jobs:union-tow-vehicle-garage-bay-2")
AddEventHandler("warp-jobs:union-tow-vehicle-garage-bay-2", function()
  if exports["isPed"]:isPed("myJob") == 'towunion' then
    TriggerEvent('warp-context:sendMenu', {
        {
            id = 1,
            header = "Tow Union",
            txt = "",
            params = {
                event = ""
            }
        },
        {
          id = 2, 
          header = "Take Out Towtruck",
          txt = "Small Towtruck",
          params = {
            event = "warp-jobs:attempt-union-spawn-veh-2",
            args = {
              vehicle = "towtruck2",
            }
          }
        },
        {
          id = 3, 
          header = "Take Out Towtruck",
          txt = "Medium Towtruck",
          params = {
            event = "warp-jobs:attempt-union-spawn-veh-2",
            args = {
              vehicle = "towtruck",
            }
          }
        },
        {
          id = 4, 
          header = "Take Out Flatbed",
          txt = "Large Flatbed",
          params = {
            event = "warp-jobs:attempt-union-spawn-veh-2",
            args = {
              vehicle = "flatbed",
            }
          }
        },
        {
          id = 5, 
          header = "Close Garage",
          txt = "",
          params = {
            event = "",
          }
        },
      })
    end
end)

RegisterNetEvent("warp-jobs:attempt-union-spawn-veh-2")
AddEventHandler("warp-jobs:attempt-union-spawn-veh-2", function(data)
  local TowUnionCar = data.vehicle
  if IsAnyVehicleNearPoint(-212.80879211426, -1168.3121337891, 23.028564453125, 1.0) then
    TriggerEvent("DoLongHudText", "There's a vehicle in the way!", 2)
    return
  else
    TriggerServerEvent("warp-jobs:union-towing",TowUnionCar)
  end 
end)


RegisterNetEvent("dreams-jobs:tow-union-bay-2")
AddEventHandler("dreams-jobs:tow-union-bay-2", function(data, cb)

  print(data)

  local model = data

  RequestModel(model)
  while not HasModelLoaded(model) do
      Citizen.Wait(0)
  end
  SetModelAsNoLongerNeeded(model)

  local DreamsTowUnionBay2Vehicle = CreateVehicle(model, vector4(-212.80879211426, -1168.3121337891, 23.028564453125, 181.41732788086), true, false)

  Citizen.Wait(100)

  SetEntityAsMissionEntity(DreamsTowUnionBay2Vehicle, true, true)
  SetModelAsNoLongerNeeded(model)
  SetVehicleOnGroundProperly(DreamsTowUnionBay2Vehicle)

  SetVehicleNumberPlateText(DreamsTowUnionBay2Vehicle, "TowUnion"..tostring(math.random(1000, 9999)))
  TriggerEvent("keys:addNew",DreamsTowUnionBay2Vehicle,plate)

  local plateText = GetVehicleNumberPlateText(DreamsTowUnionBay2Vehicle)
  local player = exports["warp-base"]:getModule("LocalPlayer")

  local timeout = 10
  while not NetworkDoesEntityExistWithNetworkId(DreamsTowUnionBay2Vehicle) and timeout > 0 do
      timeout = timeout - 1
      Wait(1000)
  end

end)


local currentlyTowedVehicle = nil

RegisterNetEvent('dreams-jobs:tow')
AddEventHandler('dreams-jobs:tow', function()
	
	local playerped = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(playerped, true)
	
	local towmodel = GetHashKey('flatbed')
	local isVehicleTow = IsVehicleModel(vehicle, towmodel)
			
	if isVehicleTow then
	
		local coordA = GetEntityCoords(playerped, 1)
		local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
		local targetVehicle = getVehicleInDirection(coordA, coordB)
		
		if currentlyTowedVehicle == nil then
			if targetVehicle ~= 0 then
				if not IsPedInAnyVehicle(playerped, true) then
					if vehicle ~= targetVehicle then
						AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
						currentlyTowedVehicle = targetVehicle
						TriggerEvent("chatMessage", "", {255, 255, 0}, "Vehicle successfully attached to towtruck!")
					else
						TriggerEvent("chatMessage", "", {255, 255, 0}, "Are you retarded? You cant tow your own towtruck with your own towtruck?")
					end
				end
			else
				TriggerEvent("chatMessage", "", {255, 255, 0}, "Theres no vehicle to tow?")
			end
		else
			AttachEntityToEntity(currentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
			DetachEntity(currentlyTowedVehicle, true, true)
			currentlyTowedVehicle = nil
			TriggerEvent("chatMessage", "", {255, 255, 0}, "The vehicle has been successfully detached!")
		end
	end
end)


--// Poggers

RegisterNetEvent('dreams-jobs:get-union-keyfob')
AddEventHandler('dreams-jobs:get-union-keyfob', function()
  if exports['warp-inventory']:hasEnoughOfItem('keyfob', 1) then
    TriggerEvent('DoLongHudText', 'You already have a keyfob', 1)
  else
    TriggerEvent('player:receiveItem', 'keyfob', 1)
    TriggerEvent('DoLongHudText', 'Use this to unlock the gates', 1)
  end
end)

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end