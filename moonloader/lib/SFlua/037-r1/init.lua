--[[
    Project: SF.lua <https://github.com/imring/SF.lua>
    License: GNU General Public License v3.0
    Authors: look in file <AUTHORS>.
]]

local memory = require 'memory'
local ffi = require 'ffi'

require 'SFlua.037-r1.cdef'
local add = require 'SFlua.addition'
local bs = require 'SFlua.bitstream'

local SAMP_INFO								= 0x21A0F8
local SAMP_DIALOG_INFO						= 0x21A0B8
local SAMP_MISC_INFO						= 0x21A10C
local SAMP_INPUIT_INFO						= 0x21A0E8
local SAMP_CHAT_INFO						= 0x21A0E4
local SAMP_COLOR							= 0x216378
local SAMP_KILL_INFO						= 0x21A0EC
local SAMP_SCOREBOARD_INFO					= 0x21A0B4
local SAMP_ANIM								= 0xF15B0

local samp_C = {
    -- stSAMP
    sendSCM = ffi.cast('void(__cdecl *)(void *this, int type, WORD id, int param1, int param2)', sampGetBase() + 0x1A50),
    sendGiveDmg = ffi.cast('void(__stdcall *)(WORD id, float damage, DWORD weapon, DWORD bodypart)', sampGetBase() + 0x6770),
    sendTakeDmg = ffi.cast('void(__stdcall *)(WORD id, float damage, DWORD weapon, DWORD bodypart)', sampGetBase() + 0x6660),
    sendReqSpwn = ffi.cast('void(__cdecl *)()', sampGetBase() + 0x3A20),

    -- stDialogInfo
    showDialog = ffi.cast('void(__thiscall *)(void* this, WORD wID, BYTE iStyle, PCHAR szCaption, PCHAR szText, PCHAR szButton1, PCHAR szButton2, bool bSend)', sampGetBase() + 0x6B9C0),
    closeDialog = ffi.cast('void(__thiscall *)(void* this, int button)', sampGetBase() + 0x6C040),
    getElementSturct = ffi.cast('char*(__thiscall *)(void* this, int a, int b)', sampGetBase() + 0x82C50),
    getEditboxText = ffi.cast('char*(__thiscall *)(void* this)', sampGetBase() + 0x81030),
    setEditboxText = ffi.cast('void(__thiscall *)(void* this, char* text, int i)', sampGetBase() + 0x80F60),

    -- stGameInfo
    showCursor = ffi.cast('void (__thiscall*)(void* this, int type, bool show)', sampGetBase() + 0x9BD30),
    cursorUnlockActorCam = ffi.cast('void (__thiscall*)(void* this)', sampGetBase() + 0x9BC10),

    -- stPlayerPool
    reqSpawn = ffi.cast('void(__thiscall*)(void* this)', sampGetBase() + 0x3EC0),
    spawn = ffi.cast('void(__thiscall*)(void* this)', sampGetBase() + 0x3AD0),
    say = ffi.cast('void(__thiscall *)(void* this, PCHAR message)', sampGetBase() + 0x57F0),
    reqClass = ffi.cast('void(__thiscall *)(void* this, int classId)', sampGetBase() + 0x56A0),
    sendInt = ffi.cast('void (__thiscall *)(void* this, BYTE interiorID)', sampGetBase() + 0x5740),
    forceUnocSync = ffi.cast('void (__thiscall *)(void* this, WORD id, BYTE seat)', sampGetBase() + 0x4B30),
    setAction = ffi.cast('void( __thiscall*)(void* this, BYTE specialActionId)', sampGetBase() + 0x30C0),
    setName = ffi.cast('void(__thiscall *)(int this, const char *name, int len)', sampGetBase() + 0xB290),
    sendEnterVehicle = ffi.cast('void (__thiscall*)(void* this, int id, bool passenger)', sampGetBase() + 0x58C0),
    sendExitVehicle = ffi.cast('void (__thiscall*)(void* this, int id)', sampGetBase() + 0x59E0),

    -- stInputInfo
    sendCMD = ffi.cast('void(__thiscall *)(void* this, PCHAR message)', sampGetBase() + 0x65C60),
    regCMD = ffi.cast('void(__thiscall *)(void* this, PCHAR command, CMDPROC function)', sampGetBase() + 0x65AD0),
    enableInput = ffi.cast('void(__thiscall *)(void* this)', sampGetBase() + 0x6AD30),
    disableInput = ffi.cast('void(__thiscall *)(void* this)', sampGetBase() + 0x658E0),

    -- stTextdrawPool
    createTextDraw = ffi.cast('void(__thiscall *)(void* this, WORD id, struct SFL_TextDrawTransmit* transmit, PCHAR text)', sampGetBase() + 0x1AE20),
    deleteTextDraw = ffi.cast('void(__thiscall *)(void* this, WORD id)', sampGetBase() + 0x1AD00),

    -- stScoreboardInfo
    enableScoreboard = ffi.cast('void (__thiscall *)(void *this)', sampGetBase() + 0x6AD30),
    disableScoreboard = ffi.cast('void (__thiscall *)(void* this, bool disableCursor)', sampGetBase() + 0x658E0),

    -- stTextLabelPool
    createTextLabel = ffi.cast('int (__thiscall *)(void* this, WORD id, PCHAR text, DWORD color, float x, float y, float z, float dist, bool ignoreWalls, WORD attachPlayerId, WORD attachCarId)', sampGetBase() + 0x11C0),
    deleteTextLabel = ffi.cast('void(__thiscall *)(void* this, WORD id)', sampGetBase() + 0x12D0),

    -- stChatInfo
    addMessage = ffi.cast('void(__thiscall *)(void* this, int Type, PCSTR szString, PCSTR szPrefix, DWORD TextColor, DWORD PrefixColor)', sampGetBase() + 0x64010),

    -- stKillInfo
    sendDeathMessage = ffi.cast('void(__thiscall*)(void *this, PCHAR killer, PCHAR killed, DWORD clKiller, DWORD clKilled, BYTE reason)', sampGetBase() + 0x66930),

    -- BitStream
    readDecodeString = ffi.cast('void (__thiscall*)(void* this, char* buf, size_t size_buf, SFL_BitStream* bs, int unk)', sampGetBase() + 0x507E0),
    writeEncodeString = ffi.cast('void (__thiscall*)(void* this, const char* str, size_t size_str, SFL_BitStream* bs, int unk)', sampGetBase() + 0x506B0)
}

--- Standart functions

-- Pointers to structures

function sampGetSampInfoPtr()
    assert(isSampLoaded(), 'SA-MP is not loaded.')
    return memory.getint32( sampGetBase() + SAMP_INFO )
end

function sampGetDialogInfoPtr()
    assert(isSampLoaded(), 'SA-MP is not loaded.')
    return memory.getint32( sampGetBase() + SAMP_DIALOG_INFO )
end

function sampGetMiscInfoPtr()
    assert(isSampLoaded(), 'SA-MP is not loaded.')
    return memory.getint32( sampGetBase() + SAMP_MISC_INFO )
end

function sampGetInputInfoPtr()
    assert(isSampLoaded(), 'SA-MP is not loaded.')
    return memory.getint32( sampGetBase() + SAMP_INPUIT_INFO )
end

function sampGetChatInfoPtr()
    assert(isSampLoaded(), 'SA-MP is not loaded.')
    return memory.getint32( sampGetBase() + SAMP_CHAT_INFO )
end

function sampGetKillInfoPtr()
    assert(isSampLoaded(), 'SA-MP is not loaded.')
    return memory.getint32( sampGetBase() + SAMP_KILL_INFO )
end

function sampGetSampPoolsPtr()
    assert(isSampAvailable(), 'SA-MP is not available.')
    return add.GET_POINTER(samp_C.pools)
