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
shared.require 'CMatrix'
shared.require 'CVector'

shared.ffi.cdef[[
enum {
    MAX_MATERIALS = 16,
};

enum SMaterialType {
    MATERIAL_TYPE_NONE = 0,
    MATERIAL_TYPE_TEXTURE = 1,
    MATERIAL_TYPE_TEXT = 2,
};
typedef enum SMaterialType SMaterialType;

enum SMaterialSize {
    MATERIAL_SIZE_32X32 = 10,
    MATERIAL_SIZE_64X32 = 20,
    MATERIAL_SIZE_64X64 = 30,
    MATERIAL_SIZE_128X32 = 40,
    MATERIAL_SIZE_128X64 = 50,
    MATERIAL_SIZE_128X128 = 60,
    MATERIAL_SIZE_256X32 = 70,
    MATERIAL_SIZE_256X64 = 80,
    MATERIAL_SIZE_256X128 = 90,
    MATERIAL_SIZE_256X256 = 100,
    MATERIAL_SIZE_512X64 = 110,
    MATERIAL_SIZE_512X128 = 120,
    MATERIAL_SIZE_512X256 = 130,
    MATERIAL_SIZE_512X512 = 140,
};
typedef enum SMaterialSize SMaterialSize;

typedef struct SMaterialText SMaterialText;
#pragma pack(push, 1)
struct SMaterialText {
    char m_nMaterialIndex;
    char pad_0[137];
    char m_nMaterialSize;
    char m_szFont[65];
    char m_nFontSize;
    bool m_bBold;
    D3DCOLOR m_fontColor;
    D3DCOLOR m_backgroundColor;
    char m_align;
};
#pragma pack(pop)

typedef struct SObjectMaterial SObjectMaterial;
#pragma pack(push, 1)
struct SObjectMaterial {
    union {
        struct CSprite2d* m_pSprite[16];
        struct RwTexture* m_pTextBackground[16];
    };
    D3DCOLOR m_color[16];
    char pad_6[68];
    int m_nType[16];
    BOOL m_bTextureWasCreated[16];
    SMaterialText m_textInfo[16];
    char* m_szText[16];
    struct IDirect3DTexture9* m_pBackgroundTexture[16];
    struct IDirect3DTexture9* m_pTexture[16];
};
#pragma pack(pop)

typedef struct SCObject SCObject;
#pragma pack(push, 1)
struct SCObject : SCEntity {
    char pad_0[6];
    int m_nModel;
    char pad_1;
    bool m_bDontCollideWithCamera;
    float m_fDrawDistance;
    float field_0;
    SCVector m_position;
    float m_fDistanceToCamera;
    bool m_bDrawLast;
    char pad_2[64];
    SCVector m_rotation;
    char pad_3[5];
    ID m_nAttachedToVehicle;
    ID m_nAttachedToObject;
    SCVector m_attachOffset;
    SCVector m_attachRotation;
    bool m_bSyncRotation;
    SCMatrix m_targetMatrix;
    char pad_4[148];
    char m_bMoving;
    float m_fSpeed;
    char pad_5[99];
    SObjectMaterial m_material;
    BOOL m_bHasCustomMaterial;
    char pad_9[10];
};
#pragma pack(pop)
]]

shared.validate_size('struct SMaterialText', 0xd7)
shared.validate_size('struct SObjectMaterial', 0xf74)
shared.validate_size('struct SCObject', 0x1199)

local CObject_constructor = ffi.cast('void(__thiscall*)(SCObject*, int, SCVector, SCVector, float, int)', 0xA3AB0)
local function CObject_new(...)
    local obj = ffi.new('struct SCObject[1]')
    CObject_constructor(obj, ...)
    return obj
end

local SCObject_mt = {
    -- Add = ...
    -- Remove = ...
    GetDistance = ffi.cast('float(__thiscall*)(SCObject*, const SCMatrix*)', sampapi.GetAddress(0xA2960)),
    Stop = ffi.cast('void(__thiscall*)(SCObject*)', sampapi.GetAddress(0xA29D0)),
    SetRotation = ffi.cast('void(__thiscall*)(SCObject*, const SCVector*)', sampapi.GetAddress(0xA2A40)),
    SetAttachedToVehicle = ffi.cast('void(__thiscall*)(SCObject*, ID, const SCVector*, const SCVector*)', sampapi.GetAddress(0xA2AB0)),
    SetAttachedToObject = ffi.cast('void(__thiscall*)(SCObject*, ID, const SCVector*, const SCVector*, char)', sampapi.GetAddress(0xA2B40)),
    AttachToVehicle = ffi.cast('void(__thiscall*)(SCObject*, SCVehicle * pVehicle)', sampapi.GetAddress(0xA2BE0)),
    AttachToObject = ffi.cast('void(__thiscall*)(SCObject*, SCObject*)', sampapi.GetAddress(0xA2C60)),
    Rotate = ffi.cast('void(__thiscall*)(SCObject*, SCVector)', sampapi.GetAddress(0xA2D60)),
    AttachedToMovingEntity = ffi.cast('BOOL(__thiscall*)(SCObject*)', sampapi.GetAddress(0xA2E60)),
    SetMaterial = ffi.cast('void(__thiscall*)(SCObject*, int, int, const char*, const char*, D3DCOLOR)', sampapi.GetAddress(0xA2ED0)),
    SetMaterialText = ffi.cast('void(__thiscall*)(SCObject*, int, const char*, char, const char*, char, bool, D3DCOLOR, D3DCOLOR, char)', sampapi.GetAddress(0xA3050)),
    GetMaterialSize = ffi.cast('bool(__thiscall*)(SCObject*, int, int*, int*)', sampapi.GetAddress(0xA3620)),
    Render = ffi.cast('void(__thiscall*)(SCObject*)', sampapi.GetAddress(0xA3900)),
    Process = ffi.cast('void(__thiscall*)(SCObject*, float)', sampapi.GetAddress(0xA3F70)),
    ConstructMaterialText = ffi.cast('void(__thiscall*)(SCObject*)', sampapi.GetAddress(0xA47F0)),
    Draw = ffi.cast('void(__thiscall*)(SCObject*)', sampapi.GetAddress(0xA48A0)),
    ShutdownMaterialText = ffi.cast('void(__thiscall*)(SCObject*)', sampapi.GetAddress(0xA3870)),
}
mt.set_handler('struct SCObject', '__index', SCObject_mt)

return {
    new = CObject_new,
}