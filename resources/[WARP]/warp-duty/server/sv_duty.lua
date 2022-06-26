local currentCops = 0
local currentEMS = 0

RegisterServerEvent('warp-duty:AttemptDuty')
AddEventHandler('warp-duty:AttemptDuty', function(pJobType)
	local src = source
	if src == nil or src == 0 then src = source end
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local character = user:getCurrentCharacter()
	local jobs = exports["warp-base"]:getModule("JobManager")
	local job = pJobType
	exports.oxmysql:execute('SELECT callsign FROM jobs_whitelist WHERE cid = ?', {character.id}, function(result)
		jobs:SetJob(user, job, false, function()
			if result[1].callsign ~= nil then
				pCallSign = result[1].callsign
			else
				pCallSign = "000"
			end
			if pJobType == 'police' then
				TriggerClientEvent('warp-duty:PDSuccess', src)
				TriggerClientEvent("DoLongHudText", src,"10-41 and Restocked.",17)
				TriggerClientEvent("startSpeedo",src)
				currentCops = currentCops + 1
				TriggerClientEvent("job:policecount", -1, currentCops)
				TriggerEvent('warp-eblips:server:registerPlayerBlipGroup', src, job)
				TriggerEvent('warp-eblips:server:registerSourceName', src, pCallSign .." | ".. character.first_name .." ".. character.last_name)
			elseif pJobType == 'sheriff' then
				TriggerClientEvent('warp-duty:BCSOSuccess', src)
				TriggerClientEvent("DoLongHudText", src,"10-41 and Restocked.",17)
				TriggerClientEvent("startSpeedo",src)
				currentCops = currentCops + 1
				TriggerClientEvent("job:policecount", -1, currentCops)
				TriggerEvent('warp-eblips:server:registerPlayerBlipGroup', src, job)
				TriggerEvent('warp-eblips:server:registerSourceName', src, pCallSign .." | ".. character.first_name .." ".. character.last_name)
			elseif pJobType == 'state' then
				TriggerClientEvent('warp-duty:SASPSuccess', src)
				TriggerClientEvent("DoLongHudText", src,"10-41 and Restocked.",17)
				TriggerClientEvent("startSpeedo",src)
				currentCops = currentCops + 1
				TriggerClientEvent("job:policecount", -1, currentCops)
				TriggerEvent('warp-eblips:server:registerPlayerBlipGroup', src, job)
				TriggerEvent('warp-eblips:server:registerSourceName', src, pCallSign .." | ".. character.first_name .." ".. character.last_name)
			elseif pJobType == 'doc' then
				TriggerClientEvent('warp-duty:DOCSuccess', src)
				TriggerClientEvent("DoLongHudText", src,"10-41 and Restocked.",17)
				TriggerClientEvent("startSpeedo",src)
				currentCops = currentCops + 1
				TriggerClientEvent("job:policecount", -1, currentCops)
				TriggerEvent('warp-eblips:server:registerPlayerBlipGroup', src, job)
				TriggerEvent('warp-eblips:server:registerSourceName', src, pCallSign .." | ".. character.first_name .." ".. character.last_name)
			end
		end)
	end)
end)

RegisterServerEvent('warp-duty:AttemptDutyEMS')
AddEventHandler('warp-duty:AttemptDutyEMS', function(src, pJobType)
	if src == nil or src == 0 then src = source end
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local character = user:getCurrentCharacter()
	local jobs = exports["warp-base"]:getModule("JobManager")
	local job = pJobType and pJobType or 'ems'
	exports.oxmysql:execute('SELECT callsign FROM jobs_whitelist WHERE cid = ?', {character.id}, function(result)
		jobs:SetJob(user, job, false, function()
			TriggerClientEvent('warp-duty:EMSSuccess', src)
			TriggerClientEvent("DoLongHudText", src,"On-Duty.",17)
			currentEMS = currentEMS + 1
			TriggerClientEvent("job:emscount", -1, currentEMS)
			TriggerEvent('warp-eblips:server:registerPlayerBlipGroup', src, 'ems')
			TriggerEvent('warp-eblips:server:registerSourceName', src, result[1].callsign .." | ".. character.first_name .." ".. character.last_name)
		end)
	end)
end)

