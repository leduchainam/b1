\# Báo cáo Phân tích Kế hoạch Thực thi (EXPLAIN Analysis)



\### 1. Truy vấn Kế toán (Trước tối ưu)

\- \*\*type = ALL\*\*: Hệ thống buộc phải thực hiện Quét toàn bảng (Full Table Scan) qua 5 triệu dòng.

\- \*\*Nguyên nhân\*\*: Mệnh đề `WHERE YEAR(created\_at) = 2026 AND MONTH(created\_at) = 6` bọc hàm lên cột làm truy vấn trở thành \*\*Non-SARGable\*\*, vô hiệu hóa khả năng duyệt cây B-Tree.

\- \*\*Hệ quả\*\*: Chiếm dụng 100% CPU, kéo dài thời gian thực thi (45s) và gây nghẽn tài nguyên / khóa bảng.



\### 2. Truy vấn Sau khi Tối ưu hóa

\- \*\*Tạo Composite Index\*\*: `idx\_type\_date (transaction\_type, created\_at)`.

\- \*\*Tái cấu trúc\*\*: Đưa về dạng SARGable `created\_at >= '2026-06-01' AND created\_at < '2026-07-01'`.

\- \*\*type = range / ref\*\*: Bộ tối ưu hóa kích hoạt Index Seek/Range Scan trực tiếp trên cây B-Tree.

\- \*\*rows\*\*: Giảm từ hàng triệu dòng xuống đúng số bản ghi phát sinh trong tháng 6. Cột `key` nhận diện chính xác `idx\_type\_date`, giải phóng hoàn toàn CPU và chấm dứt tình trạng timeout.

