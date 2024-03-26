script_name('CrossHairHack')
script_author('FYP')
script_moonloader(019)
script_description('Get the latest MoonLoader updates from http://blast.hk/moonloader/')
local memory = require 'memory'


--- Config
alwaysVisible  = false                                 -- default: false
useTexture     = true                                  -- default: true
crosshairSize  = 72                                    -- default: 72
crosshairColor = {r = 130, g = 235, b = 125, a = 255}  -- default: 130, 235, 125, 255
cheatToggle    = 'CHH'                                 -- default: CHH
activated      = false                                 -- default: false
showGameCrosshairInstantly = false                     -- default: false


--- Main
function main()
	if showGameCrosshairInstantly then
		showCrosshairInstantlyPatch(true)
	end

	while true do
		if isPlayerPlaying(playerHandle) and isCharOnFoot(playerPed) then

			if testCheat(cheatToggle) then
				activated = not activated
			end

			if activated then
				local camMode = getActiveCamMode()
				local camAiming = (camMode == 53 or camMode == 7 or camMode == 8 or camMode == 51)
				if alwaysVisible or not (camAiming and (showGameCrosshairInstantly or getCameraTransitionState() ~= 1))
				then
						local weap = getCurrentCharWeapon(playerPed)
						local slot = getWeapontypeSlot(weap)
						if slot >= 2 and slot <= 7 then
							drawCustomCrosshair(weap == 34 or weap == 35 or weap == 36)
						end
				end
			end

		end
		wait(0)
	end
end


--- Events
function onExitScript()
	if showGameCrosshairInstantly then
		showCrosshairInstantlyPatch(false)
	end
end


--- Functions
function drawCustomCrosshair(center)
	local chx, chy
	if center then
		local szx, szy = getScreenResolution()
		chx, chy = convertWindowScreenCoordsToGameScreenCoords(szx / 2, szy / 2)
	else
		chx, chy = getCrosshairPosition()
	end
	if useTexture then
		if not crosshairTexture then
			loadTextureDictionary('hud')
			crosshairTexture = loadSprite('siteM16')
		end
		local chw, chh = getCrosshairSize(crosshairSize / 4)
		useRenderCommands(true)
		drawCrosshairSprite(chx - chw / 2, chy - chh / 2, chw, chh)
		drawCrosshairSprite(chx + chw / 2, chy - chh / 2, -chw, chh)
		drawCrosshairSprite(chx - chw / 2, chy + chh / 2, chw, -chh)
		drawCrosshairSprite(chx + chw / 2, chy + chh / 2, -chw, -chh)
	else
		local chw, chh = getCrosshairSize(crosshairSize / 2)
		local r, g, b, a = crosshairColor.r, crosshairColor.g, crosshairColor.b, crosshairColor.a
		drawRect(chx, chy, 1.0, chh, r, g, b, a)
		drawRect(chx, chy, chh, 1.0, r, g, b, a)
	end
end

function drawCrosshairSprite(x, y, w, h)
	local r, g, b, a = crosshairColor.r, crosshairColor.g, crosshairColor.b, crosshairColor.a
	setSpritesDrawBeforeFade(true)
	drawSprite(crosshairTexture, x, y, w, h, r, g, b, a)
end

function getCrosshairPosition()
	local chOff1 = memory.getfloat(0xB6EC10)
	local chOff2 = memory.getfloat(0xB6EC14)
	local szx, szy = getScreenResolution()
	return convertWindowScreenCoordsToGameScreenCoords(szx * chOff2, szy * chOff1)
end

function getCrosshairSize(size)
	return convertWindowScreenCoordsToGameScreenCoords(size, size)
end

function getCamera()
	return 0x00B6F028
end

function getCameraTransitionState()
	return memory.getint8(getCamera() + 0x58)
end

function getActiveCamMode()
	local activeCamId = memory.getint8(getCamera() + 0x59)
	return getCamMode(activeCamId)
end

function getCamMode(id)
	local cams = getCamera() + 0x174
	local cam = cams + id * 0x238
	return memory.getint16(cam + 0x0C)
end

function showCrosshairInstantlyPatch(enable)
	if enable then
		if not patch_showCrosshairInstantly then
			patch_showCrosshairInstantly = memory.read(0x0058E1D9, 1, true)
		end
		memory.write(0x0058E1D9, 0xEB, 1, true)
	elseif patch_showCrosshairInstantly ~= nil then
		memory.write(0x0058E1D9, patch_showCrosshairInstantly, 1, true)
		patch_showCrosshairInstantly = nil
	end
end
