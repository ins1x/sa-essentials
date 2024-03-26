script_name("setWeather&Time")
script_description("/sw - change weather, /st - change time")
script_version_number(2)
script_version("v.002")
script_authors("hnnssy", "FYP")
script_dependencies('SAMP v0.3.7')


--- Main
function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end

  sampRegisterChatCommand("st", cmdSetTime)
  sampRegisterChatCommand("sw", cmdSetWeather)
  while true do
    wait(0)
    if time then
      setTimeOfDay(time, 0)
    end
  end
end


--- Callbacks
function cmdSetTime(param)
  local hour = tonumber(param)
  if hour ~= nil and hour >= 0 and hour <= 23 then
    time = hour
    patch_samp_time_set(true)
  else
    patch_samp_time_set(false)
    time = nil
  end
end

function cmdSetWeather(param)
  local weather = tonumber(param)
  if weather ~= nil and weather >= 0 and weather <= 45 then
    forceWeatherNow(weather)
  end
end


--- Functions
function patch_samp_time_set(enable)
	if enable and default == nil then
		default = readMemory(sampGetBase() + 0x9C0A0, 4, true)
		writeMemory(sampGetBase() + 0x9C0A0, 4, 0x000008C2, true)
	elseif enable == false and default ~= nil then
		writeMemory(sampGetBase() + 0x9C0A0, 4, default, true)
		default = nil
	end
end
