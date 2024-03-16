@ECHO OFF

SETLOCAL
CALL :NORMALIZEPATH "%~dp0..\luarocks"
SET "LUAROCKS_PATH=%RETVAL%"
CALL :NORMALIZEPATH "%~dp0..\lib"
SET "LIB_PATH=%RETVAL%"
CALL :NORMALIZEPATH "%~dp0..\libstd"
SET "LIBSTD_PATH=%RETVAL%"
REM lib and libstd paths are set by luarocks
IF "%LUA_PATH%"=="" (
	SET "LUA_PATH=.\?.lua;.\?\init.lua"
)
SET "LUA_PATH=%LUA_PATH%;%LIBSTD_PATH%\?.lua;%LIBSTD_PATH%\?\init.lua;%LIB_PATH%\?.luac;%LIB_PATH%\?\init.luac;%LUAROCKS_PATH%\lua\?.lua;%LUAROCKS_PATH%\lua\?\init.lua"
IF "%LUA_CPATH%"=="" (
	SET "LUA_CPATH=.\?.dll"
)
ENDLOCAL & SET "LUA_PATH=%LUA_PATH%" & SET "LUA_CPATH=%LUA_CPATH%"

"%~dp0\bin\luajit.exe" -lluarocks.loader %*

GOTO :EOF

:NORMALIZEPATH
  SET RETVAL=%~dpfn1
  EXIT /B
