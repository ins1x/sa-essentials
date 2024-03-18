--   The MIT License (MIT)
  
--   Copyright (c) 2021-2022 Dalerank
  
--   Permission is hereby granted, free of charge, to any person obtaining a copy
--   of this software and associated documentation files (the "Software"), to deal
--   in the Software without restriction, including without limitation the rights
--   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--   copies of the Software, and to permit persons to whom the Software is
--   furnished to do so, subject to the following conditions:
  
--   The above copyright notice and this permission notice shall be included in all
--   copies or substantial portions of the Software.
  
--   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--   SOFTWARE.

--   mimgui adaptation: Heroku

local imgui = require("mimgui")

local spinner = {}

function spinner.Rainbow(pos, size, num_segments, label, radius, thickness, color, speed, ang_min, ang_max)
    local start = math.abs(imgui.GetTime() * 1.8) * (num_segments - 5)
    local a_min = math.max(ang_min, math.pi * 2.0 * start / num_segments)
    local a_max = math.min(ang_max, math.pi * 2.0 * (num_segments - 3) / num_segments)

    local window = imgui.GetWindowDrawList()

    for i = 0, num_segments do
        local a = a_min + (i / num_segments) * (a_max - a_min)

    end
end

return spinner