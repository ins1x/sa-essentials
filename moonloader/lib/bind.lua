-- Copyright (c) 2018 FYP <https://gitlab.com/THE-FYP>
-- Distributed under the terms of MIT license.

-- on_keypress(key1, key2, key3, ..., func)                   -- press key combination
-- on_keydown(key1, key2, ..., func)                          -- hold key combination
-- on_cheatcode(cheatcode, func)                              -- game cheat-code
-- on_sampcommand(command, [pattern], func(args, arg1, arg2)) -- samp chat command
-- on_sfcommand(command, [pattern], func(args, arg1, arg2))   -- sampfuncs's console command
-- on_command(command, [pattern], func(args, arg1, arg2))     -- samp and sampfuncs command
-- on_timer(delay, func, ...)                                 -- infinite loop with delay
-- on_timeout(delay, func, ...)                               -- run once when timer expired
-- bind:unbind()                                              -- destroy bind

local module = {
	_VERSION = '1.0.0'
}
local task_create, task_create_suspended = lua_thread.create, lua_thread.create_suspended

local function typecheck(...)
	local args = {...}
	for i = 1, #args, 2 do
		if args[i + 1] == '*' or args[i + 1] ~= type(args[i]) then
			local name = debug.getinfo(2).name
			error(("bad argument #%d to '%s' (%s expected, got %s)"):format((i + 1) / 2, name, args[i + 1], type(args[i])))
		end
	end
end

local function init_bind(bind, runner, ...)
	function bind:unbind()
		self.task:terminate()
	end
	local task = task_create_suspended(runner)
	bind.task = task
	task:run(bind, ...)
end

local function is_key_input_accessible()
    if not isSampfuncsLoaded() then return true end
    local result = not isSampfuncsConsoleActive() and not isPauseMenuActive()
    if isSampLoaded() and isSampAvailable() then
        result = result and not sampIsChatInputActive() and not sampIsDialogActive()
    end
    return result
end

local function is_keycombo_activated(keys, press)
	if not is_key_input_accessible() then
		return false
	end
	for i = 1, #keys do
		if (i == #keys and press and not wasKeyPressed(keys[i])) or not isKeyDown(keys[i]) then
			return false
		end
	end
	return true
end

local function keypress_bind(keys, func, press)
	local bind = {keys = keys}
	init_bind(bind, function(bind)
		while true do
			if is_keycombo_activated(bind.keys, press) then
				func()
			end
			wait(0)
		end
	end)
	return bind
end

local function command_bind(cmd, pat_or_fn, fn, register, unregister)
	local func, pattern
	if fn then
		typecheck(cmd, 'string', pat_or_fn, 'string', fn, 'function')
		func, pattern = fn, pat_or_fn
	else
		typecheck(cmd, 'string', pat_or_fn, 'function')
		func = pat_or_fn
	end
	local bind = {command = cmd, pattern = pattern}
	function bind:unbind()
		unregister(self.command)
	end
	register(cmd, function(params)
		local values = {}
		if bind.pattern then
			values = {string.match(params, bind.pattern)}
		else -- split string
			for v in string.gmatch(params, "%S+") do
			   table.insert(values, v)
			end
		end
		task_create(func, params, unpack(values))
	end)
	return bind
end

function module.on_keydown(...)
	local args = {...}
	local func = args[#args]
	args[#args] = nil
	return keypress_bind(args, func, false)
end

function module.on_keypress(...)
	local args = {...}
	local func = args[#args]
	args[#args] = nil
	return keypress_bind(args, func, true)
end

function module.on_cheatcode(cheat, func)
	typecheck(cheat, 'string', func, 'function')
	local bind = {cheatcode = cheat}
	init_bind(bind, function(bind)
		while true do
			if testCheat(bind.cheatcode) and is_key_input_accessible() then
				func()
			end
			wait(0)
		end
	end)
	return bind
end

function module.on_timeout(time, func, ...)
	typecheck(time, 'number', func, 'function')
	local bind = {}
	init_bind(bind, function(bind, ...)
		wait(time)
		func(...)
	end, ...)
	return bind
end

function module.on_timer(time, func, ...)
	typecheck(time, 'number', func, 'function')
	local bind = {}
	init_bind(bind, function(bind, ...)
		while true do
			wait(time)
			func(...)
		end
	end, ...)
	return bind
end

function module.on_sampcommand(cmd, pat_or_fn, fn)
	if not isSampLoaded() or not isSampfuncsLoaded() then
		return nil
	end
	return command_bind(cmd, pat_or_fn, fn, sampRegisterChatCommand, sampUnregisterChatCommand)
end

function module.on_sfcommand(cmd, pat_or_fn, fn)
	if not isSampfuncsLoaded() then
		return nil
	end
	return command_bind(cmd, pat_or_fn, fn, sampfuncsRegisterConsoleCommand, sampfuncsUnregisterConsoleCommand)
end

function module.on_command(cmd, pat_or_fn, fn)
	local b1 = module.on_sfcommand(cmd, pat_or_fn, fn)
	local b2 = module.on_sampcommand(cmd, pat_or_fn, fn)
	if not b1 and not b2 then
		return nil
	end
	local bind = {sfbind = b1, sampbind = b2}
	function bind:unbind()
		if self.sfbind then
			self.sfbind:unbind()
		end
		if self.sampbind then
			self.sampbind:unbind()
		end
	end
	setmetatable(bind, {
		__index = function(self, key)
			if self.sfbind then
				return self.sfbind[key]
			elseif self.sampbind then
				return self.sfbind[key]
			end
		end,
		__newindex = function(self, key, val)
			if self.sfbind then
				self.sfbind[key] = val
			end
			if self.sampbind then
				self.sampbind[key] = val
			end
		end,
	})
	return bind
end

return module
