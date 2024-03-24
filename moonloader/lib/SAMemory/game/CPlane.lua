--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'RenderWare'
shared.require 'CAutomobile'
shared.require 'FxSystem_c'

shared.ffi.cdef[[
	typedef struct CPlane : CAutomobile
	{
		float 				field_988;
		int 					field_98C;
		int 					field_990;
		int 					field_994;
		float 				field_998;
		int 					field_99C;
		int 					field_9A0;
		int 					field_9A4;
		float 				field_9A8;
		float 				field_9AC;
		float 				field_9B0;
		float 				field_9B4;
		int 					field_9B8;
		int 					field_9BC;
		unsigned int 	nStartedFlyingTime;
		int 					field_9C4;
		float 				field_9C8;
		float 				fLandingGearStatus;
		int 					field_9D0;
		FxSystem_c 		**pGunParticles;
		unsigned char nFiringMultiplier;
		int 					field_9DC;
		int 					field_9E0;
		int 					field_9E4;
		FxSystem_c 		*apJettrusParticles[4];
		FxSystem_c 		*pSmokeParticle;
		unsigned int 	nSmokeTimer;
		bool 					bSmokeEjectorEnabled;
		char 					_pad[3];
	} CPlane;
]]

shared.validate_size('CPlane', 0xA04)
