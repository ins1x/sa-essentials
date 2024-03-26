script_name("ScriptManager")
script_authors("MISTER_GONWIK", "FYP")
script_dependencies("SAMPFUNCS", "SAMP")
script_version("1.1.0")
script_version_number(2)
script_description("MoonLoader script manager")
script_moonloader(023)

require "lib.sampfuncs"
require "lib.moonloader"
local bitex = require "lib.bitex"
local tweaks = require "lib.mgtweaks"


--- Config
keysActivate = {VK_CONTROL, VK_MENU, VK_S}


--- Main
scripts = {}
function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end

	font = renderCreateFont("Tahoma", 8, FCR_BOLD + FCR_SHADOW)
	onSystemInitialized()

	while not isSampAvailable() do wait(100) end
	sampRegisterChatCommand("smenu", cmdsmenu)

	while true do
		if enabled then sl:drawScripts() end
		if doClose then
			while isKeyDown(VK_LBUTTON) do wait(0) end
			toggle(false)
			doClose = false
		end
			if is_keycombo_pressed(keysActivate) then
				toggle(not enabled)
			end
			if wasKeyPressed(VK_ESCAPE) then
				toggle(false)
			end
		wait(0)
	end
end

function init()
	initialized = true

	mh = tweaks.mouseHandler:new()
	sl = ScriptList:new()

	loadScriptsList()
end

function toggle(show)
	enabled = show
	sampToggleCursor(show)
end


--- Events
function onSystemInitialized()
	if not initialized then
		init()
	end
end

function onScriptLoad(script)
	local s = getScriptFromList(script)
	if s ~= nil then
		s:enable(script)
	else
		addScriptToList(script)
	end
end

function onScriptTerminate(script)
	local s = getScriptFromList(script)
	if s ~= nil then
		s:disable(script)
	end
end

--- Callbacks
-- Commands
function cmdsmenu(param)
	toggle(not enabled)
end
-- GUI
function loadUnload()
	local script = scripts[sl.activeScriptId]
	if script.loaded == false
	then
		script:load()
		sl.btnLoadUnload.name = "Unload"
	else
		script:unload()
		sl.btnLoadUnload.name = "Load"
	end
end

function reload()
	local script = scripts[sl.activeScriptId]
	if script.loaded == true then
		script:reload()
	end
end

function pauseResume()
	local script = scripts[sl.activeScriptId]
	if script.loaded == true then
		if script.frozen == true
		then
			script:resume()
			sl.btnPauseResume.name = "Pause"
		else
			script:pause()
			sl.btnPauseResume.name = "Resume"
		end
	end
end

function cbClose()
	doClose = true
end


--- Class Script
Script = {}
function Script:new(script)
	local public = {}
		public.loaded = true

	function public:updateInfo(script)
		self.script = script
		self.name = script.name
		self.description = script.description
		self.version_num = script.version_num
		self.version = script.version
		self.authors = script.authors
		self.dependencies = script.dependencies
		self.path = script.path
		self.filename = script.filename
		self.directory = script.directory
		self.frozen = script.frozen
		self.dead = script.dead
	end

	function public:load()
		self:updateInfo(script.load(self.path))
	end

	function public:unload()
		self.script:unload()
	end

	function public:pause()
		self.script:pause()
		self.frozen = self.script.frozen
	end

	function public:resume()
		self.script:resume()
		self.frozen = self.script.frozen
	end

	function public:reload()
		self.script:reload()
	end

	function public:enable(script)
		if self.loaded ~= true then
			self:updateInfo(script)
		end
		self.loaded = true
	end

	function public:disable()
		self.loaded = false
	end

	public:updateInfo(script)
	setmetatable(public, self)
	self.__index = self
	return public
end


