-- POLICE HIRE/FIRE --

RegisterServerEvent("warp-duty:HireLaw")
AddEventHandler("warp-duty:HireLaw", function(cid, job, rank)
    local src = source
    if job == 'state' or job == 'police' or job == 'sheriff' then
        exports.oxmysql:execute("INSERT INTO jobs_whitelist (cid, job, rank) VALUES (@cid, @job, @rank)", {['@cid'] = cid, ['@job'] = job, ['@rank'] = rank})
        exports.oxmysql:execute('SELECT * FROM characters WHERE id = @cid', {['@cid'] = cid}, function(result)
            if result[1] ~= nil then
                TriggerClientEvent('DoLongHudText', src, 'You hired '.. result[1].first_name ..' '.. result[1].last_name, 1)
            end
        end)
    else
        TriggerClientEvent('DoLongHudText', src, 'Please select one of these jobs! (police, state, sheriff)', 2)
    end
end)

RegisterServerEvent("warp-duty:FireLaw")
AddEventHandler("warp-duty:FireLaw", function(cid)
    local src = source
    exports.oxmysql:execute('SELECT * FROM characters WHERE id = @cid', {['@cid'] = cid}, function(result)
        exports.oxmysql:execute('SELECT * FROM jobs_whitelist WHERE cid = @cid', {['@cid'] = cid}, function(result2)
            if result[1] ~= nil and result2[1] ~= nil then
                if result2[1].job == 'state' or result2[1].job == 'police' or result2[1].job == 'sheriff' then
                    exports.oxmysql:execute("DELETE FROM jobs_whitelist WHERE `cid` = @cid AND `job` = @job", {['@cid'] = cid, ['@job'] = result2[1].job})
                    TriggerClientEvent('DoLongHudText', src, 'You fired '.. result[1].first_name ..' '.. result[1].last_name, 2)
                else
                    TriggerClientEvent('DoLongHudText', src, 'The person you are trying firing does not work for you!', 2)
                end
            end
        end) 
    end)
end)

-- END POLICE HIRE/FIRE --

-- EMS HIRE/FIRE --

RegisterServerEvent("warp-duty:HireEMS")
AddEventHandler("warp-duty:HireEMS", function(cid, rank)
    local src = source
    exports.oxmysql:execute("INSERT INTO jobs_whitelist (cid, job, rank) VALUES (@cid, @job, @rank)", {['@cid'] = cid, ['@job'] = 'ems', ['@rank'] = rank})
    exports.oxmysql:execute('SELECT * FROM characters WHERE id = @cid', {['@cid'] = cid}, function(result)
        if result[1] ~= nil then
            TriggerClientEvent('DoLongHudText', src, 'You hired '.. result[1].first_name ..' '.. result[1].last_name, 1)
        end
    end)
end)

RegisterServerEvent("warp-duty:FireEMS")
AddEventHandler("warp-duty:FireEMS", function(cid)
    local src = source
    exports.oxmysql:execute('SELECT * FROM characters WHERE id = @cid', {['@cid'] = cid}, function(result)
        exports.oxmysql:execute('SELECT * FROM jobs_whitelist WHERE cid = @cid AND job = "ems"', {['@cid'] = cid}, function(result2)
            if result[1] ~= nil and result2[1] ~= nil then
                if result2[1].job == 'ems' then
                    exports.oxmysql:execute("DELETE FROM jobs_whitelist WHERE `cid` = @cid AND `job` = @job", {['@cid'] = cid, ['@job'] = result2[1].job})
                    TriggerClientEvent('DoLongHudText', src, 'You fired '.. result[1].first_name ..' '.. result[1].last_name, 2)
                else
                    TriggerClientEvent('DoLongHudText', src, 'The person you are trying firing does not work for you!', 2)
                end
            end
        end) 
    end)
end)

-- END EMS HIRE/FIRE --

-- Burgershot HIRE/FIRE --

RegisterServerEvent("warp-duty:HireBurger")
AddEventHandler("warp-duty:HireBurger", function(cid, rank)
    local src = source
    exports.oxmysql:execute("INSERT INTO jobs_whitelist (cid, job, rank) VALUES (@cid, @job, @rank)", {['@cid'] = cid, ['@job'] = 'burger_shot', ['@rank'] = rank})
    exports.oxmysql:execute('SELECT * FROM characters WHERE id = @cid', {['@cid'] = cid}, function(result)
        if result[1] ~= nil then
            TriggerClientEvent('DoLongHudText', src, 'You hired '.. result[1].first_name ..' '.. result[1].last_name, 1)
        end
    end)
end)

RegisterServerEvent("warp-duty:FireBurger")
AddEventHandler("warp-duty:FireBurger", function(cid)
    local src = source
    exports.oxmysql:execute('SELECT * FROM characters WHERE id = @cid', {['@cid'] = cid}, function(result)
        exports.oxmysql:execute('SELECT * FROM jobs_whitelist WHERE cid = @cid AND job = "burger_shot"', {['@cid'] = cid}, function(result2)
            if result[1] ~= nil and result2[1] ~= nil then
                if result2[1].job == 'burger_shot' then
                    exports.oxmysql:execute("DELETE FROM jobs_whitelist WHERE `cid` = @cid AND `job` = @job", {['@cid'] = cid, ['@job'] = result2[1].job})
                    TriggerClientEvent('DoLongHudText', src, 'You fired '.. result[1].first_name ..' '.. result[1].last_name, 2)
                else
                    TriggerClientEvent('DoLongHudText', src, 'The person you are trying firing does not work for you!', 2)
                end
            end
        end) 
    end)
end)

