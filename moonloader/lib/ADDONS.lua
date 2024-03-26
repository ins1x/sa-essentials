local imgui = require 'mimgui'
local ffi = require 'ffi'

-- \\ ИНФОРМАЦИЯ:
local M = {}
setmetatable(M, {
	__index = function(self, index)
		if index == '_AUTHOR' then
			return 'Cosmo'
		elseif index == '_VERSION' then
			return '1.0'
		end
	end
})

-- \\ Пулы:
local AI_HINTS = {}
local AI_MATERIAL = {}
local AI_ANIMBUT = {}
local AI_TOGGLE = {}
local AI_PICTURE = {}
local AI_HEADERBUT = {}
local AI_PAGE = {}

-- \\ ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ:
local ToU32 = imgui.ColorConvertFloat4ToU32
local ToVEC = imgui.ColorConvertU32ToFloat4

function limit(v, min, max) -- Ограничение динамического значения
	min = min or 0.0
	max = max or 1.0
	return v < min and min or (v > max and max or v)
end

function bringVec4To(from, to, start_time, duration)
    local timer = os.clock() - start_time
    if timer >= 0.00 and timer <= duration then
        local count = timer / (duration / 100)
        return imgui.ImVec4(
            from.x + (count * (to.x - from.x) / 100),
            from.y + (count * (to.y - from.y) / 100),
            from.z + (count * (to.z - from.z) / 100),
            from.w + (count * (to.w - from.w) / 100)
        ), true
    end
    return (timer > duration) and to or from, false
end

function bringVec2To(from, to, start_time, duration)
    local timer = os.clock() - start_time
    if timer >= 0.00 and timer <= duration then
        local count = timer / (duration / 100)
        return imgui.ImVec2(
            from.x + (count * (to.x - from.x) / 100),
            from.y + (count * (to.y - from.y) / 100)
        ), true
    end
    return (timer > duration) and to or from, false
end

function bringFloatTo(from, to, start_time, duration)
    local timer = os.clock() - start_time
    if timer >= 0.00 and timer <= duration then
        local count = timer / (duration / 100)
        return from + (count * (to - from) / 100), true
    end
    return (timer > duration) and to or from, false
end

function isPlaceHovered(a, b) -- Проверка находится ли курсор в указанной области
	local m = imgui.GetMousePos()
	if m.x >= a.x and m.y >= a.y then
		if m.x <= b.x and m.y <= b.y then
			return true
		end
	end
	return false
end

function getContrastColor(bg_col, col_1, col_2) -- Получение цвета текста в зависимости от фона
	col_1 = col_1 or imgui.ImVec4(0.00, 0.00, 0.00, 1.00)
	col_2 = col_2 or imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
    local luminance = 1 - (0.299 * bg_col.x + 0.587 * bg_col.y + 0.114 * bg_col.z)
    return luminance < 0.5 and col_1 or col_2
end

function set_alpha(color, alpha) -- Получение цвета с определённой прозрачностью
	alpha = alpha and limit(alpha, 0.0, 1.0) or 1.0
	return imgui.ImVec4(color.x, color.y, color.z, alpha)
end

M.limit = limit
M.bringVec4To = bringVec4To
M.bringVec2To = bringVec2To
M.bringFloatTo = bringFloatTo
M.isPlaceHovered = isPlaceHovered
M.getContrastColor = getContrastColor
M.set_alpha = set_alpha

