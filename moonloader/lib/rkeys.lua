--[[
   Register HotKey for MoonLoader
   Author: DonHomka
   Functions:
      - int id = registerHotKey(table keys, bool pressed, function callback)
      - unRegisterHotKey:
         > bool result, int count = unRegisterHotKey(table keys)
         > bool result = unRegisterHotKey(int id)
      - isHotKeyDefined:
         > bool result, int id = isHotKeyDefined(table keys)
         > bool result, table keys = isHotKeyDefined(int id)
      - table keys, bool end = getCurrentHotKey(bool show_name_keys)
      - table keys = getAllHotKey()
   HotKey data:
      - table keys                  Return table keys for active hotkey
      - bool pressed                True - wasKeyPressed() / False - isKeyDown()
      - function callback           Call this function on active hotkey
   E-mail: a.skinfy@gmail.com
   VK: http://vk.com/DonHomka
   TeleGramm: http://t.me/DonHomka
   Discord: DonHomka#2534

   Last update:
      #1.1.0:
      - Fixed bug isHotKeyHotKey
      - Deleted block-functions
]]
local vkeys = require 'vkeys'

vkeys.key_names[vkeys.VK_LMENU] = "LAlt"
vkeys.key_names[vkeys.VK_RMENU] = "RAlt"
vkeys.key_names[vkeys.VK_LSHIFT] = "LShift"
vkeys.key_names[vkeys.VK_RSHIFT] = "RShift"
vkeys.key_names[vkeys.VK_LCONTROL] = "LCtrl"
vkeys.key_names[vkeys.VK_RCONTROL] = "RCtrl"

local tHotKey = {}
local tKeyList = {}
local tKeysCheck = {}
local iCountCheck = 0
local tBlockKeys = {[vkeys.VK_LMENU] = true, [vkeys.VK_RMENU] = true, [vkeys.VK_RSHIFT] = true, [vkeys.VK_LSHIFT] = true, [vkeys.VK_LCONTROL] = true, [vkeys.VK_RCONTROL] = true}
local tModKeys = {[vkeys.VK_MENU] = true, [vkeys.VK_SHIFT] = true, [vkeys.VK_CONTROL] = true}
local tBlockNext = {}
local module = {}
module._VERSION = "1.1.0"
module._MODKEYS = tModKeys
module._LOCKKEYS = false

local function getKeyNum(id)
   for k, v in pairs(tKeyList) do
      if v == id then
         return k
      end
   end
   return 0
end

function module.isHotKeyHotKey(keys, keys2)
   if type(keys) ~= "table" then
      print("[RKeys | isHotKeyHotKey]: Bad argument #1. Value \"", tostring(keys), "\" is not table.")
      return false
   elseif type(keys2) ~= "table" then
      print("[RKeys | isHotKeyHotKey]: Bad argument #2. Value \"", tostring(keys2), "\" is not table.")
      return false
   else
      return table.concat(keys, " ") == table.concat(keys2, " ")
   end
end

function module.isKeyModified(id)
   if type(id) ~= "number" then
      print("[RKeys | isKeyModified]: Bad argument #1. Value \"", tostring(id), "\" is not number.")
      return false
   end
   return (tModKeys[id] or false) or (tBlockKeys[id] or false)
end

function module.isModifiedDown()
   local bool = false
   for k, v in pairs(tModKeys) do
      if isKeyDown(k) then
         bool = true
         break
      end
   end
   return bool
end

lua_thread.create(function ()
   while true do
      wait(0)
      local tDownKeys = module.getCurrentHotKey()
      for k, v in pairs(tHotKey) do
         if #v.keys > 0 then
            local bool = true
            for i = 1, #v.keys do
               if i ~= #v.keys and (getKeyNum(v.keys[i]) > getKeyNum(v.keys[i + 1]) or getKeyNum(v.keys[i]) == 0) then
                  bool = false
                  break
               elseif i == #v.keys and (v.pressed and not wasKeyPressed(v.keys[i]) or not v.pressed and not isKeyDown(v.keys[i])) or (#v.keys == 1 and module.isModifiedDown()) then
                  bool = false
                  break
               end
            end
            if bool and ((module.onHotKey and module.onHotKey(k, v.keys) ~= false) or module.onHotKey == nil) then
               v.callback(k, v.keys)
            end
         end
      end
   end
end)

