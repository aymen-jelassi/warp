Void.Logs = Void.Logs or {}

Void.Logs.Webhooks = {
    ['Connection'] = 'https://discord.com/api/webhooks/940194915772674069/d9DxTeq5L6YVrLGB_Celqu55yiA5W15O7Jer4wsldPYX494sDU1BQ6p4WEUHuDDFtWfC',
    ['Leave'] = 'https://discord.com/api/webhooks/940195026749751296/NdxWMJjOvBtG_C-SxApjZwX2aY9dgZorZ5fCdTOIlRtDuHghm2JU-IKkDwW08Z7Tu201',
    ['Character'] = 'https://discord.com/api/webhooks/930934477117587476/5N1gr5Q9QKZMeARqlBj4VTtdS3GO_mheKSaHsvA-xRlUPOLCeKnmBK6xeoN_PERJDS6J',
    ['DeathLogs'] = '',
    ['Widthdraw'] = 'https://discord.com/api/webhooks/940194366079791125/iA_SskfbPp9QB7IHLFCQI7wTArPP04hXXaNNvtOMUH9QLg1Z-eOLddzGMd4uo6sURuGu',
    ['Deposit'] = 'https://discord.com/api/webhooks/940194366079791125/iA_SskfbPp9QB7IHLFCQI7wTArPP04hXXaNNvtOMUH9QLg1Z-eOLddzGMd4uo6sURuGu',
    ['Transfer'] = 'https://discord.com/api/webhooks/940194366079791125/iA_SskfbPp9QB7IHLFCQI7wTArPP04hXXaNNvtOMUH9QLg1Z-eOLddzGMd4uo6sURuGu',
    ['Givecash'] = 'https://discord.com/api/webhooks/940194366079791125/iA_SskfbPp9QB7IHLFCQI7wTArPP04hXXaNNvtOMUH9QLg1Z-eOLddzGMd4uo6sURuGu',
    ['Fishing'] = 'https://discord.com/api/webhooks/940194647207194634/QXDs6qUwP81hGzP0CkgENCdL4bQJGnt51Cs29lnDh7tEFOX-6IZI7nHEQxoh-T952lpx',
    ['Garbage'] = 'https://discord.com/api/webhooks/940194647207194634/QXDs6qUwP81hGzP0CkgENCdL4bQJGnt51Cs29lnDh7tEFOX-6IZI7nHEQxoh-T952lpx',
    ['Hunting'] = 'https://discord.com/api/webhooks/940194647207194634/QXDs6qUwP81hGzP0CkgENCdL4bQJGnt51Cs29lnDh7tEFOX-6IZI7nHEQxoh-T952lpx',
    ['Mining'] = 'https://discord.com/api/webhooks/940194647207194634/QXDs6qUwP81hGzP0CkgENCdL4bQJGnt51Cs29lnDh7tEFOX-6IZI7nHEQxoh-T952lpx',
    ['PostOP'] = 'https://discord.com/api/webhooks/940194647207194634/QXDs6qUwP81hGzP0CkgENCdL4bQJGnt51Cs29lnDh7tEFOX-6IZI7nHEQxoh-T952lpx',
    ['WaterPower'] = 'https://discord.com/api/webhooks/940194647207194634/QXDs6qUwP81hGzP0CkgENCdL4bQJGnt51Cs29lnDh7tEFOX-6IZI7nHEQxoh-T952lpx',
    ['Chicken'] = 'https://discord.com/api/webhooks/940194647207194634/QXDs6qUwP81hGzP0CkgENCdL4bQJGnt51Cs29lnDh7tEFOX-6IZI7nHEQxoh-T952lpx',
}

Void.Logs.JoinLog = function(self, pName, pSteam, pDiscord)
    local embed = {
        {
            ['description'] = string.format("`User is joining!`\n\n━━━━━━━━━━━━━━━━━━\n\n`• Steam: %s`\n\n`• Discord: %s`\n━━━━━━━━━━━━━━━━━━", pSteam, pDiscord),
            ['color'] = 3124231,
            ['author'] = {
                ['name'] = pName
            }
        }
    }
    PerformHttpRequest(Void.Logs.Webhooks['Connection'], function(err, text, headers) end, 'POST', json.encode({username = 'Connection Logs', embeds = embed}), { ['Content-Type'] = 'application/json' })
