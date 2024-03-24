--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'matrix'

shared.ffi.cdef[[
	typedef struct CPlaceable CPlaceable;

	typedef struct CMatrixLink : matrix
	{
		CPlaceable 				 *pOwner;
		struct CMatrixLink *pPrev;
		struct CMatrixLink *pNext;
	} CMatrixLink;
]]

shared.validate_size('CMatrixLink', 0x54)
