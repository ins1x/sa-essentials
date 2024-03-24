--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

local ffi = shared.ffi
local cast = ffi.cast

ffi.cdef[[
	typedef struct CWeaponEffects CWeaponEffects;
	typedef struct CVehicle CVehicle;
	typedef struct CCamera CCamera;
	typedef struct CPool CPool;
	typedef struct CPed CPed;
]]

local function PBOOL(x)
	return cast('bool *', x)
end

local function PPOOL(x)
	return cast('CPool **', x)
end

return {
	_ver 								= '1.0.4.2';

	cast 								= cast;
	require 						= shared.require;

	code_pause					= PBOOL(0x00B7CB48);
	user_pause 					= PBOOL(0x00B7CB49);

	nullptr 						= cast('void *', 0x00000000);
	camera 							= cast('CCamera *', 0x00B6F028);
	-- array[2]
	crosshairs 					= cast('CWeaponEffects *', 0x00C8A838);
	player_ped 				  = cast('CPed **', 0x00B6F5F0);
	player_vehicle  		= cast('CVehicle **', 0x00BA18FC);

	-- pools (CPool)
	ptrNodeSinglePool   = PPOOL(0x00B74484);
	ptrNodeDoublePool   = PPOOL(0x00B74488);
	ped_pool 						= PPOOL(0x00B74490);
	vehicle_pool 				= PPOOL(0x00B74494);
	building_pool 			= PPOOL(0x00B74498);
	object_pool 				= PPOOL(0x00B7449C);
	dummy_pool 					= PPOOL(0x00B744A0);
	colModelPool 			 	= PPOOL(0x00B744A4);
	task_pool 					= PPOOL(0x00B744A8);
	pedIntelligencePool = PPOOL(0x00B744C0);
}
