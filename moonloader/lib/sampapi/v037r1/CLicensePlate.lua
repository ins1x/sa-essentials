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
enum {
    DEFAULT_PLATE_TEXT_COLOR = -297515920,
    DEFAULT_PLATE_BG_COLOR = -4278616,
};

typedef struct SCLicensePlate SCLicensePlate;
#pragma pack(push, 1)
struct SCLicensePlate {
    struct IDirect3DDevice9* m_pDevice;
    struct ID3DXRenderToSurface* m_pRenderer;
    struct IDirect3DTexture9* m_pTexture;
    struct IDirect3DSurface9* m_pSurface;
    unsigned int m_displayMode[4];
    struct IDirect3DTexture9* m_pDefaultPlate;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCLicensePlate', 0x24)

local CLicensePlate_constructor = ffi.cast('void(__thiscall*)(SCLicensePlate*, IDirect3DDevice9*)', 0x692D0)
local CLicensePlate_destructor = ffi.cast('void(__thiscall*)(SCLicensePlate*)', 0x69300)
local function CLicensePlate_new(...)
    local obj = ffi.gc(ffi.new('struct SCLicensePlate[1]'), CLicensePlate_destructor)
    CLicensePlate_constructor(obj, ...)
    return obj
end

local SCLicensePlate_mt = {
    OnLostDevice = ffi.cast('void(__thiscall*)(SCLicensePlate*)', sampapi.GetAddress(0x690D0)),
    OnResetDevice = ffi.cast('void(__thiscall*)(SCLicensePlate*)', sampapi.GetAddress(0x69120)),
    Create = ffi.cast('IDirect3DTexture9 * (__thiscall*)(SCLicensePlate*, const char*)', sampapi.GetAddress(0x691A0)),
}
mt.set_handler('struct SCLicensePlate', '__index', SCLicensePlate_mt)

local function RefLicensePlateManager() return ffi.cast('SCLicensePlate**', sampapi.GetAddress(0x21A100))[0] end

return {
    new = CLicensePlate_new,
    RefLicensePlateManager = RefLicensePlateManager,
}