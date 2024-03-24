--[[
    Project: SF.lua <https://github.com/imring/SF.lua>
    License: GNU General Public License v3.0
	Authors: look in file <AUTHORS>.
	
	lite version of RakNet BitStream Copyright 2003 Kevin Jenkins.
]]

local ffi = require 'ffi'
local bit = require 'bit'

ffi.cdef[[
void *malloc(size_t size);
void free(void * ptrmem);
void *realloc(void *ptr, size_t newsize);
void *memset(void *memptr, int val, size_t num);

typedef unsigned char BYTE;

#pragma pack(push, 1)

typedef struct
{
	int						numberOfBitsUsed;
	int						numberOfBitsAllocated;
	int						readOffset;
	BYTE*					data;
	bool					copyData;
	BYTE					stackData[256];
} SFL_BitStream;

#pragma pack(pop)
]]

local lshift, band, rshift, bor = bit.lshift, bit.band, bit.rshift, bit.bor
local cast, sizeof, gc, typeof, istype, new = ffi.cast, ffi.sizeof, ffi.gc, ffi.typeof, ffi.istype, ffi.new
local malloc, free, memcpy, memset, realloc = ffi.C.malloc, ffi.C.free, ffi.copy, ffi.C.memset, ffi.C.realloc

local BITSTREAM_STACK_ALLOCATION_SIZE = 256

local function BYTES_TO_BITS(x) return lshift(x, 3) end
local function BITS_TO_BYTES(x) return rshift(x + 7, 3) end

local BitStream = {}
BitStream.__index = BitStream
local BitStream_type = ffi.typeof('SFL_BitStream')

local bs_initialize = {
	function(self)
		self.numberOfBitsUsed = 0
		-- self.numberOfBitsAllocated = 32 * 8,
		self.numberOfBitsAllocated = BITSTREAM_STACK_ALLOCATION_SIZE * 8
		self.readOffset = 0
		-- self.data = cast('BYTE*', malloc(32)),
		self.data = cast('BYTE*', self.stackData)
		self.copyData = true
	end,

	function(self, initialBytesToAllocate)
		self.numberOfBitsUsed = 0
		self.readOffset = 0
		if initialBytesToAllocate <= BITSTREAM_STACK_ALLOCATION_SIZE then
			self.data = cast('BYTE*', self.stackData)
			self.numberOfBitsAllocated = BITSTREAM_STACK_ALLOCATION_SIZE * 8
		else
			self.data = cast('BYTE*', malloc(initialBytesToAllocate))
			self.numberOfBitsAllocated = BYTES_TO_BITS(initialBytesToAllocate)
		end
		self.copyData = true
	end,

	function(self, _data, lengthInBytes, _copyData)
		_data = cast('BYTE*', _data)

		self.numberOfBitsUsed = BYTES_TO_BITS(lengthInBytes)
		self.readOffset = 0
		self.copyData = _copyData
		self.numberOfBitsAllocated = BYTES_TO_BITS(lengthInBytes)
		if self.copyData then
			if lengthInBytes > 0 then
				if lengthInBytes < BITSTREAM_STACK_ALLOCATION_SIZE then
					self.data = cast('BYTE*', self.stackData)
					self.numberOfBitsAllocated = BYTES_TO_BITS(BITSTREAM_STACK_ALLOCATION_SIZE)
				else self.data = cast('BYTE*', malloc(lengthInBytes)) end
				memcpy(self.data, _data, lengthInBytes)
			else self.data = nil end
		else self.data = _data end
	end
}

