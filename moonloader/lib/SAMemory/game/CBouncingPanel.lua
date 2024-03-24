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
	typedef struct CBouncingPanel
	{
		unsigned short 	nFrameId;
		unsigned short 	nAxis;
		float          	fAngleLimit;
		vector3d        vRotation;
		vector3d        vPos;
	} CBouncingPanel;
]]

shared.validate_size('CBouncingPanel', 0x20)
