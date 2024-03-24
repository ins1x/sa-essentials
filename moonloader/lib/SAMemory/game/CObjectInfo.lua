--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'vector3d'
shared.require 'FxSystem_c'

shared.ffi.cdef[[
	typedef struct CObjectInfo
	{
		float          fMass;
		float          fTurnMass;
		float          fAirResistance;
		float          fElasticity;
		float          fBuoyancyConstant;
		float          fUprootLimit;
		float          fColDamageMultiplier;
		unsigned char  nColDamageEffect;
		unsigned char  nSpecialColResponseCase;
		unsigned char  nCameraAvoidObject;
		unsigned char  bCausesExplosion;
		unsigned char  nFxType;
		vector3d       vFxOffset;
		FxSystem_c     *pFxSystem;
		float          fSmashMultiplier;
		vector3d       vecBreakVelocity;
		float          fBreakVelocityRand;
		unsigned int   nGunBreakMode;
		unsigned int   nSparksOnImpact;
	} CObjectInfo;
]]

shared.validate_size('CObjectInfo', 0x50)
