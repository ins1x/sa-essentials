--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local ffi = require 'ffi'

local metatype = ffi.metatype
local metatable = {}

function ffi.metatype(ct, mt)
	metatable[ct] = mt

	metatype(ct, mt)
end

local module = {}

function module.has_metatable(ct)
	return metatable[ct] ~= nil
end

function module.clear_metatable(ct)
	if module.has_metatable(ct) then
		metatable[ct] = {}
	end
end

function module.has_handler(ct, event)
	if not module.has_metatable(ct) then
		return false
	end
	return metatable[ct][event] ~= nil
end

function module.get_handler(ct, event)
	if not module.has_metatable(ct) then
		return
	end
	return metatable[ct][event]
end

function module.set_handler(ct, event, func)
	if not module.has_metatable(ct) then
		ffi.metatype(ct, {})
	end
	metatable[ct][event] = func
end

function module.provide_access(ct, t, index, newindex)
	if not module.has_metatable(ct) then
		ffi.metatype(ct, {})
	end
	if index then
		module.set_handler(
			ct,
			'__index',
			function(s, k)
				return t[k] or error(('%s has no member named "%s"'):format(ct, k))
			end
		)
	end
	if newindex then
		module.set_handler(
			ct,
			'__newindex',
			function(s, k, v)
				t[k] = v
			end
		)
	end
end

function module.hook_handler(ct, event, func)
	if not module.has_metatable(ct) then
		ffi.metatype(ct, {})
	end

	if module.has_handler(ct, event) then
		local prev = module.get_handler(ct, event)
		module.set_handler(ct, event,
		function(...)
			local ok, result = func(...)
			if ok then
				if result == nil then
					return
				end
				return unpack(result)
			end
			return prev(...)
		end)
	else
		module.set_handler(ct, event, func)
	end
end

return module
