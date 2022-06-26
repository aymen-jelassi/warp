

RegisterNetEvent('warp-jobs:VanillaUnicorn:Shop')
AddEventHandler('warp-jobs:VanillaUnicorn:Shop', function()
    local rank = exports["isPed"]:GroupRank("vanilla_unicorn") -- Purchase Ingrediants
        if rank >= 1 then 
        TriggerEvent('server-inventory-open', "50", "Shop")
    else
        TriggerEvent('DoLongHudText', 'They Do Not Recognise You', 2)
    end
end)


RegisterNetEvent('warp-jobs:VanillaUnicorn:Fridge')
AddEventHandler('warp-jobs:VanillaUnicorn:Fridge', function()
    local rank = exports["isPed"]:GroupRank("vanilla_unicorn")
        if rank >= 1 then 
            TriggerEvent("server-inventory-open", "1", "vanilla-fridge")
    else
        TriggerEvent('DoLongHudText', 'They Do Not Recognise You', 2)
    end
end)

-- Creating drinks

RegisterNetEvent('warp-jobs-Vanilla-BrewDrinks')
AddEventHandler('warp-jobs-Vanilla-BrewDrinks', function(args)
    local job = exports["isPed"]:GroupRank('vanilla_unicorn')
    if job >= 1 then
        if exports['warp-inventory']:hasEnoughOfItem(args.items1, 1) and exports['warp-inventory']:hasEnoughOfItem(args.items2, 1) and exports['warp-inventory']:hasEnoughOfItem(args.items3, 1) then
            FreezeEntityPosition(GetPlayerPed(-1),true)
            TriggerEvent("animation:PlayAnimation","cokecut")
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
        TriggerEvent('DoLongHudText', 'They Do Not Recognise You', 2)
    end
end)

