RegisterServerEvent('warp-badge:server:useitem')
AddEventHandler('warp-badge:server:useitem', function(FUCKFEST)
    local pSrc = source
    local user = exports["warp-base"]:getModule("Player"):GetUser(pSrc)
    local char = user:getCurrentCharacter()
	local pData = json.decode(FUCKFEST)
	if pData ~= nil then
		exports.oxmysql:execute("SELECT `first_name`, `last_name` FROM characters WHERE id = @id", {['id'] = pData.cid}, function(pName)
			local name = char.first_name .. " " .. char.last_name
			exports.oxmysql:execute("SELECT `pp` FROM characters WHERE id = @id", {['id'] = pData.cid}, function(result)
				local img = '0'
				if result[1] ~= nil then
					img = result[1].mugshot_url
				end

				TriggerClientEvent('warp-badge:client:showbadge', -1, pSrc, img, "", name)
			end)
		end)
	end
end)

RegisterServerEvent("warp-pdbadge:buy")
AddEventHandler("warp-pdbadge:buy", function()
	local src = source
    local user = exports["warp-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
	information = {
		["cid"] = char.id,
	}

	TriggerClientEvent("player:receiveItem", src, "pdbadge", 1, true, information)
end)