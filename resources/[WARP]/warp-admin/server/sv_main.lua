RegisterCommand("menu", function(source, args)
    local src = source
    local steamIdentifier = GetPlayerIdentifiers(src)[1]

    exports.oxmysql:execute('SELECT rank FROM users WHERE `hex_id`= ?', {steamIdentifier}, function(data)
        if data[1].rank == "dev" or data[1].rank == "admin" or data[1].rank == "mod" then
            TriggerClientEvent('warp-admin:openMenu', src) 
        end
    end)
end)

RegisterCommand("adminlogout", function(source, args)
    local src = source
    local steamIdentifier = GetPlayerIdentifiers(src)[1]

    exports.oxmysql:execute('SELECT rank FROM users WHERE `hex_id`= ?', {steamIdentifier}, function(data)
        if data[1].rank == "dev" or data[1].rank == "admin" or data[1].rank == "mod" then
            TriggerClientEvent('swappingCharsLoop', src) 
        end
    end)
end)


RegisterServerEvent('warp-admin:sendAnnoucement')
AddEventHandler("warp-admin:sendAnnoucement", function(msg)
    TriggerClientEvent('chatMessage', -1, 'Admin', 1, msg)
end)

RegisterServerEvent('warp-admin:update:vehicle')
AddEventHandler("warp-admin:update:vehicle", function(plate)
    TriggerClientEvent('DoLongHudText', source, 'The vehicle with the plate: '.. plate .. ' has been placed back in the garage!', 1)
    exports.oxmysql:execute("UPDATE characters_cars SET `vehicle_state` = @vehicle_state WHERE license_plate = @license_plate", {['vehicle_state'] = 'In', ['license_plate'] = plate})
end)

RegisterServerEvent('warp-admin:addCharacterPass')
AddEventHandler("warp-admin:addCharacterPass", function(cid, pass, rank, info)
    if info == 'add' then 
        exports.oxmysql:execute("INSERT INTO character_passes (cid, rank, pass_type, business_name) VALUES (@cid, @rank, @pass_type, @business_name)", {['@cid'] = cid, ['@rank'] = rank, ['@pass_type'] = pass, ['@business_name'] = pass})
    elseif info == 'remove' then
        exports.oxmysql:execute("DELETE FROM character_passes WHERE `cid` = @cid AND `rank` = @rank AND `pass_type` = @pass_type", {['@cid'] = cid, ['@rank'] = rank, ['@pass_type'] = pass})
    end
end)

-- Logs -- 

-- Dev Mode --

local DevMode_Hook = "https://discord.com/api/webhooks/940195202281386044/X4Uj9mTysEngdWt2nNzbtqE0APi-_0nli0Xp0AQKFqhVm3zCznua9ZuNRa4XwcGMcM4R"

