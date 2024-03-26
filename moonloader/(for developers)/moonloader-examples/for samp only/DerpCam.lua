script_name('DerpCam')
script_author('FYP')
script_moonloader(020)
script_description('Get the latest MoonLoader updates from http://blast.hk/moonloader/')
local sampev = require 'lib.samp.events'


--- Config
cheatActivate = 'DCA'


--- Main
function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end

	while true do
		wait(10)
		if isPlayerPlaying(playerHandle) and isCharOnFoot(playerPed) and testCheat(cheatActivate) then
			activated = not activated
			printStringNow('DerpCam ' .. (activated and '~g~activated' or '~r~deactivated') .. '.~n~~y~Made by FYP~n~~w~blast.hk', 2000)
		end
	end
end


--- Events
function sampev.onSendAimSync(data)
	-- HACK!
	if activated and isCharShooting(playerPed) then
		data.camMode = g_cammode == true and 45 or 34
		g_cammode = not g_cammode
	end
end
