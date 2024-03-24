--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'CPhysical'
shared.require 'CShadowCamera'
shared.require 'RenderWare'

shared.ffi.cdef[[
	typedef struct CRealTimeShadow
	{
		struct CPhysical 	  *pOwner;
		bool 								Created;
		unsigned char 			Intensity;
		CShadowCamera 			Camera;
		bool 								Blurred;
		CShadowCamera 			BlurCamera;
		unsigned int 				BlurPasses;
		bool 								DrawMoreBlur;
		unsigned int 				RwObjectType;
		RpLight 		 			  *Light;
		RwSphere 						BoundingSphere;
		RwSphere 						BaseSphere;
	} CRealTimeShadow;
]]

shared.validate_size('CRealTimeShadow', 0x4C)
