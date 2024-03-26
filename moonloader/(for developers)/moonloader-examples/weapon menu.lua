script_name("Weapon Menu")
script_authors("FYP", "hnnssy", "~Au{R}oN")
script_version_number(2)
script_description("Weapon menu cheat. Press RightCtrl + Delete to open menu, use arrows to navigate weapons, +/- to select ammo, Enter to give weapon.")

require "lib.moonloader"


--- Config
keysToggle = {VK_RCONTROL, VK_DELETE}
defaultAmmo = 500


--- Main
local weaponTextures = {"22", "31", "32", "26", "16", "34", "24", "30", "28", "25", "17", "33",
  "23", "37", "29", "27", "18", "9", "35", "36", "38", "39", "41", "42",
  "4", "8", "6", "5", "2", "3", "1", "15", "7", "10", "12", "13", "46",
  "JETPACK", "43", "44", "45", "14"}
totalWeapons = #weaponTextures

function main()
  menu = Menu:new(24, 6)
  while true do
    wait(0)
    if isKeyCheckAvailable() and isKeyComboDown(keysToggle) then
      menuActive = not menuActive

      if not loadWeaponTextures() then return end -- exit script
      menu:toggle(menuActive)

      while not isKeyComboUp(keysToggle) do wait(80) end
    end
    if menuActive then
      menu:process()
    end
  end
end

function loadWeaponTextures()
  if textureList == nil then
    textureList = loadTextures("Weapons", weaponTextures)
    if textureList == nil then print("Can't load txd 'Weapons'."); return false end
  end
  return true
end


