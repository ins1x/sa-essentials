script_name('AntiCarJack')
script_author('FYP')
script_moonloader(022)
script_description('Get the latest MoonLoader updates from http://blast.hk/moonloader/')
local sampev = require 'lib.samp.events'


--- Config
enabled = true
cheatActivate = 'ACJ'


--- Main
function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end

	while true do
		wait(10)
		if isPlayerPlaying(playerHandle) and testCheat(cheatActivate) then
			enabled = not enabled
			printStringNow('AntiCarJack ' .. (activated and '~g~activated' or '~r~deactivated') .. '.~n~~y~Made by FYP~n~~w~blast.hk', 2000)
		end
	end
end


--- Events
function sampev.onVehicleSync(playerId, vehicleId, data)
	if enabled and is_player_stealing_my_vehicle(playerId, vehicleId) then
		if not warningMsgTick or gameClock() - warningMsgTick > 3 then
			sampfuncsLog(string.format('Player %s(%d) tried to hijack your car!',  sampGetPlayerNickname(playerId), playerId))
			warningMsgTick = gameClock()
		end
		lua_thread.create(take_vehicle_back, vehicleId)
		return false -- skip packet
	end
end

function sampev.onPlayerEnterVehicle(playerId, vehicleId, passenger)
	if enabled and is_player_stealing_my_vehicle(playerId, vehicleId) then
		return false -- skip RPC
	end
end


--- Functions
function take_vehicle_back(vehicleId)
	sampSendExitVehicle(vehicleId)
	wait(0)
	sampForceOnfootSync()
	wait(0)
	sampSendEnterVehicle(vehicleId, false)
	wait(15)
	sampForceVehicleSync(vehicleId)
end

function is_player_stealing_my_vehicle(playerId, vehicleId)
	if isCharInAnyCar(playerPed) and sampIsPlayerConnected(playerId) then
		local _, myVehId = sampGetVehicleIdByCarHandle(storeCarCharIsInNoSave(playerPed))
		return myVehId == vehicleId
	end
	return false
end
