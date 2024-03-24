--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'CAEPoliceScannerAudioEntity'
shared.require 'CCrimeBeingQd'

shared.ffi.cdef[[
	typedef struct CCopPed CCopPed;

	typedef struct CWanted
	{
		unsigned int    nChaosLevel;
		unsigned int    nChaosLevelBeforeParole;
		unsigned int    nLastTimeWantedDecreased;
		unsigned int    nLastTimeWantedLevelChanged;
		unsigned int    nTimeOfParole;
		float           fMultiplier;
		unsigned char   nCopsInPursuit;
		unsigned char   nMaxCopsInPursuit;
		unsigned char   nMaxCopCarsInPursuit;
		unsigned char   nCopsBeatingSuspect;
		unsigned short  nChanceOnRoadBlock;
		unsigned char   bPoliceBackOff : 1;
	  unsigned char   bPoliceBackOffGarage : 1;
	  unsigned char   bEverybodyBackOff : 1;
	  unsigned char   bSwatRequired : 1;
	  unsigned char   bFbiRequired : 1;
	  unsigned char   bArmyRequired : 1;
		char _pad1F;
		unsigned int    nCurrentChaseTime;
		unsigned int    nCurrentChaseTimeCounter;
		unsigned int    nTimeCounting;
		unsigned int    nWantedLevel;
		unsigned int    nWantedLevelBeforeParole;
		CCrimeBeingQd   CrimesBeingQd[16];
		CCopPed        *pCopsInPursuit[10];
	  CAEPoliceScannerAudioEntity PoliceScannerAudio;
	  bool            bLeavePlayerAlone;
	  char _pad299[3];
	} CWanted;
]]

shared.validate_size('CWanted', 0x29C)
