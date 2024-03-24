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
	typedef struct CStoredCollPoly
	{
		vector3d     aMeshVertices[3];
		bool         bIsActual;
		unsigned int nLighting;
	} CStoredCollPoly;
]]

shared.validate_size('CStoredCollPoly', 0x2C)
