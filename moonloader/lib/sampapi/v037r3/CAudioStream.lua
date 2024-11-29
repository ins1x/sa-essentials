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

local function RefStream() return ffi.cast('int*', sampapi.GetAddress(0x12E68C))[0] end
local function RefIsPlaying() return ffi.cast('bool*', sampapi.GetAddress(0x12E690))[0] end
local function RefPosition() return ffi.cast('SCVector*', sampapi.GetAddress(0x12E694))[0] end
local function RefIs3d() return ffi.cast('bool*', sampapi.GetAddress(0x12E6A0))[0] end
local function ArrayIcyUrl() return ffi.cast('char* ', sampapi.GetAddress(0x12E588)) end
local function ArrayInfo() return ffi.cast('char* ', sampapi.GetAddress(0x12E480)) end
local function ArrayUrl() return ffi.cast('char* ', sampapi.GetAddress(0x12E378)) end
local function RefNeedsToDestroy() return ffi.cast('bool*', sampapi.GetAddress(0x1027BA))[0] end
local function RefRadius() return ffi.cast('float*', sampapi.GetAddress(0x1027BC))[0] end
local function ArrayIcyName() return ffi.cast('char* ', sampapi.GetAddress(0x12E270)) end
local ConstructInfo = ffi.cast('void(__cdecl*)()', sampapi.GetAddress(0x65E50))
local SyncProc = ffi.cast('void(__stdcall*)(int, int, int, void*)', sampapi.GetAddress(0x65F80))
local Process = ffi.cast('void(__cdecl*)(void*)', sampapi.GetAddress(0x65F90))

local SCAudioStream_mt = {
    Reset = ffi.cast('BOOL(__thiscall*)(SCAudioStream*)', sampapi.GetAddress(0x65D10)),
    Stop = ffi.cast('BOOL(__thiscall*)(SCAudioStream*, bool)', sampapi.GetAddress(0x65DF0)),
    Play = ffi.cast('BOOL(__thiscall*)(SCAudioStream*, const char*, SCVector, float, bool)', sampapi.GetAddress(0x661F0)),
    ControlGameRadio = ffi.cast('void(__thiscall*)(SCAudioStream*)', sampapi.GetAddress(0x66310)),
    DrawInfo = ffi.cast('void(__thiscall*)(SCAudioStream*)', sampapi.GetAddress(0x66340)),
}
mt.set_handler('struct SCAudioStream', '__index', SCAudioStream_mt)

local function RefAudioStream() return ffi.cast('SCAudioStream**', sampapi.GetAddress(0x26E8D4))[0] end

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