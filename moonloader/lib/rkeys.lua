--[[
   Author: DonHomka
   [Functions]
      HotKeys:
      # registerHotKey(table keycombo, int activationType, [bool blockInput = false], function callback)
         Регистрирует новый хоткей. Можно опустить параметр блокировки ввода. Возвращает ID нового хоткея
      # unRegisterHotKey(int id)
         Удаляет хоткей по ID
      # unRegisterHotKey(table keycombo)
         Удаляет хоткей по комбинации клавиш. Возвращает результат удаления и колличество удаленных хоткеев.
      # isHotKeyDefined(ind id)
         Проверяет на существование определенных ID клавиши.
      # isHotKeyDefined(table keycombo)
         Проверяет на сущетсвование хоткея с заданной комбинацией
      # getHotKey(int id)
         Возвращает данные хоткея из таблицы tHotKeys по ID. Первым возвращаемым параметром идет результат поиска.
      # getHotKey(table keycombo)
         Возвращает данные хоткея из таблицы tHotKeys по комбинации клавиш. Первым возвращаемым параметром идет результат поиска.

      Other:
      # isKeyExist(int keyid, [table keylist = tCurKeys])
         Проверяет существование определенной клавиши в списке. По умолчанию берется список текущих нажатых клавиш.
      # isKeyComboExist(talbe keycombo, [table keylist = tCurKeys])
         Проверяет на существование комбинации клавиш в списке
      # getKeyPosition(int keyid, [table keylist = tCurKeys])
         Возвращает позицию клавиши в списке. Если клавиши нет - вернет nil
      # getExtendedKeys(int keyid, int scancode, int keyex)
         Возвращает расширеную версию модификаторов или nil
      # getKeys([bool showKeyName = false])
         Возвращает таблицу текущих нажатых клавиш. Аргументом задается нужно ли возвращать имя клавиши.

      tHotKeys data:
         - keys - клавиши для хоткея
         - aType - тип хоткея:
            1 - срабатывает на нажатие клавиши
            2 - срабатывает на нажатие и до тех пор пока клавиша зажата
            3 - срабатывает при отжатии последней(!) клавиши в комбо (Alt + Shift + R - сработает если зажать комбинацию и отпустить R)
         - isBlock - нужно ли блокировать ввод для последней(!) клавиши комбо. Не работает для aType = 3.
         - callback - функция обратного вызова для срабатывания клавиши
         - id - уникальный индефикатор хоткея (не позиция в tHotKeys, а именно уникальный индефикатор). Имеено по этому ID происходит поиск клавиш.

   E-mail: idonhomka@gmail.com
   VK: http://vk.com/DonHomka
   TeleGramm: http://t.me/iDonHomka
   Discord: DonHomka#2534
]]
local vkeys = require 'vkeys'
local wm = require 'windows.message'
local bitex = require 'bitex'
local ffi = require 'ffi'

local tCurKeys = {}
local tModKeys = { [vkeys.VK_MENU] = true, [vkeys.VK_SHIFT] = true, [vkeys.VK_CONTROL] = true }
local tModKeysList = { vkeys.VK_MENU, vkeys.VK_LMENU, vkeys.VK_RMENU, vkeys.VK_SHIFT, vkeys.VK_RSHIFT, vkeys.VK_LSHIFT, vkeys.VK_CONTROL, vkeys.VK_LCONTROL, vkeys.VK_RCONTROL }
local tMessageTrigger = {
                        [wm.WM_KEYDOWN] = true,
                        [wm.WM_SYSKEYDOWN] = true,
                        [wm.WM_KEYUP] = true,
                        [wm.WM_SYSKEYUP] = true,
                        [wm.WM_LBUTTONDOWN] = true,
                        [wm.WM_LBUTTONDBLCLK] = true,
                        [wm.WM_LBUTTONUP] = true,
                        [wm.WM_RBUTTONDOWN] = true,
                        [wm.WM_RBUTTONDBLCLK] = true,
                        [wm.WM_RBUTTONUP] = true,
                        [wm.WM_MBUTTONDOWN] = true,
                        [wm.WM_MBUTTONDBLCLK] = true,
                        [wm.WM_MBUTTONUP] = true,
                        [wm.WM_XBUTTONDOWN] = true,
                        [wm.WM_XBUTTONDBLCLK] = true,
                        [wm.WM_XBUTTONUP] = true,
                        [wm.WM_MOUSEWHEEL] = true
                     }
