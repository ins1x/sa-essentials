--[[
    Project: SAMP-API.lua <https://github.com/imring/SAMP-API.lua>
    Developers: imring, LUCHARE, FYP

    Special thanks:
        SAMemory (https://www.blast.hk/threads/20472/) for implementing the basic functions.
        SAMP-API (https://github.com/BlastHackNet/SAMP-API) for the structures and addresses.
]]

local shared = require 'sampapi.shared'

local ffi = shared.ffi

ffi.cdef[[
typedef struct ID3DXFont ID3DXFont;
typedef struct ID3DXSprite ID3DXSprite;
typedef struct ID3DXRenderToSurface ID3DXRenderToSurface;
typedef struct ID3DXLine ID3DXLine;

typedef struct IDirect3DSurface9 IDirect3DSurface9;
typedef struct IDirect3DTexture9 IDirect3DTexture9;
typedef struct IDirect3DDevice9 IDirect3DDevice9;
typedef struct IDirect3DStateBlock9 IDirect3DStateBlock9;

typedef struct CDXUTDialog CDXUTDialog;
typedef struct CDXUTControl CDXUTControl;
typedef struct CDXUTListBox CDXUTListBox;
typedef struct CDXUTEditBox CDXUTEditBox;
typedef struct CDXUTScrollBar CDXUTScrollBar;
typedef struct CDXUTIMEEditBox CDXUTIMEEditBox;

typedef unsigned long D3DCOLOR;
typedef unsigned long TICK;
typedef int           BOOL;

typedef int            GTAREF; // gta pool reference (scm handle)
typedef unsigned short ID;     // player, vehicle, object, etc
typedef unsigned char  NUMBER;
typedef void(__cdecl* CMDPROC)(const char*);

struct CPed;
struct CPad;
struct CEntity;
struct CSprite2d;
struct CVehicle;
struct CWeapon;
struct CWeaponInfo;
struct CObject;

struct RwObject;
struct RwTexture;

typedef struct RakClientInterface RakClientInterface;
typedef struct Packet Packet;

enum {
    SAMP_VERSION_UNKNOWN = -1,
    SAMP_VERSION_037R1,
    SAMP_VERSION_037R3_1,
    SAMP_VERSION_037R5_1,
};

typedef struct _string {
    union {
        char str[16];
        char* pstr;
    };
    size_t length;
    size_t allocated;
} string;
]]

local module = {
    shared = shared,
}

local sampModule = getModuleHandle('samp.dll')
function module.GetBase() return sampModule end
function module.GetAddress(offset) return module.GetBase() + offset end

local SAMPAPI_VERSION = 2
function module.GetAPIVersion() return SAMPAPI_VERSION end

local init = false
local sampVersion = ffi.C.SAMP_VERSION_UNKNOWN
local versions = {
    [0x31DF13] = ffi.C.SAMP_VERSION_037R1,
    [0xCC4D0] = ffi.C.SAMP_VERSION_037R3_1,
    [0xCBC90] = ffi.C.SAMP_VERSION_037R5_1
}
function module.GetSAMPVersion()
    if not init then
        local base = module.GetBase()
        if base ~= 0 then
            -- ntheader = reinterpret_cast<IMAGE_NT_HEADERS *>(base + reinterpret_cast<IMAGE_DOS_HEADER *>(base)->e_lfanew)
            -- ep = ntheader->OptionalHeader.AddressOfEntryPoint
            local ntheader = module.GetBase() + ffi.cast('long*', module.GetBase() + 0x3C)[0]
            local ep = ffi.cast('unsigned long*', ntheader + 0x28)[0]
            sampVersion = versions[ep] or sampVersion
        end
        init = true
    end
    return sampVersion
end

local versionPaths = {
    [ffi.C.SAMP_VERSION_037R1] = 'v037r1',
    [ffi.C.SAMP_VERSION_037R3_1] = 'v037r3',
    [ffi.C.SAMP_VERSION_037R5_1] = 'v037r5',
}
function module.require(mod, addVersion)
    if addVersion then
        local version = module.GetSAMPVersion()
        assert(version ~= ffi.C.SAMP_VERSION_UNKNOWN, 'Unknown version of SA-MP.')
        mod = versionPaths[version] .. '.' .. mod
    end
    return shared.require(mod)
end

module.GetSAMPVersion()
return module