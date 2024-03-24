--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.ffi.cdef[[
	typedef struct CTaskTimer
	{
		int  	nStartTime;
		int  	nInterval;
		bool 	bStarted;
		bool 	bStopped;
		char 	_pad[2];
	} CTaskTimer;
]]

shared.validate_size('CTaskTimer', 0xC)
