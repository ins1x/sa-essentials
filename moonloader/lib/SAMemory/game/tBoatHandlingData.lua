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
	typedef struct tBoatHandlingData
	{
		int 			nVehicleId;
		float 		fThrustY;
		float 		fThrustZ;
		float 		fThrustAppZ;
		float 		fAqPlaneForce;
		float 		fAqPlaneLimit;
		float 		fAqPlaneOffset;
		float 		fWaveAudioMult;
		float 		fLookLRBehindCamHeight;
		vector3d 	vecMoveRes;
		vector3d 	vecTurnRes;
	} tBoatHandlingData;
]]

shared.validate_size('tBoatHandlingData', 0x3C)
