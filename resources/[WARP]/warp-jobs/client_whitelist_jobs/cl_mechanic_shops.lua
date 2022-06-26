

--// Tuner Shop Stash

DreamsTunerShopDoc = false

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("tuner_shop_docs_stash", vector3(128.46, -3014.08, 7.04), 2.5, 2.5, {
        name="tuner_shop_docs_stash",
        heading=0,
        debugPoly=false,
        minZ=5.04,
        maxZ=9.04
    })
end)

RegisterNetEvent('warp-polyzone:enter')
AddEventHandler('warp-polyzone:enter', function(name)
    if name == "tuner_shop_docs_stash" then
        DreamsTunerShopDoc = true     
        TunerShopStash()
            local rank = exports["isPed"]:GroupRank("tuner_shop")
            if rank > 1 then 
            exports['warp-textui']:showInteraction("[E] Stash")
        end
    end
end)

RegisterNetEvent('warp-polyzone:exit')
AddEventHandler('warp-polyzone:exit', function(name)
    if name == "tuner_shop_docs_stash" then
        DreamsTunerShopDoc = false
        exports['warp-textui']:hideInteraction()
    end
end)

function TunerShopStash()
	Citizen.CreateThread(function()
        while DreamsTunerShopDoc do
            Citizen.Wait(5)
			if IsControlJustReleased(0, 38) then
                    local rank = exports["isPed"]:GroupRank("tuner_shop")
                    if rank > 1 then 
                    TriggerEvent('tuner:stash:docs')
                end
			end
		end
	end)
end

RegisterNetEvent('tuner:stash:docs')
AddEventHandler('tuner:stash:docs', function()
    local job = exports["isPed"]:GroupRank('tuner_shop')
    if job >= 2 then
		TriggerEvent("server-inventory-open", "1", "storage-tuner-docs")
		Wait(1000)
	end
end)


--------------------------------------------------------------------------------------------------------------------

-- RegisterNetEvent('warp-civjobs:craft-lockpick')
-- AddEventHandler('warp-civjobs:craft-lockpick', function()
--     if exports['warp-inventory']:hasEnoughOfItem('steel', 2) then
--         TriggerEvent('inventory:removeItem', 'steel', 2)
--         TriggerEvent('player:receiveItem', 'lockpick', 1)
--         TriggerEvent('DoLongHudText', 'Successfully crafted Lockpick', 1)
--     else
--         TriggerEvent('DoLongHudText', 'You dont have 2x Steel', 2)
--     end
-- end)

-- RegisterNetEvent('warp-civjobs:craft-advlockpick')
-- AddEventHandler('warp-civjobs:craft-advlockpick', function()
--     if exports['warp-inventory']:hasEnoughOfItem('refinedaluminium', 15) and exports['warp-inventory']:hasEnoughOfItem('refinedplastic', 12) and exports['warp-inventory']:hasEnoughOfItem('refinedrubber', 15) then
--         TriggerEvent('inventory:removeItem', 'refinedaluminium', 15)
--         TriggerEvent('inventory:removeItem', 'refinedplastic', 12)
--         TriggerEvent('inventory:removeItem', 'refinedrubber', 15)
--         TriggerEvent('player:receiveItem', 'advlockpick', 1)
--         TriggerEvent('DoLongHudText', 'Successfully Crafted Advlockpick', 1)
--     else
--         TriggerEvent('DoLongHudText', 'You do not have the required materials', 2)
--     end
-- end)

-- RegisterNetEvent('warp-civjobs:craft-repairkit')
-- AddEventHandler('warp-civjobs:craft-repairkit', function()
--     if exports['warp-inventory']:hasEnoughOfItem('electronics', 25) then
--         TriggerEvent('inventory:removeItem', 'electronics', 25)
--         TriggerEvent('player:receiveItem', 'repairkit', 1)
--         TriggerEvent('DoLongHudText', 'Successfully crafted Repairkit', 1)
--     else
--         TriggerEvent('DoLongHudText', 'You dont have the required materials', 2)
--     end
-- end)