-- \\ ЭЛЕМЕНТЫ:
M.MaterialButton = function(str_id, size, duration)
	if type(duration) ~= 'table' then
		duration = { 0.4, 0.2, 0.4 }
	end  
	local cols = {
		default = imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.Button]),
		hovered = imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.ButtonHovered]),
		active  = imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.ButtonActive]),
		window  = imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.WindowBg])
	}

	local result = false
	local rounding = imgui.GetStyle().FrameRounding
	local label = string.gsub(str_id, "##.*$", "")
	local text_size = imgui.CalcTextSize(label)
	if not size then
		local pad = imgui.GetStyle().FramePadding
		size = imgui.ImVec2(text_size.x + (pad.x * 2), text_size.y + (pad.y * 2))
	end

	if not AI_MATERIAL[str_id] then
		AI_MATERIAL[str_id] = {
			hovered = {
				state = false,
				before = nil,
				clock = 0,
				color = cols.hovered
			},
			radius = 0,
			clock = {0, 0},
			pos = nil,
			size = nil
		}
	end

	local pool = AI_MATERIAL[str_id]
    local p = imgui.GetCursorScreenPos()
	if pool['size'] ~= nil then
		local DL = imgui.GetWindowDrawList()
		local s = pool['size']

		if os.clock() - pool['hovered']['clock'] <= duration[3] then
			local start_time = pool['hovered']['clock']
			if pool['hovered']['state'] then
				pool['hovered']['color'] = bringVec4To(pool['hovered']['color'], cols.active, start_time, duration[3])
			else
				pool['hovered']['color'] = bringVec4To(pool['hovered']['color'], cols.hovered, start_time, duration[3])
			end
		elseif pool['hovered']['state'] then
			pool['hovered']['color'] = cols.active
		end

		DL:AddRect(
			p,
			imgui.ImVec2(p.x + s.x, p.y + s.y),
			ToU32(pool['hovered']['color']),
			rounding,
			15
		)
	end

	imgui.PushStyleVarFloat(imgui.StyleVar.ChildRounding, rounding)
	imgui.PushStyleColor(imgui.Col.ChildBg, cols.default)
	local pos = imgui.GetCursorPos()
	imgui.SetCursorPos(imgui.ImVec2(pos.x + 1, pos.y + 1))
	imgui.BeginChild(str_id .. "_ANIMBUTTON", imgui.ImVec2(size.x - 2, size.y - 2), false)
		local DL = imgui.GetWindowDrawList()
		if pool['pos'] ~= nil then
			local alpha = 0.00

			local timer = os.clock() - pool['clock'][2]
			if timer <= duration[2] then
				alpha = limit(1.00 - ((1.00 / duration[2]) * timer), 0.0, 1.0)
			end

			local timer = os.clock() - pool['clock'][1]
			if timer <= duration[1] then
				alpha = limit((1.00 / duration[1]) * timer, 0.0, 1.0)
				pool['radius'] = (size.x * 1.5 / duration[1]) * timer
			end

			local col = imgui.GetStyle().Colors[imgui.Col.ButtonActive]
			DL:AddCircleFilled(
				pool['pos'], 
				pool['radius'], 
				ToU32(imgui.ImVec4(col.x, col.y, col.z, alpha)), 
				64
			)

			local a, b = p, imgui.ImVec2(p.x + pool['size'].x, p.y + pool['size'].y)
			local color = ToU32(cols.window)

	        DL:PathLineTo(a)
	        DL:PathArcTo(imgui.ImVec2(a.x + rounding, a.y + rounding), rounding, -3.0, -1.500)
	        DL:PathFillConvex(color)

	        DL:PathLineTo(imgui.ImVec2(b.x, a.y))
	        DL:PathArcTo(imgui.ImVec2(b.x - rounding, a.y + rounding), rounding, -1.5, -0.205)
	        DL:PathFillConvex(color)

	        DL:PathLineTo(imgui.ImVec2(b.x, b.y))
	        DL:PathArcTo(imgui.ImVec2(b.x - rounding, b.y - rounding), rounding,  1.5,  0.205)
	        DL:PathFillConvex(color)

	        DL:PathLineTo(imgui.ImVec2(a.x, b.y))
	        DL:PathArcTo(imgui.ImVec2(a.x + rounding, b.y - rounding), rounding,  3.0,  1.500)
	        DL:PathFillConvex(color)

			if alpha <= 0 then pool['pos'] = nil end
		end

		local ws, al = imgui.GetWindowSize(), imgui.GetStyle().ButtonTextAlign
		imgui.SetCursorPos(imgui.ImVec2((ws.x - text_size.x) * al.x, (ws.y - text_size.y) * al.y))
		imgui.TextUnformatted(label)
	imgui.EndChild()
	imgui.PopStyleColor()
	imgui.PopStyleVar()

	local size = imgui.GetItemRectSize()
	pool['size'] = imgui.ImVec2(size.x + 2, size.y + 2)
	pool['hovered']['state'] = imgui.IsItemHovered() or os.clock() - pool['clock'][2] < 0
	if pool['hovered']['state'] ~= pool['hovered']['before'] then
		pool['hovered']['before'] = pool['hovered']['state']
		pool['hovered']['clock'] = os.clock()
	end

	if imgui.IsItemClicked() then
		pool['radius'] = 0
		pool['pos'] = imgui.GetMousePos()
		pool['clock'] = {
			os.clock(),
			os.clock() + duration[1]
		}
		result = true
	end

	return result
