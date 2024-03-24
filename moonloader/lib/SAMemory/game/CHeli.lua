--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'vector3d'
shared.require 'CAutomobile'
shared.require 'FxSystem_c'

shared.ffi.cdef[[
	typedef struct CHeli : CAutomobile
	{
		char               nHeliFlags;
		char 							 _pad1[3];
		float              fLeftRightSkid;
		float              fSteeringUpDown;
		float              fSteeringLeftRight;
		float              fAccelerationBreakStatus;
		int 							 field_99C;
		float              fRotorZ;
		float              fSecondRotorZ;
		float              fMaxAltitude;
		float 						 field_9AC;
		float              fMinAltitude;
		int 							 field_9B4;
		char 							 field_9B8;
		char               nNumSwatOccupants;
		char               anSwatIDs[4];
		char 							 _pad2[2];
		int 							 field_9C0[4];
		int	 							 field_9D0;
		FxSystem_c         **pParticlesList;
		char 							 field_9D8[24];
		int 							 field_9F0;
		vector3d           vSearchLightTarget;
		float              fSearchLightIntensity;
		int 							 field_A04;
		int 							 field_A08;
		FxSystem_c         **ppGunflashFx;
		char               nFiringMultiplier;
		char               bSearchLightEnabled;
		char 							 _pad3[2];
		float 						 field_A14;
	} CHeli;
]]

shared.validate_size('CHeli', 0xA18)
