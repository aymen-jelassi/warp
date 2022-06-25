local inCasino = false
local spinningObject = nil
local spinningCar = nil
local carOnShow = `r8v10`

function IsTable(T)
	return type(T) == 'table'
end

function SetIplPropState(interiorId, props, state, refresh)
	if refresh == nil then refresh = false end
	if IsTable(interiorId) then
		for key, value in pairs(interiorId) do
			SetIplPropState(value, props, state, refresh)
		end
	else
		if IsTable(props) then
			for key, value in pairs(props) do
				SetIplPropState(interiorId, value, state, refresh)
			end
		else
			if state then
				if not IsInteriorPropEnabled(interiorId, props) then EnableInteriorProp(interiorId, props) end
			else
				if IsInteriorPropEnabled(interiorId, props) then DisableInteriorProp(interiorId, props) end
			end
		end
		if refresh == true then RefreshInterior(interiorId) end
	end
end
  
Citizen.CreateThread(function()
	Wait(10000)
	RequestIpl('vw_casino_main')
	RequestIpl('vw_dlc_casino_door')
	RequestIpl('hei_dlc_casino_door')
	RequestIpl("hei_dlc_windows_casino")
	RequestIpl("vw_casino_penthouse")
	SetIplPropState(274689, "Set_Pent_Tint_Shell", true, true)
	SetInteriorEntitySetColor(274689, "Set_Pent_Tint_Shell", 3)
	-- RequestIpl("hei_dlc_windows_casino_lod")
	-- RequestIpl("vw_casino_carpark")
	-- RequestIpl("vw_casino_garage")
	-- RequestIpl("hei_dlc_casino_aircon")
	-- RequestIpl("hei_dlc_casino_aircon_lod")
	-- RequestIpl("hei_dlc_casino_door")
	-- RequestIpl("hei_dlc_casino_door_lod")
	-- RequestIpl("hei_dlc_vw_roofdoors_locked")
	-- RequestIpl("vw_ch3_additions")
	-- RequestIpl("vw_ch3_additions_long_0")
	-- RequestIpl("vw_ch3_additions_strm_0")
	-- RequestIpl("vw_dlc_casino_door")
	-- RequestIpl("vw_dlc_casino_door_lod")
	-- RequestIpl("vw_casino_billboard")
	-- RequestIpl("vw_casino_billboard_lod(1)")
	-- RequestIpl("vw_casino_billboard_lod")
	-- RequestIpl("vw_int_placement_vw")
	-- RequestIpl("vw_dlc_casino_apart")
	local interiorID = GetInteriorAtCoords(1100.000, 220.000, -50.000)
	
	if IsValidInterior(interiorID) then
	  RefreshInterior(interiorID)
	end
  
	
end)


--TELEPORT
key_to_teleport = 38

positions = {
    --[[
    {{Teleport1 X, Teleport1 Y, Teleport1 Z, Teleport1 Heading}, {Teleport2 X, Teleport 2Y, Teleport 2Z, Teleport2 Heading}, {Red, Green, Blue}, "Text for Teleport"}
    ]]
    {{925.0, 47.0, 80.00, 0}, {1090.00, 207.00, -49.9, 358},{255,0,0}, "Cassino Diamond"}, -- Outside the Sheriff's Station
	--{{1086.00, 215.0, -50.00, 312}, {964.2912597, 58.9096641, 111.65295562744, 52},{255,0,0}, "penthouse"},
}

local player = GetPlayerPed(-1)

RegisterNetEvent('assets_maps:entercasino')
AddEventHandler('assets_maps:entercasino', function()
	DoScreenFadeOut(1)
	Citizen.Wait(100)
	SetEntityCoords(PlayerPedId(), 1089.7186279297,205.91209411621,-49.00439453125)
	SetEntityHeading(PlayerPedId(), 0.0)
	DoScreenFadeIn(1000)
	enterCasino(false)
	Citizen.Wait(1)
	enterCasino(true)
end)

RegisterNetEvent('assets_maps:leavecasino')
AddEventHandler('assets_maps:leavecasino', function()
	DoScreenFadeOut(1)
	Citizen.Wait(100)
	SetEntityCoords(PlayerPedId(), 936.01318359375,47.208793640137,81.093017578125)
	SetEntityHeading(PlayerPedId(), 153.07086181641)
	DoScreenFadeIn(1000)
	enterCasino(false)
	Citizen.Wait(1)
	enterCasino(false)
end)

-- CAR FOR WINS
function drawCarForWins()
	if DoesEntityExist(spinningCar) then
	  DeleteEntity(spinningCar)
	end
	RequestModel(carOnShow)
	while not HasModelLoaded(carOnShow) do
		Citizen.Wait(0)
	end
	SetModelAsNoLongerNeeded(carOnShow)
	spinningCar = CreateVehicle(carOnShow, 1100.0, 220.0, -51.0 + 0.05, 0.0, 0, 0)
	Wait(0)
	SetVehicleDirtLevel(spinningCar, 0.0)
	SetVehicleOnGroundProperly(spinningCar)
	Wait(0)
	FreezeEntityPosition(spinningCar, 1)
