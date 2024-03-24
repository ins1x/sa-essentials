--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'vector3d'
shared.require 'CVehicle'
shared.require 'CEntity'

shared.ffi.cdef[[
	typedef struct CNodeAddress
	{
		short wAreaId;
		short wNodeId;
	} CNodeAddress;

	typedef struct CCarPathLinkAddress
	{
		short wCarPathLinkId : 10;
		short wAreaId : 6;
	} CCarPathLinkAddress;

	typedef struct CAutoPilot
	{
		CNodeAddress         currentAddress;
		CNodeAddress         startingRouteNode;
		CNodeAddress field_8;
		int field_C;
		unsigned int         nSpeedScaleFactor;
		CCarPathLinkAddress  nCurrentPathNodeInfo;
		CCarPathLinkAddress  nNextPathNodeInfo;
		CCarPathLinkAddress  nPreviousPathNodeInfo;
		char field_1A[2];
		unsigned int         nTimeToStartMission;
		unsigned int         nTimeSwitchedToRealPhysics;
		char field_24;
		char _smthCurr;
		char _smthNext;
		char                 nCurrentLane;
		char                 nNextLane;
		char                 nCarDrivingStyle;
		char                 nCarMission;
		char                 nTempAction;
		unsigned int         nTempActionTime;
		unsigned int _someStartTime;
		char field_34;
		char field_35;
		char field_36[2];
		float field_38;
		float                fMaxTrafficSpeed;
		char nCruiseSpeed;
		char field_41;
		char field_42[2];
		float field_44;
		char field_48[1];
		char field_49;
		char field_4A;
		unsigned char        nCarCtrlFlags;
		char field_4C;
		char                 nStraightLineDistance;
		char field_4E;
		char field_4F;
		char field_50;
		char field_51;
		char field_52[10];
		vector3d              vecDestinationCoors;
		CNodeAddress         aPathFindNodesInfo[8];
		unsigned short       nPathFindNodesCount;
		char field_8A[2];
		struct CVehicle      *pTargetCar;
		struct CEntity       *pCarWeMakingSlowDownFor;
		char field_94;
		char field_95;
		short field_96;
	} CAutoPilot;
]]

shared.validate_size('CAutoPilot', 0x98)
