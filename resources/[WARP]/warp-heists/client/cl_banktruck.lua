RegisterNetEvent("warp-jobmanager:playerBecameJob")
AddEventHandler("warp-jobmanager:playerBecameJob", function(job, name, notify)
    if isMedic and job ~= "ems" then isMedic = false isInService = false end
    if isCop and job ~= "police" or "state" or "sheriff" then isCop = false isInService = false end
    if job == "police" or "state" or "sheriff" then isCop = true isInService = true end
    if job == "ems" then isMedic = true isInService = true end

end)

local attempted = 0
local LootedTruck = false

local pickup = false
local additionalWait = 0
RegisterNetEvent('warp-heists:start_loop')
AddEventHandler('warp-heists:start_loop', function()
    pickup = true
    TriggerEvent("warp-heists:pick_cash")
    Wait(180000)
    Wait(additionalWait)
    pickup = false
end)

RegisterNetEvent('warp-heists:pick_cash')
AddEventHandler('warp-heists:pick_cash', function()
    local markerlocation = GetOffsetFromEntityInWorldCoords(attempted, 0.0, -3.7, 0.1)
    SetVehicleHandbrake(attempted,true)
    while pickup do
        Citizen.Wait(0)
        local coords = GetEntityCoords(GetPlayerPed(-1))
        local aDist = GetDistanceBetweenCoords(coords["x"], coords["y"],coords["z"], markerlocation["x"],markerlocation["y"],markerlocation["z"])
        if aDist < 2.0 and not LootedTruck then
            DrawText3Ds(markerlocation["x"],markerlocation["y"],markerlocation["z"], "Press [E] to pick up cash.")
            if IsDisabledControlJustReleased(0, 38) then
                if not LootedTruck then
                    FreezeEntityPosition(PlayerPedId(), true)
                    TriggerEvent('animation:PlayAnimation', 'search')
                    TriggerEvent('warp-hud:show_money')
                    local BankTruckBarLoot = exports['warp-taskbar']:taskBar(60000, 'Looting the truck')
                    if BankTruckBarLoot == 100 then
                        FreezeEntityPosition(PlayerPedId(), false)
                        TriggerEvent('warp-heists:banktruck_loot') 
                        TriggerEvent('warp-hud:hide_money') 
                        LootedTruck = true
                        Citizen.Wait(900000) 
                        LootedTruck = false     
                    else
                        FreezeEntityPosition(PlayerPedId(), false)
                        TriggerEvent('DoLongHudText', 'You notice cash dropping everywhere.', 2)
                    end
                else
                    TriggerEvent('DoLongHudText', 'You a bit greedy huh?', 2)
                end
            end
        end
    end
end)

RegisterNetEvent('warp-heists:banktruck_loot')
AddEventHandler('warp-heists:banktruck_loot', function()
    local LootTable = math.random(1, 3)
    if LootTable == 1 then
        TriggerEvent('player:receiveItem', 'cashroll', math.random(50, 100))
        TriggerEvent('player:receiveItem', 'bank', math.random(10, 25))
        TriggerEvent('warp-mining:get_gem')
    elseif LootTable == 2 then
        TriggerEvent('player:receiveItem', 'inkedmoneybag', 1)
    elseif LootTable == 3 then
        TriggerEvent('player:receiveItem', 'inkset', math.random(10, 20))
    end
end)

