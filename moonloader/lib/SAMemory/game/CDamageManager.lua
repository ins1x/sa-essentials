--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.ffi.cdef[[
	typedef enum eDamageState
	{
		DAMSTATE_OK = 0,
		DAMSTATE_OPENED = 1,
		DAMSTATE_DAMAGED = 2,
		DAMSTATE_OPENED_DAMAGED = 3,
		DAMSTATE_NOTPRESENT = 4
	} eDamageState;

	typedef enum eComponent
	{
		COMPONENT_WHEEL_LF = 1,
		COMPONENT_WHEEL_RF = 2,
		COMPONENT_WHEEL_LR = 3,
		COMPONENT_WHEEL_RR = 4,
		COMPONENT_BONNET = 5,
		COMPONENT_BOOT = 6,
		COMPONENT_DOOR_LF = 7,
		COMPONENT_DOOR_RF = 8,
		COMPONENT_DOOR_LR = 9,
		COMPONENT_DOOR_RR = 10,
		COMPONENT_WING_LF = 11,
		COMPONENT_WING_RF = 12,
		COMPONENT_WING_LR = 13,
		COMPONENT_WING_RR = 14,
		COMPONENT_WINDSCREEN = 15,
		COMPONENT_BUMP_FRONT = 16,
		COMPONENT_BUMP_REAR = 17
	} eComponent;

	typedef enum eComponentGroup
	{
		COMPGROUP_PANEL = 0,
		COMPGROUP_WHEEL = 1,
		COMPGROUP_DOOR = 2,
		COMPGROUP_BONNET = 3,
		COMPGROUP_BOOT = 4,
		COMPGROUP_LIGHT = 5,
		COMPGROUP_NA = 6
	} eComponentGroup;

	typedef enum eWheels
	{
		WHEEL_FRONT_LEFT = 0,
		WHEEL_REAR_LEFT = 1,
		WHEEL_FRONT_RIGHT = 2,
		WHEEL_REAR_RIGHT = 3
	} eWheels;

	typedef enum ePanels
	{
		WING_FRONT_LEFT = 0,
		WING_FRONT_RIGHT = 1,
		WINDSCREEN = 4,
		BUMP_FRONT = 5,
		BUMP_REAR = 6
	} ePanels;

	typedef enum eDoors
	{
		BONNET = 0,
		BOOT = 1,
		DOOR_FRONT_LEFT = 2,
		DOOR_FRONT_RIGHT = 3,
		DOOR_REAR_LEFT = 4,
		DOOR_REAR_RIGHT = 5
	} eDoors;

	typedef enum eLights
	{
		LIGHT_FRONT_LEFT = 0,
		LIGHT_FRONT_RIGHT = 1,
		LIGHT_REAR_RIGHT = 2,
		LIGHT_REAR_LEFT = 3
	} eLights;

	typedef struct CDamageManager
	{
		float 				fWheelDamageEffect;
		unsigned char nEngineStatus;
		union
		{
			unsigned char anWheelsStatus[4];
			struct
			{
				unsigned char nRightRearWheelsStatus;
				unsigned char nRightFrontWheelsStatus;
				unsigned char nLeftRearWheelsStatus;
				unsigned char nLeftFrontWheelsStatus;
			};
		};
		union
		{
			unsigned char anDoorsStatus[6];
			struct
			{
				unsigned char nBonnetStatus;
				unsigned char nBootStatus;
				unsigned char nLeftFrontDoorStatus;
				unsigned char nRightFrontDoorStatus;
				unsigned char nLeftRearDoorStatus;
				unsigned char nRightRearDoorStatus;
			};
		};
		union
		{
			unsigned int nLightsStatus;
			struct
			{
				unsigned int nLeftFrontLightStatus : 2;
				unsigned int nRightFrontLightStatus : 2;
				unsigned int nRightRearLightStatus : 2;
				unsigned int nLeftRearLightStatus : 2;
			};
		};
		unsigned int nPanelsStatus;
	} CDamageManager;
]]

shared.validate_size('CDamageManager', 0x18)
