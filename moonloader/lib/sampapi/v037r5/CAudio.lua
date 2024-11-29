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
enum SSoundId {
    SOUND_OFF = 0,
    SOUND_DISABLE_OUTDOOR_AMBIENCE_TRACK = 1,
};
typedef enum SSoundId SSoundId;

typedef struct SCAudio SCAudio;
#pragma pack(push, 1)
struct SCAudio {
    BOOL m_bSoundLoaded;
    bool m_bOutdoorAmbienceTrackDisabled;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCAudio', 0x5)

local SCAudio_mt = {
    GetRadioStation = ffi.cast('int(__thiscall*)(SCAudio*)', sampapi.GetAddress(0xA2210)),
    StartRadio = ffi.cast('void(__thiscall*)(SCAudio*, int)', sampapi.GetAddress(0xA2240)),
    StopRadio = ffi.cast('void(__thiscall*)(SCAudio*)', sampapi.GetAddress(0xA2260)),
    GetRadioVolume = ffi.cast('float(__thiscall*)(SCAudio*)', sampapi.GetAddress(0xA2280)),
    StopOutdoorAmbienceTrack = ffi.cast('void(__thiscall*)(SCAudio*)', sampapi.GetAddress(0xA2290)),
    SetOutdoorAmbienceTrack = ffi.cast('void(__thiscall*)(SCAudio*, int)', sampapi.GetAddress(0xA22A0)),
    Play = ffi.cast('void(__thiscall*)(SCAudio*, int, SCVector)', sampapi.GetAddress(0xA22C0)),
    IsOutdoorAmbienceTrackDisabled = ffi.cast('bool(__thiscall*)(SCAudio*)', sampapi.GetAddress(0xA23A0)),
}
mt.set_handler('struct SCAudio', '__index', SCAudio_mt)