local bs_write = {
	function(self, bitStream)
		bitStream = cast('SFL_BitStream*', bitStream)
		self:Write(bitStream, bitStream:GetNumberOfBitsUsed())
	end,

	function(self, input, numberOfBytes)
		input = cast('const char*', input)
		if not numberOfBytes or numberOfBytes == 0 then return end
		if band(self.numberOfBitsUsed, 7) == 0 then
			self:AddBitsAndReallocate(BYTES_TO_BITS(numberOfBytes))
			memcpy(self.data + BITS_TO_BYTES(self.numberOfBitsUsed), input, numberOfBytes)
			self.numberOfBitsUsed = self.numberOfBitsUsed + BYTES_TO_BITS(numberOfBytes)
		else self:WriteBits(input, numberOfBytes * 8, true) end
	end,

	function(self, bitStream, numberOfBits)
		self:AddBitsAndReallocate(numberOfBits)
		local numberOfBitsMod8 = 0
		while self.numberOfBits > 0 and bitStream.readOffset + 1 <= bitStream.numberOfBitsUsed do
			self.numberOfBits = self.numberOfBits - 1
			numberOfBitsMod8 = band(self.numberOfBitsUsed, 7)
			if numberOfBitsMod8 == 0 then
				local ro = bitStream.readOffset
				bitStream.readOffset = bitStream.readOffset + 1
				if band(bitStream.data[rshift(ro, 3)], rshift(0x80, ro % 8)) > 0 then
					self.data[rshift(bitStream.numberOfBitsUsed, 3)] = 0x80
				else
					self.data[rshift(bitStream.numberOfBitsUsed, 3)] = 0
				end
			else
				local ro = bitStream.readOffset
				bitStream.readOffset = bitStream.readOffset + 1
				if band(bitStream.data[rshift(ro, 3)], rshift(0x80, ro % 8)) > 0 then
					self.data[rshift(self.numberOfBitsUsed, 3)] = bor(self.data[rshift(self.numberOfBitsUsed, 3)], rshift(0x80, numberOfBitsMod8))
				end
			end
			self.numberOfBitsUsed = self.numberOfBitsUsed + 1
		end
	end
}

local bs_read = {
	function(self, cdata)
		return self:ReadBits(cdata, ffi.sizeof(cdata) * 8, true)
	end,

	function(self, output, numberOfBytes)
		output = cast('char*', output)
		if band(self.readOffset, 7) == 0 then
			if self.readOffset + BYTES_TO_BITS(numberOfBytes) > self.numberOfBitsUsed then return false end
			memcpy(output, self.data + rshift(self.readOffset, 3), numberOfBytes)
			self.readOffset = self.readOffset + BYTES_TO_BITS(numberOfBytes)
			return true
		else
			return self:ReadBits(output, numberOfBytes * 8)
		end
	end
}

function BitStream.__new(ctype, ...)
	local v, func = select('#', ...)
	if v == 0 then func = bs_initialize[1]
	elseif v < 3 then func = bs_initialize[2]
	else func = bs_initialize[3] end
	
	local bs_data = gc(malloc(sizeof('SFL_BitStream')), BitStream.__gc)
	bs_data = cast('SFL_BitStream*', bs_data)
	func(bs_data, ...)
	return bs_data
end

function BitStream:__gc()
	if self.copyData and self.numberOfBitsAllocated > BYTES_TO_BITS(BITSTREAM_STACK_ALLOCATION_SIZE) then free(self) end
end

function BitStream:SetNumberOfBitsAllocated(lengthInBits)
	self.numberOfBitsAllocated = lengthInBits
end

function BitStream:Reset()
	if self.numberOfBitsUsed > 0 then
		-- memset(data, BITS_TO_BYTES(numberOfBitsUsed), 0)
	end
	self.numberOfBitsUsed = 0
	self.readOffset = 0
end

function BitStream:Write(...)
	local v, func = select('#', ...)
	local first = select(1, ...)
	if v == 1 then func = bs_write[1]
	elseif v > 1 and type(first) == 'cdata' and istype(typeof(first), BitStream_type) then func = bs_write[3]
	elseif v > 1 then func = bs_write[2] end
	func(self, ...)
end

function BitStream:Read(...)
	local v, func = select('#', ...)
	if v >= 2 then func = bs_read[2]
	else func = bs_read[1] end
	func(self, ...)
end

function BitStream:ResetReadPointer()
	self.readOffset = 0
end

function BitStream:ResetWritePointer()
	self.numberOfBitsUsed = 0
end

function BitStream:Write0()
	self:AddBitsAndReallocate(1)
	if band(self.numberOfBitsUsed, 7) == 0 then
		self.data[rshift(numberOfBitsUsed, 3)] = 0
	end
	self.numberOfBitsUsed = self.numberOfBitsUsed + 1
end

function BitStream:Write1()
	self:AddBitsAndReallocate(1)
	local numberOfBitsMod8 = band(self.numberOfBitsUsed, 7)
	if numberOfBitsMod8 == 0 then
		self.data[rshift(self.numberOfBitsUsed, 3)] = 0x80
	else
		self.data[rshift(self.numberOfBitsUsed, 3)] = bor(self.data[rshift(self.numberOfBitsUsed, 3)], rshift(0x80, numberOfBitsMod8))
	end
	self.numberOfBitsUsed = self.numberOfBitsUsed + 1
end

function BitStream:ReadBit()
	local res = band(self.data[rshift(self.readOffset, 3)], rshift(0x80, band(self.readOffset, 7)))
	self.readOffset = self.readOffset + 1
	return res > 0
