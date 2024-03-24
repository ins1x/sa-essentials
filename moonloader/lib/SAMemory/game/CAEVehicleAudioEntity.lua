--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'CAESound'
shared.require 'CAEAudioEntity'
shared.require 'CAETwinLoopSoundEntity'

shared.ffi.cdef[[
	typedef struct tVehicleSound
	{
    unsigned int  nIndex;
    CAESound     *pSound;
	} tVehicleSound;

	typedef struct tVehicleAudioSettings
	{
		char  nVehicleSoundType;
	  char field_1;
	  short nEngineOnSoundBankId;
	  short nEngineOffSoundBankId;
	  char  nStereo;
	  char field_7;
	  int field_8;
	  int field_C;
	  char  bHornTon;
	  char field_11[3];
	  float fHornHigh;
	  char  nDoorSound;
	  char field_19;
	  char  nRadioNum;
	  char  nRadioType;
	  char field_1C;
	  char field_1D[3];
	  float fHornVolumeDelta;
	} tVehicleAudioSettings;

	typedef struct CAEVehicleAudioEntity : CAEAudioEntity
	{
		short 									field_7C;
    char 										field_7E[2];
    tVehicleAudioSettings   settings;
    bool                    bEnabled;
    bool                    bPlayerDriver;
    bool                    bPlayerPassenger;
    bool                    bVehicleRadioPaused;
    bool                    bSoundsStopped;
    char                    nEngineState;
    char 										field_AA;
    char 										field_AB;
    int 										field_AC;
    bool                    bInhibitAccForLowSpeed;
    char 										field_B1;
    short                   nRainDropCounter;
    short 									field_B4;
    char 										gap_B6[2];
    int 										field_B8;
    char 										field_BC;
    bool                    bDisableHeliEngineSounds;
    char 										field_BE;
    bool                    bSirenOrAlarmPlaying;
    bool                    bHornPlaying;
    char 										gap_C1[3];
    float                   fSirenVolume;
    bool                    bModelWithSiren;
    char 										gap_C9[3];
    unsigned int            nBoatHitWaveLastPlayedTime;
    unsigned int            nTimeToInhibitAcc;
    unsigned int            nTimeToInhibitCrz;
    float                   fGeneralVehicleSoundVolume;
    short                   nEngineDecelerateSoundBankId;
    short                   nEngineAccelerateSoundBankId;
    short                   nEngineBankSlotId;
    short 									field_E2;
    tVehicleSound           aEngineSounds[12];
    int 										field_144;
    short 									field_148;
    short 									field_14A;
    short 									field_14C;
    short 									field_14E;
    int 										field_150;
    short 									field_154;
    short                   nSkidSoundType;
    CAESound 								*field_158;
    short                   nRoadNoiseSoundType;
    char 										gap_15E[2];
    CAESound                *pRoadNoiseSound;
    short                   nFlatTyreSoundType;
    char 										gap_166[2];
    CAESound                *pFlatTyreSound;
    short                   nReverseGearSoundType;
    char 										gap_16E[2];
    CAESound                *pReverseGearSound;
    char 										gap_174[4];
    CAESound                *pHornTonSound;
    CAESound                *pSirenSound;
    CAESound                *pPoliceSirenSound;
    CAETwinLoopSoundEntity  skidSound;
    float 									field_22C;
    float 									field_230;
    float 									field_234;
    float 									field_238;
    float 									field_23C;
    int 										field_240;
    bool                    bNitroSoundPresent;
    char 										field_245[3];
    float 									field_248;
	} CAEVehicleAudioEntity;
]]

shared.validate_size('CAEVehicleAudioEntity', 0x24C)
