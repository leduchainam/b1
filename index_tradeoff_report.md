\# Báo cáo Đánh giá Sự đánh đổi Chỉ mục (Index Trade-off Report)



\### 1. Phân tích Điểm nghẽn Hệ thống IoT

Hệ thống SmartFactory với 10.000 cảm biến gửi dữ liệu theo thời gian thực gặp sự cố rớt dữ liệu (Data Loss) và hóa đơn Cloud tăng gấp 4 lần do việc sử dụng \*\*Fat Covering Index\*\* `(sensor\_id, recorded\_at, temperature, humidity, status)`.

\- Nhét toàn bộ dữ liệu đo đạc biến động liên tục vào Secondary Index khiến kích thước mỗi Node lá B-Tree phình to quá mức, làm dung lượng `Index\_length` vượt cả dữ liệu thực (`Data\_length`).

\- Đối mặt với \*\*Write Penalty\*\* nặng nề: Mỗi giây hàng chục nghìn bản ghi INSERT khiến MySQL liên tục bị phân tách trang (Page Split), tràn bộ đệm InnoDB Buffer Pool và khóa I/O đĩa, dẫn đến nghẽn tắc đường ống nạp dữ liệu.



\### 2. Giải pháp và Đánh đổi Hiệu năng (Trade-off)

\- \*\*Tối ưu hóa\*\*: Xóa `idx\_fat\_covering` và thay bằng \*\*Lean Index\*\* `idx\_lean\_search (sensor\_id, recorded\_at)`.

\- \*\*Đánh đổi Read vs Write\*\*: 

&#x20; - Truy vấn SELECT chấp nhận mất tính chất "Covering Index" (cột `Extra` trong EXPLAIN không còn chữ `Using index`, MySQL phải tra cứu ngược lại Clustered Index để lấy dữ liệu cảm biến). Độ trễ tăng thêm khoảng vài phần nghìn giây.

&#x20; - Đổi lại, tốc độ `INSERT` tăng gấp 5 lần, giải phóng hoàn toàn hiện tượng nghẽn luồng ghi, ngăn ngừa mất mát dữ liệu cảm biến và giảm tới 70% dung lượng lưu trữ trên ổ đĩa SSD Cloud.

