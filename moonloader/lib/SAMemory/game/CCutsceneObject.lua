--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'vector3d'
shared.require 'CObject'

shared.ffi.cdef[[
	typedef struct CCutsceneObject : CObject
	{
		union
		{
			RwFrame *pAttachTo;
			unsigned int nAttachBone; // this one if m_pAttachmentObject != 0
		};
		CObject  *pAttachmentObject;
		vector3d vWorldPosition;
		vector3d vForce;
	} CCutsceneObject;
]]

shared.validate_size('CCutsceneObject', 0x19C)