-- RegisterNetEvent('warp-civjobs:craft-tyre-repairkit')
-- AddEventHandler('warp-civjobs:craft-tyre-repairkit', function()
--     if exports['warp-inventory']:hasEnoughOfItem('rubber', 10) and exports['warp-inventory']:hasEnoughOfItem('steel', 3) then
--         TriggerEvent('inventory:removeItem', 'rubber', 10)
--         TriggerEvent('inventory:removeItem', 'steel', 3)
--         TriggerEvent('player:receiveItem', 'tyrerepairkit', 1)
--         TriggerEvent('DoLongHudText', 'Successfully crafted Tyre Repairkit', 1)
--     else
--         TriggerEvent('DoLongHudText', 'You dont have the required materials', 2)
--     end
-- end)

-- RegisterNetEvent('dreams-jobs:mechanic-craft')
-- AddEventHandler('dreams-jobs:mechanic-craft', function()
--     TriggerEvent('warp-context:sendMenu', {
--         {
--             id = 1,
--             header = "Mechanic Craft",
--             txt = ""
--         },
--         {
--             id = 2,
--             header = "Craft Lockpick",
--             txt = "Requires: 2x Steel",
--             params = {
--                 event = "warp-civjobs:craft-lockpick"
--             }
--         },
--         {
--             id = 3,
--             header = "Craft Advlockpick",
--             txt = "Requires: 15x Refined Aluminium | 12x Refined Plastic | 15x Refined Rubber",
--             params = {
--                 event = "warp-civjobs:craft-advlockpick"
--             }
--         },
--         {
--             id = 4,
--             header = "Craft Repairkit",
--             txt = "Requires: 25 Electronics",
--             params = {
--                 event = "warp-civjobs:craft-repairkit"
--             }
--         },
--         {
--             id = 5,
--             header = "Craft Tyre Repairkit",
--             txt = "Requires: 5 Rubber | 3 Steel",
--             params = {
--                 event = "warp-civjobs:craft-tyre-repairkit"
--             }
--         },
--         {
--             id = 6,
--             header = "Close",
--             txt = "Have a good day!",
--             params = {
--                 event = ""
--             }
--         },
--     })
-- end)

-----------------------------------------------------------------------------------------------------------------

--// Start Of Hayes Autos

DreamsHayesAutosStash = false

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("hayes_autos_stash", vector3(-1415.05, -451.58, 35.91), 1, 4.6, {
        name="hayes_autos_stash",
        heading=30,
        --debugPoly=true,
        minZ=33.11,
        maxZ=37.11
    })
end)

RegisterNetEvent('warp-polyzone:enter')
AddEventHandler('warp-polyzone:enter', function(name)
    if name == "hayes_autos_stash" then
        DreamsHayesAutosStash = true     
        HayesAutosStash()
            local rank = exports["isPed"]:GroupRank("hayes_autos")
            if rank > 1 then 
            exports['warp-textui']:showInteraction("[E] Stash")
        end
    end
end)

RegisterNetEvent('warp-polyzone:exit')
AddEventHandler('warp-polyzone:exit', function(name)
    if name == "hayes_autos_stash" then
        DreamsHayesAutosStash = false
        exports['warp-textui']:hideInteraction()
    end
end)

function HayesAutosStash()
	Citizen.CreateThread(function()
        while DreamsHayesAutosStash do
            Citizen.Wait(5)
			if IsControlJustReleased(0, 38) then
                    local rank = exports["isPed"]:GroupRank("hayes_autos")
                    if rank > 1 then 
                    TriggerEvent('dreams-jobs:hayes_mechanic-shop')
                end
			end
		end
	end)
end

RegisterNetEvent('dreams-jobs:hayes_mechanic-shop')
AddEventHandler('dreams-jobs:hayes_mechanic-shop', function()
    local job = exports["isPed"]:GroupRank('hayes_autos')
    if job >= 2 then
		TriggerEvent("server-inventory-open", "1", "storage-hayes_autos")
		Wait(1000)
	end
end)

--// Crafting

--// Hayes

DreamsCraftingHayesAutos = false

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("dreams_crafting_hayes_autos", vector3(-1408.39, -447.37, 35.91), 1, 5.4, {
        name="dreams_crafting_hayes_autos",
        heading=30,
        --debugPoly=true,
        minZ=33.31,
        maxZ=37.31
    })
