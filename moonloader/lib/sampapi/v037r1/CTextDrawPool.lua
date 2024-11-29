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

shared.require 'v037r1.CTextDraw'
shared.require 'CVector'

shared.ffi.cdef[[
enum {
    MAX_TEXTDRAWS = 2048,
    MAX_LOCAL_TEXTDRAWS = 256,
};

typedef struct SCTextDrawPool SCTextDrawPool;
#pragma pack(push, 1)
struct SCTextDrawPool {
    BOOL m_bNotEmpty[2304];
    SCTextDraw* m_pObject[2304];
};
#pragma pack(pop)
]]

shared.validate_size('struct SCTextDrawPool', 0x4800)

local CTextDrawPool_constructor = ffi.cast('void(__thiscall*)(SCTextDrawPool*)', 0x1ACB0)
local CTextDrawPool_destructor = ffi.cast('void(__thiscall*)(SCTextDrawPool*)', 0x1ADE0)
local function CTextDrawPool_new(...)
    local obj = ffi.gc(ffi.new('struct SCTextDrawPool[1]'), CTextDrawPool_destructor)
    CTextDrawPool_constructor(obj, ...)
    return obj
end

local SCTextDrawPool_mt = {
    Delete = ffi.cast('void(__thiscall*)(SCTextDrawPool*, ID)', sampapi.GetAddress(0x1AD00)),
    Draw = ffi.cast('void(__thiscall*)(SCTextDrawPool*)', sampapi.GetAddress(0x1AD40)),
    Create = ffi.cast('SCTextDraw * (__thiscall*)(SCTextDrawPool*, int, STransmit*, const char*)', sampapi.GetAddress(0x1AE20)),
}
mt.set_handler('struct SCTextDrawPool', '__index', SCTextDrawPool_mt)

return {
    new = CTextDrawPool_new,
}