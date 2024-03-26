local snet = require("snet")
local bstream = snet.bstream

local bs = bstream.new()
bs:write(BS_STRING, "Hello world!")

local client = snet.client("127.0.0.1", 7777)
client:add_event_handler('onReceivePacket', function(packet_id, bs) 
	print('onReceivePacket: ' .. packet_id .. ' ' .. bs.bytes)
	if packet_id == 1 then
		local data = bs:read(BS_UINT8)
		print(data)
		bs = bstream.new()
		bs:write(BS_UINT8, data)
		client:send(2, bs, SNET_SYSTEM_PRIORITY)
	end
end)

client:send(1, bs, SNET_SYSTEM_PRIORITY)
while true do
	client:process()
end