local thecount = 0
local ragdol = 1    
local isPlayerDead = 0
local inwater = false
local EHeld = 500
local defaultAnimTree = "dead"
local defaultAnim = "dead_d"
local carAnimTree = "random@crash_rescue@car_death@std_car"
local carAnim = "loop"
local respawn = false
local knockedOut = false
local wait = 15
local count = 60
local carry = {
	InProgress = false,
	targetSrc = -1,
	type = "",
	personCarrying = {
		animDict = "missfinale_c2mcs_1",
		anim = "fin_c2_mcs_1_camman",
		flag = 49,
	},
	personCarried = {
		animDict = "nm",
		anim = "firemans_carry",
		attachX = 0.27,
		attachY = 0.15,
		attachZ = 0.63,
		flag = 33,
	}
}

local function drawNativeNotification(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

local function GetClosestPlayer(radius)
    local players = GetActivePlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _,playerId in ipairs(players) do
        local targetPed = GetPlayerPed(playerId)
        if targetPed ~= playerPed then
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(targetCoords-playerCoords)
            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = playerId
                closestDistance = distance
            end
        end
    end
	if closestDistance ~= -1 and closestDistance <= radius then
		return closestPlayer
	else
		return nil
	end
end

local function ensureAnimDict(animDict)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(0)
        end        
    end
    return animDict
end

RegisterCommand("carry",function(source, args)
	if not carry.InProgress then
		local closestPlayer = GetClosestPlayer(3)
		if closestPlayer then
			local targetSrc = GetPlayerServerId(closestPlayer)
			if targetSrc ~= -1 then
				carry.InProgress = true
				carry.targetSrc = targetSrc
				TriggerServerEvent("CarryPeople:sync",targetSrc)
				ensureAnimDict(carry.personCarrying.animDict)
				carry.type = "carrying"
			else
				drawNativeNotification("~r~No one nearby to carry!")
			end
		else
			drawNativeNotification("~r~No one nearby to carry!")
		end
	else
		carry.InProgress = false
		ClearPedSecondaryTask(PlayerPedId())
		DetachEntity(PlayerPedId(), true, false)
		TriggerServerEvent("CarryPeople:stop",carry.targetSrc)
		carry.targetSrc = 0
	end
end,false)

RegisterNetEvent("CarryPeople:syncTarget")
AddEventHandler("CarryPeople:syncTarget", function(targetSrc)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(targetSrc))
	carry.InProgress = true
	ensureAnimDict(carry.personCarried.animDict)
	AttachEntityToEntity(PlayerPedId(), targetPed, 0, carry.personCarried.attachX, carry.personCarried.attachY, carry.personCarried.attachZ, 0.5, 0.5, 180, false, false, false, false, 2, false)
	carry.type = "beingcarried"
end)

RegisterNetEvent("CarryPeople:cl_stop")
AddEventHandler("CarryPeople:cl_stop", function()
	carry.InProgress = false
	ClearPedSecondaryTask(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)
end)

Citizen.CreateThread(function()
	while true do
		if carry.InProgress then
			if carry.type == "beingcarried" then
				if not IsEntityPlayingAnim(PlayerPedId(), carry.personCarried.animDict, carry.personCarried.anim, 3) then
					TaskPlayAnim(PlayerPedId(), carry.personCarried.animDict, carry.personCarried.anim, 8.0, -8.0, 100000, carry.personCarried.flag, 0, false, false, false)
				end
			elseif carry.type == "carrying" then
				if not IsEntityPlayingAnim(PlayerPedId(), carry.personCarrying.animDict, carry.personCarrying.anim, 3) then
					TaskPlayAnim(PlayerPedId(), carry.personCarrying.animDict, carry.personCarrying.anim, 8.0, -8.0, 100000, carry.personCarrying.flag, 0, false, false, false)
				end
			end
		end
		Wait(0)
	end
end)







function GetDeathStatus()
    if isPlayerDead == 1 then
        poggers = true
    elseif isPlayerDead == 0 then
        poggers = false
    end
    return poggers
end

Citizen.CreateThread(function()
    local ped = PlayerPedId()
    SetPedConfigFlag(ped,184,true)
    while true do
        Wait(5000)
        if PlayerPedId() ~= ped then
            ped = PlayerPedId()
            SetPedConfigFlag(ped,184,true)
        end
    end
end)

