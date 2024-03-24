--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'RenderWare'
shared.require 'vector2d'
shared.require 'vector3d'

shared.ffi.cdef[[
	typedef enum e2dEffectType
	{
		EFFECT_LIGHT,
		EFFECT_PARTICLE,
		EFFECT_ATTRACTOR = 3,
		EFFECT_SUN_GLARE,
		EFFECT_FURNITUR,
		EFFECT_ENEX,
		EFFECT_ROADSIGN,
		EFFECT_SLOTMACHINE_WHEEL,
		EFFECT_COVER_POINT,
		EFFECT_ESCALATOR,
	} e2dEffectType;

	typedef enum ePedAttractorType
	{
		PED_ATTRACTOR_ATM            = 0,
		PED_ATTRACTOR_SEAT           = 1,
		PED_ATTRACTOR_STOP           = 2,
		PED_ATTRACTOR_PIZZA          = 3,
		PED_ATTRACTOR_SHELTER        = 4,
		PED_ATTRACTOR_TRIGGER_SCRIPT = 5,
		PED_ATTRACTOR_LOOK_AT        = 6,
		PED_ATTRACTOR_SCRIPTED       = 7,
		PED_ATTRACTOR_PARK           = 8,
		PED_ATTRACTOR_STEP           = 9
	} ePedAttractorType;

	typedef struct tEffectLight
	{
		RwColor color;
		float fCoronaFarClip;
		float fPointlightRange;
		float fCoronaSize;
		float fShadowSize;
		unsigned short nFlags;
		unsigned char nCoronaFlashType;
		bool bCoronaEnableReflection;
		unsigned char nCoronaFlareType;
		unsigned char nShadowColorMultiplier;
		char nShadowZDistance;
		char offsetX;
		char offsetY;
		char offsetZ;
		char _pad2E[2];
		RwTexture *pCoronaTex;
		RwTexture *pShadowTex;
		int field_38;
		int field_3C;
	} tEffectLight;

	typedef struct tEffectParticle
	{
		char szName[24];
	} tEffectParticle;

	typedef struct tEffectPedAttractor
	{
		vector3d vecQueueDir;
		vector3d vecUseDir;
		vector3d vecForwardDir;
		unsigned char nAttractorType;
		unsigned char nPedExistingProbability;
		char field_36;
		unsigned char nFlags;
		char szScriptName[8];
	} tEffectPedAttractor;

	typedef struct tEffectEnEx
	{
		float fEnterAngle;
		vector3d vecSize;
		vector3d vecExitPosn;
		float fExitAngle;
		short nInteriorId;
		unsigned char nFlags1;
		unsigned char nSkyColor;
		char szInteriorName[8];
		unsigned char nTimeOn;
		unsigned char nTimeOff;
		unsigned char nFlags2;
	} tEffectEnEx;

	typedef struct tEffectRoadsign
	{
		vector2d vecSize;
		float afRotation[3];
		unsigned short nFlags;
		char _pad26[2];
		char *pText;
		RpAtomic *pAtomic;
	} tEffectRoadsign;

	typedef struct tEffectCoverPoint
	{
		vector2d vecDirection;
		unsigned char nType;
		char _pad19[3];
	} tEffectCoverPoint;

	typedef struct tEffectEscalator
	{
		vector3d vecBottom;
		vector3d vecTop;
		vector3d vecEnd;
		unsigned char nDirection;
		char _pad35[3];
	} tEffectEscalator;

	typedef struct C2dEffect
	{
		vector3d vecPosn;
		unsigned int nType;
		union
		{
			tEffectLight light;
			tEffectParticle particle;
			tEffectPedAttractor pedAttractor;
			tEffectEnEx enEx;
			tEffectRoadsign roadsign;
			tEffectCoverPoint coverPoint;
			tEffectEscalator escalator;
		};
	} C2dEffect;
]]

shared.validate_size('C2dEffect', 0x40)
