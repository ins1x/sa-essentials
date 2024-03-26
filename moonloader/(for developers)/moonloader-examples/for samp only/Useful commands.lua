command_list =
[[//ammo [+-][value]  -- add or set ammo
//weapon id [ammo]  -- give weapon
//health [+-][value]  -- add or set health
//armor [+-][value]  -- add or set armor
//money [+-]value  -- add or set money
//help  -- show all commands
]]

script_name('Useful Commands')
script_author('FYP')
script_version_number(1)
script_moonloader(022)
script_description('Get the latest MoonLoader updates from http://blast.hk/moonloader/\n' .. command_list)

require 'lib.sampfuncs'


--- Config
default_ammo = 1000
default_health = 100
default_armor = 100


--- Main
function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then
		return
	end
	while not isSampAvailable() do wait(100) end

	register_commands()

	wait(-1)
end

function register_commands()
	local CMD = sampRegisterChatCommand

	CMD('/help',
	function()
		sampShowDialog(1, '[Lua] Useful Commands', command_list, 'Close', '', DIALOG_STYLE_MSGBOX)
	end)

	CMD('/ammo',
	function(par)
		local pf, num = parse_number(par)
		local weap = getCurrentCharWeapon(playerPed)
		if num ~= nil then
			if pf == '+' then add_ped_ammo(playerPed, weap, num)
			elseif pf == '-' then add_ped_ammo(playerPed, weap, -num)
			else setCharAmmo(playerPed, weap, num)
			end
		else
			add_ped_ammo(playerPed, weap, default_ammo)
		end
	end)

	CMD('/health',
	function(par)
		local pf, num = parse_number(par)
		if num ~= nil then
			if pf == '+' then setCharHealth(playerPed, getCharHealth(playerPed) + num)
			elseif pf == '-' then setCharHealth(playerPed, getCharHealth(playerPed) - num)
			else setCharHealth(playerPed, num)
			end
		else
			setCharHealth(playerPed, default_health)
		end
	end)

	CMD('/armor',
	function(par)
		local pf, num = parse_number(par)
		if num ~= nil then
			if pf == '+' then addArmourToChar(playerPed, num)
			elseif pf == '-' then addArmourToChar(playerPed, -num)
			else set_ped_armor(playerPed, num)
			end
		else
			set_ped_armor(playerPed, default_armor)
		end
	end)

	CMD('/money',
	function(par)
		local pf, num = parse_number(par)
		if num ~= nil then
			if pf == '+' then givePlayerMoney(playerHandle, num)
			elseif pf == '-' then givePlayerMoney(playerHandle, -num)
			else set_player_money(num)
			end
		end
	end)

	CMD('/weapon',
	function(par)
		local id, ammo = string.match(par, '(%d+)%s*(%d*)')
		if id ~= nil then
			if ammo == nil or #ammo == 0 then ammo = default_ammo end
			-- function give_player_weapon uses 'wait', but it's being called from command callback, so it's necessary to run the function as a thread
			lua_thread.create(give_player_weapon, id, ammo)
		end
	end)

end


--- Functions
function parse_number(str)
	if str == nil then return nil end
	return string.match(str, '([+-]?)(%d+)')
end

function set_ped_armor(ped, armor)
	addArmourToChar(ped, armor - getCharArmour(ped))
end

function add_ped_ammo(ped, weap, ammo)
	if ammo > 0 then addAmmoToChar(ped, weap, ammo)
	else addAmmoToChar(ped, weap, math.max(ammo, getAmmoInCharWeapon(ped, weap)))
	end
end

function give_player_weapon(id, ammo)
  local model = getWeapontypeModel(id)
  if model ~= 0 then
    if not hasModelLoaded(model) then
      requestModel(model)
      loadAllModelsNow()
      while not hasModelLoaded(model) do wait(0) end
    end
    giveWeaponToChar(playerPed, id, ammo)
    setCurrentCharWeapon(playerPed, id)
  end
end

function set_player_money(money)
	givePlayerMoney(playerHandle, money - getPlayerMoney(playerHandle))
end