Citizen.CreateThread(function()
    SetEntityInvincible(PlayerPedId(), false)
    isPlayerDead = 0
    ragdol = 0
    while true do
        Wait(100)
        if IsEntityDead(PlayerPedId()) then
            SetEntityInvincible(PlayerPedId(), true)
            SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
            if isPlayerDead == 0 then
                isPlayerDead = 1
                deathTimer()
            end
        end
    end
end)

RegisterNetEvent('doTimer')
AddEventHandler('doTimer', function()
    TriggerEvent('pd:deathcheck')
    while isPlayerDead == 1 do
        Citizen.Wait(0)
        if thecount > 0 then
            SendNUIMessage({countCheck = true, time = math.ceil(thecount)})
        else
            countCheck = false
            SendNUIMessage({respawn = true, respawnInfo = "Hold [ E ] (" .. math.ceil(EHeld/100) .. ") to respawn"})
        end
    end
    TriggerEvent('pd:deathcheck')
end)



dragged = false
RegisterNetEvent('deathdrop')
AddEventHandler('deathdrop', function(beingDragged)
    dragged = beingDragged
    if not beingDragged and isPlayerDead == 1 then
        SetEntityHealth(PlayerPedId(), 200.0)
        SetEntityCoords( PlayerPedId(), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 1.0) )
    end 
end)

RegisterNetEvent('warp-death:deathCheck')
AddEventHandler('warp-death:deathCheck', function()
    NetworkResurrectLocalPlayer(GetEntityCoords(PlayerPedId(),  true), true, true, false)
    ResetRelationShipGroups()
end)

RegisterNetEvent('ressurection:relationships:norevive')
AddEventHandler('ressurection:relationships:norevive', function()
    ResetRelationShipGroups()
end)

function InVeh()
  local ply = PlayerPedId()
  if IsPedSittingInAnyVehicle(ply) then
    return true
  else
    return false
  end
end

function ResetRelationShipGroups()
    Citizen.Wait(1000)
    if exports["isPed"]:isPed("myJob") == 'police' or exports["isPed"]:isPed("myJob") == 'sheriff' or exports["isPed"]:isPed("myJob") == 'state' or exports["isPed"]:isPed("myJob") == 'ems' then
        SetPedRelationshipGroupDefaultHash(PlayerPedId(),`MISSION2`)
        SetPedRelationshipGroupHash(PlayerPedId(),`MISSION2`)
    else
        SetPedRelationshipGroupDefaultHash(PlayerPedId(),`PLAYER`)
        SetPedRelationshipGroupHash(PlayerPedId(),`PLAYER`)
    end
    TriggerEvent("gangs:setDefaultRelations")
end

local disablingloop = false

RegisterNetEvent('disableAllActions')
AddEventHandler('disableAllActions', function()
    if not disablingloop then
        local ped = PlayerPedId()

        disablingloop = true

        -- wait for any ragdoll / falling to finish
        while GetEntitySpeed(ped) > 0.5 do
            Citizen.Wait(1)
        end 

        -- wait for any fire effects on player to finish
        local fireLength = 60
        while FireCheck(ped) and fireLength > 1 do
            Wait(1000)
            fireLength = fireLength - 1
        end

        -- get vehicle seat
        local seat = 0
        local veh = GetVehiclePedIsUsing(ped)
        if veh then
            local vehmodel = GetEntityModel(veh)
            for i = -1, GetVehicleModelNumberOfSeats(vehmodel) do
                if GetPedInVehicleSeat(veh,i) == ped then
                    seat = i
                end
            end
        end

        TriggerEvent("warp-death:deathCheck")

        ped = PlayerPedId()
        if veh then
            TaskWarpPedIntoVehicle(ped,veh,seat)
        end

        TriggerEvent("disableAllActions2")
        SetEntityInvincible(ped, true)
        
        while isPlayerDead == 1 do
            Citizen.Wait(200)
            if InVeh() and (not IsDeadVehAnimPlaying() or IsPedRagdoll(ped)) and not FireCheck(ped) then
                DoVehDeathAnim(ped)
            elseif not InVeh() and (not IsDeadAnimPlaying() or IsPedRagdoll(ped)) and not FireCheck(ped) then
                DoDeathAnim(ped)
            end
            Citizen.Wait(800)
        end
        SetEntityInvincible(ped, false)
        ClearPedTasksImmediately(ped)
        disablingloop = false
    end
end)

