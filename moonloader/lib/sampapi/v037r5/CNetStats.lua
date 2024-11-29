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
typedef struct SCNetStats SCNetStats;
#pragma pack(push, 1)
struct SCNetStats {
    long unsigned int m_dwLastTotalBytesSent;
    long unsigned int m_dwLastTotalBytesRecv;
    long unsigned int m_dwLastUpdateTick;
    long unsigned int m_dwBPSUpload;
    long unsigned int m_dwBPSDownload;
    struct IDirect3DDevice9* m_pDevice;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCNetStats', 0x18)

local CNetStats_constructor = ffi.cast('void(__thiscall*)(SCNetStats*, IDirect3DDevice9*)', 0x60D40)
local function CNetStats_new(...)
    local obj = ffi.new('struct SCNetStats[1]')
    CNetStats_constructor(obj, ...)
    return obj
end

local SCNetStats_mt = {
    Draw = ffi.cast('void(__thiscall*)(SCNetStats*)', sampapi.GetAddress(0x60D70)),
}
mt.set_handler('struct SCNetStats', '__index', SCNetStats_mt)

local function RefNetStats() return ffi.cast('SCNetStats**', sampapi.GetAddress(0x26EB6C))[0] end

return {
    new = CNetStats_new,
    RefNetStats = RefNetStats,
}