import torch
from diffusers import StableDiffusionPipeline
from PIL import Image, ImageDraw, ImageFont
import os

def sanitize_filename(prompt):
    """Chuyển đổi prompt thành tên file hợp lệ."""
    return "".join([c if c.isalnum() or c in (' ', '_', '-') else '_' for c in prompt]).strip()

def add_warning(image):
    """Thêm cảnh báo 18+ vào ảnh."""
    draw = ImageDraw.Draw(image)
    try:
        # Sử dụng font mặc định nếu không có font tùy chỉnh
        font = ImageFont.load_default()
    except IOError:
        # Nếu không tìm thấy font, sử dụng font mặc định
        font = ImageFont.load_default()
    
    warning_text = "Cảnh báo: Nội dung 18+"
    text_bbox = draw.textbbox((0, 0), warning_text, font=font)
    text_width = text_bbox[2] - text_bbox[0]
    text_height = text_bbox[3] - text_bbox[1]
    
    # Vẽ nền cảnh báo màu đỏ
    draw.rectangle(((0, image.height - text_height - 10), (image.width, image.height)), fill="red")
    
    # Vẽ văn bản cảnh báo
    draw.text((10, image.height - text_height - 5), warning_text, fill="white", font=font)

def display_model_info(model_id, use_gpu):
    """Hiển thị thông tin cấu hình mô hình khi khởi động."""
    device = "GPU" if use_gpu and torch.cuda.is_available() else "CPU"
    print("Thông tin Mô Hình:")
    print(f"Model ID: {model_id}")
    print(f"Thiết bị đang sử dụng: {device}")
    print("██████████████████████████\n")

def generate_images(prompt, output_image_path, model_id, resolution=(1920, 1080), use_gpu=False, is_18_plus=False, num_images=4):
    """Hàm tạo nhiều ảnh từ văn bản với độ phân giải và tùy chọn GPU và phong cách ảnh."""
    
    # Load model từ Hugging Face dựa vào phong cách đã chọn
    pipe = StableDiffusionPipeline.from_pretrained(model_id, use_auth_token=True)
    
    # Tắt safety_checker để không lọc nội dung
    pipe.safety_checker = None

    # Chọn thiết bị xử lý (GPU hoặc CPU)
    device = "cuda" if use_gpu and torch.cuda.is_available() else "cpu"
    pipe.to(device)

    # Hiển thị thông tin mô hình
    display_model_info(model_id, use_gpu)

    print(f"Đang tạo {num_images} ảnh từ văn bản: {prompt} với phong cách {model_id} trên {device.upper()}")

    # Sử dụng memory_efficient_attention để giảm bộ nhớ sử dụng (nếu có GPU)
    pipe.enable_attention_slicing()

    # Tạo nhiều ảnh không giới hạn
    image_count = 0
    while True:
        try:
            result = pipe([prompt])  # Tạo một ảnh với prompt
            images = result.images  # Danh sách các ảnh được tạo
            if not images:
                raise ValueError("Không tạo được ảnh. Kết quả trả về không có ảnh.")
        except Exception as e:
            print(f"Đã xảy ra lỗi khi tạo ảnh: {e}")
            break

        # Xử lý và lưu từng ảnh
        for image in images:
            image = image.resize(resolution, Image.LANCZOS)

            # Hiển thị cảnh báo 18+ nếu cần
            if is_18_plus:
                print("Cảnh báo: Nội dung 18+ sẽ được tạo ra.")
                add_warning(image)

            # Lưu ảnh với số thứ tự khác nhau
            output_path = f"{output_image_path}_{image_count + 1}.png"
            try:
                image.save(output_path)
                print(f"Đã lưu ảnh {image_count + 1} vào: {output_path}")
                image_count += 1
            except Exception as e:
                print(f"Đã xảy ra lỗi khi lưu ảnh {image_count + 1}: {e}")

def main():
    while True:
        # Hiển thị tùy chọn phong cách
        print("Chọn phong cách ảnh:")
        print("1. Thực tế (Stable Diffusion)")
        print("2. Anime (Waifu Diffusion)")
        style_choice = input("Nhập 1 hoặc 2 để chọn phong cách: ")

        if style_choice == '1':
            model_id = "CompVis/stable-diffusion-v1-4"  # Phong cách thực tế
        elif style_choice == '2':
            model_id = "hakurei/waifu-diffusion"  # Phong cách anime
        else:
            print("Lựa chọn không hợp lệ, vui lòng thử lại.")
            continue

        prompt = input("Nhập mô tả văn bản (hoặc gõ 'exit' để thoát): ")
        if prompt.lower() == 'exit':
            print("Thoát chương trình.")
            break

        # Tạo tên file từ prompt
        filename = sanitize_filename(prompt)

        # Nhập độ phân giải nếu muốn thay đổi
        resolution_input = input("Nhập độ phân giải (mặc định là 1920x1080, định dạng 'rộng x cao') hoặc nhấn Enter để giữ mặc định: ")
        if resolution_input:
            try:
                width, height = map(int, resolution_input.split('x'))
                resolution = (width, height)
            except ValueError:
                print("Định dạng độ phân giải không hợp lệ. Sử dụng độ phân giải mặc định 1920x1080.")
                resolution = (1920, 1080)
        else:
            resolution = (1920, 1080)

        # Hỏi người dùng có muốn sử dụng GPU hay không
        use_gpu = input("Bạn có muốn sử dụng GPU nếu có? (y/n): ").lower() == 'y'

        # Hỏi người dùng có muốn tạo ảnh 18+ không
        is_18_plus = input("Bạn có muốn tạo ảnh với nội dung 18+ không? (1 để có, 0 để không có): ").strip() == '1'

        # Lưu ảnh
        output_image_path = filename
        generate_images(prompt, output_image_path, model_id, resolution, use_gpu, is_18_plus)

if __name__ == "__main__":
    # Sử dụng màu đen và trắng cho các khối '█'
    black_block = "\033[30m█\033[0m"  # Màu đen
    white_block = "\033[37m█\033[0m"  # Màu trắng

    print(f"{black_block}{white_block}{black_block}{white_block} - Khởi động mô hình tạo ảnh")
    main()
