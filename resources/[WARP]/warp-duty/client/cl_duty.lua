-- Police Duty --

local PDService = false
local SASPService = false
local BCSOService = false
local DOCService = false

RegisterNetEvent('warp-duty:PoliceMenu')
AddEventHandler('warp-duty:PoliceMenu', function()

	local menuData = {
		{
            title = "State Police",
            description = "Sign On/Off Duty",
            key = "EVENTS.SASP",
			children = {
				{ title = "Sign On Duty", action = "warp-duty:OnDutyHP", key = "EVENTS.SASP" },
				{ title = "Sign Off Duty", action = "warp-duty:OffDutyHP", key = "EVENTS.SASP" },
            },
        },
        {
            title = "Police",
            description = "Sign On/Off Duty",
            key = "EVENTS.POLICE",
			children = {
				{ title = "Sign On Duty", action = "warp-duty:OnDutyPD", key = "EVENTS.POLICE" },
				{ title = "Sign Off Duty", action = "warp-duty:OffDutyPD", key = "EVENTS.POLICE" },
            },
        },
        {
            title = "Sheriff",
            description = "Sign On/Off Duty",
            key = "EVENTS.SHERIFF",
			children = {
				{ title = "Sign On Duty", action = "warp-duty:OnDutySH", key = "EVENTS.SHERIFF" },
				{ title = "Sign Off Duty", action = "warp-duty:OffDutySH", key = "EVENTS.SHERIFF" },
            },
        },
		{
            title = "DOC",
            description = "Sign On/Off Duty",
            key = "EVENTS.DOC",
			children = {
				{ title = "Sign On Duty", action = "warp-duty:OnDutyDOC", key = "EVENTS.DOC" },
				{ title = "Sign Off Duty", action = "warp-duty:OffDutyDOC", key = "EVENTS.DOC" },
            },
        },
    }
    exports["warp-ui"]:showContextMenu(menuData)
end)

