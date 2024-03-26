script_name("SAMP-VL Autopin")
script_version_number(3)
script_author("FYP")
script_dependencies("SAMPFUNCS")
require "lib.sampfuncs"
require "config.svl_autopin"


--- Main
doStuff = false
function main()
  if not isSampfuncsLoaded() or not isSampLoaded() then return end
  while not isSampAvailable() do wait(1000) end
  if not checkAccountAndServer() then
    return
  end
  while true do
    wait(0)
    if isPlayerPlaying(playerHandle) then
      if doStuff then
        local pin = autopin.accounts[getLocalPlayerName()]
        local buttons = {}
        for i = 2123, 2132 do
          if sampTextdrawIsExists(i) then
            local str = sampTextdrawGetString(i)
            buttons[tonumber(str)] = i
          end
        end
        for i = 1, #pin do
          sampSendClickTextdraw(buttons[tonumber(pin:sub(i,i))])
        end
        doStuff = false
      end
    end
  end
end

function checkAccountAndServer()
  local host = sampGetCurrentServerAddress()
  if host ~= autopin.serverAddress then
    return false
  end
  local nick = getLocalPlayerName()
  print(nick)
  return autopin.accounts[nick] ~= nil
end


--- Events
function onReceiveRpc(id, bs)
  if id == RPC_SCRSHOWTEXTDRAW
  then
    local txdid = raknetBitStreamReadInt16(bs)
    if txdid == 2132 then
			doStuff = true
    end
  end
end


--- Functions
function getLocalPlayerName()
  local _, id = sampGetPlayerIdByCharHandle(playerPed)
  local nick = sampGetPlayerNickname(id)
  return nick
end
