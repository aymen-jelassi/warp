LoginSafe = {}
Login.CreatedPeds = {}
Login.CurrentPed = nil
Login.CurrentPedInfo = nil
Login.Hiding = false
Login.Open = false
LoginSafe.Cam = nil
Login.Selected = false
Login.CurrentClothing = {}
Login.HasTransistionFinished = true
Login.LoadFinished = true
Login.isTrainMoving = false
Login.currentProtected = {}
Login.finished = true
Login.custompeds = {}

Login.actionsBlocked = false

local vehicle = nil
local vehicleBack = nil

Login.Emotes = {
	[1] = 166523388,
	[2] = 354512356,
	[3] = -653113914,
	[4] = -822629770,
	[5] = -339257980,
}

Login.spawnLoc = {
	[1] = vector4(-6.0263710021973, -583.26593017578, 98.000000096875, 127.55905151367),
	[2] = vector4 (-6.8439521789551, -582.90991210938, 98.000000096875, 158.74015808105),
	[3] = vector4(-7.8725242614746, -582.55383300781, 98.000000096875, 161.57479858398),
	[4] = vector4 (-9.0725250244141, -582.03955078125, 98.000000096875, 158.74015808105),
	[5] = vector4(-10.35164642334, -581.64398193359, 98.000000096875, 189.92126464844),
}

function Login.Init()
	CreateThread(function()

		Login.HidePlayer(true)
		TriggerEvent("inSpawn",true)
		SetEntityCoordsNoOffset(PlayerPedId(), vector3(-9.859153, -587.2075, 99.5511), false, false, false, false)
		FreezeEntityPosition(PlayerPedId(), true)
		SetEntityVisible(PlayerPedId(), false)

		while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
			Wait(0)
		end

		Login.SetCharacterLoginCam()
		Wait(500)
		TriggerEvent("loading:disableLoading")
		Login.ShowMenu(true)
		
		SetEntityCoordsNoOffset(PlayerPedId(), vector3(-9.859153, -587.2075, 99.5511), false, false, false, false)
	end)
end

function Login.HidePlayer(toggle)

	CreateThread(function()
		local ped = PlayerPedId()

		while not ped do
			Wait(0)
			ped = PlayerPedId()
		end
	end)

end

function Login.ShowMenu(toggle)
	Login.Open = toggle == nil and not Login.open or toggle

	if Login.Open then
		SendNUIMessage({
			showAnim = true
		})
		return
	end

	SendNUIMessage({
		close = true
	})
	SetNuiFocus(false, false)

end


function Login.SetCharacterLoginCam()
	LoginSafe.Cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
	local camCoords = { -9.859153, -587.2075, 99.5511  }
	SetEntityCoordsNoOffset(PlayerPedId(), vector3(-9.859153, -587.2075, 99.5511), false, false, false, false)
	SetCamRot(LoginSafe.Cam, -14.0, 0.0, 340.16015625, 2)
	SetCamCoord(LoginSafe.Cam, camCoords[1], camCoords[2], camCoords[3])
	StopCamShaking(LoginSafe.Cam, true)
	SetCamFov(LoginSafe.Cam, 55.75)
	SetCamActive(LoginSafe.Cam, true)
	RenderScriptCams(true, false, 0, true, true)
end


function Login.nativeStart(AlreadySpawned)
	isNear = true
	ClearFocus()
	DestroyAllCams(true)
	RenderScriptCams(false, true, 1, true, true)

	if not AlreadySpawned then
		tatCategory = exports["raid_clothes"]:GetTatCategs()
		tattooHashList = exports["raid_clothes"]:GetTatCategs()
		Login.custompeds = exports["raid_clothes"]:GetCustomSkins()

		--Prevent blur from getting stuck
		while IsScreenblurFadeRunning() do
			Wait(0)
		end
		TransitionFromBlurred(1)

		Login.Init()
		Login.getCharacters(false)

		CreateThread(function()
			while Login.LoadFinished do
		        Wait(10)
		    end
		    TriggerScreenblurFadeOut(1)

		    Wait(2000)
		    SendNUIMessage({
				startAnim = true
			})
		end)
		
	else
		Login.SetCharacterLoginCam()
		Login.getCharacters(true)
	end
	
end

RegisterNetEvent("character:PlayerSelectedCharacter")
AddEventHandler("character:PlayerSelectedCharacter", function(charId)
	SendNUIMessage({
		close = true
	})
	Login.HidePlayer(false)
end)