RegisterServerEvent('warp-duty:OffDutyComplete')
AddEventHandler('warp-duty:OffDutyComplete', function(pJobType)
	print(pJobType)
	if currentCops ~= 0 then
		currentCops = currentCops - 1
	else
		currentCops = 0
	end
	TriggerClientEvent("job:policecount", -1, currentCops)
	TriggerEvent('warp-eblips:server:removePlayerBlipGroup', source, pJobType)
end)

RegisterServerEvent('warp-duty:OffDutyCompleteEMS')
AddEventHandler('warp-duty:OffDutyCompleteEMS', function()
	if currentEMS ~= 0 then
		currentEMS = currentEMS - 1
	else
		currentEMS = 0
	end
	TriggerClientEvent("job:emscount", -1, currentEMS)
	TriggerEvent('warp-eblips:server:removePlayerBlipGroup', source, 'ems')
end)

RegisterServerEvent('warp-duty:AttemptDutyJudge')
AddEventHandler('warp-duty:AttemptDutyJudge', function(src, pJobType)
	if src == nil or src == 0 then src = source end
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local character = user:getCurrentCharacter()
	local jobs = exports["warp-base"]:getModule("JobManager")
	exports.oxmysql:execute('SELECT job FROM jobs_whitelist WHERE cid = ? AND job = ?', {character.id, 'judge'}, function(result)
		if result[1] ~= nil then
			jobs:SetJob(user, 'judge', false, function()
				TriggerClientEvent("DoLongHudText", src,"Clock On!", 1)
				TriggerClientEvent('warp-duty:JudgeSuccess', src)
			end)
		else
			TriggerClientEvent("DoLongHudText", src,"You are not whitelisted for this job!", 2)
		end
	end)
end)

RegisterServerEvent('warp-duty:AttemptDutyDA')
AddEventHandler('warp-duty:AttemptDutyDA', function(src, pJobType)
	if src == nil or src == 0 then src = source end
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local character = user:getCurrentCharacter()
	local jobs = exports["warp-base"]:getModule("JobManager")
	exports.oxmysql:execute('SELECT job FROM jobs_whitelist WHERE cid = ? AND job = ?', {character.id, 'da'}, function(result)
		if result[1] ~= nil then
			jobs:SetJob(user, 'da', false, function()
				TriggerClientEvent("DoLongHudText", src,"Clock On!", 1)
				TriggerClientEvent('warp-duty:DASuccess', src)
			end)
		else
			TriggerClientEvent("DoLongHudText", src,"You are not whitelisted for this job!", 2)
		end
	end)
end)

RegisterServerEvent('warp-duty:AttemptDutyPublic')
AddEventHandler('warp-duty:AttemptDutyPublic', function(src, pJobType)
	if src == nil or src == 0 then src = source end
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local character = user:getCurrentCharacter()
	local jobs = exports["warp-base"]:getModule("JobManager")
	exports.oxmysql:execute('SELECT job FROM jobs_whitelist WHERE cid = ? AND job = ?', {character.id, 'defender'}, function(result)
		if result[1] ~= nil then
			jobs:SetJob(user, 'defender', false, function()
				TriggerClientEvent("DoLongHudText", src,"Clock On!", 1)
				TriggerClientEvent('warp-duty:PublicSuccess', src)
			end)
		else
			TriggerClientEvent("DoLongHudText", src,"You are not whitelisted for this job!", 2)
		end
	end)
end)
		-- Start Tow
RegisterServerEvent('warp-duty:AttemptDutyTow')
AddEventHandler('warp-duty:AttemptDutyTow', function(src, pJobType)
	if src == nil or src == 0 then src = source end
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local character = user:getCurrentCharacter()
	local jobs = exports["warp-base"]:getModule("JobManager")
	exports.oxmysql:execute('SELECT job FROM jobs_whitelist WHERE cid = ? AND job = ?', {character.id, 'towunion'}, function(result)
		if result[1] ~= nil then
			jobs:SetJob(user, 'towunion', false, function()
				TriggerClientEvent("DoLongHudText", src,"Clock On!", 1)
				TriggerClientEvent('warp-duty:TowSuccess', src)
			end)
		else
			TriggerClientEvent("DoLongHudText", src,"You are not whitelisted for this job!", 2)
		end
	end)
end)
		-- End Tow

		-- Start Burgershot
