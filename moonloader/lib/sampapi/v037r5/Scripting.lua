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

shared.ffi.cdef[[
typedef struct SOpcodeInfo SOpcodeInfo;
#pragma pack(push, 2)
struct SOpcodeInfo {
    short unsigned int m_wOpCode;
    char m_szParams[16];
};
#pragma pack(pop)
]]

shared.validate_size('struct SOpcodeInfo', 0x12)

local function RefThread() return ffi.cast('SCRunningScript**', sampapi.GetAddress(0x26B558))[0] end
local function ArrayBuffer() return ffi.cast('unsigned char* ', sampapi.GetAddress(0x26B458)) end
local function RefLastUsedOpcode() return ffi.cast('unsigned long*', sampapi.GetAddress(0x26B55C))[0] end
local function ArrayThreadLocals() return ffi.cast('unsigned long** ', sampapi.GetAddress(0x26B410)) end
local function RefLocalDebug() return ffi.cast('BOOL*', sampapi.GetAddress(0x26B560))[0] end
local function RefProcessOneCommand() return ffi.cast('SProcessOneCommandFn*', sampapi.GetAddress(0x1173B8))[0] end
local Initialize = ffi.cast('void(__cdecl*)()', sampapi.GetAddress(0xB2550))
local ExecBuffer = ffi.cast('int(__cdecl*)()', sampapi.GetAddress(0xB22D0))
-- FunctionProcessCommand = ...

return {
    RefThread = RefThread,
    ArrayBuffer = ArrayBuffer,
    RefLastUsedOpcode = RefLastUsedOpcode,
    ArrayThreadLocals = ArrayThreadLocals,
    RefLocalDebug = RefLocalDebug,
    RefProcessOneCommand = RefProcessOneCommand,
    Initialize = Initialize,
    ExecBuffer = ExecBuffer,
}