end

M.AnimButton = function(label, size, duration)
    if type(duration) ~= 'table' then
		duration = { 1.0, 0.3 }
	end

    local cols = {
        default = imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.Button]),
        hovered = imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.ButtonHovered]),
        active  = imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.ButtonActive])
    }

    if not AI_ANIMBUT[label] then
        AI_ANIMBUT[label] = {
            color = cols.default,
            clicked = { nil, nil },
            hovered = {
                cur = false,
                old = false,
                clock = nil,
            }
        }
    end
    local pool = AI_ANIMBUT[label]

    if pool['clicked'][1] and pool['clicked'][2] then
        if os.clock() - pool['clicked'][1] <= duration[2] then
            pool['color'] = bringVec4To(
                pool['color'],
                cols.active,
                pool['clicked'][1],
                duration[2]
            )
            goto no_hovered
        end

        if os.clock() - pool['clicked'][2] <= duration[2] then
            pool['color'] = bringVec4To(
                pool['color'],
                pool['hovered']['cur'] and cols.hovered or cols.default,
                pool['clicked'][2],
                duration[2]
            )
            goto no_hovered
        end
    end

    if pool['hovered']['clock'] ~= nil then
        if os.clock() - pool['hovered']['clock'] <= duration[1] then
            pool['color'] = bringVec4To(
                pool['color'],
                pool['hovered']['cur'] and cols.hovered or cols.default,
                pool['hovered']['clock'],
                duration[1]
            )
        else
            pool['color'] = pool['hovered']['cur'] and cols.hovered or cols.default
        end
    end

    ::no_hovered::

    imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(pool['color']))
    imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(pool['color']))
    imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(pool['color']))
    local result = imgui.Button(label, size or imgui.ImVec2(0, 0))
    imgui.PopStyleColor(3)

    if result then
        pool['clicked'] = {
            os.clock(),
            os.clock() + duration[2]
        }
    end

    pool['hovered']['cur'] = imgui.IsItemHovered()
    if pool['hovered']['old'] ~= pool['hovered']['cur'] then
        pool['hovered']['old'] = pool['hovered']['cur']
        pool['hovered']['clock'] = os.clock()
    end

    return result
end

M.CloseButton = function(str_id, value, size, rounding)
	size = size or 40
	rounding = rounding or 5
	local DL = imgui.GetWindowDrawList()
	local p = imgui.GetCursorScreenPos()
	
	local result = imgui.InvisibleButton(str_id, imgui.ImVec2(size, size))
	if result then
		value[0] = false
	end
	local hovered = imgui.IsItemHovered()

	local col = ToU32(imgui.GetStyle().Colors[imgui.Col.Border])
	local col_bg = hovered and 0x50000000 or 0x30000000
	local offs = (size / 4)

	DL:AddRectFilled(p, imgui.ImVec2(p.x + size, p.y + size), col_bg, rounding, 15)
	DL:AddLine(
		imgui.ImVec2(p.x + offs, p.y + offs), 
		imgui.ImVec2(p.x + size - offs, p.y + size - offs), 
		col,
		size / 10
	)
	DL:AddLine(
		imgui.ImVec2(p.x + size - offs, p.y + offs), 
		imgui.ImVec2(p.x + offs, p.y + size - offs),
		col,
		size / 10
	)
	return result
