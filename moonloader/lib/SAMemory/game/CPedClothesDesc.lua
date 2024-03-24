--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]
local shared = require 'SAMemory.shared'

shared.ffi.cdef[[
	typedef struct CPedClothesDesc
	{
		unsigned int anModelKeys[10];
		unsigned int anTextureKeys[18];
		float fFatStat;
		float fMuscleStat;
	} CPedClothesDesc;
]]

shared.validate_size('CPedClothesDesc', 0x78)
