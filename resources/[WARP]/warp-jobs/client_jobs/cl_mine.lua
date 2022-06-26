
--// Start With Axe

RegisterNetEvent('dreams-start-mining')
AddEventHandler('dreams-start-mining', function()
    if DreamsMiningZone then
        TriggerEvent('dreams-civjobs-mining')
    else
        TriggerEvent('DoLongHudText', 'You are not in the Mining Zone', 2)
    end
end)

local currentlyMining = false
local pFarmed = 0

RegisterNetEvent("dreams-civjobs-mining")
AddEventHandler("dreams-civjobs-mining", function()
    local rnd = math.random(10)

	if exports["warp-inventory"]:hasEnoughOfItem("miningpickaxe",1,false) and not currentlyMining then 
        currentlyMining = true
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
            FreezeEntityPosition(playerPed, true)
            SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'))
            Citizen.Wait(200)
            local pickaxe = GetHashKey("prop_tool_pickaxe")
            
            -- Loads Pickaxe
            RequestModel(pickaxe)
            while not HasModelLoaded(pickaxe) do
            Wait(1)
            end
            
            local anim = "melee@hatchet@streamed_core_fps"
            local action = "plyr_front_takedown"
            
            -- Loads Anims
            RequestAnimDict(anim)
            while not HasAnimDictLoaded(anim) do
                Wait(1)
            end
            
            local object = CreateObject(pickaxe, coords.x, coords.y, coords.z, true, false, false)
            AttachEntityToEntity(object, playerPed, GetPedBoneIndex(playerPed, 57005), 0.1, 0.0, 0.0, -90.0, 25.0, 35.0, true, true, false, true, 1, true)
            TaskPlayAnim(PlayerPedId(), anim, action, 3.0, -3.0, -1, 31, 0, false, false, false)
            local finished = exports["warp-ui"]:taskBarSkill(5000,math.random( 200,400 ))
            if (finished == 100) then
                local finished = exports["warp-ui"]:taskBarSkill(5000,math.random( 200,400 ))
                if (finished == 100) then
                    local finished = exports["warp-ui"]:taskBarSkill(5000,math.random( 200,400 ))
                    if (finished == 100) then
                        if rnd == 1 then
                            TriggerEvent('dreams-civjobs:mines-items')
                            pFarmed = pFarmed + 1
                        elseif rnd == 2 then
                            TriggerEvent('dreams-civjobs:mines-items')
                            pFarmed = pFarmed + 1
                        elseif rnd == 3 then
                            TriggerEvent('warp-mining:get_gem')
                            pFarmed = pFarmed + 1
                        elseif rnd == 4 then
                            TriggerEvent('dreams-civjobs:mines-items')
                            pFarmed = pFarmed + 1
                        elseif rnd == 5 then
                            TriggerEvent('dreams-civjobs:mines-items')
                            pFarmed = pFarmed + 1
                        elseif rnd == 6 then
                            TriggerEvent('dreams-civjobs:mines-items')
                            pFarmed = pFarmed + 1
                        elseif rnd == 7 then
                            TriggerEvent('dreams-civjobs:mines-items')
                            pFarmed = pFarmed + 1
                        elseif rnd == 8 then
                            TriggerEvent('dreams-civjobs:mines-items')
                            pFarmed = pFarmed + 1
                        elseif rnd == 9 then
                            TriggerEvent('dreams-civjobs:mines-items')
                            pFarmed = pFarmed + 1
                        elseif rnd == 10 then
                            TriggerEvent('dreams-civjobs:mines-items')
                            pFarmed = pFarmed + 1
                        end
                    else
                        TriggerEvent("DoLongHudText", "Failed", 2)
                        currentlyMining = false
                        ClearPedTasks(PlayerPedId())
                        FreezeEntityPosition(playerPed, false)
                        DeleteObject(object)
                    
                    end
                else
                    TriggerEvent("DoLongHudText", "Failed", 2)
                    currentlyMining = false
                    ClearPedTasks(PlayerPedId())
                    FreezeEntityPosition(playerPed, false)
                    DeleteObject(object)
                
                end        
            else
                TriggerEvent("DoLongHudText", "Failed", 2)
                currentlyMining = false
                ClearPedTasks(PlayerPedId())
                FreezeEntityPosition(playerPed, false)
                DeleteObject(object)
            
            end
            currentlyMining = false
            ClearPedTasks(PlayerPedId())
            FreezeEntityPosition(playerPed, false)
            DeleteObject(object)
    else
		TriggerEvent('DoLongHudText', 'You need a pickaxe to mine', 2)
    end
end)

--// Events to get items

RegisterNetEvent('dreams-civjobs:mines-items', function()
    local roll = math.random(4)
    if roll == 1 then
        TriggerEvent('player:receiveItem', 'copper', math.random(1, 5))
        TriggerEvent('DoLongHudText', 'You Found Copper !', 1)
    elseif roll == 2 then
        TriggerEvent('player:receiveItem', 'aluminium', math.random(1, 5))
        TriggerEvent('DoLongHudText', 'You Found A', 1)
    elseif roll == 3 then
        TriggerEvent('player:receiveItem', 'scrapmetal', math.random(1, 5))
        TriggerEvent('DoLongHudText', 'You Found Scrapmetal', 1)
    elseif roll == 4 then
        TriggerEvent('player:receiveItem', 'steel', 1)
        TriggerEvent('DoLongHudText', 'You Found A Steel', 1)
    end
end)

RegisterNetEvent('warp-mining:get_gem')
AddEventHandler('warp-mining:get_gem', function()
    local EvanMiningGemShit = math.random(6)
    if EvanMiningGemShit == 1 then
        TriggerEvent('player:receiveItem', 'mineddiamond', 1)
    elseif EvanMiningGemShit == 2 then
        TriggerEvent('player:receiveItem', 'minedaquamarine', 1)
    elseif EvanMiningGemShit == 3 then
        TriggerEvent('player:receiveItem', 'minedjade', 1)
    elseif EvanMiningGemShit == 4 then
        TriggerEvent('player:receiveItem', 'minedcitrine', 1)
    elseif EvanMiningGemShit == 5 then
        TriggerEvent('player:receiveItem', 'minedgarnet', 1)
    elseif EvanMiningGemShit == 6 then
        TriggerEvent('player:receiveItem', 'minedopal', 1)
    end
end)

--// Polyzone

DreamsMiningZone = false

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("mining_zone", vector3(-592.1, 2075.5, 131.38), 25, 4, {
        name="mining_zone",
        heading=15,
        minZ=129.18,
        maxZ=133.18
    })
end)

RegisterNetEvent('warp-polyzone:enter')
AddEventHandler('warp-polyzone:enter', function(name)
    if name == "mining_zone" then
        DreamsMiningZone = true     
        print("^2[Void Mining] In Zone^0")
        exports['warp-textui']:showInteraction("Mining")
    end
end)

RegisterNetEvent('warp-polyzone:exit')
AddEventHandler('warp-polyzone:exit', function(name)
    if name == "mining_zone" then
        DreamsMiningZone = false  
        print("^2[Void Mining] Left Zone^0")  
        exports['warp-textui']:hideInteraction()
    end
end)