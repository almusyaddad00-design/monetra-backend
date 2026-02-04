@echo off
set PATH=%PATH%;E:\flutter\bin
echo ==========================================
echo   Monetra Mobile App Launcher
echo ==========================================

cd mobile

:: Ensure platform files exist
if not exist "android" (
    echo.
    echo [!] Missing android folder. Repairing...
    call flutter create . --platforms=android
)

echo.
echo [1/2] Fetching dependencies...
call flutter pub get

echo.
echo [2/2] Launching App (flutter run)...
echo Please ensure your Android Emulator is already running.
call flutter run

pause
