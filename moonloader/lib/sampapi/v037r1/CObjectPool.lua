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

shared.require 'v037r1.CEntity'
shared.require 'v037r1.CVehicle'
shared.require 'v037r1.CObject'
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

local CObjectPool_constructor = ffi.cast('void(__thiscall*)(SCObjectPool*)', 0xF3A0)
local CObjectPool_destructor = ffi.cast('void(__thiscall*)(SCObjectPool*)', 0xFCB0)
local function CObjectPool_new(...)
    local obj = ffi.gc(ffi.new('struct SCObjectPool[1]'), CObjectPool_destructor)
    CObjectPool_constructor(obj, ...)
    return obj
end

local function RefLastProcess() return ffi.cast('TICK*', sampapi.GetAddress(0x1049B0))[0] end

local SCObjectPool_mt = {
    UpdateLargestId = ffi.cast('void(__thiscall*)(SCObjectPool*)', sampapi.GetAddress(0xF340)),
    GetCount = ffi.cast('int(__thiscall*)(SCObjectPool*)', sampapi.GetAddress(0xF3D0)),
    Delete = ffi.cast('BOOL(__thiscall*)(SCObjectPool*, ID)', sampapi.GetAddress(0xF3F0)),
    Create = ffi.cast('BOOL(__thiscall*)(SCObjectPool*, ID, int, SCVector, SCVector, float)', sampapi.GetAddress(0xF470)),
    Find = ffi.cast('SCObject * (__thiscall*)(SCObjectPool*, struct CObject*)', sampapi.GetAddress(0xF520)),
    GetId = ffi.cast('int(__thiscall*)(SCObjectPool*, struct CObject*)', sampapi.GetAddress(0xF560)),
    Process = ffi.cast('void(__thiscall*)(SCObjectPool*)', sampapi.GetAddress(0xF5A0)),
    ConstructMaterials = ffi.cast('void(__thiscall*)(SCObjectPool*)', sampapi.GetAddress(0xF660)),
    ShutdownMaterials = ffi.cast('void(__thiscall*)(SCObjectPool*)', sampapi.GetAddress(0xF6A0)),
    Draw = ffi.cast('void(__thiscall*)(SCObjectPool*)', sampapi.GetAddress(0xF6E0)),
    DrawLast = ffi.cast('void(__thiscall*)(SCObjectPool*)', sampapi.GetAddress(0xF720)),
    Get = ffi.cast('SCObject*(__thiscall*)(SCObjectPool*, ID)', sampapi.GetAddress(0x2DD0)),
}
mt.set_handler('struct SCObjectPool', '__index', SCObjectPool_mt)

return {
    new = CObjectPool_new,
    RefLastProcess = RefLastProcess,
}