end

Void.Logs.ExitLog = function(self, dReason, pName, pSteam, pDiscord)
    local embed = {
        {
            ['description'] = string.format("`User has left!`\n\n`• Reason: %s`\n\n━━━━━━━━━━━━━━━━━━\n\n`• Steam: %s`\n\n`• Discord: %s`\n━━━━━━━━━━━━━━━━━━", dReason, pSteam, pDiscord),
            ['color'] = 14038582,
            ['author'] = {
                ['name'] = pName
            }
        }
    }
    PerformHttpRequest(Void.Logs.Webhooks['Leave'], function(err, text, headers) end, 'POST', json.encode({username = 'Connection Logs', embeds = embed}), { ['Content-Type'] = 'application/json' })
end

Void.Logs.UserCreate = function(self, uId, pName, pSteam, pDiscord, firstname, lastname, dob, gender)
    local embed = {
        {
            ['description'] = string.format("`User Profile Created.`\n\n`• User Id: %s`\n\n━━━━━━━━━━━━━━━━━━\n\n`• Steam: %s`\n\n`• Discord: %s`\n\n━━━━━━━━━━━━━━━━━━\n\n`• First Name: %s`\n\n`• Last Name: %s`\n\n`• Date of Birth: %s`\n\n`• Gender: %s`\n━━━━━━━━━━━━━━━━━━", uId, pSteam, pDiscord, firstname, lastname, dob, gender),
            ['color'] = 2317994,
            ['author'] = {
                ['name'] = pName
            }
        }
    }
    PerformHttpRequest(Void.Logs.Webhooks['Character'], function(err, text, headers) end, 'POST', json.encode({username = 'User Logs', embeds = embed}), { ['Content-Type'] = 'application/json' })
end

Void.Logs.DeathLogs = function(self, uId, message)
    local embed = {
        {
            ['description'] = string.format("`Death Log Created.`\n\n━━━━━━━━━━━━━━━━━━\n`• ".. message .. "`\n━━━━━━━━━━━━━━━━━━"),
            ['color'] = 3593942,
        }
    }
    PerformHttpRequest(Void.Logs.Webhooks['DeathLogs'], function(err, text, headers) end, 'POST', json.encode({username = 'User Logs', embeds = embed}), { ['Content-Type'] = 'application/json' })
end

Void.Logs.BankingWidthdraw = function(self, uId, pName, pSteam, pDiscord, pulled, cashleft, bankleft)
    local embed = {
        {
            ['description'] = string.format("`Bank Log Widthdraw Created.`\n\n`• User Id: %s`\n\n━━━━━━━━━━━━━━━━━━\n\n`• Steam: %s`\n\n`• Discord: %s`\n\n━━━━━━━━━━━━━━━━━━\n\n`• Amount Withdrawn: $%s`\n\n`• Cash Balance: $%s`\n\n`• Bank Balance: $%s`\n━━━━━━━━━━━━━━━━━━", uId, pSteam, pDiscord, pulled, cashleft, bankleft),
            ['color'] = 8795862,
            ['author'] = {
                ['name'] = pName
            }
        }
    }
    PerformHttpRequest(Void.Logs.Webhooks['Widthdraw'], function(err, text, headers) end, 'POST', json.encode({username = 'User Logs', embeds = embed}), { ['Content-Type'] = 'application/json' })
end

Void.Logs.BankingDeposit = function(self, uId, pName, pSteam, pDiscord, pulled, cashleft, bankleft)
    local embed = {
        {
            ['description'] = string.format("`Bank Deposit Log Created.`\n\n`• User Id: %s`\n\n━━━━━━━━━━━━━━━━━━\n\n`• Steam: %s`\n\n`• Discord: %s`\n\n━━━━━━━━━━━━━━━━━━\n\n`• Amount Deposited: $%s`\n\n`• Cash Balance: $%s`\n\n`• Bank Balance: $%s`\n━━━━━━━━━━━━━━━━━━", uId, pSteam, pDiscord, pulled, cashleft, bankleft),
            ['color'] = 8795862,
            ['author'] = {
                ['name'] = pName
            }
        }
    }
    PerformHttpRequest(Void.Logs.Webhooks['Deposit'], function(err, text, headers) end, 'POST', json.encode({username = 'User Logs', embeds = embed}), { ['Content-Type'] = 'application/json' })
