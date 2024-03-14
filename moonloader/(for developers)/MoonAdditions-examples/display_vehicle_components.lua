script_name('Display Vehicle Components Example')
local mad = require 'MoonAdditions'

function main()
	while true do
		wait(0)
		if isPlayerPlaying(PLAYER_HANDLE) then
			if isCharInAnyCar(PLAYER_PED) then
				local car = storeCarCharIsInNoSave(PLAYER_PED)
				local components = mad.get_all_vehicle_components(car)
				for i, comp in ipairs(components) do
					draw_component(comp, i)
				end
			end
		end
	end
end

function draw_component(component, id)
	local x, y, z = component.matrix.pos:get()
	local sx, sy = convert3DCoordsToScreen(x, y, z)
	draw_text(string.format('Component #%d: ~y~%s', id, component.name), sx, sy, 255, 255, 255)
	sx = sx + 4
	-- draw objects
	local objs = component:get_objects()
	for i, obj in ipairs(objs) do
		local mats = obj:get_materials()
		sy = sy + 12
		draw_text('Object #' .. i .. ' total materials: ~y~' .. #mats, sx, sy, 255, 255, 255)
		-- draw materials
		sx = sx + 4
		for i, mat in ipairs(mats) do
			local tex = mat:get_texture()
			local tex_name = tex and ('~b~~h~~h~' .. tex.name) or '~r~no texture'
			sy = sy + 12
			draw_text('Material #' .. i .. ' texture: ' .. tex_name, sx, sy, 255, 255, 255)
		end
		sx = sx - 4
	end
end

function draw_text(str, x, y, r, g, b)
	mad.draw_text(str, x, y, mad.font_style.SUBTITLES, 0.3, 0.6, mad.font_align.LEFT, 2000, true, false, r, g, b, 255, 1, 0, 30, 30, 30, 120)
end
