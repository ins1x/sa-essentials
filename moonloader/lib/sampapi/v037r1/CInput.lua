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
shared.require 'v037r1.Commands'

shared.ffi.cdef[[
enum {
    MAX_CLIENT_CMDS = 144,
    MAX_CMD_LENGTH = 32,
};

typedef struct SCInput SCInput;
#pragma pack(push, 1)
struct SCInput {
    struct IDirect3DDevice9* m_pDevice;
    struct CDXUTDialog* m_pGameUi;
    struct CDXUTEditBox* m_pEditbox;
    CMDPROC m_commandProc[144];
    char m_szCommandName[144][33];
    int m_nCommandCount;
    BOOL m_bEnabled;
    char m_szInput[129];
    char m_szRecallBufffer[10][129];
    char m_szCurrentBuffer[129];
    int m_nCurrentRecall;
    int m_nTotalRecall;
    CMDPROC m_pDefaultCommand;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCInput', 0x1afc)

local Commands = {}

Commands.Debug = {}

local function RefInputBox() return ffi.cast('SCInput**', sampapi.GetAddress(0x21A0E8))[0] end
local CInput_constructor = ffi.cast('void(__thiscall*)(SCInput*, IDirect3DDevice9*)', 0x65730)
local function CInput_new(...)
    local obj = ffi.new('struct SCInput[1]')
    CInput_constructor(obj, ...)
    return obj
end

local SCInput_mt = {
    GetRect = ffi.cast('void(__thiscall*)(SCInput*, SCRect*)', sampapi.GetAddress(0x657A0)),
    Open = ffi.cast('void(__thiscall*)(SCInput*)', sampapi.GetAddress(0x657E0)),
    Close = ffi.cast('void(__thiscall*)(SCInput*)', sampapi.GetAddress(0x658E0)),
    AddRecall = ffi.cast('void(__thiscall*)(SCInput*, const char*)', sampapi.GetAddress(0x65930)),
    RecallUp = ffi.cast('void(__thiscall*)(SCInput*)', sampapi.GetAddress(0x65990)),
    RecallDown = ffi.cast('void(__thiscall*)(SCInput*)', sampapi.GetAddress(0x65A00)),
    EnableCursor = ffi.cast('void(__thiscall*)(SCInput*)', sampapi.GetAddress(0x65A50)),
    GetCommandHandler = ffi.cast('CMDPROC(__thiscall*)(SCInput*, const char*)', sampapi.GetAddress(0x65A70)),
    SetDefaultCommand = ffi.cast('void(__thiscall*)(SCInput*, CMDPROC)', sampapi.GetAddress(0x65AC0)),
    AddCommand = ffi.cast('void(__thiscall*)(SCInput*, const char*, CMDPROC)', sampapi.GetAddress(0x65AD0)),
    MsgProc = ffi.cast('int(__thiscall*)(SCInput*, int, int, int)', sampapi.GetAddress(0x65B30)),
    ResetDialogControls = ffi.cast('void(__thiscall*)(SCInput*, CDXUTDialog*)', sampapi.GetAddress(0x65BA0)),
    Send = ffi.cast('void(__thiscall*)(SCInput*, const char*)', sampapi.GetAddress(0x65C60)),
    ProcessInput = ffi.cast('void(__thiscall*)(SCInput*)', sampapi.GetAddress(0x65D30)),
}
mt.set_handler('struct SCInput', '__index', SCInput_mt)

return {
    Commands = Commands,
    RefInputBox = RefInputBox,
    new = CInput_new,
}