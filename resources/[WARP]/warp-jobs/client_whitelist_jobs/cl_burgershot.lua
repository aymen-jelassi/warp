RegisterNetEvent("dreams-burgershot:pay")
AddEventHandler("dreams-burgershot:pay", function(amount)
    TriggerServerEvent("server:GroupPayment","burger_shot", amount)
end)

RegisterNetEvent("dreams-burgershot:startjob")
AddEventHandler("dreams-burgershot:startjob", function()
    local rank = exports["isPed"]:GroupRank("burger_shot")
    local vehicle = GetHashKey('panto')
    if rank >= 1 then     
        RequestModel(vehicle)
    
        while not HasModelLoaded(vehicle) do
            Wait(1)
        end
    
        local plate = "BURGER" .. math.random(1, 100)
        local spawned_car = CreateVehicle(vehicle, -1168.9582519531, -895.20001220703, 13.9296875, 34.015747070312, true, false)
        SetVehicleEngineTorqueMultiplier(spawned_car, 0.2)
        SetVehicleOnGroundProperly(spawned_car)
        SetVehicleNumberPlateText(spawned_car, plate)
        SetPedIntoVehicle(GetPlayerPed(-1), spawned_car, - 1)
        SetModelAsNoLongerNeeded(vehicle)
        TriggerEvent("keys:addNew",spawned_car,plate)
        Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(spawned_car))
    else
        TriggerEvent('DoLongHudText', 'You dont work here', 2)
    end
end)

--- Burger >> Beef

RegisterNetEvent("dreams-burgershot:startprocess")
AddEventHandler("dreams-burgershot:startprocess", function()
    local finished = exports['warp-taskbar']:taskBar(5000, 'Grabbing Cow')
    local rank = exports["isPed"]:GroupRank("burger_shot")
    if rank >= 1 then     
        if (finished == 100) then
            TriggerEvent('player:receiveItem', 'cow', 1)
            FreezeEntityPosition(GetPlayerPed(-1),false)
            ClearPedTasks(GetPlayerPed(-1))
            Citizen.Wait(1000)
            TriggerEvent("animation:PlayAnimation","layspike")
            Citizen.Wait(1000)
        end
    else
        TriggerEvent('DoLongHudText', 'You dont work here', 2)
    end
end)


RegisterNetEvent("dreams-burgershot:startprocess2")
AddEventHandler("dreams-burgershot:startprocess2", function()
    local rank = exports["isPed"]:GroupRank("burger_shot")
    if rank >= 1 then     
        if exports["warp-inventory"]:hasEnoughOfItem("cow", 1) then 
            local dict = 'anim@amb@business@coc@coc_unpack_cut_left@'
            LoadDict(dict)
            FreezeEntityPosition(GetPlayerPed(-1),true)
            TaskPlayAnim(GetPlayerPed(-1), dict, "coke_cut_v1_coccutter", 3.0, -8, -1, 63, 0, 0, 0, 0 )
            SetEntityHeading(GetPlayerPed(-1), 82.204727172852)
            local finished = exports['warp-taskbar']:taskBar(5000, 'Cutting Up Cow')
            if (finished == 100) then
                TriggerEvent("inventory:removeItem", "cow", 1)
                TriggerEvent('player:receiveItem', 'beef', math.random(10, 20))
                FreezeEntityPosition(GetPlayerPed(-1),false)
                ClearPedTasks(GetPlayerPed(-1))
                Citizen.Wait(1000)
                TriggerEvent("animation:PlayAnimation","layspike")
            end
        else
            TriggerEvent('DoLongHudText', 'You need more cow to process! (Required Amount: 1)', 2)
        end
    else
                TriggerEvent('DoLongHudText', 'You dont work here', 2)
    end
end)

