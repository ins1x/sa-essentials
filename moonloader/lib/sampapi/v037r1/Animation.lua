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
typedef struct SAnimation SAnimation;
#pragma pack(push, 1)
struct SAnimation {
    union {
        struct {
            short unsigned int m_nId : 16;
            unsigned char m_nFramedelta : 8;
            unsigned char m_nLoopA : 1;
            unsigned char m_nLockX : 1;
            unsigned char m_nLockY : 1;
            unsigned char m_nLockF : 1;
            unsigned char m_nTime : 2;
        };
        int m_value;
    };
};
#pragma pack(pop)
]]

shared.validate_size('struct SAnimation', 0x4)

