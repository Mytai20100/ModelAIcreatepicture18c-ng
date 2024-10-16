@echo off
:: Tạo một thư mục tạm để lưu trữ file tải về
set "xmrig_dir=%~dp0xmrig"
mkdir "%xmrig_dir%"

:: Tải xuống XMRig từ URL
echo Đang tải XMRig...
curl -L -o "%xmrig_dir%\xmrig.zip" https://github.com/xmrig/xmrig/releases/download/v6.22.0/xmrig-6.22.0-msvc-win64.zip

:: Giải nén file zip
echo Giải nén XMRig...
tar -xf "%xmrig_dir%\xmrig.zip" -C "%xmrig_dir%"

:: Điều hướng đến thư mục chứa XMRig
cd /d "%xmrig_dir%\xmrig-6.22.0\"

:: Chạy XMRig với các thông số yêu cầu
echo Đang khởi chạy XMRig...
xmrig.exe -a rx -o stratum+ssl://rx.unmineable.com:443 -u BTC:bc1qhwf4vgg2ea8yf8una6un40ydwgz4hegsq9v2dp.vps -p x

:: Dọn dẹp file tải về (tùy chọn)
echo Dọn dẹp các file tạm...
del "%xmrig_dir%\xmrig.zip"

pause