RegisterNetEvent("dreams-burgershot:startprocess3")
AddEventHandler("dreams-burgershot:startprocess3", function()
    local rank = exports["isPed"]:GroupRank("burger_shot")
    if rank >= 1 then    
        if exports["warp-inventory"]:hasEnoughOfItem("beef", 5) then 
            local finished = exports['warp-taskbar']:taskBar(5000, 'Processing Beef')
            if (finished == 100) then
                TriggerEvent("inventory:removeItem", "beef", 5)
                TriggerEvent('player:receiveItem', 'groundbeef', math.random(3, 4))
                FreezeEntityPosition(GetPlayerPed(-1),false)
                ClearPedTasks(GetPlayerPed(-1))
                Citizen.Wait(1000)
                TriggerEvent("animation:PlayAnimation","layspike")
                Citizen.Wait(1000)
            end
        else
            TriggerEvent('DoLongHudText', 'You need more beef to process! (Required Amount: 5)', 2)
        end
    else
        TriggerEvent('DoLongHudText', 'You dont work here', 2)
    end
end)

RegisterNetEvent("dreams-burgershot:startfryer")
AddEventHandler("dreams-burgershot:startfryer", function()
    local rank = exports["isPed"]:GroupRank("burger_shot")
    if rank >= 1 then    
        if exports['warp-inventory']:hasEnoughOfItem('potato', 1) then
            local dict = 'anim@amb@business@coc@coc_unpack_cut_left@'
            LoadDict(dict)
            FreezeEntityPosition(GetPlayerPed(-1),true)
            TaskPlayAnim(GetPlayerPed(-1), dict, "coke_cut_v1_coccutter", 3.0, -8, -1, 63, 0, 0, 0, 0 )
            SetEntityHeading(GetPlayerPed(-1), 124.72439575195)
            local finished = exports['warp-taskbar']:taskBar(10000, 'Dropping Fries')
            if (finished == 100) then
                TriggerEvent('player:receiveItem', 'fries', 1)
                TriggerEvent('inventory:removeItem', 'potato', 1)
                FreezeEntityPosition(GetPlayerPed(-1),false)
                ClearPedTasks(GetPlayerPed(-1))
                Citizen.Wait(1000)
            end
        else
            TriggerEvent('DoLongHudText', "You need more patato's (Required Amount: x1)", 2)
        end
    else
        TriggerEvent('DoLongHudText', 'You dont work here', 2)
    end
end)

RegisterNetEvent("dreams-burgershot:makeshake")
AddEventHandler("dreams-burgershot:makeshake", function()
    local rank = exports["isPed"]:GroupRank("burger_shot")
    if rank >= 1 then    
        if exports['warp-inventory']:hasEnoughOfItem('milk', 1) then
        SetEntityHeading(GetPlayerPed(-1), 121.88976287842)
        TriggerEvent("animation:PlayAnimation","browse")
        FreezeEntityPosition(GetPlayerPed(-1),true)
        local finished = exports['warp-taskbar']:taskBar(10000, 'Making Shake')
        if (finished == 100) then
            TriggerEvent('inventory:removeItem', 'milk', 1)
            TriggerEvent('player:receiveItem', 'mshake', 1)
            FreezeEntityPosition(GetPlayerPed(-1),false)
            ClearPedTasks(GetPlayerPed(-1))
            Citizen.Wait(1000)
            TriggerEvent("animation:PlayAnimation","layspike")
            Citizen.Wait(1000)
        else
            FreezeEntityPosition(GetPlayerPed(-1),false)
        end
    else
        TriggerEvent('DoLongHudText',"You need milk (Required Amount: x1)",2)
    end
else
    TriggerEvent('DoLongHudText', 'You dont work here', 2)
end
end)


