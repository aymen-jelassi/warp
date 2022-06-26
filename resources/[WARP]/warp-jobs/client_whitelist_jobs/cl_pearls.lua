RegisterNetEvent("warp-pearls:CutBoard")
AddEventHandler("warp-pearls:CutBoard", function()
    local pPerals = exports["isPed"]:GroupRank("pearls")
    if pPerals >= 1 then
        TriggerEvent('warp-context:sendMenu', {
        {
            id = 1,
            header = "Bass",
            txt = "Skin Bass",
            params = {
                event = "warp-pearls:skinnedFood",
                args = {
                    food = 'bass'
                }
            }
            },
        {
            id = 2,
            header = "Salmon",
            txt = "Clean up Salmon",
            params = {
                    event = "warp-pearls:skinnedFood",
                    args = {
                        food = 'salmon'
                    }
                }
            },
        {
            id = 3,
            header = "Marlin",
            txt = "Skin Marlin",
            params = {
                    event = "warp-pearls:skinnedFood",
                    args = {
                        food = 'marlin'
                    }
                }
            },
            {
            id = 4,
            header = "Shark",
            txt = "Skin Shark",
            params = {
                    event = "warp-pearls:skinnedFood",
                    args = {
                        food = 'shark'
                    }
                }
            },
        })
    else
        TriggerEvent('DoLongHudText', 'You are not a pearls employee!', 2)
    end
end)

RegisterNetEvent("warp-pearls:pots")
AddEventHandler("warp-pearls:pots", function()
    local pPerals = exports["isPed"]:GroupRank("pearls")
    if pPerals >= 1 then
        TriggerEvent('warp-context:sendMenu', {
        {
            id = 1,
            header = "Crab",
            txt = "Drop Crap in pan",
            params = {
                    event = "warp-pearls:cookedFood",
                    args = {
                        food = 'crab'
                    }
                }
            },
            {
            id = 2,
            header = "Shrimp",
            txt = "Drop Shrimp in pan",
            params = {
                    event = "warp-pearls:cookedFood",
                    args = {
                        food = 'shrimp'
                    }
                }
            },
            {
            id = 3,
            header = "Salmon",
            txt = "Cook Salmon",
            params = {
                    event = "warp-pearls:cookedFood",
                    args = {
                        food = 'salmon'
                    }
                }
            },
            {
            id = 4,
            header = "Shark",
            txt = "Cook Shark",
            params = {
                    event = "warp-pearls:cookedFood",
                    args = {
                        food = 'shark'
                    }
                }
            },
            {
            id = 5,
            header = "Rice",
            txt = "Cook Rice",
            params = {
                    event = "warp-pearls:cookedFood",
                    args = {
                        food = 'rice'
                    }
                }
            },
        })
    else
        TriggerEvent('DoLongHudText', 'You are not a pearls employee!', 2)
    end
end)

RegisterNetEvent("warp-pearls:plate")
AddEventHandler("warp-pearls:plate", function()
    local pPerals = exports["isPed"]:GroupRank("pearls")
    if pPerals >= 1 then
        TriggerEvent('warp-context:sendMenu', {
        {
            id = 1,
            header = "Plate Shrimp",
            txt = "Shrimp Cocktail",
            params = {
                    event = "warp-pearls:plateFood",
                    args = {
                        food = 'shrimp'
                    }
                }
            },
            {
            id = 2,
            header = "Plate Bass",
            txt = "Bass Sushi",
            params = {
                    event = "warp-pearls:plateFood",
                    args = {
                        food = 'bass'
                    }
                }
            },
            {
            id = 3,
            header = "Plate Salmon",
            txt = "Salmon Dish",
            params = {
                    event = "warp-pearls:plateFood",
                    args = {
                        food = 'salmon'
                    }
                }
            },
            {
            id = 4,
            header = "Plate Marlin",
            txt = "Marlin Sushi",
            params = {
                    event = "warp-pearls:plateFood",
                    args = {
                        food = 'marlin'
                    }
                }
            },
        })
    else
        TriggerEvent('DoLongHudText', 'You are not a pearls employee!', 2)
    end
end)

