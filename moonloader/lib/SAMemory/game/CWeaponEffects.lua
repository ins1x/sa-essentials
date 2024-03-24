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
	typedef struct CWeaponEffects
	{
		bool    			bActive;
		char 					_pad01[3];
		int     			nTimeWhenToDeactivate;
		vector3d 			vPosn;
		unsigned int 	uiColor;
		float   			fSize;
		int 					field_1C;
		int 					field_20;
		float   			fRotation;
		char 					field_28;
		char 					_pad29[3];
	} CWeaponEffects;
]]

shared.validate_size('CWeaponEffects', 0x2C)
