script_name("Click Warp")
script_authors("FYP", "we_sux team")
script_version_number(3)
script_dependencies("SAMPFUNCS")
script_description("Click click, teleport!")
script_moonloader(19)

require"lib.moonloader"
require"lib.sampfuncs"
local Matrix3X3 = require "matrix3x3"
local Vector3D = require "vector3d"


--- Config
keyToggle = VK_MBUTTON
keyApply = VK_LBUTTON


--- Main
function main()
  if not isSampfuncsLoaded() then return end
  initializeRender()
  while true do

    while isPauseMenuActive() do
      if cursorEnabled then
        showCursor(false)
      end
      wait(100)
    end

    if isKeyDown(keyToggle) then
      cursorEnabled = not cursorEnabled
      showCursor(cursorEnabled)
      while isKeyDown(keyToggle) do wait(80) end
    end

    if cursorEnabled then
      local mode = sampGetCursorMode()
      if mode == 0 then
        showCursor(true)
      end
      local sx, sy = getCursorPos()
      local sw, sh = getScreenResolution()
      -- is cursor in game window bounds?
      if sx >= 0 and sy >= 0 and sx < sw and sy < sh then
        local posX, posY, posZ = convertScreenCoordsToWorld3D(sx, sy, 700.0)
        local camX, camY, camZ = getActiveCameraCoordinates()
        -- search for the collision point
        local result, colpoint = processLineOfSight(camX, camY, camZ, posX, posY, posZ, true, true, false, true, false, false, false)
        if result and colpoint.entity ~= 0 then
          local normal = colpoint.normal
          local pos = Vector3D(colpoint.pos[1], colpoint.pos[2], colpoint.pos[3]) - (Vector3D(normal[1], normal[2], normal[3]) * 0.1)
          local zOffset = 300
          if normal[3] >= 0.5 then zOffset = 1 end
          -- search for the ground position vertically down
          local result, colpoint2 = processLineOfSight(pos.x, pos.y, pos.z + zOffset, pos.x, pos.y, pos.z - 0.3,
            true, true, false, true, false, false, false)
          if result then
            pos = Vector3D(colpoint2.pos[1], colpoint2.pos[2], colpoint2.pos[3] + 1)

            local curX, curY, curZ  = getCharCoordinates(playerPed)
            local dist              = getDistanceBetweenCoords3d(curX, curY, curZ, pos.x, pos.y, pos.z)
            local hoffs             = renderGetFontDrawHeight(font)

            sy = sy - 2
            sx = sx - 2
            renderFontDrawText(font, string.format("%0.2fm", dist), sx, sy - hoffs, 0xEEEEEEEE)

            local tpIntoCar = nil
            if colpoint.entityType == 2 then
              local car = getVehiclePointerHandle(colpoint.entity)
              if doesVehicleExist(car) and (not isCharInAnyCar(playerPed) or storeCarCharIsInNoSave(playerPed) ~= car) then
                displayVehicleName(sx, sy - hoffs * 2, getNameOfVehicleModel(getCarModel(car)))
                local color = 0xAAFFFFFF
                if isKeyDown(VK_RBUTTON) then
                  tpIntoCar = car
                  color = 0xFFFFFFFF
                end
                renderFontDrawText(font2, "Hold right mouse button to teleport into the car", sx, sy - hoffs * 3, color)
              end
            end

            createPointMarker(pos.x, pos.y, pos.z)

            -- teleport!
            if isKeyDown(keyApply) then
              if tpIntoCar then
                if not jumpIntoCar(tpIntoCar) then
                  -- teleport to the car if there is no free seats
                  teleportPlayer(pos.x, pos.y, pos.z)
                end
              else
                if isCharInAnyCar(playerPed) then
                  local norm = Vector3D(colpoint.normal[1], colpoint.normal[2], 0)
                  local norm2 = Vector3D(colpoint2.normal[1], colpoint2.normal[2], colpoint2.normal[3])
                  rotateCarAroundUpAxis(storeCarCharIsInNoSave(playerPed), norm2)
                  pos = pos - norm * 1.8
                  pos.z = pos.z - 0.8
                end
                teleportPlayer(pos.x, pos.y, pos.z)
              end
              removePointMarker()

              while isKeyDown(keyApply) do wait(0) end
              showCursor(false)
            end
          end
        end
      end
    end
    wait(0)
    removePointMarker()
  end
end

function initializeRender()
  font = renderCreateFont("Tahoma", 10, FCR_BOLD + FCR_BORDER)
  font2 = renderCreateFont("Arial", 8, FCR_ITALICS + FCR_BORDER)
end