end

function sampGetServerSettingsPtr()
    assert(isSampAvailable(), 'SA-MP is not available.')
    return add.GET_POINTER(samp_C.samp.pSettings)
end

function sampGetTextdrawPoolPtr()
    assert(isSampAvailable(), 'SA-MP is not available.')
    return add.GET_POINTER(samp_C.textdraw)
end

function sampGetObjectPoolPtr()
    assert(isSampAvailable(), 'SA-MP is not available.')
    return add.GET_POINTER(samp_C.object)
end

function sampGetGangzonePoolPtr()
    assert(isSampAvailable(), 'SA-MP is not available.')
    return add.GET_POINTER(samp_C.gangzone)
end

function sampGetTextlabelPoolPtr()
    assert(isSampAvailable(), 'SA-MP is not available.')
    return add.GET_POINTER(samp_C.text3d)
end

function sampGetPlayerPoolPtr()
    assert(isSampAvailable(), 'SA-MP is not available.')
    return add.GET_POINTER(samp_C.player)
end

function sampGetVehiclePoolPtr()
    assert(isSampAvailable(), 'SA-MP is not available.')
    return add.GET_POINTER(samp_C.car)
end

function sampGetPickupPoolPtr()
    assert(isSampAvailable(), 'SA-MP is not available.')
    return add.GET_POINTER(samp_C.pickup)
end

function sampGetRakclientInterface()
    assert(isSampAvailable(), 'SA-MP is not available.')
    return add.GET_POINTER(samp_C.samp.pRakClientInterface)
end

local availables = {
    { 'sampGetSampInfoPtr', 'samp', 'SAMP' },
    { 'sampGetDialogInfoPtr', 'dialog', 'DialogInfo' },
    { 'sampGetMiscInfoPtr', 'misc', 'GameInfo' },
    { 'sampGetInputInfoPtr', 'input', 'InputInfo' },
    { 'sampGetChatInfoPtr', 'chat', 'ChatInfo' },
    { 'sampGetKillInfoPtr', 'killinfo', 'KillInfo' },
    { 'sampGetScoreboardInfoPtr', 'scoreboard', 'ScoreboardInfo' }
}

function isSampAvailable()
    assert(isSampLoaded(), 'SA-MP is not loaded.')
    local addr, result = 0, true
    for i = 1, #availables do
        local ptr = availables[i]
        addr = _G[ ptr[1] ]()
        result = result and addr > 0
        if result then
            samp_C[ ptr[2] ] = ffi.cast('struct SFL_' .. ptr[3] .. '*', addr)
        else
            return result
        end
    end
    local anim_list = ffi.new('char[1811][36]')
    ffi.copy(anim_list, ffi.cast('void*', sampGetBase() + SAMP_ANIM), ffi.sizeof(anim_list))
    samp_C.color_table = ffi.cast('DWORD*', sampGetBase() + SAMP_COLOR)
    samp_C.anim_list = anim_list

    samp_C.pools = samp_C.samp.pPools
    samp_C.player = samp_C.pools.pPlayer
    samp_C.textdraw = samp_C.pools.pTextdraw
    samp_C.object = samp_C.pools.pObject
    samp_C.gangzone = samp_C.pools.pGangzone
    samp_C.text3d = samp_C.pools.pText3D
    samp_C.car = samp_C.pools.pVehicle
    samp_C.pickup = samp_C.pools.pPickup

    return result
end

-- stSAMP

function sampGetCurrentServerName()
    assert(isSampAvailable(), 'SA-MP is not available.')
    return ffi.string(samp_C.samp.szHostname)
end

function sampGetCurrentServerAddress()
    assert(isSampAvailable(), 'SA-MP is not available.')
    return ffi.string(samp_C.samp.szIP), samp_C.samp.ulPort
end

function sampGetGamestate()
    assert(isSampAvailable(), 'SA-MP is not available.')
    local states = {
        [0] = GAMESTATE_NONE,
        [9] = GAMESTATE_WAIT_CONNECT,
        [15] = GAMESTATE_AWAIT_JOIN,
        [14] = GAMESTATE_CONNECTED,
        [18] = GAMESTATE_RESTARTING,
        [13] = GAMESTATE_DISCONNECTED
    }
    return states[samp_C.samp.iGameState]
end

function sampSetGamestate(gamestate)
    assert(isSampAvailable(), 'SA-MP is not available.')
    gamestate = tonumber(gamestate) or 0
    local states = {
        [0] = 0, 9, 15, 14, 18, 13
    }
    samp_C.samp.iGameState = states[gamestate]
end

function sampSendScmEvent(event, id, param1, param2)
    assert(isSampAvailable(), 'SA-MP is not available.')
    samp_C.sendSCM(id, event, param1, param1)
end

function sampSendGiveDamage(id, damage, weapon, bodypart)
    assert(isSampAvailable(), 'SA-MP is not available.')
    samp_C.sendGiveDmg(id, damage, weapon, bodypart)
end

function sampSendTakeDamage(id, damage, weapon, bodypart)
    assert(isSampAvailable(), 'SA-MP is not available.')
    samp_C.sendTakeDmg(id, damage, weapon, bodypart)
end

function sampSendRequestSpawn()
    assert(isSampAvailable(), 'SA-MP is not available.')
    samp_C.sendReqSpwn()
end

function sampSetSendrate(type, rate)
    assert(isSampAvailable(), 'SA-MP is not available.')
    type = tonumber(type) or 0
    rate = tonumber(rate) or 0
    local addrs = {
        0xEC0A8, 0xEC0AC, 0xEC0B0
    }
    if addrs[type] then
        memory.setuint32(sampGetBase() + addrs[type], rate, true)
    end
end

function sampGetAnimationNameAndFile(id)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    local name, file = ffi.string(samp_C.anim_list[id - 1]):match('(.*):(.*)')
    return name or '', file or ''
end

function sampFindAnimationIdByNameAndFile(file, name)
    assert(isSampAvailable(), 'SA-MP is not available.')
    for i = 0, ffi.sizeof(samp_C.anim_list) / 36 do
        local n, f = sampGetAnimationNameAndFile(i)
        if n == name and f == file then return i end
    end
    return -1
end

-- stDialogInfo

function sampIsDialogActive()
    assert(isSampAvailable(), 'SA-MP is not available.')
    return samp_C.dialog.iIsActive == 1
end

function sampGetDialogCaption()
    assert(isSampAvailable(), 'SA-MP is not available.')
    return ffi.string(samp_C.dialog.szCaption)
end

function sampGetCurrentDialogId()
    assert(isSampAvailable(), 'SA-MP is not available.')
    return samp_C.dialog.DialogID
end

function sampGetDialogText()
    assert(isSampAvailable(), 'SA-MP is not available.')
    return ffi.string(samp_C.dialog.pText)
end

function sampGetCurrentDialogType()
    assert(isSampAvailable(), 'SA-MP is not available.')
    return samp_C.dialog.iType
end

function sampShowDialog(id, caption, text, button1, button2, style)
    assert(isSampAvailable(), 'SA-MP is not available.')
    local caption = ffi.cast('PCHAR', tostring(caption))
    local text = ffi.cast('PCHAR', tostring(text))
    local button1 = ffi.cast('PCHAR', tostring(button1))
    local button2 = ffi.cast('PCHAR', tostring(button2))
    samp_C.showDialog(samp_C.dialog, id, style, caption, text, button1, button2, false)
end

function sampGetCurrentDialogListItem()
    assert(isSampAvailable(), 'SA-MP is not available.')
    local list = getStructElement(sampGetDialogInfoPtr(), 0x20, 4)
    return getStructElement(list, 0x143 --[[m_nSelected]], 4)
