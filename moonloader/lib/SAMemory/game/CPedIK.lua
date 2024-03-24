--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'CPed'

shared.ffi.cdef[[
	typedef struct CPedIK
	{
		CPed *pPed;
    float TorsoOrien[2];
    float fSlopePitch;
    float fSlopePitchLimitMult;
    float fSlopeRoll;
    float fBodyRoll;
    unsigned int nFlags;
	} CPedIK;
]]

shared.validate_size('CPedIK', 0x20)
