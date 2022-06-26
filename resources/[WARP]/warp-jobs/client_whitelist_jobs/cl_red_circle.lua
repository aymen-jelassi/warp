

RegisterNetEvent('dreams-jobs:red-circle-shop')
AddEventHandler('dreams-jobs:red-circle-shop', function()
    local rank = exports["isPed"]:GroupRank("red_circle") -- Purchase Ingrediants
        if rank >= 1 then 
        TriggerEvent('server-inventory-open', "50", "Shop")
    else
        TriggerEvent('DoLongHudText', 'You do not work here !', 2)
    end
end)


RegisterNetEvent('dreams-jobs:red-circle-fridge')
AddEventHandler('dreams-jobs:red-circle-fridge', function()
    local rank = exports["isPed"]:GroupRank("red_circle")
        if rank >= 1 then 
            TriggerEvent("server-inventory-open", "1", "redcircle-fridge")
    else
        TriggerEvent('DoLongHudText', 'You do not work here !', 2)
    end
end)

-- Creating drinks

RegisterNetEvent('warp-jobs:redcircle:MakeDrink')
AddEventHandler('warp-jobs:redcircle:MakeDrink', function(args)
    local job = exports["isPed"]:GroupRank('red_circle')
    if job >= 1 then
        if exports['warp-inventory']:hasEnoughOfItem(args.items1, 1) and exports['warp-inventory']:hasEnoughOfItem(args.items2, 1) and exports['warp-inventory']:hasEnoughOfItem(args.items3, 1) then
            FreezeEntityPosition(GetPlayerPed(-1),true)
            TriggerEvent("animation:PlayAnimation","cokecut")
            -- SetEntityHeading(GetPlayerPed(-1), 56.69291305542)
            local finished = exports['warp-taskbar']:taskBar(5000, args.pname)
            if (finished == 100) then
                FreezeEntityPosition(GetPlayerPed(-1),false)
                TriggerEvent('inventory:removeItem', args.items1, 1)
                TriggerEvent('inventory:removeItem', args.items2, 1)
                TriggerEvent('inventory:removeItem', args.items3, 1)
                TriggerEvent('player:receiveItem', args.make, 1)
            end
        else
            TriggerEvent('DoLongHudText', args.ptext, 2)
        end
    else
        TriggerEvent('DoLongHudText', 'You do not work here !', 2)
    end
end)

RegisterNetEvent('jobs:redcircle:BrewDrinks')
AddEventHandler('jobs:redcircle:BrewDrinks', function()
    local rank = exports["isPed"]:GroupRank("red_circle")
    if rank > 0 then 
        TriggerEvent('warp-context:sendMenu', {
            {
                id = 1,
                header = "Redcircle Alcohol",
                txt = ""
            },
            {
                id = 2,
                header = "Sex on the beach",
                txt = "Required: 1x Vodka | 1x Watermelon | 1x Lime",
                params = {
                    event = "warp-jobs:redcircle:MakeDrink",
                    args = {
                        items1 = 'vodka',
                        items2 = 'lime',
                        items3 = 'watermelon',
                        pname = 'Preparing Sex On The Beach',
                        make = 'shot10',
                        ptext = 'Required: 1x Vodka | 1x Watermelon | 1x Lime'
                    }
                }
            },

            {
                id = 3,
                header = "Jägermeister",
                txt = "Required: 1x Vodka | 1x Coconut | 1x Cherry",
                params = {
                    event = "warp-jobs:redcircle:MakeDrink",
                    args = {
                        items1 = 'vodka',
                        items2 = 'cherry',
                        items3 = 'coconut',
                        pname = 'Preparing Jägermeisterh',
                        make = 'shot9',
                        ptext = 'Required: 1x Vodka | 1x Coconut | 1x Cherry'
                    }
                }
            },

            {
                id = 4,
                header = "Becherovka",
                txt = "Required: 1x Vodka | 1x Peach | 1x Kiwi",
                params = {
                    event = "warp-jobs:redcircle:MakeDrink",
                    args = {
                        items1 = 'vodka',
                        items2 = 'peach',
                        items3 = 'kiwi',
                        pname = 'Preparing Becherovka',
                        make = 'shot8',
                        ptext = 'Required: 1x Vodka | 1x Peach | 1x Kiwi'
                    }
                }
            },

            
            {
                id = 5,
                header = "Kamikaze",
                txt = "Required: 1x Vodka | 1x Apple | 1x Lime",
                params = {
                    event = "warp-jobs:redcircle:MakeDrink",
                    args = {
                        items1 = 'vodka',
                        items2 = 'apple',
                        items3 = 'lime',
                        pname = 'Preparing Kamikaze',
                        make = 'shot7',
                        ptext = 'Required: 1x Vodka | 1x Apple | 1x Lime'
                    }
                }
            }, 


            {
                id = 6,
                header = "Close",
                txt = "",
                params = {
                    event = ""
                }
            },
        })      
    else
        TriggerEvent('DoLongHudText', 'You do not work here ! ', 2)
    end
end)