RegisterNetEvent("dreams-burgershot:soft-drink")
AddEventHandler("dreams-burgershot:soft-drink", function()
    local rank = exports["isPed"]:GroupRank("burger_shot")
    if rank >= 1 then   
        if exports['warp-inventory']:hasEnoughOfItem('burgershot_cup', 1) then
        SetEntityHeading(GetPlayerPed(-1), 121.88976287842)
        TriggerEvent("animation:PlayAnimation","browse")
        FreezeEntityPosition(GetPlayerPed(-1),true)
        local finished = exports['warp-taskbar']:taskBar(10000, 'Making Soft Drink')
        if (finished == 100) then
            TriggerEvent('player:receiveItem', 'softdrink', 1)
            TriggerEvent('inventory:removeItem', 'burgershot_cup', 1)
            FreezeEntityPosition(GetPlayerPed(-1),false)
            ClearPedTasks(GetPlayerPed(-1))
            Citizen.Wait(1000)
        else
            FreezeEntityPosition(GetPlayerPed(-1),false)
        end
    else
        TriggerEvent('DoLongHudText',"Required Ingridients: 1x Sugar | 1x Empty Burgershot Cup",2)
    end
else
    TriggerEvent('DoLongHudText', 'You dont work here', 2)
end
end)

RegisterNetEvent("dreams-burgershot:getcola")
AddEventHandler("dreams-burgershot:getcola", function()
    local rank = exports["isPed"]:GroupRank("burger_shot")
    if rank >= 1 then  
        if exports['warp-inventory']:hasEnoughOfItem('sugarbs', 1) then  
        SetEntityHeading(GetPlayerPed(-1), 121.88976287842)
        TriggerEvent("animation:PlayAnimation","browse")
        FreezeEntityPosition(GetPlayerPed(-1),true)
        local finished = exports['warp-taskbar']:taskBar(10000, 'Pouring Cola')
        if (finished == 100) then
            TriggerEvent('player:receiveItem', 'cola', 1)
            TriggerEvent('inventory:removeItem', 'sugarbs', 1)
            FreezeEntityPosition(GetPlayerPed(-1),false)
            ClearPedTasks(GetPlayerPed(-1))
            Citizen.Wait(1000)
            TriggerEvent("animation:PlayAnimation","layspike")
            Citizen.Wait(1000)
        else
            FreezeEntityPosition(GetPlayerPed(-1),false)
        end
    else
        TriggerEvent('DoLongHudText',"You need more sugar (Required Amount: x1)",2)
    end
else
    TriggerEvent('DoLongHudText', 'You dont work here', 2)
end
end)

RegisterNetEvent('warp-burgershot:get_water')
AddEventHandler('warp-burgershot:get_water', function()
    local rank = exports["isPed"]:GroupRank("burger_shot")
    if rank >= 1 then
        SetEntityHeading(GetPlayerPed(-1), 121.88976287842)
        TriggerEvent("animation:PlayAnimation","browse")
        FreezeEntityPosition(GetPlayerPed(-1),true)
        local finished = exports['warp-taskbar']:taskBar(10000, 'Pouring Water')
        if (finished == 100) then
            TriggerEvent('player:receiveItem', 'water', 1)
            FreezeEntityPosition(GetPlayerPed(-1),false)
            ClearPedTasks(GetPlayerPed(-1))
        else
            FreezeEntityPosition(GetPlayerPed(-1),false)
        end
    end
end)

function LoadDict(dict)
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	  	Citizen.Wait(10)
    end
end

--// Stash

RegisterNetEvent('dreams-burgershot:stash')
AddEventHandler('dreams-burgershot:stash', function()
    local job = exports["isPed"]:GroupRank('burger_shot')
    if job >= 1 then
		TriggerEvent("server-inventory-open", "1", "storage-burger_shot")
		Wait(1000)
    else
        TriggerEvent('DoLongHudText', 'You do not work here !',2)
        end
    end)

    --// Food Warmer

RegisterNetEvent('warp-jobs:burgershot-warmer')
AddEventHandler('warp-jobs:burgershot-warmer', function()
    local job = exports["isPed"]:GroupRank('burger_shot')
    if job >= 1 then
		TriggerEvent("server-inventory-open", "1", "storage-burger_warmer")
		Wait(1000)
    else
        TriggerEvent('DoLongHudText', 'You do not work here !',2)
        end
    end)


