--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'CPlaceable'
shared.require 'RenderWare'
shared.require 'CReference'

shared.ffi.cdef[[
	typedef struct CEntity CEntity;

	struct CEntity : CPlaceable
	{
		union
		{
			RwObject *pRwObject;
			RpClump  *pRwClump;
			RpAtomic *pRwAtomic;
		};
		unsigned int bUsesCollision : 1;
		unsigned int bCollisionProcessed : 1;
		unsigned int bIsStatic : 1;
		unsigned int bHasContacted : 1;
		unsigned int bIsStuck : 1;
		unsigned int bIsInSafePosition : 1;
		unsigned int bWasPostponed : 1;
		unsigned int bIsVisible : 1;

		unsigned int bIsBIGBuilding : 1;
		unsigned int bRenderDamaged : 1;
		unsigned int bStreamingDontDelete : 1;
		unsigned int bRemoveFromWorld : 1;
		unsigned int bHasHitWall : 1;
		unsigned int bImBeingRendered : 1;
		unsigned int bDrawLast :1;
		unsigned int bDistanceFade :1;

		unsigned int bDontCastShadowsOn : 1;
		unsigned int bOffscreen : 1;
		unsigned int bIsStaticWaitingForCollision : 1;
		unsigned int bDontStream : 1;
		unsigned int bUnderwater : 1;
		unsigned int bHasPreRenderEffects : 1;
		unsigned int bIsTempBuilding : 1;
		unsigned int bDontUpdateHierarchy : 1;
		unsigned int bHasRoadsignText : 1;
		unsigned int bDisplayedSuperLowLOD : 1;
		unsigned int bIsProcObject : 1;
		unsigned int bBackfaceCulled : 1;
		unsigned int bLightObject : 1;
		unsigned int bUnimportantStream : 1;
		unsigned int bTunnel : 1;
		unsigned int bTunnelTransition : 1;
		unsigned short nRandomSeed;
		unsigned short nModelIndex;
		CReference *pReferences;
		void *pStreamingLink;
		short nScanCode;
		char nIplIndex;
		unsigned char nAreaCode;
		union
		{
			int 		 nLodIndex;
			CEntity *pLod;
		};
		unsigned char nNumLodChildren;
		unsigned char nNumLodChildrenRendered;
		unsigned char nType : 3;
		unsigned char nStatus : 5;
	};
]]

shared.validate_size('CEntity', 0x38)
