script_name("QuickMap")
script_author("FYP")
script_version("1.2")
script_description("allows to show game's map without opening the main menu")
script_properties("work-in-pause")

require "lib.moonloader"


--- Config
keyShow = VK_M
reduceZoom = true


function main()
  local menuPtr = 0x00BA6748
  while true do
    wait(20)
    if isPlayerPlaying(playerHandle) then
      if isKeyCheckAvailable() and isKeyDown(keyShow) then
        writeMemory(menuPtr + 0x33, 1, 1, false) -- activate menu
        -- wait for a next frame
        wait(0)
        writeMemory(menuPtr + 0x15C, 1, 1, false) -- textures loaded
        writeMemory(menuPtr + 0x15D, 1, 5, false) -- current menu
        if reduceZoom then
          writeMemory(menuPtr + 0x64, 4, representFloatAsInt(300.0), false)
        end
        while isKeyDown(keyShow) do
          wait(80)
        end
        writeMemory(menuPtr + 0x32, 1, 1, false) -- close menu
      end
    end
  end
end


--- Functions
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