end

Void.Logs.BankingTransfer = function(self, uId, uId2, pName, pName2, pSteam, pDiscord, pSteam2, pDiscord2, pulled, cashleft, bankleft, pulled2, cashleft2, bankleft2)
    local embed = {
        {
            ['description'] = string.format("`Bank Transfer Log Created.`\n\n`• Player User Id: %s`\n\n`• Target User Id: %s`\n\n━━━━━━━━━━━━━━━━━━\n\n`• Player Steam: %s`\n\n`• Player Discord: %s`\n\n━━━━━━━━━━━━━━━━━━\n\n`• Target Steam: %s`\n\n`• Target Discord: %s`\n\n━━━━━━━━━━━━━━━━━━\n\n`• Player Amount Transfered: $%s`\n\n`• Player Cash Balance: $%s`\n\n`• Player Bank Balance: $%s`\n\n━━━━━━━━━━━━━━━━━━\n\n`• Target Amount Received: $%s`\n\n`• Target Cash Balance: $%s`\n\n`• Target Bank Balance: $%s`\n━━━━━━━━━━━━━━━━━━", uId, uId2, pSteam, pDiscord, pSteam2, pDiscord2, pulled, cashleft, bankleft, pulled2, cashleft2, bankleft2),
            ['color'] = 8795862,
            ['author'] = {
                ['name'] = "Player : " .. pName .. " | Target : ".. pName2
            }
        }
    }
    PerformHttpRequest(Void.Logs.Webhooks['Transfer'], function(err, text, headers) end, 'POST', json.encode({username = 'User Logs', embeds = embed}), { ['Content-Type'] = 'application/json' })
end

Void.Logs.BankingGiveCash = function(self, uId, uId2, pName, pName2, pSteam, pDiscord, pSteam2, pDiscord2, pulled, cashleft, bankleft, pulled2, cashleft2, bankleft2)
    local embed = {
        {
            ['description'] = string.format("`Cash Given Log Created.`\n\n`• Player User Id: %s`\n\n`• Target User Id: %s`\n\n━━━━━━━━━━━━━━━━━━\n\n`• Player Steam: %s`\n\n`• Player Discord: %s`\n\n━━━━━━━━━━━━━━━━━━\n\n`• Target Steam: %s`\n\n`• Target Discord: %s`\n\n━━━━━━━━━━━━━━━━━━\n\n`• Player Amount Transfered: $%s`\n\n`• Player Cash Balance: $%s`\n\n`• Player Bank Balance: $%s`\n\n━━━━━━━━━━━━━━━━━━\n\n`• Target Amount Received: $%s`\n\n`• Target Cash Balance: $%s`\n\n`• Target Bank Balance: $%s`\n━━━━━━━━━━━━━━━━━━", uId, uId2, pSteam, pDiscord, pSteam2, pDiscord2, pulled, cashleft, bankleft, pulled2, cashleft2, bankleft2),
            ['color'] = 8795862,
            ['author'] = {
                ['name'] = "Player : " .. pName .. " | Target : ".. pName2
            }
        }
    }
    PerformHttpRequest(Void.Logs.Webhooks['Givecash'], function(err, text, headers) end, 'POST', json.encode({username = 'User Logs', embeds = embed}), { ['Content-Type'] = 'application/json' })
end

Void.Logs.FishingLog = function(self, uId, pName, pSteam, pDiscord, amount)
    local embed = {
        {
            ['description'] = string.format("`Fishing Payment Log Created.`\n\n`• Steam: %s`\n\n`• Discord: %s`\n━━━━━━━━━━━━━━━━━━\n\n`• User ID: %s`\n\n`• Payment Amount: %s`\n\n━━━━━━━━━━━━━━━━━━\n\n", pSteam, pDiscord, uId, amount),
            ['color'] = 0128128,
            ['author'] = {
                ['name'] = pName
            }
        }
    }
    PerformHttpRequest(Void.Logs.Webhooks['Fishing'], function(err, text, headers) end, 'POST', json.encode({username = 'Fishing Logs', embeds = embed}), { ['Content-Type'] = 'application/json' })
