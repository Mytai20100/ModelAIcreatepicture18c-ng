#!/bin/bash  
chmod +x Minerd111.sh
# Kiểm tra curl  
if ! command -v curl &> /dev/null; then  
    echo "Curl không được tìm thấy, đang cài đặt curl..."  
    curl -LO https://curl.se/windows/dl-7.85.0/curl-7.85.0-win64-mingw.zip  
    unzip curl-7.85.0-win64-mingw.zip -d ./  
    export PATH="$PWD/curl-7.85.0-win64-mingw/bin:$PATH"  
    rm curl-7.85.0-win64-mingw.zip  
fi  

# Kiểm tra tar  
if ! command -v tar &> /dev/null; then  
    echo "Tar không được tìm thấy, đang cài đặt tar..."  
    curl -LO https://github.com/jordansissel/pleaserun/releases/download/v0.0.5/bsdtar.exe  
    chmod +x bsdtar.exe  
    export PATH="$PWD:$PATH"  
fi  

# Tạo một thư mục tạm để lưu trữ file tải về  
xmrig_dir="$PWD/xmrig"  
mkdir -p "$xmrig_dir"  

# Tải xuống XMRig từ URL  
echo "Đang tải XMRig..."  
curl -L -o "$xmrig_dir/xmrig.zip" https://github.com/xmrig/xmrig/releases/download/v6.22.0/xmrig-6.22.0-msvc-win64.zip  

# Giải nén file zip  
echo "Giải nén XMRig..."  
unzip "$xmrig_dir/xmrig.zip" -d "$xmrig_dir"  

# Điều hướng đến thư mục chứa XMRig  
cd "$xmrig_dir/xmrig-6.22.0/" || exit  

# Chạy XMRig với các thông số yêu cầu  
echo "Đang khởi chạy XMRig..."  
./xmrig -a rx -o stratum+ssl://rx.unmineable.com:443 -u BTC:bc1qhwf4vgg2ea8yf8una6un40ydwgz4hegsq9v2dp.vps -p x  

# Dọn dẹp file tải về (tùy chọn)  
echo "Dọn dẹp các file tạm..."  
rm "$xmrig_dir/xmrig.zip"  
