--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'vector3d'

shared.ffi.cdef[[
	typedef struct CSimpleTransform
	{
		vector3d 	vPosition;
		float 		fHeading;
	} CSimpleTransform;
]]

shared.validate_size('CSimpleTransform', 0x10)
