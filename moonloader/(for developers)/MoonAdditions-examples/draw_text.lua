script_name('Draw Text Example')
local mad = require 'MoonAdditions'

function main()
	-- create clock textdraw
	-- once created textdraw will be visible until it became destroyed or hidden
	local clock_textdraw = mad.textdraw.new('Test', 10, 350)
	clock_textdraw.style = mad.font_style.PRICEDOWN
	clock_textdraw.width = 0.4
	clock_textdraw.height = 0.82
	clock_textdraw.outline = 0
	clock_textdraw.shadow = 1
	clock_textdraw.background = true
	clock_textdraw.wrap = 175
	clock_textdraw:set_text_color(160, 81, 151, 250)
	clock_textdraw:set_background_color(240, 240, 240, 120)
	clock_textdraw:set_shadow_color(30, 30, 30, 60)
	while true do
		wait(0)
		clock_textdraw.text = 'System Time: ' .. os.date("%X")
		if isPlayerPlaying(PLAYER_HANDLE) then
			if not isCharDead(PLAYER_PED) then
				local hp_str = string.format('~w~Health: ~r~%d~n~~w~Armor: ~g~%d', getCharHealth(PLAYER_PED), getCharArmour(PLAYER_PED))
				-- 'draw_text' displays text once for a frame
				mad.draw_text(hp_str, 10, 372, mad.font_style.MENU, 0.4, 0.9, mad.font_align.LEFT, 640, true, false, 255, 255, 255, 255, 0, 1)
			end
		end
	end
end
