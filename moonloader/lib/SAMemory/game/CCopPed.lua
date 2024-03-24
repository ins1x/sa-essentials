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
	typedef enum eCopType
	{
		COP_TYPE_CITYCOP,
		COP_TYPE_LAPDM1,
		COP_TYPE_SWAT1,
		COP_TYPE_SWAT2,
		COP_TYPE_FBI,
		COP_TYPE_ARMY,
		COP_TYPE_CSHER = 7
	} eCopType;

	typedef struct CCopPed CCopPed;

	struct CCopPed : CPed
	{
		int 					field_79C;
		unsigned int  copType;
    int 					field_7A4;
		CCopPed       *pCopPartner;
		CPed          *apCriminalsToKill[5];
		char 					field_7C0;
	};
]]

shared.validate_size('CCopPed', 0x7C4)