end

M.Hint = function(str_id, hint_text, color, no_center)
	color = color or imgui.GetStyle().Colors[imgui.Col.PopupBg]
	local p_orig = imgui.GetCursorPos()
	local hovered = imgui.IsItemHovered()
	imgui.SameLine(nil, 0)

	local duration = 0.2
	local show = true

	if not AI_HINTS[str_id] then
		AI_HINTS[str_id] = {
			status = false,
			timer = 0
		}
	end
	local pool = AI_HINTS[str_id]

	if hovered then
		for k, v in pairs(AI_HINTS) do
			if k ~= str_id and os.clock() - v.timer <= duration  then
				show = false
			end
		end
	end

	if show and pool.status ~= hovered then
		pool.status = hovered
		pool.timer = os.clock()
	end

	local rend_window = function(alpha)
		local size = imgui.GetItemRectSize()
		local scrPos = imgui.GetCursorScreenPos()
		local DL = imgui.GetWindowDrawList()
		local center = imgui.ImVec2( scrPos.x - (size.x / 2), scrPos.y + (size.y / 2) - (alpha * 4) + 10 )
		local a = imgui.ImVec2( center.x - 7, center.y - size.y - 3 )
		local b = imgui.ImVec2( center.x + 7, center.y - size.y - 3)
		local c = imgui.ImVec2( center.x, center.y - size.y + 3 )
		local col = ToU32(imgui.ImVec4(color.x, color.y, color.z, alpha))

		DL:AddTriangleFilled(a, b, c, col)
		imgui.SetNextWindowPos(imgui.ImVec2(center.x, center.y - size.y - 3), imgui.Cond.Always, imgui.ImVec2(0.5, 1.0))
		imgui.PushStyleColor(imgui.Col.PopupBg, color)
		imgui.PushStyleColor(imgui.Col.Border, color)
		imgui.PushStyleColor(imgui.Col.Text, getContrastColor(color))
		imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
		imgui.PushStyleVarFloat(imgui.StyleVar.WindowRounding, 6)
		imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, alpha)

		local max_width = function(text)
			local result = 0
			for line in text:gmatch('[^\r\n]+') do
				local len = imgui.CalcTextSize(line).x
				if len > result then
					result = len
				end
			end
			return result
		end

		local hint_width = max_width(hint_text) + (imgui.GetStyle().WindowPadding.x * 2)
		imgui.SetNextWindowSize(imgui.ImVec2(hint_width, -1), imgui.Cond.Always)
		imgui.Begin('##' .. str_id, _, imgui.WindowFlags.Tooltip + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoTitleBar)
			for line in hint_text:gmatch('[^\r\n]+') do
				if no_center then
					imgui.Text(line)
				else
					imgui.SetCursorPosX((hint_width - imgui.CalcTextSize(line).x) / 2)
					imgui.Text(line)
				end
			end
		imgui.End()

		imgui.PopStyleVar(3)
		imgui.PopStyleColor(3)
	end

	if show then
		local between = os.clock() - pool.timer
		if between <= duration then
			local alpha = hovered and limit(between / duration, 0.0, 1.0) or limit(1.00 - between / duration, 0.0, 1.0)
			rend_window(alpha)
		elseif hovered then
			rend_window(1.00)
		end
	end

	imgui.SetCursorPos(p_orig)
end

M.AlignedText = function(text, align, color)
	color = color or imgui.GetStyle().Colors[imgui.Col.Text]
	local width = imgui.GetWindowWidth()
	for line in text:gmatch('[^\n]+') do
		local lenght = imgui.CalcTextSize(line).x
		if align == 2 then
			imgui.SetCursorPosX((width - lenght) / 2)
		elseif align == 3 then
			imgui.SetCursorPosX(width - lenght - imgui.GetStyle().WindowPadding.x)
		end
		imgui.TextColored(color, line)
	end
end

