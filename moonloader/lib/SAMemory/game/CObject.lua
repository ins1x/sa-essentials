--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'CPhysical'
shared.require 'CObjectInfo'
shared.require 'RenderWare'

shared.ffi.cdef[[
	typedef enum eObjectType
	{
		OBJECT_MISSION = 2,
		OBJECT_TEMPORARY = 3,
		OBJECT_MISSION2 = 6
	} eObjectType;

	typedef struct CObject : CPhysical
	{
		void            *pControlCodeList;
		unsigned char   nObjectType;
		unsigned char   nBonusValue;
		unsigned short  wCostValue;
		struct
		{
			unsigned int b01 : 1;
			unsigned int b02 : 1;
			unsigned int bPickupPropertyForSale : 1;
			unsigned int bPickupInShopOutOfStock : 1;
			unsigned int bGlassBroken : 1;
			unsigned int b06 : 1;
			unsigned int bIsExploded : 1;
			unsigned int b08 : 1;

			unsigned int bIsLampPost : 1;
			unsigned int bIsTargatable : 1;
			unsigned int bIsBroken : 1;
			unsigned int bTrainCrossEnabled : 1;
			unsigned int bIsPhotographed : 1;
			unsigned int bIsLiftable : 1;
			unsigned int bIsDoorMoving : 1;
			unsigned int bbIsDoorOpen : 1;

			unsigned int bHasNoModel : 1;
			unsigned int bIsScaled : 1;
			unsigned int bCanBeAttachedToMagnet : 1;
			unsigned int b20 : 1;
			unsigned int b21 : 1;
			unsigned int b22 : 1;
			unsigned int bFadingIn : 1;
			unsigned int bAffectedByColBrightness : 1;

			unsigned int b25 : 1;
			unsigned int bDoNotRender : 1;
			unsigned int bFadingIn2 : 1;
			unsigned int b28 : 1;
			unsigned int b29 : 1;
			unsigned int b30 : 1;
			unsigned int b31 : 1;
			unsigned int b32 : 1;
		} nObjectFlags;
		unsigned char   nColDamageEffect;
		unsigned char   nStoredColDamageEffect;
		char field_146;
		char            nGarageDoorGarageIndex;
		unsigned char   nLastWeaponDamage;
		unsigned char   nDayBrightness : 4;
		unsigned char   nNightBrightness : 4;
		short           nRefModelIndex;
		unsigned char   nCarColor[4];
		int             dwRemovalTime;
		float           fHealth;
		float           fDoorStartAngle;
		float           fScale;
		CObjectInfo     *pObjectInfo;
		void            *pFire;
		short           wScriptTriggerIndex;
		short           wRemapTxd;
		RwTexture       *pRemapTexture;
		unsigned int    *pDummyObject;
		int             dwBurnTime;
		float           fBurnDamage;
	} CObject;
]]

shared.validate_size('CObject', 0x17C)