function Login.NUICallback(data)

	if Login.actionsBlocked and data.action ~= "proceed" then return end

	if data.action == "selectCharacter" then
       Login.SelectedChar(data)
	end

	if data.action == "proceed" then
		Login.HasTransistionFinished = false
	end

	if data.action == "currentHover" then
		local offset = vector2(data.x,data.y)
		local coords = exports["warp-base"]:getModule("Util"):ScreenRelToWorld(GetCamCoord(LoginSafe.Cam), GetCamRot(LoginSafe.Cam,2),offset)
	    local pedCaught = LocationInWorld(coords,LoginSafe.Cam)
	    local pedData = findCharPed(pedCaught,true)

		SendNUIMessage({
			update = true,
			currentSelect = pedData,
			fadeHover = true
		})
	end

	if data.action == "singleClick" or data.action == "doubleClick" then
	    local offset = vector2(data.x,data.y)
	    local coords = exports["warp-base"]:getModule("Util"):ScreenRelToWorld(GetCamCoord(LoginSafe.Cam), GetCamRot(LoginSafe.Cam,2),offset)
	    local pedCaught = LocationInWorld(coords,LoginSafe.Cam)
	   	local pedData = nil
	    if data.safe then
		    pedData = findCharPed(pedCaught,false)

		    if pedData == nil then
		    	Login.Selected = false 
		    else
		    	Login.Selected = true
		    end

		    SendNUIMessage({
				update = true,
				currentSelect = pedData,
				fadeHover = false,
				forceHover = true
			})
		end


	    if pedData ~= nil then

		    if data.action == "doubleClick" then
	    		if pedData.charId == 0 then
	    			SendNUIMessage({
						newChar = true
					})
	    		else
					local construct = {
						actionData = pedData.charId
					}
		    		Login.SelectedChar(construct)
		    	end
		    end
		end
	end
	

	if data.action == "deleteCharacter" then
		Login.actionsBlocked = true
		local events = exports["warp-base"]:getModule("Events")
		events:Trigger("warp-base:deleteCharacter", data.actionData, function(deleted)
            Login.getCharacters(true)
        end)
	end

	if data.action == "newCharacter" then
		Login.actionsBlocked = true
		local cData = data.actionData
		local events = exports["warp-base"]:getModule("Events")
		if cData.gender == "F" then cData.gender = 1 end
		if cData.gender == "M" then cData.gender = 0 end
		local chardata = {
			firstname = cData.first_name,
			lastname = cData.last_name,
			dob = cData.dob,
			gender = cData.gender,
			story = "Default story - new char system"
		}
		
        if not chardata then return end

		events:Trigger("warp-base:createCharacter", chardata, function(created)
			print('this is created ', json.encode(created, {indent = true}))
            -- if created then
			-- 	TriggerEvent("DoLongHudText","There was an error while creating your character, value returned nil or false. Contact an administrator if this persists.",2) 
			-- 	Login.CreatePlayerCharacterPeds(Login.CurrentClothing,true)
            --     return
            -- end

			-- if type(created) == "table" and created.err then
			-- 	TriggerEvent("DoLongHudText",created.msg,2) 
			-- 	Login.CreatePlayerCharacterPeds(Login.CurrentClothing,true)
            --     return
			-- end

			if not created then
				Login.CreatePlayerCharacterPeds(Login.CurrentClothing,true)
				if chardata.gender == 0 then
					chardata.gender = 'Male'
				elseif chardata.gender == 1 then
					chardata.gender = 'Female'
				end

				TriggerServerEvent('warp-base:charactercreate', chardata.firstname, chardata.lastname, chardata.dob, pGender)
				
				Login.getCharacters(true)
			else
				TriggerEvent("DoLongHudText",created.msg,2) 
			end
		end)
	end
	
	if data.action == "refreshCharacters" then
		Login.CreatePlayerCharacterPeds(Login.CurrentClothing, true)
	end

	if data.action == "favorite" then
		local fav = data.actionData
		exports["storage"]:set(fav,"npfavorite")
	end

	if data.action == "spawnLocation" then
		local spawnInfo = data.actionData
		Spawn.selectedSpawn(spawnInfo)
	end
end

RegisterNUICallback("nuiCallback", Login.NUICallback)

function Login.ClearSpawnedPeds()
    for _, spawnedPed in ipairs(Login.CreatedPeds) do
        DeletePed(spawnedPed.pedObject)
        SetNuiFocus(false, false)
    end
end


function Login.DeleteCamera()
    ClearFocus()
    DestroyAllCams(true)
    RenderScriptCams(false, true, 1, true, true)
    SetNuiFocus(false, false)
end


AddEventHandler("onResourceStop", function()
	Login.ClearSpawnedPeds()
end)

RegisterNetEvent("warp-base:spawnInitialized")
AddEventHandler("warp-base:spawnInitialized", function()
	TriggerServerEvent("commands:reset:login")
	TriggerServerEvent("warp-base:clearStates")
	Login.nativeStart()
end)

RegisterNetEvent("warp-base:relog")
AddEventHandler("warp-base:relog", function(type)
	TriggerServerEvent("commands:reset:login")
	TriggerServerEvent("warp-base:clearStates")
	if type == "motel" then
		Login.nativeStart()
	end
end)