M.BeginTitleChild = function(str_id, size, thickness, flags)
	thickness = thickness or 1
    local DL = imgui.GetWindowDrawList()
    local title = str_id:gsub('##.*$', '')
    local ts = imgui.CalcTextSize(title)
    local bgColor = ToU32(imgui.GetStyle().Colors[imgui.Col.WindowBg])
    local bdColor = ToU32(imgui.GetStyle().Colors[imgui.Col.Border])
    local rounding = imgui.GetStyle().ChildRounding
    local spacing = 5
    
    local pos = imgui.GetCursorPos()
    local wsize = imgui.GetWindowSize()
    local padding = imgui.GetStyle().WindowPadding
    if size.x == -1 then
    	size.x = wsize.x - pos.x - padding.x * 2
    end
    if size.y == -1 then
    	size.y = wsize.y - pos.y - padding.y * 2
    end

    local offset = (size.x - ts.x) / 10
    imgui.SetCursorPosY(pos.y + (ts.y / 2))
    local p = imgui.GetCursorScreenPos()
    DL:AddRect(p, imgui.ImVec2(p.x + size.x, p.y + size.y), bdColor, rounding, 15, thickness)
    DL:AddLine(imgui.ImVec2(p.x + offset, p.y), imgui.ImVec2(p.x + offset + ts.x + (spacing * 2), p.y), bgColor, thickness * 3)
    DL:AddText(imgui.ImVec2(p.x + offset + spacing, p.y - (ts.y / 2)), bdColor, title)

    imgui.PushStyleColor(imgui.Col.ChildBg, imgui.ImVec4(0, 0, 0, 0))
    imgui.PushStyleColor(imgui.Col.Border, imgui.ImVec4(0, 0, 0, 0))
    imgui.BeginChild(str_id, size, true, flags)
    imgui.SetCursorPosY(imgui.GetCursorPos().y + (ts.y / 2))
end

M.EndTitleChild = function()
	imgui.EndChild()
	imgui.PopStyleColor(2)
end

M.CircularProgressBar = function(value, radius, thickness, format)
	local DL = imgui.GetWindowDrawList()
	local p = imgui.GetCursorScreenPos()
	local pos = imgui.GetCursorPos()
	local ts = nil

	if type(format) == 'string' then
		format = string.format(format, value[0])
		ts = imgui.CalcTextSize(format)
	end

	local side = imgui.ImVec2(
		radius * 2 + thickness,
		radius * 2 + thickness + (ts and (ts.y + imgui.GetStyle().ItemSpacing.y) or 0)
	)
	local centre = imgui.ImVec2(p.x + radius + (thickness / 2), p.y + radius + (thickness / 2))

    imgui.BeginGroup()
		imgui.Dummy(side)

		local corners = radius * 5
	    local col_bg = ToU32(imgui.GetStyle().Colors[imgui.Col.FrameBg])
	    local col = ToU32(imgui.GetStyle().Colors[imgui.Col.ButtonActive])
	    local a1 = 90 - (360 / 100) * (value[0] / 2)
		local a2 = 90 + (360 / 100) * (value[0] / 2)

	    DL:AddCircle(centre, radius, col_bg, corners, thickness / 2)
		DL:PathClear()
        DL:PathArcTo(centre, radius, math.rad(a1), math.rad(a2), corners)
		DL:PathStroke(col, 0, thickness)

	    if format ~= nil then
	    	imgui.SetCursorPos(
	    		imgui.ImVec2(
	    			pos.x + (side.x - ts.x) / 2,
	    			pos.y + radius * 2 + thickness + imgui.GetStyle().FramePadding.y
	    		)
	    	)
	    	imgui.Text(format)
	    end
	imgui.EndGroup()
end

