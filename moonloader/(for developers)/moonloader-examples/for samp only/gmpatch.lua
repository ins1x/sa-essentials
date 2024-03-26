script_name("gmpatch")
script_author("FYP")
script_dependencies("SAMP", "CLEO")
script_description("Patch for SA:MP godmode anticheat")


--- Main
local patchAddr = 0x004B35A0
function main()
  if not isSampLoaded() then return end
  wait(1000)
  orig1 = readMemory(patchAddr, 4, true)
  orig2 = readMemory(patchAddr + 4, 2, true)
  writeMemory(patchAddr, 4, 0x560CEC83, true)
  writeMemory(patchAddr + 4, 2, 0xF18B, true)
  wait(-1)
end


--- Events
function onExitThread()
  if orig1 and orig2 then
    -- restore original
    writeMemory(patchAddr, 4, orig1, true)
    writeMemory(patchAddr + 4, 2, orig2, true)
  end
end
