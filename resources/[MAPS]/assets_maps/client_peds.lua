local policeped = 0


function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

function createProcessPed()
	policeped = CreatePed(GetPedType(1581098148), 1581098148, 401.58,-1002.059,-100.004, 15, false, 0)
	DecorSetBool(policeped, 'ScriptedPed', true)
	FreezeEntityPosition(policeped)
	loadAnimDict( "missheist_jewel@hacking" )
	TaskPlayAnim( policeped, "missheist_jewel@hacking", "hack_loop", 8.0, -8, -1, 49, 0, 0, 0, 0 )
	SetPedKeepTask(policeped, true)
end
function delProcessPed()

	DeleteEntity(policeped)
end

spawnedPeds = {}
spawnedPedLocations = {
	[1] = { ["pedType"] = 1581098148, ["x"] = 2107.7724609375, ["y"] = 2929.2177734375, ["z"] = -61.901931762695, ["h"] = 139.06498718262, ["animDict"] = "amb@world_human_cop_idles@male@idle_a", ["anim"] = "idle_b"},
	[2] = { ["pedType"] = 368603149, ["x"] = 2111.0961914063, ["y"] = 2929.0212402344, ["z"] = -61.901931762695, ["h"] = 299.44998168945, ["animDict"] = "missheist_jewel@hacking", ["anim"] = "hack_loop"},
	[3] = { ["pedType"] = 1581098148, ["x"] = 2121.3715820313, ["y"] = 2925.6013183594, ["z"] = -61.90193939209, ["h"] = 176.32382202148, ["animDict"] = "amb@world_human_cop_idles@male@idle_a", ["anim"] = "idle_b"},
	[4] = { ["pedType"] = 1581098148, ["x"] = 2132.4958496094, ["y"] = 2925.4846191406, ["z"] = -61.901893615723, ["h"] = 267.89236450195, ["animDict"] = "amb@world_human_cop_idles@male@idle_a", ["anim"] = "idle_b"},
	[5] = { ["pedType"] = 368603149, ["x"] = 2130.7924804688, ["y"] = 2924.328125, ["z"] = -61.901893615723, ["h"] = 185.47744750977, ["animDict"] = "amb@world_human_cop_idles@male@idle_a", ["anim"] = "idle_b"},

	[6] = { ["pedType"] = 1092080539, ["x"] = 2099.15234375, ["y"] = 2942.9895019531, ["z"] = -65.501823425293, ["h"] = 121.15898132324},
	[7] = { ["pedType"] = 1581098148, ["x"] = 2064.3310546875, ["y"] = 2945.65625, ["z"] = -65.502021789551, ["h"] = 284.78601074219},
	[8] = { ["pedType"] = 1092080539, ["x"] = 2064.982421875, ["y"] = 2947.8371582031, ["z"] = -65.502021789551, ["h"] = 212.32131958008},
	[9] = { ["pedType"] = 368603149, ["x"] = 2047.8717041016, ["y"] = 2955.6459960938, ["z"] = -65.502021789551, ["h"] = 265.44512939453},
	[10] = { ["pedType"] = 1581098148, ["x"] = 2043.9493408203, ["y"] = 2955.6618652344, ["z"] = -65.502021789551, ["h"] = 78.124046325684},
	[11] = { ["pedType"] = 1581098148, ["x"] = 2035.0772705078, ["y"] = 2965.7717285156, ["z"] = -65.502021789551, ["h"] = 21.757316589355},
	[12] = { ["pedType"] = 368603149, ["x"] = 2036.3978271484, ["y"] = 2967.34375, ["z"] = -65.502021789551, ["h"] = 70.922843933105},
	[13] = { ["pedType"] = 1650288984, ["x"] = 2036.3647460938, ["y"] = 2966.0642089844, ["z"] = -65.502021789551, ["h"] = 43.284496307373},
	[14] = { ["pedType"] = 1581098148, ["x"] = 2028.2233886719, ["y"] = 2976.6044921875, ["z"] = -65.502021789551, ["h"] = 75.95450592041},
	[15] = { ["pedType"] = 368603149, ["x"] = 2026.6433105469, ["y"] = 2975.1135253906, ["z"] = -65.502021789551, ["h"] = 9.5711069107056},

	[16] = { ["pedType"] = 1581098148, ["x"] = 2047.0968017578, ["y"] = 2960.8471679688, ["z"] = -65.502021789551, ["h"] = 92.319404602051},
	[17] = { ["pedType"] = 368603149, ["x"] = 2033.6658935547, ["y"] = 2973.009765625, ["z"] = -65.502021789551, ["h"] = 62.04626083374},
	[18] = { ["pedType"] = 1581098148, ["x"] = 2042.0290527344, ["y"] = 2959.8764648438, ["z"] = -65.502021789551, ["h"] = 255.01411437988},
	[19] = { ["pedType"] = 368603149, ["x"] = 2071.2592773438, ["y"] = 2946.4331054688, ["z"] = -65.502029418945, ["h"] = 258.10818481445},
	[20] = { ["pedType"] = 1581098148, ["x"] = 2071.2092285156, ["y"] = 2945.8088378906, ["z"] = -65.502029418945, ["h"] = 239.19422912598},
	[21] = { ["pedType"] = 368603149, ["x"] = 2083.8115234375, ["y"] = 2947.8137207031, ["z"] = -65.501899719238, ["h"] = 242.61120605469},
	[22] = { ["pedType"] = 1581098148, ["x"] = 2083.1064453125, ["y"] = 2941.0427246094, ["z"] = -65.501899719238, ["h"] = 243.56161499023},
	[23] = { ["pedType"] = 368603149, ["x"] = 2080.3305664063, ["y"] = 2943.9006347656, ["z"] = -65.501899719238, ["h"] = 51.285091400146},
	[24] = { ["pedType"] = 368603149, ["x"] = 2079.9599609375, ["y"] = 2941.7927246094, ["z"] = -65.501899719238, ["h"] = 102.3041229248},
	[25] = { ["pedType"] = 1092080539, ["x"] = 2095.73046875, ["y"] = 2938.8049316406, ["z"] = -65.501899719238, ["h"] = 302.30474853516},
	[26] = { ["pedType"] = 1581098148, ["x"] = 2095.9440917969, ["y"] = 2940.8825683594, ["z"] = -65.501899719238, ["h"] = 246.9533996582},
	[27] = { ["pedType"] = 1581098148, ["x"] = 2095.5952148438, ["y"] = 2942.8999023438, ["z"] = -65.501899719238, ["h"] = 308.25518798828},
	[28] = { ["pedType"] = 368603149, ["x"] = 2107.2661132813, ["y"] = 2945.34765625, ["z"] = -65.501899719238, ["h"] = 233.36782836914},
	[29] = { ["pedType"] = 1581098148, ["x"] = 2107.416015625, ["y"] = 2942.7631835938, ["z"] = -65.501899719238, ["h"] = 296.83337402344},
	[30] = { ["pedType"] = 368603149, ["x"] = 2110.419921875, ["y"] = 2940.7756347656, ["z"] = -65.501899719238, ["h"] = 74.760299682617},
	[31] = { ["pedType"] = 1092080539, ["x"] = 2112.0483398438, ["y"] = 2948.0483398438, ["z"] = -65.501899719238, ["h"] = 180.2264251709},
}
function randomScenario2()
	local math = math.random(10)
	ret = "WORLD_HUMAN_HANG_OUT_STREET"
	if math == 5 then
		ret = "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT"
	elseif math == 4 then
		ret = "WORLD_HUMAN_DRINKING"
	elseif math < 4 then
		ret = "WORLD_HUMAN_SMOKING"
	end
	return ret
