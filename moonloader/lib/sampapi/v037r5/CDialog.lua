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

shared.ffi.cdef[[
enum SDialogType {
    DIALOG_MESSAGEBOX = 0,
    DIALOG_INPUT = 1,
    DIALOG_LIST = 2,
    DIALOG_PASSWORD = 3,
    DIALOG_TABLIST = 4,
    DIALOG_HEADERSLIST = 5,
};
typedef enum SDialogType SDialogType;

typedef struct SCDialog SCDialog;
#pragma pack(push, 1)
struct SCDialog {
    struct IDirect3DDevice9* m_pDevice;
    long unsigned int m_position[2];
    long unsigned int m_size[2];
    long unsigned int m_buttonOffset[2];
    struct CDXUTDialog* m_pDialog;
    struct CDXUTListBox* m_pListbox;
    struct CDXUTIMEEditBox* m_pEditbox;
    BOOL m_bIsActive;
    int m_nType;
    unsigned int m_nId;
    char* m_szText;
    long unsigned int m_textSize[2];
    char m_szCaption[65];
    BOOL m_bServerside;
    char pad[536];
};
#pragma pack(pop)
]]

shared.validate_size('struct SCDialog', 0x29d)

local CDialog_constructor = ffi.cast('void(__thiscall*)(SCDialog*, IDirect3DDevice9*)', 0x6F480)
local function CDialog_new(...)
    local obj = ffi.new('struct SCDialog[1]')
    CDialog_constructor(obj, ...)
    return obj
end

local SCDialog_mt = {
    GetScreenRect = ffi.cast('void(__thiscall*)(SCDialog*, SCRect*)', sampapi.GetAddress(0x6F6B0)),
    GetTextScreenLength = ffi.cast('int(__thiscall*)(SCDialog*, const char*)', sampapi.GetAddress(0x6F6E0)),
    Hide = ffi.cast('void(__thiscall*)(SCDialog*)', sampapi.GetAddress(0x6F860)),
    ResetDialogControls = ffi.cast('void(__thiscall*)(SCDialog*, CDXUTDialog*)', sampapi.GetAddress(0x6FA20)),
    Show = ffi.cast('void(__thiscall*)(SCDialog*, int, int, const char*, const char*, const char*, const char*, BOOL)', sampapi.GetAddress(0x6FFB0)),
    Close = ffi.cast('void(__thiscall*)(SCDialog*, char)', sampapi.GetAddress(0x70630)),
    Draw = ffi.cast('void(__thiscall*)(SCDialog*)', sampapi.GetAddress(0x6F890)),
}
mt.set_handler('struct SCDialog', '__index', SCDialog_mt)

local function RefDialog() return ffi.cast('SCDialog**', sampapi.GetAddress(0x26EB50))[0] end

return {
    new = CDialog_new,
    RefDialog = RefDialog,
}