--// Stash

nearRedStash = false

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("red_circle_stash", vector3(-320.67, 192.31, 104.09), 0.7, 2.35, {
        name="red_circle_stash",
        heading=10,
    })
end)

RegisterNetEvent('warp-polyzone:enter')
AddEventHandler('warp-polyzone:enter', function(name)
    if name == "red_circle_stash" then
        local rank = exports["isPed"]:GroupRank("red_circle")
		if rank > 3 then 
            nearRedStash = true
            RStash()
			exports['warp-textui']:showInteraction(("[E] %s"):format("Open Stash"))
        end
    end
end)

RegisterNetEvent('warp-polyzone:exit')
AddEventHandler('warp-polyzone:exit', function(name)
    if name == "red_circle_stash" then
        nearRedStash = false
    end
    exports['warp-textui']:hideInteraction()
end)

function RStash()
	Citizen.CreateThread(function()
        while nearRedStash do
            Citizen.Wait(5)
			if IsControlJustReleased(0, 38) then
                local job = exports["isPed"]:GroupRank('red_circle')
                if job >= 3 then
                    TriggerEvent("server-inventory-open", "1", "red-circle-stash")
                    Wait(1000)
                end
			end
		end
	end)
end


-- Seats | Sat On Via 3rd Eye

RegisterNetEvent('warp-jobs:red-circle_seat_vip_1')
AddEventHandler('warp-jobs:red-circle_seat_vip_1', function()
    SetEntityHeading(GetPlayerPed(-1), 99.212593078613)
    SetEntityCoords(PlayerPedId(), -309.08572387695,187.10847903809,103.02000065625)
    TriggerEvent('animation:Chair2')
end)

RegisterNetEvent('warp-jobs:red-circle_seat_vip_2')
AddEventHandler('warp-jobs:red-circle_seat_vip_2', function()
    SetEntityHeading(GetPlayerPed(-1), 289.13385009766)
    SetEntityCoords(PlayerPedId(), -310.9186706543,186.777777,103.02000065625)
    TriggerEvent('animation:Chair2')
end)

RegisterNetEvent('warp-jobs:red-circle_seat_vip_3')
AddEventHandler('warp-jobs:red-circle_seat_vip_3', function()
    SetEntityHeading(GetPlayerPed(-1), 201.25984191895)
    SetEntityCoords(PlayerPedId(), -302.04076171875,186.70439758301,102.00366210938)
    TriggerEvent('animation:Chair2')
end)

RegisterNetEvent('warp-jobs:red-circle_seat_vip_4')
AddEventHandler('warp-jobs:red-circle_seat_vip_4', function()
    SetEntityHeading(GetPlayerPed(-1), 297.63778686523)
    SetEntityCoords(PlayerPedId(), -302.80877685547,185.32746887207,101.88888888888)
    TriggerEvent('animation:Chair2')
end)

RegisterCommand('ay', function()
    TriggerEvent('warp-jobs:red-circle_seat_vip_4')
end)

-- Tables | Open'd VIA 3rd Eye

-- VIP

RegisterNetEvent("warp-jobs:red_circle-table-1")
AddEventHandler("warp-jobs:red_circle-table-1", function()
    TriggerEvent("server-inventory-open", "1", "redcircle_table_1_vip");
end)

RegisterNetEvent("warp-jobs:red_circle-table-2")
AddEventHandler("warp-jobs:red_circle-table-2", function()
    TriggerEvent("server-inventory-open", "1", "redcircle_table_1_vip");
end)

-- Regular

RegisterNetEvent("warp-jobs:red_circle-table-3")
AddEventHandler("warp-jobs:red_circle-table-3", function()
    TriggerEvent("server-inventory-open", "1", "redcircle_table_3");
end)

RegisterNetEvent("warp-jobs:red_circle-table-4")
AddEventHandler("warp-jobs:red_circle-table-4", function()
    TriggerEvent("server-inventory-open", "1", "redcircle_table_4");
end)

RegisterNetEvent("warp-jobs:red_circle-table-5")
AddEventHandler("warp-jobs:red_circle-table-5", function()
    TriggerEvent("server-inventory-open", "1", "redcircle_table_5");
end)

RegisterNetEvent("warp-jobs:red_circle-table-6")
AddEventHandler("warp-jobs:red_circle-table-6", function()
    TriggerEvent("server-inventory-open", "1", "redcircle_table_6");
end)