M.ToggleButton = function(str_id, value)
	local duration = 0.3
	local p = imgui.GetCursorScreenPos()
    local DL = imgui.GetWindowDrawList()
	local size = imgui.ImVec2(40, 20)
    local title = str_id:gsub('##.*$', '')
    local ts = imgui.CalcTextSize(title)
    local cols = {
    	enable = imgui.GetStyle().Colors[imgui.Col.ButtonActive],
    	disable = imgui.GetStyle().Colors[imgui.Col.TextDisabled]	
    }
    local radius = 6
    local o = {
    	x = 4,
    	y = p.y + (size.y / 2)
    }
    local A = imgui.ImVec2(p.x + radius + o.x, o.y)
    local B = imgui.ImVec2(p.x + size.x - radius - o.x, o.y)

    if AI_TOGGLE[str_id] == nil then
        AI_TOGGLE[str_id] = {
        	clock = nil,
        	color = value[0] and cols.enable or cols.disable,
        	pos = value[0] and B or A
        }
    end
    local pool = AI_TOGGLE[str_id]
    
    imgui.BeginGroup()
	    local pos = imgui.GetCursorPos()
	    local result = imgui.InvisibleButton(str_id, imgui.ImVec2(size.x, size.y))
	    if result then
	        value[0] = not value[0]
	        pool.clock = os.clock()
	    end
	    if #title > 0 then
		    local spc = imgui.GetStyle().ItemSpacing
		    imgui.SetCursorPos(imgui.ImVec2(pos.x + size.x + spc.x, pos.y + ((size.y - ts.y) / 2)))
	    	imgui.Text(title)
    	end
    imgui.EndGroup()

 	if pool.clock and os.clock() - pool.clock <= duration then
        pool.color = bringVec4To(
            imgui.ImVec4(pool.color),
            value[0] and cols.enable or cols.disable,
            pool.clock,
            duration
        )

        pool.pos = bringVec2To(
        	imgui.ImVec2(pool.pos),
        	value[0] and B or A,
        	pool.clock,
            duration
        )
    else
        pool.color = value[0] and cols.enable or cols.disable
        pool.pos = value[0] and B or A
    end

	DL:AddRect(p, imgui.ImVec2(p.x + size.x, p.y + size.y), ToU32(pool.color), 10, 15, 1)
	DL:AddCircleFilled(pool.pos, radius, ToU32(pool.color))

    return result
end

M.Picture = function(str_id, image, size, mult, hint)
	hint = hint or u8'Увеличить изображение'
	mult = mult and limit(mult, 2, 10) or 5
	local duration = { 0.3, 1.0 }
	local p = imgui.GetCursorScreenPos()
	imgui.Image(image, imgui.ImVec2(size.x / mult, size.y / mult))
	local hovered = imgui.IsItemHovered()
	local clicked = imgui.IsItemClicked(0)
	local DL = imgui.GetWindowDrawList()
	local ws, wh = getScreenResolution()
	local s = imgui.GetItemRectSize()
	local ts = imgui.CalcTextSize(hint)
	local cols = {
		bg = {
			hovr = imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg],
			idle = imgui.ImVec4(0.0, 0.0, 0.0, 0.0)
		},
		t = {
			hovr = imgui.GetStyle().Colors[imgui.Col.Text],
			idle = imgui.ImVec4(0.0, 0.0, 0.0, 0.0)
		}
	}

	if AI_PICTURE[str_id] == nil then
		AI_PICTURE[str_id] = {
			o = {
				clock = nil,
				alpha = 0
			},
			h = {
				clock = nil,
				before = false,
				bg_col = hovered and cols.bg.hovr or cols.bg.idle,
				t_col = hovered and cols.t.hovr or cols.t.idle
			}
		}
	end
	local pool = AI_PICTURE[str_id]

	if hovered ~= pool.h.before then
		pool.h.before = hovered
		pool.h.clock = os.clock()
	end

	if clicked then
		pool.o.state = true
		pool.o.clock = os.clock()
	end

	if pool.o.clock ~= nil then
		local bg_col
		if os.clock() - pool.o.clock <= duration[2] then
			local timer = (os.clock() - pool.o.clock)
			local offset = (1.0 - pool.o.alpha)
			pool.o.alpha = pool.o.alpha + ((offset / duration[2]) * timer)
			bg_col = bringVec4To(
				imgui.ImVec4(0, 0, 0, 0),
				cols.bg.hovr,
				pool.o.clock,
				duration[2]
			)
		else
			pool.o.alpha = 1.0	
			bg_col = cols.bg.hovr
		end

		local DL = imgui.GetForegroundDrawList()
		local A = imgui.ImVec2((ws - size.x) / 2, (wh - size.y) / 2)
		local B = imgui.ImVec2(A.x + size.x, A.y + size.y)

		DL:AddRectFilled(imgui.ImVec2(0, 0), imgui.ImVec2(ws, wh), ToU32(bg_col))
		DL:AddImage(image, A, B, _, _, ToU32(imgui.ImVec4(1, 1, 1, pool.o.alpha)))

		if imgui.IsMouseClicked(0) and pool.o.alpha >= 0.1 then
			pool.o.alpha = 0.0
			pool.o.clock = nil
		end	
		goto finish
	end

	if pool.h.clock ~= nil then
		if os.clock() - pool.h.clock <= duration[1] then
			pool.h.bg_col = bringVec4To(
				imgui.ImVec4(pool.h.bg_col),
				hovered and cols.bg.hovr or cols.bg.idle,
				pool.h.clock,
				duration[1]
			)
			pool.h.t_col = bringVec4To(
				imgui.ImVec4(pool.h.t_col),
				hovered and cols.t.hovr or cols.t.idle,
				pool.h.clock,
				duration[1]
			)
		else
			pool.h.bg_col = hovered and cols.bg.hovr or cols.bg.idle
			pool.h.t_col = hovered and cols.t.hovr or cols.t.idle
			if not hovered then
				pool.h.clock = nil
			end
		end
		DL:AddRectFilled(p, imgui.ImVec2(p.x + s.x, p.y + s.y), ToU32(pool.h.bg_col))
		DL:AddText(imgui.ImVec2(p.x + (s.x - ts.x) / 2, p.y + (s.y - ts.y) / 2), ToU32(pool.h.t_col), hint)
	end

	::finish::
	return clicked
