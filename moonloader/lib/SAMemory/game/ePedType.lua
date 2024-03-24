--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.ffi.cdef[[
	typedef enum ePedType
	{
		PED_TYPE_PLAYER1,
		PED_TYPE_PLAYER2,
		PED_TYPE_PLAYER_NETWORK,
		PED_TYPE_PLAYER_UNUSED,
		PED_TYPE_CIVMALE,
		PED_TYPE_CIVFEMALE,
		PED_TYPE_COP,
		PED_TYPE_GANG1,
		PED_TYPE_GANG2,
		PED_TYPE_GANG3,
		PED_TYPE_GANG4,
		PED_TYPE_GANG5,
		PED_TYPE_GANG6,
		PED_TYPE_GANG7,
		PED_TYPE_GANG8,
		PED_TYPE_GANG9,
		PED_TYPE_GANG10,
		PED_TYPE_DEALER,
		PED_TYPE_MEDIC,
		PED_TYPE_FIREMAN,
		PED_TYPE_CRIMINAL,
		PED_TYPE_BUM,
		PED_TYPE_PROSTITUTE,
		PED_TYPE_SPECIAL,
		PED_TYPE_MISSION1,
		PED_TYPE_MISSION2,
		PED_TYPE_MISSION3,
		PED_TYPE_MISSION4,
		PED_TYPE_MISSION5,
		PED_TYPE_MISSION6,
		PED_TYPE_MISSION7,
		PED_TYPE_MISSION8
	} ePedType;
]]
