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
	typedef struct AnimBlendFrameData
	{
		unsigned char  nFlags;
		vector3d       vOffset;
		void				   *pIFrame;
		unsigned int   nNodeId;
	} AnimBlendFrameData;
]]

shared.validate_size('AnimBlendFrameData', 0x18)
