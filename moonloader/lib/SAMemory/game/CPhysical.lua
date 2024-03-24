--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'quaternion'
shared.require 'vector3d'
shared.require 'CEntity'
shared.require 'CRealTimeShadow'

shared.ffi.cdef[[
	typedef struct CPhysical CPhysical;

	struct CPhysical : CEntity
	{
		int field_38;
    unsigned int nLastCollisionTime;
    struct
		{
      unsigned int b01 : 1;
			unsigned int bApplyGravity : 1;
      unsigned int bDisableCollisionForce : 1;
      unsigned int bCollidable : 1;
      unsigned int bDisableTurnForce : 1;
      unsigned int bDisableMoveForce : 1;
      unsigned int bInfiniteMass : 1;
      unsigned int bDisableZ : 1;
      unsigned int bSubmergedInWater : 1;
      unsigned int bOnSolidSurface : 1;
      unsigned int bBroken : 1;
      unsigned int b12 : 1;
      unsigned int b13 : 1;
      unsigned int bDontApplySpeed : 1;
      unsigned int b15 : 1;
      unsigned int b16 : 1;
      unsigned int b17 : 1;
      unsigned int b18 : 1;
      unsigned int bBulletProof : 1;
      unsigned int bFireProof : 1;
      unsigned int bCollisionProof : 1;
      unsigned int bMeeleProof : 1;
      unsigned int bInvulnerable : 1;
      unsigned int bExplosionProof : 1;
      unsigned int b25 : 1;
      unsigned int bAttachedToEntity : 1;
      unsigned int b27 : 1;
      unsigned int bTouchingWater : 1;
      unsigned int bCanBeCollidedWith : 1;
      unsigned int bDestroyed : 1;
      unsigned int b31 : 1;
      unsigned int b32 : 1;
    } nPhysicalFlags;
    vector3d         vMoveSpeed;
    vector3d         vTurnSpeed;
    vector3d         vFrictionMoveSpeed;
    vector3d         vFrictionTurnSpeed;
    vector3d         vForce;
    vector3d         vTorque;
    float            fMass;
    float            fTurnMass;
    float            fVelocityFrequency;
    float            fAirResistance;
    float            fElasticity;
    float            fBuoyancyConstant;
    vector3d         vCentreOfMass;
    void             *pCollisionList;
    void             *pMovingList;
    char 						 field_B8;
    unsigned char    nNumEntitiesCollided;
    unsigned char    nContactSurface;
    char 						 field_BB;
    CEntity          *apCollidedEntities[6];
    float            fMovingSpeed;
    float            fDamageIntensity;
    CEntity          *pDamageEntity;
    vector3d         vLastCollisionImpactVelocity;
    vector3d         vLastCollisionPosn;
    unsigned short   nPieceType;
    short 					 field_FA;
    CPhysical 			 *pAttachedTo;
    vector3d         vAttachOffset;
    vector3d         vAttachedEntityPosn;
    quaternion       qAttachedEntityRotation;
    CEntity          *pEntityIgnoredCollision;
    float            fContactSurfaceBrightness;
    float            fDynamicLighting;
    CRealTimeShadow  *pShadowData;
	};
]]

shared.validate_size('CPhysical', 0x138)
