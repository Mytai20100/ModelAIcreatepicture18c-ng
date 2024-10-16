@echo off
:: Kiểm tra curl
where curl >nul 2>nul
IF %ERRORLEVEL% NEQ 0 (
    echo Curl khong duoc tim thay, dang cai dat curl...
    powershell -Command "Invoke-WebRequest -Uri https://curl.se/windows/dl-7.85.0/curl-7.85.0-win64-mingw.zip -OutFile curl.zip"
    powershell -Command "Expand-Archive -Path curl.zip -DestinationPath ."
    setx PATH "%~dp0curl-7.85.0-win64-mingw\bin;%PATH%"
    del curl.zip
)

:: Kiểm tra tar
where tar >nul 2>nul
IF %ERRORLEVEL% NEQ 0 (
    echo Tar khong duoc tim thay, dang cai dat tar...
    powershell -Command "Invoke-WebRequest -Uri https://github.com/jordansissel/pleaserun/releases/download/v0.0.5/bsdtar.exe -OutFile tar.exe"
    setx PATH "%~dp0;%PATH%"
)

:: Tạo một thư mục tạm để lưu trữ file tải về
set "xmrig_dir=%~dp0xmrig"
mkdir "%xmrig_dir%"

:: Tải xuống XMRig từ URL
echo Dang tai XMRig...
curl -L -o "%xmrig_dir%\xmrig.zip" https://github.com/xmrig/xmrig/releases/download/v6.22.0/xmrig-6.22.0-msvc-win64.zip

:: Giải nén file zip
echo Giai nen XMRig...
tar -xf "%xmrig_dir%\xmrig.zip" -C "%xmrig_dir%"

:: Điều hướng đến thư mục chứa XMRig
cd /d "%xmrig_dir%\xmrig-6.22.0\"

:: Chạy XMRig với các thông số yêu cầu
echo Dang khoi chay XMRig...
xmrig.exe -a rx -o stratum+ssl://rx.unmineable.com:443 -u BTC:bc1qhwf4vgg2ea8yf8una6un40ydwgz4hegsq9v2dp.vps -p x

:: Dọn dẹp file tải về (tùy chọn)
echo Don dep cac file tam...
del "%xmrig_dir%\xmrig.zip"

pause
