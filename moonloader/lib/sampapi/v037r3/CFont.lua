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
typedef struct SCFont SCFont;
#pragma pack(push, 1)
struct SCFont {
    void** m_lpVtbl;
    struct ID3DXFont* m_pFont;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCFont', 0x8)

local CFont_constructor = ffi.cast('void(__thiscall*)(SCFont*)', 0x6B160)
local function CFont_new(...)
    local obj = ffi.new('struct SCFont[1]')
    CFont_constructor(obj, ...)
    return obj
end

return {
    new = CFont_new,
}