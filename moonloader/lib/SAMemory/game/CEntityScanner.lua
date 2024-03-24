--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'CEntity'

shared.ffi.cdef[[
	typedef struct CEntityScanner
	{
		void 						*vptr;
		int 						field_4;
		unsigned int   	nCount;
		CEntity		 			*apEntities[16];
		int 						field_4C;
	} CEntityScanner;
]]

shared.validate_size('CEntityScanner', 0x50)
