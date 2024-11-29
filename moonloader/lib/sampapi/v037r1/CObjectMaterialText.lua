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
typedef struct SCObjectMaterialText SCObjectMaterialText;
#pragma pack(push, 1)
struct SCObjectMaterialText {
    struct IDirect3DDevice9* m_pDevice;
    struct ID3DXSprite* m_pSprite;
    struct ID3DXSprite* m_pSprite_0;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCObjectMaterialText', 0xc)

local CObjectMaterialText_constructor = ffi.cast('void(__thiscall*)(SCObjectMaterialText*, IDirect3DDevice9*)', 0x6C2A0)
local CObjectMaterialText_destructor = ffi.cast('void(__thiscall*)(SCObjectMaterialText*)', 0x6C2C0)
local function CObjectMaterialText_new(...)
    local obj = ffi.gc(ffi.new('struct SCObjectMaterialText[1]'), CObjectMaterialText_destructor)
    CObjectMaterialText_constructor(obj, ...)
    return obj
end

local SCObjectMaterialText_mt = {
    OnResetDevice = ffi.cast('void(__thiscall*)(SCObjectMaterialText*)', sampapi.GetAddress(0x6C280)),
    OnLostDevice = ffi.cast('void(__thiscall*)(SCObjectMaterialText*)', sampapi.GetAddress(0x6C250)),
    Create = ffi.cast('IDirect3DTexture9 * (__thiscall*)(SCObjectMaterialText*, const char*, const char*, char, int, int, D3DCOLOR, D3DCOLOR, bool, char)', sampapi.GetAddress(0x6C2D0)),
}
mt.set_handler('struct SCObjectMaterialText', '__index', SCObjectMaterialText_mt)

local function RefObjectMaterialTextManager() return ffi.cast('SCObjectMaterialText**', sampapi.GetAddress(0x21A104))[0] end

return {
    new = CObjectMaterialText_new,
    RefObjectMaterialTextManager = RefObjectMaterialTextManager,
}