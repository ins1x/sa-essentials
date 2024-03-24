--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'vector3d'

shared.ffi.cdef[[
	typedef struct tFlyingHandlingData
	{
		int 				nVehicleId;
		float 			fThrust;
		float 			fThrustFallOff;
		float 			fYaw;
		float 			fYawStab;
		float 			fSideSlip;
		float 			fRoll;
		float 			fRollStab;
		float 			fPitch;
		float 			fPitchStab;
		float 			fFormLift;
		float 			fAttackLift;
		float 			fGearUpR;
		float 			fGearDownL;
		float 			fWindMult;
		float 			fMoveRes;
		vector3d 		vecTurnRes;
		vector3d 		vecSpeedRes;
	} tFlyingHandlingData;
]]

shared.validate_size('tFlyingHandlingData', 0x58)
