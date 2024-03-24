--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'CTaskTimer'
shared.require 'CAttractorScanner'

shared.ffi.cdef[[
	typedef struct CEventScanner
	{
		int field_0;
		CTaskTimer field_4;
		CTaskTimer field_10;
		CAttractorScanner m_attractorScanner;
		CTaskTimer field_AC;
		char field_B8;
		char field_B9;
		char field_BA;
		char field_BB;
		CTaskTimer field_BC;
		CTaskTimer field_C8;
	} CEventScanner;
]]

shared.validate_size('CEventScanner', 0xD4)
