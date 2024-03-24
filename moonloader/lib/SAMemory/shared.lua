--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local mt = require 'SAMemory.metatype'
local ffi = require 'ffi'

local cdef = ffi.cdef

local module = {
	ffi = ffi;
}

function module.ffi.cdef(def)
	local defn, c = def:gsub('struct%s*([_%a%d]+)%s*:%s*(%a*%s*[_%a%d]+)[\n%s]*{', 'struct %1 { %2 __parent;')

	cdef(defn)

	if c == 0 then return end

	for child in def:gmatch('(struct%s*[%a%d%p]+)%s*:') do
		mt.set_handler(
			child,
			'__index',
			function(s, k)
				return s.__parent[k] or error(('%s has no member named "%s"'):format(child, k or '?'))
			end
		)
		mt.set_handler(
			child,
			'__newindex',
			function(s, k, v)
				s.__parent[k] = v
			end
		)
	end
end

function module.require(mod)
	if not package.loading then package.loading = {} end
	mod = 'SAMemory.game.' .. mod
	if package.loading[mod] == nil then
		package.loading[mod] = true
		local v = {require(mod)}
		package.loading[mod] = nil
		return unpack(v)
	end
end

function module.validate_size(struct, size)
	local sizeof = ffi.sizeof(struct) or 0
	assert(sizeof == size, ("validate_size('%s', %d) assertion failed! Expected size 0x%X, got 0x%X."):format(struct, size, size, sizeof))
end

return module
