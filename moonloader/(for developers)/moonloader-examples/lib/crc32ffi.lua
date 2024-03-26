--go @ bin/luajit.exe -jdump *
--CRC-32 implementation, see http://www.geocities.ws/malbrain/
--TODO: the zlib implementation of crc32 is 6x faster, can we do better with Lua?
--modified by FYP
local ffi = require'ffi'
local bit = require'bit'

local s_crc32 = ffi.new('const uint32_t[16]',
  0x00000000, 0x1DB71064, 0x3B6E20C8, 0x26D930AC,
  0x76DC4190, 0x6B6B51F4, 0x4DB26158, 0x5005713C,
  0xEDB88320, 0xF00F9344, 0xD6D6A3E8, 0xCB61B38C,
  0x9B64C2B0, 0x86D3D2D4, 0xA00AE278, 0xBDBDF21C)

local function crc32(buf, sz, crc)
  crc = crc or 0
  sz = sz or #buf
  buf = ffi.cast('const uint8_t*', buf)
  crc = bit.bnot(crc)
  for i = 0, sz - 1 do
    crc = bit.bxor(bit.rshift(crc, 4), s_crc32[bit.bxor(bit.band(crc, 0xF), bit.band(buf[i], 0xF))])
    crc = bit.bxor(bit.rshift(crc, 4), s_crc32[bit.bxor(bit.band(crc, 0xF), bit.rshift(buf[i], 4))])
  end
  return bit.bnot(crc)
end

return crc32
