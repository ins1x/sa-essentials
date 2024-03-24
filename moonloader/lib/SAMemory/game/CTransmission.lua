--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'tTransmissionGear'

shared.ffi.cdef[[
	typedef struct CTransmission
	{
		tTransmissionGear aGears[6];
		unsigned char nDriveType;
		unsigned char nEngineType;
		unsigned char nNumberOfGears;
		char field_4B;
		unsigned int  nHandlingFlags;
		float         fEngineAcceleration;
		float         fEngineInertia;
		float         fMaxGearVelocity;
		int field_5C;
		float         fMinGearVelocity;
		float         fCurrentSpeed;
	} CTransmission;
]]

shared.validate_size('CTransmission', 0x68)
