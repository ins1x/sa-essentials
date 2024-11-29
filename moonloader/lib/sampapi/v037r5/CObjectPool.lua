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

shared.require 'v037r5.CEntity'
shared.require 'v037r5.CObject'
shared.require 'CMatrix'
shared.require 'CVector'

shared.ffi.cdef[[
enum {
    MAX_OBJECTS = 1000,
};

typedef struct SCObjectPool SCObjectPool;
#pragma pack(push, 1)
struct SCObjectPool {
    int m_nLargestId;
    BOOL m_bNotEmpty[1000];
    SCObject* m_pObject[1000];
};
#pragma pack(pop)
]]

shared.validate_size('struct SCObjectPool', 0x1f44)

local CObjectPool_constructor = ffi.cast('void(__thiscall*)(SCObjectPool*)', 0x12800)
local CObjectPool_destructor = ffi.cast('void(__thiscall*)(SCObjectPool*)', 0x13160)
local function CObjectPool_new(...)
    local obj = ffi.gc(ffi.new('struct SCObjectPool[1]'), CObjectPool_destructor)
    CObjectPool_constructor(obj, ...)
    return obj
end

local SCObjectPool_mt = {
    UpdateLargestId = ffi.cast('void(__thiscall*)(SCObjectPool*)', sampapi.GetAddress(0x127A0)),
    GetCount = ffi.cast('int(__thiscall*)(SCObjectPool*)', sampapi.GetAddress(0x12830)),
    Delete = ffi.cast('BOOL(__thiscall*)(SCObjectPool*, ID)', sampapi.GetAddress(0x12850)),
    Create = ffi.cast('BOOL(__thiscall*)(SCObjectPool*, ID, int, SCVector, SCVector, float)', sampapi.GetAddress(0x128D0)),
    Find = ffi.cast('SCObject * (__thiscall*)(SCObjectPool*, struct CObject*)', sampapi.GetAddress(0x129D0)),
    GetId = ffi.cast('int(__thiscall*)(SCObjectPool*, struct CObject*)', sampapi.GetAddress(0x12A10)),
    Process = ffi.cast('void(__thiscall*)(SCObjectPool*)', sampapi.GetAddress(0x12A50)),
    ConstructMaterials = ffi.cast('void(__thiscall*)(SCObjectPool*)', sampapi.GetAddress(0x12B10)),
    ShutdownMaterials = ffi.cast('void(__thiscall*)(SCObjectPool*)', sampapi.GetAddress(0x12B50)),
    Draw = ffi.cast('void(__thiscall*)(SCObjectPool*)', sampapi.GetAddress(0x12B90)),
    DrawLast = ffi.cast('void(__thiscall*)(SCObjectPool*)', sampapi.GetAddress(0x12BD0)),
    Get = ffi.cast('SCObject * (__thiscall*)(SCObjectPool*, ID)', sampapi.GetAddress(0x2DE0)),
}
mt.set_handler('struct SCObjectPool', '__index', SCObjectPool_mt)

return {
    new = CObjectPool_new,
}