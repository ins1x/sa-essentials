--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'CEntity'
shared.require 'CAESound'

shared.ffi.cdef[[
	typedef struct CAEAudioEntity
	{
		void   		**vptr;
		CEntity 	*pEntity;
		CAESound  tempSound;
	} CAEAudioEntity;
]]

shared.validate_size('CAEAudioEntity', 0x7C)
