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

local function RefLocalPlayerKeys() return ffi.cast('struct CPad*', sampapi.GetAddress(0x152518))[0] end
local function ArrayPlayerKeys() return ffi.cast('struct CPad* ', sampapi.GetAddress(0x152650)) end
local function RefInternalKeys() return ffi.cast('struct CPad**', sampapi.GetAddress(0x114AD0))[0] end
local function RefDriveByLeft() return ffi.cast('bool**', sampapi.GetAddress(0x114AD4))[0] end
local function RefDriveByRight() return ffi.cast('bool**', sampapi.GetAddress(0x114AD8))[0] end
local function RefSavedDriveByLeft() return ffi.cast('bool*', sampapi.GetAddress(0x1622F8))[0] end
local function RefSavedDriveByRight() return ffi.cast('bool*', sampapi.GetAddress(0x1622F9))[0] end
local Initialize = ffi.cast('void(__cdecl*)()', sampapi.GetAddress(0xA6B60))
local UpdateKeys = ffi.cast('void(__cdecl*)()', sampapi.GetAddress(0xA6B80))
local ApplyKeys = ffi.cast('void(__cdecl*)()', sampapi.GetAddress(0xA6BC0))
local SetKeys = ffi.cast('void(__cdecl*)(int, const struct CPad*)', sampapi.GetAddress(0xA6C00))
local ApplyKeys = ffi.cast('void(__cdecl*)()', sampapi.GetAddress(0xA6BC0))
local GetInternalKeys = ffi.cast('struct CPad * (__cdecl*)()', sampapi.GetAddress(0xA6C70))
local GetKeys = ffi.cast('struct CPad * (__cdecl*)()', sampapi.GetAddress(0xA6C80))
local GetKeys = ffi.cast('struct CPad * (__cdecl*)()', sampapi.GetAddress(0xA6C80))
local ResetKeys = ffi.cast('void(__cdecl*)(int)', sampapi.GetAddress(0xA6CA0))
local ResetInternalKeys = ffi.cast('void(__cdecl*)()', sampapi.GetAddress(0xA6CC0))

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