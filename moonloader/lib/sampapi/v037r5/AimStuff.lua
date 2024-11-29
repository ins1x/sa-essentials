--[[
    Project: SAMP-API.lua <https://github.com/imring/SAMP-API.lua>
    Developers: imring, LUCHARE, FYP

    Special thanks:
        SAMemory (https://www.blast.hk/threads/20472/) for implementing the basic functions.
        SAMP-API (https://github.com/BlastHackNet/SAMP-API) for the structures and addresses.
]]

local sampapi = require 'sampapi'
local shared = sampapi.shared
local mt = require 'sampapi.metatype'
local ffi = require 'ffi'

shared.require 'CVector'

shared.ffi.cdef[[
typedef struct SAim SAim;
#pragma pack(push, 1)
struct SAim {
    SCVector front;
    SCVector source;
    SCVector sourceBeforeLookBehind;
    SCVector up;
};
#pragma pack(pop)
]]

shared.validate_size('struct SAim', 0x30)

local function RefLocalPlayerCameraExtZoom() return ffi.cast('float*', sampapi.GetAddress(0x143FD0))[0] end
local function RefLocalPlayerAspectRatio() return ffi.cast('float*', sampapi.GetAddress(0x146B88))[0] end
local function RefInternalCameraExtZoom() return ffi.cast('float**', sampapi.GetAddress(0x1039D4))[0] end
local function RefInternalAspectRatio() return ffi.cast('float**', sampapi.GetAddress(0x1039D0))[0] end
local function ArrayCameraExtZoom() return ffi.cast('float* ', sampapi.GetAddress(0x1440B0)) end
local function ArrayAspectRatio() return ffi.cast('float* ', sampapi.GetAddress(0x146BB8)) end
local function ArrayCameraMode() return ffi.cast('char* ', sampapi.GetAddress(0x143FD8)) end
local function RefInternalCameraMode() return ffi.cast('char**', sampapi.GetAddress(0x113974))[0] end
local function RefLocalPlayerAim() return ffi.cast('SAim*', sampapi.GetAddress(0x1443F8))[0] end
local function ArrayPlayerAim() return ffi.cast('SAim* ', sampapi.GetAddress(0x144428)) end
local function RefInternalAim() return ffi.cast('SAim**', sampapi.GetAddress(0x1039C8))[0] end
local UpdateCameraExtZoomAndAspectRatio = ffi.cast('void(__stdcall*)()', sampapi.GetAddress(0x9C7C0))
local ApplyCameraExtZoomAndAspectRatio = ffi.cast('void(__stdcall*)()', sampapi.GetAddress(0x9C7E0))
local SetCameraExtZoomAndAspectRatio = ffi.cast('void(__stdcall*)(NUMBER, float, float)', sampapi.GetAddress(0x9C800))
local GetAspectRatio = ffi.cast('float(__stdcall*)()', sampapi.GetAddress(0x9C820))
local GetCameraExtZoom = ffi.cast('float(__stdcall*)()', sampapi.GetAddress(0x9C830))
local ApplyCameraExtZoomAndAspectRatio = ffi.cast('void(__stdcall*)()', sampapi.GetAddress(0x9C7E0))
local SetCameraMode = ffi.cast('void(__stdcall*)(char, NUMBER)', sampapi.GetAddress(0x9C890))
local GetCameraMode = ffi.cast('char(__stdcall*)(NUMBER)', sampapi.GetAddress(0x9C8B0))
local GetCameraMode = ffi.cast('char(__stdcall*)(NUMBER)', sampapi.GetAddress(0x9C8B0))
local Initialize = ffi.cast('void(__stdcall*)()', sampapi.GetAddress(0x9C8D0))
local UpdateAim = ffi.cast('void(__stdcall*)()', sampapi.GetAddress(0x9C940))
local ApplyAim = ffi.cast('void(__stdcall*)()', sampapi.GetAddress(0x9C960))
local GetAim = ffi.cast('SAim * (__stdcall*)()', sampapi.GetAddress(0x9C980))
local SetAim = ffi.cast('void(__stdcall*)(int, const SAim*)', sampapi.GetAddress(0x9C990))
local ApplyAim = ffi.cast('void(__stdcall*)()', sampapi.GetAddress(0x9C960))
local GetAim = ffi.cast('SAim * (__stdcall*)()', sampapi.GetAddress(0x9C980))

return {
    RefLocalPlayerCameraExtZoom = RefLocalPlayerCameraExtZoom,
    RefLocalPlayerAspectRatio = RefLocalPlayerAspectRatio,
    RefInternalCameraExtZoom = RefInternalCameraExtZoom,
    RefInternalAspectRatio = RefInternalAspectRatio,
    ArrayCameraExtZoom = ArrayCameraExtZoom,
    ArrayAspectRatio = ArrayAspectRatio,
    ArrayCameraMode = ArrayCameraMode,
    RefInternalCameraMode = RefInternalCameraMode,
    RefLocalPlayerAim = RefLocalPlayerAim,
    ArrayPlayerAim = ArrayPlayerAim,
    RefInternalAim = RefInternalAim,
    UpdateCameraExtZoomAndAspectRatio = UpdateCameraExtZoomAndAspectRatio,
    ApplyCameraExtZoomAndAspectRatio = ApplyCameraExtZoomAndAspectRatio,
    SetCameraExtZoomAndAspectRatio = SetCameraExtZoomAndAspectRatio,
    GetAspectRatio = GetAspectRatio,
    GetCameraExtZoom = GetCameraExtZoom,
    ApplyCameraExtZoomAndAspectRatio = ApplyCameraExtZoomAndAspectRatio,
    SetCameraMode = SetCameraMode,
    GetCameraMode = GetCameraMode,
    GetCameraMode = GetCameraMode,
    Initialize = Initialize,
    UpdateAim = UpdateAim,
    ApplyAim = ApplyAim,
    GetAim = GetAim,
    SetAim = SetAim,
    ApplyAim = ApplyAim,
    GetAim = GetAim,
}