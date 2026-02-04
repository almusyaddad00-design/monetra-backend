@echo off
set PATH=%PATH%;E:\flutter\bin
echo ==========================================
echo   Monetra Windows App Launcher
echo ==========================================

cd mobile

:: Ensure platform files exist
if not exist "windows" (
    echo.
    echo [!] Missing windows folder. Repairing...
    call flutter create . --platforms=windows
)

echo.
echo [1/2] Enabling Windows Desktop Support...
call flutter config --enable-windows-desktop

echo.
echo [2/2] Launching App on Windows...
call flutter run -d windows

pause
