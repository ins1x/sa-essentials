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

shared.require 'CRect'
shared.require 'v037r5.CFont'
shared.require 'v037r5.CFonts'

shared.ffi.cdef[[
enum SEntryType {
    ENTRY_TYPE_NONE = 0,
    ENTRY_TYPE_CHAT = 2,
    ENTRY_TYPE_INFO = 4,
    ENTRY_TYPE_DEBUG = 8,
};
typedef enum SEntryType SEntryType;

enum SDisplayMode {
    DISPLAY_MODE_OFF = 0,
    DISPLAY_MODE_NOSHADOW = 1,
    DISPLAY_MODE_NORMAL = 2,
};
typedef enum SDisplayMode SDisplayMode;

enum {
    MAX_MESSAGES = 100,
};

typedef struct SChatEntry SChatEntry;
#pragma pack(push, 1)
struct SChatEntry {
    int m_timestamp;
    char m_szPrefix[28];
    char m_szText[144];
    char unused[64];
    int m_nType;
    D3DCOLOR m_textColor;
    D3DCOLOR m_prefixColor;
};
#pragma pack(pop)

typedef struct SCChat SCChat;
#pragma pack(push, 1)
struct SCChat {
    unsigned int m_nPageSize;
    char* m_szLastMessage;
    int m_nMode;
    bool m_bTimestamps;
    BOOL m_bDoesLogExist;
    char m_szLogPath[261];
    struct CDXUTDialog* m_pGameUi;
    struct CDXUTEditBox* m_pEditbox;
    struct CDXUTScrollBar* m_pScrollbar;
    D3DCOLOR m_textColor;
    D3DCOLOR m_infoColor;
    D3DCOLOR m_debugColor;
    long int m_nWindowBottom;
    SChatEntry m_entry[100];
    SCFonts* m_pFontRenderer;
    struct ID3DXSprite* m_pTextSprite;
    struct ID3DXSprite* m_pSprite;
    struct IDirect3DDevice9* m_pDevice;
    BOOL m_bRenderToSurface;
    struct ID3DXRenderToSurface* m_pRenderToSurface;
    struct IDirect3DTexture9* m_pTexture;
    struct IDirect3DSurface9* m_pSurface;
    unsigned int m_displayMode[4];
    int pad_[2];
    BOOL m_bRedraw;
    long int m_nScrollbarPos;
    long int m_nCharHeight;
    long int m_nTimestampWidth;
};
#pragma pack(pop)
]]

shared.validate_size('struct SChatEntry', 0xfc)
shared.validate_size('struct SCChat', 0x63ea)

local function RefChat() return ffi.cast('SCChat**', sampapi.GetAddress(0x26EB80))[0] end
local CChat_constructor = ffi.cast('void(__thiscall*)(SCChat*, IDirect3DDevice9*, SCFonts*, const char*)', 0x68380)
local function CChat_new(...)
    local obj = ffi.new('struct SCChat[1]')
    CChat_constructor(obj, ...)
    return obj
end

local SCChat_mt = {
    GetMode = ffi.cast('int(__thiscall*)(SCChat*)', sampapi.GetAddress(0x612B0)),
    SwitchMode = ffi.cast('void(__thiscall*)(SCChat*)', sampapi.GetAddress(0x612C0)),
    RecalcFontSize = ffi.cast('void(__thiscall*)(SCChat*)', sampapi.GetAddress(0x67120)),
    OnLostDevice = ffi.cast('void(__thiscall*)(SCChat*)', sampapi.GetAddress(0x671A0)),
    UpdateScrollbar = ffi.cast('void(__thiscall*)(SCChat*)', sampapi.GetAddress(0x67200)),
    SetPageSize = ffi.cast('void(__thiscall*)(SCChat*, int)', sampapi.GetAddress(0x672A0)),
    PageUp = ffi.cast('void(__thiscall*)(SCChat*)', sampapi.GetAddress(0x672D0)),
    PageDown = ffi.cast('void(__thiscall*)(SCChat*)', sampapi.GetAddress(0x67330)),
    ScrollToBottom = ffi.cast('void(__thiscall*)(SCChat*)', sampapi.GetAddress(0x67390)),
    Scroll = ffi.cast('void(__thiscall*)(SCChat*, int)', sampapi.GetAddress(0x673C0)),
    FilterOutInvalidChars = ffi.cast('void(__thiscall*)(SCChat*, char*)', sampapi.GetAddress(0x67420)),
    PushBack = ffi.cast('void(__thiscall*)(SCChat*)', sampapi.GetAddress(0x67450)),
    RenderEntry = ffi.cast('void(__thiscall*)(SCChat*, const char*, SCRect, D3DCOLOR)', sampapi.GetAddress(0x67470)),
    Log = ffi.cast('void(__thiscall*)(SCChat*, int, const char*, const char*)', sampapi.GetAddress(0x677D0)),
    ResetDialogControls = ffi.cast('void(__thiscall*)(SCChat*, CDXUTDialog*)', sampapi.GetAddress(0x678A0)),
    Render = ffi.cast('void(__thiscall*)(SCChat*)', sampapi.GetAddress(0x67940)),
    AddEntry = ffi.cast('void(__thiscall*)(SCChat*, int, const char*, const char*, D3DCOLOR, D3DCOLOR)', sampapi.GetAddress(0x67BE0)),
    Draw = ffi.cast('void(__thiscall*)(SCChat*)', sampapi.GetAddress(0x67E00)),
    RenderToSurface = ffi.cast('void(__thiscall*)(SCChat*)', sampapi.GetAddress(0x67ED0)),
    AddChatMessage = ffi.cast('void(__thiscall*)(SCChat*, const char*, D3DCOLOR, const char*)', sampapi.GetAddress(0x68020)),
    AddMessage = ffi.cast('void(__thiscall*)(SCChat*, D3DCOLOR, const char*)', sampapi.GetAddress(0x68170)),
    OnResetDevice = ffi.cast('void(__thiscall*)(SCChat*)', sampapi.GetAddress(0x681D0)),
}
mt.set_handler('struct SCChat', '__index', SCChat_mt)

return {
    RefChat = RefChat,
    new = CChat_new,
}