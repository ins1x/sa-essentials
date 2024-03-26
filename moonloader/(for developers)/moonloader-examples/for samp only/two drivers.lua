script_name('TwoDriversHack')
script_author('FYP')
script_moonloader(021)
script_description('Get the latest MoonLoader updates from http://blast.hk/moonloader/')
require 'lib.moonloader'


--- Config
keysActivate = {VK_X, VK_N}


--- Main
function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end

	while true do
		wait(10)
		if isPlayerPlaying(playerHandle) and not isCharDead(playerPed) and is_key_check_available() and is_keycombo_pressed(keysActivate) then
			local playerId = find_nearest_driving_player_onscreen(getCharCoordinates(playerPed))
			if playerId ~= nil then
				local _, pedHandle = sampGetCharHandleBySampPlayerId(playerId)
				if isCharInAnyCar(playerPed) then
					local carHandle = storeCarCharIsInNoSave(pedHandle)
					remove_ped_from_car(pedHandle)
					wait(0)
					warpCharIntoCar(playerPed, carHandle)
					restoreCameraJumpcut()
				elseif isCharOnFoot(playerPed) then
					local carHandle = storeCarCharIsInNoSave(pedHandle)
					local seat = get_car_free_passenger_seat(carHandle)
					if seat ~= nil then
						remove_ped_from_car(pedHandle)
						local _, carId = sampGetVehicleIdByCarHandle(carHandle)
						warpCharIntoCarAsPassenger(playerPed, carHandle, seat)
						for i = 1, 10 do
							sampForcePassengerSyncSeatId(carId, seat)
							wait(20)
						end
						warpCharIntoCar(playerPed, carHandle)
						restoreCameraJumpcut()
					end
				end
			end
		end
	end
end


--- Functions
function remove_ped_from_car(ped)
	local posx, posy, posz = getCharCoordinates(ped)
	posz = posz - 4
	warpCharFromCarToCoord(ped, posx, posy, posz)
end

function get_car_free_passenger_seat(car)
  local maxPassengers = getMaximumNumberOfPassengers(car)
  for i = 0, maxPassengers do
    if isCarPassengerSeatFree(car, i) then
      return i
    end
  end
  return nil
end

function find_nearest_driving_player_onscreen(x, y, z)
	local ped = find_nearest_ped(x, y, z,
		function(handle)
			local result, playerId = sampGetPlayerIdByCharHandle(handle)
			return isCharInAnyCar(handle) and isCharOnScreen(handle) and result
		end)
	if ped == nil then return nil end
	local _, playerId = sampGetPlayerIdByCharHandle(ped)
	return playerId
end

function find_nearest_ped(x, y, z, pred)
	local dist, near = nil, nil
	local found, handle = findAllRandomCharsInSphere(x, y, z, 1000.0, false, true)
	while found do
		if pred(handle) then
			local posx, posy, posz = getCharCoordinates(handle)
			dist = getDistanceBetweenCoords3d(x, y, z, posx, posy, posz)
			near = handle
		end
		found, handle = findAllRandomCharsInSphere(x, y, z, 1000.0, true, true)
	end
	return near
end

function is_keycombo_pressed(keys)
  for i = 1, #keys - 1 do
    if not isKeyDown(keys[i]) then return false end
  end
  return wasKeyPressed(keys[#keys])
end

function is_key_check_available()
  if not isSampfuncsLoaded() then
    return not isPauseMenuActive()
  end
  local result = not isSampfuncsConsoleActive() and not isPauseMenuActive()
  if isSampLoaded() and isSampAvailable() then
    result = result and not sampIsChatInputActive() and not sampIsDialogActive()
  end
  return result
end