function module.registerHotKey(keys, pressed, callback)
   tHotKey[#tHotKey + 1] = {keys = keys, pressed = pressed, callback = callback}
   return #tHotKey
end

function module.getAllHotKey()
   return tHotKey
end

function module.changeHotKey(id, newkeys)
   if type(id) ~= "number" then
      print("[RKeys | changeHotKey]: Bad argument #1. Value \"", tostring(keys), "\" is not number.")
      return false
   elseif type(newkeys) ~= "table" then
      print("[RKeys | changeHotKey]: Bad argument #2. Value \"", tostring(newkeys), "\" is not table.")
      return false
   else
      local bool = false
      if module.isHotKeyDefined(id) then
         tHotKey[id].keys = newkeys
         bool = true
      end
      return bool
   end
end

function module.unRegisterHotKey(keys_or_id)
   local result = false
   local count = 0
   if type(keys_or_id) == "number" and tHotKey[keys_or_id] then
      tHotKey[keys_or_id] = nil
      result = true
      count = nil
   elseif type(keys_or_id) == "table" then
      while module.isHotKeyDefined(keys_or_id) do
         local _, id = module.isHotKeyDefined(keys_or_id)
         tHotKey[id] = nil
         result = true
         count = count + 1
      end
      local id = 1
      local tNewHotKey = {}
      for k, v in pairs(tHotKey) do
         tNewHotKey[id] = v
         id = id + 1
      end
      tHotKey = tNewHotKey
   else
      print("[RKeys | unRegisterHotKey]: Bad argument #1. Value \"", tostring(keys_or_id), "\" is not number or table.")
      return false, -1
   end
   return result, count
end

function module.isHotKeyDefined(keys_or_id)
   if type(keys_or_id) == "number" and tHotKey[keys_or_id] then
      return true, tHotKey[keys_or_id].keys
   elseif type(keys_or_id) == "table" then
      local bool, hkId = false, -1
      for k, v in pairs(tHotKey) do
         if module.isHotKeyHotKey(keys_or_id, v.keys) then
            bool = true
            hkId = k
            break
         end
      end
      return bool, hkId
   else
      print("[RKeys | isHotKeyDefined]: Bad argument #1. Value \"", tostring(keys_or_id), "\" is not number or table.")
      return false, -1
   end
   return false, -1
end

function module.getKeysName(keys)
   if type(keys) ~= "table" then
      print("[RKeys | getKeysName]: Bad argument #1. Value \"", tostring(keys), "\" is not table.")
      return false
   else
      local tKeysName = {}
      for k, v in ipairs(keys) do
         tKeysName[k] = vkeys.id_to_name(v)
      end
      return tKeysName
   end
end

function module.getCurrentHotKey(show_name_keys)
   local show_name_keys = show_name_keys or false
   local tCurKeys = {}
   for k, v in pairs(vkeys) do
      if tBlockKeys[v] == nil then
         local num, down = getKeyNum(v), isKeyDown(v)
         if down and num == 0 then
            tKeyList[#tKeyList + 1] = v
         elseif num > 0 and not down then
            tKeyList[num] = nil
         end
      end
   end
   local i = 1
   for k, v in pairs(tKeyList) do
      tCurKeys[i] = show_name_keys == false and v or vkeys.id_to_name(v)
      i = i + 1
   end
   return tCurKeys, #tKeyList > 0 and not module.isKeyModified(tKeyList[#tKeyList]) or false
end

return module