local tRewriteMouseKeys = {
                           [wm.WM_LBUTTONDOWN] = vkeys.VK_LBUTTON,
                           [wm.WM_LBUTTONUP] = vkeys.VK_LBUTTON,
                           [wm.WM_RBUTTONDOWN] = vkeys.VK_RBUTTON,
                           [wm.WM_RBUTTONUP] = vkeys.VK_RBUTTON,
                           [wm.WM_MBUTTONDOWN] = vkeys.VK_MBUTTON,
                           [wm.WM_MBUTTONUP] = vkeys.VK_MBUTTON,
                        }
local tXButtonMessage = {
                           [wm.WM_XBUTTONUP] = true,
                           [wm.WM_XBUTTONDOWN] = true,
                           [wm.WM_XBUTTONDBLCLK] = true,
                        }
local tXButtonMouseData = {
                           vkeys.VK_XBUTTON1,
                           vkeys.VK_XBUTTON2
                        }
local tDownMessages = {
                        [wm.WM_KEYDOWN] = true,
                        [wm.WM_SYSKEYDOWN] = true,
                        [wm.WM_LBUTTONDOWN] = true,
                        [wm.WM_RBUTTONDOWN] = true,
                        [wm.WM_MBUTTONDOWN] = true,
                        [wm.WM_XBUTTONDOWN] = true,
                        [wm.WM_LBUTTONDBLCLK] = true,
                        [wm.WM_RBUTTONDBLCLK] = true,
                        [wm.WM_MBUTTONDBLCLK] = true,
                        [wm.WM_XBUTTONDBLCLK] = true,
                        [wm.WM_MOUSEWHEEL] = true
                     }
local tHotKeys = {}
local tActKeys = {}
local hkId = 0
local mod = {}
--- Текущая версия модуля
mod._VERSION = "2.1.1"
--- Список клавиш модификаторов включая расширеные версии
mod._MODKEYS = tModKeysList
--- Определяет нужно ли блокировать нажатия для окна при нажатии любого зарегистрированного сочетания
mod._LOCKKEYS = false
--- Псевдо-клавиши для WM_MOUSEWHEEL
mod.vkeys = {
   VK_WHEELDOWN = 0x100,
   VK_WHEELUP = 0x101
}
--- Названия псевдо-клавиш
mod.vkeys.names = {
   [mod.vkeys.VK_WHEELDOWN] = "Mouse Wheel Down",
   [mod.vkeys.VK_WHEELUP] = "Mouse Wheel Up",
}

local id_to_name = function(id)
   local name = vkeys.id_to_name(id) or mod.vkeys.names[id]
   return name
end
local HIWORD = function(param)
	return bit.rshift(bit.band(param, 0xffff0000), 16);
end
local splitsigned = function(n) -- СПАСИБО WINAPI.lua и GITHUB и Chat mimgui
	n = tonumber(n)
	local x, y = bit.band(n, 0xffff), bit.rshift(n, 16)
	if x >= 0x8000 then x = x-0xffff end
	if y >= 0x8000 then y = y-0xffff end
	return x, y
end

