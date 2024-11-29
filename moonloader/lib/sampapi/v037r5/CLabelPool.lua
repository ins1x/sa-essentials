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
typedef struct STextLabel STextLabel;
#pragma pack(push, 1)
struct STextLabel {
    char* m_pText;
    D3DCOLOR m_color;
    SCVector m_position;
    float m_fDrawDistance;
    bool m_bBehindWalls;
    ID m_nAttachedToPlayer;
    ID m_nAttachedToVehicle;
};
#pragma pack(pop)

enum {
    MAX_TEXT_LABELS = 2048,
};

typedef struct SCLabelPool SCLabelPool;
#pragma pack(push, 1)
struct SCLabelPool {
    STextLabel m_object[2048];
    BOOL m_bNotEmpty[2048];
};
#pragma pack(pop)
]]

shared.validate_size('struct STextLabel', 0x1d)
shared.validate_size('struct SCLabelPool', 0x10800)

local CLabelPool_constructor = ffi.cast('void(__thiscall*)(SCLabelPool*)', 0x1190)
local CLabelPool_destructor = ffi.cast('void(__thiscall*)(SCLabelPool*)', 0x15E0)
local function CLabelPool_new(...)
    local obj = ffi.gc(ffi.new('struct SCLabelPool[1]'), CLabelPool_destructor)
    CLabelPool_constructor(obj, ...)
    return obj
end

local SCLabelPool_mt = {
    Create = ffi.cast('void(__thiscall*)(SCLabelPool*, ID, const char*, D3DCOLOR, SCVector, float, bool, ID, ID)', sampapi.GetAddress(0x11D0)),
    Delete = ffi.cast('BOOL(__thiscall*)(SCLabelPool*, ID)', sampapi.GetAddress(0x12E0)),
    Draw = ffi.cast('void(__thiscall*)(SCLabelPool*)', sampapi.GetAddress(0x1350)),
}
mt.set_handler('struct SCLabelPool', '__index', SCLabelPool_mt)

return {
    new = CLabelPool_new,
}