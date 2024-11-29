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

local function RefLocalPlayerKeys() return ffi.cast('struct CPad*', sampapi.GetAddress(0x13D2C0))[0] end
local function ArrayPlayerKeys() return ffi.cast('struct CPad* ', sampapi.GetAddress(0x13D3F8)) end
local function RefInternalKeys() return ffi.cast('struct CPad**', sampapi.GetAddress(0x1016E8))[0] end
local function RefDriveByLeft() return ffi.cast('bool**', sampapi.GetAddress(0x1016EC))[0] end
local function RefDriveByRight() return ffi.cast('bool**', sampapi.GetAddress(0x1016F0))[0] end
local function RefSavedDriveByLeft() return ffi.cast('bool*', sampapi.GetAddress(0x14D0A0))[0] end
local function RefSavedDriveByRight() return ffi.cast('bool*', sampapi.GetAddress(0x14D0A1))[0] end
local Initialize = ffi.cast('void(__cdecl*)()', sampapi.GetAddress(0xA2240))
local UpdateKeys = ffi.cast('void(__cdecl*)()', sampapi.GetAddress(0xA22A0))
local ApplyKeys = ffi.cast('void(__cdecl*)()', sampapi.GetAddress(0xA2260))
local SetKeys = ffi.cast('void(__cdecl*)(int, const struct CPad*)', sampapi.GetAddress(0xA22E0))
local ApplyKeys = ffi.cast('void(__cdecl*)()', sampapi.GetAddress(0xA2260))
local GetInternalKeys = ffi.cast('struct CPad * (__cdecl*)()', sampapi.GetAddress(0xA2350))
local GetKeys = ffi.cast('struct CPad * (__cdecl*)(int)', sampapi.GetAddress(0xA2370))
local GetKeys = ffi.cast('struct CPad * (__cdecl*)(int)', sampapi.GetAddress(0xA2370))
local ResetKeys = ffi.cast('void(__cdecl*)(int)', sampapi.GetAddress(0xA2380))
local ResetInternalKeys = ffi.cast('void(__cdecl*)()', sampapi.GetAddress(0xA23A0))

return {
    RefLocalPlayerKeys = RefLocalPlayerKeys,
    ArrayPlayerKeys = ArrayPlayerKeys,
    RefInternalKeys = RefInternalKeys,
    RefDriveByLeft = RefDriveByLeft,
    RefDriveByRight = RefDriveByRight,
    RefSavedDriveByLeft = RefSavedDriveByLeft,
    RefSavedDriveByRight = RefSavedDriveByRight,
    Initialize = Initialize,
    UpdateKeys = UpdateKeys,
    ApplyKeys = ApplyKeys,
    SetKeys = SetKeys,
    ApplyKeys = ApplyKeys,
    GetInternalKeys = GetInternalKeys,
    GetKeys = GetKeys,
    GetKeys = GetKeys,
    ResetKeys = ResetKeys,
    ResetInternalKeys = ResetInternalKeys,
}