-- END Burgershot HIRE/FIRE --

-- ArtGallery HIRE/FIRE --

RegisterServerEvent("warp-duty:HireArt")
AddEventHandler("warp-duty:HireArt", function(cid, rank)
    local src = source
    exports.oxmysql:execute("INSERT INTO jobs_whitelist (cid, job, rank) VALUES (@cid, @job, @rank)", {['@cid'] = cid, ['@job'] = 'art_gallery', ['@rank'] = rank})
    exports.oxmysql:execute('SELECT * FROM characters WHERE id = @cid', {['@cid'] = cid}, function(result)
        if result[1] ~= nil then
            TriggerClientEvent('DoLongHudText', src, 'You hired '.. result[1].first_name ..' '.. result[1].last_name, 1)
        end
    end)
end)

RegisterServerEvent("warp-duty:FireArt")
AddEventHandler("warp-duty:FireArt", function(cid)
    local src = source
    exports.oxmysql:execute('SELECT * FROM characters WHERE id = @cid', {['@cid'] = cid}, function(result)
        exports.oxmysql:execute('SELECT * FROM jobs_whitelist WHERE cid = @cid AND job = "art_gallery"', {['@cid'] = cid}, function(result2)
            if result[1] ~= nil and result2[1] ~= nil then
                if result2[1].job == 'art_gallery' then
                    exports.oxmysql:execute("DELETE FROM jobs_whitelist WHERE `cid` = @cid AND `job` = @job", {['@cid'] = cid, ['@job'] = result2[1].job})
                    TriggerClientEvent('DoLongHudText', src, 'You fired '.. result[1].first_name ..' '.. result[1].last_name, 2)
                else
                    TriggerClientEvent('DoLongHudText', src, 'The person you are trying firing does not work for you!', 2)
                end
            end
        end) 
    end)
end)

-- END ArtGallery HIRE/FIRE --

-- PDM HIRE/FIRE --

RegisterServerEvent("warp-duty:HirePDM")
AddEventHandler("warp-duty:HirePDM", function(cid, rank)
    local src = source
    exports.oxmysql:execute("INSERT INTO jobs_whitelist (cid, job, rank) VALUES (@cid, @job, @rank)", {['@cid'] = cid, ['@job'] = 'pdm', ['@rank'] = rank})
    exports.oxmysql:execute('SELECT * FROM characters WHERE id = @cid', {['@cid'] = cid}, function(result)
        if result[1] ~= nil then
            TriggerClientEvent('DoLongHudText', src, 'You hired '.. result[1].first_name ..' '.. result[1].last_name, 1)
        end
    end)
end)

RegisterServerEvent("warp-duty:FirePDM")
AddEventHandler("warp-duty:FirePDM", function(cid)
    local src = source
    exports.oxmysql:execute('SELECT * FROM characters WHERE id = @cid', {['@cid'] = cid}, function(result)
        exports.oxmysql:execute('SELECT * FROM jobs_whitelist WHERE cid = @cid AND job = "pdm"', {['@cid'] = cid}, function(result2)
            if result[1] ~= nil and result2[1] ~= nil then
                if result2[1].job == 'pdm' then
                    exports.oxmysql:execute("DELETE FROM jobs_whitelist WHERE `cid` = @cid AND `job` = @job", {['@cid'] = cid, ['@job'] = result2[1].job})
                    TriggerClientEvent('DoLongHudText', src, 'You fired '.. result[1].first_name ..' '.. result[1].last_name, 2)
                else
                    TriggerClientEvent('DoLongHudText', src, 'The person you are trying firing does not work for you!', 2)
                end
            end
        end) 
    end)
end)
-- END PDM HIRE/FIRE --

-- Cosmic Cannabis HIRE/FIRE --

RegisterServerEvent("warp-duty:HireCosmic")
AddEventHandler("warp-duty:HireCosmic", function(cid, rank)
    local src = source
    exports.oxmysql:execute("INSERT INTO jobs_whitelist (cid, job, rank) VALUES (@cid, @job, @rank)", {['@cid'] = cid, ['@job'] = 'cosmic_cannabis', ['@rank'] = rank})
    exports.oxmysql:execute('SELECT * FROM characters WHERE id = @cid', {['@cid'] = cid}, function(result)
        if result[1] ~= nil then
            TriggerClientEvent('DoLongHudText', src, 'You hired '.. result[1].first_name ..' '.. result[1].last_name, 1)
        end
    end)
end)

RegisterServerEvent("warp-duty:FireCosmic")
AddEventHandler("warp-duty:FireCosmic", function(cid)
    local src = source
    exports.oxmysql:execute('SELECT * FROM characters WHERE id = @cid', {['@cid'] = cid}, function(result)
        exports.oxmysql:execute('SELECT * FROM jobs_whitelist WHERE cid = @cid AND job = "cosmic_cannabis"', {['@cid'] = cid}, function(result2)
            if result[1] ~= nil and result2[1] ~= nil then
                if result2[1].job == 'cosmic_cannabis' then
                    exports.oxmysql:execute("DELETE FROM jobs_whitelist WHERE `cid` = @cid AND `job` = @job", {['@cid'] = cid, ['@job'] = result2[1].job})
                    TriggerClientEvent('DoLongHudText', src, 'You fired '.. result[1].first_name ..' '.. result[1].last_name, 2)
                else
                    TriggerClientEvent('DoLongHudText', src, 'The person you are trying firing does not work for you!', 2)
                end
            end
        end) 
    end)
end)
-- END Cosmic Cannabis HIRE/FIRE --