--- Class Menu
Menu = {}
function Menu:new(iconSize, columns)
  local public = {}
    public.iconSize = iconSize
    public.columns = columns
    public.selectedItem = 1
    public.textAlphaTick = 0
    public.keyTick = {}
    public.ammo = defaultAmmo
    public.direction = {up = 1, down = 2, left = 3, right = 4}

  function public:toggle(show)
    self.textAlphaTick = 0
    self.textAlpha = 0
    if not menuActive then setPlayerControl(playerHandle, true) end
  end

  function public:process()
    setPlayerControl(playerHandle, false)
    useRenderCommands(true)
    menu:processControl()
    menu:draw()
  end

  function public:draw()
    local x, y = 648.0 - self.columns * self.iconSize, 120.0
    local posX, posY = x, y
    local column = 1

    -- draw icons
    for i = 1, #textureList do
      drawIcon(textureList[i].sprite, posX, posY, (self.selectedItem == i) and (self.iconSize + 2) or self.iconSize)
      if column < self.columns then
        column = column + 1
        posX = posX + self.iconSize
      else
        column = 1
        posX = x
        posY = posY + self.iconSize
      end
    end

    -- update alpha
    if self.textAlpha ~= 0 and gameClock() - self.textAlphaTick > 3.0 then
      self.textAlpha = self.textAlpha - 5
      if self.textAlpha < 0 then self.textAlpha = 0 end
    end

    -- draw info
    if not gxtsInitialized then
      gxtAmmo, gxtInfo = getFreeGxtKey(), getFreeGxtKey()
      gxtsInitialized = true
    end

    setGxtEntry(gxtAmmo, string.format("ammo: %d", self.ammo))
    setGxtEntry(gxtInfo, "hold +/- to select ammo and enter to get weapon~n~hold left shift when selecting ammo to speed up")

    posY = posY - self.iconSize / 2 + 4
    x = x - self.iconSize / 2
    self:drawText(gxtAmmo, x, posY, self.textAlpha)
    self:drawText(gxtInfo, x, posY + 10, self.textAlpha)
  end

  function public:processControl()
    if self:checkKey(VK_RETURN, 0.25) then
      self:giveSelectedWeapon()
      self:updateKeyTick(VK_RETURN)
    end

    -- weapon navigation
    self:processKey(VK_UP, 0.092, function() self:move(self.direction.up) end)
    self:processKey(VK_DOWN, 0.092, function() self:move(self.direction.down) end)
    self:processKey(VK_LEFT, 0.092, function() self:move(self.direction.left) end)
    self:processKey(VK_RIGHT, 0.092, function() self:move(self.direction.right) end)

    -- ammo
    self:processKey(VK_ADD, 0.05, function() self:addAmmo(1) end)
    self:processKey(VK_SUBTRACT, 0.05, function() self:addAmmo(-1) end)
    self:processKey(VK_OEM_PLUS, 0.05, function() self:addAmmo(1) end)
    self:processKey(VK_OEM_MINUS, 0.05, function() self:addAmmo(-1) end)

  end

  function public:addAmmo(ammo)
    self.ammo = self.ammo + (isKeyDown(VK_LSHIFT) and ammo * 10 or ammo)
    if self.ammo < 0 then self.ammo = 0 end
  end

  function public:move(dir)
    if dir == self.direction.right then
      self.selectedItem = self.selectedItem + 1
      if self.selectedItem > totalWeapons then self.selectedItem = 1 end
    end
    if dir == self.direction.left then
      self.selectedItem = self.selectedItem - 1
      if self.selectedItem < 1 then self.selectedItem = totalWeapons end
    end
    if dir == self.direction.down then
      self.selectedItem = self.selectedItem + self.columns
      if self.selectedItem > totalWeapons then self.selectedItem = self.selectedItem - totalWeapons end
    end
    if dir == self.direction.up then
      self.selectedItem = self.selectedItem - self.columns
      if self.selectedItem < 1 then self.selectedItem = totalWeapons + self.selectedItem end
    end
  end

  function public:checkKey(k, delay)
    return isKeyDown(k) and (not self.keyTick[k] or (gameClock() - self.keyTick[k]) > delay)
  end

  function public:processKey(k, delay, func)
    if self:checkKey(k, delay) then
      func()
      self:updateKeyTick(k)
      self.textAlphaTick = gameClock()
      self.textAlpha = 255
    end
  end

  function public:updateKeyTick(k)
    self.keyTick[k] = gameClock()
  end

  function public:giveSelectedWeapon()
    local weap = textureList[self.selectedItem].weapon
    if weap == "JETPACK" then taskJetpack(playerPed)
    else giveWeapon(tonumber(weap), self.ammo)
    end
  end

  function public:drawText(gxt, x, y, alpha)
    setTextWrapx(640.0)
    setTextDropshadow(0, 0, 0, 0)
    setTextScale(0.29, 0.78)
    setTextColour(255, 255, 255, alpha)
    alpha = alpha - 30
    if alpha < 0 then alpha = 0 end
    setTextEdge(1, 0, 0, 0, alpha)
    displayText(x, y, gxt)
  end

  setmetatable(public, self)
  self.__index = self
  return public
end


--- Functions
function isKeyComboDown(keys)
  for i, k in ipairs(keys) do
    if not isKeyDown(k) then return false end
  end
  return true
end

function isKeyComboUp(keys)
  return not isKeyDown(keys[#keys])
end

function isKeyCheckAvailable()
  if not isSampfuncsLoaded() then
    return not isPauseMenuActive()
  end
  local result = not isSampfuncsConsoleActive() and not isPauseMenuActive()
  if isSampLoaded() and isSampAvailable() then
    result = result and not sampIsChatInputActive() and not sampIsDialogActive()
  end
  return result
end

function giveWeapon(id, ammo)
  local model = getWeapontypeModel(id)
  if model ~= 0 then
    if not hasModelLoaded(model) then
      requestModel(model)
      loadAllModelsNow()
      while not hasModelLoaded(model) do wait(0) end
    end
    giveWeaponToChar(playerPed, id, ammo)
    setCurrentCharWeapon(playerPed, id)
  end
end

function loadTextures(txd, names)
  if not loadTextureDictionary(txd) then
		return nil
	end

  local textures = {}
  local count = 0
  for _, name in ipairs(names) do
    local id = loadSprite(name)
    table.insert(textures, {weapon = name, sprite = id})
    count = count + 1
  end

  return textures
end

function drawIcon(id, x, y, size)
  setSpritesDrawBeforeFade(true)
  drawSprite(id, x, y, size, size, 255, 255, 255, 255)
end
