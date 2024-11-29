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
enum {
    SETTINGS_STRING_LEN = 256,
};

typedef struct SSettings SSettings;
#pragma pack(push, 1)
struct SSettings {
    BOOL m_bDebugMode;
    BOOL m_bOnlineGame;
    BOOL m_bWindowedMode;
    char m_szPass[257];
    char m_szHost[257];
    char m_szPort[257];
    char m_szNick[257];
    char m_szDebugScript[257];
};
#pragma pack(pop)
]]

shared.validate_size('struct SSettings', 0x511)

local Initialize = ffi.cast('void(__cdecl*)()', sampapi.GetAddress(0xC45B0))
local GetFromCommandLine = ffi.cast('void(__cdecl*)(const char*, char*)', sampapi.GetAddress(0xC3EC0))
local GetFromQuotes = ffi.cast('void(__cdecl*)(const char*, char*)', sampapi.GetAddress(0xC3F10))

local function RefSettings() return ffi.cast('SSettings*', sampapi.GetAddress(0x26DFE8))[0] end

return {
    Initialize = Initialize,
    GetFromCommandLine = GetFromCommandLine,
    GetFromQuotes = GetFromQuotes,
    RefSettings = RefSettings,
}