RegisterUICallback("warp-duty:OnDutyPD", function(data, cb)
	cb({ data = {}, meta = { ok = true, message = 'done' } })
	exports["warp-ui"]:hideContextMenu()
	if PDService == false then
		TriggerServerEvent('warp-duty:AttemptDuty', 'police')
		TriggerEvent('warp-clothing:inService', true)
		TriggerServerEvent('dispatch:setcallsign')
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

RegisterUICallback("warp-duty:OffDutyPD", function(data, cb)
	cb({ data = {}, meta = { ok = true, message = 'done' } })
	exports["warp-ui"]:hideContextMenu()
	if PDService == true then
		PDService = false
		TriggerEvent('warp-clothing:inService', false)
		exports['warp-voice']:removePlayerFromRadio()
		exports["warp-voice"]:setVoiceProperty("radioEnabled", false)
		TriggerEvent('radio:SetRadioStatus', false)
		TriggerServerEvent("jobssystem:jobs", "unemployed")
		TriggerServerEvent('myskin_customization:wearSkin')
		TriggerServerEvent('tattoos:retrieve')
		TriggerServerEvent('Blemishes:retrieve')
		TriggerEvent("police:noLongerCop")
		TriggerEvent("logoffmedic")		
		TriggerEvent("loggedoff")					
		TriggerEvent('nowCopSpawnOff')
		TriggerEvent('nowMedicOff')
		SetPedRelationshipGroupHash(PlayerPedId(),`PLAYER`)
		SetPedRelationshipGroupDefaultHash(PlayerPedId(),`PLAYER`)
		SetPoliceIgnorePlayer(PlayerPedId(),false)
		TriggerServerEvent('warp-duty:OffDutyComplete', 'police')
		TriggerEvent("DoLongHudText",'Signed off Duty!',1)
	else
		TriggerEvent("DoLongHudText",'You wasnt on duty!', 2)
	end
end)

-- Sheriff

RegisterUICallback("warp-duty:OnDutySH", function(data, cb)
	cb({ data = {}, meta = { ok = true, message = 'done' } })
	exports["warp-ui"]:hideContextMenu()
	if BCSOService == false then
		TriggerServerEvent('warp-duty:AttemptDuty', 'sheriff')
		TriggerEvent('warp-clothing:inService', true)
		TriggerServerEvent('dispatch:setcallsign')
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

RegisterUICallback("warp-duty:OffDutySH", function(data, cb)
	cb({ data = {}, meta = { ok = true, message = 'done' } })
	exports["warp-ui"]:hideContextMenu()
	if BCSOService == true then
		BCSOService = false
		TriggerEvent('warp-clothing:inService', false)
		exports['warp-voice']:removePlayerFromRadio()
		exports["warp-voice"]:setVoiceProperty("radioEnabled", false)
		TriggerEvent('radio:SetRadioStatus', false)
		TriggerServerEvent("jobssystem:jobs", "unemployed")
		TriggerServerEvent('myskin_customization:wearSkin')
		TriggerServerEvent('tattoos:retrieve')
		TriggerServerEvent('Blemishes:retrieve')
		TriggerEvent("police:noLongerCop")
		TriggerEvent("logoffmedic")		
		TriggerEvent("loggedoff")					
		TriggerEvent('nowCopSpawnOff')
		TriggerEvent('nowMedicOff')
		SetPedRelationshipGroupHash(PlayerPedId(),`PLAYER`)
		SetPedRelationshipGroupDefaultHash(PlayerPedId(),`PLAYER`)
		SetPoliceIgnorePlayer(PlayerPedId(),false)
		TriggerServerEvent('warp-duty:OffDutyComplete', 'sheriff')
		TriggerEvent("DoLongHudText",'Signed off Duty!',1)
	else
		TriggerEvent("DoLongHudText",'You wasnt on duty!', 2)
	end
end)

-- State

RegisterUICallback("warp-duty:OnDutyHP", function(data, cb)
	cb({ data = {}, meta = { ok = true, message = 'done' } })
	exports["warp-ui"]:hideContextMenu()
	if SASPService == false then
		TriggerServerEvent('warp-duty:AttemptDuty', 'state')
		TriggerEvent('warp-clothing:inService', true)
		TriggerServerEvent('dispatch:setcallsign')
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

RegisterUICallback("warp-duty:OffDutyHP", function(data, cb)
	cb({ data = {}, meta = { ok = true, message = 'done' } })
	exports["warp-ui"]:hideContextMenu()
	if SASPService == true then
		SASPService = false
		TriggerEvent('warp-clothing:inService', false)
		exports['warp-voice']:removePlayerFromRadio()
		exports["warp-voice"]:setVoiceProperty("radioEnabled", false)
		TriggerEvent('radio:SetRadioStatus', false)
		TriggerServerEvent("jobssystem:jobs", "unemployed")
		TriggerServerEvent('myskin_customization:wearSkin')
		TriggerServerEvent('tattoos:retrieve')
		TriggerServerEvent('Blemishes:retrieve')
		TriggerEvent("police:noLongerCop")
		TriggerEvent("logoffmedic")		
		TriggerEvent("loggedoff")					
		TriggerEvent('nowCopSpawnOff')
		TriggerEvent('nowMedicOff')
		SetPedRelationshipGroupHash(PlayerPedId(),`PLAYER`)
		SetPedRelationshipGroupDefaultHash(PlayerPedId(),`PLAYER`)
		SetPoliceIgnorePlayer(PlayerPedId(),false)
		TriggerServerEvent('warp-duty:OffDutyComplete', 'state')
		TriggerEvent("DoLongHudText",'Signed off Duty!',1)
	else
		TriggerEvent("DoLongHudText",'You wasnt on duty!', 2)
	end
end)

-- DOC

RegisterUICallback("warp-duty:OnDutyDOC", function(data, cb)
	cb({ data = {}, meta = { ok = true, message = 'done' } })
	exports["warp-ui"]:hideContextMenu()
	if DOCService == false then
		TriggerServerEvent('warp-duty:AttemptDuty', 'doc')
		TriggerEvent('warp-clothing:inService', true)
		TriggerServerEvent('dispatch:setcallsign')
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

RegisterUICallback("warp-duty:OffDutyDOC", function(data, cb)
	cb({ data = {}, meta = { ok = true, message = 'done' } })
	exports["warp-ui"]:hideContextMenu()
	if DOCService == true then
		DOCService = false
		TriggerEvent('warp-clothing:inService', false)
		exports['warp-voice']:removePlayerFromRadio()
		exports["warp-voice"]:setVoiceProperty("radioEnabled", false)
		TriggerEvent('radio:SetRadioStatus', false)
		TriggerServerEvent("jobssystem:jobs", "unemployed")
		TriggerServerEvent('myskin_customization:wearSkin')
		TriggerServerEvent('tattoos:retrieve')
		TriggerServerEvent('Blemishes:retrieve')
		TriggerEvent("police:noLongerCop")
		TriggerEvent("logoffmedic")		
		TriggerEvent("loggedoff")					
		TriggerEvent('nowCopSpawnOff')
		TriggerEvent('nowMedicOff')
		SetPedRelationshipGroupHash(PlayerPedId(),`PLAYER`)
		SetPedRelationshipGroupDefaultHash(PlayerPedId(),`PLAYER`)
		SetPoliceIgnorePlayer(PlayerPedId(),false)
		TriggerServerEvent('warp-duty:OffDutyComplete', 'doc')
		TriggerEvent("DoLongHudText",'Signed off Duty!',1)
	else
		TriggerEvent("DoLongHudText",'You wasnt on duty!', 2)
	end
end)

RegisterNetEvent('warp-duty:PDSuccess')
AddEventHandler('warp-duty:PDSuccess', function()
	if PDService == false then
		exports["warp-voice"]:setVoiceProperty("radioEnabled", true)
		exports['warp-voice']:addPlayerToRadio(1)
		TriggerEvent('radio:SetRadioStatus', true)
		PDService = true
		TriggerEvent('nowCop')
		TriggerEvent('nowService')
		TriggerEvent('nowCopHud')
		TriggerEvent('nowCopDeath')
		TriggerEvent('nowCopSpawn')
		TriggerEvent('nowMedic')
		SetPedRelationshipGroupDefaultHash(PlayerPedId(),`MISSION2`)
		SetPedRelationshipGroupHash(PlayerPedId(),`MISSION2`)
		SetPoliceIgnorePlayer(PlayerPedId(),true)
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

RegisterNetEvent('warp-duty:BCSOSuccess')
AddEventHandler('warp-duty:BCSOSuccess', function()
	if BCSOService == false then
		exports["warp-voice"]:setVoiceProperty("radioEnabled", true)
		exports['warp-voice']:addPlayerToRadio(1)
		TriggerEvent('radio:SetRadioStatus', true)
		BCSOService = true
		TriggerEvent('nowCop')
		TriggerEvent('nowService')
		TriggerEvent('nowCopHud')
		TriggerEvent('nowCopDeath')
		TriggerEvent('nowCopSpawn')
		TriggerEvent('nowMedic')
		SetPedRelationshipGroupDefaultHash(PlayerPedId(),`MISSION2`)
		SetPedRelationshipGroupHash(PlayerPedId(),`MISSION2`)
		SetPoliceIgnorePlayer(PlayerPedId(),true)
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

RegisterNetEvent('warp-duty:SASPSuccess')
AddEventHandler('warp-duty:SASPSuccess', function()
	if SASPService == false then
		exports["warp-voice"]:setVoiceProperty("radioEnabled", true)
		exports['warp-voice']:addPlayerToRadio(1)
		TriggerEvent('radio:SetRadioStatus', true)
		SASPService = true
		TriggerEvent('nowCop')
		TriggerEvent('nowService')
		TriggerEvent('nowCopHud')
		TriggerEvent('nowCopDeath')
		TriggerEvent('nowCopSpawn')
		TriggerEvent('nowMedic')
		SetPedRelationshipGroupDefaultHash(PlayerPedId(),`MISSION2`)
		SetPedRelationshipGroupHash(PlayerPedId(),`MISSION2`)
		SetPoliceIgnorePlayer(PlayerPedId(),true)
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

RegisterNetEvent('warp-duty:DOCSuccess')
AddEventHandler('warp-duty:DOCSuccess', function()
	if DOCService == false then
		exports["warp-voice"]:setVoiceProperty("radioEnabled", true)
		exports['warp-voice']:addPlayerToRadio(3)
		TriggerEvent('radio:SetRadioStatus', true)
		DOCService = true
		TriggerEvent('nowCop')
		TriggerEvent('nowService')
		TriggerEvent('nowCopHud')
		TriggerEvent('nowCopDeath')
		TriggerEvent('nowCopSpawn')
		TriggerEvent('nowMedic')
		SetPedRelationshipGroupDefaultHash(PlayerPedId(),`MISSION2`)
		SetPedRelationshipGroupHash(PlayerPedId(),`MISSION2`)
		SetPoliceIgnorePlayer(PlayerPedId(),true)
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

-- EMS Duty --

local EMSService = false

RegisterNetEvent('warp-duty:EMSMenu')
AddEventHandler('warp-duty:EMSMenu', function()
	TriggerEvent('warp-context:sendMenu', {
        {
            id = 1,
            header = "Sign In / Off ",
            txt = ""
        },
        {
            id = 2,
            header = "Signing On Duty",
			txt = "Use this to sign in",
			params = {
                event = "warp-duty:OnDutyEMS"
            }
        },
		{
            id = 3,
            header = "Signing Off Duty",
			txt = "Use this to sign off",
			params = {
                event = "warp-duty:OffDutyEMS"
            }
        },
    })
end)

RegisterNetEvent('warp-duty:OnDutyEMS')
AddEventHandler('warp-duty:OnDutyEMS', function()
	if EMSService == false then
		TriggerServerEvent('warp-duty:AttemptDutyEMS')
		TriggerEvent('warp-clothing:inService', true)
		TriggerServerEvent('dispatch:setcallsign')
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

RegisterNetEvent('warp-duty:OffDutyEMS')
AddEventHandler('warp-duty:OffDutyEMS', function()
	if EMSService == true then
		EMSService = false
		TriggerEvent('warp-clothing:inService', false)
		exports['warp-voice']:removePlayerFromRadio()
		exports["warp-voice"]:setVoiceProperty("radioEnabled", false)
		TriggerEvent('radio:SetRadioStatus', false)
		TriggerServerEvent("jobssystem:jobs", "unemployed")
		TriggerServerEvent('myskin_customization:wearSkin')
		TriggerServerEvent('tattoos:retrieve')
		TriggerServerEvent('Blemishes:retrieve')
		TriggerEvent("logoffmedic")		
		TriggerEvent("loggedoff")					
		TriggerEvent('nowCopSpawnOff')
		TriggerEvent('nowMedicOff')
		SetPedRelationshipGroupHash(PlayerPedId(),`PLAYER`)
		SetPedRelationshipGroupDefaultHash(PlayerPedId(),`PLAYER`)
		SetPoliceIgnorePlayer(PlayerPedId(),false)
		TriggerServerEvent('warp-duty:OffDutyCompleteEMS')
		TriggerEvent("DoLongHudText",'Signed off Duty!',1)
	else
		TriggerEvent("DoLongHudText",'You are not on duty!', 2)
	end
end)

RegisterNetEvent('warp-duty:EMSSuccess')
AddEventHandler('warp-duty:EMSSuccess', function()
	if EMSService == false then
		exports["warp-voice"]:setVoiceProperty("radioEnabled", true)
		exports['warp-voice']:addPlayerToRadio(2)
		TriggerEvent('radio:SetRadioStatus', true)
		EMSService = true
		TriggerEvent('nowCop')
		TriggerEvent('nowService')
		TriggerEvent('nowCopHud')
		TriggerEvent('nowCopDeath')
		TriggerEvent('nowCopSpawn')
		TriggerEvent('nowMedic')
		SetPedRelationshipGroupDefaultHash(PlayerPedId(),`MISSION2`)
		SetPedRelationshipGroupHash(PlayerPedId(),`MISSION2`)
		SetPoliceIgnorePlayer(PlayerPedId(),true)
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

-- Suits Duty ----------------------------------------------------------------

local SuitsService = false

RegisterNetEvent('warp-duty:SuitsMenu')
AddEventHandler('warp-duty:SuitsMenu', function()
	TriggerEvent('warp-context:sendMenu', {
        {
            id = 1,
            header = "Sign In / Off ",
            txt = ""
        },
        {
            id = 2,
            header = "Signing On Duty",
			txt = "Use this to sign in",
			params = {
                event = "warp-duty:OnDutySuits"
            }
        },
		{
            id = 3,
            header = "Signing Off Duty",
			txt = "Use this to sign off",
			params = {
                event = "warp-duty:OffDutySuits"
            }
        },
    })
end)

RegisterNetEvent('warp-duty:OnDutySuits')
AddEventHandler('warp-duty:OnDutySuits', function()
	if SuitsService == false then
		TriggerServerEvent('warp-duty:AttemptDutySuits')
		TriggerEvent('warp-clothing:inService', true)
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

RegisterNetEvent('warp-duty:OffDutySuits')
AddEventHandler('warp-duty:OffDutySuits', function()
	if SuitsService == true then
		SuitsService = false
		TriggerEvent('warp-clothing:inService', false)
		TriggerServerEvent("jobssystem:jobs", "unemployed")
		TriggerServerEvent('myskin_customization:wearSkin')
		TriggerServerEvent('tattoos:retrieve')
		TriggerServerEvent('Blemishes:retrieve')
		TriggerEvent("logoffmedic")		
		TriggerEvent("loggedoff")					
		TriggerEvent('nowCopSpawnOff')
		TriggerEvent('nowMedicOff')
		SetPedRelationshipGroupHash(PlayerPedId(),`PLAYER`)
		SetPedRelationshipGroupDefaultHash(PlayerPedId(),`PLAYER`)
		SetPoliceIgnorePlayer(PlayerPedId(),false)
		TriggerServerEvent('warp-duty:OffDutyCompleteSuits')
		TriggerEvent("DoLongHudText",'Signed off Duty!',1)
	else
		TriggerEvent("DoLongHudText",'You are not on duty!', 2)
	end
end)

RegisterNetEvent('warp-duty:SuitsSuccess')
AddEventHandler('warp-duty:SuitsSuccess', function()
	if SuitsService == false then
		SuitsService = true
		TriggerEvent('nowCop')
		TriggerEvent('nowService')
		TriggerEvent('nowCopHud')
		TriggerEvent('nowCopDeath')
		TriggerEvent('nowCopSpawn')
		TriggerEvent('nowMedic')
		SetPedRelationshipGroupDefaultHash(PlayerPedId(),`MISSION2`)
		SetPedRelationshipGroupHash(PlayerPedId(),`MISSION2`)
		SetPoliceIgnorePlayer(PlayerPedId(),true)
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

-- Judge Duty ------------------------------------------------------------

local JudgeService = false

RegisterNetEvent('warp-duty:JudgeMenu')
AddEventHandler('warp-duty:JudgeMenu', function()
	TriggerEvent('warp-context:sendMenu', {
        {
            id = 1,
            header = "Sign In / Off ",
            txt = ""
        },
        {
            id = 2,
            header = "Signing On Duty",
			txt = "Use this to sign in",
			params = {
                event = "warp-duty:OnDutyJudge"
            }
        },
		{
            id = 3,
            header = "Signing Off Duty",
			txt = "Use this to sign off",
			params = {
                event = "warp-duty:OffDutyJudge"
            }
        },
    })
end)

RegisterNetEvent('warp-duty:OnDutyJudge')
AddEventHandler('warp-duty:OnDutyJudge', function()
	if JudgeService == false then
		TriggerServerEvent('warp-duty:AttemptDutyJudge')
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

RegisterNetEvent('warp-duty:OffDutyJudge')
AddEventHandler('warp-duty:OffDutyJudge', function()
	if JudgeService == true then
		JudgeService = false
		TriggerServerEvent('warp-duty:OffDutyCompleteEMS')
		TriggerServerEvent("jobssystem:jobs", "unemployed")
		TriggerEvent("DoLongHudText",'Signed off Duty!',1)
	else
		TriggerEvent("DoLongHudText",'You are not on duty!', 2)
	end
end)

RegisterNetEvent('warp-duty:JudgeSuccess')
AddEventHandler('warp-duty:JudgeSuccess', function()
	if JudgeService == false then
		JudgeService = true
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

-- DA Duty --

local DAService = false

RegisterNetEvent('warp-duty:DAMenu')
AddEventHandler('warp-duty:DAMenu', function()
	TriggerEvent('warp-context:sendMenu', {
        {
            id = 1,
            header = "Sign In / Off ",
            txt = ""
        },
        {
            id = 2,
            header = "Signing On Duty",
			txt = "Use this to sign in",
			params = {
                event = "warp-duty:OnDutyDA"
            }
        },
		{
            id = 3,
            header = "Signing Off Duty",
			txt = "Use this to sign off",
			params = {
                event = "warp-duty:OffDutyDA"
            }
        },
    })
end)

RegisterNetEvent('warp-duty:OnDutyDA')
AddEventHandler('warp-duty:OnDutyDA', function()
	if DAService == false then
		TriggerServerEvent('warp-duty:AttemptDutyDA')
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

RegisterNetEvent('warp-duty:OffDutyDA')
AddEventHandler('warp-duty:OffDutyDA', function()
	if DAService == true then
		DAService = false
		TriggerServerEvent("jobssystem:jobs", "unemployed")
		TriggerEvent("DoLongHudText",'Signed off Duty!',1)
	else
		TriggerEvent("DoLongHudText",'You are not on duty!', 2)
	end
end)

RegisterNetEvent('warp-duty:DASuccess')
AddEventHandler('warp-duty:DASuccess', function()
	if DAService == false then
		DAService = true
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

-- Public Duty --

local PublicService = false

RegisterNetEvent('warp-duty:PublicMenu')
AddEventHandler('warp-duty:PublicMenu', function()
	TriggerEvent('warp-context:sendMenu', {
        {
            id = 1,
            header = "Sign In / Off ",
            txt = ""
        },
        {
            id = 2,
            header = "Signing On Duty",
			txt = "Use this to sign in",
			params = {
                event = "warp-duty:OnDutyPublic"
            }
        },
		{
            id = 3,
            header = "Signing Off Duty",
			txt = "Use this to sign off",
			params = {
                event = "warp-duty:OffDutyPublic"
            }
        },
    })
end)

RegisterNetEvent('warp-duty:OnDutyPublic')
AddEventHandler('warp-duty:OnDutyPublic', function()
	if PublicService == false then
		TriggerServerEvent('warp-duty:AttemptDutyPublic')
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

RegisterNetEvent('warp-duty:OffDutyPublic')
AddEventHandler('warp-duty:OffDutyPublic', function()
	if PublicService == true then
		PublicService = false
		TriggerServerEvent("jobssystem:jobs", "unemployed")
		TriggerEvent("DoLongHudText",'Signed off Duty!',1)
	else
		TriggerEvent("DoLongHudText",'You are not on duty!', 2)
	end
end)

RegisterNetEvent('warp-duty:PublicSuccess')
AddEventHandler('warp-duty:PublicSuccess', function()
	if PublicService == false then
		PublicService = true
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

-- ADA Duty --

local ADAService = false

RegisterNetEvent('warp-duty:ADAMenu')
AddEventHandler('warp-duty:ADAMenu', function()
	TriggerEvent('warp-context:sendMenu', {
        {
            id = 1,
            header = "Sign In / Off ",
            txt = ""
        },
        {
            id = 2,
            header = "Signing On Duty",
			txt = "Use this to sign in",
			params = {
                event = "warp-duty:OnDutyADA"
            }
        },
		{
            id = 3,
            header = "Signing Off Duty",
			txt = "Use this to sign off",
			params = {
                event = "warp-duty:OffDutyADA"
            }
        },
    })
end)

RegisterNetEvent('warp-duty:OnDutyADA')
AddEventHandler('warp-duty:OnDutyADA', function()
	if PublicService == false then
		TriggerServerEvent('warp-duty:AttemptDutyADA')
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

RegisterNetEvent('warp-duty:OffDutyADA')
AddEventHandler('warp-duty:OffDutyADA', function()
	if ADAService == true then
		ADAService = false
		TriggerServerEvent("jobssystem:jobs", "unemployed")
		TriggerEvent("DoLongHudText",'Signed off Duty!',1)
	else
		TriggerEvent("DoLongHudText",'You are not on duty!', 2)
	end
end)

RegisterNetEvent('warp-duty:ADASuccess')
AddEventHandler('warp-duty:ADASuccess', function()
	if ADAService == false then
		ADAService = true
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

-- PDM Duty --

local PDMService = false

RegisterNetEvent('warp-duty:PDMMenu')
AddEventHandler('warp-duty:PDMMenu', function()
	TriggerEvent('warp-context:sendMenu', {
        {
            id = 1,
            header = "Sign In / Off ",
            txt = ""
        },
        {
            id = 2,
            header = "Signing On Duty",
			txt = "Use this to sign in",
			params = {
                event = "warp-duty:OnDutyPDM"
            }
        },
		{
            id = 3,
            header = "Signing Off Duty",
			txt = "Use this to sign off",
			params = {
                event = "warp-duty:OffDutyPDM"
            }
        },
    })
end)

RegisterNetEvent('warp-duty:OnDutyPDM')
AddEventHandler('warp-duty:OnDutyPDM', function()
	if PDMService == false then
		TriggerServerEvent('warp-duty:AttemptDutyPDM')
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

RegisterNetEvent('warp-duty:OffDutyPDM')
AddEventHandler('warp-duty:OffDutyPDM', function()
	if PDMService == true then
		PDMService = false
		TriggerServerEvent("jobssystem:jobs", "unemployed")
		TriggerEvent("DoLongHudText",'Signed off Duty!',1)
	else
		TriggerEvent("DoLongHudText",'You are not on duty!', 2)
	end
end)

RegisterNetEvent('warp-duty:PDMSuccess')
AddEventHandler('warp-duty:PDMSuccess', function()
	if PDMService == false then
		PDMService = true
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

-- Sanders Duty --

local SandersService = false

RegisterNetEvent('warp-duty:SandersMenu')
AddEventHandler('warp-duty:SandersMenu', function()
	TriggerEvent('warp-context:sendMenu', {
        {
            id = 1,
            header = "Sign In / Off ",
            txt = ""
        },
        {
            id = 2,
            header = "Signing On Duty",
			txt = "Use this to sign in",
			params = {
                event = "warp-duty:OnDutySanders"
            }
        },
		{
            id = 3,
            header = "Signing Off Duty",
			txt = "Use this to sign off",
			params = {
                event = "warp-duty:OffDutySanders"
            }
        },
    })
end)

RegisterNetEvent('warp-duty:OnDutySanders')
AddEventHandler('warp-duty:OnDutySanders', function()
	if SandersService == false then
		TriggerServerEvent('warp-duty:AttemptDutySanders')
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

RegisterNetEvent('warp-duty:OffDutySanders')
AddEventHandler('warp-duty:OffDutySanders', function()
	if SandersService == true then
		SandersService = false
		TriggerServerEvent("jobssystem:jobs", "unemployed")
		TriggerEvent("DoLongHudText",'Signed off Duty!',1)
	else
		TriggerEvent("DoLongHudText",'You are not on duty!', 2)
	end
end)

RegisterNetEvent('warp-duty:SandersSuccess')
AddEventHandler('warp-duty:SandersSuccess', function()
	if SandersService == false then
		SandersService = true
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

-- Sanders Duty --

local TowService = false

RegisterNetEvent('warp-duty:TowMenu')
AddEventHandler('warp-duty:TowMenu', function()
	TriggerEvent('warp-context:sendMenu', {
        {
            id = 1,
            header = "Sign In / Off ",
            txt = ""
        },
        {
            id = 2,
            header = "Signing On Duty",
			txt = "Use this to sign in",
			params = {
                event = "warp-duty:OnDutyTow"
            }
        },
		{
            id = 3,
            header = "Signing Off Duty",
			txt = "Use this to sign off",
			params = {
                event = "warp-duty:OffDutyTow"
            }
        },
    })
end)

RegisterNetEvent('warp-duty:OnDutyTow')
AddEventHandler('warp-duty:OnDutyTow', function()
	if TowService == false then
		TriggerServerEvent('warp-duty:AttemptDutyTow')
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

RegisterNetEvent('warp-duty:OffDutyTow')
AddEventHandler('warp-duty:OffDutyTow', function()
	if TowService == true then
		TowService = false
		TriggerServerEvent("jobssystem:jobs", "unemployed")
		TriggerEvent("DoLongHudText",'Signed off Duty!',1)
	else
		TriggerEvent("DoLongHudText",'You are not on duty!', 2)
	end
end)

RegisterNetEvent('warp-duty:TowSuccess')
AddEventHandler('warp-duty:TowSuccess', function()
	if TowService == false then
		TowService = true
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

 -- Start of Burgershot Duty
local ClockedinBurger = false

RegisterNetEvent('warp-duty:BurgerMenu')
AddEventHandler('warp-duty:BurgerMenu', function()
	TriggerEvent('warp-context:sendMenu', {
        {
            id = 1,
            header = "Sign In / Off ",
            txt = ""
        },
        {
            id = 2,
            header = "Signing On Duty",
			txt = "Use this to sign in",
			params = {
                event = "warp-duty:OnDutyBurger"
            }
        },
		{
            id = 3,
            header = "Signing Off Duty",
			txt = "Use this to sign off",
			params = {
                event = "warp-duty:OffDutyBurger"
            }
        },
    })
end)

RegisterNetEvent('warp-duty:OnDutyBurger')
AddEventHandler('warp-duty:OnDutyBurger', function()
	if ClockedinBurger == false then
		TriggerServerEvent('warp-duty:AttemptDutyBurger')
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

RegisterNetEvent('warp-duty:OffDutyBurger')
AddEventHandler('warp-duty:OffDutyBurger', function()
	if ClockedinBurger == true then
		ClockedinBurger = false
		TriggerServerEvent("jobssystem:jobs", "unemployed")
		TriggerEvent("DoLongHudText",'Signed off Duty!',1)
	else
		TriggerEvent("DoLongHudText",'You are not on duty!', 2)
	end
end)

RegisterNetEvent('warp-duty:BurgerSuccess')
AddEventHandler('warp-duty:BurgerSuccess', function()
	if ClockedinBurger == false then
		ClockedinBurger = true
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)
	-- End of Burgershot Duty

	 -- Start of ArtGallery Duty
local ClockedinArt = false

RegisterNetEvent('warp-duty:ArtMenu')
AddEventHandler('warp-duty:ArtMenu', function()
	TriggerEvent('warp-context:sendMenu', {
        {
            id = 1,
            header = "Sign In / Off ",
            txt = ""
        },
        {
            id = 2,
            header = "Signing On Duty",
			txt = "Use this to sign in",
			params = {
                event = "warp-duty:OnDutyArt"
            }
        },
		{
            id = 3,
            header = "Signing Off Duty",
			txt = "Use this to sign off",
			params = {
                event = "warp-duty:OffDutyArt"
            }
        },
    })
end)

RegisterNetEvent('warp-duty:OnDutyArt')
AddEventHandler('warp-duty:OnDutyArt', function()
	if ClockedinArt == false then
		TriggerServerEvent('warp-duty:AttemptDutyArt')
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

RegisterNetEvent('warp-duty:OffDutyArt')
AddEventHandler('warp-duty:OffDutyArt', function()
	if ClockedinArt == true then
		ClockedinArt = false
		TriggerServerEvent("jobssystem:jobs", "unemployed")
		TriggerEvent("DoLongHudText",'Signed off Duty!',1)
	else
		TriggerEvent("DoLongHudText",'You are not on duty!', 2)
	end
end)

RegisterNetEvent('warp-duty:ArtSuccess')
AddEventHandler('warp-duty:ArtSuccess', function()
	if ClockedinArt == false then
		ClockedinArt = true
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)
	-- End of ArtGallery Duty

	 -- Start of PDM Duty
local ClockedinPDM = false

RegisterNetEvent('warp-duty:PDMMenu')
AddEventHandler('warp-duty:PDMMenu', function()
	TriggerEvent('warp-context:sendMenu', {
        {
            id = 1,
            header = "Sign In / Off ",
            txt = ""
        },
        {
            id = 2,
            header = "Signing On Duty",
			txt = "Use this to sign in",
			params = {
                event = "warp-duty:OnDutyPDM"
            }
        },
		{
            id = 3,
            header = "Signing Off Duty",
			txt = "Use this to sign off",
			params = {
                event = "warp-duty:OffDutyPDM"
            }
        },
    })
end)

RegisterNetEvent('warp-duty:OnDutyPDM')
AddEventHandler('warp-duty:OnDutyPDM', function()
	if ClockedinPDM == false then
		TriggerServerEvent('warp-duty:AttemptDutyPDM')
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

RegisterNetEvent('warp-duty:OffDutyPDM')
AddEventHandler('warp-duty:OffDutyPDM', function()
	if ClockedinPDM == true then
		ClockedinPDM = false
		TriggerServerEvent("jobssystem:jobs", "unemployed")
		TriggerEvent("DoLongHudText",'Signed off Duty!',1)
	else
		TriggerEvent("DoLongHudText",'You are not on duty!', 2)
	end
end)

RegisterNetEvent('warp-duty:PDMSuccess')
AddEventHandler('warp-duty:PDMSuccess', function()
	if ClockedinPDM == false then
		ClockedinPDM = true
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)
	-- End of PDM Duty

	-- Start of Cosmic Cannabis Duty
local ClockedinCosmic = false

RegisterNetEvent('warp-duty:CosmicMenu')
AddEventHandler('warp-duty:CosmicMenu', function()
	TriggerEvent('warp-context:sendMenu', {
        {
            id = 1,
            header = "Sign In / Off ",
            txt = ""
        },
        {
            id = 2,
            header = "Signing On Duty",
			txt = "Use this to sign in",
			params = {
                event = "warp-duty:OnDutyCosmic"
            }
        },
		{
            id = 3,
            header = "Signing Off Duty",
			txt = "Use this to sign off",
			params = {
                event = "warp-duty:OffDutyCosmic"
            }
        },
    })
end)

RegisterNetEvent('warp-duty:OnDutyCosmic')
AddEventHandler('warp-duty:OnDutyCosmic', function()
	if ClockedinCosmic == false then
		TriggerServerEvent('warp-duty:AttemptDutyCosmic')
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

RegisterNetEvent('warp-duty:OffDutyCosmic')
AddEventHandler('warp-duty:OffDutyCosmic', function()
	if ClockedinCosmic == true then
		ClockedinCosmic = false
		TriggerServerEvent("jobssystem:jobs", "unemployed")
		TriggerEvent("DoLongHudText",'Signed off Duty!',1)
	else
		TriggerEvent("DoLongHudText",'You are not on duty!', 2)
	end
end)

RegisterNetEvent('warp-duty:CosmicSuccess')
AddEventHandler('warp-duty:CosmicSuccess', function()
	if ClockedinCosmic == false then
		ClockedinCosmic = true
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)
	-- End of Cosmic Cannabis Duty

RegisterCommand('pdduty', function()
	TriggerEvent('warp-duty:OnDuty')
end)
RegisterCommand('pddutyoff', function()
	TriggerEvent('warp-duty:OffDuty')
end)

-- In N Out Duty --

local ClockedOnAsInNOut = false

RegisterNetEvent('warp-duty:in-n-out:clockin')
AddEventHandler('warp-duty:in-n-out:clockin', function()
	TriggerEvent('warp-context:sendMenu', {
        {
            id = 1,
            header = "Sign In / Off ",
            txt = ""
        },
        {
            id = 2,
            header = "Signing On Duty",
			txt = "Use this to sign in",
			params = {
                event = "warp-duty:on-in-n-out"
            }
        },
		{
            id = 3,
            header = "Signing Off Duty",
			txt = "Use this to sign off",
			params = {
                event = "warp-duty:off-duty-in-n-out"
            }
        },
    })
end)

RegisterNetEvent('warp-duty:on-in-n-out')
AddEventHandler('warp-duty:on-in-n-out', function()
	if ClockedOnAsInNOut == false then
		TriggerServerEvent('warp-duty:attempt-in-n-out:duty')
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

RegisterNetEvent('warp-duty:off-duty-in-n-out')
AddEventHandler('warp-duty:off-duty-in-n-out', function()
	if ClockedOnAsInNOut == true then
		ClockedOnAsInNOut = false
		TriggerServerEvent("jobssystem:jobs", "unemployed")
		TriggerEvent("DoLongHudText",'Signed off Duty!',1)
	else
		TriggerEvent("DoLongHudText",'You are not on duty!', 2)
	end
end)

RegisterNetEvent('warp-duty:in-n-out:successful')
AddEventHandler('warp-duty:in-n-out:successful', function()
	if ClockedOnAsInNOut == false then
		ClockedOnAsInNOut = true
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

-- Burger Shot clockin shit

local ClockedOnAsBurger = false

RegisterNetEvent('warp-duty:Burger:clockin')
AddEventHandler('warp-duty:Burger:clockin', function()
	TriggerEvent('warp-context:sendMenu', {
        {
            id = 1,
            header = "Sign In / Off ",
            txt = ""
        },
        {
            id = 2,
            header = "Signing On Duty",
			txt = "Use this to sign in",
			params = {
                event = "warp-duty:on-Burger"
            }
        },
		{
            id = 3,
            header = "Signing Off Duty",
			txt = "Use this to sign off",
			params = {
                event = "warp-duty:off-duty-Burger"
            }
        },
    })
end)

RegisterNetEvent('warp-duty:on-Burger')
AddEventHandler('warp-duty:on-Burger', function()
	if ClockedOnAsBurger == false then
		TriggerServerEvent('warp-duty:attempt-Burger:duty')
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

RegisterNetEvent('warp-duty:off-duty-Burger')
AddEventHandler('warp-duty:off-duty-Burger', function()
	if ClockedOnAsBurger == true then
		ClockedOnAsBurger = false
		TriggerServerEvent("jobssystem:jobs", "unemployed")
		TriggerEvent("DoLongHudText",'Signed off Duty!',1)
	else
		TriggerEvent("DoLongHudText",'You are not on duty!', 2)
	end
end)

RegisterNetEvent('warp-duty:burger:successful')
AddEventHandler('warp-duty:burger:successful', function()
	if ClockedOnAsBurger == false then
		ClockedOnAsBurger = true
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

curPolice = 0

RegisterNetEvent('job:policecount')
AddEventHandler('job:policecount', function(pAmount)
	curPolice = pAmount
end)

function LawAmount()
	return curPolice
end

-- DOJ Duty --

local ClockedInAsJudge = false

local ClockedInAsPublicDefender = false

local ClockedInAsDistrictAttorney = false

RegisterNetEvent('warp-duty:doj_board')
AddEventHandler('warp-duty:doj_board', function()
	TriggerEvent('warp-context:sendMenu', {
        {
            id = 1,
            header = "DOJ Duty Board",
            txt = ""
        },
        {
            id = 2,
            header = "Judge Duty",
			txt = "Use this to sign in as a judge !",
			params = {
                event = "warp-duty:clock_in:judge_context"
            }
        },
		{
            id = 3,
            header = "Public Defender Duty",
			txt = "Use this to sign in as a Public Defender",
			params = {
				event = "warp-duty:clock_in:public_defender_context"
            }
        },
		{
            id = 4,
            header = "District Attorney Duty",
			txt = "Use this to sign in as a District Attorney",
			params = {
				event = "warp-duty:clock_in:district_attorney_context"
            }
        },
    })
end)

-- Judge --

RegisterNetEvent('warp-duty:clock_in:judge_context')
AddEventHandler('warp-duty:clock_in:judge_context', function()
	TriggerEvent('warp-context:sendMenu', {
		{
            id = 1,
            header = "< Go Back",
			txt = "",
			params = {
                event = "warp-duty:doj_board"
            }
        },
        {
            id = 2,
            header = "Sign In",
			txt = "",
			params = {
                event = "warp-duty:clock_in:judge"
            }
        },
		{
            id = 3,
            header = "Sign Out",
			txt = "",
			params = {
				event = "warp-duty:clock_out:judge"
            }
        },
    })
end)

RegisterNetEvent('warp-duty:clock_in:judge')
AddEventHandler('warp-duty:clock_in:judge', function()
	if ClockedInAsJudge == false then
		TriggerServerEvent('warp-duty:attempt_duty:judge')
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

RegisterNetEvent('warp-duty:clock_out:judge')
AddEventHandler('warp-duty:clock_out:judge', function()
	if ClockedInAsJudge == true then
		ClockedInAsJudge = false
		TriggerServerEvent("jobssystem:jobs", "unemployed")
		TriggerEvent("DoLongHudText",'Signed out. You are no longer a Judge', 2)
	else
		TriggerEvent("DoLongHudText",'You was never clocked in as a Judge', 2)
	end
end)

RegisterNetEvent('warp-duty:clocked_in:judge_successful')
AddEventHandler('warp-duty:clocked_in:judge_successful', function()
	if ClockedInAsJudge == false then
		ClockedInAsJudge = true
	else
		TriggerEvent("DoLongHudText",'You are already clocked in as a Judge', 2)
	end
end)

-- Public Defender --

RegisterNetEvent('warp-duty:clock_in:public_defender_context')
AddEventHandler('warp-duty:clock_in:public_defender_context', function()
	TriggerEvent('warp-context:sendMenu', {
		{
            id = 1,
            header = "< Go Back",
			txt = "",
			params = {
                event = "warp-duty:doj_board"
            }
        },
        {
            id = 2,
            header = "Sign In",
			txt = "",
			params = {
                event = "warp-duty:clock_in:public_defender"
            }
        },
		{
            id = 3,
            header = "Sign Out",
			txt = "",
			params = {
				event = "warp-duty:clock_out:public_defender"
            }
        },
    })
end)

RegisterNetEvent('warp-duty:clock_in:public_defender')
AddEventHandler('warp-duty:clock_in:public_defender', function()
	if ClockedInAsPublicDefender == false then
		TriggerServerEvent('warp-duty:attempt_duty:public_defender')
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

RegisterNetEvent('warp-duty:clock_out:public_defender')
AddEventHandler('warp-duty:clock_out:public_defender', function()
	if ClockedInAsPublicDefender == true then
		ClockedInAsPublicDefender = false
		TriggerServerEvent("jobssystem:jobs", "unemployed")
		TriggerEvent("DoLongHudText",'Signed out. You are no longer a Public Defender', 2)
	else
		TriggerEvent("DoLongHudText",'You was never clocked in as a Public Defender', 2)
	end
end)

RegisterNetEvent('warp-duty:clocked_in:public_defender_successful')
AddEventHandler('warp-duty:clocked_in:public_defender_successful', function()
	if ClockedInAsPublicDefender == false then
		ClockedInAsPublicDefender = true
	else
		TriggerEvent("DoLongHudText",'You are already clocked in as a Public Defender', 2)
	end
end)

-- District Attorney --

RegisterNetEvent('warp-duty:clock_in:district_attorney_context')
AddEventHandler('warp-duty:clock_in:district_attorney_context', function()
	TriggerEvent('warp-context:sendMenu', {
		{
            id = 1,
            header = "< Go Back",
			txt = "",
			params = {
                event = "warp-duty:doj_board"
            }
        },
        {
            id = 2,
            header = "Sign In",
			txt = "",
			params = {
                event = "warp-duty:clock_in:district_attorney"
            }
        },
		{
            id = 3,
            header = "Sign Out",
			txt = "",
			params = {
				event = "warp-duty:clock_out:district_attorney"
            }
        },
    })
end)

RegisterNetEvent('warp-duty:clock_in:district_attorney')
AddEventHandler('warp-duty:clock_in:district_attorney', function()
	if ClockedInAsDistrictAttorney == false then
		TriggerServerEvent('warp-duty:attempt_duty:district_attorney')
	else
		TriggerEvent("DoLongHudText",'You are on duty already!', 2)
	end
end)

RegisterNetEvent('warp-duty:clock_out:district_attorney')
AddEventHandler('warp-duty:clock_out:district_attorney', function()
	if ClockedInAsDistrictAttorney == true then
		ClockedInAsDistrictAttorney = false
		TriggerServerEvent("jobssystem:jobs", "unemployed")
		TriggerEvent("DoLongHudText",'Signed out. You are no longer a District Attorney', 2)
	else
		TriggerEvent("DoLongHudText",'You was never clocked in as a District Attorney', 2)
	end
end)

RegisterNetEvent('warp-duty:clocked_in:district_attorney_successful')
AddEventHandler('warp-duty:clocked_in:district_attorney_successful', function()
	if ClockedInAsDistrictAttorney == false then
		ClockedInAsDistrictAttorney = true
	else
		TriggerEvent("DoLongHudText",'You are already clocked in as a District Attorney', 2)
	end
end)

-- BURGER SHOT --

RegisterNetEvent('warp-duty:clock_in:district_attorney_context')
AddEventHandler('warp-duty:clock_in:district_attorney_context', function()
TriggerEvent('warp-context:sendMenu', {
	{
		id = 1,
		header = "< Go Back",
		txt = "",
		params = {
			event = "warp-duty:doj_board"
		}
	},
	{
		id = 2,
		header = "Sign In",
		txt = "",
		params = {
			event = "warp-duty:clock_in:district_attorney"
		}
	},
	{
		id = 3,
		header = "Sign Out",
		txt = "",
		params = {
			event = "warp-duty:clock_out:district_attorney"
		}
	},
})
end)

RegisterNetEvent('warp-duty:clock_out:district_attorney')
AddEventHandler('warp-duty:clock_out:district_attorney', function()
	if ClockedInAsDistrictAttorney == true then
		ClockedInAsDistrictAttorney = false
		TriggerServerEvent("jobssystem:jobs", "unemployed")
		TriggerEvent("DoLongHudText",'Signed out. You are no longer a District Attorney', 2)
	else
		TriggerEvent("DoLongHudText",'You was never clocked in as a District Attorney', 2)
	end
end)

RegisterNetEvent('warp-duty:clocked_in:district_attorney_successful')
AddEventHandler('warp-duty:clocked_in:district_attorney_successful', function()
	if ClockedInAsDistrictAttorney == false then
		ClockedInAsDistrictAttorney = true
	else
		TriggerEvent("DoLongHudText",'You are already clocked in as a District Attorney', 2)
	end
end)



-- --Name: burgershot | 2022-02-01T00:38:01Z
-- CircleZone:Create(vector3(-1192.13, -901.02, 14.78), 0.87, {
-- 	name="burgershot",
-- 	useZ=true,
-- 	--debugPoly=true
--   })
  