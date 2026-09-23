CREATE DATABASE IF NOT EXISTS quickfeed_db;
USE quickfeed_db;

-- 1. Dọn dẹp và tạo bảng Posts
DROP TABLE IF EXISTS Posts;

CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT,
    post_type VARCHAR(10),
    is_visible BOOLEAN DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2. Thiết lập trạng thái ban đầu bị Over-indexing (Thảm họa cũ)
CREATE INDEX idx_user_id ON Posts(user_id);
CREATE INDEX idx_content ON Posts(content(255));
CREATE INDEX idx_post_type ON Posts(post_type);
CREATE INDEX idx_is_visible ON Posts(is_visible);
CREATE INDEX idx_created_at ON Posts(created_at);

-- 3. Đo lường kích thước Data và Index ban đầu qua information_schema
SELECT 
    table_name AS `Table`,
    ROUND(data_length / 1024 / 1024, 4) AS `Data_Size_MB`,
    ROUND(index_length / 1024 / 1024, 4) AS `Index_Size_MB`,
    ROUND((data_length + index_length) / 1024 / 1024, 4) AS `Total_Size_MB`
FROM information_schema.TABLES
WHERE table_schema = 'quickfeed_db' AND table_name = 'Posts';

-- 4. Tiến hành phẫu thuật cắt bỏ 3 Index vô dụng / Low Cardinality
-- Xóa idx_content: Kích thước chuỗi lớn, làm phình to B-Tree, không phục vụ tìm kiếm toàn văn
ALTER TABLE Posts DROP INDEX idx_content;

-- Xóa idx_post_type: Cardinality cực thấp (chỉ 3 giá trị: TEXT, IMAGE, VIDEO)
ALTER TABLE Posts DROP INDEX idx_post_type;

-- Xóa idx_is_visible: Boolean (chỉ 0 và 1), Optimizer luôn bỏ qua và quét bảng
ALTER TABLE Posts DROP INDEX idx_is_visible;

-- 5. Đo lường lại dung lượng sau khi loại bỏ Index dư thừa
SELECT 
    table_name AS `Table`,
    ROUND(data_length / 1024 / 1024, 4) AS `Data_Size_MB`,
    ROUND(index_length / 1024 / 1024, 4) AS `Index_Size_MB`,
    ROUND((data_length + index_length) / 1024 / 1024, 4) AS `Total_Size_MB`
FROM information_schema.TABLES
WHERE table_schema = 'quickfeed_db' AND table_name = 'Posts';

-- 6. Kiểm tra lại danh sách các Index còn lại (chỉ còn PRIMARY, idx_user_id, idx_created_at)
SHOW INDEX FROM Posts;