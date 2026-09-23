CREATE DATABASE IF NOT EXISTS quickfeed_db;
USE quickfeed_db;

DROP TABLE IF EXISTS Posts;

CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT,
    post_type VARCHAR(10),
    is_visible BOOLEAN DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 1. Trạng thái Over-indexing ban đầu
CREATE INDEX idx_user_id ON Posts(user_id);
CREATE INDEX idx_content ON Posts(content(255));
CREATE INDEX idx_post_type ON Posts(post_type);
CREATE INDEX idx_is_visible ON Posts(is_visible);
CREATE INDEX idx_created_at ON Posts(created_at);

-- 2. Đo lường kích thước Data và Index ban đầu
SELECT 
    table_name AS `Table`,
    ROUND(data_length / 1024 / 1024, 4) AS `Data_Size_MB`,
    ROUND(index_length / 1024 / 1024, 4) AS `Index_Size_MB`,
    ROUND((data_length + index_length) / 1024 / 1024, 4) AS `Total_Size_MB`
FROM information_schema.TABLES
WHERE table_schema = 'quickfeed_db' AND table_name = 'Posts';

-- 3. Loại bỏ 3 Index vô dụng (Low Cardinality & Kích thước quá lớn)
-- Xóa idx_content: Cột TEXT làm phình to B-Tree Index, tìm kiếm văn bản cần dùng FULLTEXT
ALTER TABLE Posts DROP INDEX idx_content;

-- Xóa idx_post_type: Cardinality cực thấp (chỉ có 3 giá trị)
ALTER TABLE Posts DROP INDEX idx_post_type;

-- Xóa idx_is_visible: Kiểu BOOLEAN (chỉ 0 và 1), Optimizer luôn bỏ qua và Full Table Scan
ALTER TABLE Posts DROP INDEX idx_is_visible;

-- 4. Đo lường lại dung lượng sau khi tối ưu
SELECT 
    table_name AS `Table`,
    ROUND(data_length / 1024 / 1024, 4) AS `Data_Size_MB`,
    ROUND(index_length / 1024 / 1024, 4) AS `Index_Size_MB`,
    ROUND((data_length + index_length) / 1024 / 1024, 4) AS `Total_Size_MB`
FROM information_schema.TABLES
WHERE table_schema = 'quickfeed_db' AND table_name = 'Posts';

-- 5. Xác nhận các Index còn lại (PRIMARY, idx_user_id, idx_created_at)
SHOW INDEX FROM Posts;