end

-- END CAR FOR WINS

function enterCasino(pIsInCasino, pFromElevator, pCoords, pHeading)
	if pIsInCasino == inCasino then return end
	inCasino = pIsInCasino
	if DoesEntityExist(spinningCar) then
	  DeleteEntity(spinningCar)
	end
	spinMeRightRoundBaby()
	showDiamondsOnScreenBaby()
	playSomeBackgroundAudioBaby()
end
  
function spinMeRightRoundBaby()
	Citizen.CreateThread(function()
	    while inCasino do
		if not spinningObject or spinningObject == 0 or not DoesEntityExist(spinningObject) then
		  spinningObject = GetClosestObjectOfType(1100.0, 220.0, -51.0, 10.0, -1561087446, 0, 0, 0)
		  drawCarForWins()
		end
		if spinningObject ~= nil and spinningObject ~= 0 then
		  local curHeading = GetEntityHeading(spinningObject)
		  local curHeadingCar = GetEntityHeading(spinningCar)
		  if curHeading >= 360 then
			curHeading = 0.0
			curHeadingCar = 0.0
		  elseif curHeading ~= curHeadingCar then
			curHeadingCar = curHeading
		  end
		  SetEntityHeading(spinningObject, curHeading + 0.075)
		  SetEntityHeading(spinningCar, curHeadingCar + 0.075)
		end
		Wait(0)
	  end
	  spinningObject = nil
	end)
end
  
-- Casino Screens
local Playlists = {
	"CASINO_DIA_PL", -- diamonds
	"CASINO_SNWFLK_PL", -- snowflakes
	"CASINO_WIN_PL", -- win
	"CASINO_HLW_PL", -- skull
}
 
-- Render
function CreateNamedRenderTargetForModel(name, model)
	local handle = 0
	if not IsNamedRendertargetRegistered(name) then
		RegisterNamedRendertarget(name, 0)
	end
	if not IsNamedRendertargetLinked(model) then
		LinkNamedRendertarget(model)
	end
	if IsNamedRendertargetRegistered(name) then
		handle = GetNamedRendertargetRenderId(name)
	end
  
	return handle
end

-- render tv 
function showDiamondsOnScreenBaby()
	Citizen.CreateThread(function()
	  local model = GetHashKey("vw_vwint01_video_overlay")
	  local timeout = 21085 -- 5000 / 255
  
	  local handle = CreateNamedRenderTargetForModel("CasinoScreen_01", model)
  
	  RegisterScriptWithAudio(0)
	  SetTvChannel(-1)
	  SetTvVolume(0)
	  SetScriptGfxDrawOrder(4)
	  SetTvChannelPlaylist(2, "CASINO_DIA_PL", 0)
	  SetTvChannel(2)
	  EnableMovieSubtitles(1)
  
	function doAlpha()
		Citizen.SetTimeout(timeout, function()
		SetTvChannelPlaylist(2, "CASINO_DIA_PL", 0)
		SetTvChannel(2)
		doAlpha()
		end)
	end
	doAlpha()
  
	Citizen.CreateThread(function()
	while inCasino do
	  SetTextRenderId(handle)
	  DrawTvChannel(0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
	  SetTextRenderId(GetDefaultScriptRendertargetRenderId())
	  Citizen.Wait(0)
	end
	SetTvChannel(-1)
	ReleaseNamedRendertarget(GetHashKey("CasinoScreen_01"))
	SetTextRenderId(GetDefaultScriptRendertargetRenderId())
	end)
   end)
end
  
function playSomeBackgroundAudioBaby()
	Citizen.CreateThread(function()
	  local function audioBanks()
		while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_GENERAL", false, -1) do
		  Citizen.Wait(0)
		end
		while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_01", false, -1) do
		  Citizen.Wait(0)
		end
		while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_02", false, -1) do
		  Citizen.Wait(0)
		end
		while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_03", false, -1) do
		  Citizen.Wait(0)
		end
		-- while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_INTERIOR_STEMS", false, -1) do
		--   print('load 5')
		--   Wait(0)
		-- end
	  end
	  audioBanks()
	  while inCasino do
		if not IsStreamPlaying() and LoadStream("casino_walla", "DLC_VW_Casino_Interior_Sounds") then
		  PlayStreamFromPosition(1111, 230, -47)
		end
		if IsStreamPlaying() and not IsAudioSceneActive("DLC_VW_Casino_General") then
		  StartAudioScene("DLC_VW_Casino_General")
		end
		Citizen.Wait(1000)
	  end
	  if IsStreamPlaying() then
		StopStream()
	  end
	  if IsAudioSceneActive("DLC_VW_Casino_General") then
		StopAudioScene("DLC_VW_Casino_General")
	  end
	end)
  end
  
