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

shared.require 'v037r1.CEntity'
shared.require 'v037r1.CVehicle'
shared.require 'v037r1.KeyStuff'
shared.require 'CMatrix'
shared.require 'CVector'
shared.require 'v037r1.CCamera'

local function RefCamera() return ffi.cast('SCCamera**', sampapi.GetAddress(0x13BA7C))[0] end
local function RefVehicle() return ffi.cast('SCVehicle**', sampapi.GetAddress(0x13BB64))[0] end
local function RefControls() return ffi.cast('struct CPad**', sampapi.GetAddress(0x13BA78))[0] end
local function RefInitialized() return ffi.cast('BOOL*', sampapi.GetAddress(0x13BB60))[0] end
local function RefSelectedModel() return ffi.cast('int*', sampapi.GetAddress(0x1014B4))[0] end
local ResetVehicle = ffi.cast('void(__cdecl*)()', sampapi.GetAddress(0x99710))
local Process = ffi.cast('void(__cdecl*)()', sampapi.GetAddress(0x99AD0))
local KeyStuff = {}

return {
    RefCamera = RefCamera,
    RefVehicle = RefVehicle,
    RefControls = RefControls,
    RefInitialized = RefInitialized,
    RefSelectedModel = RefSelectedModel,
    ResetVehicle = ResetVehicle,
    Process = Process,
    KeyStuff = KeyStuff,
}