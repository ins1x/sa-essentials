--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'CBike'

shared.ffi.cdef[[
	typedef struct CBmx : CBike
	{
		float 				field_814;
		float 				field_818;
		float 				field_81C;
		float 				field_820;
		float 				field_824;
		float 				field_828;
		float 				fDistanceBetweenWheels;
		float 				fWheelsBalance;
		unsigned char field_834;
		char _pad[3];
	} CBmx;
]]

shared.validate_size('CBmx', 0x838)
