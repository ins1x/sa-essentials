--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'CEntity'
shared.require 'vector3d'

shared.ffi.cdef[[
	typedef enum eSoundEnvironment
	{
    SOUND_FRONT_END = 1,
    SOUND_UNCANCELLABLE = 2,
    SOUND_REQUEST_UPDATES = 4,
    SOUND_PLAY_PHYSICALLY = 8,
    SOUND_UNPAUSABLE = 16,
    SOUND_START_PERCENTAGE = 32,
    SOUND_MUSIC_MASTERED = 64,
    SOUND_LIFESPAN_TIED_TO_PHYSICAL_ENTITY = 128,
    SOUND_UNDUCKABLE = 256,
    SOUND_UNCOMPRESSABLE = 512,
    SOUND_ROLLED_OFF = 1024,
    SOUND_SMOOTH_DUCKING = 2048,
    SOUND_FORCED_FRONT = 4096
	} eSoundEnvironment;

	typedef struct CAEAudioEntity CAEAudioEntity;

	typedef struct CAESound
	{
		short                 nBankSlotId;
		short                 nSoundIdInSlot;
		CAEAudioEntity        *pBaseAudio;
		CEntity               *pPhysicalEntity;
		unsigned int          nEvent;
	  float                 fMaxVolume;
		float                 fVolume;
		float                 fSoundDistance;
		float                 fSpeed;
		float 								field_20;
		vector3d              vecCurrPosn;
		vector3d              vecPrevPosn;
		int                   nLastFrameUpdate;
		int                   nCurrTimeUpdate;
		int                   nPrevTimeUpdate;
		float                 fCurrCamDist;
		float                 fPrevCamDist;
		float                 fTimeScale;
		char 									field_54;
		char 									field_55;
		union
		{
			unsigned short nEnvironmentFlags;
			struct
			{
				unsigned short bFrontEnd : 1;
				unsigned short bUncancellable : 1;
				unsigned short bRequestUpdates : 1;
				unsigned short bPlayPhysically : 1;
				unsigned short bUnpausable : 1;
				unsigned short bStartPercentage : 1;
				unsigned short bMusicMastered : 1;
				unsigned short bLifespanTiedToPhysicalEntity : 1;
				unsigned short bUndackable : 1;
				unsigned short bUncompressable : 1;
				unsigned short bRolledOff : 1;
				unsigned short bSmoothDucking : 1;
				unsigned short bForcedFront : 1;
			};
		};
		unsigned short        nIsUsed;
		short 								field_5A;
		short                 nCurrentPlayPosition;
		short 								field_5E;
		float                 fFinalVolume;
		float                 fFrequency;
		short                 nPlayingState;
		char 									field_6A[2];
		float                 fSoundHeadRoom;
	  short 								field_70;
		short 								field_72;
	} CAESound;
]]

shared.validate_size('CAESound', 0x74)
