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

shared.require 'v037r1.CEntity'
shared.require 'v037r1.CVehicle'
shared.require 'v037r1.CObject'
shared.require 'v037r1.CObjectPool'
shared.require 'CMatrix'
shared.require 'CVector'

shared.ffi.cdef[[
enum {
    LINE_BUFFER_LENGTH = 256,
};
]]

local function RefPrivateObjectPool() return ffi.cast('SCObjectPool**', sampapi.GetAddress(0x13BB74))[0] end
local function RefObjectCount() return ffi.cast('unsigned short*', sampapi.GetAddress(0x13BB78))[0] end
local function RefNewCameraPos() return ffi.cast('SCVector*', sampapi.GetAddress(0x13BB68))[0] end
local Initialize = ffi.cast('void(__cdecl*)(const char*)', sampapi.GetAddress(0x99FF0))
local ProcessLine = ffi.cast('void(__cdecl*)(const char*)', sampapi.GetAddress(0x99EE0))
local GetCommandParams = ffi.cast('char*(__cdecl*)(char*)', sampapi.GetAddress(0x99AF0))
local CreateVehicle = ffi.cast('void(__cdecl*)(const char*)', sampapi.GetAddress(0x99C50))

return {
    RefPrivateObjectPool = RefPrivateObjectPool,
    RefObjectCount = RefObjectCount,
    RefNewCameraPos = RefNewCameraPos,
    Initialize = Initialize,
    ProcessLine = ProcessLine,
    GetCommandParams = GetCommandParams,
    CreateVehicle = CreateVehicle,
}