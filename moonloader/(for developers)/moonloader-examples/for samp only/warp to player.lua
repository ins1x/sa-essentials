script_name("SAMP-Warp")
script_author("FYP")
script_dependencies("SAMPFUNCS", "SAMP")


--- Main
function main()
  if not isSampfuncsLoaded() or not isSampLoaded() then return end
  while not isSampAvailable() do
    wait(200)
  end
  sampRegisterChatCommand("warpto", cmdWarp)
  sampSetClientCommandDescription("warpto", "teleport to player by ID. usage: /warpto [playerId]")
  wait(-1)
end


--- Callbacks
function cmdWarp(p)
  if #p > 0 then
    local id = tonumber(p)
    if sampIsPlayerConnected(id) then
      local result, posX, posY, posZ = sampGetStreamedOutPlayerPos(id)
      if result then
        teleportToPlayer(id, posX + 1.0, posY + 1.0, posZ)
      else
        local result, handle = sampGetCharHandleBySampPlayerId(id)
        if result and doesCharExist(handle) then
          local posX, posY, posZ = getCharCoordinates(handle)
          teleportToPlayer(id, posX + 1.0, posY + 1.0, posZ - 1.0)
        else
          sampAddChatMessage(string.format("Player %s(%d) position is unknown.", sampGetPlayerNickname(id), id), 0xCC0000)
        end
      end
    else
      sampAddChatMessage(string.format("Player %d is not connected.", id), 0xCC0000)
    end
  end
end


--- Functions
function teleportToPlayer(id, x, y, z)
  setCharCoordinates(playerPed, x, y, z)
  sampAddChatMessage(string.format("Teleported to %s (%d). Position %.2f %.2f %.2f", sampGetPlayerNickname(id), id, x, y, z), 0xAAAAAA)
end
