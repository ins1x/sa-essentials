--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'CompressedVector'

shared.ffi.cdef[[
	typedef struct CColTrianglePlane
	{
		CompressedVector normal;
		unsigned short 	 nDistance;
		unsigned char 	 nOrientation;
	} CColTrianglePlane;
]]

shared.validate_size('CColTrianglePlane', 0xA)
