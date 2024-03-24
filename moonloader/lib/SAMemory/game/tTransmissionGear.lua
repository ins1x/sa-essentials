--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.ffi.cdef[[
	typedef struct tTransmissionGear
	{
		float fMaxVelocity;
		float fChangeUpVelocity;
		float fChangeDownVelocity;
	} tTransmissionGear;
]]

shared.validate_size('tTransmissionGear', 0xC)