end

function BitStream:WriteAlignedBytes(input, numberOfBytesToWrite)
	self:AlignWriteToByteBoundary()
	self:Write(input, numberOfBytesToWrite)
end

function BitStream:ReadAlignedBytes(output, numberOfBytesToRead)
	if numberOfBytesToRead <= 0 then return false end
	output = cast('BYTE*', output)
	self:AlignReadToByteBoundary()
	if self.readOffset + BYTES_TO_BITS(numberOfBytesToRead) > self.numberOfBitsUsed then return false end
	memcpy(output, self.data + rshift(self.readOffset, 3), numberOfBytesToRead)
	self.readOffset = self.readOffset + BYTES_TO_BITS(numberOfBytesToRead)
	return true
end

function BitStream:AlignWriteToByteBoundary()
	if self.numberOfBitsUsed > 0 then
		self.numberOfBitsUsed = self.numberOfBitsUsed + ( 8 - band(self.numberOfBitsUsed - 1, 7) + 1 )
	end
end

function BitStream:AlignReadToByteBoundary()
	if self.readOffset > 0 then
		self.readOffset = self.readOffset + ( 8 - band(self.readOffset - 1, 7) + 1 )
	end
end

function BitStream:WriteBits(input, numberOfBitsToWrite, rightAlignedBits)
	if numberOfBitsToWrite <= 0 then return end
	input = cast('BYTE*', input)

	self:AddBitsAndReallocate(numberOfBitsToWrite)
	local offset = 0
	local dataByte = 0
	local numberOfBitsUsedMod8 = 0

	numberOfBitsUsedMod8 = band(self.numberOfBitsUsed, 7)

	while numberOfBitsToWrite > 0 do
		dataByte = (input + offset)[0]

		if numberOfBitsToWrite < 8 and rightAlignedBits then
			dataByte = lshift(dataByte, 8 - numberOfBitsToWrite)
		end

		if numberOfBitsUsedMod8 == 0 then
			(self.data + rshift(self.numberOfBitsUsed, 3))[0] = dataByte
		else
			(self.data + rshift(self.numberOfBitsUsed, 3))[0] = bor((self.data + rshift(self.numberOfBitsUsed, 3))[0], rshift(dataByte, numberOfBitsUsedMod8))

			if 8 - numberOfBitsUsedMod8 < 8 and 8 - numberOfBitsUsedMod8 < numberOfBitsToWrite then
				(self.data + rshift(self.numberOfBitsUsed, 3) + 1)[0] = lshift(dataByte, 8 - numberOfBitsUsedMod8)
			end
		end

		if numberOfBitsToWrite >= 8 then self.numberOfBitsUsed = self.numberOfBitsUsed + 8
		else self.numberOfBitsUsed = self.numberOfBitsUsed + numberOfBitsToWrite end

		numberOfBitsToWrite = numberOfBitsToWrite - 8

		offset = offset + 1
	end
end

function BitStream:SetData(input)
	self.data = cast('BYTE*', input)
	self.copyData = false
end

function BitStream:WriteCompressed(input, size, unsignedData)
	input = cast('BYTE*', input)
	local currentByte = rshift(size, 3) - 1
	local byteMatch = 0
	if not unsignedData then byteMatch = 0xFF end
	while currentByte > 0 do
		if input[currentByte] == byteMatch then
			-- self:Write(true)
		else
			-- self:Write(false)
			self:WriteBits(input, BYTES_TO_BITS(currentByte + 1), true)
			return
		end
		currentByte = currentByte - 1
	end
	if ( unsignedData and band((input + currentByte)[0], 0xF0) == 0x00 ) or 
		( unsignedData == false and band((input + currentByte)[0], 0xF0) == 0xF0 ) then
		-- self:Write(true)
		self:WriteBits(input + currentByte, 4, true)
	else
		-- self:Write(false)
		self:WriteBits(input + currentByte, 8, true)
	end
end

