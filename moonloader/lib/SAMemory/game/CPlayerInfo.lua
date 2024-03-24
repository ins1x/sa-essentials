--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'CVehicle'
shared.require 'CPlayerData'
shared.require 'CPed'
shared.require 'vector2d'

shared.ffi.cdef[[
	typedef struct CPlayerInfo
	{
		CPed 							*pPed;
		CPlayerData 			nPlayerData;
		CVehicle 					*pRemoteVehicle;
		CVehicle 					*pSpecCar;
		int 							nMoney;
		int 							nDisplayMoney;
		unsigned int 			nCollectablesPickedUp;
		unsigned int 			nTotalNumCollectables;
		unsigned int 			nLastBumpPlayerCarTimer;
		unsigned int 			nTaxiTimer;
		unsigned int 			nVehicleTimeCounter;
		bool 							bTaxiTimerScore;
		bool 							bTryingToExitCar;
		char 							_pad0[2];
		CVehicle 					*pLastTargetVehicle;
		unsigned char			nPlayerState;
		bool 							bAfterRemoteVehicleExplosion;
		bool 							bCreateRemoteVehicleExplosion;
		bool 							bFadeAfterRemoteVehicleExplosion;
		unsigned int 			nTimeOfRemoteVehicleExplosion;
		unsigned int 			nLastTimeEnergyLost;
		unsigned int 			nLastTimeArmourLost;
		unsigned int 			nLastTimeBigGunFired;
		unsigned int 			nTimesUpsideDownInARow;
		unsigned int 			nTimesStuckInARow;
		unsigned int 			nCarTwoWheelCounter;
		float							fCarTwoWheelDist;
		unsigned int 			nCarLess3WheelCounter;
		unsigned int 			nBikeRearWheelCounter;
		float 						fBikeRearWheelDist;
		unsigned int 			nBikeFrontWheelCounter;
		float							fBikeFrontWheelDist;
		unsigned int 			nTempBufferCounter;
		unsigned int 			nBestCarTwoWheelsTimeMs;
		float 						fBestCarTwoWheelsDistM;
		unsigned int 			nBestBikeWheelieTimeMs;
		float 						fBestBikeWheelieDistM;
		unsigned int 			nBestBikeStoppieTimeMs;
		float 						fBestBikeStoppieDistM;
		unsigned short 		nCarDensityForCurrentZone;
		char 							_pad1[2];
		float 						fRoadDensityAroundPlayer;
		unsigned int 			nTimeOfLastCarExplosionCaused;
		unsigned int 			nExplosionMultiplier;
		unsigned int 			nHavocCaused;
		unsigned short 		nNumHoursDidntEat;
		char 							_pad2[2];
		float 						fCurrentChaseValue;
		bool 							bDoesNotGetTired;
		bool 							bFastReload;
		bool 							bFireProof;
		unsigned char			nMaxHealth;
		unsigned char			nMaxArmour;
		bool 							bGetOutOfJailFree;
		bool 							bFreeHealthCare;
		bool 							bCanDoDriveBy;
		unsigned char			nBustedAudioStatus;
		char 							_pad3;
		unsigned short 		nLastBustMessageNumber;
		unsigned int 			nCrosshairActivated;
		vector2d 						vecCrosshairTarget;
		char 							szSkinName[32];
		RwTexture 				*pSkinTexture;
		bool 							bParachuteReferenced;
		char 							_pad4[3];
		unsigned int 			nRequireParachuteTimer;
	} CPlayerInfo;
]]

shared.validate_size('CPlayerInfo', 0x190)
