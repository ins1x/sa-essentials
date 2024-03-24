--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.ffi.cdef[[
	typedef struct CColourSet
	{
		float          fAmbientRed;
		float          fAmbientGreen;
		float          fAmbientBlue;
		float          fAmbientRed_Obj;
		float          fAmbientGreen_Obj;
		float          fAmbientBlue_Obj;
		float          fDirectionalRed;
		float          fDirectionalGreen;
		float          fDirectionalBlue;
		unsigned short nSkyTopRed;
		unsigned short nSkyTopGreen;
		unsigned short nSkyTopBlue;
		unsigned short nSkyBottomRed;
		unsigned short nSkyBottomGreen;
		unsigned short nSkyBottomBlue;
		unsigned short nSunCoreRed;
		unsigned short nSunCoreGreen;
		unsigned short nSunCoreBlue;
		unsigned short nSunCoronaRed;
		unsigned short nSunCoronaGreen;
		unsigned short nSunCoronaBlue;
		float          fSunSize;
		float          fSpriteSize;
		float          fSpriteBrightness;
		unsigned short nShadowStrength;
		unsigned short nLightShadowStrength;
		unsigned short nPoleShadowStrength;
		float          fFarClip;
		float          fFogStart;
		float          fLightsOnGroundBrightness;
		unsigned short nLowCloudsRed;
		unsigned short nLowCloudsGreen;
		unsigned short nLowCloudsBlue;
		unsigned short nFluffyCloudsBottomRed;
		unsigned short nFluffyCloudsBottomGreen;
		unsigned short nFluffyCloudsBottomBlue;
		float          fWaterRed;
		float          fWaterGreen;
		float          fWaterBlue;
		float          fWaterAlpha;
		float          fPostFx1Red;
		float          fPostFx1Green;
		float          fPostFx1Blue;
		float          fPostFx1Alpha;
		float          fPostFx2Red;
		float          fPostFx2Green;
		float          fPostFx2Blue;
		float          fPostFx2Alpha;
		float          fCloudAlpha;
		unsigned int   nHighLightMinIntensity;
		unsigned short nWaterFogAlpha;
		float          fIllumination;
		float          fLodDistMult;
	} CColourSet;
]]

shared.validate_size('CColourSet', 0xAC)
