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
typedef struct SPlayer SPlayer;
#pragma pack(push, 1)
struct SPlayer {
    BOOL m_bExists;
    char m_szText[256];
    int m_creationTick;
    int m_lifeSpan;
    D3DCOLOR m_color;
    float m_fDrawDistance;
    int m_nMaxLineLength;
};
#pragma pack(pop)

typedef struct SCChatBubble SCChatBubble;
#pragma pack(push, 1)
struct SCChatBubble {
    SPlayer m_player[1004];
};
#pragma pack(pop)
]]

shared.validate_size('struct SPlayer', 0x118)
shared.validate_size('struct SCChatBubble', 0x44a20)

local CChatBubble_constructor = ffi.cast('void(__thiscall*)(SCChatBubble*)', 0x66670)
local function CChatBubble_new(...)
    local obj = ffi.new('struct SCChatBubble[1]')
    CChatBubble_constructor(obj, ...)
    return obj
end

local SCChatBubble_mt = {
    Add = ffi.cast('void(__thiscall*)(SCChatBubble*, ID, const char*, D3DCOLOR, float, int)', sampapi.GetAddress(0x666A0)),
    Draw = ffi.cast('void(__thiscall*)(SCChatBubble*)', sampapi.GetAddress(0x66760)),
}
mt.set_handler('struct SCChatBubble', '__index', SCChatBubble_mt)

local function RefChatBubble() return ffi.cast('SCChatBubble**', sampapi.GetAddress(0x26E8C0))[0] end

return {
    new = CChatBubble_new,
    RefChatBubble = RefChatBubble,
}