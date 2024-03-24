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
shared.require 'CPed'
shared.require 'CDoor'

shared.ffi.cdef[[
	typedef enum eTrainNodes
	{
		TRAIN_NODE_NONE = 0,
		TRAIN_DOOR_LF = 1,
		TRAIN_DOOR_RF = 2,
		TRAIN_WHEEL_RF1 = 3,
		TRAIN_WHEEL_RF2 = 4,
		TRAIN_WHEEL_RF3 = 5,
		TRAIN_WHEEL_RB1 = 6,
		TRAIN_WHEEL_RB2 = 7,
		TRAIN_WHEEL_RB3 = 8,
		TRAIN_WHEEL_LF1 = 9,
		TRAIN_WHEEL_LF2 = 10,
		TRAIN_WHEEL_LF3 = 11,
		TRAIN_WHEEL_LB1 = 12,
		TRAIN_WHEEL_LB2 = 13,
		TRAIN_WHEEL_LB3 = 14,
		TRAIN_BOGIE_FRONT = 15,
		TRAIN_BOGIE_REAR = 16,
		TRAIN_NUNODES
	} eTrainNodes;

	typedef enum eTrainPassengersGenerationState
	{
		TRAIN_PASSENGERS_QUERY_NUPASSENGERS_TO_LEAVE = 0,
		TRAIN_PASSENGERS_TELL_PASSENGERS_TO_LEAVE = 1,
		TRAIN_PASSENGERS_QUERY_NUPASSENGERS_TO_ENTER = 2,
		TRAIN_PASSENGERS_TELL_PASSENGERS_TO_ENTER = 3,
		TRAIN_PASSENGERS_GENERATION_FINISHED = 4
	} eTrainPassengersGenerationState;

	typedef struct CTrain CTrain;

	struct CTrain : CVehicle
	{
		short             nNodeIndex;
    char 							_pad1[2];
    float             fTrainSpeed;
    float             fCurrentRailDistance;
    float             fLength;
    float             fTrainGas;
    float             fTrainBrake;
    struct
		{
			unsigned char b01 : 1;
      unsigned char bStoppedAtStation : 1;
      unsigned char bPassengersCanEnterAndLeave : 1;
      unsigned char bIsFrontCarriage : 1;
      unsigned char bIsLastCarriage : 1;
      unsigned char bMissionTrain : 1;
      unsigned char bClockwiseDirection : 1;
      unsigned char bStopsAtStations : 1;
      unsigned char bNotOnARailRoad : 1;
      unsigned char bForceSlowDown : 1;
      unsigned char bIsStreakModel : 1;
    } nTrainFlags;
    char 							_pad5BA[2];
    int               nTimeWhenStoppedAtStation;
    char              nTrackId;
    char 							_pad5C1[3];
    int               nTimeWhenCreated;
    short 						field_5C8;
    unsigned char     nPassengersGenerationState;
    unsigned char     nNumPassengersToLeave : 4;
    unsigned char     nNumPassengersToEnter : 4;
    CPed              *pTemporaryPassenger;
    CTrain            *pPrevCarriage;
    CTrain            *pNextCarriage;
    CDoor             aDoors[6];
    RwFrame           *aTrainNodes[TRAIN_NUNODES];
	};
]]

shared.validate_size('CTrain', 0x6AC)
