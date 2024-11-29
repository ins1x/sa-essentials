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

local function RefLocalPlayerKeys() return ffi.cast('struct CPad*', sampapi.GetAddress(0x1527C8))[0] end
local function ArrayPlayerKeys() return ffi.cast('struct CPad* ', sampapi.GetAddress(0x152900)) end
local function RefInternalKeys() return ffi.cast('struct CPad**', sampapi.GetAddress(0x114AE8))[0] end
local function RefDriveByLeft() return ffi.cast('bool**', sampapi.GetAddress(0x114AEC))[0] end
local function RefDriveByRight() return ffi.cast('bool**', sampapi.GetAddress(0x114AF0))[0] end
local function RefSavedDriveByLeft() return ffi.cast('bool*', sampapi.GetAddress(0x1625A8))[0] end
local function RefSavedDriveByRight() return ffi.cast('bool*', sampapi.GetAddress(0x1625A9))[0] end
local Initialize = ffi.cast('void(__cdecl*)()', sampapi.GetAddress(0xA72A0))
local UpdateKeys = ffi.cast('void(__cdecl*)()', sampapi.GetAddress(0xA72C0))
local ApplyKeys = ffi.cast('void(__cdecl*)()', sampapi.GetAddress(0xA7300))
local SetKeys = ffi.cast('void(__cdecl*)(int, const struct CPad*)', sampapi.GetAddress(0xA7340))
local ApplyKeys = ffi.cast('void(__cdecl*)()', sampapi.GetAddress(0xA7300))
local GetInternalKeys = ffi.cast('struct CPad * (__cdecl*)()', sampapi.GetAddress(0xA73B0))
local GetKeys = ffi.cast('struct CPad * (__cdecl*)()', sampapi.GetAddress(0xA73C0))
local GetKeys = ffi.cast('struct CPad * (__cdecl*)()', sampapi.GetAddress(0xA73C0))
local ResetKeys = ffi.cast('void(__cdecl*)(int)', sampapi.GetAddress(0xA73E0))
local ResetInternalKeys = ffi.cast('void(__cdecl*)()', sampapi.GetAddress(0xA7400))

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