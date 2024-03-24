--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'CDamageManager'
shared.require 'CEntity'
shared.require 'CDoor'
shared.require 'CBouncingPanel'
shared.require 'CColPoint'
shared.require 'CVehicle'
shared.require 'vector3d'

shared.ffi.cdef[[
	typedef enum eCarNodes
	{
		CAR_NODE_NONE = 0,
		CAR_CHASSIS = 1,
		CAR_WHEEL_RF = 2,
		CAR_WHEEL_RM = 3,
		CAR_WHEEL_RB = 4,
		CAR_WHEEL_LF = 5,
		CAR_WHEEL_LM = 6,
		CAR_WHEEL_LB = 7,
		CAR_DOOR_RF = 8,
		CAR_DOOR_RR = 9,
		CAR_DOOR_LF = 10,
		CAR_DOOR_LR = 11,
		CAR_BUMP_FRONT = 12,
		CAR_BUMP_REAR = 13,
		CAR_WING_RF = 14,
		CAR_WING_LF = 15,
		CAR_BONNET = 16,
		CAR_BOOT = 17,
		CAR_WINDSCREEN = 18,
		CAR_EXHAUST = 19,
		CAR_MISC_A = 20,
		CAR_MISC_B = 21,
		CAR_MISC_C = 22,
		CAR_MISC_D = 23,
		CAR_MISC_E = 24,
		CAR_NUNODES
	} eCarNodes;

	typedef struct CAutomobile : CVehicle
	{
		CDamageManager 		damageManager;
    CDoor 						doors[6];
    RwFrame 					*pCarNodes[CAR_NUNODES];
    CBouncingPanel 		panels[3];
    CDoor 						swingingChassis;
    CColPoint 				wheelColPoint[4];
    float 						wheelsDistancesToGround1[4];
    float 						wheelsDistancesToGround2[4];
    float 						field_7F4[4];
    float 						field_800;
    float 						field_804;
    float 						field_80C;
    int 							field_810[4];
    char 							field_81C[4];
    int 							field_820;
    float 						fWheelRotation[4];
    float 						field_838[4];
    float 						fWheelSpeed[4];
    int 							field_858[4];
    char 							taxiAvaliable;
    char 							field_869;
    char 							field_86A;
    char 							field_867;
    short 						wMiscComponentAngle;
    short 						wVoodooSuspension;
    int 							dwBusDoorTimerEnd;
    int 							dwBusDoorTimerStart;
    float 						field_878;
    float 						wheelOffsetZ[4];
    int 							field_88C[3];
    float 						fFrontHeightAboveRoad;
    float 						fRearHeightAboveRoad;
    float	 						fCarTraction;
    float 						fNitroValue;
    int 							field_8A4;
    int 							fRotationBalance;
    float							fMoveDirection;
    int 							field_8B4[6];
    int 							field_8C8[6];
    int 							dwBurnTimer;
    CEntity 					*pWheelCollisionEntity[4];
    vector3d 					vWheelCollisionPos[4];
    char 							field_924;
    char 							field_925;
    char 							field_926;
    char 							field_927;
    char 							field_928;
    char 							field_929;
    char 							field_92A;
    char 							field_92B;
    char 							field_92C;
    char 							field_92D;
    char 							field_92E;
    char 							field_92F;
    char 							field_930;
    char 							field_931;
    char 							field_932;
    char 							field_933;
    char 							field_934;
    char 							field_935;
    char 							field_936;
    char 							field_937;
    char 							field_938;
    char 							field_939;
    char 							field_93A;
    char 							field_93B;
    char 							field_93C;
    char 							field_93D;
    char 							field_93E;
    char 							field_93F;
    int 							field_940;
    int 							field_944;
    float 						fDoomVerticalRotation;
    float 						fDoomHorizontalRotation;
    float 						fForcedOrientation;
    float 						fUpDownLightAngle[2];
    unsigned char 		nNumContactWheels;
    unsigned char 		nWheelsOnGround;
    char 							field_962;
    char 							field_963;
    float 						field_964;
    int 							field_968[4];
    void 							*pNitroParticle[2];
    char 							field_980;
    char 							field_981;
    short 						field_982;
    float 						field_984;
	} CAutomobile;
]]

shared.validate_size('CAutomobile', 0x988)
