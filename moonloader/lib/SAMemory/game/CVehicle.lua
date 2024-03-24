--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'RenderWare'
shared.require 'CPhysical'
shared.require 'CAEVehicleAudioEntity'
shared.require 'tHandlingData'
shared.require 'tFlyingHandlingData'
shared.require 'CAutoPilot'
shared.require 'CPed'
shared.require 'CEntity'
shared.require 'CFire'
shared.require 'CStoredCollPoly'
shared.require 'FxSystem_c'

shared.ffi.cdef[[
	typedef enum eCarWeapon
	{
		CAR_WEAPON_NOT_USED,
		CAR_WEAPON_HEAVY_GUN,
		CAR_WEAPON_FREEFALL_BOMB,
		CAR_WEAPON_LOCK_ON_ROCKET,
		CAR_WEAPON_DOUBLE_ROCKET
	} eCarWeapon;

	typedef enum eCarLock
	{
		CARLOCK_NOT_USED,
		CARLOCK_UNLOCKED,
		CARLOCK_LOCKED,
		CARLOCK_LOCKOUT_PLAYER_ONLY,
		CARLOCK_LOCKED_PLAYER_INSIDE,
		CARLOCK_COP_CAR,
		CARLOCK_FORCE_SHUT_DOORS,
		CARLOCK_SKIP_SHUT_DOORS
	} eCarLock;

	typedef enum eVehicleType
	{
		VEHICLE_AUTOMOBILE,
		VEHICLE_MTRUCK,
		VEHICLE_QUAD,
		VEHICLE_HELI,
		VEHICLE_PLANE,
		VEHICLE_BOAT,
		VEHICLE_TRAIN,
		VEHICLE_FHELI,
		VEHICLE_FPLANE,
		VEHICLE_BIKE,
		VEHICLE_BMX,
		VEHICLE_TRAILER
	} eVehicleType;

	typedef enum eVehicleApperance
	{
		VEHICLE_APPEARANCE_AUTOMOBILE = 1,
		VEHICLE_APPEARANCE_BIKE,
		VEHICLE_APPEARANCE_HELI,
		VEHICLE_APPEARANCE_BOAT,
		VEHICLE_APPEARANCE_PLANE,
	} eVehicleApperance;

	typedef enum eVehicleLightsFlags
	{
		VEHICLE_LIGHTS_TWIN = 1,
		VEHICLE_LIGHTS_IGNORE_DAMAGE = 4,
		VEHICLE_LIGHTS_DISABLE_FRONT = 16,
		VEHICLE_LIGHTS_DISABLE_REAR = 32
	} eVehicleLightsFlags;

	typedef enum eVehicleCreatedBy
	{
		RANDOVEHICLE = 0,
		MISSION_VEHICLE = 2,
		PARKED_VEHICLE = 3,
		PERMANENT_VEHICLE = 4
	} eVehicleCreatedBy;

	typedef enum eBombState
	{
		BOMB_TIMED_NOT_ACTIVATED = 1,
		BOMB_IGNITION = 2,
		BOMB_STICKY = 3,
		BOMB_TIMED_ACTIVATED = 4,
		BOMB_IGNITION_ACTIVATED = 5
	} eBombState;

	typedef struct CVehicle CVehicle;

	struct CVehicle : CPhysical
	{
		CAEVehicleAudioEntity     vehicleAudio;
		tHandlingData             *pHandlingData;
		tFlyingHandlingData       *pFlyingHandlingData;
		union
		{
			eVehicleHandlingFlags  nHandlingFlagsIntValue;
			struct
			{
				unsigned int b1gBoost : 1;
				unsigned int b2gBoost : 1;
				unsigned int bNpcAntiRoll : 1;
				unsigned int bNpcNeutralHandl : 1;
				unsigned int bNoHandbrake : 1;
				unsigned int bSteerRearwheels : 1;
				unsigned int bHbRearwheelSteer : 1;
				unsigned int bAltSteerOpt : 1;
				unsigned int bWheelFNarrow2 : 1;
				unsigned int bWheelFNarrow : 1;
				unsigned int bWheelFWide : 1;
				unsigned int bWheelFWide2 : 1;
				unsigned int bWheelRNarrow2 : 1;
				unsigned int bWheelRNarrow : 1;
				unsigned int bWheelRWide : 1;
				unsigned int bWheelRWide2 : 1;
				unsigned int bHydraulicGeom : 1;
				unsigned int bHydraulicInst : 1;
				unsigned int bHydraulicNone : 1;
				unsigned int bNosInst : 1;
				unsigned int bOffroadAbility : 1;
				unsigned int bOffroadAbility2 : 1;
				unsigned int bHalogenLights : 1;
				unsigned int bProcRearwheelFirst : 1;
				unsigned int bUseMaxspLimit : 1;
				unsigned int bLowRider : 1;
				unsigned int bStreetRacer : 1;
				unsigned int bSwingingChassis : 1;
			} nHandlingFlags;
		};
		CAutoPilot                 autoPilot;
		struct
		{
			unsigned char bIsLawEnforcer : 1;
			unsigned char bIsAmbulanceOnDuty : 1;
			unsigned char bIsFireTruckOnDuty : 1;
			unsigned char bIsLocked : 1;
			unsigned char bEngineOn : 1;
			unsigned char bIsHandbrakeOn : 1;
			unsigned char bLightsOn : 1;
			unsigned char bFreebies : 1;

			unsigned char bIsVan : 1;
			unsigned char bIsBus : 1;
			unsigned char bIsBig : 1;
			unsigned char bLowVehicle : 1;
			unsigned char bComedyControls : 1;
			unsigned char bWarnedPeds : 1;
			unsigned char bCraneMessageDone : 1;
			unsigned char bTakeLessDamage : 1;

			unsigned char bIsDamaged : 1;
			unsigned char bHasBeenOwnedByPlayer : 1;
			unsigned char bFadeOut : 1;
			unsigned char bIsBeingCarJacked : 1;
			unsigned char bCreateRoadBlockPeds : 1;
			unsigned char bCanBeDamaged : 1;
			unsigned char bOccupantsHaveBeenGenerated : 1;
			unsigned char bGunSwitchedOff : 1;

			unsigned char bVehicleColProcessed : 1;
			unsigned char bIsCarParkVehicle : 1;
			unsigned char bHasAlreadyBeenRecorded : 1;
			unsigned char bPartOfConvoy : 1;
			unsigned char bHeliMinimumTilt : 1;
			unsigned char bAudioChangingGear : 1;
			unsigned char bIsDrowning : 1;
			unsigned char bTyresDontBurst : 1;

			unsigned char bCreatedAsPoliceVehicle : 1;
			unsigned char bRestingOnPhysical : 1;
			unsigned char bParking : 1;
			unsigned char bCanPark : 1;
			unsigned char bFireGun : 1;
			unsigned char bDriverLastFrame : 1;
			unsigned char bNeverUseSmallerRemovalRange : 1;
			unsigned char bIsRCVehicle : 1;

			unsigned char bAlwaysSkidMarks : 1;
			unsigned char bEngineBroken : 1;
			unsigned char bVehicleCanBeTargetted : 1;
			unsigned char bPartOfAttackWave : 1;
			unsigned char bWinchCanPickMeUp : 1;
			unsigned char bImpounded : 1;
			unsigned char bVehicleCanBeTargettedByHS : 1;
			unsigned char bSirenOrAlarm : 1;

			unsigned char bHasGangLeaningOn : 1;
			unsigned char bGangMembersForRoadBlock : 1;
			unsigned char bDoesProvideCover : 1;
			unsigned char bMadDriver : 1;
			unsigned char bUpgradedStereo : 1;
			unsigned char bConsideredByPlayer : 1;
			unsigned char bPetrolTankIsWeakPoint : 1;
			unsigned char bDisableParticles : 1;

			unsigned char bHasBeenResprayed : 1;
			unsigned char bUseCarCheats : 1;
			unsigned char bDontSetColourWhenRemapping : 1;
			unsigned char bUsedForReplay : 1;
		} nFlags;
		unsigned int 				nCreationTime;
		unsigned char  			nPrimaryColor;
		unsigned char 		 	nSecondaryColor;
		unsigned char  			nTertiaryColor;
		unsigned char 		 	nQuaternaryColor;
		char   							anExtras[2];
		short  							anUpgrades[15];
		float    						fWheelScale;
		unsigned short			nAlarmState;
		short 						 	nForcedRandomRouteSeed;
		CPed 								*pDriver;
		CPed 								*apPassengers[8];
		unsigned char  			nNumPassengers;
		unsigned char  			nNumGettingIn;
		unsigned char  			nGettingInFlags;
		unsigned char 		 	nGettingOutFlags;
		unsigned char  			nMaxPassengers;
		unsigned char  			nWindowsOpenFlags;
		unsigned char  			nNitroBoosts;
		unsigned char 			nSpecialColModel;
		CEntity 						*pEntityWeAreOn;

		CFire 							*pFire;
		float  							fSteerAngle;
		float  							f2ndSteerAngle;
		float  							fGasPedal;
		float  							fBreakPedal;
		unsigned char  			nCreatedBy;
		short 							nExtendedRemovalRange;
		unsigned char 			nBombOnBoard : 3;
		unsigned char 			nOverrideLights : 2;
		unsigned char 			nWinchType : 2;
		unsigned char 			nGunsCycleIndex : 2;
		unsigned char 			nOrdnanceCycleIndex : 2;
		unsigned char 			nUsedForCover;
		unsigned char 			nAmmoInClip;
		unsigned char 			nPacMansCollected;
		unsigned char 			nPedsPositionForRoadBlock;
		unsigned char 			nNumCopsForRoadBlock;
		float   						fDirtLevel;
		unsigned char 			nCurrentGear;
		float   						fGearChangeCount;
		float   						fWheelSpinForAudio;
		float   						fHealth;
		CVehicle 						*pTractor;
		CVehicle 						*pTrailer;
		CPed 								*pWhoInstalledBombOnMe;
		unsigned int 				nTimeTillWeNeedThisCar;
		unsigned int 				nGunFiringTime;
		unsigned int 				nTimeWhenBlowedUp;
		short  							nCopsInCarTimer;

		short  							wBombTimer;
		CPed 								*pWhoDetonatedMe;
		float  							fVehicleFrontGroundZ;
		float  							fVehicleRearGroundZ;
		char 								field_4EC;
		char 								field_4ED[11];
		unsigned int 				nDoorLock;
		unsigned int				nProjectileWeaponFiringTime;
		unsigned int 				nAdditionalProjectileWeaponFiringTime;
		unsigned int 				nTimeForMinigunFiring;
		unsigned char				nLastWeaponDamageType;
		CEntity 						*pLastDamageEntity;
		char 								field_510;
		char 								field_511;
		char 								field_512;
		char 								nVehicleWeaponInUse;
		unsigned int     		nHornCounter;
		char 								field_518;
		char 								field_519;
		char 								field_51A;
		char       					nHasslePosId;
		CStoredCollPoly 		FrontCollPoly;
		CStoredCollPoly 		RearCollPoly;
		unsigned char      	anCollisionLighting[4];
		FxSystem_c 					*pOverheatParticle;
		FxSystem_c 					*pFireParticle;
		FxSystem_c 					*pDustParticle;
		union
		{
			unsigned char     nRenderLightsFlags;
			struct
			{
				unsigned char bRightFront : 1;
				unsigned char bLeftFront : 1;
				unsigned char bRightRear : 1;
				unsigned char bLeftRear : 1;
			} renderLights;
		};
		RwTexture 				*pCustomCarPlate;
		CVehicle 					*field_58C;
		unsigned int     	nVehicleClass;
		unsigned int     	nVehicleSubClass;
		short      				nPreviousRemapTxd;
		short      				nRemapTxd;
		RwTexture 				*pRemapTexture;
	};
]]

shared.validate_size('CVehicle', 0x5A0)
