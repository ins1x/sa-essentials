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
shared.require 'v037r1.CPed'
shared.require 'v037r1.CObject'
shared.require 'CMatrix'
shared.require 'CVector'
shared.require 'v037r1.CVehicle'
shared.require 'v037r1.CCamera'
shared.require 'v037r1.CAudio'
shared.require 'v037r1.AimStuff'

shared.ffi.cdef[[
enum SCursorMode {
    CURSOR_NONE = 0,
    CURSOR_LOCKKEYS_NOCURSOR = 1,
    CURSOR_LOCKCAMANDCONTROL = 2,
    CURSOR_LOCKCAM = 3,
    CURSOR_LOCKCAM_NOCURSOR = 4,
};
typedef enum SCursorMode SCursorMode;

typedef struct SCGame SCGame;
#pragma pack(push, 1)
struct SCGame {
    SCAudio* m_pAudio;
    SCCamera* m_pCamera;
    SCPed* m_pPlayerPed;
    struct {
        SCVector m_position;
        SCVector m_size;
        BOOL m_bEnabled;
        GTAREF m_handle;
    } m_checkpoint;
    struct {
        SCVector m_currentPosition;
        SCVector m_nextPosition;
        float m_fSize;
        char m_nType;
        BOOL m_bEnabled;
        GTAREF m_marker;
        GTAREF m_handle;
    } m_racingCheckpoint;
    int m_nCursorMode;
    unsigned int m_nInputEnableWaitFrames;
    BOOL m_bClockEnabled;
    int field_61;
    BOOL m_bHeadMove;
    int m_nFrameLimiter;
    char field_6d;
    bool m_aKeepLoadedVehicleModels[212];
};
#pragma pack(pop)
]]

shared.validate_size('struct SCGame', 0x142)

local AimStuff = {}

local function RefGame() return ffi.cast('SCGame**', sampapi.GetAddress(0x21A10C))[0] end
local CGame_constructor = ffi.cast('void(__thiscall*)(SCGame*)', 0x9B5C0)
local function CGame_new(...)
    local obj = ffi.new('struct SCGame[1]')
    CGame_constructor(obj, ...)
    return obj
end

local function RefGameTextMessage() return ffi.cast('char**', sampapi.GetAddress(0x13BEFC))[0] end
local function ArrayUsedPlayerSlots() return ffi.cast('BOOL* ', sampapi.GetAddress(0x13BF08)) end

