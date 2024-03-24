--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

require 'SAMemory.game.vector3d'
require 'SAMemory.game.RenderWare'

local mt = require 'SAMemory.metatype'
local ffi = require 'ffi'

ffi.cdef[[
	typedef struct matrix3x3
	{
		vector3d      right;
		unsigned int 	flags;
		vector3d      up;
		unsigned int 	pad1;
		vector3d      at;
		unsigned int 	pad2;
		vector3d      pos;
		unsigned int 	pad3;
		RwMatrix 			*pAttachMatrix;
		bool 					bOwnsAttachedMatrix;
	} matrix;
]]

local matrix = {
	Attach 									= ffi.cast('void ( __thiscall * )( void *, RwMatrix *, bool )', 0x59BD10);
	Detach 									= ffi.cast('void ( __thiscall * )( void * )', 0x59ACF0);
	Update 									= ffi.cast('void ( __thiscall * )( void * )', 0x59BB60);
	UpdateRWWithAttached 		= ffi.cast('void ( __thiscall * )( void * )', 0x59BBB0);
	ResetOrientation 				= ffi.cast('void ( __thiscall * )( void * )', 0x59AEA0);
	SetRotateXOnly 					= ffi.cast('void ( __thiscall * )( void *, float )', 0x59AFA0);
	SetRotateYOnly 					= ffi.cast('void ( __thiscall * )( void *, float )', 0x59AFE0);
	SetRotateZOnly 					= ffi.cast('void ( __thiscall * )( void *, float )', 0x59B020);
	SetRotateX 							= ffi.cast('void ( __thiscall * )( void *, float )', 0x59B060);
	SetRotateY 							= ffi.cast('void ( __thiscall * )( void *, float )', 0x59B0A0);
	SetRotateZ 							= ffi.cast('void ( __thiscall * )( void *, float )', 0x59B0E0);
	SetRotate 							= ffi.cast('void ( __thiscall * )( void *, float, float, float )', 0x59B120);
	RotateX 								= ffi.cast('void ( __thiscall * )( void *, float )', 0x59B1E0);
	RotateY 								= ffi.cast('void ( __thiscall * )( void *, float )', 0x59B2C0);
	RotateZ 								= ffi.cast('void ( __thiscall * )( void *, float )', 0x59B390);
	Rotate 									= ffi.cast('void ( __thiscall * )( void *, float, float, float )', 0x59B460);
}

mt.provide_access('matrix', matrix, true, false)
