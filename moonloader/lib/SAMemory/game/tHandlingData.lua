--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'eVehicleHandlingModelFlags'
shared.require 'eVehicleHandlingFlags'
shared.require 'vector3d'
shared.require 'CTransmission'

shared.ffi.cdef[[
	typedef enum eVehicleLightsSize
	{
		LIGHTS_LONG,
		LIGHTS_SMALL,
		LIGHTS_BIG,
		LIGHTS_TALL
	} eVehicleLightsSize;

	typedef struct tHandlingData
	{
		int           	nVehicleId;
		float         	fMass;
		float 					field_8;
		float         	fTurnMass;
		float         	fDragMult;
		vector3d       	vecCentreOfMass;
		unsigned char 	nPercentSubmerged;
		float         	fBuoyancyConstant;
		float         	fTractionMultiplier;
		CTransmission 	transmissionData;
		float         	fBrakeDeceleration;
		float         	fBrakeBias;
		char          	bABS;
		char 						field_9D;
		char 						field_9E;
		char 						field_9F;
		float         	fSteeringLock;
		float         	fTractionLoss;
		float         	fTractionBias;
		float         	fSuspensionForceLevel;
		float         	fSuspensionDampingLevel;
		float         	fSuspensionHighSpdComDamp;
		float         	fSuspensionUpperLimit;
		float         	fSuspensionLowerLimit;
		float         	fSuspensionBiasBetweenFrontAndRear;
		float         	fSuspensionAntiDiveMultiplier;
		float         	fCollisionDamageMultiplier;
		union
		{
			eVehicleHandlingModelFlags nModelFlags;
			struct
			{
				unsigned int bIsVan : 1;
				unsigned int bIsBus : 1;
				unsigned int bIsLow : 1;
				unsigned int bIsBig : 1;
				unsigned int bReverseBonnet : 1;
				unsigned int bHangingBoot : 1;
				unsigned int bTailgateBoot : 1;
				unsigned int bNoswingBoot : 1;
				unsigned int bNoDoors : 1;
				unsigned int bTandemSeats : 1;
				unsigned int bSitInBoat : 1;
				unsigned int bConvertible : 1;
				unsigned int bNoExhaust : 1;
				unsigned int bDoubleExhaust : 1;
				unsigned int bNo1fpsLookBehind : 1;
				unsigned int bForceDoorCheck : 1;
				unsigned int bAxleFNotlit : 1;
				unsigned int bAxleFSolid : 1;
				unsigned int bAxleFMcpherson : 1;
				unsigned int bAxleFReverse : 1;
				unsigned int bAxleRNotlit : 1;
				unsigned int bAxleRSolid : 1;
				unsigned int bAxleRMcpherson : 1;
				unsigned int bAxleRReverse : 1;
				unsigned int bIsBike : 1;
				unsigned int bIsHeli : 1;
				unsigned int bIsPlane : 1;
				unsigned int bIsBoat : 1;
				unsigned int bBouncePanels : 1;
				unsigned int bDoubleRwheels : 1;
				unsigned int bForceGroundClearance : 1;
				unsigned int bIsHatchback : 1;
			};
		};
		union
		{
			eVehicleHandlingFlags nHandlingFlags;
			struct
			{
				unsigned int b1gBoost : 1;
				unsigned int b2gBoost : 1;
				unsigned int bNpcAntiRoll : 1;
				unsigned int bNpcNeutralHandl : 1;
				unsigned int bNoHandbrake : 1;
				unsigned int bSteerRearwheels : 1;
				unsigned int bHbRearwheelSteer : 1;
				unsigned int bAltSteerOpt : 1;
				unsigned int bWheelFNarrow2 : 1;
				unsigned int bWheelFNarrow : 1;
				unsigned int bWheelFWide : 1;
				unsigned int bWheelFWide2 : 1;
				unsigned int bWheelRNarrow2 : 1;
				unsigned int bWheelRNarrow : 1;
				unsigned int bWheelRWide : 1;
				unsigned int bWheelRWide2 : 1;
				unsigned int bHydraulicGeom : 1;
				unsigned int bHydraulicInst : 1;
				unsigned int bHydraulicNone : 1;
				unsigned int bNosInst : 1;
				unsigned int bOffroadAbility : 1;
				unsigned int bOffroadAbility2 : 1;
				unsigned int bHalogenLights : 1;
				unsigned int bProcRearwheelFirst : 1;
				unsigned int bUseMaxspLimit : 1;
				unsigned int bLowRider : 1;
				unsigned int bStreetRacer : 1;
				unsigned int bSwingingChassis : 1;
			};
		};
		float              fSeatOffsetDistance;
		unsigned int       nMonetaryValue;
		unsigned char 		 nFrontLights;
		unsigned char 		 nRearLights;
		unsigned char      nAnimGroup;
	} tHandlingData;
]]

shared.validate_size('tHandlingData', 0xE0)
