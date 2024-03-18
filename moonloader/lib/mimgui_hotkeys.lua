--[[
	   
	Author: СоМиК
	Links:
		- https://www.blast.hk/members/406277/
		- https://t.me/klamet_one
		- https://vk.com/klamet1

]]

local imgui = require 'mimgui'
local vk = require 'vkeys'

HOTKEY = {
	MODULEINFO = {
		version = 1,
		author = 'СоМиК'
	},
	Text = {
		WaitForKey = 'Нажмите любую клавишу...',
		NoKey = '< Свободно >'
	},
	List = {},
	ActiveKeys = {},
	ReturnHotKeys = nil,
	HotKeyIsEdit = nil,
	CancelKey = 0x1B,
	RemoveKey = 0x08,
	True = true
}

local specialKeys = {
	0x10,
	0x11,
	0x12,
	0xA4,
	0xA5
}

deepcopy = function(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[deepcopy(orig_key)] = deepcopy(orig_value)
		end
		setmetatable(copy, deepcopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

local keyIsSpecial = function(key)
	for k, v in ipairs(specialKeys) do
		if v == key then
			return true
		end
	end
	return false
end

local getKeysText = function(name)
	local keysText = {}
	if HOTKEY.List[name] ~= nil then
		for k, v in ipairs(HOTKEY.List[name].keys) do
			table.insert(keysText, vk.id_to_name(v))
		end
	end
	return table.concat(keysText, ' + ')
end

local searchHotKey = function(keys)
	local needCombo = deepcopy(keys)
	table.sort(needCombo)
	needCombo = table.concat(needCombo, ':')
	for k, v in pairs(HOTKEY.List) do
		if next(v.keys) then
			local foundCombo = deepcopy(v.keys)
			table.sort(foundCombo)
			foundCombo = table.concat(foundCombo, ':')
			if foundCombo == needCombo then
				v.callback()
				break
			end
		end
	end
end

HOTKEY.RegisterHotKey = function(name, soloKey, keys, callback)
	if HOTKEY.List[name] == nil then
		HOTKEY.List[name] = {
			soloKey = soloKey,
			keys = keys,
			callback = callback
		}
		return {
			name,
			['ShowHotKey'] = setmetatable({}, {__call = function(self, arg1, arg2) return HOTKEY.ShowHotKey(arg1[1], arg2) end}),
			['EditHotKey'] = setmetatable({}, {__call = function(self, arg1, arg2) return HOTKEY.EditHotKey(arg1[1], arg2) end}),
			['RemoveHotKey'] = setmetatable({}, {__call = function(self, arg) return HOTKEY.RemoveHotKey(arg[1]) end}),
			['GetHotKey'] = setmetatable({}, {__call = function(self, arg) return HOTKEY.GetHotKey(arg[1]) end})
		}
	end
end

HOTKEY.EditHotKey = setmetatable(
	{},
	{
		__call = function(self, name, keys)
			if HOTKEY.List[name] ~= nil then
				HOTKEY.List[name].keys = keys
				return true
			end
			return false
		end
	}
)

HOTKEY.RemoveHotKey = setmetatable(
	{},
	{
		__call = function(self, name)
			HOTKEY.List[name] = nil
			return true
		end
	}
)

HOTKEY.ShowHotKey = setmetatable(
	{},
	{
		__call = function(self, name, sizeButton)
			if HOTKEY.List[name] ~= nil then
				local HotKeyText = #HOTKEY.List[name].keys == 0 and ((HOTKEY.HotKeyIsEdit ~= nil and HOTKEY.HotKeyIsEdit.NameHotKey == name) and HOTKEY.Text.WaitForKey or HOTKEY.Text.NoKey) or getKeysText(name)
				if imgui.Button(('%s##HK:%s'):format(HotKeyText, name), sizeButton) then
					HOTKEY.HotKeyIsEdit = {
						NameHotKey = name,
						BackupHotKeyKeys = HOTKEY.List[name].keys,
					}
					HOTKEY.ActiveKeys = {}
					HOTKEY.HotKeyIsEdit.ActiveKeys = {}
					HOTKEY.List[name].keys = {}
				end
				if HOTKEY.ReturnHotKeys == name then
					HOTKEY.ReturnHotKeys = nil
					return true
				end
			else
				imgui.Button('Хоткей не найден', sizeButton)
			end
		end
	}
)

HOTKEY.GetHotKey = setmetatable(
	{},
	{
		__call = function(self, name)
			if HOTKEY.List[name] ~= nil then
				return HOTKEY.List[name].keys
			end
		end
	}
)

addEventHandler('onWindowMessage', function(msg, key, lparam)
	if msg == 0x100 or msg == 260 then
		if HOTKEY.HotKeyIsEdit == nil then
			if key ~= HOTKEY.CancelKey and key ~= HOTKEY.RemoveKey and key ~= 0x1B and key ~= 0x08 and next(HOTKEY.List) then
				local found = false
				for k, v in ipairs(HOTKEY.ActiveKeys) do
					if v == key then
						found = true
						break
					end
				end
				if not found then
					table.insert(HOTKEY.ActiveKeys, key)
					if keyIsSpecial(key) then
						table.sort(HOTKEY.ActiveKeys)
					else
						searchHotKey(HOTKEY.ActiveKeys)
						table.remove(HOTKEY.ActiveKeys)
					end
				end
			end
		else
			if key == HOTKEY.CancelKey then
				HOTKEY.List[HOTKEY.HotKeyIsEdit.NameHotKey].keys = HOTKEY.HotKeyIsEdit.BackupHotKeyKeys
				HOTKEY.HotKeyIsEdit = nil
			elseif key == HOTKEY.RemoveKey then
				HOTKEY.List[HOTKEY.HotKeyIsEdit.NameHotKey].keys = {}
				HOTKEY.ReturnHotKeys = HOTKEY.HotKeyIsEdit.NameHotKey
				HOTKEY.HotKeyIsEdit = nil
			elseif key ~= 0x1B and key ~= 0x08 then
				local found = false
				for k, v in ipairs(HOTKEY.HotKeyIsEdit.ActiveKeys) do
					if v == key then
						found = true
						break
					end
				end
				if not found then
					if keyIsSpecial(key) then
						if not HOTKEY.List[HOTKEY.HotKeyIsEdit.NameHotKey].soloKey then
							for k, v in ipairs(specialKeys) do
								if key == v then
									table.insert(HOTKEY.HotKeyIsEdit.ActiveKeys, v)
								end
							end
							table.sort(HOTKEY.HotKeyIsEdit.ActiveKeys)
							HOTKEY.List[HOTKEY.HotKeyIsEdit.NameHotKey].keys = HOTKEY.HotKeyIsEdit.ActiveKeys
						end
					else
						table.insert(HOTKEY.List[HOTKEY.HotKeyIsEdit.NameHotKey].keys, key)
						HOTKEY.ReturnHotKeys = HOTKEY.HotKeyIsEdit.NameHotKey
						HOTKEY.HotKeyIsEdit = nil
					end
				end
			end
			consumeWindowMessage(true, true)
		end
	elseif msg == 0x101 or msg == 261 then
		if keyIsSpecial(key) then
			local pizdec = HOTKEY.HotKeyIsEdit ~= nil and HOTKEY.HotKeyIsEdit.ActiveKeys or HOTKEY.ActiveKeys
			for k, v in ipairs(pizdec) do
				if v == key then
					table.remove(pizdec, k)
					break
				end
			end
		end
	end
end)

return HOTKEY