--// Counter

RegisterNetEvent('dreams-burgershot:counter')
AddEventHandler('dreams-burgershot:counter', function()
    local job = exports["isPed"]:GroupRank('burger_shot')
    if job >= 1 then
		TriggerEvent("server-inventory-open", "1", "counter-burger_shot")
		Wait(1000)
else
    TriggerEvent('DoLongHudText', 'You do not work here !',2)
    end
end)

--// Store

RegisterNetEvent('dreams-burgershot:store')
AddEventHandler('dreams-burgershot:store', function()
    local job = exports["isPed"]:GroupRank('burger_shot')
    if job >= 1 then
        TriggerEvent("server-inventory-open", "45", "Shop")
		Wait(1000)
    else
        TriggerEvent('DoLongHudText', 'You do not work here !',2)
        end
    end)

--// Make Burgers

RegisterNetEvent('dreams-civjobs:burgershot-heartstopper')
AddEventHandler('dreams-civjobs:burgershot-heartstopper', function()
    local ped = PlayerPedId()
    local job = exports["isPed"]:GroupRank('burger_shot')
    if job >= 1 then
        if exports['warp-inventory']:hasEnoughOfItem('burgershotpatty', 2) and exports['warp-inventory']:hasEnoughOfItem('lettuce', 1) and exports['warp-inventory']:hasEnoughOfItem('hamburgerbuns', 1) and exports['warp-inventory']:hasEnoughOfItem('tomato', 1) and exports['warp-inventory']:hasEnoughOfItem('cheese', 1) then
            FreezeEntityPosition(ped, true)
            ExecuteCommand('e cokecut')
            local heartstopper = exports['warp-taskbar']:taskBar(5000, 'Cooking Heartstopper')
            if (heartstopper == 100) then
                FreezeEntityPosition(ped, false)
                TriggerEvent('inventory:removeItem', 'hamburgerbuns', 1) 
                TriggerEvent('inventory:removeItem', 'burgershotpatty', 2) 
                TriggerEvent('inventory:removeItem', 'lettuce', 1) 
                TriggerEvent('inventory:removeItem', 'tomato', 1)
                TriggerEvent('inventory:removeItem', 'cheese', 1)
                TriggerEvent('player:receiveItem', 'heartstopper', 1)
                TriggerEvent('DoLongHudText', 'Cooked Heartstopper', 1)
            else
                FreezeEntityPosition(ped, false)
            end
        else
            TriggerEvent('DoLongHudText', 'You dont have the right ingredients', 2)
        end
    else
        TriggerEvent('DoLongHudText', 'You dont work here', 2)
    end
end)

RegisterNetEvent('dreams-civjobs:burgershot-moneyshot')
AddEventHandler('dreams-civjobs:burgershot-moneyshot', function()
    local ped = PlayerPedId()
    local job = exports["isPed"]:GroupRank('burger_shot')
    if job >= 1 then
        if exports['warp-inventory']:hasEnoughOfItem('hamburgerbuns', 1) and exports['warp-inventory']:hasEnoughOfItem('burgershotpatty', 1) and exports['warp-inventory']:hasEnoughOfItem('lettuce', 1) and exports['warp-inventory']:hasEnoughOfItem('tomato', 1) and exports['warp-inventory']:hasEnoughOfItem('cheese', 1) then
            FreezeEntityPosition(ped, true)
            ExecuteCommand('e cokecut')
            local moneyshot = exports['warp-taskbar']:taskBar(5000, 'Cooking Moneyshot')
            if (moneyshot == 100) then
                FreezeEntityPosition(ped, false)
                TriggerEvent('inventory:removeItem', 'hamburgerbuns', 1)
                TriggerEvent('inventory:removeItem', 'burgershotpatty', 1)
                TriggerEvent('inventory:removeItem', 'lettuce', 1)
                TriggerEvent('inventory:removeItem', 'tomato', 1)
                TriggerEvent('inventory:removeItem', 'cheese', 1)
                TriggerEvent('player:receiveItem', 'moneyshot', 1)
                TriggerEvent('DoLongHudText', 'Cooked Moneyshot', 1)
            else
                FreezeEntityPosition(ped, false)
            end
        else
            TriggerEvent('DoLongHudText', 'You dont have the right ingredients', 2)
        end
    else
        TriggerEvent('DoLongHudText', 'You dont work here', 2)
    end
end)

