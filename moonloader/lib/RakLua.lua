local RakLuaDll = require "RakLuaDll"

addEventHandler("onScriptTerminate", function(scr) if scr == script.this then RakLuaDll.destroyHandlers() end end)

local events = {
    ["onSendRpc"]       = RakLuaEvents.OUTGOING_RPC,
    ["onSendPacket"]    = RakLuaEvents.OUTGOING_PACKET,
    ["onReceiveRpc"]    = RakLuaEvents.INCOMING_RPC,
    ["onReceivePacket"] = RakLuaEvents.INCOMING_PACKET
}

local addEventHandler_orig = addEventHandler

local function hookAddEventHandler(event, func)
    if events[event] then
        RakLuaDll.registerHandler(events[event], func)
    else
        addEventHandler_orig(event, func)
    end
end

local function defineSampLuaCompatibility()
    RakLuaDll.defineGlobals()
    
    addEventHandler = hookAddEventHandler
    isSampfuncsLoaded = function() return true end
end

RakLuaDll.defineSampLuaCompatibility = defineSampLuaCompatibility

return RakLuaDll
