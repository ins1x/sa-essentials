--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

require 'SAMemory.game.vector3d'
require 'SAMemory.game.RenderWare'

local mt = require 'SAMemory.metatype'
local ffi = require 'ffi'

ffi.cdef[[
	typedef struct _quaternion
	{
		vector3d imag;
		float 	 real;
	} quaternion;
]]

local function quaternion(imag, real)
	return ffi.new('quaternion', imag, real)
end

-- thx plugin-sdk
local quat = {
	dot_product	 = ffi.cast('void ( __thiscall * )( void *, quaternion const & )', 0x4CFA00);
	set_matrix 	 = ffi.cast('void ( __thiscall * )( void *, RwMatrix const & )', 0x59C3E0);
	normalize		 = ffi.cast('void ( __thiscall * )( void * )', 0x4D1610);
	slerp				 = ffi.cast('void ( __thiscall * )( void *, quaternion const &, quaternion const &, float )', 0x59C630);
	copy 				 = ffi.cast('void ( __thiscall * )( void *, quaternion const & )', 0x4CF9E0);
}

function quat:get_matrix()
	local out_mat = ffi.new('RwMatrix *')
	ffi.cast('void ( __thiscall * )( void *, RwMatrix * )', 0x59C080)(self, out_mat)
	return out_mat
end

quat.DotProduct = quat.dot_product
quat.SetMatrix  = quat.set_matrix
quat.GetMatrix  = quat.get_matrix

mt.provide_access('quaternion', quat, true, false)

return {
	new = quaternion;
}
