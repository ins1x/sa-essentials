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
    SOUND_OFF = 0,
};

typedef struct SCAudio SCAudio;
#pragma pack(push, 1)
struct SCAudio {
    BOOL m_bSoundLoaded;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCAudio', 0x4)

local SCAudio_mt = {
    Play = ffi.cast('void(__thiscall*)(SCAudio*, int, SCVector)', sampapi.GetAddress(0x9D730)),
    StartRadio = ffi.cast('void(__thiscall*)(SCAudio*, unsigned char)', sampapi.GetAddress(0x9D860)),
    GetRadioVolume = ffi.cast('float(__thiscall*)(SCAudio*)', sampapi.GetAddress(0x9D8A0)),
}
mt.set_handler('struct SCAudio', '__index', SCAudio_mt)