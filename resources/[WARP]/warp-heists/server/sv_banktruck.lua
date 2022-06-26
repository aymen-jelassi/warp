local license = 0

local licenseArray = {}

RegisterServerEvent('warp-heists:check_if_robbed')
AddEventHandler('warp-heists:check_if_robbed', function(license)

local _source = source

if licenseArray[#licenseArray] ~= nil then
    for k, v in pairs(licenseArray) do
        if v == license then
        return
        end
    end
end

licenseArray[#licenseArray+1] = license

    TriggerClientEvent('sec:AllowHeist', _source)
end)