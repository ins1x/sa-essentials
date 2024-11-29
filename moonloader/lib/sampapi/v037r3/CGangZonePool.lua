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
typedef struct SGangZone SGangZone;
#pragma pack(push, 1)
struct SGangZone {
    struct {
        float left;
        float bottom;
        float right;
        float top;
    } m_rect;
    D3DCOLOR m_color;
    D3DCOLOR m_altColor;
};
#pragma pack(pop)

enum {
    MAX_GANGZONES = 1024,
};

typedef struct SCGangZonePool SCGangZonePool;
#pragma pack(push, 1)
struct SCGangZonePool {
    SGangZone* m_pObject[1024];
    BOOL m_bNotEmpty[1024];
};
#pragma pack(pop)
]]

shared.validate_size('struct SGangZone', 0x18)
shared.validate_size('struct SCGangZonePool', 0x2000)

local CGangZonePool_constructor = ffi.cast('void(__thiscall*)(SCGangZonePool*)', 0x2100)
local CGangZonePool_destructor = ffi.cast('void(__thiscall*)(SCGangZonePool*)', 0x2130)
local function CGangZonePool_new(...)
    local obj = ffi.gc(ffi.new('struct SCGangZonePool[1]'), CGangZonePool_destructor)
    CGangZonePool_constructor(obj, ...)
    return obj
end

local SCGangZonePool_mt = {
    Create = ffi.cast('void(__thiscall*)(SCGangZonePool*, ID, float, float, float, float, D3DCOLOR)', sampapi.GetAddress(0x2160)),
    StartFlashing = ffi.cast('void(__thiscall*)(SCGangZonePool*, ID, D3DCOLOR)', sampapi.GetAddress(0x21E0)),
    StopFlashing = ffi.cast('void(__thiscall*)(SCGangZonePool*, ID)', sampapi.GetAddress(0x2200)),
    Delete = ffi.cast('void(__thiscall*)(SCGangZonePool*, ID)', sampapi.GetAddress(0x2220)),
    Draw = ffi.cast('void(__thiscall*)(SCGangZonePool*)', sampapi.GetAddress(0x2250)),
}
mt.set_handler('struct SCGangZonePool', '__index', SCGangZonePool_mt)

return {
    new = CGangZonePool_new,
}