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
	typedef struct CCrimeBeingQd
	{
		unsigned int nCrimeType;
		unsigned int nCrimeID;
		unsigned int nTimeOfQing;
		vector3d     vecCoors;
		bool         bAlreadyReported;
		bool         bPoliceDontReallyCare;
		char 				 _pad1A[2];
	} CCrimeBeingQd;
]]

shared.validate_size('CCrimeBeingQd', 0x1C)