--- Functions
function rotateCarAroundUpAxis(car, vec)
  local mat = Matrix3X3(getVehicleRotationMatrix(car))
  local rotAxis = Vector3D(mat.up:get())
  vec:normalize()
  rotAxis:normalize()
  local theta = math.acos(rotAxis:dotProduct(vec))
  if theta ~= 0 then
    rotAxis:crossProduct(vec)
    rotAxis:normalize()
    rotAxis:zeroNearZero()
    mat = mat:rotate(rotAxis, -theta)
  end
  setVehicleRotationMatrix(car, mat:get())
end

function readFloatArray(ptr, idx)
  return representIntAsFloat(readMemory(ptr + idx * 4, 4, false))
end

function writeFloatArray(ptr, idx, value)
  writeMemory(ptr + idx * 4, 4, representFloatAsInt(value), false)
end

function getVehicleRotationMatrix(car)
  local entityPtr = getCarPointer(car)
  if entityPtr ~= 0 then
    local mat = readMemory(entityPtr + 0x14, 4, false)
    if mat ~= 0 then
      local rx, ry, rz, fx, fy, fz, ux, uy, uz
      rx = readFloatArray(mat, 0)
      ry = readFloatArray(mat, 1)
      rz = readFloatArray(mat, 2)

      fx = readFloatArray(mat, 4)
      fy = readFloatArray(mat, 5)
      fz = readFloatArray(mat, 6)

      ux = readFloatArray(mat, 8)
      uy = readFloatArray(mat, 9)
      uz = readFloatArray(mat, 10)
      return rx, ry, rz, fx, fy, fz, ux, uy, uz
    end
  end
end

function setVehicleRotationMatrix(car, rx, ry, rz, fx, fy, fz, ux, uy, uz)
  local entityPtr = getCarPointer(car)
  if entityPtr ~= 0 then
    local mat = readMemory(entityPtr + 0x14, 4, false)
    if mat ~= 0 then
      writeFloatArray(mat, 0, rx)
      writeFloatArray(mat, 1, ry)
      writeFloatArray(mat, 2, rz)

      writeFloatArray(mat, 4, fx)
      writeFloatArray(mat, 5, fy)
      writeFloatArray(mat, 6, fz)

      writeFloatArray(mat, 8, ux)
      writeFloatArray(mat, 9, uy)
      writeFloatArray(mat, 10, uz)
    end
  end
end

function displayVehicleName(x, y, gxt)
  x, y = convertWindowScreenCoordsToGameScreenCoords(x, y)
  useRenderCommands(true)
  setTextWrapx(640.0)
  setTextProportional(true)
  setTextJustify(false)
  setTextScale(0.33, 0.8)
  setTextDropshadow(0, 0, 0, 0, 0)
  setTextColour(255, 255, 255, 230)
  setTextEdge(1, 0, 0, 0, 100)
  setTextFont(1)
  displayText(x, y, gxt)
end

function createPointMarker(x, y, z)
  pointMarker = createUser3dMarker(x, y, z + 0.3, 4)
end

function removePointMarker()
  if pointMarker then
    removeUser3dMarker(pointMarker)
    pointMarker = nil
  end
end

function getCarFreeSeat(car)
  if doesCharExist(getDriverOfCar(car)) then
    local maxPassengers = getMaximumNumberOfPassengers(car)
    for i = 0, maxPassengers do
      if isCarPassengerSeatFree(car, i) then
        return i + 1
      end
    end
    return nil -- no free seats
  else
    return 0 -- driver seat
  end
end

function jumpIntoCar(car)
  local seat = getCarFreeSeat(car)
  if not seat then return false end                         -- no free seats
  if seat == 0 then warpCharIntoCar(playerPed, car)         -- driver seat
  else warpCharIntoCarAsPassenger(playerPed, car, seat - 1) -- passenger seat
  end
  restoreCameraJumpcut()
  return true
end

function teleportPlayer(x, y, z)
  if isCharInAnyCar(playerPed) then
    setCharCoordinates(playerPed, x, y, z)
  end
  setCharCoordinatesDontResetAnim(playerPed, x, y, z)
end

function setCharCoordinatesDontResetAnim(char, x, y, z)
  if doesCharExist(char) then
    local ptr = getCharPointer(char)
    setEntityCoordinates(ptr, x, y, z)
  end
end

function setEntityCoordinates(entityPtr, x, y, z)
  if entityPtr ~= 0 then
    local matrixPtr = readMemory(entityPtr + 0x14, 4, false)
    if matrixPtr ~= 0 then
      local posPtr = matrixPtr + 0x30
      writeMemory(posPtr + 0, 4, representFloatAsInt(x), false) -- X
      writeMemory(posPtr + 4, 4, representFloatAsInt(y), false) -- Y
      writeMemory(posPtr + 8, 4, representFloatAsInt(z), false) -- Z
    end
  end
end

function showCursor(toggle)
  if toggle then
    sampSetCursorMode(CMODE_LOCKCAM)
  else
    sampToggleCursor(false)
  end
  cursorEnabled = toggle
end