function FireCheck()
    local Coords = GetEntityCoords(PlayerPedId())
    local retval, outPosition = GetClosestFirePos(Coords.x, Coords.y, Coords.z)
    return retval
end

function IsDeadVehAnimPlaying()
    if IsEntityPlayingAnim(PlayerPedId(), carAnimTree, carAnim, 1) then
        return true
    else
        return false
    end
end

function IsDeadAnimPlaying()
    if IsEntityPlayingAnim(PlayerPedId(), defaultAnimTree, defaultAnim, 1) then
        return true
    else
        return false
    end
end

function DoVehDeathAnim(ped)
    loadAnimDict( carAnimTree ) 
    TaskPlayAnim(ped, carAnimTree, carAnim, 8.0, -8, -1, 1, 0, 0, 0, 0)
end

function DoDeathAnim(ped)
    ClearPedTasksImmediately(ped)
    loadAnimDict( defaultAnimTree ) 
    TaskPlayAnim(ped, defaultAnimTree, defaultAnim, 8.0, -8, -1, 1, 0, 0, 0, 0)
end

RegisterNetEvent('disableAllActions2')
AddEventHandler('disableAllActions2', function()
    TriggerEvent("disableVehicleActions")
    local playerPed = PlayerPedId()
    while isPlayerDead == 1 do
        Citizen.Wait(0) 
        DisableInputGroup(0)
        DisableInputGroup(1)
        DisableInputGroup(2)
        DisableControlAction(1, 19, true)
        DisableControlAction(0, 34, true)
        DisableControlAction(0, 9, true)
        DisableControlAction(0, 32, true)
        DisableControlAction(0, 8, true)
        DisableControlAction(2, 31, true)
        DisableControlAction(2, 32, true)
        DisableControlAction(1, 33, true)
        DisableControlAction(1, 34, true)
        DisableControlAction(1, 35, true)
        DisableControlAction(1, 21, true)  -- space
        DisableControlAction(1, 22, true)  -- space
        DisableControlAction(1, 23, true)  -- F
        DisableControlAction(1, 24, true)  -- F
        DisableControlAction(1, 25, true)  -- F
        DisableControlAction(1, 311, true)  -- K Inventory
        if IsControlJustPressed(1,29) then
            SetPedToRagdoll(playerPed, 26000, 26000, 3, 0, 0, 0) 
            Citizen.Wait(22000)
            TriggerEvent("warp-death:forceAnim")
        end
        DisableControlAction(1, 106, true) -- VehicleMouseControlOverride
        DisableControlAction(1, 140, true) --Disables Melee Actions
        DisableControlAction(1, 141, true) --Disables Melee Actions
        DisableControlAction(1, 142, true) --Disables Melee Actions 
        DisableControlAction(1, 37, true) --Disables INPUT_SELECT_WEAPON (tab) Actions
        DisablePlayerFiring(playerPed, true) -- Disable weapon firing
    end
    SetPedCanRagdoll(PlayerPedId(), false)
end)

RegisterNetEvent('disableVehicleActions')
AddEventHandler('disableVehicleActions', function()
    local playerPed = PlayerPedId()
    while isPlayerDead == 1 do
        local currentVehicle = GetVehiclePedIsIn(playerPed, false)
        Wait(300)
        if playerPed ==  GetPedInVehicleSeat(currentVehicle, -1) then
            SetVehicleUndriveable(currentVehicle,true)
        end
    end
end)

local CanSendSignal = true

RegisterNetEvent('warp-death:alert')
AddEventHandler('warp-death:alert', function()
    if CanSendSignal then
        TriggerEvent("civilian:alertPolice",100.0,"death",0)
        CanSendSignal = false
        Citizen.Wait(120000)
        CanSendSignal = true
    else
        TriggerEvent('DoLongHudText', 'You already sent a signal, wait for someone to respond.', 2)
    end
end)

local gamerTimer = 0
function deathTimer()
    EHeld = 500
    thecount = 300
    TriggerEvent("doTimer")
    gamerTimer = GetGameTimer()
    TriggerEvent("disableAllActions")
    while isPlayerDead == 1 do
        
        Citizen.Wait(5)
        
        if GetGameTimer() - gamerTimer > 1000 then
            gamerTimer = GetGameTimer()
            thecount = thecount - 1
            
            while thecount < 0 do
                Citizen.Wait(1)
                
                if IsControlPressed(1,38) then
                    local hspDist = #(vector3(307.93017578125,-594.99530029297,43.291835784912) - GetEntityCoords(PlayerPedId()))
                    EHeld = EHeld - 1
                    if hspDist > 5 and EHeld < 1 then
                        thecount = 99999999
                        releaseBody()
                    end
                else
                    EHeld = 500
                end
            end
        end      
    end
