--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local mt = require 'SAMemory.metatype'
local ffi = require 'ffi'

ffi.cdef[[
	typedef struct _vec2d
	{
		float x, y;
	} vector2d;
]]

local function vector2d(x, y)
	return ffi.new('vector2d', x, y)
end

local vec2d = {}

function vec2d:length()
	return math.sqrt(self.x^2 + self.y^2)
end

vec2d.len = vec2d.length
vec2d.magnitude = vec2d.length

local meta = {}

-- operators
function meta:__mul(x)
	return vector2d(self.x * x, self.y * x)
end

function meta:__div(x)
	return vector2d(self.x / x, self.y / y)
end

function meta:__add(v)
	return vector2d(self.x + v.x, self.y + v.y)
end

function meta:__sub(v)
	return vector2d(self.x - v.x, self.y - v.y)
end

function meta:__unm() -- unary minus
	return vector2d(-self.x, -self.y)
end

function meta:__len()
	return self:len()
end

ffi.metatype('vector2d', meta)
mt.provide_access('vector2d', vec2d, true, false)

return {
	new = vector2d;
}
