local nearPicking = false

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("cosmic_picking", vector3(164.48, -238.71, 50.06), 4.6, 4.8,  {
		name="cosmic_picking",
        heading=340,
        minZ=48.26,
        maxZ=52.26
    }) 
end)

RegisterNetEvent('warp-polyzone:enter')
AddEventHandler('warp-polyzone:enter', function(name)
    if name == "cosmic_picking" then
        local rank = exports["isPed"]:GroupRank("cosmic_cannabis")
		if rank > 0 then 
            nearPicking = true
            StartHarvisting()
			exports['warp-textui']:showInteraction(("[E] %s"):format("Start Harvisting"))
        end
    end
end)


RegisterNetEvent('warp-polyzone:exit')
AddEventHandler('warp-polyzone:exit', function(name)
    if name == "cosmic_picking" then
        nearPicking = false
    end
    exports['warp-textui']:hideInteraction()
end)

function StartHarvisting()
	Citizen.CreateThread(function()
        while nearPicking do
            Citizen.Wait(5)
            local rank = exports["isPed"]:GroupRank("cosmic_cannabis")
            if rank > 0 then 
                if IsControlJustReleased(0, 38) then
                    local lPed = PlayerPedId()
                    LoadAnim('amb@world_human_gardener_plant@male@base')
                    FreezeEntityPosition(lPed,true)
                    Citizen.Wait(500)
                    ClearPedTasksImmediately(lPed)
                    TaskPlayAnim(lPed, "amb@world_human_gardener_plant@male@base", "base", 8.0, -8, -1, 49, 0, 0, 0, 0)
                    local finished = exports['warp-taskbar']:taskBar(math.random(60000, 120000), 'Picking Weed')
                    if (finished == 100) then
                        local pWeed = math.random(2, 5)
                        TriggerEvent('player:receiveItem', 'weedq', pWeed)
                        FreezeEntityPosition(lPed,false)
                    end
                end
            end
        end
    end)
end


function LoadAnim(animDict)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(10)
	end
end

RegisterNetEvent('warp-jobs:CraftJoints')
AddEventHandler('warp-jobs:CraftJoints', function(args)
    if exports['warp-inventory']:hasEnoughOfItem('weedq', args.weedAmount) then
        FreezeEntityPosition(GetPlayerPed(-1),true)
        TriggerEvent("animation:PlayAnimation","cokecut")
        local finished = exports['warp-taskbar']:taskBar(math.random(20000, 30000), args.pBar)
        if (finished == 100) then
            TriggerEvent("inventory:removeItem","weedq", 1)
            Wait(1000)
            FreezeEntityPosition(GetPlayerPed(-1),false)
            TriggerEvent('player:receiveItem', args.craftItem, 1)
        end
    end
end)

RegisterNetEvent('warp-jobs:CraftEdibles')
AddEventHandler('warp-jobs:CraftEdibles', function(args)
    if exports['warp-inventory']:hasEnoughOfItem('weedq', args.weedAmount) then
        FreezeEntityPosition(GetPlayerPed(-1),true)
        TriggerEvent("animation:PlayAnimation","cokecut")
        local finished = exports['warp-taskbar']:taskBar(math.random(130000, 150000), args.pBar)
        if (finished == 100) then
            TriggerEvent("inventory:removeItem","weedq", 1)
            Wait(1000)
            FreezeEntityPosition(GetPlayerPed(-1),false)
            TriggerEvent('player:receiveItem', args.craftItem, 1)
        end
    end
end)

RegisterNetEvent('warp-jobs:CraftJointsMenu')
AddEventHandler('warp-jobs:CraftJointsMenu', function()
    TriggerEvent('warp-context:sendMenu', {
        {
            id = 1,
            header = "LS Confidential",
            txt = "Roll 2g LS Confidential Joint",
            params = {
                event = "warp-jobs:CraftJoints",
                args = {
                    weedAmount = 1,
                    craftItem = 'lsconfidentialjoint',
                    pBar = 'Crafting LS Confidential',
                },
            }
        },
        {
            id = 2,
            header = "Alaskan Thunder Fuck",
            txt = "Roll 2g Alaskan Thunder Fuck Joint",
            params = {
                event = "warp-jobs:CraftJoints",
                args = {
                    weedAmount = 1,
                    craftItem = 'alaskanthunderfuckjoint',
                    pBar = 'Alaskan Thunder Fuck',
                },
            }
        },
        {
            id = 3,
            header = "Chiliad Kush",
            txt = "Roll 2g Chiliad Kush Joint",
            params = {
                event = "warp-jobs:CraftJoints",
                args = {
                    weedAmount = 1,
                    craftItem = 'chiliadkushjoint',
                    pBar = 'Chiliad Kush',
                },
            }
        },
    })
end)