--- Class ScriptList
-- Script manager core
ScriptList = {}
function ScriptList:new()
	local public = {}
		public.x, public.y = 0, 0
		public.scriptY = 0
		public.activeScriptId = 1
		public.drawToolTip = 0
		public.btnReload = tweaks.button:new(1, "Reload", reload, font)
		public.btnPauseResume = tweaks.button:new(2, "Pause", pauseResume, font)
		public.btnLoadUnload = tweaks.button:new(3, "Unload", loadUnload, font)
		public.btnClose = tweaks.button:new(4, "x", cbClose, font)
		public.scrollBar = tweaks.scrollBar:new(0, 0, 5, 194, 100, 16)
		public.toolTip = tweaks.toolTip:new(330)
		public.windowTitle = "ScriptManager v" .. thisScript().version

	function public:drawScript(id, script)
		local color = 0xDCDCFFFF
		local flags = mh:isKeyPressed(VK_LBUTTON, self.x + 4, self.scriptY, renderGetFontDrawTextLength(font, script.filename), renderGetFontDrawHeight(font))
		if flags.isWnd == true then
			color = 0xC8DCFFFF
			if flags.isPressedWnd == true then
				self.activeScriptId = id
				sl.btnPauseResume.name = script.frozen == true and "Resume" or "Pause"
				sl.btnLoadUnload.name = script.loaded == true and "Unload" or "Load"
			end
			if flags.isDownWnd == true then
				color = 0x96DCFFFF
			end
		end
		if id == self.activeScriptId then color = 0xFFFF6400 end
		if script.loaded == false then
			local a = bitex.bextract(color, 24, 8)
			color = bitex.breplace(color, a - 100, 24, 8)
		end
		renderFontDrawText(font, script.filename, self.x + 4, self.scriptY, color)
		self.scriptY = self.scriptY + renderGetFontDrawHeight(font)
	end

	function public:updateTooltip(text, x, y, length)
		self.toolTip:setText(text)
		self.toolTip:setPosition(x + length / 2, y + 30)

		self.drawToolTip = 1
	end

	function public:drawString(text, y)
		local string = splitString(font, text, 305)
		local x = self.x + 154 + 14
		if #text == 0 then
			renderFontDrawText(font, "-", x, y, 0xDCDCFFFF)
		else
			local length = renderGetFontDrawTextLength(font, string.."..")
			mh:isKeyPressed(VK_LBUTTON, x, y, length, renderGetFontDrawHeight(font), function() self:updateTooltip(text, x, y, length) end)
			renderFontDrawText(font, length > 310 and string..".." or string, x, y, 0xDCDCFFFF)
		end
		return y + renderGetFontDrawHeight(font)
	end

	function public:drawScriptInfo(script)
		self.drawToolTip = 0
		local x = self.x + 154
		local y = self.y + 4

		renderFontDrawText(font, "Name:", x, y, 0xFF1E90FF)
		y = y + renderGetFontDrawHeight(font)
		y = self:drawString(script.name, y)

		renderFontDrawText(font, "Version:", x, y, 0xFF1E90FF)
		y = y + renderGetFontDrawHeight(font)
		y = self:drawString(script.version.." ("..tostring(script.version_num)..")", y)

		renderFontDrawText(font, (#script.authors == 1 and "Author:" or "Authors:"), x, y, 0xFF1E90FF)
		y = y + renderGetFontDrawHeight(font)
		y = self:drawString(table.concat(script.authors, ", "), y)

		renderFontDrawText(font, "Description:", x, y, 0xFF1E90FF)
		y = y + renderGetFontDrawHeight(font)
		y = self:drawString(script.description, y)

		renderFontDrawText(font, "Path:", x, y, 0xFF1E90FF)
		y = y + renderGetFontDrawHeight(font)
		y = self:drawString(script.path, y)

		renderFontDrawText(font, "Dependencies:", x, y, 0xFF1E90FF)
		y = y + renderGetFontDrawHeight(font)
		y = self:drawString(table.concat(script.dependencies, ", "), y)
	end

	function public:drawWindowTitle(text)
		local x = self.x - (renderGetFontDrawTextLength(font, text) / 2) + 502 / 2
		local y = self.y - 12
		renderDrawBox(self.x, y, 500, 12, 0xFF141414)--0xFF3C82A0)
		--renderDrawBoxWithBorder(self.x, y, 502, 10, 0xFF141414, 1, 0xFF0A0A0A)
		renderFontDrawText(font, text, x, y, 0xDCDCFFFF)
	end

	function public:drawWindow()
		self.x, self.y = getScreenResolution()
		self.x, self.y = self.x / 2 - 250, self.y / 2 - 100

		self:drawWindowTitle(self.windowTitle)
		renderDrawBoxWithBorder(self.x, self.y, 500, 200, 0xD0101010, 2, 0xFF141414)

		--[[self.btnLoadUnload:draw(self.x + 154, self.y + 165, 40, 15)
		self.btnReload:draw(self.x + 200, self.y + 165, 40, 15)
		self.btnPauseResume:draw(self.x + 246, self.y + 165, 40, 15)]]
		self.btnLoadUnload:draw(self.x + 154, self.y + 168, 50, 25)
		self.btnReload:draw(self.x + 154 + 51, self.y + 168, 50, 25)
		self.btnPauseResume:draw(self.x + 154 + 51 * 2, self.y + 168, 50, 25)

		self.btnClose:draw(self.x + 500 - 12, self.y - 12, 12, 10)

		self.scrollBar.x = self.x + 143
		self.scrollBar.y = self.y + 3
		self.scrollBar.maxLines = #scripts
		self.scrollBar:draw()
	end

	function public:drawScripts()
		sampToggleCursor(true)
		self:drawWindow()
		self.scriptY = self.y + 2
		for id, it in ipairs(scripts) do
			if id > (self.scrollBar.currLine) and id <= (self.scrollBar.currLine + self.scrollBar.visibleLines) then
				self:drawScript(id, it)
			end
			if id == self.activeScriptId then
				self:drawScriptInfo(it)
			end
		end
		if self.drawToolTip == 1 then
			self.toolTip:draw()
		end
	end

	setmetatable(public, self)
	self.__index = self
	return public
end


--- Functions
function loadScriptsList()
	for _, it in ipairs(script.list()) do
		addScriptToList(it)
	end
end

function getScriptFromList(script)
	for _, it in pairs(scripts) do
		if it.path == script.path then
			return it
		end
	end
	return nil
end

function addScriptToList(script)
	local s = getScriptFromList(script)
	if s == nil then
		table.insert(scripts, Script:new(script))
	end
end

function splitString(font, text, length)
	if renderGetFontDrawTextLength(font, text) <= length then return text end

	local pos = 1
	for i = 1, #text, 1 do
		if renderGetFontDrawTextLength(font, text:sub(pos, i - 1)) > length then
			return text:sub(pos, i - 1)
		end
	end
end

function is_keycombo_pressed(keys)
	for i = 1, #keys - 1 do
		if not isKeyDown(keys[i]) then return false end
	end
	return wasKeyPressed(keys[#keys])
end
