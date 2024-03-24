--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'CAEAudioEntity'
shared.require 'CAESound'
shared.require 'CPed'

shared.ffi.cdef[[
	typedef struct CAEWeaponAudioEntity : CAEAudioEntity
	{
		char bPlayedMiniGunFireSound;
		char field_7D;
		char field_7E;
		char field_7F;
		char nChainsawSoundState;
		char field_81[3];
		int dwFlameThrowerLastPlayedTime;
		int dwSpraycanLastPlayedTime;
		int dwExtinguisherLastPlayedTime;
		int dwMiniGunFireSoundPlayedTime;
		int dwTimeChainsaw;
		int dwTimeLastFired;
		CAESound *pSounds;
		char bActive;
		char field_A1[3];
		CPed* pPed;
	} CAEWeaponAudioEntity;
]]

shared.validate_size('CAEWeaponAudioEntity', 0xA8)
