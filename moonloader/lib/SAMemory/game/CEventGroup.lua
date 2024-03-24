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
	typedef struct CEventGroup
	{
		void        	*vptr;
		CPed          *pPed;
		unsigned int  dwCount;
		void          *apEvents[16];
	} CEventGroup;
]]

shared.validate_size('CEventGroup', 0x4C)
