--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'matrix'
shared.require 'vector3d'

shared.ffi.cdef[[
	typedef enum eFxSystemKillStatus
	{
		FX_NOT_KILLED = 0,
		FX_PLAY_AND_KILL = 1,
		FX_KILLED = 2
	} eFxSystemKillStatus;

	typedef enum eFxSystemPlayStatus
	{
		FX_PLAYING = 0,
		FX_STOPPED = 1
	} eFxSystemPlayStatus;

	typedef struct FxSystem_c
	{
		void 						*pBlueprint;
		matrix 					*pParentMatrix;
		matrix 					localMatrix;
		unsigned char 	nPlayStatus;
		unsigned char 	nKillStatus;
		unsigned char 	bConstTimeSet;
		char 						field_53;
		int 						field_54;
		float 					fCameraDistance;
		unsigned short 	nConstTime;
		unsigned short 	nRateMult;
		unsigned short 	nTimeMult;
		struct
		{
			unsigned char bOwnedParentMatrix: 1;
			unsigned char blocalParticles : 1;
			unsigned char bZTestEnabled : 1;
			unsigned char bUnknown4 : 1;
			unsigned char bUnknown5 : 1;
			unsigned char bMustCreatePtrs : 1;
		} nFlags;
		char 						field_63;
		float 					fUnkRandom;
		vector3d 				vecVelAdd;
		void 						*pBounding;
		void 						**pPrimsPtrList;
		char 						fireAudio[0x88];
	} FxSystem_c;
]]
