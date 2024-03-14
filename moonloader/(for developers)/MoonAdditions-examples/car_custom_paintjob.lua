script_name('Vehicle Material Texture Example')
local mad = require 'MoonAdditions'

function main()
	local pj_texture = assert(mad.load_png_texture(getWorkingDirectory() .. '/resource/texture/example/my_paintjob.png'))
	while true do
		wait(0)
		if isPlayerPlaying(PLAYER_HANDLE) then
			if isCharInAnyCar(PLAYER_PED) and testCheat('MYPJ') then
				local car = storeCarCharIsInNoSave(PLAYER_PED)
				local new_r, new_g, new_b = math.random(0, 255), math.random(0, 255), math.random(0, 255)
				for_each_vehicle_material(car, function(mat)
					local tex = mat:get_texture()
					if tex ~= nil and string.sub(tex.name, 1, 1) == '#' then
						mat:set_texture(pj_texture)
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
