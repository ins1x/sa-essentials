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
typedef struct SCHelpDialog SCHelpDialog;
#pragma pack(push, 1)
struct SCHelpDialog {
    struct IDirect3DDevice9* m_pDevice;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCHelpDialog', 0x4)

local CHelpDialog_constructor = ffi.cast('void(__thiscall*)(SCHelpDialog*, IDirect3DDevice9*)', 0x83D0)
local function CHelpDialog_new(...)
    local obj = ffi.new('struct SCHelpDialog[1]')
    CHelpDialog_constructor(obj, ...)
    return obj
end

local SCHelpDialog_mt = {
    Show = ffi.cast('void(__thiscall*)(SCHelpDialog*)', sampapi.GetAddress(0x6BB30)),
}
mt.set_handler('struct SCHelpDialog', '__index', SCHelpDialog_mt)

local function RefHelpDialog() return ffi.cast('SCHelpDialog**', sampapi.GetAddress(0x26EB74))[0] end

return {
    new = CHelpDialog_new,
    RefHelpDialog = RefHelpDialog,
}