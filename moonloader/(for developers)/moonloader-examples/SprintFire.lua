script_name('SprintFire')
script_author('FYP')
script_description('Get the latest MoonLoader updates from http://blast.hk/moonloader/')


--- Main
function main()
	while true do
		wait(0)
		if isPlayerPlaying(playerHandle) and isCharOnFoot(playerPed) and not isCharInAir(playerPed) then
			if isButtonPressed(playerHandle, 16) -- sprint
			and isButtonPressed(playerHandle, 6) -- aim
			then
				local weap = getCurrentCharWeapon(playerPed)
				local slot = getWeapontypeSlot(weap)
				if slot >= 2 and slot <= 8 then
					while isButtonPressed(playerHandle, 6) do
						wait(0)
						setGameKeyState(16, 0)
					end
				end
			end
		end
	end
end
