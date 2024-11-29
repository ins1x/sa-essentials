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

local Default = ffi.cast('CMDPROC', sampapi.GetAddress(0x64910))
local TestDeathWindow = ffi.cast('CMDPROC', sampapi.GetAddress(0x64930))
local ToggleCameraTargetLabels = ffi.cast('CMDPROC', sampapi.GetAddress(0x64A10))
local SetChatPageSize = ffi.cast('CMDPROC', sampapi.GetAddress(0x64A20))
local SetChatFontSize = ffi.cast('CMDPROC', sampapi.GetAddress(0x64AA0))
local DrawNameTagStatus = ffi.cast('CMDPROC', sampapi.GetAddress(0x65B50))
local DrawChatTimestamps = ffi.cast('CMDPROC', sampapi.GetAddress(0x64B60))
local ToggleAudioStreamMessages = ffi.cast('CMDPROC', sampapi.GetAddress(0x64BC0))
local PrintMemory = ffi.cast('CMDPROC', sampapi.GetAddress(0x64C40))
local SetFrameLimiter = ffi.cast('CMDPROC', sampapi.GetAddress(0x64C60))
local ToggleHeadMoves = ffi.cast('CMDPROC', sampapi.GetAddress(0x64CF0))
local Quit = ffi.cast('CMDPROC', sampapi.GetAddress(0x64D70))
local CmpStat = ffi.cast('CMDPROC', sampapi.GetAddress(0x64D80))
local SavePosition = ffi.cast('CMDPROC', sampapi.GetAddress(0x64D90))
local SavePositionOnly = ffi.cast('CMDPROC', sampapi.GetAddress(0x64F10))
local PrintCurrentInterior = ffi.cast('CMDPROC', sampapi.GetAddress(0x65360))
local ToggleObjectsLight = ffi.cast('CMDPROC', sampapi.GetAddress(0x65390))
local ToggleDebugLabels = ffi.cast('CMDPROC', sampapi.GetAddress(0x653B0))
local SendRconCommand = ffi.cast('CMDPROC', sampapi.GetAddress(0x653C0))
local Debug = {}

Debug.SetPlayerSkin = ffi.cast('CMDPROC', sampapi.GetAddress(0x65090))
Debug.CreateVehicle = ffi.cast('CMDPROC', sampapi.GetAddress(0x65100))
Debug.EnableVehicleSelection = ffi.cast('CMDPROC', sampapi.GetAddress(0x65240))
Debug.SetWorldWeather = ffi.cast('CMDPROC', sampapi.GetAddress(0x65260))
Debug.SetWorldTime = ffi.cast('CMDPROC', sampapi.GetAddress(0x652B0))
local Setup = ffi.cast('void(__cdecl*)()', sampapi.GetAddress(0x654A0))

return {
    Default = Default,
    TestDeathWindow = TestDeathWindow,
    ToggleCameraTargetLabels = ToggleCameraTargetLabels,
    SetChatPageSize = SetChatPageSize,
    SetChatFontSize = SetChatFontSize,
    DrawNameTagStatus = DrawNameTagStatus,
    DrawChatTimestamps = DrawChatTimestamps,
    ToggleAudioStreamMessages = ToggleAudioStreamMessages,
    PrintMemory = PrintMemory,
    SetFrameLimiter = SetFrameLimiter,
    ToggleHeadMoves = ToggleHeadMoves,
    Quit = Quit,
    CmpStat = CmpStat,
    SavePosition = SavePosition,
    SavePositionOnly = SavePositionOnly,
    PrintCurrentInterior = PrintCurrentInterior,
    ToggleObjectsLight = ToggleObjectsLight,
    ToggleDebugLabels = ToggleDebugLabels,
    SendRconCommand = SendRconCommand,
    Debug = Debug,
    Setup = Setup,
}