RegisterNetEvent('jobs:vanilla:BrewDrinks')
AddEventHandler('jobs:vanilla:BrewDrinks', function()
    local job = exports["isPed"]:GroupRank('vanilla_unicorn')
    if job >= 1 then
        TriggerEvent('warp-context:sendMenu', {
            {
                id = 1,
                header = "VU Bar",
                txt = ""
            },
            {
                id = 2,
                header = "Martini",
                txt = "Required: 1x Vodka | 1x Watermelon | 1x Lime",
                params = {
                    event = "warp-jobs-Vanilla-BrewDrinks",
                    args = {
                        items1 = 'vodka',
                        items2 = 'lime',
                        items3 = 'watermelon',
                        pname = 'Preparing Martini',
                        make = 'martini',
                        ptext = 'Required: 1x Vodka | 1x Watermelon | 1x Lime'
                    }
                }
            },

            {
                id = 3,
                header = "Glass Of Whiskey",
                txt = "Required: 1x Vodka | 1x Coconut | 1x Cherry",
                params = {
                    event = "warp-jobs-Vanilla-BrewDrinks",
                    args = {
                        items1 = 'vodka',
                        items2 = 'cherry',
                        items3 = 'coconut',
                        pname = 'Preparing Glass Of Whiskey',
                        make = 'GlassOfWhiskey',
                        ptext = 'Required: 1x Vodka | 1x Coconut | 1x Cherry'
                    }
                }
            },

            {
                id = 4,
                header = "Margarita",
                txt = "Required: 1x Vodka | 1x Peach | 1x Kiwi",
                params = {
                    event = "warp-jobs-Vanilla-BrewDrinks",
                    args = {
                        items1 = 'vodka',
                        items2 = 'peach',
                        items3 = 'kiwi',
                        pname = 'Preparing Margarita',
                        make = 'margarita',
                        ptext = 'Required: 1x Vodka | 1x Peach | 1x Kiwi'
                    }
                }
            },

            
            {
                id = 5,
                header = "Kamikaze",
                txt = "Required: 1x Vodka | 1x Apple | 1x Lime",
                params = {
                    event = "warp-jobs-Vanilla-BrewDrinks",
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
        TriggerEvent('DoLongHudText', 'They Do Not Recognise You ', 2)
    end
end)


NearStash = false

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("stash_vanilla", vector3(93.7, -1290.55, 29.26), 1.2, 1.6, {
        name="stash_vanilla",
        heading=296,
    })
    
end)

RegisterNetEvent('warp-polyzone:enter')
AddEventHandler('warp-polyzone:enter', function(name)
    if name == "stash_vanilla" then
        local job = exports["isPed"]:GroupRank("vanilla_unicorn")
		if job >= 4 then 
            NearStash = true
            StashSpot()
			exports['warp-textui']:showInteraction(("[E] %s"):format("Open Stash"))
        end
        
    end
end)

RegisterNetEvent('warp-polyzone:exit')
AddEventHandler('warp-polyzone:exit', function(name)
    if name == "stash_vanilla" then
        NearStash = false
    end
    exports['warp-textui']:hideInteraction()
end)

function StashSpot()
	Citizen.CreateThread(function()
        while NearStash do
            Citizen.Wait(5)
			if IsControlJustReleased(0, 38) then
                local job = exports["isPed"]:GroupRank("vanilla_unicorn")
                if job >= 4 then 
                    TriggerEvent("server-inventory-open", "1", "vanilla-unicorn-stash")
                end
			end
		end
	end)
end




RegisterNetEvent("vanillUnicorn-table-1")
AddEventHandler("vanillUnicorn-table-1", function()
    TriggerEvent("server-inventory-open", "1", "Vanilla-Bar-Table");
end)

RegisterNetEvent("vanillUnicorn-table-2")
AddEventHandler("vanillUnicorn-table-2", function()
    TriggerEvent("server-inventory-open", "1", "Vanilla-Bar-Table");
end)



RegisterNetEvent("vanilla-cash:register")
AddEventHandler("vanilla-cash:register", function(registerID)
    local pler = source
    local job = exports["isPed"]:GroupRank('vanilla_unicorn')
    if job >= 1 then
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
            TriggerServerEvent("vanilla:OrderComplete", registerID, order[1].input, order[2].input)
        end
    else
        TriggerEvent("DoLongHudText", "You cant use this", 2)
    end
end)

RegisterNetEvent("vanilla:get:receipt")
AddEventHandler("vanilla:get:receipt", function(registerid)
    TriggerServerEvent('vanilla:retreive:receipt', registerid)
end)

RegisterNetEvent('vanilla:cash:in')
AddEventHandler('vanilla:cash:in', function()
    local rank = exports["isPed"]:GroupRank("vanilla_unicorn")
    if rank >= 1 then 
        local cid = exports["isPed"]:isPed("cid")
        TriggerServerEvent("vanilla:update:pay", cid)
    else
        print('not employed here')
    end
end)


RegisterNetEvent('vanilla-sitchair:1')
AddEventHandler('vanilla-sitchair:1', function()
    SetEntityHeading(GetPlayerPed(-1), 99.991180)
    SetEntityCoords(PlayerPedId(), 111.3251, -1288.633, 27.21908)
    TriggerEvent('animation:Chair2')
end)

RegisterNetEvent('vanilla-sitchair:2')
AddEventHandler('vanilla-sitchair:2', function()
    SetEntityHeading(GetPlayerPed(-1), 142.6449)
    SetEntityCoords(PlayerPedId(), 110.2726, -1287.19, 27.21908)
    TriggerEvent('animation:Chair2')
end)

RegisterNetEvent('vanilla-sitchair:3')
AddEventHandler('vanilla-sitchair:3', function()
    SetEntityHeading(GetPlayerPed(-1), 183.13546)
    SetEntityCoords(PlayerPedId(), 108.4513, -1286.742, 27.21908)
    TriggerEvent('animation:Chair2')
end)

RegisterNetEvent('vanilla-sitchair:4')
AddEventHandler('vanilla-sitchair:4', function()
    SetEntityHeading(GetPlayerPed(-1), 67.85624)
    SetEntityCoords(PlayerPedId(), 111.0651, -1290.64, 27.21908)
    TriggerEvent('animation:Chair2')
end)



-- Chairs below cuz too messy 

Citizen.CreateThread(function()

    exports["warp-polytarget"]:AddCircleZone("vanillaCHAIR1",  vector3(111.72, -1288.52, 28.26), 0.6, {
        useZ = true
    })

    exports["warp-polytarget"]:AddCircleZone("vanillaCHAIR2",  vector3(110.56, -1286.96, 28.26), 0.58, {
        useZ = true
    })

    exports["warp-polytarget"]:AddCircleZone("vanillaCHAIR3",  vector3(108.48, -1286.37, 28.26), 0.56, {
        useZ = true
    })

    exports["warp-polytarget"]:AddCircleZone("vanillaCHAIR4",  vector3(111.45, -1290.75, 28.26), 0.55, {
        useZ = true
    })

end)


Citizen.CreateThread(function()
exports["warp-interact"]:AddPeekEntryByPolyTarget("vanillaCHAIR1", {{
    event = "vanilla-sitchair:1",
    id = "sitchair_vanilla1",
    icon = "chair",
    label = "Sit down",
    parameters = {},
}}, {
    distance = { radius = 1.1 },
});

exports["warp-interact"]:AddPeekEntryByPolyTarget("vanillaCHAIR2", {{
    event = "vanilla-sitchair:2",
    id = "vanillaNOCHAIR2",
    icon = "chair",
    label = "Sit down",
    parameters = {},
}}, {
    distance = { radius = 1.5 },
});

exports["warp-interact"]:AddPeekEntryByPolyTarget("vanillaCHAIR3", {{
    event = "vanilla-sitchair:3",
    id = "vanillaNOCHAIR3",
    icon = "chair",
    label = "Sit down",
    parameters = {},
}}, {
    distance = { radius = 1.5 },
});

exports["warp-interact"]:AddPeekEntryByPolyTarget("vanillaCHAIR4", {{
    event = "vanilla-sitchair:4",
    id = "vanillaNOCHAIR4",
    icon = "chair",
    label = "Sit down",
    parameters = {},
}}, {
    distance = { radius = 1.5 },
});
end)