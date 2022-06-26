-- types, 1 = gun, 2 = contraband, 3 melee weapons, 4 katana for sheath

local ag = {}
local ad = {}
local am = {}
local ab = {}
local gunLimit = 4
local drugLimit = 5
local meleeLimit = 4
local disabled = false -- is only temp disable for clothing etc to prevent items everywhere
local tried = false
local isKatanaEquppied = false
local katana_model = 'katana_sheath'

RegisterNetEvent('ev-katana:equippedNow', function(bool)
	local switching = false
	local isEquip = bool
	if isEquip then
		katana_model = 'katana_sheath_empty'
		Wait(10)
	else
		katana_model = 'katana_sheath'
	end
	Wait(10)
end)

Citizen.CreateThread(function()
	local switching = false
	while true do
		Citizen.Wait(1000)
		local ped = PlayerPedId()
		local num, curw = GetCurrentPedWeapon(ped, false)
		if curw == -1239161099 or curw == 1692590063 then
			sleep = false
			TriggerEvent('ev-katana:equippedNow',true)
			Wait(10)
		elseif curw ~= -1239161099 or curw ~= 1692590063 then
			TriggerEvent('ev-katana:equippedNow',false)
		end
		Wait(10)
	end
end)
 

local w = {
	[1] = { ["type"] = 2, ["name"] = "Weed Plant", ["id"] = "wetbud", ["model"] = 'bkr_prop_weed_drying_02a', ["z"] = 0.3, ["rx"] = 0.0, ["ry"] = 90.0, ["rz"] = 0.0 },
	[2] = { ["type"] = 1, ["name"] = "Rocket Launcher", ["id"] = "-1312131151", ["model"] = 'w_lr_rpg', ["z"] = -0.15, ["rx"] = 0.0, ["ry"] = 180.0, ["rz"] = 0.0 },
	[3] = { ["type"] = 1, ["name"] = "RPG", ["id"] = "rpgammo", ["model"] = 'w_lr_rpg_rocket', ["z"] = 0.35, ["rx"] = 90.0, ["ry"] = 90.0, ["rz"] = 0.0 },
	[4] = { ["type"] = 1, ["name"] = "Remington", ["id"] = "1432025498", ["model"] = 'w_sg_pumpshotgunmk2', ["z"] = 0.0, ["rx"] = 0.0, ["ry"] = 0.0, ["rz"] = 0.0 },
	[5] = { ["type"] = 1, ["name"] = "IZh-81", ["id"] = "487013001", ["model"] = 'w_sg_izh81', ["z"] = -0.23, ["rx"] = 0.0, ["ry"] = 0.0, ["rz"] = 0.0 },
	[6] = { ["type"] = 1, ["name"] = "m70", ["id"] = "497969164", ["model"] = 'w_ar_assaultrifle2', ["z"] = 0.0, ["rx"] = 0.0, ["ry"] = 0.0, ["rz"] = 0.0 },
	[7] = { ["type"] = 1, "AK74", ["id"] = "-1074790547", ["model"] = 'w_ar_ak74', ["z"] = 0.0, ["rx"] = 0.0, ["ry"] = 0.0, ["rz"] = 0.0 },
	[8] = { ["type"] = 1, ["name"] = "SCAR", ["id"] = "-1768145561", ["model"] = 'w_ar_scar', ["z"] = 0.1, ["rx"] = 0.0, ["ry"] = 0.0, ["rz"] = 0.0 },
	[9] = { ["type"] = 1, ["name"] = "M4", ["id"] = "1192676223", ["model"] = 'w_ar_m4', ["z"] = 0.1, ["rx"] = 0.0, ["ry"] = 0.0, ["rz"] = 0.0 },
	[10] = { ["type"] = 1, ["name"] = "Draco", ["id"] = "1649403952", ["model"] = 'w_ar_draco', ["z"] = 0.0, ["rx"] = 0.0, ["ry"] = 0.0, ["rz"] = 0.0 },
	[11] = { ["type"] = 1, ["name"] = "Sig MPX", ["id"] = "171789620", ["model"] = 'w_sb_mpx', ["z"] = 0.02, ["rx"] = 0.0, ["ry"] = 0.0, ["rz"] = 0.0 },
	[12] = { ["type"] = 1, ["name"] = "Hunting Rifle", ["id"] = "3648318199", ["model"] = 'w_sr_sniperrifle2', ["z"] = 0.0, ["rx"] = 0.0, ["ry"] = 0.0, ["rz"] = 0.0 },	
	[13] = { ["type"] = 2, ["name"] = "Meth Bag", ["id"] = "methlabbatch", ["model"] = 'hei_prop_pill_bag_01', ["z"] = 0.05, ["rx"] = 0.0, ["ry"] = 90.0, ["rz"] = 0.0 },
	[14] = { ["type"] = 2, ["name"] = "Meth Bag", ["id"] = "meth50g", ["model"] = 'bkr_prop_meth_smallbag_01a', ["z"] = 0.1, ["rx"] = 95.0, ["ry"] = 90.0, ["rz"] = 0.0 },
	[15] = { ["type"] = 2, ["name"] = "Coke Brick", ["id"] = "cocainebrick", ["model"] = 'bkr_prop_coke_cutblock_01', ["z"] = 0.05, ["rx"] = 95.0, ["ry"] = 90.0, ["rz"] = 0.0 },
	[16] = { ["type"] = 2, ["name"] = "Bank Bag", ["id"] = "inkedmoneybag", ["model"] = 'prop_money_bag_01', ["z"] = -0.4, ["rx"] = 0.0, ["ry"] = 90.0, ["rz"] = 0.0 },
	[17] = { ["type"] = 1, ["name"] = "Dragunov", ["id"] = "-90637530", ["model"] = 'w_sr_dragunov', ["z"] = 0.0, ["rx"] = 0.0, ["ry"] = 0.0, ["rz"] = 0.0 },
	[18] = { ["type"] = 1, ["name"] = "M14", ["id"] = "-1719357158", ["model"] = 'w_sr_m14', ["z"] = 0.0, ["rx"] = 0.0, ["ry"] = 0.0, ["rz"] = 0.0 },
	[19] = { ["type"] = 4, "Katana", ["id"] = "-1239161099", ["z"] = 0.51, ["rx"] = 225.0, ["ry"] = 8.0, ["rz"] = 90.0 },
	[20] = { ["type"] = 4, "Katana", ["id"] = "1692590063", ["z"] = 0.51, ["rx"] = 225.0, ["ry"] = 8.0, ["rz"] = 90.0 },
	[21] = { ["type"] = 4, "Katana", ["id"] = "cursedkatanaweapon", ["z"] = 0.51, ["rx"] = 225.0, ["ry"] = 8.0, ["rz"] = 90.0 },
	[22] = { ["type"] = 3, ["name"] = "Machete", ["id"] = "3713923289", ["model"] = 'w_me_machette_lr', ["z"] = 0.4, ["rx"] = 5.0, ["ry"] = 45.0, ["rz"] = 0.0 },



	-- smg small
	[23] = { ["type"] = 1, ["name"] = "Gepard", ["id"] = "-1518444656", ["model"] = 'w_ar_gepard', ["z"] = 0.0, ["rx"] = 0.0, ["ry"] = 0.0, ["rz"] = 0.0 },

	[24] = { ["type"] = 1, ["name"] = "MAC-10", ["id"] = "-134995899", ["model"] = 'w_sb_microsmg3', ["z"] = 0.0, ["rx"] = 0.0, ["ry"] = 0.0, ["rz"] = 0.0 },
	[25] = { ["type"] = 1, ["name"] = "Uzi", ["id"] = "-942620673", ["model"] = 'w_sb_uzi', ["z"] = 0.0, ["rx"] = 0.0, ["ry"] = 0.0, ["rz"] = 0.0 },
	[26] = { ["type"] = 1, ["name"] = "MP5", ["id"] = "736523883", ["model"] = 'w_sb_mp5', ["z"] = 0.0, ["rx"] = 0.0, ["ry"] = 0.0, ["rz"] = 0.0 },
	[27] = { ["type"] = 1, ["name"] = "Skorpion", ["id"] = "-1472189665", ["model"] = 'w_sb_skorpion', ["z"] = 0.0, ["rx"] = 0.0, ["ry"] = 0.0, ["rz"] = 0.0 },

	-- other
	[28] = { ["type"] = 1, ["name"] = "Groza", ["id"] = "-1357824103", ["model"] = 'w_ar_groza', ["z"] = 0.0, ["rx"] = 0.0, ["ry"] = 0.0, ["rz"] = 0.0 },

	-- Snipers
	[29] = { ["type"] = 5, ["name"] = "AWM Sniper Rifle", ["id"] = "-1536150836", ["model"] = 'prop_gun_case_01', ["z"] = 0.0, ["rx"] = 182.0, ["ry"] = 147.0, ["rz"] = 82.0 },
	[30] = { ["type"] = 5, ["name"] = "M24 Sniper Rifle", ["id"] = "100416529", ["model"] = 'prop_gun_case_01', ["z"] = 0.0, ["rx"] = 182.0, ["ry"] = 147.0, ["rz"] = 82.0 },
	

	[31] = { ["type"] = 1, ["name"] = "Homing Launcher", ["id"] = "1672152130", ["model"] = 'w_lr_homing', ["z"] = -0.15, ["rx"] = 0.0, ["ry"] = 180.0, ["rz"] = 0.0 },
	[32] = { ["type"] = 1, ["name"] = "Homing Launcher Ammo", ["id"] = "homingammo", ["model"] = 'w_lr_homing_rocket', ["z"] = 0.35, ["rx"] = 90.0, ["ry"] = 90.0, ["rz"] = 0.0 },

	-- Duffel Bag
	[33] = { ["type"] = 6, ["name"] = "Duffel Bag", ["id"] = "heistduffelbag", ["model"] = "hei_p_m_bag_var22_arm_s", ["z"] = 0.51, ["rx"] = 90.0, ["ry"] = 270.0, ["rz"] = 90.0 },

	-- [34] = { ["type"] = 7, ["name"] = "Katana", ["id"] = "-1239161099", ["model"] = 'katana_sheat_empty', ["z"] = 0.51, ["rx"] = 225.0, ["ry"] = 8.0, ["rz"] = 90.0 },
	-- [35] = { ["type"] = 7, ["name"] = "Katana", ["id"] = "1692590063", ["model"] = 'katana_sheat_empty', ["z"] = 0.51, ["rx"] = 225.0, ["ry"] = 8.0, ["rz"] = 90.0 },
	-- [36] = { ["type"] = 7, ["name"] = "Katana", ["id"] = "cursedkatanaweapon", ["model"] = 'katana_sheat_empty', ["z"] = 0.51, ["rx"] = 225.0, ["ry"] = 8.0, ["rz"] = 90.0 },
	[37] = { ["type"] = 1, "Rubber Slug Shotgun", ["id"] = "218362403", ["model"] = 'w_sg_pumpshotgun', ["z"] = 0.0, ["rx"] = 0.0, ["ry"] = 0.0, ["rz"] = 0.0 },
}




