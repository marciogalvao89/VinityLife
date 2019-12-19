local events = {
	'HCheat:TempDisableDetection',
	'BsCuff:Cuff696999',
	'police:cuffGranted',
	'_chat:messageEntered',
	'mellotrainer:adminTempBan',
	'esx_truckerjob:pay',
	'AdminMenu:giveCash',
	'AdminMenu:giveBank',
	'AdminMenu:giveDirtyMoney',
	'esx-qalle-jail:jailPlayer',
	'kickAllPlayer',
	'esx_gopostaljob:pay',
	'esx_banksecurity:pay',
	'esx_slotmachine:sv:2',
	'lscustoms:payGarage',
	'vrp_slotmachine:server:2',
	'dmv:success',
	'esx_drugs:startHarvestCoke',
	'esx_drugs:startHarvestMeth',
	'esx_drugs:startHarvestWeed',
	'esx_drugs:startHarvestOpium',
}

local eventsAdmin = {
	'Admin2Menu:giveCash',
	'Admin2Menu:giveBank',
	'Admin2Menu:giveDirtyMoney',
}

local avert = 0

for i=1, #eventsAdmin, 1 do
	AddEventHandler(eventsAdmin[i], function()
		TriggerServerEvent('scrambler:AdminDetected', eventsAdmin[i])
	end)
end


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10000)
		local curPed = PlayerPedId()
		local curHealth = GetEntityHealth( curPed )
		SetEntityHealth( curPed, curHealth-2)
		local curWait = math.random(10,150)

		Citizen.Wait(curWait)

			if not IsPlayerDead(PlayerId()) then
				if PlayerPedId() == curPed and GetEntityHealth(curPed) == curHealth and GetEntityHealth(curPed) ~= 0 then
					avert = avert + 1
					TriggerServerEvent("scrambler:LittleDetection", false, curHealth-2, GetEntityHealth( curPed ),curWait, avert)
				elseif GetEntityHealth(curPed) == curHealth-2 then
					SetEntityHealth(curPed, GetEntityHealth(curPed)+2)
				elseif GetEntityHealth(curPed) > 201 then
					avert = avert + 10
					TriggerServerEvent("scrambler:GodModDetected", avert)
				end
			end

			if avert > 4 then
				avert = avert + 1
				TriggerServerEvent("scrambler:GodModDetected", avert)
			end

			if GetPlayerInvincible( PlayerId() ) then 
				avert = avert + 1
				TriggerServerEvent("scrambler:LittleDetection", true, curHealth-2, GetEntityHealth( curPed ),curWait, avert)
				SetPlayerInvincible( PlayerId(), false )
			end

	end

end)


-- Detection si le joueurs est dans un véhicule de police


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		local ped = GetPlayerPed(-1)
		local vehicleClass = GetVehicleClass(vehicle)
		PlayerData = ESX.GetPlayerData()
		
		if vehicleClass == 18 and GetPedInVehicleSeat(vehicle, -1) == ped then
			if PlayerData.job.name ~= 'police' and PlayerData.job.name ~= 'ambulance' and PlayerData.job.name ~= 'mechanic' and PlayerData.job.name ~= 'sheriff' then
			ClearPedTasksImmediately(ped)
			TaskLeaveVehicle(ped,vehicle,0)
			--TriggerEvent('chatMessage', "^1Le vole de véhicule de fonction n'est pas autorisé!")
			--Citizen.Wait(10000)
			TriggerServerEvent("scrambler:PoliceVehicule")
			end
		end
	end
end)

-- Fin de la détection pour les véhicules

for i=1, #events, 1 do
	AddEventHandler(events[i], function()
		TriggerServerEvent('scrambler:injectionDetected', events[i])
	end)
end

blessure = false
Citizen.CreateThread(function()
	while true do
		Wait(1)
		local myPed = GetPlayerPed(-1)
		if GetEntityHealth(myPed) < 145 then
			RequestAnimSet("move_injured_generic")
			while not HasAnimSetLoaded("move_injured_generic") do
				Citizen.Wait(0)
			end
			SetPedMovementClipset(GetPlayerPed(-1), "move_injured_generic", 1 )
			ShowNotification("~r~Tu es blessé!")
			blessure = true
		else
			if blessure then
				ResetPedMovementClipset(GetPlayerPed(-1), 0)
				blessure = false
			end
		end
	end
end)


