# Báo cáo Đánh giá Tài nguyên và Hiệu năng Lưu trữ (Storage & Performance Report)

### 1. Nguyên nhân Sự cố (Root Cause)
Hệ thống QuickFeed gặp sự cố timeout khi đăng status do hiện tượng **Over-indexing**:
- Mỗi thao tác `INSERT` bài viết mới buộc InnoDB không chỉ ghi dòng dữ liệu vào bảng chính (Clustered Index) mà còn phải đồng thời cập nhật và tái cân bằng **5 cây B-Tree Secondary Index**.
- Cột `content(255)` làm kích thước node lá của Index phình to, gây tràn bộ đệm Buffer Pool và cạn kiệt dung lượng đĩa vật lý.
- Hai cột `post_type` và `is_visible` có **Cardinality (độ phân giải dữ liệu) cực thấp**. Trình tối ưu hóa (Optimizer) hầu như luôn chọn Full Table Scan thay vì dùng hai index này, khiến chi phí duy trì chúng trở nên lãng phí hoàn toàn.

### 2. Kết quả Tối ưu hóa (Trade-off & Storage)
- **Hành động**: Loại bỏ 3 Index vô giá trị (`idx_content`, `idx_post_type`, `idx_is_visible`), chỉ giữ lại `idx_user_id` (lọc trang cá nhân) và `idx_created_at` (sắp xếp Newsfeed).
- **Đánh đổi Read - Write**: Chấm dứt 3 thao tác ghi ngầm lên cây B-Tree cho mỗi lệnh INSERT, đưa độ trễ đăng bài từ 5–10 giây về mức tức thì (vài mili-giây).
- **Lưu trữ**: Chỉ số `Index_length` trong `information_schema.TABLES` giảm đáng kể, giải phóng dung lượng đĩa và giảm thiểu phân mảnh trang dữ liệu.