addEventHandler("onWindowMessage", function (message, wparam, lparam)
   if tMessageTrigger[message] then
      local scancode = bitex.bextract(lparam, 16, 8)
      local keystate = bitex.bextract(lparam, 30, 1)
      local keyex = bitex.bextract(lparam, 24, 1)
      if tXButtonMessage[message] then
         local btn = HIWORD(wparam)
         wparam = tXButtonMouseData[btn]
      elseif message == wm.WM_MOUSEWHEEL then
         local btn, delta = splitsigned(ffi.cast('int32_t', wparam))
         if delta < 0 then
            wparam = mod.vkeys.VK_WHEELDOWN
         elseif delta > 0 then
            wparam = mod.vkeys.VK_WHEELUP
         end
      elseif tRewriteMouseKeys[message] then
         wparam = tRewriteMouseKeys[message]
      end
      local keydown = mod.isKeyExist(wparam)
      if tDownMessages[message] then
         if not keydown and keystate == 0 then
            table.insert(tCurKeys, wparam)
            if tModKeys[wparam] then
               local exKey = mod.getExtendedKeys(wparam, scancode, keyex)
               if exKey then
                  table.insert(tCurKeys, exKey)
               end
            end
         end
         for k, v in ipairs(tHotKeys) do
            if v.aType ~= 3 and (tActKeys[v.id] == nil or v.aType == 2)
               and ((v.aType == 1 and keystate == 0) or v.aType == 2)
               and mod.isKeyComboExist(v.keys)
               and (not mod.isKeysExist(tModKeysList, v.keys) and not mod.isKeysExist(tModKeysList) or mod.isKeysExist(tModKeysList, v.keys))
               and (mod.onHotKey == nil or (mod.onHotKey and mod.onHotKey(v.id, v) ~= false))
            then
               lua_thread.create(function()
                  wait(0)
                  v.callback(v)
               end)
               tActKeys[v.id] = true
            end
            if v.isBlock and (tActKeys[v.id] or v.aType == 2) or (tActKeys[v.id] and not v.isBlock and mod._LOCKKEYS) then
               consumeWindowMessage()
            end
         end
      else
         for k, v in ipairs(tHotKeys) do
            if v.aType == 3 and keystate == 1 and mod.isKeyComboExist(v.keys)
               and (mod.onHotKey == nil or (mod.onHotKey and mod.onHotKey(v.id, v) ~= false))
               then
               v.callback(v)
            end
         end
         if keydown then
            local pos = mod.getKeyPosition(wparam)
            table.remove(tCurKeys, pos)
            if tModKeys[wparam] then
               local exKey = mod.getExtendedKeys(wparam, scancode, keyex)
               if exKey then
                  pos = mod.getKeyPosition(exKey)
                  table.remove(tCurKeys, pos)
               end
            end
         end
      end
      if message == wm.WM_MOUSEWHEEL then
         local pos = mod.getKeyPosition(wparam)
         table.remove(tCurKeys, pos)
      end
      for k, v in ipairs(tHotKeys) do
         if v.aType == 2 or tActKeys[v.id] and not mod.isKeyComboExist(v.keys) then
            tActKeys[v.id] = nil
         end
      end
   elseif message == wm.WM_KILLFOCUS then
      tCurKeys = {}
   end
end)

--- Регистрирует новое сочетание клавиш. Параметр isBlock можно опустить
---@param keycombo table
---@param activationType integer
---@param isBlock_or_callback boolean|function
---@param callback function
---@return integer
function mod.registerHotKey(keycombo, activationType, isBlock_or_callback, callback)
   local newId = hkId + 1
   tHotKeys[#tHotKeys + 1] = {
      keys = keycombo,
      aType = activationType,
      callback = type(isBlock_or_callback) == "function" and isBlock_or_callback or callback,
      id = newId,
      isBlock = type(isBlock_or_callback) == "boolean" and isBlock_or_callback or false
   }
   hkId = hkId + 1
   return newId
end

--- Проверяет существует ли указанное комбо. Первым параметром возвращает результат проверки, вторым количество найденых комбо.
---@param keycombo_or_id table|integer
---@return boolean,integer
function mod.isHotKeyDefined(keycombo_or_id)
   local bool = false
   local count = 0
   if type(keycombo_or_id) == "number" then
      for k, v in ipairs(tHotKeys) do
         if v.id == keycombo_or_id then
            bool = true
            count = count + 1
         end
      end
   elseif type(keycombo_or_id) == "table" then
      for k, v in ipairs(tHotKeys) do
         if mod.compareKeys(v.keys, keycombo_or_id) then
            bool = true
            count = count + 1
         end
      end
   end
   return bool, count
end

--- Возвращает данные хоткея по ID или комбо клавиш. Возвращает результат поиска и таблицу данных.
---@param keycombo_or_id table|integer
---@return boolean,table
function mod.getHotKey(keycombo_or_id)
   local bool = false
   local data = {}
   if type(keycombo_or_id) == "number" then
      for k, v in ipairs(tHotKeys) do
         if v.id == keycombo_or_id then
            bool = true
            data = v
            break
         end
      end
   elseif type(keycombo_or_id) == "table" then
      for k, v in ipairs(tHotKeys) do
         if mod.compareKeys(v.keys, keycombo_or_id) then
            bool = true
            data = v
            break
         end
      end
   end
   return bool, data
end

---Изменяет комбо клавиш для хоткея. Возвращает результат изменения.
---@param id integer
---@param keycombo table
---@return boolean
function mod.changeHotKey(id, keycombo)
   local bool = false
   for k, v in ipairs(tHotKeys) do
      if v.id == id then
         bool = true
         v.keys = keycombo
      end
   end
   return bool
end

