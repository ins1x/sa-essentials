--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'vector3d'

shared.ffi.cdef[[
	typedef struct CWeaponInfo
	{
		 unsigned int   nWeaponFire;
		 float          fTargetRange;
		 float          fWeaponRange;
		 int            nModelId1;
		 int            nModelId2;
		 unsigned int   nSlot;
		 struct
		 {
			 unsigned int bCanAim : 1;
			 unsigned int bAimWithArm : 1;
			 unsigned int b1stPerson : 1;
			 unsigned int bOnlyFreeAim : 1;
			 unsigned int bMoveAim : 1;
			 unsigned int bMoveFire : 1;
			 unsigned int b06 : 1;
			 unsigned int b07 : 1;
			 unsigned int bThrow : 1;
			 unsigned int bHeavy : 1;
			 unsigned int bContinuosFire : 1;
			 unsigned int bTwinPistol : 1;
			 unsigned int bReload : 1;
			 unsigned int bCrouchFire : 1;
			 unsigned int bReload2Start : 1;
			 unsigned int bLongReload : 1;
			 unsigned int bSlowdown : 1;
			 unsigned int bRandSpeed : 1;
			 unsigned int bExpands : 1;
		 } nFlags;
		 unsigned int   dwAnimGroup;
		 unsigned short nAmmoClip;
		 unsigned short nDamage;
		 vector3d       vFireOffset;
		 unsigned int   nSkillLevel;
		 unsigned int   nReqStatLevel;
		 float          fAccuracy;
		 float          fMoveSpeed;
		 float          fAnimLoopStart;
		 float          fAnimLoopEnd;
		 unsigned int   nAnimLoopFire;
		 unsigned int   nAnimLoop2Start;
		 unsigned int   nAnimLoop2End;
		 unsigned int   nAnimLoop2Fire;
		 float          fBreakoutTime;
		 float          fSpeed;
		 float          fRadius;
		 float          fLifespan;
		 float          fSpread;
		 unsigned short nAimOffsetIndex;
		 unsigned char  nBaseCombo;
		 unsigned char  nNumCombos;
	} CWeaponInfo;
]]

shared.validate_size('CWeaponInfo', 0x70)
