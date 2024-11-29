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
typedef struct SCSrvNetStats SCSrvNetStats;
#pragma pack(push, 1)
struct SCSrvNetStats {
    long unsigned int m_dwLastTotalBytesSent;
    long unsigned int m_dwLastTotalBytesRecv;
    long unsigned int m_dwLastUpdateTick;
    long unsigned int m_dwBPSUpload;
    long unsigned int m_dwBPSDownload;
    struct IDirect3DDevice9* m_pDevice;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCSrvNetStats', 0x18)

local CSrvNetStats_constructor = ffi.cast('void(__thiscall*)(SCSrvNetStats*, IDirect3DDevice9*)', 0x71220)
local function CSrvNetStats_new(...)
    local obj = ffi.new('struct SCSrvNetStats[1]')
    CSrvNetStats_constructor(obj, ...)
    return obj
end

local SCSrvNetStats_mt = {
    Draw = ffi.cast('void(__thiscall*)(SCSrvNetStats*)', sampapi.GetAddress(0x71260)),
}
mt.set_handler('struct SCSrvNetStats', '__index', SCSrvNetStats_mt)

local function RefServerNetStatistics() return ffi.cast('SCSrvNetStats**', sampapi.GetAddress(0x26EB70))[0] end

return {
    new = CSrvNetStats_new,
    RefServerNetStatistics = RefServerNetStatistics,
}