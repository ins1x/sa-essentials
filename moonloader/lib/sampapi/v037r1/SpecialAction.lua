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
enum SSpecialAction {
    SPECIAL_ACTION_NONE = 0,
    SPECIAL_ACTION_DUCK = 1,
    SPECIAL_ACTION_USEJETPACK = 2,
    SPECIAL_ACTION_ENTER_VEHICLE = 3,
    SPECIAL_ACTION_EXIT_VEHICLE = 4,
    SPECIAL_ACTION_DANCE1 = 5,
    SPECIAL_ACTION_DANCE2 = 6,
    SPECIAL_ACTION_DANCE3 = 7,
    SPECIAL_ACTION_DANCE4 = 8,
    SPECIAL_ACTION_HANDSUP = 9,
    SPECIAL_ACTION_USECELLPHONE = 10,
    SPECIAL_ACTION_SITTING = 11,
    SPECIAL_ACTION_STOPUSECELLPHONE = 12,
    SPECIAL_ACTION_DRINK_BEER = 20,
    SPECIAL_ACTION_SMOKE_CIGGY = 21,
    SPECIAL_ACTION_DRINK_WINE = 22,
    SPECIAL_ACTION_DRINK_SPRUNK = 23,
    SPECIAL_ACTION_CUFFED = 24,
    SPECIAL_ACTION_CARRY = 25,
    SPECIAL_ACTION_URINATING = 68,
};
typedef enum SSpecialAction SSpecialAction;
]]

