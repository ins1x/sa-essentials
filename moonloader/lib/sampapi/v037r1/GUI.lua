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

local function RefResourceMgr() return ffi.cast('CDXUTDialogResourceManager**', sampapi.GetAddress(0x21A180))[0] end
local function RefGameUi() return ffi.cast('CDXUTDialog**', sampapi.GetAddress(0x21A184))[0] end
local function RefScoreboard() return ffi.cast('CDXUTDialog**', sampapi.GetAddress(0x21A188))[0] end
local function RefDialog() return ffi.cast('CDXUTDialog**', sampapi.GetAddress(0x21A190))[0] end
local function RefClassSelection() return ffi.cast('CDXUTDialog**', sampapi.GetAddress(0x21A18C))[0] end
local function RefCursor() return ffi.cast('IDirect3DSurface9**', sampapi.GetAddress(0x21A198))[0] end
local function RefDevice() return ffi.cast('IDirect3DDevice9**', sampapi.GetAddress(0x21A0A8))[0] end
local Initialize = ffi.cast('void(__cdecl*)()', sampapi.GetAddress(0xB3FC0))
local OnLostDevice = ffi.cast('void(__cdecl*)()', sampapi.GetAddress(0xB2980))
local OnResetDevice = ffi.cast('void(__cdecl*)()', sampapi.GetAddress(0xB2BE0))
local GameUIEventHandler = ffi.cast('void(__stdcall*)(unsigned int, int, CDXUTControl*, void*)', sampapi.GetAddress(0xB3EE0))
local ScoreboardEventHandler = ffi.cast('void(__stdcall*)(unsigned int, int, CDXUTControl*, void*)', sampapi.GetAddress(0xB3F20))
local DialogEventHandler = ffi.cast('void(__stdcall*)(unsigned int, int, CDXUTControl*, void*)', sampapi.GetAddress(0xB3E50))
local ClassSelectorEventHandler = ffi.cast('void(__stdcall*)(unsigned int, int, CDXUTControl*, void*)', sampapi.GetAddress(0xB3F50))

return {
    RefResourceMgr = RefResourceMgr,
    RefGameUi = RefGameUi,
    RefScoreboard = RefScoreboard,
    RefDialog = RefDialog,
    RefClassSelection = RefClassSelection,
    RefCursor = RefCursor,
    RefDevice = RefDevice,
    Initialize = Initialize,
    OnLostDevice = OnLostDevice,
    OnResetDevice = OnResetDevice,
    GameUIEventHandler = GameUIEventHandler,
    ScoreboardEventHandler = ScoreboardEventHandler,
    DialogEventHandler = DialogEventHandler,
    ClassSelectorEventHandler = ClassSelectorEventHandler,
}