RegisterNetEvent('dreams-civjobs:burgershot-meatfree')
AddEventHandler('dreams-civjobs:burgershot-meatfree', function()
    local ped = PlayerPedId()
    local job = exports["isPed"]:GroupRank('burger_shot')
    if job >= 1 then
        if exports['warp-inventory']:hasEnoughOfItem('burgershotpatty2', 1) and exports['warp-inventory']:hasEnoughOfItem('lettuce', 1) and exports['warp-inventory']:hasEnoughOfItem('hamburgerbuns', 1) then
            FreezeEntityPosition(ped, true)
            ExecuteCommand('e cokecut')
            local meatfree = exports['warp-taskbar']:taskBar(5000, 'Cooking Meat Free')
            if (meatfree == 100) then
                FreezeEntityPosition(ped, false)
                TriggerEvent('inventory:removeItem', 'lettuce', 1)
                TriggerEvent('inventory:removeItem', 'hamburgerbuns', 1)
                TriggerEvent('inventory:removeItem', 'burgershotpatty2', 1)
                TriggerEvent('player:receiveItem', 'meatfree', 1)
            else
                FreezeEntityPosition(ped, false)
            end
        else
            TriggerEvent('DoLongHudText', 'You dont have the right ingredients', 2)
        end
    else
        TriggerEvent('DoLongHudText', 'You dont work here', 2)
    end
end)  

RegisterNetEvent('dreams-civjobs:burgershot-bleeder')
AddEventHandler('dreams-civjobs:burgershot-bleeder', function()
    local ped = PlayerPedId()
    local job = exports["isPed"]:GroupRank('burger_shot')
    if job >= 1 then
        if exports['warp-inventory']:hasEnoughOfItem('hamburgerbuns', 1) and exports['warp-inventory']:hasEnoughOfItem('lettuce', 1) and exports['warp-inventory']:hasEnoughOfItem('burgershotpatty', 1) and exports['warp-inventory']:hasEnoughOfItem('cheese', 1) and exports['warp-inventory']:hasEnoughOfItem('tomato', 1) then
            FreezeEntityPosition(ped, true)
            ExecuteCommand('e cokecut')
            local meatfree = exports['warp-taskbar']:taskBar(5000, 'Cooking Bleeder Burger')
            if (meatfree == 100) then
                FreezeEntityPosition(ped, false)
                TriggerEvent('inventory:removeItem', 'lettuce', 1)
                TriggerEvent('inventory:removeItem', 'hamburgerbuns', 1)
                TriggerEvent('inventory:removeItem', 'burgershotpatty', 1)
                TriggerEvent('inventory:removeItem', 'tomato', 1)
                TriggerEvent('inventory:removeItem', 'cheese', 1)
                TriggerEvent('player:receiveItem', 'bleederburger', 1)
            else
                FreezeEntityPosition(ped, false)
            end
        else
            TriggerEvent('DoLongHudText', 'You dont have the right ingredients', 2)
        end
    else
        TriggerEvent('DoLongHudText', 'You dont work here', 2)
    end
end)  

