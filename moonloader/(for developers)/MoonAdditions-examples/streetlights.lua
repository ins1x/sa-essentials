script_name('Spotlight Example')
local mad = require 'MoonAdditions'

function main()
	while true do
		wait(0)
		if isPlayerPlaying(PLAYER_HANDLE) then
			local x, y, z = getCharCoordinates(PLAYER_PED)
			for _, object in ipairs(mad.get_all_objects(x, y, z, 300)) do
				local model = getObjectModel(object)
				if model == 1226 and getObjectHealth(object) > 0 then
					local matrix = mad.get_object_matrix(object)
					if matrix then
						local objx, objy, objz = matrix:get_coords_with_offset(-1.3, 0.165, 3.69)
						local ground_z = getGroundZFor3dCoord(objx, objy, objz)
						mad.draw_spotlight(objx, objy, objz, objx, objy, ground_z, 0.065, 27)
					end
				end
			end
		end
	end
end
