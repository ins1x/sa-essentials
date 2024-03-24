--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'CAEAudioEntity'
shared.require 'CAESound'

shared.ffi.cdef[[
	typedef struct CAETwinLoopSoundEntity : CAEAudioEntity
	{
		short           nBankSlotId;
    short           nSoundType[2];
    char 						_pad1[2];
    CAEAudioEntity  *pBaseAudio;
    short 					field_88;
    short 					field_8A;
    short 					field_8C;
    short           nPlayTimeMin;
    short           nPlayTimeMax;
    char 						_pad2[2];
    unsigned int    nTimeToSwapSounds;
    bool            bPlayingFirstSound;
    char 						_pad3;
    short           anStartingPlayPercentage[2];
    short 					field_9E;
    CAESound        *apSounds[2];
	} CAETwinLoopSoundEntity;
]]

shared.validate_size('CAETwinLoopSoundEntity', 0xA8)