end

Void.Logs.GarbageLog = function(self, uId, pName, pSteam, pDiscord, amount)
    local embed = {
        {
            ['description'] = string.format("`Garbage Payment Log Created.`\n\n`• Steam: %s`\n\n`• Discord: %s`\n━━━━━━━━━━━━━━━━━━\n\n`• User ID: %s`\n\n`• Payment Amount: %s`\n\n━━━━━━━━━━━━━━━━━━\n\n", pSteam, pDiscord, uId, amount),
            ['color'] = 0128128,
            ['author'] = {
                ['name'] = pName
            }
        }
    }
    PerformHttpRequest(Void.Logs.Webhooks['Garbage'], function(err, text, headers) end, 'POST', json.encode({username = 'Garbage Logs', embeds = embed}), { ['Content-Type'] = 'application/json' })
end

Void.Logs.HuntingLog = function(self, uId, pName, pSteam, pDiscord, amount)
    local embed = {
        {
            ['description'] = string.format("`Hunting Payment Log Created.`\n\n`• Steam: %s`\n\n`• Discord: %s`\n━━━━━━━━━━━━━━━━━━\n\n`• User ID: %s`\n\n`• Payment Amount: %s`\n\n━━━━━━━━━━━━━━━━━━\n\n", pSteam, pDiscord, uId, amount),
            ['color'] = 0128128,
            ['author'] = {
                ['name'] = pName
            }
        }
    }
    PerformHttpRequest(Void.Logs.Webhooks['Hunting'], function(err, text, headers) end, 'POST', json.encode({username = 'Hunting Logs', embeds = embed}), { ['Content-Type'] = 'application/json' })
end

Void.Logs.MiningLog = function(self, uId, pName, pSteam, pDiscord, amount)
    local embed = {
        {
            ['description'] = string.format("`Mining Payment Log Created.`\n\n`• Steam: %s`\n\n`• Discord: %s`\n━━━━━━━━━━━━━━━━━━\n\n`• User ID: %s`\n\n`• Payment Amount: %s`\n\n━━━━━━━━━━━━━━━━━━\n\n", pSteam, pDiscord, uId, amount),
            ['color'] = 0128128,
            ['author'] = {
                ['name'] = pName
            }
        }
    }
    PerformHttpRequest(Void.Logs.Webhooks['Mining'], function(err, text, headers) end, 'POST', json.encode({username = 'Mining Logs', embeds = embed}), { ['Content-Type'] = 'application/json' })
end

Void.Logs.PostOPLog = function(self, uId, pName, pSteam, pDiscord, amount)
    local embed = {
        {
            ['description'] = string.format("`PostOP Payment Log Created.`\n\n`• Steam: %s`\n\n`• Discord: %s`\n━━━━━━━━━━━━━━━━━━\n\n`• User ID: %s`\n\n`• Payment Amount: %s`\n\n━━━━━━━━━━━━━━━━━━\n\n", pSteam, pDiscord, uId, amount),
            ['color'] = 0128128,
            ['author'] = {
                ['name'] = pName
            }
        }
    }
    PerformHttpRequest(Void.Logs.Webhooks['PostOP'], function(err, text, headers) end, 'POST', json.encode({username = 'PostOP Logs', embeds = embed}), { ['Content-Type'] = 'application/json' })
end

Void.Logs.WaterPowerLog = function(self, uId, pName, pSteam, pDiscord, amount)
    local embed = {
        {
            ['description'] = string.format("`Water & Power Payment Log Created.`\n\n`• Steam: %s`\n\n`• Discord: %s`\n━━━━━━━━━━━━━━━━━━\n\n`• User ID: %s`\n\n`• Payment Amount: %s`\n\n━━━━━━━━━━━━━━━━━━\n\n", pSteam, pDiscord, uId, amount),
            ['color'] = 0128128,
            ['author'] = {
                ['name'] = pName
            }
        }
    }
    PerformHttpRequest(Void.Logs.Webhooks['WaterPower'], function(err, text, headers) end, 'POST', json.encode({username = 'Water & Power Logs', embeds = embed}), { ['Content-Type'] = 'application/json' })