--- Удаляет комбо. Первым параметром возвращает результат удаления, вторым количество удаленных комбо.
---@param keycombo_or_id table|integer
---@return boolean,integer
function mod.unRegisterHotKey(keycombo_or_id)
   local bool = false
   local count = 0
   local idsToRemove = {}
   if type(keycombo_or_id) == "number" then
      for k, v in ipairs(tHotKeys) do
         if v.id == keycombo_or_id then
            bool = true
            count = count + 1
            table.insert(idsToRemove, k)
         end
      end
   elseif type(keycombo_or_id) == "table" then
      for k, v in ipairs(tHotKeys) do
         if mod.compareKeys(v.keys, keycombo_or_id) then
            bool = true
            count = count + 1
            table.insert(idsToRemove, k)
         end
      end
   end
   for k, v in ipairs(idsToRemove) do
      table.remove(tHotKeys, v)
   end
   return bool, count
end

--- Проверяет активен ли хоткей keycombo в списке keylist. Если опущен keylist - использует текущие нажатые клавиши.
---@param keycombo table
---@param keylist table
---@return boolean
function mod.isKeyComboExist(keycombo, keylist)
   keylist = keylist or tCurKeys
   local b = false
   local i = 1
   for k, v in ipairs(keylist) do
      if v == keycombo[i] then
         if i == #keycombo then
            b = true
            break
         end
         i = i + 1
      end
   end
   return b
end

--- Сравнивает два комбо
---@param keycombo table
---@param keycombotwo table
---@return boolean
function mod.compareKeys(keycombo, keycombotwo)
   local b = true
   for k, v in ipairs(keycombo) do
      if keycombotwo[k] ~= v then
         b = false
         break
      end
   end
   return b
end

--- Ищет keyid в списке keylist. В отличии от isKeyComboExist не ищет несколько клавиш, а только одну с указанной датой.
---@param keyid integer
---@param keylist table
---@return boolean
function mod.isKeyExist(keyid, keylist)
   keylist = keylist or tCurKeys
   for k, v in ipairs(keylist) do
      if tonumber(v) == tonumber(keyid) then
         return true
      end
   end
   return false
end

--- Ищет несколько id из списка keyids в keylist. Возвращает истину если найден хотябы один id из keyids
---@param keyids table
---@param keylist table
---@return boolean
function mod.isKeysExist(keyids, keylist)
   keylist = keylist or tCurKeys
   for k, v in ipairs(keyids) do
      for kk, vv in ipairs(keylist) do
         if v == vv then
            return true
         end
      end
   end
   return false
end

--- Аналог isKeyExist, но возвращает позицию в keylist если находит.
---@param keyid integer
---@param keylist table
---@return integer|nil
function mod.getKeyPosition(keyid, keylist)
   keylist = keylist or tCurKeys
   for k, v in ipairs(keylist) do
      if v == keyid then
         return k
      end
   end
   return nil
end

--- Получает расширеные версии Alt, Shift, Ctrl на основе сканкода и расширения.
---@param keyid integer
---@param scancode integer
---@param extend integer
---@return integer|nil
function mod.getExtendedKeys(keyid, scancode, extend)
   local newKeyId = nil
   if keyid == vkeys.VK_MENU then
      if extend == 1 then
         newKeyId = vkeys.VK_RMENU
      else
         newKeyId = vkeys.VK_LMENU
      end
   elseif keyid == vkeys.VK_SHIFT then
      if scancode == 42 then
         newKeyId = vkeys.VK_LSHIFT
      elseif scancode == 54 then
         newKeyId = vkeys.VK_RSHIFT
      end
   elseif keyid == vkeys.VK_CONTROL then
      if extend == 1 then
         newKeyId = vkeys.VK_RCONTROL
      else
         newKeyId = vkeys.VK_LCONTROL
      end
   end
   return newKeyId
end

--- Возвращает список текущих нажатых клавиш в формате скрипта. В качестве аргумента принимает то какие нужно выводить данные. Только ИД, нужно ли название клавиш
---@param keyname boolean
---@param keyscan boolean
---@param keyex boolean
---@return table
function mod.getKeys(keyname, keyscan, keyex)
   keyname = keyname or false
   local szKeys = {}
   for k, v in ipairs(tCurKeys) do
      table.insert(szKeys, ("%s%s"):format(tostring(v), (keyname and ":" .. id_to_name(v) or "")))
   end
   return szKeys
end

--- Возвращает колличество нажатых клавиш
---@return integer
function mod.getCountKeys()
   return #tCurKeys
end

return mod