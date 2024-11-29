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
typedef struct SCPlayerTags SCPlayerTags;
#pragma pack(push, 1)
struct SCPlayerTags {
    struct IDirect3DDevice9* m_pDevice;
    struct IDirect3DStateBlock9* m_pStates;
    struct ID3DXSprite* m_pSprite;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCPlayerTags', 0xc)

local CPlayerTags_constructor = ffi.cast('void(__thiscall*)(SCPlayerTags*, IDirect3DDevice9*)', 0x68610)
local CPlayerTags_destructor = ffi.cast('void(__thiscall*)(SCPlayerTags*)', 0x68640)
local function CPlayerTags_new(...)
    local obj = ffi.gc(ffi.new('struct SCPlayerTags[1]'), CPlayerTags_destructor)
    CPlayerTags_constructor(obj, ...)
    return obj
end

local SCPlayerTags_mt = {
    EndHealthBar = ffi.cast('void(__thiscall*)(SCPlayerTags*)', sampapi.GetAddress(0x68670)),
    BeginLabel = ffi.cast('void(__thiscall*)(SCPlayerTags*)', sampapi.GetAddress(0x686A0)),
    EndLabel = ffi.cast('void(__thiscall*)(SCPlayerTags*)', sampapi.GetAddress(0x686B0)),
    DrawLabel = ffi.cast('void(__thiscall*)(SCPlayerTags*, SCVector*, const char*, D3DCOLOR, float, bool, int)', sampapi.GetAddress(0x686C0)),
    DrawHealthBar = ffi.cast('void(__thiscall*)(SCPlayerTags*, SCVector*, float, float, float)', sampapi.GetAddress(0x689C0)),
    OnLostDevice = ffi.cast('void(__thiscall*)(SCPlayerTags*)', sampapi.GetAddress(0x68F70)),
    OnResetDevice = ffi.cast('void(__thiscall*)(SCPlayerTags*)', sampapi.GetAddress(0x68FA0)),
    BeginHealthBar = ffi.cast('void(__thiscall*)(SCPlayerTags*)', sampapi.GetAddress(0x68FD0)),
}
mt.set_handler('struct SCPlayerTags', '__index', SCPlayerTags_mt)

local function RefPlayerTags() return ffi.cast('SCPlayerTags**', sampapi.GetAddress(0x21A0B0))[0] end

return {
    new = CPlayerTags_new,
    RefPlayerTags = RefPlayerTags,
}