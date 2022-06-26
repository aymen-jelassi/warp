RegisterNetEvent("warp-storageunits:attempt:purchase", function(args)
    local menu_data = {
        {
            id = 0,
            header = "Are you sure you want to purchase this?",
            txt = ""
        }, 
        {
            id = 1,
            header = "Purchase",
            txt = "Current Listing Price: "..args.price,
            params = {
                event = "warp-storageunits:purchase",
                args = {
                    storage_unit_id = args.id,
                }
            }
        },            
    }

    TriggerEvent('warp-context:sendMenu', menu_data)
end)

RegisterNetEvent("warp-storageunits:attempt:access", function(args)
    if args.isOwner then
        local menu_data = {
            {
                id = 0,
                header = "< Go Back",
                txt = "Return to main menu.",
                params = {
                    event = "warp-storageunit:return:main"
                }
            }, 
            {
                id = 1,
                header = "Add Access",
                txt = "Gives said CID access to your storage unit",
                params = {
                    event = "warp-storageunits:give:access_cl",
                    args = {
                        storage_unit_id = args.id
                    }
                }
            }, 
            {
                id = 2,
                header = "View Access",
                txt = "See who has access to open your storage unit",
                params = {
                    event = "warp-storageunit:view:access",
                    args = {
                        storage_unit_id = args.id,
                    }
                }
            },     
            {
                id = 3,
                header = "Transfer Ownership",
                txt = "Gives your current ownership to said person.",
                params = {
                    event = "warp-storageunit:transfer:ownership",
                    args = {
                        storage_unit_id = args.id
                    }
                }
            },         
        }

        TriggerEvent('warp-context:sendMenu', menu_data)
    else
        TriggerEvent("DoLongHudText", "You dont have permission to use this!", 2)
    end
end)


RegisterNetEvent("warp-storageunits:purchase", function(args)
    TriggerServerEvent("warp-storageunits:purchase", args)
end)

RegisterNetEvent("warp-storageunits:attempt:inventory", function(args)
    TriggerEvent("server-inventory-open", "1", "storage_unit_"..args.id)
end)

RegisterNetEvent("warp-storageunit:view:access", function(args)
    TriggerServerEvent("warp-storageunit:view", args.storage_unit_id)
end)

RegisterNetEvent("warp-storageunits:give:access_cl", function(args)
    local give_access_id = exports["warp-applications"]:KeyboardInput({
        header = "",
        rows = {
            {
                id = 0,
                txt = "What CID do you want to add?"
            }
        }
    })

    if give_access_id ~= nil and give_access_id[1].input ~= nil then
        RPC.execute('warp-storageunits:give:access', args.storage_unit_id, give_access_id[1].input)
    end
end)

RegisterNetEvent("warp-storageunit:attempt:remove", function(args) 
    local menu_data = {
        {
            id = 0,
            header = "< Go Back",
            txt = "Return to current list of access.",
            params = {
				event = "warp-storageunit:view:access",
                args = {
                    storage_unit_id = args.id,
                }
			}
        }, 
        {
            id = 1,
            header = "Remove " .. args.character_name.. "\'s access",
            txt = "This will remove them from accessing your unit",
            params = {
                event = "warp-storageunit:continue:remove",
                args = {
                    storage_unit_id = args.id,
                    player_cid = args.player_cid,
                    char_name = args.character_name
                }
            }
        },       
    }

    TriggerEvent('warp-context:sendMenu', menu_data)
end)

RegisterNetEvent("warp-storageunit:continue:remove", function(args)
    RPC.execute('warp-storageunits:remove:access', args.storage_unit_id, args.player_cid, args.char_name)
end)

RegisterNetEvent("warp-storageunit:return:main", function()
    RPC.execute("warp-storageunits:occupied", currently_visiting_unit)
end)

RegisterNetEvent("warp-storageunit:transfer:ownership", function(args)
    local transfer_event = exports["warp-applications"]:KeyboardInput({
        header = "",
        rows = {
            {
                id = 0,
                txt = "What CID do you wanna transfer ownership to?"
            }
        }
    })

    if transfer_event ~= nil and transfer_event[1].input ~= nil then
        RPC.execute("warp-storageunits:attenpt:transfer", args.storage_unit_id, transfer_event[1].input)
    end
end)

