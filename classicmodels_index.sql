-- Sử dụng cơ sở dữ liệu classicmodels
USE classicmodels;

-- 1. Khảo sát kế hoạch thực thi trước khi đánh chỉ mục
-- Quan sát type = ALL (Full Table Scan)
EXPLAIN SELECT * FROM customers WHERE customerName = 'Land of Toys Inc.';

-- 2. Thêm chỉ mục đơn cho cột customerName
ALTER TABLE customers ADD INDEX idx_customerName(customerName);

-- 3. Khảo sát lại sau khi đánh chỉ mục idx_customerName
-- Quan sát type chuyển thành ref, key = idx_customerName, rows giảm xuống
EXPLAIN SELECT * FROM customers WHERE customerName = 'Land of Toys Inc.';

-- 4. Thêm composite index (chỉ mục kết hợp) cho cặp cột contactFirstName và contactLastName
ALTER TABLE customers ADD INDEX idx_full_name(contactFirstName, contactLastName);

-- 5. Khảo sát kế hoạch thực thi khi truy vấn kết hợp
EXPLAIN SELECT * FROM customers WHERE contactFirstName = 'Jean' OR contactFirstName = 'King';

-- 6. Xóa chỉ mục
ALTER TABLE customers DROP INDEX idx_customerName;
ALTER TABLE customers DROP INDEX idx_full_name;