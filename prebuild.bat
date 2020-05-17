@echo off
setlocal enabledelayedexpansion
set PREV_DIR=%cd%
set DIR=%~dp0
cd "%DIR%"

set INSTALL_DIR=%DIR%install
set DEEPSEA_DIR=%DIR%DeepSea
set BUILD_DIR=%DEEPSEA_DIR%\build
set /P FLAGS=<"%DIR%scripts\flags"
set PLATFORM=native
set CMAKE_ARGS=
set CMAKE_PLATFORM_ARGS=-A Win32
set WIN_PLATFORM=win32

:parseArgs
if not "%1"=="" (
	set MATCH=
	if "%1"=="-h" set MATCH=1
	if "%1"=="--help" set MATCH=1
	if "%1"=="/?" set MATCH=1
	if defined MATCH (
		goto :printHelp
	) else (
		if "%1"=="-p" set MATCH=1
		if "%1"=="--platform" set MATCH=1
		if defined MATCH (
			if "%2"=="win32" (
				set CMAKE_PLATFORM_ARGS=-A Win32
				set WIN_PLATFORM=win32
			) else (
				if "%2"=="win64" (
					set CMAKE_PLATFORM_ARGS=-A x64
					set WIN_PLATFORM=win64
				) else (
					echo Unknown platform "%2"
					set ERRORLEVEL=1
					goto :printHelp
				)
			)
			shift /1
		) else set CMAKE_ARGS=!CMAKE_ARGS! "%1"
	)
	shift /1
	goto :parseArgs
)

rmdir "%BUILD_DIR%" /S /Q > nul 2>&1
mkdir "%BUILD_DIR%"

if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

echo Building DeepSea...

cd "%BUILD_DIR%"
call "%DIR%scripts\!PLATFORM!-compile.bat" %FLAGS% !CMAKE_PLATFORM_ARGS! !CMAKE_ARGS!
if !ERRORLEVEL! neq 0 (
	cd %PREV_DIR%
	exit /B !ERRORLEVEL!
)

echo Cleaning up...

rmdir %BUILD_DIR% /S /Q > nul 2>&1

echo Done

cd %PREV_DIR%
exit /B !ERRORLEVEL!

:printHelp
	echo Usage: %~n0` [options] [CMake args...]
	echo.
	echo Options:
	echo -p, --platform ^<platform^>    The platform to build for. Valid platforms are:
	echo                              - win32 (default)
	echo                              - win64
	exit /B !ERRORLEVEL!