end)

RegisterNetEvent('warp-polyzone:enter')
AddEventHandler('warp-polyzone:enter', function(name)
    if name == "dreams_crafting_hayes_autos" then
        DreamsCraftingHayesAutos = true     
            local rank = exports["isPed"]:GroupRank("hayes_autos")
            if rank > 1 then 
            TunerShopCraft()
            exports['warp-textui']:showInteraction("[E] Craft")
        end
    end
end)

RegisterNetEvent('warp-polyzone:exit')
AddEventHandler('warp-polyzone:exit', function(name)
    if name == "dreams_crafting_hayes_autos" then
        DreamsCraftingHayesAutos = false
        exports['warp-textui']:hideInteraction()
    end
end)

function TunerShopCraft()
	Citizen.CreateThread(function()
        while DreamsCraftingHayesAutos do
            Citizen.Wait(5)
			if IsControlJustReleased(0, 38) then
                    local rank = exports["isPed"]:GroupRank("hayes_autos")
                    if rank > 0 then 
                    TriggerEvent('server-inventory-open', '27', 'Craft')
                end
			end
		end
	end)
end

--// Tuner Shop

DreamsTunerCraft = false

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("dreams_crafting_tuner_shop", vector3(144.39, -3050.88, 7.04), 4, 1.4, {
        name="dreams_crafting_tuner_shop",
        heading=270,
        --debugPoly=true,
        minZ=5.44,
        maxZ=9.44
    })
end)

RegisterNetEvent('warp-polyzone:enter')
AddEventHandler('warp-polyzone:enter', function(name)
    if name == "dreams_crafting_tuner_shop" then
        DreamsTunerCraft = true     
            local rank = exports["isPed"]:GroupRank("tuner_shop")
            if rank > 1 then 
            TunerShopCrafting()
            exports['warp-textui']:showInteraction("[E] Craft")
        end
    end
end)

RegisterNetEvent('warp-polyzone:exit')
AddEventHandler('warp-polyzone:exit', function(name)
    if name == "dreams_crafting_tuner_shop" then
        DreamsTunerCraft = false
        exports['warp-textui']:hideInteraction()
    end
end)

function TunerShopCrafting()
	Citizen.CreateThread(function()
        while DreamsTunerCraft do
            Citizen.Wait(5)
			if IsControlJustReleased(0, 38) then
                    local rank = exports["isPed"]:GroupRank("tuner_shop")
                    if rank > 1 then 
                    TriggerEvent('server-inventory-open', '27', 'Craft')
                end
			end
		end
	end)
end

--// Harmony Craft

DreamsHarmonyCraft = false

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("dreams_harmony_craft", vector3(1176.22, 2635.66, 37.75), 2, 3.6, {
        name="dreams_harmony_craft",
        heading=0,
        --debugPoly=true,
        minZ=35.35,
        maxZ=39.35
    })
end)

RegisterNetEvent('warp-polyzone:enter')
AddEventHandler('warp-polyzone:enter', function(name)
    if name == "dreams_harmony_craft" then
        DreamsHarmonyCraft = true     
            local rank = exports["isPed"]:GroupRank("harmony_autos")
            if rank > 1 then 
            HarmonyShopCrafting()
            exports['warp-textui']:showInteraction("[E] Craft")
        end
    end
end)

RegisterNetEvent('warp-polyzone:exit')
AddEventHandler('warp-polyzone:exit', function(name)
    if name == "dreams_harmony_craft" then
        DreamsHarmonyCraft = false
        exports['warp-textui']:hideInteraction()
    end
end)

function HarmonyShopCrafting()
	Citizen.CreateThread(function()
        while DreamsHarmonyCraft do
            Citizen.Wait(5)
			if IsControlJustReleased(0, 38) then
                    local rank = exports["isPed"]:GroupRank("harmony_autos")
                    if rank > 1 then 
                    TriggerEvent('server-inventory-open', '27', 'Craft')
                end
			end
		end
	end)
end

--// Harmony Stash

