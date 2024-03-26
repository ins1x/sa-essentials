script_name('RapidFire')
script_author('FYP')
script_description('Get the latest MoonLoader updates from http://blast.hk/moonloader/')
local ffi = require 'ffi'


--- Config
cheatToggle = 'RAPID'
amplification = {
-- weapon   speed multiplier (greater value = faster)
	[22]   =   3,    -- pistol
	-- [23]   =   4,    -- silenced pistol
	[24]   =   2.5,  -- desert eagle
	[25]   =   1.5,  -- shotgun
	[26]   =   10,   -- sawn-off shotgun
	[27]   =   10,   -- combat shotgun
	[28]   =   2,    -- micro uzi
	[29]   =   5,    -- mp5
	[30]   =   3.5,  -- ak47
	[31]   =   3,    -- m4
	[32]   =   2,    -- tec9
	[33]   =   10,   -- rifle
	[34]   =   10,   -- sniper rifle
}


--- Main
function main()
	gameGetWeaponInfo = ffi.cast('struct CWeaponInfo* (__cdecl*)(int, int)', 0x743C60)

	while true do
		wait(0)
		if isPlayerPlaying(playerHandle) and isCharOnFoot(playerPed) then
			if testCheat(cheatToggle) then
				activated = not activated
				printStringNow('RapidFire ' .. (activated and '~g~activated' or '~r~deactivated') .. '.~n~~y~Made by FYP~n~~w~blast.hk', 2000)

				if activated then
					weaponOrigData = {}
					for skill = 1, 3 do
						weaponOrigData[skill] = {}
						for id, value in pairs(amplification) do
							local weap = gameGetWeaponInfo(id, skill - 1)
							weaponOrigData[skill][id] = {accuracy = weap.m_fAccuracy,
														animLoopStart = weap.m_fAnimLoopStart,
														animLoopFire = weap.m_fAnimLoopFire,
														animLoopEnd = weap.m_fAnimLoopEnd,
														animLoopStart2 = weap.m_fAnimLoop2Start,
														animLoopFire2 = weap.m_fAnimLoop2Fire,
														animLoopEnd2 = weap.m_fAnimLoop2End}
							-- magic
							local mul = 1 / value
							if id ~= 25 and id ~= 26 and id ~= 27 then
								weap.m_fAccuracy = weap.m_fAccuracy / (mul * 1.4)
							end
							weap.m_fAnimLoopStart = weap.m_fAnimLoopFire - (weap.m_fAnimLoopFire - weap.m_fAnimLoopStart) * mul
							weap.m_fAnimLoop2Start = weap.m_fAnimLoop2Fire - (weap.m_fAnimLoop2Fire - weap.m_fAnimLoop2Start) * mul
							weap.m_fAnimLoopEnd = weap.m_fAnimLoopFire + (weap.m_fAnimLoopEnd - weap.m_fAnimLoopFire) * mul
							weap.m_fAnimLoop2End = weap.m_fAnimLoop2Fire + (weap.m_fAnimLoop2End - weap.m_fAnimLoop2Fire) * mul
						end
					end
				else
					restoreOriginalWeaponData()
					weaponOrigData = nil
				end
			end
		end
	end
end


--- Events
function onExitScript()
	restoreOriginalWeaponData()
end


--- Functions
function restoreOriginalWeaponData()
	if weaponOrigData ~= nil then
		for skill, weaponsOrig in pairs(weaponOrigData) do
			for id, orig in pairs(weaponsOrig) do
				local weap = gameGetWeaponInfo(id, skill - 1)
				weap.m_fAccuracy 			 = orig.accuracy
				weap.m_fAnimLoopStart  = orig.animLoopStart
				weap.m_fAnimLoopFire   = orig.animLoopFire
				weap.m_fAnimLoopEnd    = orig.animLoopEnd
				weap.m_fAnimLoop2Start = orig.animLoopStart2
				weap.m_fAnimLoop2Fire  = orig.animLoopFire2
				weap.m_fAnimLoop2End   = orig.animLoopEnd2
			end
		end
	end
end


--- FFI
ffi.cdef([[
struct CVector { float x, y, z; };
// from plugin-sdk: https://github.com/DK22Pac/plugin-sdk/blob/master/plugin_sa/game_sa/CWeaponInfo.h
struct CWeaponInfo
{
	int m_iWeaponFire; // 0
	float m_fTargetRange; // 4
	float m_fWeaponRange; // 8
	__int32 m_dwModelId1; // 12
	__int32 m_dwModelId2; // 16
	unsigned __int32 m_dwSlot; // 20
	union {
		int m_iWeaponFlags; // 24
		struct {
			unsigned __int32 m_bCanAim : 1;
			unsigned __int32 m_bAimWithArm : 1;
			unsigned __int32 m_b1stPerson : 1;
			unsigned __int32 m_bOnlyFreeAim : 1;
			unsigned __int32 m_bMoveAim : 1;
			unsigned __int32 m_bMoveFire : 1;
			unsigned __int32 _weaponFlag6 : 1;
			unsigned __int32 _weaponFlag7 : 1;
			unsigned __int32 m_bThrow : 1;
			unsigned __int32 m_bHeavy : 1;
			unsigned __int32 m_bContinuosFire : 1;
			unsigned __int32 m_bTwinPistol : 1;
			unsigned __int32 m_bReload : 1;
			unsigned __int32 m_bCrouchFire : 1;
			unsigned __int32 m_bReload2Start : 1;
			unsigned __int32 m_bLongReload : 1;
			unsigned __int32 m_bSlowdown : 1;
			unsigned __int32 m_bRandSpeed : 1;
			unsigned __int32 m_bExpands : 1;
		};
	};
	unsigned __int32 m_dwAnimGroup; // 28
	unsigned __int16 m_wAmmoClip; // 32
	unsigned __int16 m_wDamage; // 34
	struct CVector m_vFireOffset; // 36
	unsigned __int32 m_dwSkillLevel; // 48
	unsigned __int32 m_dwReqStatLevel; // 52
	float m_fAccuracy; // 56
	float m_fMoveSpeed;
	float m_fAnimLoopStart;
	float m_fAnimLoopEnd;
	float m_fAnimLoopFire;
	float m_fAnimLoop2Start;
	float m_fAnimLoop2End;
	float m_fAnimLoop2Fire;
	float m_fBreakoutTime;
	float m_fSpeed;
	float m_fRadius;
	float m_fLifespan;
	float m_fSpread;
	unsigned __int16 m_wAimOffsetIndex;
	unsigned __int8 m_nBaseCombo;
	unsigned __int8 m_nNumCombos;
} __attribute__ ((aligned (4)));
]])
