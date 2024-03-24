--[[
    Project: SF.lua <https://github.com/imring/SF.lua>
    License: GNU General Public License v3.0
    Authors: look in file <AUTHORS>.
]]

local ffi = require 'ffi'
local memory = require 'memory'

require 'SFlua.cdef'
require 'SFlua.const'

local versions = {
    [0x31DF13] = { VERSION_0_3_7_R1, 'SFlua.037-r1' }
}

local currentVersion, sampModule = nil, getModuleHandle("samp.dll")

function isSampLoaded()
    if sampModule <= 0 then return false end
    
    if not currentVersion then
        -- Getting version taken from SAMP-API (thx fyp)
        local ntheader = sampModule + memory.getint32(sampModule + 0x3C)
        local ep = memory.getuint32(ntheader + 0x28)
        currentVersion = versions[ep]
        if not currentVersion then
            print(('WARNING: Unknown version of SA-MP (Entry point: 0x%08x)'):format(ep))
            currentVersion = { VERSION_UNKNOWN, '' }
        else
            require(currentVersion[2])
        end
    end
    return true
end

function sampGetBase()
    return sampModule
end

function sampGetVersion()
    return currentVersion[1]
end

function isSampfuncsLuaLoaded()
    return sampGetVersion() ~= VERSION_UNKNOWN
end

isSampLoaded()