DreamsHarmony = false

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("harmony_mec_stash", vector3(1186.97, 2637.56, 38.44), 2, 2.0, {
        name="harmony_mec_stash",
        heading=0,
        --debugPoly=true,
        minZ=35.84,
        maxZ=39.84
    })
end)

RegisterNetEvent('warp-polyzone:enter')
AddEventHandler('warp-polyzone:enter', function(name)
    if name == "harmony_mec_stash" then
        DreamsHarmony = true     
            local rank = exports["isPed"]:GroupRank("harmony_autos")
            if rank > 1 then 
            HarmonyStash()
            exports['warp-textui']:showInteraction("[E] Stash")
        end
    end
end)

RegisterNetEvent('warp-polyzone:exit')
AddEventHandler('warp-polyzone:exit', function(name)
    if name == "harmony_mec_stash" then
        DreamsHarmony = false
        exports['warp-textui']:hideInteraction()
    end
end)

function HarmonyStash()
	Citizen.CreateThread(function()
        while DreamsHarmony do
            Citizen.Wait(5)
			if IsControlJustReleased(0, 38) then
                    local rank = exports["isPed"]:GroupRank("harmony_autos")
                    if rank > 1 then 
                    TriggerEvent("server-inventory-open", "1", "storage-harmony")
                end
			end
		end
	end)
end


-- // Racing Place Shit

DreamsRacingPartyTingInnit = false

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("racing_shit_like_southside_innit", vector3(1001.21, -2553.71, 32.87), 1, 4, {
        name="racing_shit_like_southside_innit",
        heading=355,
        --debugPoly=true,
        minZ=29.87,
        maxZ=33.87
    })
end)

RegisterNetEvent('warp-polyzone:enter')
AddEventHandler('warp-polyzone:enter', function(name)
    if name == "racing_shit_like_southside_innit" then
        DreamsRacingPartyTingInnit = true     
        RacingLocationWarehouseStash()
            local rank = exports["isPed"]:GroupRank("illegal_shop")
            if rank > 3 then 
            exports['warp-textui']:showInteraction("[E] Stash")
        end
    end
end)

RegisterNetEvent('warp-polyzone:exit')
AddEventHandler('warp-polyzone:exit', function(name)
    if name == "racing_shit_like_southside_innit" then
        DreamsRacingPartyTingInnit = false
        exports['warp-textui']:hideInteraction()
    end
end)

function RacingLocationWarehouseStash()
	Citizen.CreateThread(function()
        while DreamsRacingPartyTingInnit do
            Citizen.Wait(5)
			if IsControlJustReleased(0, 38) then
                    local rank = exports["isPed"]:GroupRank("illegal_shop")
                    if rank > 3 then 
                    TriggerEvent("server-inventory-open", "1", "storage-racing-shit")
                end
			end
		end
	end)
end

--// Craft

DreamsCraftingRacePlace = false

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("dreams_racing_warehouse_craft", vector3(1046.79, -2531.53, 28.29), 1.5, 4, {
        name="dreams_racing_warehouse_craft",
        heading=265,
        --debugPoly=true,
        minZ=25.29,
        maxZ=29.29
    })
end)

RegisterNetEvent('warp-polyzone:enter')
AddEventHandler('warp-polyzone:enter', function(name)
    if name == "dreams_racing_warehouse_craft" then
        DreamsCraftingRacePlace = true     
            local rank = exports["isPed"]:GroupRank("illegal_shop")
            if rank > 3 then 
            print(rank)
            RacingPlaceCraft()
            exports['warp-textui']:showInteraction("[E] Craft")
        end
    end
end)

RegisterNetEvent('warp-polyzone:exit')
AddEventHandler('warp-polyzone:exit', function(name)
    if name == "dreams_racing_warehouse_craft" then
        DreamsCraftingRacePlace = false
        exports['warp-textui']:hideInteraction()
    end
end)

function RacingPlaceCraft()
	Citizen.CreateThread(function()
        while DreamsCraftingRacePlace do
            Citizen.Wait(5)
			if IsControlJustReleased(0, 38) then
                    local rank = exports["isPed"]:GroupRank("illegal_shop")
                    if rank > 3 then 
                    TriggerEvent('server-inventory-open', '60', 'Craft')
                end
			end
		end
	end)
end