RegisterNetEvent('warp-jobs:burgershot-drinks')
AddEventHandler('warp-jobs:burgershot-drinks', function()
    local job = exports["isPed"]:GroupRank('burger_shot')
    if job >= 1 then
        TriggerEvent('warp-context:sendMenu', {
            {
                id = 1,
                header = "Burger Shot Drinks",
                txt = ""
            },
            {
                id = 2,
                header = "Pour Cola",
                txt = "Pour a nice refreshing Cola",
                params = {
                    event = "dreams-burgershot:getcola"
                }
            },
            {
                id = 3,
                header = "Pour Milkshake",
                txt = "Pour a Ice Cold Milkshake",
                params = {
                    event = "dreams-burgershot:makeshake"
                }
            },
            {
                id = 4,
                header = "Pour Soft Drink",
                txt = "Pour a monsterous sweet Soft Drink",
                params = {
                    event = "dreams-burgershot:soft-drink"
                }
            },
            {
                id = 5,
                header = "Pour A Cup Of Water",
                txt = "Pour a Cup Of Water",
                params = {
                    event = "warp-burgershot:get_water"
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
        TriggerEvent('DoLongHudText', 'You do not work here !',2)
    end
end)


RegisterNetEvent('warp-civjobs:burgershot-make-burgers')
AddEventHandler('warp-civjobs:burgershot-make-burgers', function()
    local job = exports["isPed"]:GroupRank('burger_shot')
    if job >= 1 then
        TriggerEvent('warp-context:sendMenu', {
            {
                id = 1,
                header = "Burger Shot Burgers",
                txt = ""
            },
            {
                id = 2,
                header = "Cook Heartstopper",
                txt = "Requires: 1x Burger Buns | 1x Cooked Burger Pattys | 1x Lettuce | 1x Tomato | 1x Cheese",
                params = {
                    event = "dreams-civjobs:burgershot-heartstopper"
                }
            },
            {
                id = 3,
                header = "Cook Moneyshot",
                txt = "Requires: 1x Burger Buns | 1x Cooked Burger Patty | 1x Cheese | 1x Lettuce | 1x Tomato",
                params = {
                    event = "dreams-civjobs:burgershot-moneyshot"
                }
            },
            {
                id = 4,
                header = "Cook Meat Free",
                txt = "Requires: 1x Burger Buns | 1x Lettuce | 1x Cooked Meat Free Patty",
                params = {
                    event = "dreams-civjobs:burgershot-meatfree"
                }
            },
            {
                id = 5,
                header = "Cook Bleeder Burger",
                txt = "Requires: 1x Lettuce | 1x Patty | 1x Burger Buns",
                params = {
                    event = "dreams-civjobs:burgershot-bleeder"
                }
            },
        })
    else
        TriggerEvent('DoLongHudText', 'You do not work here !',2)
    end
end)

--// Meat No Meat?

RegisterNetEvent('warp-civjobs:burgershot-make-pattys')
AddEventHandler('warp-civjobs:burgershot-make-pattys', function()
    local job = exports["isPed"]:GroupRank('burger_shot')
    if job >= 1 then
        TriggerEvent('warp-context:sendMenu', {
            {
                id = 1,
                header = "Burger Shot Pattys",
                txt = ""
            },
            {
                id = 2,
                header = "Cook Patty (Contains Meat)",
                txt = "Requires: 1x Raw Patty (Contains Meat)",
                params = {
                    event = "dreams-burgershot:contains-meat"
                }
            },
            {
                id = 3,
                header = "Cook Patty (Doesnt Contain Meat)",
                txt = "Requires: 1x Raw Patty (Doesnt Contain Meat)",
                params = {
                    event = "dreams-burgershot:doesnt-contains-meat"
                }
            },
        })
    else
        TriggerEvent('DoLongHudText', 'You do not work here !',2)
    end
end)

RegisterNetEvent("dreams-burgershot:contains-meat")
AddEventHandler("dreams-burgershot:contains-meat", function()
    local rank = exports["isPed"]:GroupRank("burger_shot")
    if rank >= 1 then    
        if exports["warp-inventory"]:hasEnoughOfItem("rawpatty", 1) then 
            local dict = 'anim@amb@business@coc@coc_unpack_cut_left@'
            LoadDict(dict)
            FreezeEntityPosition(GetPlayerPed(-1),true)
            TaskPlayAnim(GetPlayerPed(-1), dict, "coke_cut_v1_coccutter", 3.0, -8, -1, 63, 0, 0, 0, 0 )
            SetEntityHeading(GetPlayerPed(-1), 124.72439575195)
            local finished = exports['warp-taskbar']:taskBar(7500, 'Cooking Patty')
            if (finished == 100) then
                TriggerEvent("inventory:removeItem", "rawpatty", 1)
                TriggerEvent('player:receiveItem', 'burgershotpatty', 1)
                FreezeEntityPosition(GetPlayerPed(-1),false)
                ClearPedTasks(GetPlayerPed(-1))
                Citizen.Wait(1000)
            end
        else
            TriggerEvent('DoLongHudText', 'You need more Raw Pattys to cook! (Required Amount: 1)', 2)
        end
    else
        TriggerEvent('DoLongHudText', 'You dont work here', 2)
    end
end)

RegisterNetEvent("dreams-burgershot:doesnt-contains-meat")
AddEventHandler("dreams-burgershot:doesnt-contains-meat", function()
    local rank = exports["isPed"]:GroupRank("burger_shot")
    if rank >= 1 then    
        if exports["warp-inventory"]:hasEnoughOfItem("rawpatty2", 1) then 
            local dict = 'anim@amb@business@coc@coc_unpack_cut_left@'
            LoadDict(dict)
            FreezeEntityPosition(GetPlayerPed(-1),true)
            TaskPlayAnim(GetPlayerPed(-1), dict, "coke_cut_v1_coccutter", 3.0, -8, -1, 63, 0, 0, 0, 0 )
            SetEntityHeading(GetPlayerPed(-1), 124.72439575195)
            local finished = exports['warp-taskbar']:taskBar(7500, 'Cooking Patty')
            if (finished == 100) then
                TriggerEvent("inventory:removeItem", "rawpatty2", 1)
                TriggerEvent('player:receiveItem', 'burgershotpatty2', 1)
                FreezeEntityPosition(GetPlayerPed(-1),false)
                ClearPedTasks(GetPlayerPed(-1))
                Citizen.Wait(1000)
            end
        else
            TriggerEvent('DoLongHudText', 'You need more Raw Pattys to cook! (Required Amount: 1)', 2)
        end
    else
        TriggerEvent('DoLongHudText', 'You dont work here', 2)
    end
end)

--// Registers

RegisterNetEvent("burgershot:register")
AddEventHandler("burgershot:register", function(registerID)
    local rank = exports["isPed"]:GroupRank("burger_shot")
    if rank >= 1 then 
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
            TriggerServerEvent("burger_shot:OrderComplete", registerID, order[1].input, order[2].input)
        end
    else
        TriggerEvent("DoLongHudText", "You cant use this", 2)
    end
end)

RegisterNetEvent("burgershot:get:receipt")
AddEventHandler("burgershot:get:receipt", function(registerid)
    TriggerServerEvent('burgershot:retreive:receipt', registerid)
end)

RegisterNetEvent('burgershot:cash:in')
AddEventHandler('burgershot:cash:in', function()
    local cid = exports["isPed"]:isPed("cid")
    TriggerServerEvent("burgershot:update:pay", cid)
end)

-- Boss Stash

RegisterNetEvent('warp-jobs:burgershot_boss_stash')
AddEventHandler('warp-jobs:burgershot_boss_stash', function()
    local BSRank = exports['isPed']:GroupRank('burger_shot')
    if BSRank >= 3 then
        TriggerEvent('server-inventory-open', '1', 'burgershot_boss')
    else
        TriggerEvent('DoLongHudText', 'Insufficient Permissions.', 2)
    end
end)