end

function sampSetCurrentDialogListItem(number)
    assert(isSampAvailable(), 'SA-MP is not available.')
    local list = getStructElement(sampGetDialogInfoPtr(), 0x20, 4)
    return setStructElement(list, 0x143 --[[m_nSelected]], 4, tonumber(number) or 0)
end

function sampCloseCurrentDialogWithButton(button)
    assert(isSampAvailable(), 'SA-MP is not available.')
    samp_C.closeDialog(samp_C.dialog, button)
end

function sampGetCurrentDialogEditboxText()
    assert(isSampAvailable(), 'SA-MP is not available.')
    local char = samp_C.getEditboxText(samp_C.dialog.pEditBox)
    return ffi.string(char)
end

function sampSetCurrentDialogEditboxText(text)
    assert(isSampAvailable(), 'SA-MP is not available.')
    samp_C.setEditboxText(samp_C.dialog.pEditBox, ffi.cast('PCHAR', text), 0)
end

function sampIsDialogClientside()
    assert(isSampAvailable(), 'SA-MP is not available.')
    return samp_C.dialog.bServerside ~= 0
end

function sampSetDialogClientside(client)
    assert(isSampAvailable(), 'SA-MP is not available.')
    samp_C.dialog.bServerside = client and 0 or 1
end

function sampGetListboxItemsCount()
    assert(isSampAvailable(), 'SA-MP is not available.')
    return memory.getint32(add.GET_POINTER(samp_C.dialog.pList) + 0x150, true)
end

function sampGetListboxItemText(list)
    assert(isSampAvailable(), 'SA-MP is not available.')
    list = tonumber(list) or 0
    if list >= 0 and sampGetListboxItemsCount() - 1 >= list then
        local data = ffi.cast('struct DXUTComboBoxItem**', memory.getuint32(add.GET_POINTER(samp_C.dialog.pList) + 0x14C))
        return ffi.string(data[list][0].strText)
    end
    return ''
end


-- stGameInfo

function sampToggleCursor(showed)
    assert(isSampAvailable(), 'SA-MP is not available.')
    samp_C.showCursor(samp_C.misc, showed == true and CMODE_LOCKCAM or CMODE_DISABLED, showed)
    if showed ~= true then samp_C.cursorUnlockActorCam(samp_C.misc) end
end

function sampIsCursorActive()
    assert(isSampAvailable(), 'SA-MP is not available.')
    return samp_C.misc.iCursorMode > 0
end

function sampGetCursorMode()
    assert(isSampAvailable(), 'SA-MP is not available.')
    return samp_C.misc.iCursorMode
end

function sampSetCursorMode(mode)
    assert(isSampAvailable(), 'SA-MP is not available.')
    samp_C.misc.iCursorMode = tonumber(mode) or 0
end

-- stPlayerPool

function sampIsPlayerConnected(id)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    if id >= 0 and id < MAX_PLAYERS then
        return samp_C.player.iIsListed[id] == 1 or sampGetLocalPlayerId() == id
    end
    return false
end

function sampGetPlayerNickname(id)
    assert(isSampAvailable(), 'SA-MP is not available.')
    local point
    if sampGetLocalPlayerId() == id then point = samp_C.player.strLocalPlayerName
    elseif sampIsPlayerConnected(id) then point = samp_C.player.pRemotePlayer[id].strPlayerName end
    return point and ffi.string(point.str) or ''
end

function sampSpawnPlayer()
    assert(isSampAvailable(), 'SA-MP is not available.')
    samp_C.reqSpawn(samp_C.player.pLocalPlayer)
    samp_C.spawn(samp_C.player.pLocalPlayer)
end

function sampSendChat(msg)
    assert(isSampAvailable(), 'SA-MP is not available.')
    local char = ffi.cast('PCHAR', tostring(msg))
    if char[0] == 47 then -- character "/"
        samp_C.sendCMD(samp_C.input, char)
    else
        samp_C.say(samp_C.player.pLocalPlayer, char)
    end
end

function sampIsPlayerNpc(id)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    return sampIsPlayerConnected(id) and samp_C.player.pRemotePlayer[id].iIsNPC == 1
end

function sampGetPlayerScore(id)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    local score = 0
    if sampGetLocalPlayerId() == id then score = samp_C.player.iLocalPlayerScore
    elseif sampIsPlayerConnected(id) then score = samp_C.player.pRemotePlayer[id].iScore end
    return score
end

function sampGetPlayerPing(id)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    local ping = 0
    if sampGetLocalPlayerId() == id then ping = samp_C.player.iLocalPlayerPing
    elseif sampIsPlayerConnected(id) then ping = samp_C.player.pRemotePlayer[id].iPing end
    return ping
end

function sampRequestClass(class)
    assert(isSampAvailable(), 'SA-MP is not available.')
    class = tonumber(class) or 0
    samp_C.reqClass(samp_C.player.pLocalPlayer, class)
end

function sampGetPlayerColor(id)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    if sampIsPlayerConnected(id) or sampGetLocalPlayerId() == id then
        return add.convertRGBAToARGB(samp_C.color_table[id])
    end
end

function sampSendInteriorChange(id)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    samp_C.sendInt(samp_C.player.pLocalPlayer, id)
end

function sampForceUnoccupiedSyncSeatId(id, seat)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    seat = tonumber(seat) or 0
    samp_C.forceUnocSync(samp_C.player.pLocalPlayer, id, seat)
end

function sampGetCharHandleBySampPlayerId(id)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    if id == sampGetLocalPlayerId() then return true, playerPed
    elseif sampIsPlayerDefined(id) then
        return true, getCharPointerHandle(add.GET_POINTER(samp_C.player.pRemotePlayer[id].pPlayerData.pSAMP_Actor.pGTA_Ped))
    end
    return false, -1
end

function sampGetPlayerIdByCharHandle(ped)
    assert(isSampAvailable(), 'SA-MP is not available.')
    ped = tonumber(ped) or 0
    if ped == playerPed then return true, sampGetLocalPlayerId() end
    for i = 0, MAX_PLAYERS - 1 do
        local res, pped = sampGetCharHandleBySampPlayerId(i)
        if res and pped == ped then return true, i end
    end
    return false, -1
end

function sampGetPlayerArmor(id)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    if sampIsPlayerDefined(id) then
        if id == sampGetLocalPlayerId() then return getCharArmour(playerPed) end
        return samp_C.player.pRemotePlayer[id].pPlayerData.fActorArmor
    end
    return 0
end

function sampGetPlayerHealth(id)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    if sampIsPlayerDefined(id) then
        if id == sampGetLocalPlayerId() then return getCharHealth(playerPed) end
        return samp_C.player.pRemotePlayer[id].pPlayerData.fActorHealth
    end
    return 0
end

function sampSetSpecialAction(action)
    assert(isSampAvailable(), 'SA-MP is not available.')
    action = tonumber(action) or 0
    if sampIsPlayerDefined(sampGetLocalPlayerId()) then
        samp_C.setAction(samp_C.player.pLocalPlayer, action)
    end
end

function sampGetPlayerCount(streamed)
    assert(isSampAvailable(), 'SA-MP is not available.')
    if not streamed then return samp_C.scoreboard.iPlayersCount - 1 end
    local players = 0
    for i = 0, MAX_PLAYERS - 1 do
        if i ~= sampGetLocalPlayerId() then
            local bool = false
            local res, ped = sampGetCharHandleBySampPlayerId(i)
            bool = res and doesCharExist(ped)
            if bool then players = players + 1 end
        end
    end
    return players
end