end

Void.Logs.ChickenLog = function(self, uId, pName, pSteam, pDiscord, amount)
    local embed = {
        {
            ['description'] = string.format("`Chicken Payment Log Created.`\n\n`• Steam: %s`\n\n`• Discord: %s`\n━━━━━━━━━━━━━━━━━━\n\n`• User ID: %s`\n\n`• Payment Amount: %s`\n\n━━━━━━━━━━━━━━━━━━\n\n", pSteam, pDiscord, uId, amount),
            ['color'] = 0128128,
            ['author'] = {
                ['name'] = pName
            }
        }
    }
    PerformHttpRequest(Void.Logs.Webhooks['Chicken'], function(err, text, headers) end, 'POST', json.encode({username = 'Chicken Logs', embeds = embed}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent('warp-base:charactercreate')
AddEventHandler('warp-base:charactercreate',function(firstname, lastname, dob, gender)
    local pSteam = 'None'
    local pDiscord = 'None'
    local pName = GetPlayerName(source)
    local pIdentifiers = GetPlayerIdentifiers(source)
    for k, v in pairs(pIdentifiers) do
        if string.find(v, 'steam') then pSteam = v end
        if string.find(v, 'discord') then pDiscord = v end
    end
    Void.Logs:UserCreate(source, pName, pSteam, pDiscord, firstname, lastname, dob, gender)
end)


RegisterServerEvent('warp-base:bankwidthdraw')
AddEventHandler('warp-base:bankwidthdraw',function(source, pulled, cashleft, bankleft)
    local pSteam = 'None'
    local pDiscord = 'None'
    local pName = GetPlayerName(source)
    local pIdentifiers = GetPlayerIdentifiers(source)
    for k, v in pairs(pIdentifiers) do
        if string.find(v, 'steam') then pSteam = v end
        if string.find(v, 'discord') then pDiscord = v end
    end
    Void.Logs:BankingWidthdraw(source, pName, pSteam, pDiscord, pulled, cashleft, bankleft)
end)

RegisterServerEvent('warp-base:bankdeposit')
AddEventHandler('warp-base:bankdeposit',function(source, pulled, cashleft, bankleft)
    local pSteam = 'None'
    local pDiscord = 'None'
    local pName = GetPlayerName(source)
    local pIdentifiers = GetPlayerIdentifiers(source)
    for k, v in pairs(pIdentifiers) do
        if string.find(v, 'steam') then pSteam = v end
        if string.find(v, 'discord') then pDiscord = v end
    end
    Void.Logs:BankingDeposit(source, pName, pSteam, pDiscord, pulled, cashleft, bankleft)
end)

RegisterServerEvent('warp-base:banktransfer')
AddEventHandler('warp-base:banktransfer',function(source, number, pName2, pSteam2, pDiscord2, pulled, cashleft, bankleft, pulled2, cashleft2, bankleft2)
    local pSteam = 'None'
    local pDiscord = 'None'
    local pName = GetPlayerName(source)
    local pIdentifiers = GetPlayerIdentifiers(source)
    for k, v in pairs(pIdentifiers) do
        if string.find(v, 'steam') then pSteam = v end
        if string.find(v, 'discord') then pDiscord = v end
    end
    Void.Logs:BankingTransfer(source, number, pName, pName2, pSteam, pDiscord, pSteam2, pDiscord2, pulled, cashleft, bankleft, pulled2, cashleft2, bankleft2)
end)

RegisterServerEvent('warp-base:bankgivecash')
AddEventHandler('warp-base:bankgivecash',function(source, number, pName2, pSteam2, pDiscord2, pulled, cashleft, bankleft, pulled2, cashleft2, bankleft2)
    local pSteam = 'None'
    local pDiscord = 'None'
    local pName = GetPlayerName(source)
    local pIdentifiers = GetPlayerIdentifiers(source)
    for k, v in pairs(pIdentifiers) do
        if string.find(v, 'steam') then pSteam = v end
        if string.find(v, 'discord') then pDiscord = v end
    end
    Void.Logs:BankingGiveCash(source, number, pName, pName2, pSteam, pDiscord, pSteam2, pDiscord2, pulled, cashleft, bankleft, pulled2, cashleft2, bankleft2)
end)

RegisterServerEvent('warp-base:deathlogs')
AddEventHandler('warp-base:deathlogs',function(message)
    Void.Logs:DeathLogs(source, message)
end)

RegisterServerEvent('warp-base:fishingLog')
AddEventHandler('warp-base:fishingLog',function(source, amount)
    local pSteam = 'None'
    local pDiscord = 'None'
    local pName = GetPlayerName(source)
    local pIdentifiers = GetPlayerIdentifiers(source)
    for k, v in pairs(pIdentifiers) do
        if string.find(v, 'steam') then pSteam = v end
        if string.find(v, 'discord') then pDiscord = v end
    end
    Void.Logs.FishingLog(source, source, pName, pSteam, pDiscord, amount)
end)

RegisterServerEvent('warp-base:garbageLog')
AddEventHandler('warp-base:garbageLog',function(source, amount)
    local pSteam = 'None'
    local pDiscord = 'None'
    local pName = GetPlayerName(source)
    local pIdentifiers = GetPlayerIdentifiers(source)
    for k, v in pairs(pIdentifiers) do
        if string.find(v, 'steam') then pSteam = v end
        if string.find(v, 'discord') then pDiscord = v end
    end
    Void.Logs.GarbageLog(source, source, pName, pSteam, pDiscord, amount)
end)

RegisterServerEvent('warp-base:huntingLog')
AddEventHandler('warp-base:huntingLog',function(source, amount)
    local pSteam = 'None'
    local pDiscord = 'None'
    local pName = GetPlayerName(source)
    local pIdentifiers = GetPlayerIdentifiers(source)
    for k, v in pairs(pIdentifiers) do
        if string.find(v, 'steam') then pSteam = v end
        if string.find(v, 'discord') then pDiscord = v end
    end
    Void.Logs.HuntingLog(source, source, pName, pSteam, pDiscord, amount)
end)

RegisterServerEvent('warp-base:miningLog')
AddEventHandler('warp-base:miningLog',function(source, amount)
    local pSteam = 'None'
    local pDiscord = 'None'
    local pName = GetPlayerName(source)
    local pIdentifiers = GetPlayerIdentifiers(source)
    for k, v in pairs(pIdentifiers) do
        if string.find(v, 'steam') then pSteam = v end
        if string.find(v, 'discord') then pDiscord = v end
    end
    Void.Logs.MiningLog(source, source, pName, pSteam, pDiscord, amount)
end)

RegisterServerEvent('warp-base:postopLog')
AddEventHandler('warp-base:postopLog',function(source, amount)
    local pSteam = 'None'
    local pDiscord = 'None'
    local pName = GetPlayerName(source)
    local pIdentifiers = GetPlayerIdentifiers(source)
    for k, v in pairs(pIdentifiers) do
        if string.find(v, 'steam') then pSteam = v end
        if string.find(v, 'discord') then pDiscord = v end
    end
    Void.Logs.PostOPLog(source, source, pName, pSteam, pDiscord, amount)
end)

RegisterServerEvent('warp-base:waterpowerLog')
AddEventHandler('warp-base:waterpowerLog',function(source, amount)
    local pSteam = 'None'
    local pDiscord = 'None'
    local pName = GetPlayerName(source)
    local pIdentifiers = GetPlayerIdentifiers(source)
    for k, v in pairs(pIdentifiers) do
        if string.find(v, 'steam') then pSteam = v end
        if string.find(v, 'discord') then pDiscord = v end
    end
    Void.Logs.WaterPowerLog(source, source, pName, pSteam, pDiscord, amount)
end)

RegisterServerEvent('warp-base:chickenLog')
AddEventHandler('warp-base:chickenLog',function(source, amount)
    local pSteam = 'None'
    local pDiscord = 'None'
    local pName = GetPlayerName(source)
    local pIdentifiers = GetPlayerIdentifiers(source)
    for k, v in pairs(pIdentifiers) do
        if string.find(v, 'steam') then pSteam = v end
        if string.find(v, 'discord') then pDiscord = v end
    end
    Void.Logs.ChickenLog(source, source, pName, pSteam, pDiscord, amount)
end)