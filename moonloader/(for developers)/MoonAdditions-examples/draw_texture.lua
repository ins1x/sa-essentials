script_name('Textures Example')
local mad = require 'MoonAdditions'

function main()
	local textures_path = getWorkingDirectory() .. '/resource/texture/example/'
	local dds_texture = assert(mad.load_dds_texture(textures_path .. 'example_dds.dss'))
	local png_texture = assert(mad.load_png_texture(textures_path .. 'example_png.png'))
	local bmp_texture = assert(mad.load_bmp_texture_with_mask(textures_path .. 'example_bmp.bmp', textures_path .. 'example_bmp_a.bmp'))
	local txd = assert(mad.load_txd(getWorkingDirectory() .. '/resource/txd/example/example_txd.txd'))
	local texture_from_txd = assert(txd:get_texture('example_txd'))
	while true do
		wait(0)
		local resx, resy = getScreenResolution()
		local x, y = 120, 120
		local width, height = resx - 120 * 2, resy - 120 * 2
		mad.draw_rect_with_gradient(x, y, x + width, y + height, --[[1]] 220, 220, 220, 240, --[[2]] 128, 158, 182, 240, --[[3]] 220, 220, 220, 240, --[[4]] 220, 220, 220, 240)

		local tex_w = (width - 20 * 3) / 2
		local tex_h = (height - 30 * 3) / 2
		function display_texture(tex, x, y)
			tex:draw(x, y, x + tex_w, y + tex_h)
			mad.draw_text(tex.name, x, y + tex_h + 2)
		end

		display_texture(png_texture, x + 20, y + 20)
		display_texture(bmp_texture, x + tex_w + 20 + 20, y + 20)
		display_texture(dds_texture, x + 20, y + tex_h + 20 + 30)
		display_texture(texture_from_txd, x + tex_w + 20 + 20, y + tex_h + 20 + 30)
	end
end
