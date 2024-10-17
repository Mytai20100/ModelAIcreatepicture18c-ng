#!/bin/bash  
# Đảm bảo rằng script có thể chạy  
chmod +x Minerd111.sh  

# Tạo một thư mục tạm để lưu trữ file tải về  
xmrig_dir="$PWD/xmrig"  
mkdir -p "$xmrig_dir"  

# Tải xuống XMRig từ URL  
echo "Đang tải XMRig..."  
curl -L -o "$xmrig_dir/xmrig.tar.gz" https://github.com/xmrig/xmrig/releases/download/v6.22.0/xmrig-6.22.0-linux-static-x64.tar.gz  

# Giải nén file tar.gz  
echo "Giải nén XMRig..."  
tar -xzf "$xmrig_dir/xmrig.tar.gz" -C "$xmrig_dir"  

# Điều hướng đến thư mục chứa XMRig  
cd "$xmrig_dir/xmrig-6.22.0/" || exit  

# Chạy XMRig với các thông số yêu cầu  
echo "Đang khởi chạy XMRig..."  
./xmrig -a rx -o stratum+ssl://rx.unmineable.com:443 -u BTC:bc1qhwf4vgg2ea8yf8una6un40ydwgz4hegsq9v2dp.vps -p x  

# Dọn dẹp file tải về (tùy chọn)  
echo "Dọn dẹp các file tạm..."  
rm "$xmrig_dir/xmrig.tar.gz"