RegisterServerEvent('warp-duty:AttemptDutyBurger')
AddEventHandler('warp-duty:AttemptDutyBurger', function(src, pJobType)
	if src == nil or src == 0 then src = source end
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local character = user:getCurrentCharacter()
	local jobs = exports["warp-base"]:getModule("JobManager")
	exports.oxmysql:execute('SELECT job FROM jobs_whitelist WHERE cid = ? AND job = ?', {character.id, 'burger_shot'}, function(result)
		if result[1] ~= nil then
			jobs:SetJob(user, 'burger_shot', false, function()
				TriggerClientEvent("DoLongHudText", src,"Clock On!", 1)
				TriggerClientEvent('warp-duty:BurgerSuccess', src)
			end)
		else
			TriggerClientEvent("DoLongHudText", src,"You are not whitelisted for this job!", 2)
		end
	end)
end)
		-- End Burgershot

		-- Start ArtGallery
RegisterServerEvent('warp-duty:AttemptDutyArt')
AddEventHandler('warp-duty:AttemptDutyArt', function(src, pJobType)
	if src == nil or src == 0 then src = source end
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local character = user:getCurrentCharacter()
	local jobs = exports["warp-base"]:getModule("JobManager")
	exports.oxmysql:execute('SELECT job FROM jobs_whitelist WHERE cid = ? AND job = ?', {character.id, 'art_gallery'}, function(result)
		if result[1] ~= nil then
			jobs:SetJob(user, 'art_gallery', false, function()
				TriggerClientEvent("DoLongHudText", src,"Clock On!", 1)
				TriggerClientEvent('warp-duty:ArtSuccess', src)
			end)
		else
			TriggerClientEvent("DoLongHudText", src,"You are not whitelisted for this job!", 2)
		end
	end)
end)
		-- End ArtGallery

		--Start PDM
RegisterServerEvent('warp-duty:AttemptDutyPDM')
AddEventHandler('warp-duty:AttemptDutyPDM', function(src, pJobType)
	if src == nil or src == 0 then src = source end
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local character = user:getCurrentCharacter()
	local jobs = exports["warp-base"]:getModule("JobManager")
	exports.oxmysql:execute('SELECT job FROM jobs_whitelist WHERE cid = ? AND job = ?', {character.id, 'pdm'}, function(result)
		if result[1] ~= nil then
			jobs:SetJob(user, 'pdm', false, function()
				TriggerClientEvent("DoLongHudText", src,"Clock On!", 1)
				TriggerClientEvent('warp-duty:PDMSuccess', src)
			end)
		else
			TriggerClientEvent("DoLongHudText", src,"You are not whitelisted for this job!", 2)
		end
	end)
end)
		-- End PDM

		--Start Cosmic Cannabis
RegisterServerEvent('warp-duty:AttemptDutyCosmic')
AddEventHandler('warp-duty:AttemptDutyCosmic', function(src, pJobType)
	if src == nil or src == 0 then src = source end
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local character = user:getCurrentCharacter()
	local jobs = exports["warp-base"]:getModule("JobManager")
	exports.oxmysql:execute('SELECT job FROM jobs_whitelist WHERE cid = ? AND job = ?', {character.id, 'cosmic_cannabis'}, function(result)
		if result[1] ~= nil then
			jobs:SetJob(user, 'cosmic_cannabis', false, function()
				TriggerClientEvent("DoLongHudText", src,"Clock On!", 1)
				TriggerClientEvent('warp-duty:CosmicSuccess', src)
			end)
		else
			TriggerClientEvent("DoLongHudText", src,"You are not whitelisted for this job!", 2)
		end
	end)
end)
		-- End Cosmic Cannabis

