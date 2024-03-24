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
	typedef struct CEventHandler
	{
		CPed *pPed;
		int field_4;
		int field_8;
		int field_C;
		int field_10;
		int field_14;
		int field_18;
		char field_1C;
		char field_1D;
		short field_1E;
		int field_20;
		int field_24;
		int field_28;
		int field_2C;
		int field_30;
	} CEventHandler;
]]

shared.validate_size('CEventHandler', 0x34)
