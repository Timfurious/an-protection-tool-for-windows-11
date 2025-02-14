@echo off
chcp 65001 > nul
title - Windows Protection - by TimFurious

:start
cls
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo  ██▀███  ▓█████  ██▓███   ▄▄▄       ██▓ ██▀███  
echo ▓██ ▒ ██▒▓█   ▀ ▓██░  ██▒▒████▄    ▓██▒▓██ ▒ ██▒
echo ▓██ ░▄█ ▒▒███   ▓██░ ██▓▒▒██  ▀█▄  ▒██▒▓██ ░▄█ ▒
echo ▒██▀▀█▄  ▒▓█  ▄ ▒██▄█▓▒ ▒░██▄▄▄▄██ ░██░▒██▀▀█▄  
echo ░██▓ ▒██▒░▒████▒▒██▒ ░  ░ ▓█   ▓██▒░██░░██▓ ▒██▒
echo ░ ▒▓ ░▒▓░░░ ▒░ ░▒▓▒░ ░  ░ ▒▒   ▓▒█░░▓  ░ ▒▓ ░▒▓░
echo   ░▒ ░ ▒░ ░ ░  ░░▒ ░       ▒   ▒▒ ░ ▒ ░  ░▒ ░ ▒░
echo   ░░   ░    ░   ░░         ░   ▒    ▒ ░  ░░   ░ 
echo    ░        ░  ░               ░  ░   ░        ░  

echo.
echo 1 - Scan for malware

echo 2 - Check for corrupted files

echo 3 - Delete temporary files

echo 4 - Check for updates

echo 5 - Clear network cache

echo 6 - Display largest files

echo 7 - Exit
set /p choice=Enter your choice: 
if %choice% == 1 goto malware_scan
if %choice% == 2 goto corruption_scan
if %choice% == 3 goto delete_temp
if %choice% == 4 goto update_check
if %choice% == 5 goto clear_cache
if %choice% == 6 goto large_files
if %choice% == 7 goto exit_script
goto :start

:malware_scan
cls
echo 1 - Quick scan
echo 2 - Full scan
echo 3 - Scan a specific file
set /p virus=Select an option: 
if %virus% == 3 goto scan_file
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType %virus%
echo Scan completed.
pause
goto start

:scan_file
cls
set /p dir=Enter file path to scan: 
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 3 -File "%dir%"
echo File %dir% has been scanned.
pause
goto start

:corruption_scan
cls
sfc /scannow
DISM /Online /Cleanup-Image /CheckHealth
DISM /Online /Cleanup-Image /ScanHealth
DISM /Online /Cleanup-Image /RestoreHealth
timeout /t 5
chkdsk C: /F /R
echo System integrity check completed.
pause
goto start

:exit_script
cls
echo Goodbye!
exit

:delete_temp
cls
echo Cleaning temporary files...

del /f /s /q "%TEMP%\*" >nul 2>nul
for /d %%P in ("%TEMP%\*") do rmdir /s /q "%%P" >nul 2>nul
echo Temporary files cleaned.

del /f /s /q "C:\WINDOWS\Temp\*" >nul 2>nul
for /d %%P in ("C:\WINDOWS\Temp\*") do rmdir /s /q "%%P" >nul 2>nul
echo System temp files cleaned.

del /f /s /q "C:\WINDOWS\Prefetch\*" >nul 2>nul
echo Prefetch cleaned.

del /f /s /q "C:\WINDOWS\SoftwareDistribution\Download\*" >nul 2>nul
for /d %%P in ("C:\WINDOWS\SoftwareDistribution\Download\*") do rmdir /s /q "%%P" >nul 2>nul
echo Windows update cache cleaned.

del "%LocalAppData%\Microsoft\Windows\Explorer\*.db" /s /q >nul 2>nul
echo Thumbnail cache cleaned.

echo Cleanup completed.
pause
goto start

:update_check
cls
wuauclt.exe /detectnow
wuauclt.exe /updatenow
gpupdate /force
echo Updates checked and installed.
pause
goto start

:clear_cache
cls
ipconfig /flushdns
arp -d *
nbtstat -R
echo Network cache cleared.
pause
goto start

:large_files
cls
set /p num_files=Enter the number of largest files to display: 
echo This may take a few minutes...
powershell -NoExit -Command "Get-ChildItem 'C:\' -Recurse -ErrorAction SilentlyContinue | Sort-Object Length -Descending | Select-Object FullName, Length | Select-Object -First %num_files%; Read-Host"
echo Displaying top %num_files% largest files.
pause
goto start