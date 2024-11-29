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
enum {
    AUDIOSTREAM_MAX_STRING = 256,
};

typedef struct SCAudioStream SCAudioStream;
#pragma pack(push, 1)
struct SCAudioStream {
    bool m_bInitialized;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCAudioStream', 0x1)

local function RefStream() return ffi.cast('int*', sampapi.GetAddress(0x12E7B4))[0] end
local function RefIsPlaying() return ffi.cast('bool*', sampapi.GetAddress(0x12E7B8))[0] end
local function RefPosition() return ffi.cast('SCVector*', sampapi.GetAddress(0x12E7BC))[0] end
local function RefIs3d() return ffi.cast('bool*', sampapi.GetAddress(0x12E7C8))[0] end
local function ArrayIcyUrl() return ffi.cast('char* ', sampapi.GetAddress(0x12E6B0)) end
local function ArrayInfo() return ffi.cast('char* ', sampapi.GetAddress(0x12E5A8)) end
local function ArrayUrl() return ffi.cast('char* ', sampapi.GetAddress(0x12E4A0)) end
local function RefNeedsToDestroy() return ffi.cast('bool*', sampapi.GetAddress(0x1027D2))[0] end
local function RefRadius() return ffi.cast('float*', sampapi.GetAddress(0x1027D4))[0] end
local function ArrayIcyName() return ffi.cast('char* ', sampapi.GetAddress(0x12E398)) end
local ConstructInfo = ffi.cast('void(__cdecl*)()', sampapi.GetAddress(0x665C0))
local SyncProc = ffi.cast('void(__stdcall*)(int, int, int, void*)', sampapi.GetAddress(0x666F0))
local Process = ffi.cast('void(__cdecl*)(void*)', sampapi.GetAddress(0x66700))

local SCAudioStream_mt = {
    Reset = ffi.cast('BOOL(__thiscall*)(SCAudioStream*)', sampapi.GetAddress(0x66480)),
    Stop = ffi.cast('BOOL(__thiscall*)(SCAudioStream*, bool)', sampapi.GetAddress(0x66560)),
    Play = ffi.cast('BOOL(__thiscall*)(SCAudioStream*, const char*, SCVector, float, bool)', sampapi.GetAddress(0x66960)),
    ControlGameRadio = ffi.cast('void(__thiscall*)(SCAudioStream*)', sampapi.GetAddress(0x66A80)),
    DrawInfo = ffi.cast('void(__thiscall*)(SCAudioStream*)', sampapi.GetAddress(0x66AB0)),
}
mt.set_handler('struct SCAudioStream', '__index', SCAudioStream_mt)

local function RefAudioStream() return ffi.cast('SCAudioStream**', sampapi.GetAddress(0x26EB8C))[0] end

return {
    RefStream = RefStream,
    RefIsPlaying = RefIsPlaying,
    RefPosition = RefPosition,
    RefIs3d = RefIs3d,
    ArrayIcyUrl = ArrayIcyUrl,
    ArrayInfo = ArrayInfo,
    ArrayUrl = ArrayUrl,
    RefNeedsToDestroy = RefNeedsToDestroy,
    RefRadius = RefRadius,
    ArrayIcyName = ArrayIcyName,
    ConstructInfo = ConstructInfo,
    SyncProc = SyncProc,
    Process = Process,
    RefAudioStream = RefAudioStream,
}