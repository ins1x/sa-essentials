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
enum {
    RECEIVE_BUFFER_SIZE = 4096,
};

enum SRequestType {
    GET = 1,
    POST = 2,
    HEAD = 3,
};
typedef enum SRequestType SRequestType;

typedef struct SRequest SRequest;
#pragma pack(push, 1)
struct SRequest {
    short unsigned int m_nPort;
    int m_nType;
    char* m_szHost;
    char* m_szFile;
    char* m_szData;
    char* m_szReferer;
};
#pragma pack(pop)

enum SContentType {
    CONTENT_UNKNOWN = 0,
    CONTENT_TEXT = 1,
    CONTENT_HTML = 2,
};
typedef enum SContentType SContentType;

typedef struct SResponse SResponse;
#pragma pack(push, 1)
struct SResponse {
    char* m_szHeader;
    char* m_szResponse;
    unsigned int m_nHeaderLen;
    unsigned int m_nResponseLen;
    unsigned int m_nResponseCode;
    unsigned int m_nContentType;
};
#pragma pack(pop)

enum SErrorCode {
    ERROR_SUCCESS = 0,
    ERROR_BAD_HOST = 1,
    ERROR_NO_SOCKET = 2,
    ERROR_CANNOT_CONNECT = 3,
    ERROR_CANNOT_WRITE = 4,
    ERROR_TOO_BIG_CONTENT = 5,
    ERROR_INCORRECT_RESPONSE = 6,
};
typedef enum SErrorCode SErrorCode;

typedef struct SCHttpClient SCHttpClient;
#pragma pack(push, 1)
struct SCHttpClient {
    int m_nSocket;
    SRequest m_request;
    SResponse m_response;
    SErrorCode m_error;
};
#pragma pack(pop)
]]

shared.validate_size('struct SRequest', 0x16)
shared.validate_size('struct SResponse', 0x18)
shared.validate_size('struct SCHttpClient', 0x36)

local CHttpClient_constructor = ffi.cast('void(__thiscall*)(SCHttpClient*)', 0x22C0)
local CHttpClient_destructor = ffi.cast('void(__thiscall*)(SCHttpClient*)', 0x2320)
local function CHttpClient_new(...)
    local obj = ffi.gc(ffi.new('struct SCHttpClient[1]'), CHttpClient_destructor)
    CHttpClient_constructor(obj, ...)
    return obj
end

local SCHttpClient_mt = {
    GetHeaderValue = ffi.cast('bool(__thiscall*)(SCHttpClient*, const char*, char*, int)', sampapi.GetAddress(0x2390)),
    InitializeRequest = ffi.cast('void(__thiscall*)(SCHttpClient*, int, const char*, const char*, const char*)', sampapi.GetAddress(0x2490)),
    HandleEntity = ffi.cast('void(__thiscall*)(SCHttpClient*)', sampapi.GetAddress(0x2660)),
    Connect = ffi.cast('bool(__thiscall*)(SCHttpClient*, const char*, int)', sampapi.GetAddress(0x2980)),
    Process = ffi.cast('void(__thiscall*)(SCHttpClient*)', sampapi.GetAddress(0x2A40)),
    Disconnect = ffi.cast('void(__thiscall*)(SCHttpClient*)', sampapi.GetAddress(0x2420)),
    ProcessUrl = ffi.cast('SErrorCode(__thiscall*)(SCHttpClient*, int, const char*, const char*, const char*)', sampapi.GetAddress(0x2C20)),
    Send = ffi.cast('bool(__thiscall*)(SCHttpClient*, const char*)', sampapi.GetAddress(0x2430)),
    Receive = ffi.cast('int(__thiscall*)(SCHttpClient*, char*, int)', sampapi.GetAddress(0x2470)),
}
mt.set_handler('struct SCHttpClient', '__index', SCHttpClient_mt)

return {
    new = CHttpClient_new,
}