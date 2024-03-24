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
	typedef struct tColLighting
	{
		unsigned char day : 4;
		unsigned char night : 4;
	} tColLighting;

	typedef struct CColPoint
	{
		vector3d       	vecPoint;
		float 					field_C;
		vector3d       	vecNormal;
		float 					field_1C;
		unsigned char		nSurfaceTypeA;
		unsigned char 	nPieceTypeA;
	  tColLighting 		nLightingA;
	  char 						_pad;
		unsigned char 	nSurfaceTypeB;
		unsigned char 	nPieceTypeB;
	  tColLighting 		nLightingB;
	  char 						_pad2;
		float         	fDepth;
	} CColPoint;
]]

shared.validate_size('CColPoint', 0x2C)