end

function randomScenario()
	local math = math.random(10)
	ret = "WORLD_HUMAN_CLIPBOARD"
	if math == 5 then
		ret = "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT"
	elseif math == 4 then
		ret = "WORLD_HUMAN_DRINKING"
	elseif math < 4 then
		ret = "CODE_HUMAN_MEDIC_TIME_OF_DEATH"
	end

	return ret
end

function GetRandomWeapon()
	ret = "WEAPON_COMBATPISTOL"
	local math = math.random(10)

	if math == 9 then
		ret = "WEAPON_PISTOL"
	elseif math == 8 then
		ret = "WEAPON_COMBATPISTOL"
	elseif math == 5 then
		ret = "WEAPON_PISTOL"
	end

	return ret
end
--s_m_m_scientist_01


local retry = 0
local retry2 = 0

function DelCocainePeds()
	local playerped = PlayerPedId()
    local handle, ObjectFound = FindFirstPed()
    local success
    repeat
        local pos = GetEntityCoords(ObjectFound)
        local distance = #(vector3(1088.472, -3191.326, -38.993) - pos)
        if distance < 175.0 and ObjectFound ~= playerped then
    		if IsPedAPlayer(ObjectFound) then
    		else
    			SetEntityAsNoLongerNeeded(ObjectFound)

    			DeleteEntity(ObjectFound)
    		end            
        end
        success, ObjectFound = FindNextPed(handle)
    until not success
    EndFindPed(handle)
end