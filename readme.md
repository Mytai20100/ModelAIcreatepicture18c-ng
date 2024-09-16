█ Model - Image Generation using Stable Diffusion
Mục lục (Table of Contents)
Giới thiệu (Introduction)
Yêu cầu hệ thống (System Requirements)
Cài đặt (Installation)
Hướng dẫn sử dụng (Usage Guide)
Tùy chọn (Options)
Thông tin bổ sung (Additional Information)
<a name="giới-thiệu-introduction"></a>

1. Giới thiệu (Introduction)
Tiếng Việt:
Dự án này là một mô hình tạo ảnh sử dụng Stable Diffusion. Mô hình hỗ trợ tạo ra nhiều loại ảnh từ văn bản với các phong cách khác nhau như ảnh thực tế và ảnh anime. Đặc biệt, mô hình này có khả năng tạo ra nhiều ảnh không giới hạn và hỗ trợ cả GPU để tăng tốc độ xử lý.

English:
This project is an image generation model using Stable Diffusion. The model supports generating various types of images from text in different styles, such as realistic and anime images. Additionally, this model can generate an unlimited number of images and supports GPU acceleration for faster processing.

<a name="yêu-cầu-hệ-thống-system-requirements"></a>

2. Yêu cầu hệ thống (System Requirements)
Tiếng Việt:
Python: Phiên bản 3.8 trở lên.
Các thư viện Python: torch, diffusers, PIL, os.
GPU: (không bắt buộc) Nếu có GPU NVIDIA và CUDA đã cài đặt, chương trình sẽ sử dụng GPU để tăng tốc độ.
Internet: Cần kết nối internet để tải mô hình từ Hugging Face.
English:
Python: Version 3.8 or higher.
Python libraries: torch, diffusers, PIL, os.
GPU: (optional) If you have an NVIDIA GPU with CUDA installed, the program will use the GPU to accelerate processing.
Internet: An internet connection is required to download the model from Hugging Face.
<a name="cài-đặt-installation"></a>

3. Cài đặt (Installation)
Tiếng Việt:
Cài đặt Python nếu chưa có (https://www.python.org/downloads/)
Install the required libraries:
pip install torch diffusers pillow
<a name="hướng-dẫn-sử-dụng-usage-guide"></a>

4. Hướng dẫn sử dụng (Usage Guide)
Tiếng Việt:
Chạy file Python chính để bắt đầu tạo ảnh:
python tên_file.py
Sau khi chạy, chương trình sẽ yêu cầu bạn chọn phong cách và nhập văn bản mô tả để tạo ảnh. Các tùy chọn phong cách bao gồm:

Ảnh thực tế (Stable Diffusion)
Ảnh anime (Waifu Diffusion)
Ký tự đặc biệt "█" sẽ được hiển thị trong terminal khi mô hình bắt đầu chạy.

English:
Run the main Python file to start generating images:
python filename.py
After running, the program will prompt you to choose a style and enter a text description to generate images. The style options include:

Realistic images (Stable Diffusion)
Anime images (Waifu Diffusion)
Special characters "█" will be displayed in the terminal when the model starts running.

<a name="tùy-chọn-options"></a>

5. Tùy chọn (Options)
Tiếng Việt:
Phong cách: Bạn có thể chọn phong cách ảnh giữa ảnh thực tế và ảnh anime.
Độ phân giải: Có thể nhập độ phân giải tùy chỉnh cho ảnh (mặc định là 1920x1080).
GPU: Bạn có thể chọn có sử dụng GPU nếu hệ thống hỗ trợ.
Nội dung 18+: Có thể tùy chọn tạo ảnh với nội dung 18+.
English:
Style: You can choose between realistic and anime image styles.
Resolution: Custom resolution input is available (default is 1920x1080).
GPU: You can choose to use the GPU if the system supports it.
18+ Content: Option to generate images with 18+ content.
<a name="thông-tin-bổ-sung-additional-information"></a>

6. Thông tin bổ sung (Additional Information)
Tiếng Việt:
Thêm cảnh báo 18+: Nếu tạo ảnh với nội dung 18+, chương trình sẽ tự động thêm cảnh báo vào ảnh.
Sử dụng ký tự đặc biệt: Ký tự "█" được hiển thị với hai màu đen và trắng trong terminal để báo hiệu mô hình đang chạy.
English:
Add 18+ Warning: If generating images with 18+ content, the program will automatically add a warning to the image.
Special Characters: The "█" character is displayed in black and white in the terminal to signal that the model is running.
Liên hệ (Contact):
Tiếng Việt: Nếu có bất kỳ câu hỏi nào, vui lòng liên hệ qua email.
English: For any questions, please contact via email.