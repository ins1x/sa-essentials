--[[
   Author: DonHomka
   E-mail: a.skinfy@gmail.com
   VK: http://vk.com/DonHomka
   TeleGramm: http://t.me/DonHomka
   Discord: DonHomka#2534
]]
local imgui = require 'imgui'
local vkeys = require 'vkeys'
local wm = require 'lib.windows.message'

local module = {}
module._VERSION = "1.0.0"
module._SETTINGS = {
    noKeysMessage = "No"
}

-- Spinner:
module.Spinner = function(label, radius, thickness, color)
    local style = imgui.GetStyle()
    local pos = imgui.GetCursorScreenPos()
    local size = imgui.ImVec2(radius * 2, (radius + style.FramePadding.y) * 2)
    
    imgui.Dummy(imgui.ImVec2(size.x + style.ItemSpacing.x, size.y))

    local DrawList = imgui.GetWindowDrawList()
    DrawList:PathClear()
    
    local num_segments = 30
    local start = math.abs(math.sin(imgui.GetTime() * 1.8) * (num_segments - 5))
    
    local a_min = 3.14 * 2.0 * start / num_segments
    local a_max = 3.14 * 2.0 * (num_segments - 3) / num_segments

    local centre = imgui.ImVec2(pos.x + radius, pos.y + radius + style.FramePadding.y)
    
    for i = 0, num_segments do
        local a = a_min + (i / num_segments) * (a_max - a_min)
        DrawList:PathLineTo(imgui.ImVec2(centre.x + math.cos(a + imgui.GetTime() * 8) * radius, centre.y + math.sin(a + imgui.GetTime() * 8) * radius))
    end

    DrawList:PathStroke(color, false, thickness)
    return true
end

-- BufferingBar:
module.BufferingBar = function(label, value, size_arg, bg_col, fg_col)
    local style = imgui.GetStyle()
    local size = size_arg;

    local DrawList = imgui.GetWindowDrawList()
    size.x = size.x - (style.FramePadding.x * 2);

    local pos = imgui.GetCursorScreenPos()

    imgui.Dummy(imgui.ImVec2(size.x, size.y))
    
    local circleStart = size.x * 0.85;
    local circleEnd = size.x;
    local circleWidth = circleEnd - circleStart;
    
    DrawList:AddRectFilled(pos, imgui.ImVec2(pos.x + circleStart, pos.y + size.y), bg_col)
    DrawList:AddRectFilled(pos, imgui.ImVec2(pos.x + circleStart * value, pos.y + size.y), fg_col)
    
    local t = imgui.GetTime()
    local r = size.y / 2;
    local speed = 1.5;
    
    local a = speed * 0;
    local b = speed * 0.333;
    local c = speed * 0.666;

    local o1 = (circleWidth+r) * (t+a - speed * math.floor((t+a) / speed)) / speed;
    local o2 = (circleWidth+r) * (t+b - speed * math.floor((t+b) / speed)) / speed;
    local o3 = (circleWidth+r) * (t+c - speed * math.floor((t+c) / speed)) / speed;
    
    DrawList:AddCircleFilled(imgui.ImVec2(pos.x + circleEnd - o1, pos.y + r), r, bg_col);
    DrawList:AddCircleFilled(imgui.ImVec2(pos.x + circleEnd - o2, pos.y + r), r, bg_col);
    DrawList:AddCircleFilled(imgui.ImVec2(pos.x + circleEnd - o3, pos.y + r), r, bg_col);
    return true
end

-- HotKey:
local tBlockKeys = {[vkeys.VK_RETURN] = true, [vkeys.VK_T] = true, [vkeys.VK_F6] = true, [vkeys.VK_F8] = true}
local tBlockChar = {[116] = true, [84] = true}
local tModKeys = {[vkeys.VK_MENU] = true, [vkeys.VK_SHIFT] = true, [vkeys.VK_CONTROL] = true}
local tBlockNextDown = {}

local tHotKeyData = {
    edit = nil,
	save = {},
   lastTick = os.clock(),
   tickState = false
}
local tKeys = {}

module.HotKey = function(name, keys, lastkeys, width)
    local width = width or 90
    local name = tostring(name)
    local lastkeys = lastkeys or {}
    local keys, bool = keys or {}, false
    lastkeys.v = keys.v

    local sKeys = table.concat(module.getKeysName(keys.v), " + ")

    if #tHotKeyData.save > 0 and tostring(tHotKeyData.save[1]) == name then
        keys.v = tHotKeyData.save[2]
        sKeys = table.concat(module.getKeysName(keys.v), " + ")
        tHotKeyData.save = {}
        bool = true
    elseif tHotKeyData.edit ~= nil and tostring(tHotKeyData.edit) == name then
		if #tKeys == 0 then
			if os.clock() - tHotKeyData.lastTick > 0.5 then
            tHotKeyData.lastTick = os.clock()
            tHotKeyData.tickState = not tHotKeyData.tickState
         end
         sKeys = tHotKeyData.tickState and module._SETTINGS.noKeysMessage or " "
        else
            sKeys = table.concat(module.getKeysName(tKeys), " + ")
        end
    end

    imgui.PushStyleColor(imgui.Col.Button, imgui.GetStyle().Colors[imgui.Col.FrameBg])
    imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.GetStyle().Colors[imgui.Col.FrameBgHovered])
    imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.GetStyle().Colors[imgui.Col.FrameBgActive])
    if imgui.Button((tostring(sKeys):len() == 0 and module._SETTINGS.noKeysMessage or sKeys) .. name, imgui.ImVec2(width, 0)) then
        tHotKeyData.edit = name
    end
    imgui.PopStyleColor(3)
    return bool
