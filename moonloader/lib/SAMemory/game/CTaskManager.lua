--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'CTask'
shared.require 'CPed'

shared.ffi.cdef[[
	typedef struct CTaskManager
	{
		CTask *aPrimaryTasks[5];
    CTask *aSecondaryTasks[6];
    CPed  *pPed;
	} CTaskManager;
]]

shared.validate_size('CTaskManager', 0x30)