RegisterNetEvent('warp-heists:spawn_peds')
AddEventHandler('warp-heists:spawn_peds', function(veh)
    local cType = 's_m_m_highsec_01'
    local pedmodel = GetHashKey(cType)
    RequestModel(pedmodel)
    while not HasModelLoaded(pedmodel) do
        RequestModel(pedmodel)
        Citizen.Wait(100)
    end
    ped2 = CreatePedInsideVehicle(veh, 4, pedmodel, 0, 1, 0.0)
    DecorSetBool(ped2, 'ScriptedPed', true)
    ped3 = CreatePedInsideVehicle(veh, 4, pedmodel, 1, 1, 0.0)
    DecorSetBool(ped3, 'ScriptedPed', true)
    ped4 = CreatePedInsideVehicle(veh, 4, pedmodel, 2, 1, 0.0)
    DecorSetBool(ped4, 'ScriptedPed', true)

    GiveWeaponToPed(ped2, GetHashKey('WEAPON_SpecialCarbine'), 420, 0, 1)
    GiveWeaponToPed(ped3, GetHashKey('WEAPON_SpecialCarbine'), 420, 0, 1)
    GiveWeaponToPed(ped4, GetHashKey('WEAPON_SpecialCarbine'), 420, 0, 1)

    SetPedDropsWeaponsWhenDead(ped2,false)
    SetPedRelationshipGroupDefaultHash(ped2,GetHashKey('COP'))
    SetPedRelationshipGroupHash(ped2,GetHashKey('COP'))
    SetPedAsCop(ped2,true)
    SetCanAttackFriendly(ped2,false,true)

    SetPedDropsWeaponsWhenDead(ped3,false)
    SetPedRelationshipGroupDefaultHash(ped3,GetHashKey('COP'))
    SetPedRelationshipGroupHash(ped3,GetHashKey('COP'))
    SetPedAsCop(ped3,true)
    SetCanAttackFriendly(ped3,false,true)

    SetPedDropsWeaponsWhenDead(ped4,false)
    SetPedRelationshipGroupDefaultHash(ped4,GetHashKey('COP'))
    SetPedRelationshipGroupHash(ped4,GetHashKey('COP'))
    SetPedAsCop(ped4,true)
    SetCanAttackFriendly(ped4,false,true)

    TaskCombatPed(ped2, GetPlayerPed(-1), 0, 16)
    TaskCombatPed(ped3, GetPlayerPed(-1), 0, 16)
    TaskCombatPed(ped4, GetPlayerPed(-1), 0, 16)
end)



RegisterNetEvent('warp-heists:start_hitting_truck')
AddEventHandler('warp-heists:start_hitting_truck', function(veh)
    TriggerEvent('warp-dispatch:bank_truck_robbery')
    attempted = veh
    SetEntityAsMissionEntity(attempted,true,true)
    local plate = GetVehicleNumberPlateText(veh)
    TriggerServerEvent("warp-heists:check_if_robbed",plate)
end)

RegisterNetEvent('sec:AllowHeist')
AddEventHandler('sec:AllowHeist', function()
    TriggerServerEvent('banktruckrobbery:log')
    TriggerEvent("warp-heists:spawn_peds",attempted)
    SetVehicleDoorOpen(attempted, 2, 0, 0)
    SetVehicleDoorOpen(attempted, 3, 0, 0)
    TriggerEvent("warp-heists:start_loop")

end)

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

function FindEndPointCar(x,y)   
	local randomPool = 50.0
	while true do

		if (randomPool > 2900) then
			return
		end
	    local vehSpawnResult = {}
	    vehSpawnResult["x"] = 0.0
	    vehSpawnResult["y"] = 0.0
	    vehSpawnResult["z"] = 30.0
	    vehSpawnResult["x"] = x + math.random(randomPool - (randomPool * 2),randomPool) + 1.0  
	    vehSpawnResult["y"] = y + math.random(randomPool - (randomPool * 2),randomPool) + 1.0  
	    roadtest, vehSpawnResult, outHeading = GetClosestVehicleNode(vehSpawnResult["x"], vehSpawnResult["y"], vehSpawnResult["z"],  0, 55.0, 55.0)

        Citizen.Wait(1000)        
        if vehSpawnResult["z"] ~= 0.0 then
            local caisseo = GetClosestVehicle(vehSpawnResult["x"], vehSpawnResult["y"], vehSpawnResult["z"], 20.000, 0, 70)
            if not DoesEntityExist(caisseo) then

                return vehSpawnResult["x"], vehSpawnResult["y"], vehSpawnResult["z"], outHeading
            end
            
        end

        randomPool = randomPool + 50.0
	end
end