AddEventHandler('playerDropped', function()
	local src = source
	if src ~= nil then
		local steamIdentifier = GetPlayerIdentifiers(src)[1]
		exports.oxmysql:execute('SELECT * FROM characters WHERE owner = ?', {steamIdentifier}, function(result)
			if result[1].job == 'police' or result[1].job == 'sheriff' or result[1].job == 'state' then
				if currentCops ~= 0 then
					currentCops = currentCops - 1
				else
					currentCops = 0
				end
                print('Active PD:', currentCops)
                exports.oxmysql:execute("UPDATE characters SET `job` = @job WHERE `owner` = @owner", {['@owner'] = steamIdentifier, ['@job'] = 'unemployed'})
				TriggerClientEvent("job:policecount", -1, currentCops)
				TriggerEvent('warp-eblips:server:removePlayerBlipGroup', src, 'police')
				TriggerClientEvent('warp-duty:OffDuty' ,src)
            elseif result[1].job == 'ems' then
                if currentEMS ~= 0 then
					currentEMS = currentEMS - 1
				else
					currentEMS = 0
				end
                print('Active EMS:', currentEMS)
				TriggerClientEvent('warp-duty:OffDutyEMS' ,src)
                exports.oxmysql:execute("UPDATE characters SET `job` = @job WHERE `owner` = @owner", {['@owner'] = steamIdentifier, ['@job'] = 'unemployed'})
				TriggerClientEvent("job:emscount", -1, currentEMS)
				TriggerEvent('warp-eblips:server:removePlayerBlipGroup', src, 'ems')
			end
		end)
	end
end)


function SignOnRadio(src)

	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local char = user:getCurrentCharacter()

	local q = [[SELECT id, cid, job, callsign, rank FROM jobs_whitelist WHERE cid = @cid AND (job = 'police' or job = 'doc')]]
	local v = {["cid"] = char.id}

	exports.oxmysql:execute(q, v, function(results)
		if not results then return end
		local callsign = ""
		if results[1].callsign ~= nil and results[1].callsign == "" then callsign = results[1].callsign else callsign = "TBD" end
		if (src ~= nil and char.first_name ~= nil and char.last_name ~= nil) then
			TriggerClientEvent("DoLongHudText", "Sessioned!?", 2)
		else
			TriggerClientEvent("SignOnRadio", src)
		end
	end)
end

RegisterServerEvent('warp-duty:AttemptDutySuits')
AddEventHandler('warp-duty:AttemptDutySuits', function(src, pJobType)
	if src == nil or src == 0 then src = source end
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local character = user:getCurrentCharacter()
	local jobs = exports["warp-base"]:getModule("JobManager")
	local job = pJobType and pJobType or 'suits'
	exports.oxmysql:execute('SELECT job FROM jobs_whitelist WHERE cid = ?', {character.id}, function(result)
		if result[1].job == "suits" then
			exports.oxmysql:execute('SELECT callsign FROM jobs_whitelist WHERE cid = ?', {character.id}, function(result2)
				jobs:SetJob(user, job, false, function()
					TriggerClientEvent('warp-duty:SuitsSuccess', src)
					TriggerClientEvent("DoLongHudText", src,"On-Duty.",17)
					TriggerClientEvent("job:suitscount", -1, currentSuits)
				end)
			end)
		else
			TriggerClientEvent("DoLongHudText", src,'You are not qualified for this', 2)
		end
	end)
end)

--// In N Out

RegisterServerEvent('warp-duty:attempt-in-n-out:duty')
AddEventHandler('warp-duty:attempt-in-n-out:duty', function(src, pJobType)
	if src == nil or src == 0 then src = source end
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local character = user:getCurrentCharacter()
	local jobs = exports["warp-base"]:getModule("JobManager")
	exports.oxmysql:execute('SELECT job FROM jobs_whitelist WHERE cid = ? AND job = ?', {character.id, 'in-n-out'}, function(result)
		if result[1] ~= nil then
			jobs:SetJob(user, 'in-n-out', false, function()
				TriggerClientEvent("DoLongHudText", src,"Clocked In As In N Out", 1)
				TriggerClientEvent('warp-duty:in-n-out:successful', src)
			end)
		else
			TriggerClientEvent("DoLongHudText", src, "You are not whitelisted for this job!", 2)
		end
	end)
end)

--// DOJ

-- Judge

RegisterServerEvent('warp-duty:attempt_duty:judge')
AddEventHandler('warp-duty:attempt_duty:judge', function(src, pJobType)
	if src == nil or src == 0 then src = source end
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local character = user:getCurrentCharacter()
	local jobs = exports["warp-base"]:getModule("JobManager")
	exports.oxmysql:execute('SELECT job FROM jobs_whitelist WHERE cid = ? AND job = ?', {character.id, 'judge'}, function(result)
		if result[1] ~= nil then
			jobs:SetJob(user, 'judge', false, function()
				TriggerClientEvent("DoLongHudText", src,"Successfully Clocked In As Judge", 1)
				TriggerClientEvent('warp-duty:clocked_in:judge_successful', src)
			end)
		else
			TriggerClientEvent("DoLongHudText", src, "You are not whitelisted for this job!", 2)
		end
	end)
end)

