local snet = require("snet")
local bstream = snet.bstream

local server = snet.server("*", 7777)
server:add_event_handler('onClientUpdate', function(address, port, status) -- status: connected, timeout
	-- чтобы не было timeout надо хотя бы раз в 60 секунд кидать какой-нибудь пакет (лучше раз в 30 секунд)
	-- после timeout сервер считает, что пользователь отключен и перестает кидать пакеты повторно
	print('onClientUpdate: ' .. address .. ':' .. port .. ' ' .. status)
end)
server:add_event_handler('onReceivePacket', function(packet_id, bs, address, port) 
	print('onReceivePacket: ' .. address .. ':' .. port .. ' ' .. packet_id .. ' ' .. bs.bytes)
	if packet_id == 1 then
		bs = bstream.new()
		bs:write(BS_UINT8, 127)
		server:send(1, bs, SNET_SYSTEM_PRIORITY, address, port)
	elseif packet_id == 2 then
		print(bs:read(BS_UINT8))
	end
end)

while true do
	server:process()
end