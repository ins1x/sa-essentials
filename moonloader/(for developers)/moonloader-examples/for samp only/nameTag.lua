script_name("nameTag")
script_description("alt + F3 to turn on/off")
script_version_number(3)
script_version("v.003")
script_authors("hnnssy")
local mem = require "memory"


--- Main
function main()
	if not isSampfuncsLoaded() or not isSampLoaded() then return end
	while true do
		wait(0)
		if isKeyDown(18) and isKeyJustPressed(114) then -- ALT+F3
			nameTagOn()
			--sampAddChatMessage("on", 0xFFFF00)
			repeat
			wait(0)
			if isKeyDown(119) then
				nameTagOff()
				wait(1000)
				nameTagOn()
			end
			until isKeyDown(18) and isKeyJustPressed(114)
			while isKeyDown(18) or isKeyDown(114) do
			wait(10)
			end
			nameTagOff()
			--sampAddChatMessage("off", 0xFFFF00)
		end
	end
end

function nameTagOn()
	local pStSet = sampGetServerSettingsPtr()
	NTdist = mem.getfloat(pStSet + 39) -- дальность
	NTwalls = mem.getint8(pStSet + 47) -- видимость через стены
	NTshow = mem.getint8(pStSet + 56) -- видимость тегов
	mem.setfloat(pStSet + 39, 1488.0)
	mem.setint8(pStSet + 47, 0)
	mem.setint8(pStSet + 56, 1)
end

function nameTagOff()
	local pStSet = sampGetServerSettingsPtr()
	mem.setfloat(pStSet + 39, NTdist)
	mem.setint8(pStSet + 47, NTwalls)
	mem.setint8(pStSet + 56, NTshow)
end


--- Events
function onExitScript()
	if NTdist then
		nameTagOff()
	end
end