end

M.PageButton = function(bool, icon, name, but_wide)
	but_wide = but_wide or 190
	local duration = 0.25
	local DL = imgui.GetWindowDrawList()
	local p1 = imgui.GetCursorScreenPos()
	local p2 = imgui.GetCursorPos()
	local col = imgui.GetStyle().Colors[imgui.Col.ButtonActive]
		
	if not AI_PAGE[name] then
		AI_PAGE[name] = { clock = nil }
	end
	local pool = AI_PAGE[name]

	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
    imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
    imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
    local result = imgui.InvisibleButton(name, imgui.ImVec2(but_wide, 35))
    if result and not bool then 
    	pool.clock = os.clock() 
    end
    local pressed = imgui.IsItemActive()
    imgui.PopStyleColor(3)
	if bool then
		if pool.clock and (os.clock() - pool.clock) < duration then
			local wide = (os.clock() - pool.clock) * (but_wide / duration)
			DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2((p1.x + 190) - wide, p1.y + 35), 0x10FFFFFF, 15, 10)
	       	DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2(p1.x + 5, p1.y + 35), ToU32(col))
			DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2(p1.x + wide, p1.y + 35), ToU32(imgui.ImVec4(col.x, col.y, col.z, 0.6)), 15, 10)
		else
			DL:AddRectFilled(imgui.ImVec2(p1.x, (pressed and p1.y + 3 or p1.y)), imgui.ImVec2(p1.x + 5, (pressed and p1.y + 32 or p1.y + 35)), ToU32(col))
			DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2(p1.x + 190, p1.y + 35), ToU32(imgui.ImVec4(col.x, col.y, col.z, 0.6)), 15, 10)
		end
	else
		if imgui.IsItemHovered() then
			DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2(p1.x + 190, p1.y + 35), 0x10FFFFFF, 15, 10)
		end
	end
	imgui.SameLine(10); imgui.SetCursorPosY(p2.y + 8)
	if bool then
		imgui.Text((' '):rep(3) .. icon)
		imgui.SameLine(60)
		imgui.Text(name)
	else
		imgui.TextColored(imgui.ImVec4(0.60, 0.60, 0.60, 1.00), (' '):rep(3) .. icon)
		imgui.SameLine(60)
		imgui.TextColored(imgui.ImVec4(0.60, 0.60, 0.60, 1.00), name)
	end
	imgui.SetCursorPosY(p2.y + 40)
	return result
