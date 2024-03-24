--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared  = require 'SAMemory.shared'

shared.require 'RenderWare'

shared.ffi.cdef[[
	typedef struct CColBox : RwBBox
	{
		unsigned char nMaterial;
		unsigned char nFlags;
		unsigned char nLighting;
		unsigned char nLight;
	} CColBox;
]]

shared.validate_size('CColBox', 0x1C)
