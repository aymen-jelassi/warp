-- Stash

VoidPizzeriaStash = false

Citizen.CreateThread(function()
    exports["warp-polyzone"]:AddBoxZone("maldinis_stash", vector3(813.61, -749.35, 26.78), 2, 1.2, {
        name="maldinis_stash",
        heading=0,
        --debugPoly=true,
        minZ=24.38,
        maxZ=28.38
    })
end)

RegisterNetEvent('warp-polyzone:enter')
AddEventHandler('warp-polyzone:enter', function(name)
    if name == "maldinis_stash" then
        VoidPizzeriaStash = true     
        local rank = exports["isPed"]:GroupRank("mafia")
        if rank > 1 then 
            warpMaldinisStash()
            exports['warp-textui']:showInteraction("[E] Stash")
        end
    end
end)

RegisterNetEvent('warp-polyzone:exit')
AddEventHandler('warp-polyzone:exit', function(name)
    if name == "maldinis_pizzeria" then
        VoidPizzeriaStash = false
        exports['warp-textui']:hideInteraction()
    end
end)

function warpMaldinisStash()
	Citizen.CreateThread(function()
        while VoidPizzeriaStash do
            Citizen.Wait(5)
			if IsControlJustReleased(0, 38) then
                local rank = exports["isPed"]:GroupRank("mafia")
                if rank > 1 then 
                    TriggerEvent('server-inventory-open', '1', 'maldinis-stash')
                end
			end
		end
	end)
end

RegisterNetEvent('warp-pizzeria:open_safe')
AddEventHandler('warp-pizzeria:open_safe', function()
    local rank = exports["isPed"]:GroupRank("mafia")
    if rank > 4 then 
        TriggerEvent('server-inventory-open', '1', 'safe-maldinis')
    else
        TriggerEvent('DoLongHudText', 'You dont got access to this', 2)
    end
end)

-- Registers

RegisterNetEvent("warp_maldinis:get:receipt")
AddEventHandler("warp_maldinis:get:receipt", function(registerid)
    TriggerServerEvent('voirp_maldinis:retreive:receipt', registerid)
end)

RegisterNetEvent("warp_maldinis:register")
AddEventHandler("warp_maldinis:register", function(registerID)
    local rank = exports["isPed"]:GroupRank("mafia")
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
            TriggerServerEvent("void_maldinis:OrderComplete", registerID, order[1].input, order[2].input)
        end
    else
        TriggerEvent("DoLongHudText", "You cant use this", 2)
    end
end)