end

function module.getCurrentEdit()
    return tHotKeyData.edit ~= nil
end

function module.getKeysList(bool)
   local bool = bool or false
   local tKeysList = {}
   if bool then
      for k, v in ipairs(tKeys) do
         tKeysList[k] = vkeys.id_to_name(v)
      end
   else
      tKeysList = tKeys
   end
   return tKeysList
end

function module.getKeysName(keys)
    if type(keys) ~= "table" then
       return false
    else
       local tKeysName = {}
       for k, v in ipairs(keys) do
          tKeysName[k] = vkeys.id_to_name(v)
       end
       return tKeysName
    end
 end

local function getKeyNumber(id)
   for k, v in ipairs(tKeys) do
      if v == id then
         return k
      end
   end
   return -1
end

local function reloadKeysList()
    local tNewKeys = {}
    for k, v in pairs(tKeys) do
       tNewKeys[#tNewKeys + 1] = v
    end
    tKeys = tNewKeys
    return true
 end

-- Toggle Button:
module.ToggleButton = function(str_id, bool)
	local rBool = false

	if LastActiveTime == nil then
		LastActiveTime = {}
	end
	if LastActive == nil then
		LastActive = {}
	end

	local function ImSaturate(f)
		return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
	end
	
	local p = imgui.GetCursorScreenPos()
	local draw_list = imgui.GetWindowDrawList()

	local height = imgui.GetTextLineHeightWithSpacing()
	local width = height * 1.55
	local radius = height * 0.50
	local ANIM_SPEED = 0.15

	if imgui.InvisibleButton(str_id, imgui.ImVec2(width, height)) then
		bool.v = not bool.v
		rBool = true
		LastActiveTime[tostring(str_id)] = os.clock()
		LastActive[tostring(str_id)] = true
	end

	local t = bool.v and 1.0 or 0.0

	if LastActive[tostring(str_id)] then
		local time = os.clock() - LastActiveTime[tostring(str_id)]
		if time <= ANIM_SPEED then
			local t_anim = ImSaturate(time / ANIM_SPEED)
			t = bool.v and t_anim or 1.0 - t_anim
		else
			LastActive[tostring(str_id)] = false
		end
	end

	local col_bg
	if bool.v then
		col_bg = imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.FrameBgHovered])
	else
		col_bg = imgui.ImColor(100, 100, 100, 180):GetU32()
	end

	draw_list:AddRectFilled(imgui.ImVec2(p.x, p.y + (height / 6)), imgui.ImVec2(p.x + width - 1.0, p.y + (height - (height / 6))), col_bg, 5.0)
	draw_list:AddCircleFilled(imgui.ImVec2(p.x + radius + t * (width - radius * 2.0), p.y + radius), radius - 0.75, imgui.GetColorU32(bool.v and imgui.GetStyle().Colors[imgui.Col.ButtonActive] or imgui.ImColor(150, 150, 150, 255):GetVec4()))

	return rBool
end

function module.isKeyModified(id)
if type(id) ~= "number" then
   return false
end
return (tModKeys[id] or false) or (tBlockKeys[id] or false)
end

addEventHandler("onWindowMessage", function (msg, wparam, lparam)
    if tHotKeyData.edit ~= nil and msg == wm.WM_CHAR then
        if tBlockChar[wparam] then
            consumeWindowMessage(true, true)
        end
    end
    if msg == wm.WM_KEYDOWN or msg == wm.WM_SYSKEYDOWN then
        if tHotKeyData.edit ~= nil and wparam == vkeys.VK_ESCAPE then
            tKeys = {}
            tHotKeyData.edit = nil
            consumeWindowMessage(true, true)
        end
        if tHotKeyData.edit ~= nil and wparam == vkeys.VK_BACK then
            tHotKeyData.save = {tHotKeyData.edit, {}}
            tHotKeyData.edit = nil
            consumeWindowMessage(true, true)
        end
        local num = getKeyNumber(wparam)
        if num == -1 then
            tKeys[#tKeys + 1] = wparam
            if tHotKeyData.edit ~= nil then
                if not module.isKeyModified(wparam) then
                    tHotKeyData.save = {tHotKeyData.edit, tKeys}
                    tHotKeyData.edit = nil
                    tKeys = {}
                    consumeWindowMessage(true, true)
                end
            end
        end
        reloadKeysList()
        if tHotKeyData.edit ~= nil then
            consumeWindowMessage(true, true)
        end
    elseif msg == wm.WM_KEYUP or msg == wm.WM_SYSKEYUP then
        local num = getKeyNumber(wparam)
        if num > -1 then
            tKeys[num] = nil
        end
        reloadKeysList()
        if tHotKeyData.edit ~= nil then
            consumeWindowMessage(true, true)
        end
    end
end)

return module