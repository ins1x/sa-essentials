script_name('BubbleSniffer')
script_author('FYP')
script_moonloader(021)
script_description('Get the latest MoonLoader updates from http://blast.hk/moonloader/')
require 'lib.moonloader'
require 'lib.sampfuncs'
local sampev = require 'lib.samp.events'


--- Config
keyToggle = VK_F5
secondaryKey = VK_B
positionX = 10
positionY = 250
pagesize = 13
messagesMax = 500
blacklist = {
	'На паузе %d+:%d+',
	'На паузе %d+ сек.',
	'+%d hp'
}


--- Main
function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end

	bubbleBox = ChatBox(pagesize, blacklist)
	-- uncomment to show by default
	-- bubbleBox:toggle(true)

	while true do
		if is_key_check_available() and wasKeyPressed(keyToggle) then
			bubbleBox:toggle(not bubbleBox.active)
		end

		if bubbleBox.active then
			bubbleBox:draw(positionX, positionY)
			if is_key_check_available() and isKeyDown(secondaryKey) then
				if getMousewheelDelta() ~= 0 then
					bubbleBox:scroll(getMousewheelDelta() * -1)
				end
			end
		end

		wait(0)
	end
end


--- Events
function sampev.onPlayerChatBubble(playerId, color, distance, duration, message)
	if sampIsPlayerConnected(playerId) and bubbleBox then
		bubbleBox:add_message(playerId, color, distance, message)
	end
end

function onExitScript()
	if bubbleBox then bubbleBox:free() end
end


--- Class ChatBox
ChatBox = function(pagesize, blacklist)
  local obj = {
    pagesize = pagesize,
		active = false,
		font = nil,
		messages = {},
		blacklist = blacklist,
		firstMessage = 0,
		currentMessage = 0,
  }

	function obj:initialize()
		if self.font == nil then
			self.font = renderCreateFont('Verdana', 8, FCR_BORDER + FCR_BOLD)
		end
	end

	function obj:free()
		if self.font ~= nil then
			renderReleaseFont(self.font)
			self.font = nil
		end
	end

	function obj:toggle(show)
		self:initialize()
		self.active = show
	end

  function obj:draw(x, y)
		local add_text_draw = function(text, color)
			renderFontDrawText(self.font, text, x, y, color)
			y = y + renderGetFontDrawHeight(self.font)
		end

		-- draw caption
    add_text_draw("BubbleSniffer", 0xFFE4D8CC)

		-- draw page indicator
		if #self.messages == 0 then return end
		local cur = self.currentMessage
		local to = cur + math.min(self.pagesize, #self.messages) - 1
		add_text_draw(string.format("%d/%d", to, #self.messages), 0xFFE4D8CC)

		-- draw messages
		x = x + 4
		for i = cur, to do
			local it = self.messages[i]
			add_text_draw(
				string.format("{E4E4E4}[%s] (%.1fm) {%06X}%s{D4D4D4}({EEEEEE}%d{D4D4D4}): {%06X}%s",
					it.time,
					it.dist,
					argb_to_rgb(it.playerColor),
					it.nickname,
					it.playerId,
					argb_to_rgb(it.color),
					it.text),
				it.color)
		end
  end

	function obj:add_message(playerId, color, distance, text)
		-- ignore blacklisted messages
		if self:is_text_blacklisted(text) then return end

		-- process only streamed in players
		local dist = get_distance_to_player(playerId)
		if dist ~= nil then
			color = bgra_to_argb(color)
			if dist > distance then color = set_argb_alpha(color, 0xA0)
			else color = set_argb_alpha(color, 0xF0)
			end
			table.insert(self.messages, {
				playerId = playerId,
				nickname = sampGetPlayerNickname(playerId),
				color = color,
				playerColor = sampGetPlayerColor(playerId),
				dist = dist,
				distLimit = distance,
				text = text,
				time = os.date('%X')})

			-- limit message list
			if #self.messages > messagesMax then
				self.messages[self.firstMessage] = nil
				self.firstMessage = #self.messages - messagesMax
			else
				self.firstMessage = 1
			end
			self:scroll(1)
		end
	end

	function obj:is_text_blacklisted(text)
		for _, t in pairs(self.blacklist) do
			if string.match(text, t) then
				return true
			end
		end
		return false
	end

	function obj:scroll(n)
		self.currentMessage = self.currentMessage + n
		if self.currentMessage < self.firstMessage then
			self.currentMessage = self.firstMessage
		else
			local max = math.max(#self.messages, self.pagesize) + 1 - self.pagesize
			if self.currentMessage > max then
				self.currentMessage = max
			end
		end
	end

  setmetatable(obj, {})
  return obj
end


--- Functions
function get_distance_to_player(playerId)
	if sampIsPlayerConnected(playerId) then
		local result, ped = sampGetCharHandleBySampPlayerId(playerId)
		if result and doesCharExist(ped) then
			local myX, myY, myZ = getCharCoordinates(playerPed)
			local playerX, playerY, playerZ = getCharCoordinates(ped)
			return getDistanceBetweenCoords3d(myX, myY, myZ, playerX, playerY, playerZ)
		end
	end
	return nil
end

function is_key_check_available()
  if not isSampfuncsLoaded() then
    return not isPauseMenuActive()
  end
  local result = not isSampfuncsConsoleActive() and not isPauseMenuActive()
  if isSampLoaded() and isSampAvailable() then
    result = result and not sampIsChatInputActive() and not sampIsDialogActive()
  end
  return result
end

function explode_argb(argb)
  local a = bit.band(bit.rshift(argb, 24), 0xFF)
  local r = bit.band(bit.rshift(argb, 16), 0xFF)
  local g = bit.band(bit.rshift(argb, 8), 0xFF)
  local b = bit.band(argb, 0xFF)
  return a, r, g, b
end

function join_argb(a, r, g, b)
  local argb = b  -- b
  argb = bit.bor(argb, bit.lshift(g, 8))  -- g
  argb = bit.bor(argb, bit.lshift(r, 16)) -- r
  argb = bit.bor(argb, bit.lshift(a, 24)) -- a
  return argb
end

function bgra_to_argb(bgra)
  local b, g, r, a = explode_argb(bgra)
  return join_argb(a, r, g, b)
end

function set_argb_alpha(color, alpha)
	  local _, r, g, b = explode_argb(color)
		return join_argb(alpha, r, g, b)
end

function get_argb_alpha(color)
	local alpha = explode_argb(color)
	return alpha
end

function argb_to_rgb(argb)
	return bit.band(argb, 0xFFFFFF)
end
