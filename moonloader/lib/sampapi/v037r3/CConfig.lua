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
    MAX_ENTRIES = 512,
    MAX_ENTRY_NAME = 40,
};

enum SValueType {
    VALUE_TYPE_NONE = 0,
    VALUE_TYPE_INT = 1,
    VALUE_TYPE_STRING = 2,
    VALUE_TYPE_FLOAT = 3,
};
typedef enum SValueType SValueType;

typedef struct SConfigEntry SConfigEntry;
#pragma pack(push, 1)
struct SConfigEntry {
    char m_szName[41];
    BOOL m_bReadOnly;
    int m_nType;
    int m_nValue;
    float m_fValue;
    char* m_szValue;
};
#pragma pack(pop)

typedef struct SCConfig SCConfig;
#pragma pack(push, 1)
struct SCConfig {
    SConfigEntry m_entry[512];
    BOOL m_bNotEmpty[512];
    char m_szFilename[261];
    int m_nFirstFree;
};
#pragma pack(pop)
]]

shared.validate_size('struct SConfigEntry', 0x3d)
shared.validate_size('struct SCConfig', 0x8309)

local CConfig_constructor = ffi.cast('void(__thiscall*)(SCConfig*, const char*)', 0x65C70)
local CConfig_destructor = ffi.cast('void(__thiscall*)(SCConfig*)', 0x65490)
local function CConfig_new(...)
    local obj = ffi.gc(ffi.new('struct SCConfig[1]'), CConfig_destructor)
    CConfig_constructor(obj, ...)
    return obj
end

local SCConfig_mt = {
    FindFirstFree = ffi.cast('void(__thiscall*)(SCConfig*)', sampapi.GetAddress(0x654D0)),
    GetIndex = ffi.cast('int(__thiscall*)(SCConfig*, const char*)', sampapi.GetAddress(0x65520)),
    DoesExist = ffi.cast('bool(__thiscall*)(SCConfig*, const char*)', sampapi.GetAddress(0x655C0)),
    CreateEntry = ffi.cast('int(__thiscall*)(SCConfig*, const char*)', sampapi.GetAddress(0x655E0)),
    GetIntValue = ffi.cast('int(__thiscall*)(SCConfig*, const char*)', sampapi.GetAddress(0x656A0)),
    GetStringValue = ffi.cast('const char*(__thiscall*)(SCConfig*, const char*)', sampapi.GetAddress(0x656D0)),
    GetFloatValue = ffi.cast('float(__thiscall*)(SCConfig*, const char*)', sampapi.GetAddress(0x65700)),
    Free = ffi.cast('BOOL(__thiscall*)(SCConfig*, const char*)', sampapi.GetAddress(0x65730)),
    GetValueType = ffi.cast('int(__thiscall*)(SCConfig*, const char*)', sampapi.GetAddress(0x65790)),
    GetEntry = ffi.cast('SConfigEntry * (__thiscall*)(SCConfig*, int)', sampapi.GetAddress(0x657C0)),
    GetType = ffi.cast('int(__thiscall*)(SCConfig*, const char*)', sampapi.GetAddress(0x657F0)),
    Save = ffi.cast('BOOL(__thiscall*)(SCConfig*)', sampapi.GetAddress(0x65860)),
    WriteIntValue = ffi.cast('BOOL(__thiscall*)(SCConfig*, const char*, int, BOOL)', sampapi.GetAddress(0x65910)),
    WriteStringValue = ffi.cast('BOOL(__thiscall*)(SCConfig*, const char*, const char*, BOOL)', sampapi.GetAddress(0x65970)),
    WriteFloatValue = ffi.cast('BOOL(__thiscall*)(SCConfig*, const char*, float, BOOL)', sampapi.GetAddress(0x65A10)),
    Write = ffi.cast('void(__thiscall*)(SCConfig*, const char*, char*)', sampapi.GetAddress(0x65A70)),
    Load = ffi.cast('BOOL(__thiscall*)(SCConfig*)', sampapi.GetAddress(0x65B00)),
}
mt.set_handler('struct SCConfig', '__index', SCConfig_mt)

local function RefConfig() return ffi.cast('SCConfig**', sampapi.GetAddress(0x26E8C4))[0] end

return {
    new = CConfig_new,
    RefConfig = RefConfig,
}