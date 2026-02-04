@echo off
set PATH=%PATH%;E:\flutter\bin
echo ==========================================
echo   Monetra Web App Launcher
echo ==========================================

cd mobile

echo.
echo [1/2] Fetching dependencies...
call flutter pub get

echo.
echo [2/2] Launching App in Chrome...
call flutter run -d chrome

pause