function BitStream:ReadBits(output, numberOfBitsToRead, alignBitsToRight)
	output = cast('BYTE*', output)
	if numberOfBitsToRead <= 0 then return false end

	if self.readOffset + numberOfBitsToRead > self.numberOfBitsUsed then return false end

	local readOffsetMod8, offset = 0, 0
	memset(output, 0, BITS_TO_BYTES(numberOfBitsToRead))

	readOffsetMod8 = band(self.readOffset, 7)
	while numberOfBitsToRead > 0 do
		local this = output + offset
		this[0] = bor(this[0], lshift((self.data + rshift(self.readOffset, 3))[0], readOffsetMod8))
		if readOffsetMod8 > 0 and numberOfBitsToRead > 8 - readOffsetMod8 then
			this[0] = bor(this[0], rshift((self.data + rshift(self.readOffset, 3) + 1)[0], 8 - readOffsetMod8))
		end
		numberOfBitsToRead = numberOfBitsToRead - 8
		if numberOfBitsToRead < 0 then
			if alignBitsToRight then this[0] = rshift(this[0], -numberOfBitsToRead) end
			self.readOffset = self.readOffset + 8 + numberOfBitsToRead
		else self.readOffset = self.readOffset + 8 end
		offset = offset + 1
	end
	return true
end

function BitStream:ReadCompressed(output, size, unsignedData)
	output = cast('BYTE*', output)
	local currentByte = rhsift(size, 3) - 1

	local byteMatch, halfByteMatch = 0, 0

	if not unsignedData then byteMatch, halfByteMatch = 0xFF, 0xF0 end

	while currentByte > 0 do
		local b = ffi.new('bool[1]')

		if self:Read(b) == false then return false end

		if b[0] then
			output[currentByte] = byteMatch
			currentByte = currentByte - 1
		else
			if self:ReadBits(output, BYTES_TO_BITS(currentByte + 1)) == false then return false end

			return true
		end
	end

	if readOffset + 1 > self.numberOfBitsUsed then
		return false
	end

	local b = ffi.new('bool[1]')
	if self:Read(b) == false then return false end
	if b[0] then
		if self:ReadBits(output + currentByte, 4) == false then
			return false
		end
		output[currentByte] = bor(output[currentByte], halfByteMatch)
	else
		if self:ReadBits(output + currentByte, 8) == false then return false end
	end

	return true
end

function BitStream:AddBitsAndReallocate(numberOfBitsToWrite)
	if numberOfBitsToWrite <= 0 then return end

	local newNumberOfBitsAllocated = numberOfBitsToWrite + self.numberOfBitsUsed

	if numberOfBitsToWrite + self.numberOfBitsUsed > 0 and rshift(self.numberOfBitsAllocated - 1, 3) < rshift(newNumberOfBitsAllocated - 1, 3) then
		newNumberOfBitsAllocated = ( numberOfBitsToWrite + self.numberOfBitsUsed ) * 2
		local amountToAllocate = BITS_TO_BYTES(newNumberOfBitsAllocated)
		if self.data == cast('BYTE*', self.stackData) then
			if amountToAllocate > BITSTREAM_STACK_ALLOCATION_SIZE then
				data = cast('BYTE*', malloc(amountToAllocate))

				memcpy(cast('void*', data), cast('void*', stackData), BITS_TO_BYTES(self.numberOfBitsAllocated))
			end
		else
			data = cast('BYTE*', realloc(self.data, amountToAllocate))
		end
	end

	if newNumberOfBitsAllocated > self.numberOfBitsAllocated then
		self.numberOfBitsAllocated = newNumberOfBitsAllocated
	end
end

function BitStream:AssertStreamEmpty()
	assert(self.readOffset == self.numberOfBitsUsed)
end

function BitStream:CopyData(_data)
	_data = cast('BYTE**', _data)
	_data[0] = ffi.new('BYTE[?]', BITS_TO_BYTES( self.numberOfBitsUsed ))
	memcpy(_data[0], self.data, ffi.sizeof('BYTE') * BITS_TO_BYTES( self.numberOfBitsUsed ))
	return self.numberOfBitsUsed
end

function BitStream:IgnoreBits(numberOfBits)
	self.readOffset = self.readOffset + numberOfBits
end

function BitStream:SetWriteOffset(offset)
	self.numberOfBitsUsed = offset
end

function BitStream:AssertCopyData()
	if self.copyData == false then
		self.copyData = true

		if self.numberOfBitsAllocated > 0 then
			local newdata = malloc(BITS_TO_BYTES( self.numberOfBitsAllocated ) )

			memcpy(newdata, data, BITS_TO_BYTES( self.numberOfBitsAllocated ))
			self.data = newdata
		else self.data = nil end
	end
end

function BitStream:ReverseBytes(input, output, length)
	input = cast('BYTE*', input)
	output = cast('BYTE*', output)
	for i = 0, length - 1 do
		output[i] = input[length-i-1]
	end
end

ffi.metatype(BitStream_type, BitStream)

return BitStream_type