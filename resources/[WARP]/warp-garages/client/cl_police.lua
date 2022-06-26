local nearBuy = false

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("police_buy", vector3(464.53, -1012.86, 28.43), 1.6, 1.45, {
		name="police_buy",
		heading=0,
    }) 
end)

RegisterNetEvent('warp-polyzone:enter')
AddEventHandler('warp-polyzone:enter', function(name)
    if name == "police_buy" then
		local job = exports["isPed"]:isPed("myJob")
		if job == 'police' or job == 'state' or job == 'sheriff' then
            nearBuy = true
            AtPoliceBuy()
			exports['warp-textui']:showInteraction(("[E] %s"):format("Purchase Vehicle"))
        end
    end
end)

RegisterNetEvent('warp-polyzone:exit')
AddEventHandler('warp-polyzone:exit', function(name)
    if name == "police_buy" then
        nearBuy = false
    end
    exports['warp-textui']:hideInteraction()
end)

function AtPoliceBuy()
	Citizen.CreateThread(function()
        while nearBuy do
            Citizen.Wait(5)
            local plate = GetVehicleNumberPlateText(vehicle)
            local job = exports["isPed"]:isPed("myJob")
            if job == 'police' or job == 'state' or job == 'sheriff' then
                if IsControlJustReleased(0, 38) then
                    TriggerEvent('warp-garages:openBuyMenu')
                end
            end
        end
    end)
end

RegisterNetEvent('warp-garages:openBuyMenu')
AddEventHandler('warp-garages:openBuyMenu', function()
    TriggerEvent('warp-context:sendMenu', {
		{
			id = 1,
			header = "Police Crown Vic (Solo Cadet+)",
			txt = "Purchase for $80000",
			params = {
				event = "warp-garages:PurchasedVic"
			}
		},
        {
			id = 2,
			header = "Police Charger (SGT+)",
			txt = "Purchase for $160000",
			params = {
				event = "warp-garages:PurchasedCharger"
			}
		},
        {
			id = 3,
			header = "Police Explorer (SGT+)",
			txt = "Purchase for $100000",
			params = {
				event = "warp-garages:PurchasedExplorer"
			}
		},
	})
end)

RegisterNetEvent('warp-garages:openBuyMenu2')
AddEventHandler('warp-garages:openBuyMenu2', function()
    TriggerEvent('warp-context:sendMenu', {
		{
			id = 1,
			header = "EMS Ambulance",
			txt = "Purchase for $80000",
			params = {
				event = "warp-garages:PurchasedAmbo"
			}
		},
	})
end)

RegisterNetEvent('warp-garages:PurchasedAmbo')
AddEventHandler('warp-garages:PurchasedAmbo', function()
    if exports["isPed"]:isPed("mycash") >= 80000 then
        TriggerServerEvent('warp-banking:removeMoney', 80000)
        TriggerEvent('warp-garages:PurchasedVeh', 'Ambulance', 'emsnspeedo', '80000')
    else
        TriggerEvent('DoLongHudText', "You do not have enough money!", 2)
    end
end)

RegisterNetEvent('warp-garages:PurchasedVic')
AddEventHandler('warp-garages:PurchasedVic', function()
    if exports["isPed"]:isPed("mycash") >= 80000 then
        TriggerServerEvent('warp-banking:removeMoney', 80000)
        TriggerEvent('warp-garages:PurchasedVeh', 'Police Vic', 'npolvic', '80000')
    else
        TriggerEvent('DoLongHudText', "You do not have enough money!", 2)
    end
end)

RegisterNetEvent('warp-garages:PurchasedCharger')
AddEventHandler('warp-garages:PurchasedCharger', function()
    if exports["isPed"]:isPed("mycash") >= 160000 then
        TriggerServerEvent('warp-banking:removeMoney', 160000)
        TriggerEvent('warp-garages:PurchasedVeh', 'Police Charger', 'npolchar', '160000')
    else
        TriggerEvent('DoLongHudText', "You do not have enough money!", 2)
    end
end)

RegisterNetEvent('warp-garages:PurchasedExplorer')
AddEventHandler('warp-garages:PurchasedExplorer', function()
    if exports["isPed"]:isPed("mycash") >= 100000 then
        TriggerServerEvent('warp-banking:removeMoney', 100000)
        TriggerEvent('warp-garages:PurchasedVeh', 'Police Explorer', 'polsuv', '100000')
    else
        TriggerEvent('DoLongHudText', "You do not have enough money!", 2)
    end
end)
    

RegisterNetEvent('warp-garages:PurchasedVeh')
AddEventHandler('warp-garages:PurchasedVeh', function(name, veh, price)
    local ped = PlayerPedId()
    local name = name	
    local vehicle = veh
    local price = price		
    local model = veh
    local colors = table.pack(GetVehicleColours(veh))
    local extra_colors = table.pack(GetVehicleExtraColours(veh))

    local mods = {}

    for i = 0,24 do
        mods[i] = GetVehicleMod(veh,i)
    end

    FreezeEntityPosition(ped,false)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end

    local job = exports["isPed"]:isPed("myJob")
    if job == 'police' or job == 'state' or job == 'sheriff' then
        personalvehicle = CreateVehicle(model,462.81759643555,-1019.5252685547,28.100341796875,87.874015808105,true,false)
        SetEntityHeading(personalvehicle, 87.874015808105)
    elseif job == 'ems' then
        personalvehicle = CreateVehicle(model,333.1516418457,-575.947265625,28.791259765625,340.15747070312,true,false)
        SetEntityHeading(personalvehicle, 340.15747070312)
    end
        
    SetModelAsNoLongerNeeded(model)

    for i,mod in pairs(mods) do
        SetVehicleModKit(personalvehicle,0)
        SetVehicleMod(personalvehicle,i,mod)
    end

    SetVehicleOnGroundProperly(personalvehicle)

    local plate = GetVehicleNumberPlateText(personalvehicle)
    SetVehicleHasBeenOwnedByPlayer(personalvehicle,true)
    local id = NetworkGetNetworkIdFromEntity(personalvehicle)
    SetNetworkIdCanMigrate(id, true)
    Citizen.InvokeNative(0x629BFA74418D6239,Citizen.PointerValueIntInitialized(personalvehicle))
    SetVehicleColours(personalvehicle,colors[1],colors[2])
    SetVehicleExtraColours(personalvehicle,extra_colors[1],extra_colors[2])
    TaskWarpPedIntoVehicle(PlayerPedId(),personalvehicle,-1)
    SetEntityVisible(ped,true)			
    local primarycolor = colors[1]
    local secondarycolor = colors[2]	
    local pearlescentcolor = extra_colors[1]
    local wheelcolor = extra_colors[2]
    local VehicleProps = exports['warp-base']:FetchVehProps(personalvehicle)
    local model = GetEntityModel(personalvehicle)
    local vehname = GetDisplayNameFromVehicleModel(model)
    TriggerEvent("keys:addNew",personalvehicle, plate)
    TriggerServerEvent('warp-garages:FinalizedPur', plate, name, vehicle, price, VehicleProps)
    Citizen.Wait(100)
    exports['warp-textui']:hideInteraction()
end)