--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'CAEAudioEntity'

shared.ffi.cdef[[
	typedef struct CAEPoliceScannerAudioEntity : CAEAudioEntity
	{

	} CAEPoliceScannerAudioEntity;
]]

shared.validate_size('CAEPoliceScannerAudioEntity', 0x7C)
