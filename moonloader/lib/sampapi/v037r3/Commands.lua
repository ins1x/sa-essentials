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

local Default = ffi.cast('CMDPROC', sampapi.GetAddress(0x67D60))
local TestDeathWindow = ffi.cast('CMDPROC', sampapi.GetAddress(0x67D90))
local ToggleCameraTargetLabels = ffi.cast('CMDPROC', sampapi.GetAddress(0x67E70))
local SetChatPageSize = ffi.cast('CMDPROC', sampapi.GetAddress(0x67E80))
local SetChatFontSize = ffi.cast('CMDPROC', sampapi.GetAddress(0x67F00))
local DrawNameTagStatus = ffi.cast('CMDPROC', sampapi.GetAddress(0x67FB0))
local DrawChatTimestamps = ffi.cast('CMDPROC', sampapi.GetAddress(0x67FC0))
local ToggleAudioStreamMessages = ffi.cast('CMDPROC', sampapi.GetAddress(0x68020))
local ToggleURLMessages = ffi.cast('CMDPROC', sampapi.GetAddress(0x68090))
local ToggleHUDScaleFix = ffi.cast('CMDPROC', sampapi.GetAddress(0x68100))
local PrintMemory = ffi.cast('CMDPROC', sampapi.GetAddress(0x68140))
local SetFrameLimiter = ffi.cast('CMDPROC', sampapi.GetAddress(0x68160))
local ToggleHeadMoves = ffi.cast('CMDPROC', sampapi.GetAddress(0x681F0))
local Quit = ffi.cast('CMDPROC', sampapi.GetAddress(0x68270))
local CmpStat = ffi.cast('CMDPROC', sampapi.GetAddress(0x68280))
local SavePosition = ffi.cast('CMDPROC', sampapi.GetAddress(0x68290))
local SavePositionOnly = ffi.cast('CMDPROC', sampapi.GetAddress(0x68410))
local PrintCurrentInterior = ffi.cast('CMDPROC', sampapi.GetAddress(0x68860))
local ToggleObjectsLight = ffi.cast('CMDPROC', sampapi.GetAddress(0x68890))
local ToggleDebugLabels = ffi.cast('CMDPROC', sampapi.GetAddress(0x688B0))
local SendRconCommand = ffi.cast('CMDPROC', sampapi.GetAddress(0x688C0))
local Debug = {}

Debug.SetPlayerSkin = ffi.cast('CMDPROC', sampapi.GetAddress(0x68590))
Debug.CreateVehicle = ffi.cast('CMDPROC', sampapi.GetAddress(0x68600))
Debug.EnableVehicleSelection = ffi.cast('CMDPROC', sampapi.GetAddress(0x68740))
Debug.SetWorldWeather = ffi.cast('CMDPROC', sampapi.GetAddress(0x68760))
Debug.SetWorldTime = ffi.cast('CMDPROC', sampapi.GetAddress(0x687B0))
local Setup = ffi.cast('void(__cdecl*)()', sampapi.GetAddress(0x689A0))

return {
    Default = Default,
    TestDeathWindow = TestDeathWindow,
    ToggleCameraTargetLabels = ToggleCameraTargetLabels,
    SetChatPageSize = SetChatPageSize,
    SetChatFontSize = SetChatFontSize,
    DrawNameTagStatus = DrawNameTagStatus,
    DrawChatTimestamps = DrawChatTimestamps,
    ToggleAudioStreamMessages = ToggleAudioStreamMessages,
    ToggleURLMessages = ToggleURLMessages,
    ToggleHUDScaleFix = ToggleHUDScaleFix,
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