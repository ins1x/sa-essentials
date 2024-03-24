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
	typedef struct CColDisk
	{
		vector3d vecStart;
		float fStartRadius;
		unsigned char nMaterial;
		unsigned char nPiece;
		unsigned char nLighting;
		char _pad13;
		vector3d VecEnd;
		float fEndRadius;
	} CColDisk;
]]

shared.validate_size('CColDisk', 0x24)
