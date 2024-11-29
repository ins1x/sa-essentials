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
    MAX_ANTICHEAT_DETECT_COUNT = 10,
};
]]

local SwitchWindowedMode = ffi.cast('void(__cdecl*)()', sampapi.GetAddress(0x5D800))
local function RefPrevWindowProc() return ffi.cast('void**', sampapi.GetAddress(0x119CB8))[0] end
local function RefAntiCheatDetectCount() return ffi.cast('unsigned int*', sampapi.GetAddress(0x21A130))[0] end
local WindowProc = ffi.cast('int(__stdcall*)(unsigned int, unsigned int, long)', sampapi.GetAddress(0x5DB40))
local KeyPressHandler = ffi.cast('BOOL(__cdecl*)(unsigned int)', sampapi.GetAddress(0x5D850))
local CharInputHandler = ffi.cast('BOOL(__cdecl*)(unsigned int)', sampapi.GetAddress(0x5DA80))
local Initialize = ffi.cast('BOOL(__cdecl*)()', sampapi.GetAddress(0x5E3B0))

return {
    SwitchWindowedMode = SwitchWindowedMode,
    RefPrevWindowProc = RefPrevWindowProc,
    RefAntiCheatDetectCount = RefAntiCheatDetectCount,
    WindowProc = WindowProc,
    KeyPressHandler = KeyPressHandler,
    CharInputHandler = CharInputHandler,
    Initialize = Initialize,
}