function sampGetMaxPlayerId(streamed)
    assert(isSampAvailable(), 'SA-MP is not available.')
    local mid = sampGetLocalPlayerId()
    for i = 0, MAX_PLAYERS - 1 do
        if i ~= sampGetLocalPlayerId() then
            local bool = false
            if streamed then
                local res, ped = sampGetCharHandleBySampPlayerId(i)
                bool = res and doesCharExist(ped)
            else bool = sampIsPlayerConnected(i) end
            if bool and i > mid then mid = i end
        end
    end
    return mid
end

function sampGetPlayerSpecialAction(id)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    if sampIsPlayerConnected(id) then return samp_C.player.pRemotePlayer[i].pPlayerData.byteSpecialAction end
    return -1
end

function sampStorePlayerOnfootData(id, data)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    data = tonumber(data) or 0
    local struct
    if id == sampGetLocalPlayerId() then struct = samp_C.player.pLocalPlayer.onFootData
    elseif sampIsPlayerDefined(id) then struct = samp_C.player.pRemotePlayer[id].pPlayerData.onFootData end
    if struct then memory.copy(data, add.GET_POINTER(struct), ffi.sizeof('struct onFootData')) end
end

function sampIsPlayerPaused(id)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    if id == sampGetLocalPlayerId() then return false end
    if sampIsPlayerConnected(id) then return samp_C.player.pRemotePlayer[id].pPlayerData.iAFKState == 0 end
end

function sampStorePlayerIncarData(id, data)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    data = tonumber(data) or 0
    local struct
    if id == sampGetLocalPlayerId() then struct = samp_C.player.pLocalPlayer.inCarData
    elseif sampIsPlayerDefined(id) then struct = samp_C.player.pRemotePlayer[id].pPlayerData.inCarData end
    if struct then memory.copy(data, add.GET_POINTER(struct), ffi.sizeof('struct stInCarData')) end
end

function sampStorePlayerPassengerData(id, data)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    data = tonumber(data) or 0
    local struct
    if id == sampGetLocalPlayerId() then struct = samp_C.player.pLocalPlayer.passengerData
    elseif sampIsPlayerDefined(id) then struct = samp_C.player.pRemotePlayer[id].pPlayerData.passengerData end
    if struct then memory.copy(data, add.GET_POINTER(struct), ffi.sizeof('struct stPassengerData')) end
end

function sampStorePlayerTrailerData(id, data)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    data = tonumber(data) or 0
    local struct
    if id == sampGetLocalPlayerId() then struct = samp_C.player.pLocalPlayer.trailerData
    elseif sampIsPlayerDefined(id) then struct = samp_C.player.pRemotePlayer[id].pPlayerData.trailerData end
    if struct then memory.copy(data, add.GET_POINTER(struct), ffi.sizeof('struct stTrailerData')) end
end

function sampStorePlayerAimData(id, data)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    data = tonumber(data) or 0
    local struct
    if id == sampGetLocalPlayerId() then struct = samp_C.player.pLocalPlayer.aimData
    elseif sampIsPlayerDefined(id) then struct = samp_C.player.pRemotePlayer[id].pPlayerData.aimData end
    if struct then memory.copy(data, add.GET_POINTER(struct), ffi.sizeof('struct stAimData')) end
end

function sampSendSpawn()
    assert(isSampAvailable(), 'SA-MP is not available.')
    samp_C.spawn(samp_C.player.pLocalPlayer)
end

function sampGetPlayerAnimationId(id)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    if id == sampGetLocalPlayerId() then return samp_C.player.pLocalPlayer.sCurrentAnimID end
    if sampIsPlayerConnected(id) then return samp_C.player.pRemotePlayer[id].pPlayerData.onFootData.sCurrentAnimationID end
end

