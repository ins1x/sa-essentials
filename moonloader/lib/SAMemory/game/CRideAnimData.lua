--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.ffi.cdef[[
	typedef struct CRideAnimData
	{
		unsigned int nAnimGroup;
		int 				 dword4;
		float        fAnimLean;
		int 				 dwordC;
		float 			 dword10;
		float        fHandlebarsAngle;
		float        fAnimPercentageState;
	} CRideAnimData;
]]

shared.validate_size('CRideAnimData', 0x1C)
