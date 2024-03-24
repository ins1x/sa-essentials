--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local mt = require 'SAMemory.metatype'
local ffi = require 'ffi'

local FLT_EPSILON = 0.0001

local function is_near_zero(x)
	return math.abs(x) < FLT_EPSILON
end

ffi.cdef[[
	typedef struct _vec3d
	{
		float x, y, z;
	} vector3d;
]]

local function vector3d(x, y, z)
	return ffi.new('vector3d', x, y, z)
end

local vec3d = {}

function vec3d:set(x, y, z)
	self.x, self.y, self.z = x, y, z
end

function vec3d:length()
	return math.sqrt(self.x^2 + self.y^2 + self.z^2)
end

vec3d.len = vec3d.length
vec3d.magnitude = vec3d.length

function vec3d:normalize()
	local len = self:length()
	self.x = self.x / len
	self.y = self.y / len
	self.z = self.z / len
end

vec3d.normalise = vec3d.normalize

function vec3d:zeroNearZero()
	if is_near_zero(self.x) then self.x = 0 end
	if is_near_zero(self.y) then self.y = 0 end
	if is_near_zero(self.z) then self.z = 0 end
end

vec3d.zero_near_zero = vec3d.zeroNearZero

function vec3d:dotProduct(v)
	return self.x * v.x + self.y * v.y + self.z * v.z
end

vec3d.dot_product = vec3d.dotProduct

function vec3d:crossProduct(v)
	self.x = self.y * v.z - v.y * self.z
	self.y = self.z * v.x - v.z * self.x
	self.z = self.x * v.y - v.x * self.y
end

vec3d.cross_product = vec3d.crossProduct

function vec3d:distanceToPoint(point)
	local diff = point - self
	return diff:length()
end

vec3d.distance2point = vec3d.distanceToPoint

local meta = {}

-- operators
function meta:__mul(x)
	return vector3d(self.x * x, self.y * x, self.z * x)
end

function meta:__add(v)
	return vector3d(self.x + v.x, self.y + v.y, self.z + v.z)
end

function meta:__sub(v)
	return vector3d(self.x - v.x, self.y - v.y, self.z - v.z)
end

function meta:__unm() -- unary minus
	return vector3d(-self.x, -self.y, -self.z)
end

function meta:__len()
	return self:len()
end

ffi.metatype('vector3d', meta)
mt.provide_access('vector3d', vec3d, true, false)

return {
	new = vector3d;
}