RegisterNetEvent("warp-pearls:drink")
AddEventHandler("warp-pearls:drink", function()
    local pPerals = exports["isPed"]:GroupRank("pearls")
    if pPerals >= 1 then
        TriggerEvent('warp-context:sendMenu', {
        {
            id = 1,
            header = "Grab Water",
            txt = "Pour glass of water",
            params = {
                    event = "warp-pearls:plateDrink",
                    args = {
                        food = 'water'
                    }
                }
            },
            {
            id = 2,
            header = "Grab Coke",
            txt = "Pour glass of coke",
            params = {
                    event = "warp-pearls:plateDrink",
                    args = {
                        food = 'coke'
                    }
                }
            },
            {
            id = 3,
            header = "Grab Tea",
            txt = "Pour glass of tea",
            params = {
                    event = "warp-pearls:plateDrink",
                    args = {
                        food = 'tea'
                    }
                }
            },
        })
    else
        TriggerEvent('DoLongHudText', 'You are not a pearls employee!', 2)
    end
end)

RegisterNetEvent("warp-pearls:skinnedFood")
AddEventHandler("warp-pearls:skinnedFood", function(data)
    local pPerals = exports["isPed"]:GroupRank("pearls")
    if pPerals >= 1 then
        if data.food == 'bass' then
            if exports["warp-inventory"]:hasEnoughOfItem('bass',1,false) then
                local dict = 'anim@amb@business@coc@coc_unpack_cut_left@'
                LoadDict(dict)
                FreezeEntityPosition(GetPlayerPed(-1),true)
                TaskPlayAnim(GetPlayerPed(-1), dict, "coke_cut_v1_coccutter", 3.0, -8, -1, 63, 0, 0, 0, 0 )
                local PedCoords = GetEntityCoords(GetPlayerPed(-1))
                prop = CreateObject(GetHashKey('prop_knife'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
                AttachEntityToEntity(prop, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 0xDEAD), 0.13, 0.14, 0.09, 40.0, 0.0, 0.0, false, false, false, false, 2, true)
                SetEntityHeading(GetPlayerPed(-1), 59.52755355835)
                local finished = exports['warp-taskbar']:taskBar(10000, 'Skinning Bass')
                if (finished == 100) then
                    TriggerEvent("player:receiveItem",'skinnedbass', math.random(1, 2))
                    TriggerEvent("inventory:removeItem",'bass', 1)
                    FreezeEntityPosition(GetPlayerPed(-1),false)
                    DeleteEntity(prop)
                    ClearPedTasks(GetPlayerPed(-1))
                    Citizen.Wait(1000)
                    TriggerEvent("animation:PlayAnimation","layspike")
                end
            else
                TriggerEvent('DoLongHudText', 'You do not have enough bass to proccess!', 2)
            end
        elseif data.food == 'salmon' then 
            if exports["warp-inventory"]:hasEnoughOfItem('salmon',1,false) then
                local dict = 'anim@amb@business@coc@coc_unpack_cut_left@'
                LoadDict(dict)
                FreezeEntityPosition(GetPlayerPed(-1),true)
                TaskPlayAnim(GetPlayerPed(-1), dict, "coke_cut_v1_coccutter", 3.0, -8, -1, 63, 0, 0, 0, 0 )
                local PedCoords = GetEntityCoords(GetPlayerPed(-1))
                prop = CreateObject(GetHashKey('prop_knife'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
                AttachEntityToEntity(prop, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 0xDEAD), 0.13, 0.14, 0.09, 40.0, 0.0, 0.0, false, false, false, false, 2, true)
                SetEntityHeading(GetPlayerPed(-1), 59.52755355835)
                local finished = exports['warp-taskbar']:taskBar(10000, 'Skinning Salmon')
                if (finished == 100) then
                    TriggerEvent("player:receiveItem",'skinnedsalmon', math.random(1, 2))
                    TriggerEvent("inventory:removeItem",'salmon', 1)
                    FreezeEntityPosition(GetPlayerPed(-1),false)
                    DeleteEntity(prop)
                    ClearPedTasks(GetPlayerPed(-1))
                    Citizen.Wait(1000)
                    TriggerEvent("animation:PlayAnimation","layspike")
                end
            else
                TriggerEvent('DoLongHudText', 'You do not have enough salmon to proccess!', 2)
            end
        elseif data.food == 'marlin' then 
            if exports["warp-inventory"]:hasEnoughOfItem('marlin',1,false) then
                local dict = 'anim@amb@business@coc@coc_unpack_cut_left@'
                LoadDict(dict)
                FreezeEntityPosition(GetPlayerPed(-1),true)
                TaskPlayAnim(GetPlayerPed(-1), dict, "coke_cut_v1_coccutter", 3.0, -8, -1, 63, 0, 0, 0, 0 )
                local PedCoords = GetEntityCoords(GetPlayerPed(-1))
                prop = CreateObject(GetHashKey('prop_knife'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
                AttachEntityToEntity(prop, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 0xDEAD), 0.13, 0.14, 0.09, 40.0, 0.0, 0.0, false, false, false, false, 2, true)
                SetEntityHeading(GetPlayerPed(-1), 59.52755355835)
                local finished = exports['warp-taskbar']:taskBar(10000, 'Skinning Marlin')
                if (finished == 100) then
                    TriggerEvent("player:receiveItem",'skinnedmarlin', math.random(1, 2))
                    TriggerEvent("inventory:removeItem",'marlin', 1)
                    FreezeEntityPosition(GetPlayerPed(-1),false)
                    DeleteEntity(prop)
                    ClearPedTasks(GetPlayerPed(-1))
                    Citizen.Wait(1000)
                    TriggerEvent("animation:PlayAnimation","layspike")
                end
            else
                TriggerEvent('DoLongHudText', 'You do not have enough marlin to proccess!', 2)
            end
        elseif data.food == 'shark' then 
            if exports["warp-inventory"]:hasEnoughOfItem('shark',1,false) then
                local dict = 'anim@amb@business@coc@coc_unpack_cut_left@'
                LoadDict(dict)
                FreezeEntityPosition(GetPlayerPed(-1),true)
                TaskPlayAnim(GetPlayerPed(-1), dict, "coke_cut_v1_coccutter", 3.0, -8, -1, 63, 0, 0, 0, 0 )
                local PedCoords = GetEntityCoords(GetPlayerPed(-1))
                prop = CreateObject(GetHashKey('prop_knife'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
                AttachEntityToEntity(prop, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 0xDEAD), 0.13, 0.14, 0.09, 40.0, 0.0, 0.0, false, false, false, false, 2, true)
                SetEntityHeading(GetPlayerPed(-1), 59.52755355835)
                local finished = exports['warp-taskbar']:taskBar(10000, 'Skinning Shark')
                if (finished == 100) then
                    TriggerEvent("player:receiveItem",'skinnedshark', math.random(1, 2))
                    TriggerEvent("inventory:removeItem",'shark', 1)
                    FreezeEntityPosition(GetPlayerPed(-1),false)
                    DeleteEntity(prop)
                    ClearPedTasks(GetPlayerPed(-1))
                    Citizen.Wait(1000)
                    TriggerEvent("animation:PlayAnimation","layspike")
                end
            else
                TriggerEvent('DoLongHudText', 'You do not have enough shark to proccess!', 2)
            end
        else
            TriggerEvent('DoLongHudText', 'You are not a pearls employee!', 2)
        end
    end
end)

RegisterNetEvent("warp-pearls:cookedFood")
AddEventHandler("warp-pearls:cookedFood", function(data)
    local pPerals = exports["isPed"]:GroupRank("pearls")
    if pPerals >= 1 then
        if data.food == 'crab' then
            if exports["warp-inventory"]:hasEnoughOfItem('crab',1,false) then
                TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BBQ", 0, true)
                local finished = exports["warp-taskbar"]:taskBar(20000,"Cooking Crab",false,false,ped)
                if (finished == 100) then
                    ClearPedTasksImmediately(GetPlayerPed(-1))
                    TriggerEvent("player:receiveItem",'cookedcrab', 1)
                    TriggerEvent("inventory:removeItem",'crab', 1)
                end
            else
                TriggerEvent('DoLongHudText', 'You do not have any crab to cook!', 2)
            end
        elseif data.food == 'shrimp' then
            if exports["warp-inventory"]:hasEnoughOfItem('shrimp',1,false) then
                TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BBQ", 0, true)
                local finished = exports["warp-taskbar"]:taskBar(12000,"Cooking Shrimp",false,false,ped)
                if (finished == 100) then
                    ClearPedTasksImmediately(GetPlayerPed(-1))
                    TriggerEvent("player:receiveItem",'cookedshrimp', 1)
                    TriggerEvent("inventory:removeItem",'shrimp', 1)
                end
            else
                TriggerEvent('DoLongHudText', 'You do not have any shrimp to cook!', 2)
            end
        elseif data.food == 'salmon' then
            if exports["warp-inventory"]:hasEnoughOfItem('skinnedsalmon',1,false) then
                TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BBQ", 0, true)
                local finished = exports["warp-taskbar"]:taskBar(12000,"Cooking Shrimp",false,false,ped)
                if (finished == 100) then
                    ClearPedTasksImmediately(GetPlayerPed(-1))
                    TriggerEvent("player:receiveItem",'cookedsalmon', 1)
                    TriggerEvent("inventory:removeItem",'skinnedsalmon', 1)
                end
            else
                TriggerEvent('DoLongHudText', 'You do not have any skinnedsalmon to cook!', 2)
            end
        elseif data.food == 'shark' then
            if exports["warp-inventory"]:hasEnoughOfItem('skinnedshark',1,false) then
                TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BBQ", 0, true)
                local finished = exports["warp-taskbar"]:taskBar(20000,"Cooking Shark Fin Soup",false,false,ped)
                if (finished == 100) then
                    ClearPedTasksImmediately(GetPlayerPed(-1))
                    TriggerEvent("player:receiveItem",'cookedshark', 1)
                    TriggerEvent("inventory:removeItem",'skinnedshark', 1)
                end
            else
                TriggerEvent('DoLongHudText', 'You do not have any skinnedshark to cook!', 2)
            end
        elseif data.food == 'rice' then
            TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BBQ", 0, true)
            local finished = exports["warp-taskbar"]:taskBar(20000,"Cooking Rice",false,false,ped)
            if (finished == 100) then
                ClearPedTasksImmediately(GetPlayerPed(-1))
                TriggerEvent("player:receiveItem",'cookedrice', 1)
            end
        else
            TriggerEvent('DoLongHudText', 'You are not a pearls employee!', 2)
        end
    end
end)

RegisterNetEvent("warp-pearls:plateFood")
AddEventHandler("warp-pearls:plateFood", function(data)
    local pPerals = exports["isPed"]:GroupRank("pearls")
    if pPerals >= 1 then
        if data.food == 'shrimp' then
            if exports["warp-inventory"]:hasEnoughOfItem('cookedshrimp',1,false) then
                local dict = 'anim@amb@business@coc@coc_unpack_cut_left@'
                LoadDict(dict)
                FreezeEntityPosition(GetPlayerPed(-1),true)
                TaskPlayAnim(GetPlayerPed(-1), dict, "coke_cut_v1_coccutter", 3.0, -8, -1, 63, 0, 0, 0, 0 )
                local finished = exports['warp-taskbar']:taskBar(10000, 'Plating Shrimp Cocktail')
                if (finished == 100) then
                    TriggerEvent("player:receiveItem",'platedshrimp', 1)
                    TriggerEvent("inventory:removeItem",'cookedshrimp', 1)
                    FreezeEntityPosition(GetPlayerPed(-1),false)
                    DeleteEntity(prop)
                    ClearPedTasks(GetPlayerPed(-1))
                    Citizen.Wait(1000)
                    TriggerEvent("animation:PlayAnimation","layspike")
                end
            else
                TriggerEvent('DoLongHudText', 'You do not have enough cookedshrimp to plate!', 2)
            end
        elseif data.food == 'bass' then
            if exports["warp-inventory"]:hasEnoughOfItem('skinnedbass',1,false) then
                local dict = 'anim@amb@business@coc@coc_unpack_cut_left@'
                LoadDict(dict)
                FreezeEntityPosition(GetPlayerPed(-1),true)
                TaskPlayAnim(GetPlayerPed(-1), dict, "coke_cut_v1_coccutter", 3.0, -8, -1, 63, 0, 0, 0, 0 )
                local finished = exports['warp-taskbar']:taskBar(10000, 'Plating Bass Sushi')
                if (finished == 100) then
                    TriggerEvent("player:receiveItem",'platedbass', 1)
                    TriggerEvent("inventory:removeItem",'skinnedbass', 1)
                    FreezeEntityPosition(GetPlayerPed(-1),false)
                    DeleteEntity(prop)
                    ClearPedTasks(GetPlayerPed(-1))
                    Citizen.Wait(1000)
                    TriggerEvent("animation:PlayAnimation","layspike")
                end
            else
                TriggerEvent('DoLongHudText', 'You do not have enough skinnedbass to plate!', 2)
            end
        elseif data.food == 'salmon' then
            if exports["warp-inventory"]:hasEnoughOfItem('cookedsalmon',1,false) then
                local dict = 'anim@amb@business@coc@coc_unpack_cut_left@'
                LoadDict(dict)
                FreezeEntityPosition(GetPlayerPed(-1),true)
                TaskPlayAnim(GetPlayerPed(-1), dict, "coke_cut_v1_coccutter", 3.0, -8, -1, 63, 0, 0, 0, 0 )
                local finished = exports['warp-taskbar']:taskBar(10000, 'Plating Salmon')
                if (finished == 100) then
                    TriggerEvent("player:receiveItem",'platedsalmon', 1)
                    TriggerEvent("inventory:removeItem",'cookedsalmon', 1)
                    FreezeEntityPosition(GetPlayerPed(-1),false)
                    DeleteEntity(prop)
                    ClearPedTasks(GetPlayerPed(-1))
                    Citizen.Wait(1000)
                    TriggerEvent("animation:PlayAnimation","layspike")
                end
            else
                TriggerEvent('DoLongHudText', 'You do not have enough cookedsalmon to plate!', 2)
            end
        elseif data.food == 'marlin' then
            if exports["warp-inventory"]:hasEnoughOfItem('skinnedmarlin',1,false) then
                local dict = 'anim@amb@business@coc@coc_unpack_cut_left@'
                LoadDict(dict)
                FreezeEntityPosition(GetPlayerPed(-1),true)
                TaskPlayAnim(GetPlayerPed(-1), dict, "coke_cut_v1_coccutter", 3.0, -8, -1, 63, 0, 0, 0, 0 )
                local finished = exports['warp-taskbar']:taskBar(10000, 'Plating Marlin Sushi')
                if (finished == 100) then
                    TriggerEvent("player:receiveItem",'platedmarlin', 1)
                    TriggerEvent("inventory:removeItem",'skinnedmarlin', 1)
                    FreezeEntityPosition(GetPlayerPed(-1),false)
                    DeleteEntity(prop)
                    ClearPedTasks(GetPlayerPed(-1))
                    Citizen.Wait(1000)
                    TriggerEvent("animation:PlayAnimation","layspike")
                end
            else
                TriggerEvent('DoLongHudText', 'You do not have enough skinnedmarlin to plate!', 2)
            end
        else
            TriggerEvent('DoLongHudText', 'You are not a pearls employee!', 2)
        end
    end    
end)

RegisterNetEvent("warp-pearls:plateDrink")
AddEventHandler("warp-pearls:plateDrink", function(data)
    if data.food == 'water' then
        local dict = 'anim@amb@business@coc@coc_unpack_cut_left@'
        LoadDict(dict)
        FreezeEntityPosition(GetPlayerPed(-1),true)
        TaskPlayAnim(GetPlayerPed(-1), dict, "coke_cut_v1_coccutter", 3.0, -8, -1, 63, 0, 0, 0, 0 )
        local finished = exports['warp-taskbar']:taskBar(5000, 'Grabbing Water')
        if (finished == 100) then
            TriggerEvent("player:receiveItem",'water', 1)
            FreezeEntityPosition(GetPlayerPed(-1),false)
            DeleteEntity(prop)
            ClearPedTasks(GetPlayerPed(-1))
            Citizen.Wait(1000)
            TriggerEvent("animation:PlayAnimation","layspike")
        end
    elseif data.food == 'coke' then
        local dict = 'anim@amb@business@coc@coc_unpack_cut_left@'
        LoadDict(dict)
        FreezeEntityPosition(GetPlayerPed(-1),true)
        TaskPlayAnim(GetPlayerPed(-1), dict, "coke_cut_v1_coccutter", 3.0, -8, -1, 63, 0, 0, 0, 0 )
        local finished = exports['warp-taskbar']:taskBar(5000, 'Grabbing Soda')
        if (finished == 100) then
            TriggerEvent("player:receiveItem",'cola', 1)
            FreezeEntityPosition(GetPlayerPed(-1),false)
            DeleteEntity(prop)
            ClearPedTasks(GetPlayerPed(-1))
            Citizen.Wait(1000)
            TriggerEvent("animation:PlayAnimation","layspike")
        end
    elseif data.food == 'tea' then
        local dict = 'anim@amb@business@coc@coc_unpack_cut_left@'
        LoadDict(dict)
        FreezeEntityPosition(GetPlayerPed(-1),true)
        TaskPlayAnim(GetPlayerPed(-1), dict, "coke_cut_v1_coccutter", 3.0, -8, -1, 63, 0, 0, 0, 0 )
        local finished = exports['warp-taskbar']:taskBar(10000, 'Making Cup of Tea')
        if (finished == 100) then
            TriggerEvent("player:receiveItem",'tea', 1)
            FreezeEntityPosition(GetPlayerPed(-1),false)
            DeleteEntity(prop)
            ClearPedTasks(GetPlayerPed(-1))
            Citizen.Wait(1000)
            TriggerEvent("animation:PlayAnimation","layspike")
        end
    end
end)

function LoadDict(dict)
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	  	Citizen.Wait(10)
    end
end

RegisterNetEvent("warp-peals:addBill")
AddEventHandler("warp-peals:addBill", function(amount)
    TriggerServerEvent("server:GroupPayment","pearls", amount)
end)

RegisterNetEvent("warp-pearls:openFridge")
AddEventHandler("warp-pearls:openFridge", function()
    local pPerals = exports["isPed"]:GroupRank("pearls")
    if pPerals >= 1 then
        TriggerEvent("server-inventory-open", "1", "pearls-fridge")
        Wait(100)
    else
        TriggerEvent('DoLongHudText', 'You are not a pearls employee!', 2)
    end
end)

RegisterNetEvent("pearls:register")
AddEventHandler("pearls:register", function(registerID)
    local rank = exports["isPed"]:GroupRank("pearls")
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
            TriggerServerEvent("pearls:OrderComplete", registerID, order[1].input, order[2].input)
        end
    else
        TriggerEvent("DoLongHudText", "You cant use this", 2)
    end
end)

RegisterNetEvent("pearls:get:receipt")
AddEventHandler("pearls:get:receipt", function(registerid)
    TriggerServerEvent('pearls:retreive:receipt', registerid)
end)

RegisterNetEvent("pearls:pay")
AddEventHandler("pearls:pay", function(amount)
    TriggerServerEvent("server:GroupPayment","pearls", amount)
end)

local nearPackcheck = false

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("peals_paycheck", vector3(-1840.56, -1189.82, 14.32), 1.0, 2.4, {
		name="peals_paycheck",
		heading=330,
    }) 
end)

RegisterNetEvent('warp-polyzone:enter')
AddEventHandler('warp-polyzone:enter', function(name)
    if name == "peals_paycheck" then
        local rank = exports["isPed"]:GroupRank("pearls")
		if rank > 0 then 
            nearPackcheck = true
            PearlsReceipts()
			exports['warp-textui']:showInteraction(("[E] %s"):format("Trade In Receipts"))
        end
    end
end)


RegisterNetEvent('warp-polyzone:exit')
AddEventHandler('warp-polyzone:exit', function(name)
    if name == "peals_paycheck" then
        nearPackcheck = false
    end
    exports['warp-textui']:hideInteraction()
end)

function PearlsReceipts()
	Citizen.CreateThread(function()
        while nearPackcheck do
            Citizen.Wait(5)
			if IsControlJustReleased(0, 38) then
                    local rank = exports["isPed"]:GroupRank("pearls")
                    if rank > 0 then 
                    TriggerEvent('pearls:cash:in')
                end
			end
		end
	end)
end

RegisterNetEvent('pearls:cash:in')
AddEventHandler('pearls:cash:in', function()
    local cid = exports["isPed"]:isPed("cid")
    TriggerServerEvent("pearls:update:pay", cid)
end)