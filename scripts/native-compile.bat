@echo off
set REPO_DIR=%cd%

set INSTALL_PREFIX=%INSTALL_DIR%\%WIN_PLATFORM%

REM Install to an intermediate location first to ensure absolute paths aren't used.
cmake .. -DCMAKE_INSTALL_PREFIX=install %*
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%
cmake --build . --config Debug
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%
cmake --build . --config Debug --target install
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%
cmake --build . --config Release
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%
cmake --build . --config Release --target install
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%

rmdir "%INSTALL_PREFIX%" /S /Q > nul 2>&1
move /Y install "%INSTALL_PREFIX%"

cd %REPO_DIR%