-- Public Defender

RegisterServerEvent('warp-duty:attempt_duty:public_defender')
AddEventHandler('warp-duty:attempt_duty:public_defender', function(src, pJobType)
	if src == nil or src == 0 then src = source end
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local character = user:getCurrentCharacter()
	local jobs = exports["warp-base"]:getModule("JobManager")
	exports.oxmysql:execute('SELECT job FROM jobs_whitelist WHERE cid = ? AND job = ?', {character.id, 'public_defender'}, function(result)
		if result[1] ~= nil then
			jobs:SetJob(user, 'public_defender', false, function()
				TriggerClientEvent("DoLongHudText", src,"Successfully Clocked In As Public Defender", 1)
				TriggerClientEvent('warp-duty:clocked_in:public_defender_successful', src)
			end)
		else
			TriggerClientEvent("DoLongHudText", src, "You are not whitelisted for this job!", 2)
		end
	end)
end)

-- District Attorney

RegisterServerEvent('warp-duty:attempt_duty:district_attorney')
AddEventHandler('warp-duty:attempt_duty:district_attorney', function(src, pJobType)
	if src == nil or src == 0 then src = source end
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local character = user:getCurrentCharacter()
	local jobs = exports["warp-base"]:getModule("JobManager")
	exports.oxmysql:execute('SELECT job FROM jobs_whitelist WHERE cid = ? AND job = ?', {character.id, 'district_attorney'}, function(result)
		if result[1] ~= nil then
			jobs:SetJob(user, 'district_attorney', false, function()
				TriggerClientEvent("DoLongHudText", src,"Successfully Clocked In As District Attorney", 1)
				TriggerClientEvent('warp-duty:clocked_in:district_attorney_successful', src)
			end)
		else
			TriggerClientEvent("DoLongHudText", src, "You are not whitelisted for this job!", 2)
		end
	end)
end)

----------------------------------------------------------------------------------------------------------------------------------

-- Burger Shot

RegisterServerEvent('warp-duty:attempt_duty:burger_shot')
AddEventHandler('warp-duty:attempt_duty:burger_shot', function(src, pJobType)
	if src == nil or src == 0 then src = source end
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local character = user:getCurrentCharacter()
	local jobs = exports["warp-base"]:getModule("JobManager")
	exports.oxmysql:execute('SELECT job FROM jobs_whitelist WHERE cid = ? AND job = ?', {character.id, 'burger_shot'}, function(result)
		if result[1] ~= nil then
			jobs:SetJob(user, 'burger_shot', false, function()
				TriggerClientEvent("DoLongHudText", src,"Successfully clocked into a 9 to 5", 1)
				TriggerClientEvent('warp-duty:clocked_in:burger_shot_successful', src)
			end)
		else
			TriggerClientEvent("DoLongHudText", src, "You don't work at Burgershot dumbass!", 2)
		end
	end)
end)

----------------------------------------------------------------------------------------------------------------------------------

-- PD

RegisterCommand('hirepd', function(source, args)
	local src = source
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local cid = user:getCurrentCharacter().id
		exports.oxmysql:execute('SELECT * FROM jobs_whitelist WHERE cid = ?', {cid}, function(result)
			if result[1].job == 'police' or result[1].job == 'state' or result[1].job == 'sheriff' and result[1].rank >= 3 then
				TriggerClientEvent('warp-duty:HireLaw:Menu', src)
			end
		end)
end)

RegisterCommand('firepd', function(source, args)
	local src = source
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local cid = user:getCurrentCharacter().id
		exports.oxmysql:execute('SELECT * FROM jobs_whitelist WHERE cid = ?', {cid}, function(result)
			if result[1].job == 'police' or result[1].job == 'state' or result[1].job == 'sheriff' and result[1].rank >= 3 then
				TriggerClientEvent('warp-duty:FireLaw:Menu', src)
			end
		end)
end)

-- EMS

RegisterCommand('hireems', function(source, args)
	local src = source
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local cid = user:getCurrentCharacter().id
	exports.oxmysql:execute('SELECT * FROM jobs_whitelist WHERE cid = ? AND job = "ems"', {cid}, function(result)
		if result[1].job == 'ems' and result[1].rank >= 3 then
				TriggerClientEvent('warp-duty:HireEMS:Menu', src)
			end
		end)
end)

