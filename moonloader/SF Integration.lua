script_name("SF Integration")
script_version("0.8")
script_version_number(8)
script_author("FYP")
script_description("integrate MoonLoader with SAMPFUNCS")
script_dependencies("SAMPFUNCS ^5.3")
script_properties('work-in-pause')

require "lib.sampfuncs"
require "lib.moonloader"


--- Сonfig
logDebugMessages = false


--- Main
COLOR_MSG       = 0xC0C0C0
COLOR_SCRIPTMSG = 0x7DD156
COLOR_SENDER    = 0xE0E0E0

function main()
  if not isSampfuncsLoaded() then return end
  sampfuncsRegisterConsoleCommand("lua", do_lua)
  sampfuncsRegisterConsoleCommand(">>", do_lua)
  -- wait infinitely
  wait(-1)
end

function log_message(msg, tagtext, tagcolor, sender)
  local str = string.format("{%06X}[ML] ", COLOR_MSG)
  if tagtext then
    str = str .. string.format("{%06X}(%s) ", tagcolor, tagtext)
  end
  if sender then
    str = str .. string.format("{%06X}%s: ", COLOR_SENDER, sender.name)
  end
  sampfuncsLog(string.format("%s{%06X}%s", str, COLOR_MSG, msg))
end


--- Callbacks
function do_lua(code)
  if code:sub(1,1) == '=' then
    code = "print(" .. code:sub(2, -1) .. ")"
  end
  local func, err = load(code)
  if func then
    local result, err = pcall(func)
    if not result then
      onSystemMessage(err, TAG.TYPE_ERROR, thisScript())
    end
  else
    onSystemMessage(err, TAG.TYPE_ERROR, thisScript())
  end
end


--- Events
function onSystemMessage(msg, type, sender)
	if isSampfuncsLoaded() and isOpcodesAvailable() and (type ~= TAG.TYPE_DEBUG or logDebugMessages) then
    local tagtxt = get_tag_text(type)
    local tagclr = get_tag_color(type) or COLOR_MSG
    log_message(msg, tagtxt, tagclr, sender)
  end
end

function onScriptMessage(msg, sender)
  if isSampfuncsLoaded() and isOpcodesAvailable() then
    log_message(msg, "script", COLOR_SCRIPTMSG, sender)
  end
end


--- Functions
local tags = {
  [TAG.TYPE_INFO] =      {"info", 0xA9EFF5},
  [TAG.TYPE_DEBUG] =     {"debug", 0xAFA9F5},
  [TAG.TYPE_ERROR] =     {"error", 0xFF7070},
  [TAG.TYPE_WARN] =      {"warn", 0xF5C28E},
  [TAG.TYPE_SYSTEM] =    {"system", 0xFA9746},
  [TAG.TYPE_FATAL] =     {"fatal", 0x040404},
  [TAG.TYPE_EXCEPTION] = {"exception", 0xF5A9A9}
}

function get_tag_text(n)
	local tag = tags[n]
	return tag ~= nil and tag[1] or nil
end

function get_tag_color(n)
	local tag = tags[n]
	return tag ~= nil and tag[2] or nil
end
