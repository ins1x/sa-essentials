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
typedef struct SControllerState SControllerState;
#pragma pack(push, 1)
struct SControllerState {
    short int m_sLeftStickX;
    short int m_sLeftStickY;
    union {
        struct {
            unsigned char m_bLeftShoulder1 : 1;
            unsigned char m_bShockButtonL : 1;
            unsigned char m_bButtonCircle : 1;
            unsigned char m_bButtonCross : 1;
            unsigned char m_bButtonTriangle : 1;
            unsigned char m_bButtonSquare : 1;
            unsigned char m_bRightShoulder2 : 1;
            unsigned char m_bRightShoulder1 : 1;
            unsigned char m_bLeftShoulder2 : 1;
            unsigned char m_bShockButtonR : 1;
            unsigned char m_bPedWalk : 1;
            unsigned char m_bRightStickDown : 1;
            unsigned char m_bRightStickUp : 1;
            unsigned char m_bRightStickRight : 1;
            unsigned char m_bRightStickLeft : 1;
        };
        short int m_value;
    };
};
#pragma pack(pop)
]]

shared.validate_size('struct SControllerState', 0x6)

