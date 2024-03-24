--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'CAESound'
shared.require 'CAEAudioEntity'
shared.require 'CAETwinLoopSoundEntity'

shared.ffi.cdef[[
	typedef struct CPed CPed;

	typedef struct CAEPedAudioEntity : CAEAudioEntity
	{
		char 						field_7C;
    char 						field_7D;
    short 					field_7E;
    int 						field_80;
    float 					field_84;
    float 					field_88;
    char 						field_8C[8];
    CPed 						*pPed;
    char 						field_98;
    char 						field_99[3];
    CAESound 				*field_9C;
    int 						field_A0;
    CAESound 				*field_A4;
		CAETwinLoopSoundEntity nTwinLoopSoundEntity;
    CAESound 				*field_150;
    float 					field_154;
    float 					field_158;
	} CAEPedAudioEntity;
]]

shared.validate_size('CAEPedAudioEntity', 0x15C)
