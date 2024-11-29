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

shared.require 'CPoint'
shared.require 'CRect'
shared.require 'CMatrix'
shared.require 'CVector'

shared.ffi.cdef[[
enum SObjectEditType {
    OBJECT_EDIT_TYPE_NONE = 0,
    OBJECT_EDIT_TYPE_ATTACHEDOBJECT = 2,
    OBJECT_EDIT_TYPE_OBJECT = 1,
};
typedef enum SObjectEditType SObjectEditType;

enum SObjectEditMode {
    OBJECT_EDIT_MODE_POSITION = 0,
    OBJECT_EDIT_MODE_ROTATION = 1,
    OBJECT_EDIT_MODE_SCALE = 2,
};
typedef enum SObjectEditMode SObjectEditMode;

enum SObjectEditProcessType {
    OBJECT_EDIT_PROCESS_TYPE_XAXIS = 0,
    OBJECT_EDIT_PROCESS_TYPE_YAXIS = 1,
    OBJECT_EDIT_PROCESS_TYPE_ZAXIS = 2,
    OBJECT_EDIT_PROCESS_TYPE_SETPOSITION = 3,
    OBJECT_EDIT_PROCESS_TYPE_SETROTATION = 4,
    OBJECT_EDIT_PROCESS_TYPE_SETSCALE = 5,
    OBJECT_EDIT_PROCESS_TYPE_SAVE = 10,
};
typedef enum SObjectEditProcessType SObjectEditProcessType;

typedef struct SCObjectEdit SCObjectEdit;
#pragma pack(push, 1)
struct SCObjectEdit {
    SCPoint m_CharMaxSize;
    SCRect m_xAxisButtonRect;
    SCRect m_yAxisButtonRect;
    SCRect m_zAxisButtonRect;
    SCRect m_PositionButtonRect;
    SCRect m_RotationButtonRect;
    SCRect m_ScaleButtonRect;
    SCRect m_SaveButtonRect;
    int m_nEditType;
    int m_nEditMode;
    BOOL m_bEnabled;
    BOOL m_bRenderedThisFrame;
    ID m_nEditObjectId;
    unsigned int m_nAttachedObjectIndex;
    BOOL m_bIsPlayerObject;
    SCVector m_vRotation;
    unsigned int m_nLastSentNotificationTick;
    bool m_bRenderScaleButton;
    bool m_bEditingRightNow;
    bool m_bTopXOfObjectIsOnLeftOfScreen;
    bool m_bTopYOfObjectIsOnLeftOfScreen;
    bool m_bTopZOfObjectIsOnLeftOfScreen;
    SCPoint m_EditStartPos;
    SCPoint m_CursorPosInGame;
    BOOL m_bObjectXSizeYCoordDiffMoreThanX;
    BOOL m_bObjectYSizeYCoordDiffMoreThanX;
    BOOL m_bObjectZSizeYCoordDiffMoreThanX;
    SCMatrix m_entityMatrix;
    struct IDirect3DDevice9* m_pDevice;
    struct ID3DXLine* m_pLine;
    struct ID3DXFont* m_pIconFontSmall;
    struct ID3DXFont* m_pIconFontBig;
    int m_nProcessType;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCObjectEdit', 0x117)

local CObjectEdit_constructor = ffi.cast('SCObjectEdit*(__thiscall*)(SCObjectEdit*, IDirect3DDevice9*)', 0x71470)
local function CObjectEdit_new(...)
    local obj = ffi.new('struct SCObjectEdit[1]')
    CObjectEdit_constructor(obj, ...)
    return obj
end

local GetMaxSizeChar = ffi.cast('const char*(__cdecl*)()', sampapi.GetAddress(0x718A0))

local SCObjectEdit_mt = {
    WorldToScreen = ffi.cast('float(__thiscall*)(SCObjectEdit*, SCVector*, float*)', sampapi.GetAddress(0x71530)),
    RenderAxes = ffi.cast('int(__thiscall*)(SCObjectEdit*, SCMatrix*, float)', sampapi.GetAddress(0x71630)),
    GetRenderChar = ffi.cast('const char*(__thiscall*)(SCObjectEdit*, BOOL)', sampapi.GetAddress(0x718B0)),
    TryChangeProcessType = ffi.cast('void(__thiscall*)(SCObjectEdit*)', sampapi.GetAddress(0x719B0)),
    SetEditMode = ffi.cast('void(__thiscall*)(SCObjectEdit*, SObjectEditMode)', sampapi.GetAddress(0x71B00)),
    ResetMousePos = ffi.cast('void(__thiscall*)(SCObjectEdit*)', sampapi.GetAddress(0x71CD0)),
    EnterEditObject = ffi.cast('void(__thiscall*)(SCObjectEdit*, ID, BOOL)', sampapi.GetAddress(0x71D30)),
    SendEditEndNotification = ffi.cast('void(__thiscall*)(SCObjectEdit*, int)', sampapi.GetAddress(0x721C0)),
    SendAttachedEditEndNotification = ffi.cast('void(__thiscall*)(SCObjectEdit*, int)', sampapi.GetAddress(0x723D0)),
    Disable = ffi.cast('void(__thiscall*)(SCObjectEdit*, BOOL)', sampapi.GetAddress(0x724D0)),
    RenderControlsForObject = ffi.cast('BOOL(__thiscall*)(SCObjectEdit*, SCMatrix*, float)', sampapi.GetAddress(0x72540)),
    ApplyChanges = ffi.cast('void(__thiscall*)(SCObjectEdit*, SObjectEditProcessType, float)', sampapi.GetAddress(0x72D70)),
    ProcessMouseMove = ffi.cast('float(__thiscall*)(SCObjectEdit*)', sampapi.GetAddress(0x72D90)),
    MsgProc = ffi.cast('BOOL(__thiscall*)(SCObjectEdit*, int, int, int)', sampapi.GetAddress(0x72E60)),
    Render = ffi.cast('void(__thiscall*)(SCObjectEdit*)', sampapi.GetAddress(0x73090)),
}
mt.set_handler('struct SCObjectEdit', '__index', SCObjectEdit_mt)

local function RefObjectEdit() return ffi.cast('SCObjectEdit**', sampapi.GetAddress(0x26E8A8))[0] end

return {
    new = CObjectEdit_new,
    GetMaxSizeChar = GetMaxSizeChar,
    RefObjectEdit = RefObjectEdit,
}