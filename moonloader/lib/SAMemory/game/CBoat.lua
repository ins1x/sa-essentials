--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'vector2d'
shared.require 'RenderWare'
shared.require 'CVehicle'
shared.require 'CEntity'
shared.require 'CDoor'
shared.require 'FxSystem_c'
shared.require 'tBoatHandlingData'
shared.require 'vector3d'

shared.ffi.cdef[[
	typedef enum eBoatNodes
	{
		BOAT_NODE_NONE = 0,
		BOAT_MOVING = 1,
		BOAT_WINDSCREEN = 2,
		BOAT_RUDDER = 3,
		BOAT_FLAP_LEFT = 4,
		BOAT_FLAP_RIGHT = 5,
		BOAT_REARFLAP_LEFT = 6,
		BOAT_REARFLAP_RIGHT = 7,
		BOAT_STATIC_PROP = 8,
		BOAT_MOVING_PROP = 9,
		BOAT_STATIC_PROP_2 = 10,
		BOAT_MOVING_PROP_2 = 11,
		BOAT_NUM_NODES
	} eBoatNodes;

	typedef struct CBoat : CVehicle
	{
		float              fMovingHiRotation;
		float              fPropSpeed;
		float              fPropRotation;
		struct
		{
			unsigned char bOnWater : 1;
			unsigned char bMovingOnWater : 1;
			unsigned char bAnchored : 1;
		} nBoatFlags;
		char 								_pad5AD[3];
		RwFrame            	*pBoatNodes[12];
		CDoor              	boatFlap;
		tBoatHandlingData 	*pBoatHandling;
		float              	fAnchoredAngle;
		int                	nAttackPlayerTime;
		int 								field_604;
		float              	fBurningTimer;
		CEntity           	*pWhoDestroyedMe;
		vector3d            vBoatMoveForce;
		vector3d            vBoatTurnForce;
		FxSystem_c        	*apPropSplashFx[2];
		vector3d            vWaterDamping;
		char 								field_63C;
		unsigned char      	nPadNumber;
		char 								_pad63E[2];
		float              	fWaterResistance;
		short              	nNumWaterTrailPoints;
		char 								_pad646[2];
		vector2d          	avWakePoints[32];
		float              	afWakePointLifeTime[32];
		unsigned char      	anWakePointIntensity[32];
	} CBoat;
]]

shared.validate_size('CBoat', 0x7E8)
