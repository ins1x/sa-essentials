--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

local ffi = shared.ffi
local cast = ffi.cast
local sizeof = ffi.sizeof

ffi.cdef[[
	typedef union tPoolObjectFlags
	{
		struct
		{
			unsigned char nId : 7;
			bool 					bEmpty : 1;
		};
		unsigned char nValue;
	} tPoolObjectFlags;

	typedef struct CPool
	{
		uintptr_t 				pObjects;
		tPoolObjectFlags  *byteMap;
		int               nSize;
		int               nFirstFree;
		bool              bOwnsAllocations;
		bool 							field_11;
	} CPool;
]]

shared.validate_size('CPool', 0x14)

local mt = require 'SAMemory.metatype'

local data_type_object_size = {
	CVehicle = 0xA18; -- size of CHeli
	CObject = 0x19C; -- size of CCutsceneObject
	CTask = 0x80; -- size of char[128]
	CPed = 0x7C4; -- size of CCopPed
}

local pool = {}

function pool:size()
	return self.nSize
end

function pool:object_size(ct)
	return (data_type_object_size[ct] or sizeof(ct))
end

function pool:is_valid_idx(idx)
	if idx ~= nil then
		return idx > -1 and idx < self:size()
	end
	return false
end

function pool:is_empty(idx)
	if self:is_valid_idx(idx) then
		return self.byteMap[idx].bEmpty
	end
end

function pool:free_slots()
	local count = 0

	for i = 0, self:size() - 1 do
		if self:is_empty(i) then
			count = count + 1
		end
	end

	return count
end

function pool:used_slots()
	return self:size() - self:free_slots()
end

function pool:index(ct, obj)
	return tonumber(cast('uintptr_t', obj) - self.pObjects) / self:object_size(ct)
end

function pool:is_valid_object(obj)
	local idx = self:index(obj)
	if self:is_valid_idx(idx) then
		return (not self:is_empty(idx))
	end
	return false
end

function pool:set_free(idx, free)
	if self:is_valid_idx(idx) then
		if not self:is_empty(idx) then
			self.byteMap[idx].bEmpty = free
			if free then
				if idx < self.nFirstFree then
					self.nFirstFree = idx
				end
			end
		end
	end
end

function pool:get_handle(ct, obj)
	local idx = self:index(ct, obj)
	return bit.lshift(idx, 8) + self.byteMap[idx].nValue
end

function pool:get_handle_pool_slot(handle)
	return bit.rshift(handle, 8)
end

function pool:is_valid_handle(handle)
	local idx = self:get_handle_pool_slot(handle)
	if self:is_valid_idx(idx) then
		return self.byteMap[idx].nValue == bit.band(handle, 0xFF)
	end
	return false
end

function pool:get_ptr(ct, handle)
	if self:is_valid_handle(handle) then
		return self:get_object(ct, self:get_handle_pool_slot(handle))
	end
end

function pool:remove(ct, obj)
	self:set_free(self:index(ct, obj))
end

function pool:get_object(ct, idx)
	if self:is_valid_idx(idx) then
		if not self:is_empty(idx) then
			return cast(ct .. '*', self.pObjects + idx * self:object_size(ct))
		end
	end
end

-- returns iterator
function pool:objects(ct)
	local i = 0

	return function()
		for itr = i, self:size() - 1 do
			if not self:is_empty(itr) then
				i = itr + 1
				return itr, self:get_object(ct, itr)
			end
		end
	end

end

mt.provide_access('CPool', pool, true, false)
mt.set_handler('CPool', '__call', pool.objects)
