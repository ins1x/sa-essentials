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
	typedef struct CPlayerPed : CPed
	{
		CPed 		*pPlayerTargettedPed;
		int 		field_7A0;
	} CPlayerPed;
]]

shared.validate_size('CPlayerPed', 0x7A4)