function sampSetLocalPlayerName(name)
    assert(isSampAvailable(), 'SA-MP is not available.')
    local name = tostring(name)
    assert(#name <= MAX_PLAYER_NAME, 'Limit name - '..MAX_PLAYER_NAME..'.')
    samp_C.setName(add.GET_POINTER(samp_C.player) + ffi.offsetof('struct stPlayerPool', 'pVTBL_txtHandler'), name, #name)
end

function sampGetPlayerStructPtr(id)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    if id == sampGetLocalPlayerId() then return add.GET_POINTER(samp_C.player.pLocalPlayer) end
    if sampIsPlayerConnected(id) then
        return add.GET_POINTER(samp_C.player.pRemotePlayer[id])
    end
end

function sampSendEnterVehicle(id, passenger)
    assert(isSampAvailable(), 'SA-MP is not available.')
    samp_C.sendEnterVehicle(samp_C.player.pLocalPlayer, id, passenger)
end

function sampSendExitVehicle(id)
    assert(isSampAvailable(), 'SA-MP is not available.')
    samp_C.sendExitVehicle(samp_C.player.pLocalPlayer, id)
end

function sampIsLocalPlayerSpawned()
    assert(isSampAvailable(), 'SA-MP is not available.')
    local local_player = samp_C.player.pLocalPlayer
    return local_player.iSpawnClassLoaded == 1 and local_player.iIsActorAlive == 1 and ( local_player.iIsActive == 1 or isCharDead(playerPed) )
end

-- stInputInfo

function sampUnregisterChatCommand(name)
    assert(isSampAvailable(), 'SA-MP is not available.')
    for i = 0, MAX_CLIENTCMDS - 1 do
        if ffi.string(samp_C.input.szCMDNames[i]) == tostring(name) then
            samp_C.input.szCMDNames[i] = ffi.new('char[33]') --ffi.new('char[?]', 33)
            samp_C.input.pCMDs[i] = nil
            samp_C.input.iCMDCount = samp_C.input.iCMDCount - 1
            return true
        end
    end
    return false
end

function sampRegisterChatCommand(name, function_)
    name = tostring(name)
    assert(isSampAvailable(), 'SA-MP is not available.')
    assert(type(function_) == 'function', '"'..tostring(function_)..'" is not function.')
    assert(samp_C.input.iCMDCount < MAX_CLIENTCMDS, 'Couldn\'t initialize "'..name..'". Maximum command amount reached.')
    assert(#name < 30, 'Command name "'..tostring(name)..'" was too long.')
    sampUnregisterChatCommand(name)
    local char = ffi.cast('PCHAR', name)
    local func = ffi.new('CMDPROC', function(args)
        function_(ffi.string(args))
    end)
    samp_C.regCMD(samp_C.input, char, func)
    return true
end

function sampSetChatInputText(text)
    assert(isSampAvailable(), 'SA-MP is not available.')
    samp_C.setEditboxText(samp_C.input.pDXUTEditBox, ffi.cast('PCHAR', text), 0)
end

function sampGetChatInputText()
    assert(isSampAvailable(), 'SA-MP is not available.')
    return ffi.string(samp_C.getEditboxText(samp_C.input.pDXUTEditBox))
end

function sampSetChatInputEnabled(enabled)
    assert(isSampAvailable(), 'SA-MP is not available.')
    samp_C[enabled and 'enableInput' or 'disableInput'](samp_C.input)
end

function sampIsChatInputActive()
    assert(isSampAvailable(), 'SA-MP is not available.')
    return samp_C.input.pDXUTEditBox.bIsChatboxOpen == 1
end

function sampIsChatCommandDefined(name)
    assert(isSampAvailable(), 'SA-MP is not available.')
    name = tostring(name)
    for i = 0, MAX_CLIENTCMDS - 1 do
        if ffi.string(samp_C.input.szCMDNames[i]) == name then return true end
    end
    return false
end

-- stChatInfo

function sampAddChatMessage(text, color)
    assert(isSampAvailable(), 'SA-MP is not available.')
    sampAddChatMessageEx(CHAT_TYPE_DEBUG, text, '', color, -1)
end

function sampGetChatDisplayMode()
    assert(isSampAvailable(), 'SA-MP is not available.')
    return samp_C.chat.iChatWindowMode
end

function sampSetChatDisplayMode(id)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    samp_C.chat.iChatWindowMode = id
end

function sampGetChatString(id)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    return ffi.string(samp_C.chat.chatEntry[id].szText), ffi.string(samp_C.chat.chatEntry[id].szPrefix), samp_C.chat.chatEntry[id].clTextColor, samp_C.chat.chatEntry[id].clPrefixColor
end

function sampSetChatString(id, text, prefix, color_t, color_p)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    samp_C.chat.chatEntry[id].szText = ffi.new('char[?]', 144, tostring(text))
    samp_C.chat.chatEntry[id].szPrefix = ffi.new('char[?]', 28, tostring(prefix))
    samp_C.chat.chatEntry[id].clTextColor = color_t
    samp_C.chat.chatEntry[id].clPrefixColor = color_p
end

function sampIsChatVisible()
    assert(isSampAvailable(), 'SA-MP is not available.')
    return sampGetChatDisplayMode() > 0
end

-- stTextdrawPool

function sampTextdrawIsExists(id)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    return samp_C.textdraw.iIsListed[id] == 1
end

function sampTextdrawCreate(id, text, x, y)
    assert(isSampAvailable(), 'SA-MP is not available.')
    local transmit = ffi.new('stTextDrawTransmit[1]', { { fX = x, fY = y } })
    samp_C.createTextDraw(samp_C.textdraw, transmit, ffi.cast('PCHAR', tostring(text)))
end

function sampTextdrawSetBoxColorAndSize(id, box, color, sizeX, sizeY)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    if sampTextdrawIsExists(id) then
        samp_C.textdraw.textdraw[id].byteBox = box
        samp_C.textdraw.textdraw[id].dwBoxColor = color
        samp_C.textdraw.textdraw[id].fBoxSizeX = sizeX
        samp_C.textdraw.textdraw[id].fBoxSizeY = sizeY
    end
end

function sampTextdrawGetString(id)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    if sampTextdrawIsExists(id) then
        return samp_C.textdraw.textdraw[id].szText
    end
    return ''
end

function sampTextdrawDelete(id)
    assert(isSampAvailable(), 'SA-MP is not available.')
    samp_C.deleteTextDraw(samp_C.textdraw, id)
end

function sampTextdrawGetLetterSizeAndColor(id)
    if sampTextdrawIsExists(id) then
        return samp_C.textdraw.textdraw[id].fLetterWidth, samp_C.textdraw.textdraw[id].fLetterHeight, add.convertABGRtoARGB(samp_C.textdraw.textdraw[id].dwLetterColor)
    end
end

function sampTextdrawGetPos(id)
    if sampTextdrawIsExists(id) then
        return samp_C.textdraw.textdraw[id].fX, samp_C.textdraw.textdraw[id].fY
    end
end

function sampTextdrawGetShadowColor(id)
    if sampTextdrawIsExists(id) then
        return samp_C.textdraw.textdraw[id].byteShadowSize, samp_C.textdraw.textdraw[id].dwShadowColor
    end
end

function sampTextdrawGetOutlineColor(id)
    if sampTextdrawIsExists(id) then
        return samp_C.textdraw.textdraw[id].byteOutline, samp_C.textdraw.textdraw[id].dwShadowColor
    end
end

function sampTextdrawGetStyle(id)
    if sampTextdrawIsExists(id) then
        return samp_C.textdraw.textdraw[id].iStyle
    end
end

function sampTextdrawGetProportional(id)
    if sampTextdrawIsExists(id) then
        return samp_C.textdraw.textdraw[id].byteProportional
    end
end

function sampTextdrawGetAlign(id)
    if sampTextdrawIsExists(id) then
        if samp_C.textdraw.textdraw[id].byteLeft == 1 then
            return 1
        elseif samp_C.textdraw.textdraw[id].byteCenter == 1 then
            return 2
        elseif samp_C.textdraw.textdraw[id].byteRight == 1 then
            return 3
        else
            return 0
        end
    end
end

function sampTextdrawGetBoxEnabledColorAndSize(id)
    if sampTextdrawIsExists(id) then
        return samp_C.textdraw.textdraw[id].byteBox, samp_C.textdraw.textdraw[id].dwBoxColor, samp_C.textdraw.textdraw[id].fBoxSizeX, samp_C.textdraw.textdraw[id].fBoxSizeY
    end
end

function sampTextdrawGetModelRotationZoomVehColor(id)
    if sampTextdrawIsExists(id) then
        return samp_C.textdraw.textdraw[id].sModel, samp_C.textdraw.textdraw[id].fRot[1], samp_C.textdraw.textdraw[id].fRot[2], samp_C.textdraw.textdraw[id].fRot[3], samp_C.textdraw.textdraw[id].fZoom, samp_C.textdraw.textdraw[id].sColor[1], samp_C.textdraw.textdraw[id].sColor[2]
    end
end

function sampTextdrawSetLetterSizeAndColor(id, letSizeX, letSizeY, color)
    if sampTextdrawIsExists(id) then
        samp_C.textdraw.textdraw[id].fLetterWidth = letSizeX
        samp_C.textdraw.textdraw[id].fLetterHeight = letSizeY
        samp_C.textdraw.textdraw[id].dwLetterColor = color
    end
end

function sampTextdrawSetPos(id, posX, posY)
    if sampTextdrawIsExists(id) then
        samp_C.textdraw.textdraw[id].fX = posX
        samp_C.textdraw.textdraw[id].fY = posY
    end
end

function sampTextdrawSetString(id, str)
    if sampTextdrawIsExists(id) then
        samp_C.textdraw.textdraw[id].szText = str
    end
end

function sampTextdrawSetModelRotationZoomVehColor(id, model, rotX, rotY, rotZ, zoom, clr1, clr2)
    if sampTextdrawIsExists(id) then
        samp_C.textdraw.textdraw[id].sModel = model
        samp_C.textdraw.textdraw[id].fRot[1] = rotX
        samp_C.textdraw.textdraw[id].fRot[2] = rotY
        samp_C.textdraw.textdraw[id].fRot[3] = rotZ
        samp_C.textdraw.textdraw[id].fZoom = zoom
        samp_C.textdraw.textdraw[id].sColor[1] = clr1
        samp_C.textdraw.textdraw[id].sColor[2] = clr2
    end
end

function sampTextdrawSetOutlineColor(id, outline, color)
    if sampTextdrawIsExists(id) then
        samp_C.textdraw.textdraw[id].byteOutline = outline
        samp_C.textdraw.textdraw[id].dwShadowColor = color
    end
end

function sampTextdrawSetShadow(id, shadow, color)
    if sampTextdrawIsExists(id) then
        samp_C.textdraw.textdraw[id].byteShadowSize = shadow
        samp_C.textdraw.textdraw[id].dwShadowColor = color
    end
end

function sampTextdrawSetStyle(id, style)
    if sampTextdrawIsExists(id) then
        samp_C.textdraw.textdraw[id].iStyle = style
    end
end

function sampTextdrawSetProportional(id, proportional)
    if sampTextdrawIsExists(id) then
        samp_C.textdraw.textdraw[id].byteProportional = proportional
    end
end

function sampTextdrawSetAlign(id, align)
    if sampTextdrawIsExists(id) then
        samp_C.textdraw.textdraw[id].byteLeft = 0
        samp_C.textdraw.textdraw[id].byteCenter = 0
        samp_C.textdraw.textdraw[id].byteRight = 0
        if align == 1 then
            samp_C.textdraw.textdraw[id].byteLeft = 1
        elseif align == 2 then
            samp_C.textdraw.textdraw[id].byteCenter = 1
        elseif align == 3 then
            samp_C.textdraw.textdraw[id].byteRight = 1
        end
    end
end

-- stScoreboardInfo

function sampToggleScoreboard(showed)
    assert(isSampAvailable(), 'SA-MP is not available.')
    if showed then
        samp_C.enableScoreboard(samp_C.scoreboard)
    else
        samp_C.disableScoreboard(samp_C.scoreboard, true)
    end
end

function sampIsScoreboardOpen()
    assert(isSampAvailable(), 'SA-MP is not available.')
    return samp_C.scoreboard.iIsEnabled == 1
end

-- stTextLabelPool

function sampCreate3dText(text, color, x, y, z, dist, i_walls, id, vid)
    assert(isSampAvailable(), 'SA-MP is not available.')
    local text = ffi.cast('PCHAR', tostring(text))
    for i = 0, #MAX_3DTEXTS - 1 do
        if not sampIs3dTextDefined(i) then
            samp_C.createTextLabel(samp_C.text3d, i, text, color, x, y, z, dist, i_walls, id, vid)
            return i
        end
    end
    return -1
end

function sampIs3dTextDefined(id)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    return samp_C.text3d.iIsListed[id] == 1
end

function sampGet3dTextInfoById(id)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    if sampIs3dTextDefined(id) then
        local t = samp_C.text3d.textLabel[id]
        return ffi.string(t.pText), t.color, t.fPosition[0], t.fPosition[1], t.fPosition[2], t.fMaxViewDistance, t.byteShowBehindWalls == 1, t.sAttachedToPlayerID, t.sAttachedToVehicleID
    end
end

function sampSet3dTextString(id, text)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    if sampIs3dTextDefined(id) then
        samp_C.text3d.textLabel[id].pText = ffi.cast('PCHAR', tostring(text))
    end
end

function sampDestroy3dText(id)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    if sampIs3dTextDefined(id) then
        samp_C.deleteTextLabel(samp_C.text3d, id)
    end
end

function sampCreate3dTextEx(i, text, color, x, y, z, dist, i_walls, id, vid)
    assert(isSampAvailable(), 'SA-MP is not available.')
    if sampIs3dTextDefined(i) then sampDestroy3dText(i) end
    local text = ffi.cast('PCHAR', tostring(text))
    samp_C.createTextLabel(samp_C.text3d, id, text, color, x, y, z, dist, i_walls, id, vid)
end

-- stVehiclePool

function sampGetCarHandleBySampVehicleId(id)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    if sampIsVehicleDefined(id) then return true, getVehiclePointerHandle(add.GET_POINTER(samp_C.car.pSAMP_Vehicle[id].pGTA_Vehicle)) end
    return false, -1
end

function sampGetVehicleIdByCarHandle(car)
    assert(isSampAvailable(), 'SA-MP is not available.')
    car = tonumber(car) or 0
    for i = 0, MAX_VEHICLES - 1 do
        local res, ccar = sampGetCarHandleBySampVehicleId(i)
        if res and ccar == car then return true, i end
    end
end

-- stObjectPool

function sampGetObjectHandleBySampId(id)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    if samp_C.object.iIsListed[id] == 1 then
        return getObjectPointerHandle(add.GET_POINTER(samp_C.object[id].object_info))
    end
end

-- stPickupPool

function sampGetPickupHandleBySampId(id)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    return samp_C.pickup.ul_GTA_PickupID[id]
end

function sampGetPickupSampIdByHandle(handle)
    assert(isSampAvailable(), 'SA-MP is not available.')
    handle = tonumber(handle) or 0
    for i = 0, MAX_PICKUPS - 1 do
        if sampGetPickupHandleBySampId(i) == handle then return i end
    end
    return -1
end

-- BitStream

function raknetBitStreamReadBool(bitstream)
    bitstream = ffi.cast('struct SFL_BitStream*', bitstream)
    return bitstream:ReadBit()
end

function raknetBitStreamReadInt8(bitstream)
    bitstream = ffi.cast('struct SFL_BitStream*', bitstream)
    local buf = ffi.new('char[?]', 1)
    bitstream:ReadBits(buf, 8, true)
    return buf[0]
end

function raknetBitStreamReadInt16(bitstream)
    bitstream = ffi.cast('struct SFL_BitStream*', bitstream)
    local buf = ffi.new('WORD[1]')
    bitstream:ReadBits(buf, 16, true)
    return buf[0]
end

function raknetBitStreamReadInt32(bitstream)
    bitstream = ffi.cast('struct SFL_BitStream*', bitstream)
    local buf = ffi.new('DWORD[1]')
    bitstream:ReadBits(buf, 32, true)
    return buf[0]
end

function raknetBitStreamReadFloat(bitstream)
    bitstream = ffi.cast('struct SFL_BitStream*', bitstream)
    local buf = ffi.new('float[1]')
    bitstream:ReadBits(buf, 32, true)
    return buf[0]
end

function raknetBitStreamReadBuffer(bitstream, dest, size)
    bitstream = ffi.cast('struct SFL_BitStream*', bitstream)
    bitstream:ReadBits(dest, size * 8, true)
end

function raknetBitStreamReadString(bitstream, size)
    bitstream = ffi.cast('struct SFL_BitStream*', bitstream)
    local buf = ffi.new('char[?]', size + 1)
    bitstream:ReadBits(buf, size * 8, true)
    return ffi.string(buf)
end

function raknetBitStreamResetReadPointer(bitstream)
    bitstream = ffi.cast('struct SFL_BitStream*', bitstream)
    bitstream:ResetReadPointer()
end

function raknetBitStreamResetWritePointer(bitstream)
    bitstream = ffi.cast('struct SFL_BitStream*', bitstream)
    bitstream:ResetWritePointer()
end

function raknetBitStreamIgnoreBits(bitstream, amount)
    bitstream = ffi.cast('struct SFL_BitStream*', bitstream)
    bitstream:IgnoreBits(amount)
end

function raknetBitStreamSetWriteOffset(bitstream, offset)
    bitstream = ffi.cast('struct SFL_BitStream*', bitstream)
    bitstream:SetWriteOffset(offset)
end

function raknetBitStreamSetReadOffset(bitstream, offset)
    bitstream = ffi.cast('struct SFL_BitStream*', bitstream)
    bitstream.readOffset = offset
end

function raknetBitStreamGetNumberOfBitsUsed(bitstream)
    bitstream = ffi.cast('struct SFL_BitStream*', bitstream)
    return bitstream.numberOfBitsUsed
end

function raknetBitStreamGetNumberOfBytesUsed(bitstream)
    local bits = raknetBitStreamGetNumberOfBitsUsed(bitstream)
    return bit.rshift(bits + 7, 3)
end

function raknetBitStreamGetNumberOfUnreadBits(bitstream)
    bitstream = ffi.cast('struct SFL_BitStream*', bitstream)
    return bitstream.numberOfBitsAllocated - bitstream.numberOfBitsUsed
end

function raknetBitStreamGetWriteOffset(bitstream)
    bitstream = ffi.cast('struct SFL_BitStream*', bitstream)
    return bitstream.numberOfBitsUsed
end

function raknetBitStreamGetReadOffset(bitstream)
    bitstream = ffi.cast('struct SFL_BitStream*', bitstream)
    return bitstream.readOffset
end

function raknetBitStreamGetDataPtr(bitstream)
    bitstream = ffi.cast('struct SFL_BitStream*', bitstream)
    return add.GET_POINTER(bitstream.data)
end

function raknetNewBitStream()
    local bitstream = bs()
    return add.GET_POINTER(bitstream)
end

function raknetDeleteBitStream(bitstream)
    bitstream = ffi.cast('struct SFL_BitStream*', bitstream)
    bitstream:__gc()
end

function raknetResetBitStream(bitstream)
    bitstream = ffi.cast('struct SFL_BitStream*', bitstream)
    bitstream:Reset()
end

function raknetBitStreamWriteBool(bitstream, value)
    bitstream = ffi.cast('struct SFL_BitStream*', bitstream)
    if value then bitstream:Write1()
    else bitstream:Write0() end
end

function raknetBitStreamWriteInt8(bitstream, value)
    bitstream = ffi.cast('struct SFL_BitStream*', bitstream)
    local buf = ffi.new('char[?]', 1, value)
    bitstream:WriteBits(buf, 8, true)
end

function raknetBitStreamWriteInt16(bitstream, value)
    bitstream = ffi.cast('struct SFL_BitStream*', bitstream)
    local buf = ffi.new('WORD[1]', value)
    bitstream:WriteBits(buf, 16, true)
end

function raknetBitStreamWriteInt32(bitstream, value)
    bitstream = ffi.cast('struct SFL_BitStream*', bitstream)
    local buf = ffi.new('DWORD[1]', value)
    bitstream:WriteBits(buf, 32, true)
end

function raknetBitStreamWriteFloat(bitstream, value)
    bitstream = ffi.cast('struct SFL_BitStream*', bitstream)
    local buf = ffi.new('float[1]', value)
    bitstream:WriteBits(buf, 32, true)
end

function raknetBitStreamWriteBuffer(bitstream, dest, size)
    bitstream = ffi.cast('struct SFL_BitStream*', bitstream)
    bitstream:WriteBits(dest, size * 8, true)
end

function raknetBitStreamWriteString(bitstream, str)
    bitstream = ffi.cast('struct SFL_BitStream*', bitstream)
    local buf = ffi.new('char[?]', #str + 1, str)
    bitstream:WriteBits(buf, #str * 8, true)
end

function raknetBitStreamDecodeString(bitstream, size)
    assert(isSampAvailable(), 'SA-MP is not available.')
    bitstream = ffi.cast('struct SFL_BitStream*', bitstream)
    local buf = ffi.new('char[?]', size + 1)
    local this = ffi.cast('void**', sampGetBase() + 0x10D894)
    samp_C.readDecodeString(this[0], buf, size, bitstream, 0)
    return ffi.string(buf)
end

function raknetBitStreamEncodeString(bitstream, str)
    assert(isSampAvailable(), 'SA-MP is not available.')
    bitstream = ffi.cast('struct SFL_BitStream*', bitstream)
    local buf = ffi.new('char[?]', #str + 1, str)
    local this = ffi.cast('void**', sampGetBase() + 0x10D894)
    samp_C.writeEncodeString(this[0], buf, #str, bitstream, 0)
end

function raknetBitStreamWriteBitStream(bitstream, bitStream)
    bitstream = ffi.cast('struct SFL_BitStream*', bitstream)
    bitstream:Write(bitStream)
end

-- RakClient

function raknetGetRpcName(id)
    local tab = {
        [23] = 'ClickPlayer',
        [25] = 'ClientJoin',
        [26] = 'EnterVehicle',
        [27] = 'EnterEditObject',
        [31] = 'ScriptCash',
        [50] = 'ServerCommand',
        [52] = 'Spawn',
        [53] = 'Death',
        [54] = 'NPCJoin',
        [62] = 'DialogResponse',
        [83] = 'ClickTextDraw',
        [96] = 'SCMEvent',
        [101] = 'Chat',
        [102] = 'SrvNetStats',
        [103] = 'ClientCheck',
        [106] = 'DamageVehicle',
        [115] = 'GiveTakeDamage',
        [116] = 'EditAttachedObject',
        [117] = 'EditObject',
        [118] = 'SetInteriorId',
        [119] = 'MapMarker',
        [128] = 'RequestClass',
        [129] = 'RequestSpawn',
        [131] = 'PickedUpPickup',
        [132] = 'MenuSelect',
        [136] = 'VehicleDestroyed',
        [140] = 'MenuQuit',
        [154] = 'ExitVehicle',
        [155] = 'UpdateScoresPingsIPs',
        [11] = 'SetPlayerName',
        [12] = 'SetPlayerPos',
        [13] = 'SetPlayerPosFindZ',
        [14] = 'SetPlayerHealth',
        [15] = 'TogglePlayerControllable',
        [16] = 'PlaySound',
        [17] = 'SetPlayerWorldBounds',
        [18] = 'GivePlayerMoney',
        [19] = 'SetPlayerFacingAngle',
        [20] = 'ResetPlayerMoney',
        [21] = 'ResetPlayerWeapons',
        [22] = 'GivePlayerWeapon',
        [24] = 'SetVehicleParamsEx',
        [28] = 'CancelEdit',
        [29] = 'SetPlayerTime',
        [30] = 'ToggleClock',
        [32] = 'WorldPlayerAdd',
        [33] = 'SetPlayerShopName',
        [34] = 'SetPlayerSkillLevel',
        [35] = 'SetPlayerDrunkLevel',
        [36] = 'Create3DTextLabel',
        [37] = 'DisableCheckpoint',
        [38] = 'SetRaceCheckpoint',
        [39] = 'DisableRaceCheckpoint',
        [40] = 'GameModeRestart',
        [41] = 'PlayAudioStream',
        [42] = 'StopAudioStream',
        [43] = 'RemoveBuildingForPlayer',
        [44] = 'CreateObject',
        [45] = 'SetObjectPos',
        [46] = 'SetObjectRot',
        [47] = 'DestroyObject',
        [55] = 'DeathMessage',
        [56] = 'SetPlayerMapIcon',
        [57] = 'RemoveVehicleComponent',
        [58] = 'Update3DTextLabel',
        [59] = 'ChatBubble',
        [60] = 'UpdateSystemTime',
        [61] = 'ShowDialog',
        [63] = 'DestroyPickup',
        [64] = 'WeaponPickupDestroy',
        [65] = 'LinkVehicleToInterior',
        [66] = 'SetPlayerArmour',
        [67] = 'SetPlayerArmedWeapon',
        [68] = 'SetSpawnInfo',
        [69] = 'SetPlayerTeam',
        [70] = 'PutPlayerInVehicle',
        [71] = 'RemovePlayerFromVehicle',
        [72] = 'SetPlayerColor',
        [73] = 'DisplayGameText',
        [74] = 'ForceClassSelection',
        [75] = 'AttachObjectToPlayer',
        [76] = 'InitMenu',
        [77] = 'ShowMenu',
        [78] = 'HideMenu',
        [79] = 'CreateExplosion',
        [80] = 'ShowPlayerNameTagForPlayer',
        [81] = 'AttachCameraToObject',
        [82] = 'InterpolateCamera',
        [84] = 'SetObjectMaterial',
        [85] = 'GangZoneStopFlash',
        [86] = 'ApplyAnimation',
        [87] = 'ClearAnimations',
        [88] = 'SetPlayerSpecialAction',
        [89] = 'SetPlayerFightingStyle',
        [90] = 'SetPlayerVelocity',
        [91] = 'SetVehicleVelocity',
        [92] = 'SetPlayerDrunkVisuals',
        [93] = 'ClientMessage',
        [94] = 'SetWorldTime',
        [95] = 'CreatePickup',
        [98] = 'SetVehicleTireStatus',
        [99] = 'MoveObject',
        [104] = 'EnableStuntBonusForPlayer',
        [105] = 'TextDrawSetString',
        [107] = 'SetCheckpoint',
        [108] = 'GangZoneCreate',
        [112] = 'PlayCrimeReport',
        [113] = 'SetPlayerAttachedObject',
        [120] = 'GangZoneDestroy',
        [121] = 'GangZoneFlash',
        [122] = 'StopObject',
        [123] = 'SetNumberPlate',
        [124] = 'TogglePlayerSpectating',
        [126] = 'PlayerSpectatePlayer',
        [127] = 'PlayerSpectateVehicle',
        [133] = 'SetPlayerWantedLevel',
        [134] = 'ShowTextDraw',
        [135] = 'TextDrawHideForPlayer',
        [137] = 'ServerJoin',
        [138] = 'ServerQuit',
        [139] = 'InitGame',
        [144] = 'RemovePlayerMapIcon',
        [145] = 'SetPlayerAmmo',
        [146] = 'SetPlayerGravity',
        [147] = 'SetVehicleHealth',
        [148] = 'AttachTrailerToVehicle',
        [149] = 'DetachTrailerFromVehicle',
        [150] = 'SetPlayerDrunkHandling',
        [151] = 'DestroyPickups',
        [152] = 'SetWeather',
        [153] = 'SetPlayerSkin',
        [156] = 'SetPlayerInterior',
        [157] = 'SetPlayerCameraPos',
        [158] = 'SetPlayerCameraLookAt',
        [159] = 'SetVehiclePos',
        [160] = 'SetVehicleZAngle',
        [161] = 'SetVehicleParamsForPlayer',
        [162] = 'SetCameraBehindPlayer',
        [163] = 'WorldPlayerRemove',
        [164] = 'WorldVehicleAdd',
        [165] = 'WorldVehicleRemove',
        [166] = 'WorldPlayerDeath'
    }
    return tab[id]
end

function raknetGetPacketName(id)
    local tab = {
        [6] = 'INTERNAL_PING',
        [7] = 'PING',
        [8] = 'PING_OPEN_CONNECTIONS',
        [9] = 'CONNECTED_PONG',
        [10] = 'REQUEST_STATIC_DATA',
        [11] = 'CONNECTION_REQUEST',
        [12] = 'AUTH_KEY',
        [14] = 'BROADCAST_PINGS',
        [15] = 'SECURED_CONNECTION_RESPONSE',
        [16] = 'SECURED_CONNECTION_CONFIRMATION',
        [17] = 'RPC_MAPPING',
        [19] = 'SET_RANDOM_NUMBER_SEED',
        [20] = 'RPC',
        [21] = 'RPC_REPLY',
        [23] = 'DETECT_LOST_CONNECTIONS',
        [24] = 'OPEN_CONNECTION_REQUEST',
        [25] = 'OPEN_CONNECTION_REPLY',
        [26] = 'CONNECTION_COOKIE',
        [28] = 'RSA_PUBLIC_KEY_MISMATCH',
        [29] = 'CONNECTION_ATTEMPT_FAILED',
        [30] = 'NEW_INCOMING_CONNECTION',
        [31] = 'NO_FREE_INCOMING_CONNECTIONS',
        [32] = 'DISCONNECTION_NOTIFICATION',
        [33] = 'CONNECTION_LOST',
        [34] = 'CONNECTION_REQUEST_ACCEPTED',
        [35] = 'INITIALIZE_ENCRYPTION',
        [36] = 'CONNECTION_BANNED',
        [37] = 'INVALID_PASSWORD',
        [38] = 'MODIFIED_PACKET',
        [39] = 'PONG',
        [40] = 'TIMESTAMP',
        [41] = 'RECEIVED_STATIC_DATA',
        [42] = 'REMOTE_DISCONNECTION_NOTIFICATION',
        [43] = 'REMOTE_CONNECTION_LOST',
        [44] = 'REMOTE_NEW_INCOMING_CONNECTION',
        [45] = 'REMOTE_EXISTING_CONNECTION',
        [46] = 'REMOTE_STATIC_DATA',
        [56] = 'ADVERTISE_SYSTEM',
        [200] = 'VEHICLE_SYNC',
        [201] = 'RCON_COMMAND',
        [202] = 'RCON_RESPONCE',
        [203] = 'AIM_SYNC',
        [204] = 'WEAPONS_UPDATE',
        [205] = 'STATS_UPDATE',
        [206] = 'BULLET_SYNC',
        [207] = 'PLAYER_SYNC',
        [208] = 'MARKERS_SYNC',
        [209] = 'UNOCCUPIED_SYNC',
        [210] = 'TRAILER_SYNC',
        [211] = 'PASSENGER_SYNC',
        [212] = 'SPECTATOR_SYNC'
    }
    return tab[id]
end

--- New functions

-- stVehiclePool

function sampIsVehicleDefined(id)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    return samp_C.car.iIsListed[id] == 1 and samp_C.car.pSAMP_Vehicle[id] and samp_C.car.pSAMP_Vehicle[id].pGTA_Vehicle
end

-- stPlayerPool

function sampIsPlayerDefined(id)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    if id == sampGetLocalPlayerId() then return samp_C.player.pLocalPlayer ~= nil end
    return sampIsPlayerConnected(id) and samp_C.player.pRemotePlayer[id] and samp_C.player.pRemotePlayer[id].pPlayerData and
        samp_C.player.pRemotePlayer[id].pPlayerData.pSAMP_Actor and samp_C.player.pRemotePlayer[id].pPlayerData.pSAMP_Actor.actor_info
end

function sampGetLocalPlayerNickname()
    assert(isSampAvailable(), 'SA-MP is not available.')
    return sampGetPlayerNickname(sampGetLocalPlayerId())
end

function sampGetLocalPlayerColor()
    assert(isSampAvailable(), 'SA-MP is not available.')
    return sampGetPlayerColor(sampGetLocalPlayerId())
end

function sampGetLocalPlayerId()
    assert(isSampAvailable(), 'SA-MP is not available.')
    return samp_C.player.sLocalPlayerID
end

function sampSetPlayerColor(id, color)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id)
    if sampIsPlayerConnected(id) or sampGetLocalPlayerId() == id then
        color_table[id] = add.convertARGBToRGBA(color)
    end
end

-- Pointers to structures

function sampGetScoreboardInfoPtr()
    assert(isSampLoaded(), 'SA-MP is not loaded.')
    return memory.getint32( sampGetBase() + SAMP_SCOREBOARD_INFO )
end

-- stChatInfo

function sampAddChatMessageEx(_type, text, prefix, textColor, prefixColor)
    assert(isSampAvailable(), 'SA-MP is not available.')
    local char = ffi.cast('PCSTR', tostring(text))
    local charPrefix = prefix and ffi.cast('PCSTR', tostring(prefix))
    samp_C.addMessage(samp_C.chat, _type, char, charPrefix, tonumber(textColor) or -1, tonumber(prefixColor) or -1)
end

-- stPickupPool

function sampGetPickupModelTypeBySampId(id)
    assert(isSampAvailable(), 'SA-MP is not available.')
    id = tonumber(id) or 0
    if samp_C.pickup.pickup[id] then return samp_C.pickup.pickup[id].iModelID, samp_C.pickup.pickup[id].iType end
    return -1, -1
end

-- stKillInfo

function sampAddDeathMessage(killer, killed, clkiller, clkilled, reason)
    assert(isSampAvailable(), 'SA-MP is not available.')
    local killer = ffi.cast('PCHAR', killer)
    local killed = ffi.cast('PCHAR', killed)
    samp_C.sendDeathMessage(samp_C.killinfo, killer, killed, clkiller, clkilled, reason)
end

-- stDialogInfo

function sampGetDialogButtons()
    assert(isSampAvailable(), 'SA-MP is not available.')
    local dialog = samp_C.dialog.pDialog
    local b1p = samp_C.getElementSturct(dialog, 20, 0) + 0x4D
    local b2p = samp_C.getElementSturct(dialog, 21, 0) + 0x4D
    return ffi.string(b1p), ffi.string(b2p)
end
