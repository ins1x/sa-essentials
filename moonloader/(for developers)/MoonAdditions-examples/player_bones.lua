script_name('Display Player Bones Example')
local mad = require 'MoonAdditions'

function main()
	while true do
		wait(0)
		if isPlayerPlaying(PLAYER_HANDLE) then
			if isCharOnFoot(PLAYER_PED) and not isCharDead(PLAYER_PED) then
				local color_b = 255
				for name, id in pairs(mad.bone_id) do
					local bone = mad.get_char_bone(PLAYER_PED, id)
					if bone then
						local bone_pos = bone.matrix.pos
						local sx, sy = convert3DCoordsToScreen(bone_pos.x, bone_pos.y, bone_pos.z)
						draw_text('#' .. id .. ': ' .. name, sx, sy, 255, 255, math.fmod(id, 2) == 1 and 255 or 120)
					end
				end
			end
		end
	end
end

function draw_text(str, x, y, r, g, b)
	mad.draw_text(str, x, y, mad.font_style.SUBTITLES, 0.3, 0.6, mad.font_align.LEFT, 2000, true, false, r, g, b, 255, 1, 0, 30, 30, 30, 120)
end
