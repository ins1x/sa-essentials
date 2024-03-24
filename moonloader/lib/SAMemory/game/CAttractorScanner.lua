--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'C2dEffect'
shared.require 'CTaskTimer'

shared.ffi.cdef[[
	typedef struct CAttractorScanner
	{
		char field_0;
		char _pad[3];
		CTaskTimer field_4;
		C2dEffect *pEffectInUse;
		int field_14;
		int field_18[10];
		int field_40[10];
		int field_68[10];
	} CAttractorScanner;
]]

shared.validate_size('CAttractorScanner', 0x90)
