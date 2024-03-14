script_name('Draw Shape Example')
local mad = require 'MoonAdditions'

function main()
	local circle = mad.shape.new()
	build_polygon(circle, 100, 100, 70, 100, 200, 0, 0, 200)
	while true do
		wait(0)
		circle:draw(mad.primitive_type.TRIANGLEFAN, true, mad.blend_method.SRCCOLOR, mad.blend_method.SRCCOLOR)
	end
end

function build_polygon(shape, x, y, c, size, r, g, b, alpha)
	shape:add_vertex(x, y, r, g, b, alpha)
	size = size / 2
	local a = 0
	local delta = math.pi * 2 / c
	for i = 0, c do
		a = a + delta
		local cx = x + math.cos(a) * size
		local cy = y + math.sin(a) * size
		g = 255 - g
		shape:add_vertex(cx, cy, r, g, b, alpha)
	end
end
