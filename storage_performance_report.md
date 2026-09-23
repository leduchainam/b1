\# Báo cáo Đánh giá Tài nguyên và Hiệu năng Lưu trữ (Storage \& Performance Report)



\### 1. Nguyên nhân Sự cố (Root Cause)

Hệ thống QuickFeed gặp sự cố timeout khi đăng status do hiện tượng \*\*Over-indexing\*\*:

\- Mỗi thao tác `INSERT` bài viết mới buộc InnoDB không chỉ ghi dòng dữ liệu vào Clustered Index (Primary Key) mà còn phải đồng thời cập nhật và tái cân bằng \*\*5 cây B-Tree Secondary Index\*\*.

\- Cột `content(255)` làm kích thước node lá của Index phình to, gây tràn bộ đệm Buffer Pool và cạn kiệt dung lượng đĩa vật lý.

\- Hai cột `post\_type` và `is\_visible` có \*\*Cardinality (độ phân giải dữ liệu) cực thấp\*\*. Trình tối ưu hóa (Optimizer) hầu như luôn chọn Full Table Scan thay vì dùng hai index này, khiến chi phí duy trì chúng trở nên lãng phí hoàn toàn.



\### 2. Kết quả Tối ưu hóa (Trade-off \& Storage)

\- \*\*Hành động\*\*: Loại bỏ 3 Index vô giá trị (`idx\_content`, `idx\_post\_type`, `idx\_is\_visible`), chỉ giữ lại `idx\_user\_id` (lọc trang cá nhân) và `idx\_created\_at` (sắp xếp Newsfeed).

\- \*\*Đánh đổi Read - Write\*\*: Chấm dứt 3 thao tác ghi ngầm lên cây B-Tree cho mỗi lệnh INSERT, đưa độ trễ đăng bài từ 5–10 giây về mức tức thì (vài mili-giây).

\- \*\*Lưu trữ\*\*: Chỉ số `Index\_length` trong `information\_schema.TABLES` giảm đáng kể, giải phóng dung lượng đĩa và giảm thiểu phân mảnh trang dữ liệu.

