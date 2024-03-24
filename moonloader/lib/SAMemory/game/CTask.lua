--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.ffi.cdef[[
	typedef struct CTask CTask;

	struct CTask
	{
		void	*vptr;
		CTask *pParentTask;
	};
]]

shared.validate_size('CTask', 0x8) -- ???
