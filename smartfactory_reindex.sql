CREATE DATABASE IF NOT EXISTS smartfactory_db;
USE smartfactory_db;

-- 1. Dọn dẹp và tạo bảng SensorLogs
DROP TABLE IF EXISTS SensorLogs;

CREATE TABLE SensorLogs (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    sensor_id INT NOT NULL,
    recorded_at DATETIME NOT NULL,
    temperature DECIMAL(5,2),
    humidity DECIMAL(5,2),
    status VARCHAR(20)
) ENGINE=InnoDB;

-- 2. Thêm dữ liệu mẫu kiểm thử
INSERT INTO SensorLogs (sensor_id, recorded_at, temperature, humidity, status) VALUES
(105, '2026-06-20 08:00:00', 28.50, 65.20, 'NORMAL'),
(105, '2026-06-20 08:01:00', 31.00, 68.00, 'WARNING'),
(106, '2026-06-20 08:02:00', 25.40, 55.10, 'NORMAL'),
(105, '2026-06-21 09:30:00', 42.10, 80.50, 'CRITICAL'),
(107, '2026-06-22 10:15:00', 27.80, 60.00, 'NORMAL');

-- 3. Tạo trạng thái ban đầu: "Fat Covering Index" (Thảm họa cũ)
CREATE INDEX idx_fat_covering ON SensorLogs(sensor_id, recorded_at, temperature, humidity, status);

-- Đo lường dung lượng ban đầu của bảng và Index
SELECT 
    table_name AS `Table`,
    ROUND(data_length / 1024 / 1024, 4) AS `Data_Size_MB`,
    ROUND(index_length / 1024 / 1024, 4) AS `Index_Size_MB`,
    ROUND((data_length + index_length) / 1024 / 1024, 4) AS `Total_Size_MB`
FROM information_schema.TABLES
WHERE table_schema = 'smartfactory_db' AND table_name = 'SensorLogs';

-- EXPLAIN với Fat Index: Extra hiển thị "Using index" (Covering Index)
EXPLAIN 
SELECT temperature, humidity, status 
FROM SensorLogs 
WHERE sensor_id = 105 AND recorded_at >= '2026-06-20 00:00:00';

-- 4. Tiến hành phẫu thuật: Xóa Fat Index và Tạo Lean Index
ALTER TABLE SensorLogs DROP INDEX idx_fat_covering;

-- Tạo Lean Index chỉ chứa 2 cột lọc dữ liệu trong mệnh đề WHERE
CREATE INDEX idx_lean_search ON SensorLogs(sensor_id, recorded_at);

-- 5. Đo lường lại dung lượng sau khi tối ưu
SELECT 
    table_name AS `Table`,
    ROUND(data_length / 1024 / 1024, 4) AS `Data_Size_MB`,
    ROUND(index_length / 1024 / 1024, 4) AS `Index_Size_MB`,
    ROUND((data_length + index_length) / 1024 / 1024, 4) AS `Total_Size_MB`
FROM information_schema.TABLES
WHERE table_schema = 'smartfactory_db' AND table_name = 'SensorLogs';

-- EXPLAIN với Lean Index: Extra không còn "Using index" (chuyển sang Table Lookup),
-- nhưng type vẫn duy trì "range", key = idx_lean_search
EXPLAIN 
SELECT temperature, humidity, status 
FROM SensorLogs 
WHERE sensor_id = 105 AND recorded_at >= '2026-06-20 00:00:00';

-- 6. Thực thi truy vấn thực tế để xác minh tính toàn vẹn dữ liệu
SELECT temperature, humidity, status 
FROM SensorLogs 
WHERE sensor_id = 105 AND recorded_at >= '2026-06-20 00:00:00';