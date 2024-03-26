require "lib.sampfuncs"
require "lib.moonloader"

local tweaks = {}

tweaks.mouseHandler = {}
function tweaks.mouseHandler:new()
  local public = {}
    public.x, public.y = 0, 0
    public.callEvent = 0

  function public:updatePosition()
    self.x, self.y = getCursorPos()
  end

  function public:isMouseInWnd(x, y, w, h)
    if self.x > x and self.x < x + w and self.y > y - 1 and self.y < y + h
    then return true end
    return false
  end

  function public:isKeyPressed(key, x, y, w, h, event)
    local flags = {}
      self:updatePosition()
      if self:isMouseInWnd(x, y, w, h) then
        flags.isWnd = true
        if event ~= nil then
          if self.callEvent == 0 then self.callEvent = 1; event() end
        end
        if isKeyJustPressed(key) then flags.isPressedWnd = true end
        if isKeyDown(key) then flags.isDownWnd = true end
      else
        self.callEvent = 0
        if isKeyJustPressed(key) then flags.isPressedNWnd = true end
        if isKeyDown(key) then flags.isDownNWnd = true end
      end

      if next(flags) == nil then flags.isFree = true end
    return flags
  end

  setmetatable(public, self)
  self.__index = self
  return public
end

tweaks.toolTip = {}
function tweaks.toolTip:new(w)
  local public = {}
    public.maxW = w
    public.w, public.h = 0, 0
    public.strings = ""
    public.font = renderCreateFont("Tahoma", 8, FCR_BOLD + FCR_SHADOW)
    public.x, public.y = 0, 0

  function public:drawTriangle(x1, y1, x2, y2, x3, y3, color)
    renderSetRenderState(176, 1)
    renderBegin(D3DPT_TRIANGLESTRIP)
      renderColor(color)
      renderVertex(x1, y1)
      renderVertex(x2, y2)
      renderVertex(x3, y3)
    renderEnd()
  end

  --function public:Draw(x, y)
  function public:draw()
    local x = self.x - (self.w / 2) - 3
    local y = self.y
    self:drawTriangle(self.x - 15, self.y, self.x, self.y - 9, self.x + 15, y, 0xFF262626)

    renderDrawBox(x, self.y, self.w + 6, self.h + 4, 0xFF262626)
    for _, str in ipairs(self.strings) do
      renderFontDrawText(self.font, str, x + 3, y + 2, 0xDCDCFFFF)
      y = y + renderGetFontDrawHeight(self.font)
    end
  end

  function public:setPosition(x, y)
      self.x, self.y = x, y
  end

  function public:setText(text)
      self:calcSizeWnd(text)
      self.strings = self:splitText(text)
  end

  function public:calcSizeWnd(text)
    local textLength = renderGetFontDrawTextLength(self.font, text)
    if textLength < self.maxW then
      self.w = textLength
      self.h = renderGetFontDrawHeight(self.font) + 5
    else
      local lines = textLength / self.maxW
      self.w = self.maxW
      self.h = renderGetFontDrawHeight(self.font) * lines + 10
    end
  end

  function public:splitText(text)
    local strings = {}
    if self.h <= renderGetFontDrawHeight(self.font) + 2 then
      table.insert(strings, text)
      return strings
    end

    local pos = 1
    for i = 1, #text, 1 do
      if renderGetFontDrawTextLength(self.font, text:sub(pos, i - 1)) > (self.maxW - 13) then
        table.insert(strings, text:sub(pos, i - 1))
        pos = i
      end
    end

    table.insert(strings, text:sub(pos, i))
    return strings
  end

  setmetatable(public, self)
  self.__index = self
  return public
end

tweaks.button = {}
function tweaks.button:new(id, name, func, font)
  local public = {}
    public.id = id
    public.name = name
    public.func = func
    public.mh = tweaks.mouseHandler:new()
    if not font then
      public.font = renderCreateFont("Tahoma", 8, FCR_BOLD + FCR_SHADOW)
    else
      public.font = font
    end

  function public:draw(x, y, w, h)
    local color = 0xFF131313
    local flags = self.mh:isKeyPressed(VK_LBUTTON, x, y, w, h)
    if flags.isWnd == true
    then color = 0xFF292929 --0xFF323232
      if flags.isPressedWnd == true
      then self.func() end
      if flags.isDownWnd == true
      then color = 0xFF323232 end--0xFF141414 end
    end
    renderDrawBox(x, y, w, h, color)
    x = x - (renderGetFontDrawTextLength(self.font, self.name) / 2) + w / 2
    y = y - renderGetFontDrawHeight(self.font) / 2 + h / 2
    renderFontDrawText(self.font, self.name, x, y, 0xB4FFFFFF)
  end

  setmetatable(public, self)
  self.__index = self
  return public
end

tweaks.scrollBar = {}
function tweaks.scrollBar:new(x, y, w, h, maxLines, visibleLines)
  local public = {}
    public.x, public.y = x, y
    public.w, public.h = w, h
    public.maxLines, public.visibleLines = maxLines, visibleLines
    public.scrollY, public.scrollHeight = 0, 0
    public.currLine = 0
    public.difference = 0
    public.mh = tweaks.mouseHandler:new()
    public.active = false

  function public:draw()
    self:updateScrollerSize()
    local color = 0xFF292929
    renderDrawBox(self.x, self.y, self.w, self.h, 0xFF131313)
    if (self.maxLines - self.visibleLines) <= 0 then return end

    local flags = self.mh:isKeyPressed(VK_LBUTTON, self.x, self.y + self.scrollY, self.w, self.scrollHeight)
    if flags.isWnd == true then color = 0xFF353535 end
    if flags.isPressedWnd == true then
      local _, y = getCursorPos()
      self.difference = y - self.y - self.scrollY
      self.active = true
    end
    if flags.isDownWnd == true or flags.isDownNWnd == true then
      if self.active == true then
        local _, y = getCursorPos()
        self.scrollY = y - self.y - self.difference
        if self.scrollY < 0 then self.scrollY = 0 end
        if self.scrollY > (self.h - self.scrollHeight) then self.scrollY = (self.h - self.scrollHeight) end
        self:updateCurrentLine()
      end
    end
    if flags.isFree == true then self.active = false end
    if self.active then color = 0xFF434343 end
    renderDrawBox(self.x, self.y + self.scrollY, self.w, self.scrollHeight, color)
  end

  function public:updateCurrentLine()
    local lineHeight = (self.h - self.scrollHeight) / (self.maxLines - self.visibleLines)
    self.currLine = (self.scrollY / lineHeight)
  end

  function public:updateScrollerSize()
    local lineHeight = self.h / self.maxLines
    self.scrollHeight = self.h - (lineHeight * (self.maxLines - self.visibleLines))
    if self.scrollHeight < 10 then self.scrollHeight = 10 end

    if self.currLine > (self.maxLines - self.visibleLines)
    then self.currLine = (self.maxLines - self.visibleLines) end

    if self.currLine < 0 then self.currLine = 0 end

    self.scrollY = lineHeight * self.currLine
  end

  setmetatable(public, self)
  self.__index = self
  return public
end

return tweaks
