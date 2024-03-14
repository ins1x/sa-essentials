script_name('Vehicle Material Color Example')
local mad = require 'MoonAdditions'

function main()
	while true do
		wait(0)
		if isPlayerPlaying(PLAYER_HANDLE) then
			if isCharInAnyCar(PLAYER_PED) and testCheat('RESPRAY') then
				local car = storeCarCharIsInNoSave(PLAYER_PED)
				local new_r, new_g, new_b = math.random(0, 255), math.random(0, 255), math.random(0, 255)
				for_each_vehicle_material(car, function(mat)
					local r, g, b, a = mat:get_color()
					if (r == 0x3C and g == 0xFF and b == 0x00) or (r == 0xFF and g == 0x00 and b == 0xAF) then
						mat:set_color(new_r, new_g, new_b, a)
					end
				end)
			end
		end
	end
end

function for_each_vehicle_material(car, func)
	for _, comp in ipairs(mad.get_all_vehicle_components(car)) do
		for _, obj in ipairs(comp:get_objects()) do
			for _, mat in ipairs(obj:get_materials()) do
				func(mat)
			end
		end
	end
end