RegisterNetEvent("attachedItems:block")
AddEventHandler("attachedItems:block", function(status)
	disabled = status
	if status then
		DeleteAttached()
	else
		TriggerEvent("AttachWeapons")
	end
end)

RegisterNetEvent("AttachWeapons")
AddEventHandler("AttachWeapons", function()
	if disabled then
		return
	end
	local ped = PlayerPedId()
	local num, curw = GetCurrentPedWeapon(ped, false)
	local sheathed = false
	DeleteAttached()
	for i = 1, #w do
		if exports["warp-inventory"]:getQuantity(w[i]["id"]) > 0 then
			local mdl = GetHashKey(w[i]["model"])
			loadmodel(mdl)
			if w[i]["type"] == 1 and #ag < gunLimit and curw ~= tonumber(w[i]["id"]) then
				local bone = GetPedBoneIndex(ped, 24818)
				ag[#ag+1] = CreateObject(mdl, 1.0 ,1.0 ,1.0, 1, 1, 0)
				AttachEntityToEntity(ag[#ag], ped, bone, w[i]["z"], -0.155, 0.21 - (#ag/10), w[i]["rx"], w[i]["ry"], w[i]["rz"], 0, 1, 0, 1, 0, 1)
			elseif w[i]["type"] == 2 and #ad < drugLimit and curw ~= tonumber(w[i]["id"]) then
				local bone = GetPedBoneIndex(ped, 24817)
				ad[#ad+1] = CreateObject(mdl, 1.0 ,1.0 ,1.0, 1, 1, 0)
				AttachEntityToEntity(ad[#ad], ped, bone, w[i]["z"]-0.1, -0.11, 0.24 - (#ad/10), w[i]["rx"], w[i]["ry"], w[i]["rz"], 0, 1, 0, 1, 0, 1)
			elseif w[i]["type"] == 3 and curw ~= tonumber(w[i]["id"]) then
				local bone = GetPedBoneIndex(ped, 24817) 
				local bone2 = GetPedBoneIndex(ped, 11816)
				am[#am+1] = CreateObject(mdl, 1.0 ,1.0 ,1.0, 1, 1, 0)
				-- melee weapons will be placed in specific spots pending on type here, sort of aids but we can have infinite really if they all have a belt spot or w./e
				-- also our item id is not the correct hash, so it fucks up atm. :)
				if w[i]["id"] == "3713923289" and curw ~= -581044007 then
					AttachEntityToEntity(am[#am], ped, bone2, w[i]["z"]-0.53, -0.125, -0.15, w[i]["rx"], w[i]["ry"], w[i]["rz"], 0, 1, 0, 1, 0, 1)
				end
			elseif w[i]["type"] == 4 and not sheathed then
				sheathed = true
				local bone = GetPedBoneIndex(ped, 24817)
				am[#am+1] = CreateObject(katana_model, 1.0 ,1.0 ,1.0, 1, 1, 0)
				AttachEntityToEntity(am[#am], ped, bone, w[i]["z"]-0.4, -0.135, 0.0, w[i]["rx"], w[i]["ry"], w[i]["rz"], 0, 1, 0, 1, 0, 1)
			elseif w[i]["type"] == 5 and curw ~= tonumber(w[i]["id"]) then
				am[#am+1] = CreateObject(mdl, 1.0 ,1.0 ,1.0, 1, 1, 0)
				local bone = GetPedBoneIndex(ped, 28422)
				AttachEntityToEntity(am[#am], ped, bone, 0.05, 0.01, -0.01, w[i]["rx"], w[i]["ry"], w[i]["rz"], 0, 1, 0, 1, 0, 1)
			elseif w[i]["type"] == 6 and curw ~= tonumber(w[i]["id"]) then
				local bone = GetPedBoneIndex(ped, 24817)
				ab[#ab+1] = CreateObject(mdl, 1.0 ,1.0 ,1.0, 1, 1, 0)
				AttachEntityToEntity(ab[#ab], ped, bone, w[i]["z"]-0.7, -0.02, 0.0, w[i]["rx"], w[i]["ry"], w[i]["rz"], 0, 1, 0, 1, 0, 1)
			-- elseif w[i]["type"] == 7 and sheathed then
			-- 	sheathed = false
			-- 	local bone = GetPedBoneIndex(ped, 24817)
			-- 	am[#am+1] = CreateObject(mdl, 1.0 ,1.0 ,1.0, 1, 1, 0)
			-- 	AttachEntityToEntity(am[#am], ped, bone, w[i]["z"]-0.4, -0.135, 0.0, w[i]["rx"], w[i]["ry"], w[i]["rz"], 0, 1, 0, 1, 0, 1)
			end
		end
	end
end)

function loadmodel(mdl)
	RequestModel(mdl)
	local rst = 0
	while not HasModelLoaded(mdl) and rst < 10 do
		Citizen.Wait(100)
		rst = rst + 1
	end
end

function DeleteAttachedKatana()
	for i = 1, #am do
		DeleteEntity(am[i])
	end	
	am = {}
end


function DeleteAttached()
	for i = 1, #ag do
		DeleteEntity(ag[i])
	end
	for i = 1, #ad do
		DeleteEntity(ad[i])
	end	
	for i = 1, #am do
		DeleteEntity(am[i])
	end	
	for i = 1, #ab do
		DeleteEntity(ab[i])
	end	
	ag = {}
	ad = {}
	am = {}
	ab = {}
end

RegisterNetEvent('warp-inventory:delete_attach_items')
AddEventHandler('warp-inventory:delete_attach_items', function()
	DeleteAttached()
end)

exports('GetAttachedBag', function()
	return ab[1] and ab[1] or 0
end)