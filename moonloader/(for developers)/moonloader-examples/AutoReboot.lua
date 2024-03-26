script_name("ML-AutoReboot")
script_version_number(6)
script_version("1.0")
script_author("FYP")
script_description("reloads edited scripts automatically")
script_moonloader(021)
script_properties('work-in-pause')
local crc32 = require "lib.crc32ffi"


--- Config
autoreloadDelay    = 500 -- ms
autoreloadEnabled  = true


--- Main
function main()
  if not autoreloadEnabled then
    return -- just exit
  end
  -- for the reload case
  onSystemInitialized()
  while true do
    wait(autoreloadDelay)
    if files ~= nil then
      for f, h in pairs(files) do
        local cs = calc_file_crc32(f)
        if cs ~= h and cs ~= nil then
          local scr = find_script_by_path(f)
          if scr ~= nil then
            print("Reloading '" .. scr.name .. "'...")
            scr:reload()
          else
            print("Loading '" .. f .. "'...")
            script.load(f)
          end
          files[f] = cs -- update checksum
        end
      end
    end
  end
end

function init()
  initialized = true
  files = {}
  -- store all loaded scripts
  for _, s in ipairs(script.list()) do
    local cs = calc_file_crc32(s.path)
    if cs ~= nil then
      files[s.path] = cs
    end
  end
end


--- Events
function onSystemInitialized()
  if not initialized then
    init()
  end
end


--- Functions
function find_script_by_path(path)
  for _, s in ipairs(script.list()) do
    if s.path == path then
      return s
    end
  end
  return nil
end

function calc_file_crc32(path)
  local f = io.open(path, "r")
  if f == nil then
    return nil
  end
  local data = f:read("*a")
  local cs = crc32(data)
  f:close()
  return cs
end
