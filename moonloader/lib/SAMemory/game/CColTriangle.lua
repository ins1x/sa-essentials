--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.ffi.cdef[[
	typedef struct CColTriangle
	{
		unsigned short nVertA;
		unsigned short nVertB;
		unsigned short nVertC;
		unsigned char  nMaterial;
		unsigned char  nLight;
	} CColTriangle;
]]

shared.validate_size('CColTriangle', 8)
