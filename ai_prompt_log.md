\# Nhật ký Tương tác AI (AI Prompt Log)

\*\*Dự án:\*\* AutoRide Database Architecture

Lượt 1: Kiểu dữ liệu số học cho tài chính

Prompt: "Tại sao bắt buộc phải sử dụng kiểu DECIMAL(10, 2) thay vì FLOAT hoặc DOUBLE cho các trường lưu trữ tiền đặt cọc và phí phạt trong MySQL?"



Tóm tắt phản hồi: FLOAT/DOUBLE dùng chuẩn IEEE 754 biểu diễn dấu phẩy động dạng nhị phân xấp xỉ, dẫn đến sai số làm tròn khi thực hiện các phép trừ tài chính. DECIMAL là kiểu fixed-point lưu chính xác dạng chuỗi thập phân, đảm bảo số liệu kế toán chính xác tuyệt đối.



Lượt 2: Thiết kế quan hệ bảng Inspections

Prompt: "Nên thiết kế bảng Inspections theo quan hệ 1-1 hay 1-N với bảng Rentals? Ưu và nhược điểm của việc tách bảng riêng thay vì thêm cột vào Rentals?"



Tóm tắt phản hồi: Nên thiết kế quan hệ 1-N (hoặc 1-1 mở rộng). Việc tách riêng bảng Inspections tuân thủ chuẩn hóa 3NF, tránh dư thừa cột rỗng (NULL) khi xe trả về nguyên vẹn, đồng thời cho phép lưu vết nhiều đợt kiểm tra và thông tin chi tiết của người kiểm tra.



Lượt 3: Ràng buộc nghiệp vụ bằng Trigger

Prompt: "Làm thế nào để chặn việc insert vào bảng Inspections khi hợp đồng thuê đang ở trạng thái BOOKED bằng trigger trong MySQL?"



Tóm tắt phản hồi: Sử dụng BEFORE INSERT ON Inspections. Truy vấn trạng thái của Rentals thông qua NEW.rental\_id. Nếu giá trị bằng 'BOOKED', dùng lệnh SIGNAL SQLSTATE '45000' để hủy giao dịch và hiển thị thông báo lỗi nghiệp vụ.

