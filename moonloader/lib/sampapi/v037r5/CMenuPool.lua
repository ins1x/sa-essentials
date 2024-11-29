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

shared.require 'v037r5.CMenu'

shared.ffi.cdef[[
enum {
    MAX_MENUS = 128,
};

typedef struct SCMenuPool SCMenuPool;
#pragma pack(push, 1)
struct SCMenuPool {
    SCMenu* m_pObject[128];
    BOOL m_bNotEmpty[128];
    NUMBER m_nCurrent;
    bool m_bCanceled;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCMenuPool', 0x402)

local CMenuPool_constructor = ffi.cast('void(__thiscall*)(SCMenuPool*)', 0x7E60)
local CMenuPool_destructor = ffi.cast('void(__thiscall*)(SCMenuPool*)', 0x81C0)
local function CMenuPool_new(...)
    local obj = ffi.gc(ffi.new('struct SCMenuPool[1]'), CMenuPool_destructor)
    CMenuPool_constructor(obj, ...)
    return obj
end

local SCMenuPool_mt = {
    Create = ffi.cast('SCMenu * (__thiscall*)(SCMenuPool*, NUMBER, float, float, char, float, float, const SInteraction*)', sampapi.GetAddress(0x7EB0)),
    Delete = ffi.cast('BOOL(__thiscall*)(SCMenuPool*, NUMBER)', sampapi.GetAddress(0x7F70)),
    Show = ffi.cast('void(__thiscall*)(SCMenuPool*, NUMBER)', sampapi.GetAddress(0x7FC0)),
    Hide = ffi.cast('void(__thiscall*)(SCMenuPool*, NUMBER)', sampapi.GetAddress(0x8020)),
    GetTextPointer = ffi.cast('char*(__thiscall*)(SCMenuPool*, const char*)', sampapi.GetAddress(0x8060)),
    Process = ffi.cast('void(__thiscall*)(SCMenuPool*)', sampapi.GetAddress(0x8200)),
}
mt.set_handler('struct SCMenuPool', '__index', SCMenuPool_mt)

return {
    new = CMenuPool_new,
}