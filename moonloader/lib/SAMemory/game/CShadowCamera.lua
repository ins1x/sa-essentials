--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'RenderWare'

shared.ffi.cdef[[
	typedef struct CShadowCamera
	{
		RwCamera  *pRwCamera;
		RwTexture *pRwRenderTexture;
	} CShadowCamera;
]]

shared.validate_size('CShadowCamera', 8)