end

M.StateButton = function(bool, ...)
	if bool then
		return imgui.Button(...)
	else
		local but_col = imgui.GetStyle().Colors[imgui.Col.Button]
		imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
		imgui.PushStyleColor(imgui.Col.Button, set_alpha(but_col, 0.2))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, set_alpha(but_col, 0.2))
		imgui.PushStyleColor(imgui.Col.ButtonActive, set_alpha(but_col, 0.2))
		imgui.Button(...)
		imgui.PopStyleColor(4)
	end
end

M.CheckButton = function(str_id, value, size)
	local pos = imgui.GetCursorPos()
	local p = imgui.GetCursorScreenPos()
	local DL = imgui.GetWindowDrawList()

	imgui.BeginGroup()
		
		local result = imgui.InvisibleButton(str_id, size)
		if result then
			value[0] = not value[0]
		end

		DL:AddRectFilled(p, imgui.ImVec2(p.x + size.x, p.y + size.y), 0xFFFFFFFF)

	imgui.EndGroup()
	return result
end

M.HeaderButton = function(bool, str_id)
	local DL = imgui.GetWindowDrawList()
	local result = false
	local label = string.gsub(str_id, "##.*$", "")
	local duration = { 0.5, 0.3 }
	local cols = {
        idle = imgui.GetStyle().Colors[imgui.Col.TextDisabled],
        hovr = imgui.GetStyle().Colors[imgui.Col.Text],
        slct = imgui.GetStyle().Colors[imgui.Col.ButtonActive]
    }

 	if not AI_HEADERBUT[str_id] then
        AI_HEADERBUT[str_id] = {
            color = bool and cols.slct or cols.idle,
            clock = os.clock() + duration[1],
            h = {
                state = bool,
                alpha = bool and 1.00 or 0.00,
                clock = os.clock() + duration[2],
            }
        }
    end
    local pool = AI_HEADERBUT[str_id]

	imgui.BeginGroup()
		local pos = imgui.GetCursorPos()
		local p = imgui.GetCursorScreenPos()
		
		-- Render Text
		imgui.TextColored(pool.color, label)
		local s = imgui.GetItemRectSize()
		local hovered = isPlaceHovered(p, imgui.ImVec2(p.x + s.x, p.y + s.y))
		local clicked = imgui.IsItemClicked()
		
		-- Listeners
		if pool.h.state ~= hovered and not bool then
			pool.h.state = hovered
			pool.h.clock = os.clock()
		end
		
		if clicked then
	    	pool.clock = os.clock()
	    	result = true
	    end

    	if os.clock() - pool.clock <= duration[1] then
			pool.color = bringVec4To(
				imgui.ImVec4(pool.color),
				bool and cols.slct or (hovered and cols.hovr or cols.idle),
				pool.clock,
				duration[1]
			)
		else
			pool.color = bool and cols.slct or (hovered and cols.hovr or cols.idle)
		end

		if pool.h.clock ~= nil then
			if os.clock() - pool.h.clock <= duration[2] then
				pool.h.alpha = bringFloatTo(
					pool.h.alpha,
					pool.h.state and 1.00 or 0.00,
					pool.h.clock,
					duration[2]
				)
			else
				pool.h.alpha = pool.h.state and 1.00 or 0.00
				if not pool.h.state then
					pool.h.clock = nil
				end
			end

			local max = s.x / 2
			local Y = p.y + s.y + 3
			local mid = p.x + max

			DL:AddLine(imgui.ImVec2(mid, Y), imgui.ImVec2(mid + (max * pool.h.alpha), Y), ToU32(set_alpha(pool.color, pool.h.alpha)), 3)
			DL:AddLine(imgui.ImVec2(mid, Y), imgui.ImVec2(mid - (max * pool.h.alpha), Y), ToU32(set_alpha(pool.color, pool.h.alpha)), 3)
		end

	imgui.EndGroup()
	return result
end

return M