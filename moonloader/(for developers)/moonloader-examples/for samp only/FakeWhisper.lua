script_name("FakeWhisper")
script_description("/fwt - FW to player, /fwf - FW from player")
script_version_number(2)
script_version("v.002")
script_authors("hnnssy")


--- Main
function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end

  sampRegisterChatCommand("fwt", cmdFWto)
  sampRegisterChatCommand("fwf", cmdFWfrom)
  wait(-1)
end


--- Callbacks
function cmdFWto(param)
  local id, text = string.match(param, '(%d+)%s*(.+)')
  if id ~= nil and text ~= nil and sampIsPlayerConnected(id) then
    local name = sampGetPlayerNickname(id)
    sampAddChatMessage(string.format(" หั ๊ %s[%d]: {ADFF33}%s", name, id, text), 0xFFFF00)
  end
end

function cmdFWfrom(param)
  local id, text = string.match(param, '(%d+)%s*(.+)')
  if id ~= nil and text ~= nil and sampIsPlayerConnected(id) then
    local name = sampGetPlayerNickname(id)
    sampAddChatMessage(string.format(" หั ๎๒ %s[%d]: {ADFF33}%s", name, id, text), 0xFFFF00)
  end
end