RegisterServerEvent('warp-admin:developer_mode')
AddEventHandler('warp-admin:developer_mode', function(data)
    local pName = GetPlayerName(source)
    local connect = {
        {
            ["color"] = "186",
            ["title"] = "Dev Mode Log User Enabled Dev Mode - ".. pName,
	        ["footer"] = {
                ["text"] = "Sent By Void RP Admin Menu",
            },
        }
    }
    PerformHttpRequest(DevMode_Hook, function(err, text, headers) end, 'POST', json.encode({username = "Void RP",  avatar_url = "https://cdn.discordapp.com/attachments/898738405217800242/931735378740772874/voidlogo.png",embeds = connect}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent('warp-admin:developer_mode_2')
AddEventHandler('warp-admin:developer_mode_2', function(data)
    local pName = GetPlayerName(source)
    local connect = {
        {
            ["color"] = "186",
            ["title"] = "Dev Mode Log User Dissabled Dev Mode - ".. pName,
	        ["footer"] = {
                ["text"] = "Sent By Void RP Admin Menu",
            },
        }
    }
    PerformHttpRequest(DevMode_Hook, function(err, text, headers) end, 'POST', json.encode({username = "Void RP",  avatar_url = "https://cdn.discordapp.com/attachments/898738405217800242/931735378740772874/voidlogo.png",embeds = connect}), { ['Content-Type'] = 'application/json' })
end)

-- Clothing Menu --

local ClothingMenu_hook = "https://discord.com/api/webhooks/940194235070685184/VzTvM2pDxP_NlgVSF_HFio9-E3a6L5uw22SW-kWSbY370V_kKAxD2MKvBb5CM3_u6L0j"

RegisterServerEvent('warp-admin:clothing_menu')
AddEventHandler('warp-admin:clothing_menu', function(data)
    local pName = GetPlayerName(source)
    local connect = {
        {
            ["color"] = "186",
            ["title"] = "Admin / Developer gave themself the Clothing Menu - ".. pName,
	        ["footer"] = {
                ["text"] = "Sent By Void RP Admin Menu",
            },
        }
    }
    PerformHttpRequest(ClothingMenu_hook, function(err, text, headers) end, 'POST', json.encode({username = "Void RP",  avatar_url = "https://cdn.discordapp.com/attachments/898738405217800242/931735378740772874/voidlogo.png",embeds = connect}), { ['Content-Type'] = 'application/json' })
end)

-- Barber Shop --

local BarberShop_Hook = "https://discord.com/api/webhooks/940195175022604288/FjtpZhhMdFdxQ8xLacPUPAkc3lTdKclbhKKyihqxvdupKPxft20tiYJfWBgonqF58chf"

RegisterServerEvent('warp-admin:barber_menu')
AddEventHandler('warp-admin:barber_menu', function(data)
    local pName = GetPlayerName(source)
    local connect = {
        {
            ["color"] = "186",
            ["title"] = "Admin / Developer gave themself the Barber Menu - ".. pName,
	        ["footer"] = {
                ["text"] = "Sent By Void RP Admin Menu",
            },
        }
    }
    PerformHttpRequest(BarberShop_Hook, function(err, text, headers) end, 'POST', json.encode({username = "Void RP",  avatar_url = "https://cdn.discordapp.com/attachments/898738405217800242/931735378740772874/voidlogo.png",embeds = connect}), { ['Content-Type'] = 'application/json' })
end)

-- Max Stats --

local MaxStats_Hook = "https://discord.com/api/webhooks/940195151014400000/UH49qyun6AIpyZkGC59zwSJchS3ziaY_pO2bebLiX3ZuAg7A0MBCU7SkqfO6ykZcwWxp"

RegisterServerEvent('warp-admin:max_stats')
AddEventHandler('warp-admin:max_stats', function(data)
    local pName = GetPlayerName(source)
    local connect = {
        {
            ["color"] = "186",
            ["title"] = "Admin / Developer used Max Stats | 100% Armor | 100% Health | 100% Hunger | 100% Water | Steam Name: ".. pName,
	        ["footer"] = {
                ["text"] = "Sent By Void RP Admin Menu",
            },
        }
    }
    PerformHttpRequest(MaxStats_Hook, function(err, text, headers) end, 'POST', json.encode({username = "Void RP",  avatar_url = "https://cdn.discordapp.com/attachments/898738405217800242/931735378740772874/voidlogo.png",embeds = connect}), { ['Content-Type'] = 'application/json' })
end)

-- Debug --

local DevDebug_Hook = "https://discord.com/api/webhooks/940194111485542450/OcN4pQpUj4iwq5H_Ek8kWSjZ1fAwzadwkjSDBeW1HrI7zPADM-DFoTdfihr47CJIkkyb"

RegisterServerEvent('warp-admin:dev_debug')
AddEventHandler('warp-admin:dev_debug', function(data)
    local pName = GetPlayerName(source)
    local connect = {
        {
            ["color"] = "186",
            ["title"] = "Admin / Developer toggled Dev Debug - ".. pName,
	        ["footer"] = {
                ["text"] = "Sent By Void RP Admin Menu",
            },
        }
    }
    PerformHttpRequest(DevDebug_Hook, function(err, text, headers) end, 'POST', json.encode({username = "Void RP",  avatar_url = "https://cdn.discordapp.com/attachments/898738405217800242/931735378740772874/voidlogo.png",embeds = connect}), { ['Content-Type'] = 'application/json' })
end)

-- Change Ped Model --

local PedModel_Hook = "https://discord.com/api/webhooks/940194187192700988/q4y7Z3RpKK4tWkhArVcCcrsximAkskVCAVKcQ7zCuxjk903xf57tIYTxpCk-DTgTHx7U"

RegisterServerEvent('warp-admin:ped_model')
AddEventHandler('warp-admin:ped_model', function(data)
    local pName = GetPlayerName(source)
    local connect = {
        {
            ["color"] = "186",
            ["title"] = "Admin / Developer Changed there ped model using the admin menu - ".. pName,
	        ["footer"] = {
                ["text"] = "Sent By Void RP Admin Menu",
            },
        }
    }
    PerformHttpRequest(PedModel_Hook, function(err, text, headers) end, 'POST', json.encode({username = "Void RP",  avatar_url = "https://cdn.discordapp.com/attachments/898738405217800242/931735378740772874/voidlogo.png",embeds = connect}), { ['Content-Type'] = 'application/json' })
end)

-- Telport Marker --

local TeleportToMarker_Hook = "https://discord.com/api/webhooks/940194217463009330/19_PUWN8KxNXi8bYpxm7dT8xcC_fMicbhMfXTVRBsobhK5-69D_WEd1DOpQMgzGHe5QC"

RegisterServerEvent('warp-admin:teleport_to_marker')
AddEventHandler('warp-admin:teleport_to_marker', function(data)
    local pName = GetPlayerName(source)
    local connect = {
        {
            ["color"] = "186",
            ["title"] = "Admin / Developer Teleported to a marker - ".. pName,
	        ["footer"] = {
                ["text"] = "Sent By Void RP Admin Menu",
            },
        }
    }
    PerformHttpRequest(TeleportToMarker_Hook, function(err, text, headers) end, 'POST', json.encode({username = "Void RP",  avatar_url = "https://cdn.discordapp.com/attachments/898738405217800242/931735378740772874/voidlogo.png",embeds = connect}), { ['Content-Type'] = 'application/json' })
end)

-- Noclip --

local ToggleAdminMenuNoclip_Hook = "https://discord.com/api/webhooks/940195107267805234/rxJ7OWSFfzx5Q023vUyK7eLknXSAtu3_a1V6rNiKRJ4JD8R15UHxh2PJZ9Rv2mWpqhcf"

RegisterServerEvent('warp-admin:noclip')
AddEventHandler('warp-admin:noclip', function(data)
    local pName = GetPlayerName(source)
    local connect = {
        {
            ["color"] = "186",
            ["title"] = "Admin / Developer Noclipped with admin menu - ".. pName,
	        ["footer"] = {
                ["text"] = "Sent By Void RP Admin Menu",
            },
        }
    }
    PerformHttpRequest(ToggleAdminMenuNoclip_Hook, function(err, text, headers) end, 'POST', json.encode({username = "Void RP",  avatar_url = "https://cdn.discordapp.com/attachments/898738405217800242/931735378740772874/voidlogo.png",embeds = connect}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent('warp-admin:noclip2')
AddEventHandler('warp-admin:noclip2', function(data)
    local pName = GetPlayerName(source)
    local connect = {
        {
            ["color"] = "186",
            ["title"] = "Admin / Developer Stopped Noclipping with the admin menu - ".. pName,
	        ["footer"] = {
                ["text"] = "Sent By Void RP Admin Menu",
            },
        }
    }
    PerformHttpRequest(ToggleAdminMenuNoclip_Hook, function(err, text, headers) end, 'POST', json.encode({username = "Void RP",  avatar_url = "https://cdn.discordapp.com/attachments/898738405217800242/931735378740772874/voidlogo.png",embeds = connect}), { ['Content-Type'] = 'application/json' })
end)

local DevModeNoclip_Hook = "https://discord.com/api/webhooks/940195107267805234/rxJ7OWSFfzx5Q023vUyK7eLknXSAtu3_a1V6rNiKRJ4JD8R15UHxh2PJZ9Rv2mWpqhcf"

RegisterServerEvent('warp-admin:noclip_dev_mode')
AddEventHandler('warp-admin:noclip_dev_mode', function(data)
    local pName = GetPlayerName(source)
    local connect = {
        {
            ["color"] = "186",
            ["title"] = "Admin / Developer Started Noclipping with Dev Mode - ".. pName,
	        ["footer"] = {
                ["text"] = "Sent By Void RP Admin Menu",
            },
        }
    }
    PerformHttpRequest(DevModeNoclip_Hook, function(err, text, headers) end, 'POST', json.encode({username = "Void RP",  avatar_url = "https://cdn.discordapp.com/attachments/898738405217800242/931735378740772874/voidlogo.png",embeds = connect}), { ['Content-Type'] = 'application/json' })
end)

-- Revive In Distance --

local ReviveInDistance_Hook = "https://discord.com/api/webhooks/940195013206351873/2uw3ThTzPCW8TryPML3EX1cm2szd5fhBiBu8LvSJbUMMNtzvilPO2jMbYuh-L9vRxw1F"

RegisterServerEvent('warp-admin:revive_in_distance')
AddEventHandler('warp-admin:revive_in_distance', function(data)
    local pName = GetPlayerName(source)
    local connect = {
        {
            ["color"] = "186",
            ["title"] = "Admin / Developer Triggerd Reviving In Distance - ".. pName,
	        ["footer"] = {
                ["text"] = "Sent By Void RP Admin Menu",
            },
        }
    }
    PerformHttpRequest(ReviveInDistance_Hook, function(err, text, headers) end, 'POST', json.encode({username = "Void RP",  avatar_url = "https://cdn.discordapp.com/attachments/898738405217800242/931735378740772874/voidlogo.png",embeds = connect}), { ['Content-Type'] = 'application/json' })
end)

-- God Mode Log --

local Godmode_Hook = "https://discord.com/api/webhooks/940194138194853930/QacAqwj9XHhl7VmIMy6HaNXgkamgFcz4SGW5UNPkj4PuPEzR6FpWwnmP4SGHq-M_rMrj"

RegisterServerEvent('warp-admin:godmode')
AddEventHandler('warp-admin:godmode', function(data)
    local pName = GetPlayerName(source)
    local connect = {
        {
            ["color"] = "186",
            ["title"] = "Admin / Developer Enabled Godmode - ".. pName,
	        ["footer"] = {
                ["text"] = "Sent By Void RP Admin Menu",
            },
        }
    }
    PerformHttpRequest(Godmode_Hook, function(err, text, headers) end, 'POST', json.encode({username = "Void RP",  avatar_url = "https://cdn.discordapp.com/attachments/898738405217800242/931735378740772874/voidlogo.png",embeds = connect}), { ['Content-Type'] = 'application/json' })
end)

local Godmode_Hook2 = "https://discord.com/api/webhooks/940194138194853930/QacAqwj9XHhl7VmIMy6HaNXgkamgFcz4SGW5UNPkj4PuPEzR6FpWwnmP4SGHq-M_rMrj"

RegisterServerEvent('warp-admin:godmode2')
AddEventHandler('warp-admin:godmode2', function(data)
    local pName = GetPlayerName(source)
    local connect = {
        {
            ["color"] = "186",
            ["title"] = "Admin / Developer Dissabled Godmode - ".. pName,
	        ["footer"] = {
                ["text"] = "Sent By Void RP Admin Menu",
            },
        }
    }
    PerformHttpRequest(Godmode_Hook2, function(err, text, headers) end, 'POST', json.encode({username = "Void RP",  avatar_url = "https://cdn.discordapp.com/attachments/898738405217800242/931735378740772874/voidlogo.png",embeds = connect}), { ['Content-Type'] = 'application/json' })
end)

-- Spawned Vehicle --

local SpawnVehicle_hook = "https://discord.com/api/webhooks/940194165843714168/a6V76kyriANaKWxBIhr8nTIyMESXsDVLGi5LSKMdKm1ZwujuG6I-mcWSo8UhHx8f4BQT"

RegisterServerEvent('warp-admin:spawned_vehicle')
AddEventHandler('warp-admin:spawned_vehicle', function(data)
    local pName = GetPlayerName(source)
    local connect = {
        {
            ["color"] = "186",
            ["title"] = "User Spawned a Vehicle - ".. pName,
	        ["footer"] = {
                ["text"] = "Sent By Void RP Admin Menu",
            },
        }
    }
    PerformHttpRequest(SpawnVehicle_hook, function(err, text, headers) end, 'POST', json.encode({username = "Void RP",  avatar_url = "https://cdn.discordapp.com/attachments/898738405217800242/931735378740772874/voidlogo.png",embeds = connect}), { ['Content-Type'] = 'application/json' })
end)


-- Spawned Item --

local SpawnedItem_hook = "https://discord.com/api/webhooks/940194033475649566/r6HW6SJ0dkBc7Pw0b8e4LGsEt7DNhAYlHO5zU43UX0PlowA9ksyj7b_ci5AsCmerGDoq"

RegisterServerEvent('warp-admin:spawned_a_item')
AddEventHandler('warp-admin:spawned_a_item', function(data)
    local pName = GetPlayerName(source)
    local connect = {
        {
            ["color"] = "186",
            ["title"] = "User Spawned a Item - ".. pName,
	        ["footer"] = {
                ["text"] = "Sent By Void RP Admin Menu",
            },
        }
    }
    PerformHttpRequest(SpawnedItem_hook, function(err, text, headers) end, 'POST', json.encode({username = "Void RP",  avatar_url = "https://cdn.discordapp.com/attachments/898738405217800242/931735378740772874/voidlogo.png",embeds = connect}), { ['Content-Type'] = 'application/json' })
end)

-- Report Stuff --

-- report recieve --

RegisterServerEvent("warp-admin:report_command")
AddEventHandler("warp-admin:report_command", function(args)
	local src = source

	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local SteamName = GetPlayerName(source)
	local job = user:getVar("job")
	local message = ""

	for k,v in ipairs(args) do
		message = message .. " " .. v
	end

    TriggerClientEvent("chatMessage", src, "Report | Steam Name: " .. SteamName .. " | Report Details", 4, tostring(message))

	local users = exports["warp-base"]:getModule("Player"):GetUsers()

	local AdminReport = {}

	for k,v in pairs(users) do
		local user = exports["warp-base"]:getModule("Player"):GetUser(v)

		if GetPlayerIdentifier(source) == 'steam:1100001424368e2' or 'steam:110000136904f62' or 'steam:1100001161769e9' or 'steam:11000013fcd2349' or 'steam:110000145386721' or 'steam:110000106b1db47' or 'steam:11000013d7a5937' or 'steam:11000010d1d48c9' or 'steam:11000010d1d48c9' then
			AdminReport[#AdminReport+1]= v
		end
	end

	for k,v in ipairs(AdminReport) do
        TriggerClientEvent("chatMessage", src, "Incoming Report | Steam Name: " .. SteamName .. " | ID: (" .. tonumber(src) .. ") | Report Details", 3, tostring(message))
	end
end)

-- report reply --

RegisterServerEvent("warp-admin:report_r_command")
AddEventHandler("warp-admin:report_r_command", function(args)
	local src = source
    local SteamName = GetPlayerName(source)

	if not args[1] or not tonumber(args[1]) then return end
	local target = args[1]

	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local char = user:getCurrentCharacter()

	local canReplyReports = (GetPlayerIdentifier(source) == 'steam:1100001424368e2' or 'steam:110000136904f62' or 'steam:1100001161769e9' or 'steam:11000013fcd2349' or 'steam:110000145386721' or 'steam:110000106b1db47' or 'steam:11000013d7a5937' or 'steam:11000010d1d48c9' or 'steam:11000010d1d48c9') and true or false
	if not canReplyReports then return end

	local message = ""

	local caller = tostring(SteamName) .. " " .. tostring(SteamName)

	for k,v in ipairs(args) do
		if k > 1 then
			message = message .. " " .. v
		end
	end

	local users = exports["warp-base"]:getModule("Player"):GetUsers()

	local AdminReportReply = {}

	for k,v in pairs(users) do
		local user = exports["warp-base"]:getModule("Player"):GetUser(v)

		if GetPlayerIdentifier(source) == 'steam:1100001424368e2' or 'steam:110000136904f62' or 'steam:1100001161769e9' or 'steam:11000013fcd2349' or 'steam:110000145386721' or 'steam:110000106b1db47' or 'steam:11000013d7a5937' or 'steam:11000010d1d48c9' or 'steam:11000010d1d48c9' then
			AdminReportReply[#AdminReportReply+1]= v
		end
	end

	for k,v in ipairs(AdminReportReply) do
		TriggerClientEvent("chatMessage", v, "Admin Reply Report: | " .. target .. " | " .. SteamName .. ' ', 1, tostring(message))
	end

	TriggerClientEvent("chatMessage", target, "Report Reply: | ".. SteamName .." | (" .. tonumber(src) ..")", 4, tostring(message))
end)