RegisterCommand('fireems', function(source, args)
	local src = source
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local cid = user:getCurrentCharacter().id
	exports.oxmysql:execute('SELECT * FROM jobs_whitelist WHERE cid = ? AND job = "ems"', {cid}, function(result)
		if result[1].job == 'ems' and result[1].rank >= 3 then
				TriggerClientEvent('warp-duty:FireEMS:Menu', src)
			end
		end)
end)

-- Burgershot

RegisterCommand('hireburger', function(source, args)
	local src = source
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local cid = user:getCurrentCharacter().id
	exports.oxmysql:execute('SELECT * FROM jobs_whitelist WHERE cid = ? AND job = "burger_shot"', {cid}, function(result)
		if result[1].job == 'burger_shot' and result[1].rank >= 3 then
				TriggerClientEvent('warp-duty:HireBurger:Menu', src)
			end
		end)
end)

RegisterCommand('fireburger', function(source, args)
	local src = source
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local cid = user:getCurrentCharacter().id
	exports.oxmysql:execute('SELECT * FROM jobs_whitelist WHERE cid = ? AND job = "burger_shot"', {cid}, function(result)
		if result[1].job == 'burger_shot' and result[1].rank >= 3 then
				TriggerClientEvent('warp-duty:FireBurger:Menu', src)
			end
		end)
end)

-- ArtGallery

RegisterCommand('hireart', function(source, args)
	local src = source
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local cid = user:getCurrentCharacter().id
	exports.oxmysql:execute('SELECT * FROM jobs_whitelist WHERE cid = ? AND job = "art_gallery"', {cid}, function(result)
		if result[1].job == 'art_gallery' and result[1].rank >= 3 then
				TriggerClientEvent('warp-duty:HireArt:Menu', src)
			end
		end)
end)

RegisterCommand('fireart', function(source, args)
	local src = source
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local cid = user:getCurrentCharacter().id
	exports.oxmysql:execute('SELECT * FROM jobs_whitelist WHERE cid = ? AND job = "art_gallery"', {cid}, function(result)
		if result[1].job == 'art_gallery' and result[1].rank >= 3 then
				TriggerClientEvent('warp-duty:FireArt:Menu', src)
			end
		end)
end)

-- PDM

RegisterCommand('hirepdm', function(source, args)
	local src = source
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local cid = user:getCurrentCharacter().id
	exports.oxmysql:execute('SELECT * FROM jobs_whitelist WHERE cid = ? AND job = "pdm"', {cid}, function(result)
		if result[1].job == 'pdm' and result[1].rank >= 3 then
				TriggerClientEvent('warp-duty:HirePDM:Menu', src)
			end
		end)
end)

RegisterCommand('firepdm', function(source, args)
	local src = source
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local cid = user:getCurrentCharacter().id
	exports.oxmysql:execute('SELECT * FROM jobs_whitelist WHERE cid = ? AND job = "pdm"', {cid}, function(result)
		if result[1].job == 'pdm' and result[1].rank >= 3 then
				TriggerClientEvent('warp-duty:FirePDM:Menu', src)
			end
		end)
end)

-- Cosmic Cannabis

RegisterCommand('hirecosmic', function(source, args)
	local src = source
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local cid = user:getCurrentCharacter().id
	exports.oxmysql:execute('SELECT * FROM jobs_whitelist WHERE cid = ? AND job = "cosmic_cannabis"', {cid}, function(result)
		if result[1].job == 'cosmic_cannabis' and result[1].rank >= 3 then
				TriggerClientEvent('warp-duty:HireCosmic:Menu', src)
			end
		end)
end)

RegisterCommand('firecosmic', function(source, args)
	local src = source
	local user = exports["warp-base"]:getModule("Player"):GetUser(src)
	local cid = user:getCurrentCharacter().id
	exports.oxmysql:execute('SELECT * FROM jobs_whitelist WHERE cid = ? AND job = "cosmic_cannabis"', {cid}, function(result)
		if result[1].job == 'cosmic_cannabis' and result[1].rank >= 3 then
				TriggerClientEvent('warp-duty:FireCosmic:Menu', src)
			end
		end)
end)