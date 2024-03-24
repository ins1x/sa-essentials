--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'RenderWare'
shared.require 'CVehicle'
shared.require 'CColPoint'
shared.require 'CEntity'
shared.require 'CRideAnimData'
shared.require 'matrix'
shared.require 'vector3d'

shared.ffi.cdef[[
	typedef enum eBikeNodes
	{
		BIKE_NODE_NONE = 0,
		BIKE_CHASSIS = 1,
		BIKE_FORKS_FRONT = 2,
		BIKE_FORKS_REAR = 3,
		BIKE_WHEEL_FRONT = 4,
		BIKE_WHEEL_REAR = 5,
		BIKE_MUDGUARD = 6,
		BIKE_HANDLEBARS = 7,
		BIKE_MISC_A = 8,
		BIKE_MISC_B = 9,
		BIKE_NUNODES
	} eBikeNodes;

	typedef struct CBike : CVehicle
	{
		RwFrame       	*pBikeNodes[BIKE_NUNODES];
    bool          	bLeanMatrixCalculated;
    char 						_pad0[3];
    matrix        	mLeanMatrix;
    unsigned char  	nDamageFlags;
    char 						field_615[27];
    vector3d 				field_630;
    void          	*pBikeHandlingData;
    CRideAnimData  	rideAnimData;
    unsigned char  	anWheelDamageState[2];
    char 						field_65E;
    char 						field_65F;
    CColPoint      	anWheelColPoint[4];
    float 					field_710[4];
    float 					field_720[4];
    float 					field_730[4];
    float 					field_740;
    int            	anWheelSurfaceType[2];
    char 						field_74C[2];
    char 						field_74E[2];
    float          	afWheelRotationX[2];
    float 					fWheelSpeed[2];
    float 					field_760;
    float 					field_764;
    float 					field_768;
    float 					field_76C;
    float 					field_770[4];
    float 					field_780[4];
    float          	fHeightAboveRoad;
    float          	fCarTraction;
    float 					field_798;
    float 					field_79C;
    float 					field_7A0;
    float 					field_7A4;
    short 					field_7A8;
    char 						field_7AA[2];
    int 						field_7AC;
    int 						field_7B0;
    bool           	bPedLeftHandFixed;
    bool           	bPedRightHandFixed;
    char 						field_7B6[2];
    int 						field_7B8;
    int 						field_7BC;
    CEntity       	*apWheelCollisionEntity[4];
    vector3d        avTouchPointsLocalSpace[4];
    CEntity       	*pDamager;
    unsigned char  	nNumContactWheels;
    unsigned char  	nNumWheelsOnGround;
    char 						field_806;
    char 						field_807;
    int 						field_808;
    unsigned int   	anWheelState[2];
	} CBike;
]]

shared.validate_size('CBike', 0x814)
