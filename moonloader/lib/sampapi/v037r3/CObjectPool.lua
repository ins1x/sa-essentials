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

shared.require 'v037r3.CEntity'
shared.require 'v037r3.CObject'
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

local CObjectPool_constructor = ffi.cast('void(__thiscall*)(SCObjectPool*)', 0x124B0)
local CObjectPool_destructor = ffi.cast('void(__thiscall*)(SCObjectPool*)', 0x12E10)
local function CObjectPool_new(...)
    local obj = ffi.gc(ffi.new('struct SCObjectPool[1]'), CObjectPool_destructor)
    CObjectPool_constructor(obj, ...)
    return obj
end

local SCObjectPool_mt = {
    UpdateLargestId = ffi.cast('void(__thiscall*)(SCObjectPool*)', sampapi.GetAddress(0x12450)),
    GetCount = ffi.cast('int(__thiscall*)(SCObjectPool*)', sampapi.GetAddress(0x124E0)),
    Delete = ffi.cast('BOOL(__thiscall*)(SCObjectPool*, ID)', sampapi.GetAddress(0x12500)),
    Create = ffi.cast('BOOL(__thiscall*)(SCObjectPool*, ID, int, SCVector, SCVector, float)', sampapi.GetAddress(0x12580)),
    Find = ffi.cast('SCObject * (__thiscall*)(SCObjectPool*, struct CObject*)', sampapi.GetAddress(0x12680)),
    GetId = ffi.cast('int(__thiscall*)(SCObjectPool*, struct CObject*)', sampapi.GetAddress(0x126C0)),
    Process = ffi.cast('void(__thiscall*)(SCObjectPool*)', sampapi.GetAddress(0x12700)),
    ConstructMaterials = ffi.cast('void(__thiscall*)(SCObjectPool*)', sampapi.GetAddress(0x127C0)),
    ShutdownMaterials = ffi.cast('void(__thiscall*)(SCObjectPool*)', sampapi.GetAddress(0x12800)),
    Draw = ffi.cast('void(__thiscall*)(SCObjectPool*)', sampapi.GetAddress(0x12840)),
    DrawLast = ffi.cast('void(__thiscall*)(SCObjectPool*)', sampapi.GetAddress(0x12880)),
    Get = ffi.cast('SCObject * (__thiscall*)(SCObjectPool*, ID)', sampapi.GetAddress(0x2DC0)),
}
mt.set_handler('struct SCObjectPool', '__index', SCObjectPool_mt)

return {
    new = CObjectPool_new,
}