script_name('ChatBliss')
script_version_number(1)
script_moonloader(020)
script_author('FYP')
script_description('Get the latest MoonLoader updates from http://blast.hk/moonloader/')
local SE = require 'lib.samp.events'


--[[
	#<part_of_name> = id; 			#self = local player id
	%<part_of_name> = fullname; %self = local player name
	%<id> 					= fullname
	## 							= #
	%% 							= %
]]


--- Main
function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then error('Chat Bliss needs SA:MP and SAMPFUNCS!') end
	wait(-1)
end

local punct_chars = '[ %%!"#&\'()*+,-./:;<=>?@%[\\%]^`{|}~]'
function process_match(punct, char, word)
	if punct == char then
		return char .. word
	end

	if punct == '' or #word < 2 then
		return punct .. char .. word
	end

	if word:upper() == 'SELF' then
		local replace
		local _, localPlayerId = sampGetPlayerIdByCharHandle(playerPed)
		if char == '#' then replace = tostring(localPlayerId)
		else replace = sampGetPlayerNickname(localPlayerId)
		end
		return punct .. replace
	end

	-- try to find player by id
	local playerId = tonumber(word)
	if playerId ~= nil then
		if sampIsPlayerConnected(playerId) then
			if char == '%' then return punct .. sampGetPlayerNickname(playerId)
			else return punct .. tostring(playerId)
			end
		end
	end

	-- find player by the part of nickname
	local replace = nil
	for i = 0, sampGetMaxPlayerId(false) do
		if sampIsPlayerConnected(i) then
			local nick = sampGetPlayerNickname(i)
			if string.find(nick:upper(), word:upper(), 1, true) ~= nil then
				if replace ~= nil then
					global_error = 'Too many matches.'
					return nil
				end
				replace = char == '%' and nick or tostring(i)
			end
		end
	end

	if replace ~= nil then
		return punct .. replace
	else
		global_error = "No player '" .. word .. "'."
		return nil
	end
end

function on_send_chat(msg)
	global_error = nil
	msg = string.gsub(' ' .. msg, '([ %%!"#&\'()*+,-./:;<=>?@%[\\%]^`{|}~]?)([%%#])([%w_Р-пр-џЈИ]+)', process_match)
	if global_error then
		sampAddChatMessage('[{E3E300}Chat Bliss{EEEEEE}] {EE3333}' .. global_error, 0xEEEEEE)
		return nil
	end
	return msg:sub(2)
end


--- Events
function SE.onSendChat(msg)
	msg = on_send_chat(msg)
	if msg == nil then
		return false
	end
	return {msg}
end

function SE.onSendCommand(msg)
	msg = on_send_chat(msg)
	if msg == nil then
		return false
	end
	return {msg}
end
