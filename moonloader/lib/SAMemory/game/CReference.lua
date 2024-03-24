--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.ffi.cdef[[
	typedef struct CEntity 		CEntity;
	typedef struct CReference CReference;

	struct CReference
	{
		CReference *pNext;
		CEntity    **ppEntity;
	};
]]

shared.validate_size('CReference', 8)
