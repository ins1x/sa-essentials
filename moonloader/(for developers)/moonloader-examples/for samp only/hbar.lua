script_name('hBAR')
script_author('hnnssy')
print("* /lua/ hBAR loaded // hnnssy")
require("config.hbarcfg")


--- Config
istate = true


--- Main
function main()
  while not isSampAvailable() do
      wait(1000)
  end
  initialize()
  while true do
    wait(0)
    if isPlayerPlaying(playerHandle) and istate then
      local posX, posY = getScreenResolution()
      renderDrawBoxWithBorder(-1, posY - 17, posX + 2, 18, cfg_back_color, 1, cfg_border_color)
      if not isCharInAnyCar(playerPed) then
        drawOnfootBar()
      else
        drawInCarBar()
      end
    end
  end
end

function initialize()
  ifont = renderCreateFont(cfg_font_name, 8, cfg_flags)
  sampAddChatMessage("* /lua/ hBAR loaded // hnnssy", 0xC1C1C1)
  sampAddChatMessage("** use /hbar to turn on/off this shit", 0xC1C1C1)
  sampRegisterChatCommand("hbar", command)
end

function drawOnfootBar()
  local playerID, playerName, playerPing, playerHP, playerAP, playerLvl, playerMoney,
    playerWeapon, playerAmmo, playerInterior = getPlayerOnFootInfo()
  local playerposX, playerposY, playerposZ = getCharCoordinates(playerPed)

  local text = string.format("Name: %s | ID: %d | Ping: %d | Health: %d | Armor: %d | Level: %d | Money: %.2fkk | Weapon: %d | Ammo: %d | Interior: %d | [%.2f][%.2f][%.2f]",
    playerName, playerID, playerPing, playerHP, playerAP, playerLvl, playerMoney / 1000000.0,
    playerWeapon, playerAmmo, playerInterior, playerposX, playerposY, playerposZ)

  local screenW, screenH = getScreenResolution()
  local fontlen = renderGetFontDrawTextLength(ifont, text)
  local posX = math.ceil((screenW / 2) - (fontlen / 2))

  renderFontDrawText(ifont, text, posX, screenH - 17, cfg_text_color)
end

function drawInCarBar()
  local playerID, playerName, playerPing, playerHP, playerAP, playerLvl, playerMoney,
    playerWeapon, playerAmmo, vehHP, vehID = getPlayerInCarInfo()
  local playerposX, playerposY, playerposZ = getCharCoordinates(playerPed)

  local text = string.format("Name: %s | ID: %d | Ping: %d | Health: %d | Armor: %d | Level: %d | Money: %.2fkk | Weapon: %d | Ammo: %d | VehHP: %d | VehID: %d | [%.2f][%.2f][%.2f]",
    playerName, playerID, playerPing, playerHP, playerAP, playerLvl, playerMoney / 1000000.0,
    playerWeapon, playerAmmo, vehHP, vehID, playerposX, playerposY, playerposZ)

  local screenW, screenH = getScreenResolution()
  local fontlen = renderGetFontDrawTextLength(ifont, text)
  local posX = math.ceil((screenW / 2) - (fontlen / 2))

    renderFontDrawText(ifont, text, posX, screenH - 17, cfg_text_color)
end


--- Callbacks
function command()
  if istate == true then
    istate = false
    sampfuncsLog("** hBAR disabled")
  else
    istate = true
    sampfuncsLog("** hBAR enabled")
  end
end


--- Functions
function getPlayerOnFootInfo()
  local _, playerID = sampGetPlayerIdByCharHandle(playerPed)
  local playerHP = getCharHealth(playerPed)
  local playerWeapon = getCurrentCharWeapon(playerPed)

  return playerID,
    sampGetPlayerNickname(playerID),
    sampGetPlayerPing(playerID),
    playerHP,
    getCharArmour(playerPed),
    sampGetPlayerScore(playerID),
    getPlayerMoney(playerHandle),
    playerWeapon,
    getAmmoInCharWeapon(playerPed, playerWeapon),
    getActiveInterior()
end

function getPlayerInCarInfo()
  local _, playerID = sampGetPlayerIdByCharHandle(playerPed)
  local playerHP = getCharHealth(playerPed)
  local playerWeapon = getCurrentCharWeapon(playerPed)
  local playerCar = storeCarCharIsInNoSave(playerPed)
  local _, vehId = sampGetVehicleIdByCarHandle(playerCar)

  return playerID,
    sampGetPlayerNickname(playerID),
    sampGetPlayerPing(playerID),
    playerHP,
    getCharArmour(playerPed),
    sampGetPlayerScore(playerID),
    getPlayerMoney(playerHandle),
    playerWeapon,
    getAmmoInCharWeapon(playerPed, playerWeapon),
    getCarHealth(playerCar),
    vehId
end
