script_name('InCar Pickup')
script_author('FYP')
script_version_number(1)
script_description('Get the latest MoonLoader updates from http://blast.hk/moonloader/')

require 'lib.moonloader'


--- Config
press_to_enable = false
key_activate = VK_SHIFT

--- Main
function main()
	if not press_to_enable then
		install_pickup_patch(true)
	end
	while true do
		wait(0)
		if isPlayerPlaying(PLAYER_HANDLE) then
			if isKeyDown(key_activate) then
				install_pickup_patch(press_to_enable)
				while isKeyDown(key_activate) do
					wait(0)
				end
				install_pickup_patch(not press_to_enable)
			end
		end
	end
end

function install_pickup_patch(enable)
	if (enable and pickup_patch_active) or (not enable and not pickup_patch_active) then
		return
	end
	if not pickup_patch_data then pickup_patch_data = '\x90\x90\x90\x90\x90\x90' end
	pickup_patch_data = patch_create(0x004577F9, pickup_patch_data)
	pickup_patch_active = enable
end

--- Events
function onExitScript()
	install_pickup_patch(false)
end

--- Functions
function patch_create(address, data)
	local orig = {}
	for i = 1, #data do
		local v = readMemory(address + i - 1, 1, true)
		table.insert(orig, string.char(v))
		writeMemory(address + i - 1, 1, data:byte(i), true)
	end
	return table.concat(orig)
end
