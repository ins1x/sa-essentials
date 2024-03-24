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
	typedef struct CColLine
	{
		vector3d vecStart;
		float field_C;
		vector3d vecEnd;
		float field_1C;
	} CColLine;
]]

shared.validate_size('CColLine', 0x20)
