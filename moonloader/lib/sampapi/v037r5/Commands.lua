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

local Default = ffi.cast('CMDPROC', sampapi.GetAddress(0x684E0))
local TestDeathWindow = ffi.cast('CMDPROC', sampapi.GetAddress(0x68500))
local ToggleCameraTargetLabels = ffi.cast('CMDPROC', sampapi.GetAddress(0x685E0))
local SetChatPageSize = ffi.cast('CMDPROC', sampapi.GetAddress(0x685F0))
local SetChatFontSize = ffi.cast('CMDPROC', sampapi.GetAddress(0x68670))
local DrawNameTagStatus = ffi.cast('CMDPROC', sampapi.GetAddress(0x68720))
local DrawChatTimestamps = ffi.cast('CMDPROC', sampapi.GetAddress(0x68730))
local ToggleAudioStreamMessages = ffi.cast('CMDPROC', sampapi.GetAddress(0x68790))
local ToggleURLMessages = ffi.cast('CMDPROC', sampapi.GetAddress(0x68800))
local ToggleHUDScaleFix = ffi.cast('CMDPROC', sampapi.GetAddress(0x68870))
local PrintMemory = ffi.cast('CMDPROC', sampapi.GetAddress(0x688B0))
local SetFrameLimiter = ffi.cast('CMDPROC', sampapi.GetAddress(0x688D0))
local ToggleHeadMoves = ffi.cast('CMDPROC', sampapi.GetAddress(0x68960))
local Quit = ffi.cast('CMDPROC', sampapi.GetAddress(0x689E0))
local CmpStat = ffi.cast('CMDPROC', sampapi.GetAddress(0x689F0))
local SavePosition = ffi.cast('CMDPROC', sampapi.GetAddress(0x68A00))
local SavePositionOnly = ffi.cast('CMDPROC', sampapi.GetAddress(0x68B80))
local PrintCurrentInterior = ffi.cast('CMDPROC', sampapi.GetAddress(0x68FD0))
local ToggleObjectsLight = ffi.cast('CMDPROC', sampapi.GetAddress(0x69000))
local ToggleDebugLabels = ffi.cast('CMDPROC', sampapi.GetAddress(0x69020))
local SendRconCommand = ffi.cast('CMDPROC', sampapi.GetAddress(0x69030))
local Debug = {}

Debug.SetPlayerSkin = ffi.cast('CMDPROC', sampapi.GetAddress(0x68D00))
Debug.CreateVehicle = ffi.cast('CMDPROC', sampapi.GetAddress(0x68D70))
Debug.EnableVehicleSelection = ffi.cast('CMDPROC', sampapi.GetAddress(0x68EB0))
Debug.SetWorldWeather = ffi.cast('CMDPROC', sampapi.GetAddress(0x68ED0))
Debug.SetWorldTime = ffi.cast('CMDPROC', sampapi.GetAddress(0x68F20))
local Setup = ffi.cast('void(__cdecl*)()', sampapi.GetAddress(0x69110))

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