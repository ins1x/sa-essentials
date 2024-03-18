local imgui = require 'mimgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local fa = require("fAwesome5")
imgui.OnInitialize(function()
    local config = imgui.ImFontConfig()
    config.MergeMode = true
    local glyph_ranges = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
    local iconRanges = imgui.new.ImWchar[3](fa.min_range, fa.max_range, 0)
    imgui.GetIO().Fonts:AddFontFromFileTTF('trebucbd.ttf', 14.0, nil, glyph_ranges)
    icon = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 14.0, config, iconRanges)
end)

local COLORS = {
    [0] = {back = {0.26, 0.71, 0.81, 1},    text = {1, 1, 1, 1}, icon = {1, 1, 1, 1}, border = {1, 0, 0, 0}},--{back = imgui.ImVec4(0.1, 0.13, 0.17, 1), text = imgui.ImVec4(1, 1, 1, 1), icon = imgui.ImVec4(1, 0, 0.3, 1), border = imgui.ImVec4(1, 0, 0.3, 1)},
    [1] = {back = {0.26, 0.81, 0.31, 1},    text = {1, 1, 1, 1}, icon = {1, 1, 1, 1}, border = {1, 0, 0, 0}},
    [2] = {back = {1, 0.39, 0.39, 1},       text = {1, 1, 1, 1}, icon = {1, 1, 1, 1}, border = {1, 0, 0, 0}},
    [3] = {back = {0.97, 0.57, 0.28, 1},    text = {1, 1, 1, 1}, icon = {1, 1, 1, 1}, border = {1, 0, 0, 0}},
    [4] = {back = {0, 0, 0, 1},             text = {1, 1, 1, 1}, icon = {1, 1, 1, 1}, border = {1, 0, 0, 0}},
}


local list = {}
EXPORTS = {
    __version = '0.1',
    TYPE = {
        INFO = 0,
        OK = 1,
        ERROR = 2,
        WARN = 3,
        DEBUG = 4
    },
    ICON = {
        [0] = fa.ICON_FA_INFO_CIRCLE,
        [1] = fa.ICON_FA_CHECK,
        [2] = fa.ICON_FA_TIMES,
        [3] = fa.ICON_FA_EXCLAMATION,
        [4] = fa.ICON_FA_WRENCH
    },
    Show = function(text, type, time, colors)
        table.insert(list, {
            text = text,
            type = type or 2,
            time = time or 4,
            start = os.clock(),
            alpha = 0,
            colors = colors or COLORS[type]
        })
    end
}

local newFrame = imgui.OnFrame(
    function() return #list > 0 end,
    function(self)
        self.HideCursor = true
        local resX, resY = getScreenResolution()
        local sizeX, sizeY = 300, 300
        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY), imgui.Cond.FirstUseEver)
        imgui.Begin('notf_window', _, 0
            + imgui.WindowFlags.AlwaysAutoResize
            + imgui.WindowFlags.NoTitleBar
            + imgui.WindowFlags.NoResize
            + imgui.WindowFlags.NoMove
            + imgui.WindowFlags.NoBackground
        )
        
        local winSize = imgui.GetWindowSize()
        imgui.SetWindowPosVec2(imgui.ImVec2(resX - 10 - winSize.x, 50))
        
        for k, data in ipairs(list) do
            ------------------------------------------------
            local default_data = {
                text = 'text',
                type = 0,
                time = 1500
            }
            for k, v in pairs(default_data) do
                if data[k] == nil then
                    data[k] = v
                end
            end
        
        
            local c = imgui.GetCursorPos()
            local p = imgui.GetCursorScreenPos()
            local DL = imgui.GetWindowDrawList()
        
            local textSize = imgui.CalcTextSize(data.text)
            local iconSize = imgui.CalcTextSize(EXPORTS.ICON[data.type] or fa.ICON_FA_TIMES)
            local size = imgui.ImVec2(5 + iconSize.x + 5 + textSize.x + 5, 5 + textSize.y + 5)
        
        
            local winSize = imgui.GetWindowSize()
            if winSize.x > size.x + 20 then
                imgui.SetCursorPosX(winSize.x - size.x - 8)
            end
        
            
            imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, data.alpha)--bringFloatTo(1, 0, data.start + data.time / 5, data.time / 5) or 1)
            imgui.PushStyleVarFloat(imgui.StyleVar.ChildRounding, 5)
            imgui.PushStyleColor(imgui.Col.ChildBg,     tableToImVec(data.colors.back or COLORS[data.type].back))
            imgui.PushStyleColor(imgui.Col.Border,      tableToImVec(data.colors.border or COLORS[data.type].border))
            imgui.BeginChild('toastNotf:'..tostring(k)..tostring(data.text), size, true, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)
                imgui.PushStyleColor(imgui.Col.Text,    tableToImVec(data.colors.icon or COLORS[data.type].icon))
                imgui.SetCursorPos(imgui.ImVec2(5, size.y / 2 - iconSize.y / 2))
                imgui.Text(EXPORTS.ICON[data.type] or fa.ICON_FA_TIMES)
                imgui.PopStyleColor()

                imgui.PushStyleColor(imgui.Col.Text,    tableToImVec(data.colors.text or COLORS[data.type].text))
                imgui.SetCursorPos(imgui.ImVec2(5 + iconSize.x + 5, size.y / 2 - textSize.y / 2))
                imgui.Text(data.text)
                imgui.PopStyleColor()
            imgui.EndChild()
            imgui.PopStyleColor()
            imgui.PopStyleVar(2)
            ------------------------------------------------
        end
        
        imgui.End()
    end
)

function tableToImVec(tbl)
    return imgui.ImVec4(tbl[1], tbl[2], tbl[3], tbl[4])
end

function bringFloatTo(from, to, start_time, duration)
    local timer = os.clock() - start_time
    if timer >= 0.00 and timer <= duration then
        local count = timer / (duration / 100)
        return from + (count * (to - from) / 100), true
    end
    return (timer > duration) and to or from, false
end

local DEBUG = false

function main()
    if DEBUG then
        for k, v in pairs(EXPORTS.TYPE) do
            EXPORTS.Show('Toast Notification\nType: '..k..' ('..tostring(v)..')', v, 5000)
        end
    end
    while true do
        wait(0)
        for k, data in ipairs(list) do
            --==[ UPDATE ALPHA ]==--
            if data.alpha == nil then list[k].alpha = 0 end
            if os.clock() - data.start < 0.5 then
                list[k].alpha = bringFloatTo(0, 1, data.start, 0.5)
            elseif data.time - 0.5 < os.clock() - data.start then
                list[k].alpha = bringFloatTo(1, 0, data.start + data.time - 0.5, 0.5)
            end

            --==[ REMOVE ]==--
            if os.clock() - data.start > data.time then
                table.remove(list, k)
            end
        end
    end
end
