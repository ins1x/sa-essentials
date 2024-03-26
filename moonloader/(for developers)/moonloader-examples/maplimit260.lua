script_name("MapLimit-260")
script_author("FYP")
script_description("Expand minimum map zoom limit from 300 to 260. Activation: auto. Only for GTASA vUS1.0.")
script_version_number(2)
local ffi = require "ffi"
local addrCmp, addrSet = 0x00577993, 0x005779FA


--- Main
function main()
  if getGameVersion() ~= 0 then
    return -- incompatible game version
  end
	-- alloc memory for float value
	local limit = ffi.new("float[1]", 260.0)
	-- store original data
  origCmp = readMemory(addrCmp, 4, true)
  origSet = readMemory(addrSet, 4, true)
  -- put pointer to value
  writeMemory(addrCmp, 4, tonumber(ffi.cast("intptr_t", limit)), true)
  -- put value
  writeMemory(addrSet, 4, representFloatAsInt(limit[0]), true)
  wait(-1)
end


--- Events
function onExitThread()
  -- restore original on exit
  if origCmp and origSet then
    writeMemory(addrCmp, 4, origCmp, true)
    writeMemory(addrSet, 4, origSet, true)
  end
end
