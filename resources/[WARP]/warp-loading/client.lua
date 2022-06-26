
local spawn1 = false

AddEventHandler("warp-base:spawnInitialized", function()
	if not spawn1 then
		ShutdownLoadingScreenNui()
		spawn1 = true
	end
end)

--TriggerEvent("warp-base:playerSpawned")