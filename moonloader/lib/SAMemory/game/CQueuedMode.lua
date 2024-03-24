--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.ffi.cdef[[
	typedef struct CQueuedMode
	{
		unsigned short nMode;
		float 				 fDuration;
		unsigned short nMinZoom;
		unsigned short nMaxZoom;
	} CQueuedMode;
]]

shared.validate_size('CQueuedMode', 0xC)