RegisterNetEvent("warp-jobs:EdiblesMenu")
AddEventHandler("warp-jobs:EdiblesMenu", function()
    TriggerEvent('warp-context:sendMenu', {
        {
            id = 1,
            header = "Cannabis Brownies",
            txt = "Make a batch of brownies",
            params = {
                event = "warp-jobs:CraftEdibles",
                args = {
                    weedAmount = 1,
                    craftItem = 'cbrownie',
                    pBar = 'Making Cannabis Brownies',
                },
            }
        },
        {
            id = 2,
            header = "Cannabis Absinthe",
            txt = "Make some cannabis absinthe",
            params = {
                event = "warp-jobs:CraftEdibles",
                args = {
                    weedAmount = 1,
                    craftItem = 'cabsinthe',
                    pBar = 'Making Cannabis Absinthe',
                },
            }
        },
        {
            id = 3,
            header = "Cannabis Gummies",
            txt = "Make a batch of gummies",
            params = {
                event = "warp-jobs:CraftEdibles",
                args = {
                    weedAmount = 1,
                    craftItem = 'cgummies',
                    pBar = 'Making Cannabis Gummies',
                },
            }
        },
        {
            id = 4,
            header = "420 Bar",
            txt = "Make some chocolate",
            params = {
                event = "warp-jobs:CraftEdibles",
                args = {
                    weedAmount = 1,
                    craftItem = '420bar',
                    pBar = 'Making 420 Bar',
                },
            }
        },
    })
end)

function LoadDict(dict)
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	  	Citizen.Wait(10)
    end
end

RegisterNetEvent("cosmic_cannabis:pay")
AddEventHandler("cosmic_cannabis:pay", function(amount)
    TriggerServerEvent("server:GroupPayment","cosmic_cannabis", amount)
end)

RegisterNetEvent("cosmic_cannabis:register")
AddEventHandler("cosmic_cannabis:register", function(registerID)
    local rank = exports["isPed"]:GroupRank("cosmic_cannabis")
    if rank > 0 then 
        local order = exports["warp-applications"]:KeyboardInput({
            header = "Create Receipt",
            rows = {
                {
                    id = 0,
                    txt = "Amount"
                },
                {
                    id = 1,
                    txt = "Comment"
                }
            }
        })
        if order then
            TriggerServerEvent("cosmic_cannabis:OrderComplete", registerID, order[1].input, order[2].input)
        end
    else
        TriggerEvent("DoLongHudText", "You cant use this", 2)
    end
end)

RegisterNetEvent("cosmic_cannabis:get:receipt")
AddEventHandler("cosmic_cannabis:get:receipt", function(registerid)
    TriggerServerEvent('cosmic_cannabis:retreive:receipt', registerid)
end)

RegisterNetEvent('cosmic_cannabis:openStash')
AddEventHandler('cosmic_cannabis:openStash', function()
    local rank = exports["isPed"]:GroupRank("cosmic_cannabis")
    if rank > 3 then 
        TriggerEvent("server-inventory-open", "1", "cosmic_cannabis")
    end
end)

RegisterNetEvent('cosmic_cannabis:openCounter')
AddEventHandler('cosmic_cannabis:openCounter', function()
    TriggerEvent("server-inventory-open", "1", "cosmic_counter")
end)

-- Trays

RegisterNetEvent("warp-cosmic:tray_1")
AddEventHandler("warp-cosmic:tray_1", function()
    TriggerEvent("server-inventory-open", "1", "cosmic-table-1");
end)

RegisterNetEvent("warp-cosmic:tray_2")
AddEventHandler("warp-cosmic:tray_2", function()
    TriggerEvent("server-inventory-open", "1", "cosmic-table-2");
end)