local SCGame_mt = {
    GetPlayerPed = ffi.cast('SCPed * (__thiscall*)(SCGame*)', sampapi.GetAddress(0x1010)),
    FindGroundZ = ffi.cast('float(__thiscall*)(SCGame*, SCVector)', sampapi.GetAddress(0x9BA40)),
    SetCursorMode = ffi.cast('void(__thiscall*)(SCGame*, int, BOOL)', sampapi.GetAddress(0x9BD30)),
    InitGame = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0x9BED0)),
    StartGame = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0x9BF20)),
    IsMenuVisible = ffi.cast('int(__thiscall*)(SCGame*)', sampapi.GetAddress(0x9BF60)),
    IsStarted = ffi.cast('int(__thiscall*)(SCGame*)', sampapi.GetAddress(0x9BF70)),
    RequestModel = ffi.cast('void(__thiscall*)(SCGame*, int, int)', sampapi.GetAddress(0x9BF80)),
    LoadRequestedModels = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0x9BFA0)),
    IsModelAvailable = ffi.cast('int(__thiscall*)(SCGame*, int)', sampapi.GetAddress(0x9BFB0)),
    ReleaseModel = ffi.cast('void(__thiscall*)(SCGame*, int, bool)', sampapi.GetAddress(0x9BFD0)),
    SetWorldTime = ffi.cast('void(__thiscall*)(SCGame*, char, char)', sampapi.GetAddress(0x9C0A0)),
    GetWorldTime = ffi.cast('void(__thiscall*)(SCGame*, char*, char*)', sampapi.GetAddress(0x9C0D0)),
    LetTimeGo = ffi.cast('void(__thiscall*)(SCGame*, bool)', sampapi.GetAddress(0x9C0F0)),
    SetWorldWeather = ffi.cast('void(__thiscall*)(SCGame*, char)', sampapi.GetAddress(0x9C130)),
    SetFrameLimiter = ffi.cast('void(__thiscall*)(SCGame*, int)', sampapi.GetAddress(0x9C190)),
    SetMaxStats = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0x9C1C0)),
    DisableTrainTraffic = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0x9C1F0)),
    RefreshRenderer = ffi.cast('void(__thiscall*)(SCGame*, float, float)', sampapi.GetAddress(0x9C200)),
    RequestAnimation = ffi.cast('void(__thiscall*)(SCGame*, const char*)', sampapi.GetAddress(0x9C230)),
    IsAnimationLoaded = ffi.cast('int(__thiscall*)(SCGame*, const char*)', sampapi.GetAddress(0x9C250)),
    ReleaseAnimation = ffi.cast('void(__thiscall*)(SCGame*, const char*)', sampapi.GetAddress(0x9C270)),
    DisplayGameText = ffi.cast('void(__thiscall*)(SCGame*, const char*, int, int)', sampapi.GetAddress(0x9C2C0)),
    DeleteRacingCheckpoint = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0x9C310)),
    CreateMarker = ffi.cast('unsigned long(__thiscall*)(SCGame*, int, SCVector, D3DCOLOR, int)', sampapi.GetAddress(0x9C340)),
    DeleteMarker = ffi.cast('void(__thiscall*)(SCGame*, GTAREF)', sampapi.GetAddress(0x9C470)),
    GetCurrentInterior = ffi.cast('char(__thiscall*)(SCGame*)', sampapi.GetAddress(0x9C490)),
    UpdateFarClippingPlane = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0x9C4B0)),
    IncreasePlayerMoney = ffi.cast('void(__thiscall*)(SCGame*, int)', sampapi.GetAddress(0x9C520)),
    GetPlayerMoney = ffi.cast('int(__thiscall*)(SCGame*)', sampapi.GetAddress(0x9C540)),
    GetWeaponName = ffi.cast('const char*(__thiscall*)(SCGame*, int)', sampapi.GetAddress(0x9C550)),
    CreatePickup = ffi.cast('void(__thiscall*)(SCGame*, int, int, SCVector, GTAREF*)', sampapi.GetAddress(0x9C7A0)),
    CreateWeaponPickup = ffi.cast('unsigned long(__thiscall*)(SCGame*, int, int, SCVector)', sampapi.GetAddress(0x9C870)),
    GetDevice = ffi.cast('IDirect3DDevice9 * (__thiscall*)(SCGame*)', sampapi.GetAddress(0x9C910)),
    Restart = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0x9C950)),
    GetWeaponInfo = ffi.cast('struct CWeaponInfo * (__thiscall*)(SCGame*, int, int)', sampapi.GetAddress(0x9C980)),
    SetWorldGravity = ffi.cast('void(__thiscall*)(SCGame*, float)', sampapi.GetAddress(0x9C9A0)),
    SetWantedLevel = ffi.cast('void(__thiscall*)(SCGame*, char)', sampapi.GetAddress(0x9C9C0)),
    SetNumberOfIntroTextLinesThisFrame = ffi.cast('void(__thiscall*)(SCGame*, unsigned short)', sampapi.GetAddress(0x9C9D0)),
    DrawGangZone = ffi.cast('void(__thiscall*)(SCGame*, float*, D3DCOLOR)', sampapi.GetAddress(0x9C9E0)),
    EnableZoneDisplaying = ffi.cast('void(__thiscall*)(SCGame*, bool)', sampapi.GetAddress(0x9CAC0)),
    EnableStuntBonus = ffi.cast('void(__thiscall*)(SCGame*, bool)', sampapi.GetAddress(0x9CAE0)),
    LoadScene = ffi.cast('void(__thiscall*)(SCGame*, const char*)', sampapi.GetAddress(0x9CB50)),
    GetUsedMemory = ffi.cast('int(__thiscall*)(SCGame*)', sampapi.GetAddress(0x9CB70)),
    GetStreamingMemory = ffi.cast('int(__thiscall*)(SCGame*)', sampapi.GetAddress(0x9CB80)),
    SetRequiredVehicleModels = ffi.cast('void(__thiscall*)(SCGame*, unsigned char*)', sampapi.GetAddress(0x9CBB0)),
    GetTimer = ffi.cast('int(__thiscall*)(SCGame*)', sampapi.GetAddress(0x9CCD0)),
    LoadAnimationsAndModels = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0x9CE00)),
    LoadCollisionFile = ffi.cast('void(__thiscall*)(SCGame*, const char*)', sampapi.GetAddress(0x9D0E0)),
    LoadCullZone = ffi.cast('void(__thiscall*)(SCGame*, const char*)', sampapi.GetAddress(0x9D100)),
    UsingGamepad = ffi.cast('BOOL(__thiscall*)(SCGame*)', sampapi.GetAddress(0x9D120)),
    DisableAutoAiming = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0x9D130)),
    EnableHUD = ffi.cast('void(__thiscall*)(SCGame*, BOOL)', sampapi.GetAddress(0x9D310)),
    SetCheckpoint = ffi.cast('void(__thiscall*)(SCGame*, SCVector*, SCVector*)', sampapi.GetAddress(0x9D340)),
    CreateRacingCheckpoint = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0x9D400)),
    ProcessCheckpoints = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0x9D480)),
    ResetMoney = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0x9D620)),
    SetRacingCheckpoint = ffi.cast('void(__thiscall*)(SCGame*, int, SCVector*, SCVector*, float)', sampapi.GetAddress(0x9D660)),
    EnableRadar = ffi.cast('void(__thiscall*)(SCGame*, BOOL)', sampapi.GetAddress(0x9C2A0)),
    GetWindowHandle = ffi.cast('void*(__thiscall*)(SCGame*)', sampapi.GetAddress(0x2D00)),
    GetAudio = ffi.cast('SCAudio * (__thiscall*)(SCGame*)', sampapi.GetAddress(0x2D10)),
    GetCamera = ffi.cast('SCCamera * (__thiscall*)(SCGame*)', sampapi.GetAddress(0x2D20)),
    DoesHeadMoves = ffi.cast('BOOL(__thiscall*)(SCGame*)', sampapi.GetAddress(0x2D30)),
    EnableClock = ffi.cast('void(__thiscall*)(SCGame*, bool)', sampapi.GetAddress(0x9CA00)),
    Sleep = ffi.cast('void(__thiscall*)(SCGame*, int, int)', sampapi.GetAddress(0x9B6D0)),
    CreatePed = ffi.cast('SCPed * (__thiscall*)(SCGame*, int, SCVector, float, int, int)', sampapi.GetAddress(0x9B750)),
    RemovePed = ffi.cast('BOOL(__thiscall*)(SCGame*, SCPed*)', sampapi.GetAddress(0x9B850)),
    CreateVehicle = ffi.cast('SCVehicle * (__thiscall*)(SCGame*, int, SCVector, float, int)', sampapi.GetAddress(0x9B890)),
    CreateObject = ffi.cast('SCObject * (__thiscall*)(SCGame*, int, SCVector, SCVector, float)', sampapi.GetAddress(0x9B970)),
    ProcessInputEnabling = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0x9BC10)),
    ProcessFrameLimiter = ffi.cast('void(__thiscall*)(SCGame*)', sampapi.GetAddress(0x9D170)),
}
mt.set_handler('struct SCGame', '__index', SCGame_mt)

return {
    AimStuff = AimStuff,
    RefGame = RefGame,
    new = CGame_new,
    RefGameTextMessage = RefGameTextMessage,
    ArrayUsedPlayerSlots = ArrayUsedPlayerSlots,
}