end

RegisterNetEvent('warp-death:revive')
AddEventHandler('warp-death:revive', function()
    attemptRevive()
end)

function releaseBody()
    local ply = PlayerPedId()
    thecount = 0
    isPlayerDead = 0   
    ragdol = 1
    ClearPedTasksImmediately(ply)
    TriggerEvent('DoLongHudText', 'You have been revived by medical staff.', 1)
    TriggerEvent('dreams-phone:fix-dead')
    FreezeEntityPosition(ply, false)
    TriggerEvent("unEscortPlayer")
    TriggerEvent("resetCuffs")
    Citizen.Wait(5)
    if exports["isPed"]:isPed("myJob") == 'police' or exports["isPed"]:isPed("myJob") == 'sheriff' or exports["isPed"]:isPed("myJob") == 'state' then
        SetEntityCoords(ply, 441.60, -982.37, 30.67)
    else
        RemoveAllPedWeapons(ply)
        SetEntityCoords(ply, 357.43, -593.36, 28.79)
    end
    SetEntityInvincible(ply, false)
    ClearPedBloodDamage(ply)
    EnableAllControlActions(0)
    local plyPos = GetEntityCoords(ply,true)
    TriggerEvent("warp-death:deathCheck")
    TriggerEvent("Evidence:isAlive")
    TriggerEvent("attachWeapons")
    SetCurrentPedWeapon(ply,2725352035,true)
    SetPedCanRagdoll(ply, true)
    TriggerEvent('ai:resetKOS')
    Citizen.Wait(100)
    SendNUIMessage({countCheck = false})
    SendNUIMessage({respawn = false})
    -- Citizen.CreateThread(function()
    --     Citizen.Wait(4000)
    --     TriggerEvent("unEscortPlayer")
    --     TriggerEvent("resetCuffs")
    -- end)
end

-- INFO: Revive Function
function attemptRevive()
    if InVeh() then
        print("In vehicle - can not be revived!")
        return
    end
    if isPlayerDead == 1 or IsDeadAnimPlaying() or IsDeadVehAnimPlaying() then
        ragdol = 1
        isPlayerDead = 0
        thecount = 0
        local ped = PlayerPedId()
        TriggerEvent("Heal")
        SetEntityInvincible(ped, false)
        SetPedMaxHealth(ped, 200)
        SetPlayerMaxArmour(PlayerId(), 60)
        ClearPedBloodDamage(ped)
        local plyPos = GetEntityCoords(ped,  true)
        local heading = GetEntityHeading(ped)
        TriggerEvent("warp-death:deathCheck")
        TriggerEvent("Evidence:isAlive")
        TriggerEvent('ai:resetKOS')
        ClearPedTasksImmediately(ped)
        NetworkResurrectLocalPlayer(plyPos, heading, false, false, false)
        SetPedCanRagdoll(ped, true)
        Citizen.Wait(100)
        SendNUIMessage({countCheck = false})
        SendNUIMessage({respawn = false})
        Citizen.Wait(500)
        RemoveAllPedWeapons(ped,true)
        reviveSucess()
        EnableAllControlActions(0)
    end
end

function reviveSucess()
    ClearPedSecondaryTask(PlayerPedId())
    loadAnimDict( "random@crash_rescue@help_victim_up" ) 
    TaskPlayAnim( PlayerPedId(), "random@crash_rescue@help_victim_up", "helping_victim_to_feet_victim", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
    SetCurrentPedWeapon(PlayerPedId(),2725352035,true)
    Citizen.Wait(3000)
    stopAnimation()
end

function stopAnimation()
    ClearPedSecondaryTask(PlayerPedId())
end

function loadAnimDict( dict )
    RequestAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        
        Citizen.Wait( 1 )
    end
end

RegisterNetEvent("heal")
AddEventHandler('heal', function()
	local ped = PlayerPedId()
	if DoesEntityExist(ped) and not IsEntityDead(ped) then
		SetEntityHealth(ped, GetEntityMaxHealth(ped))
		ragdol = 0
	end
end)