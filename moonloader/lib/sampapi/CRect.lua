--[[
    Project: SAMP-API.lua <https://github.com/imring/SAMP-API.lua>
    Developers: imring, LUCHARE, FYP

    Special thanks:
        SAMemory (https://www.blast.hk/threads/20472/) for implementing the basic functions.
        SAMP-API (https://github.com/BlastHackNet/SAMP-API) for the structures and addresses.
]]

local sampapi = require 'sampapi'
local shared = sampapi.shared
local ffi = require 'ffi'

shared.require 'CVector'

shared.ffi.cdef[[
struct SCRect {
    long left, top;
    long right, bottom;
};
typedef struct SCRect SCRect;
]]