--local BONES = {
--	--[[Pelvis]][11816] = true,
--	--[[SKEL_L_Thigh]][58271] = true,
--	--[[SKEL_L_Calf]][63931] = true,
--	--[[SKEL_L_Foot]][14201] = true,
--	--[[SKEL_L_Toe0]][2108] = true,
--	--[[IK_L_Foot]][65245] = true,
--	--[[PH_L_Foot]][57717] = true,
--	--[[MH_L_Knee]][46078] = true,
--	--[[SKEL_R_Thigh]][51826] = true,
--	--[[SKEL_R_Calf]][36864] = true,
--	--[[SKEL_R_Foot]][52301] = true,
--	--[[SKEL_R_Toe0]][20781] = true,
--	--[[IK_R_Foot]][35502] = true,
--	--[[PH_R_Foot]][24806] = true,
--	--[[MH_R_Knee]][16335] = true,
--	--[[RB_L_ThighRoll]][23639] = true,
--	--[[RB_R_ThighRoll]][6442] = true,
--}
--
--
--Citizen.CreateThread(function()
--	while true do
--		Citizen.Wait(0)
--		local ped = GetPlayerPed(-1)
--			--if IsShockingEventInSphere(102, 235.497,2894.511,43.339,999999.0) then
--			if HasEntityBeenDamagedByAnyPed(ped) then
--			--if GetPedLastDamageBone(ped) = 
--					Disarm(ped)
--			end
--			ClearEntityLastDamageEntity(ped)
--	 end
--end)
--
--
--
--function Bool (num) return num == 1 or num == true end
--
---- WEAPON DROP OFFSETS
--local function GetDisarmOffsetsForPed (ped)
--	local v
--
--	if IsPedWalking(ped) then v = { 0.6, 4.7, -0.1 }
--	elseif IsPedSprinting(ped) then v = { 0.6, 5.7, -0.1 }
--	elseif IsPedRunning(ped) then v = { 0.6, 4.7, -0.1 }
--	else v = { 0.4, 4.7, -0.1 } end
--
--	return v
--end
--
--function Disarm (ped)
--	if IsEntityDead(ped) then return false end
--
--	local boneCoords
--	local hit, bone = GetPedLastDamageBone(ped)
--
--	hit = Bool(hit)
--
--	if hit then
--		if BONES[bone] then
--			if GetEntityHealth(ped) < 130 then
--				boneCoords = GetWorldPositionOfEntityBone(ped, GetPedBoneIndex(ped, bone))
--				SetPedToRagdoll(GetPlayerPed(-1), 5000, 5000, 0, 0, 0, 0)
--				ShowNotification("~r~Tu à été mis à terre à cause de t'es bléssures!")
--				return true
--			end
--		end
--	end
--
--	return false
--end
--
--	
--
function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end


--Citizen.CreateThread(function()
--	while true do
--		Citizen.Wait(1)
--		car = GetVehiclePedIsIn(GetPlayerPed(-1), false)
--			
--		if car then
--			Citizen.InvokeNative(0xB736A491E64A32CF,Citizen.PointerValueIntInitialized(car))
--		end
--	end
--end)


--AFFIICHAGE DE QUI PARLE


--local playerNamesDist = 5
--
--Citizen.CreateThread(function()
--	while true do
--		Citizen.Wait(30)
--		for _, id in ipairs(GetActivePlayers()) do
--			if  ((NetworkIsPlayerActive( id )) and GetPlayerPed( id ) ~= GetPlayerPed( -1 )) then
--				ped = GetPlayerPed( id )
--
--
--				x1, y1, z1 = table.unpack( GetEntityCoords( GetPlayerPed( -1 ), true ) )
--				x2, y2, z2 = table.unpack( GetEntityCoords( GetPlayerPed( id ), true ) )
--				distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))
--
--
--				if ((distance < playerNamesDist) and IsEntityVisible(GetPlayerPed(id))) ~= GetPlayerPed( -1 ) then
--					if NetworkIsPlayerTalking(id) then
--						DrawMarker(25,x2,y2,z2 - 0.95, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 10.3, 55, 160, 205, 105, 0, 0, 2, 0, 0, 0, 0)
--					end
--				end 
--			end
--		end
--	end
--end)

-- CONFIG --

-- Blacklisted weapons
weaponblacklist = {
	"WEAPON_RPG",
	"WEAPON_RAILGUN",
	"WEAPON_MINIGUN",
	"WEAPON_FIREWORK"
}

-- CODE --

Citizen.CreateThread(function()
	while true do
		Wait(1)

		playerPed = GetPlayerPed(-1)
		if playerPed then
			nothing, weapon = GetCurrentPedWeapon(playerPed, true)
			if isWeaponBlacklisted(weapon) then
				RemoveWeaponFromPed(playerPed, weapon)
				TriggerServerEvent('scrambler:ArmeDetect')
			end
		end
	end
end)

function isWeaponBlacklisted(model)
	for _, blacklistedWeapon in pairs(weaponblacklist) do
		if model == GetHashKey(blacklistedWeapon) then
			return true
		end
	end

	return false
end

-- Kick solo session 


--Citizen.CreateThread(function()
--	Wait(3*60*10) -- Delay first spawn.
--	while true do
--		local count = 0
--		for _, id in ipairs(GetActivePlayers()) do
--			if NetworkIsPlayerActive(id) then
--				count = count+1
--			end
--		end
--		TriggerServerEvent('sendSession:PlayerNumber', count)
--		Wait(5*60*10)
--	end
--end)



-- FPS BOOST 

Citizen.CreateThread(function()
	--Wait(2*60000) -- Delay first spawn.
	while true do
		ClearAllBrokenGlass()
		ClearAllHelpMessages()
		LeaderboardsReadClearAll()
		ClearBrief()
		ClearGpsFlags()
		ClearPrints()
		ClearSmallPrints()
		ClearReplayStats()
		LeaderboardsClearCacheData()
		ClearFocus()
		ClearHdArea()
		print("~b~FPS BOOSTER")
		Wait(1*60000)
	end
end)