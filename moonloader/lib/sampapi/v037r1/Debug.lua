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
    DEBUG_MODE_VEHICLE_SELECTION = 10,
};
]]

local function RefMode() return ffi.cast('int*', sampapi.GetAddress(0x13BB18))[0] end
local function RefFirstEntity() return ffi.cast('void**', sampapi.GetAddress(0x13BB1C))[0] end
local function RefSecondEntity() return ffi.cast('void**', sampapi.GetAddress(0x13BB20))[0] end
local SetProperties = ffi.cast('void(__cdecl*)(void*, void*, int)', sampapi.GetAddress(0x996E0))
local Disable = ffi.cast('void(__cdecl*)()', sampapi.GetAddress(0x99700))

return {
    RefMode = RefMode,
    RefFirstEntity = RefFirstEntity,
    RefSecondEntity = RefSecondEntity,
    SetProperties = SetProperties,
    Disable = Disable,
}