RegisterNetEvent("warp-jobs:red_circle-table-7")
AddEventHandler("warp-jobs:red_circle-table-7", function()
    TriggerEvent("server-inventory-open", "1", "redcircle_table_7");
end)

RegisterNetEvent("warp-jobs:red_circle-table-8")
AddEventHandler("warp-jobs:red_circle-table-8", function()
    TriggerEvent("server-inventory-open", "1", "redcircle_table_8");
end)

-- Booths

-- Booth 1 Start
RegisterNetEvent("warp-jobs:red_circle-booth-1-table-1")
AddEventHandler("warp-jobs:red_circle-booth-1-table-1", function()
    TriggerEvent("server-inventory-open", "1", "redcircle_booth_1_table_1");
end)

RegisterNetEvent("warp-jobs:red_circle-booth-1-table-2")
AddEventHandler("warp-jobs:red_circle-booth-1-table-2", function()
    TriggerEvent("server-inventory-open", "1", "redcircle_booth_1_table_2");
end)
-- Booth 1 End

-- Booth 2 Start
RegisterNetEvent("warp-jobs:red_circle-booth-2-table-1")
AddEventHandler("warp-jobs:red_circle-booth-2-table-1", function()
    TriggerEvent("server-inventory-open", "1", "redcircle_booth_2_table_1");
end)

RegisterNetEvent("warp-jobs:red_circle-booth-2-table-2")
AddEventHandler("warp-jobs:red_circle-booth-2-table-2", function()
    TriggerEvent("server-inventory-open", "1", "redcircle_booth_2_table_2");
end)
-- Booth 2 End

-- Booth 3 Start
RegisterNetEvent("warp-jobs:red_circle-booth-3-table-1")
AddEventHandler("warp-jobs:red_circle-booth-3-table-1", function()
    TriggerEvent("server-inventory-open", "1", "redcircle_booth_3_table_1");
end)

RegisterNetEvent("warp-jobs:red_circle-booth-3-table-2")
AddEventHandler("warp-jobs:red_circle-booth-3-table-2", function()
    TriggerEvent("server-inventory-open", "1", "redcircle_booth_3_table_2");
end)
-- Booth 3 End

-- Booth 4 Start
RegisterNetEvent("warp-jobs:red_circle-booth-4-table-1")
AddEventHandler("warp-jobs:red_circle-booth-4-table-1", function()
    TriggerEvent("server-inventory-open", "1", "redcircle_booth_4_table_1");
end)

RegisterNetEvent("warp-jobs:red_circle-booth-4-table-2")
AddEventHandler("warp-jobs:red_circle-booth-4-table-2", function()
    TriggerEvent("server-inventory-open", "1", "redcircle_booth_4_table_2");
end)
-- Booth 4 End

-- Elevator

RegisterNetEvent('warp-jobs:red-circle:main-floor:elevator_go_up')
AddEventHandler('warp-jobs:red-circle:main-floor:elevator_go_up', function()
    local job = exports["isPed"]:GroupRank('red_circle')
    if job >= 3 then
        local finished = exports['warp-taskbar']:taskBar(5000, 'Calling Elevator')
        if (finished == 100) then
            SetEntityHeading(GetPlayerPed(-1), 286.29919433594)
            SetEntityCoords(PlayerPedId(), -316.8923034668,217.89889526367,99.86376953125)
        end
    end
end)

RegisterNetEvent('warp-jobs:red-circle:main-floor:elevator_go_down')
AddEventHandler('warp-jobs:red-circle:main-floor:elevator_go_down', function()
    local job = exports["isPed"]:GroupRank('red_circle')
    if job >= 3 then
        local finished = exports['warp-taskbar']:taskBar(5000, 'Calling Elevator')
        if (finished == 100) then
            SetEntityHeading(GetPlayerPed(-1), 283.4645690918)
            SetEntityCoords(PlayerPedId(), -318.35604858398,217.02856445312,87.86669921875)
        end
    end
end)

-- Cash Registers

RegisterNetEvent("red_circle-cash:register")
AddEventHandler("red_circle-cash:register", function(registerID)
    local rank = exports["isPed"]:GroupRank("red_circle")
    if rank > 1 then 
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
            TriggerServerEvent("red_circle:OrderComplete", registerID, order[1].input, order[2].input)
        end
    else
        TriggerEvent("DoLongHudText", "You cant use this", 2)
    end
end)

RegisterNetEvent("red_circle:get:receipt")
AddEventHandler("red_circle:get:receipt", function(registerid)
    TriggerServerEvent('red_circle:retreive:receipt', registerid)
end)

RegisterNetEvent('red_circle:cash:in')
AddEventHandler('red_circle:cash:in', function()
    local cid = exports["isPed"]:isPed("cid")
    TriggerServerEvent("red_circle:update:pay", cid)
end)