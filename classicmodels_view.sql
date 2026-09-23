-- Sử dụng cơ sở dữ liệu classicmodels
USE classicmodels;

-- 1. Tạo View cơ bản có tên customer_views lấy customerNumber, customerName, phone
CREATE OR REPLACE VIEW customer_views AS
SELECT customerNumber, customerName, phone
FROM customers;

-- 2. Truy vấn dữ liệu từ bảng ảo (View) vừa tạo
SELECT * FROM customer_views;

-- 3. Cập nhật cấu trúc của View bằng CREATE OR REPLACE VIEW
-- Bổ sung thêm contactFirstName, contactLastName và lọc theo thành phố Nantes
CREATE OR REPLACE VIEW customer_views AS
SELECT customerNumber, customerName, contactFirstName, contactLastName, phone
FROM customers
WHERE city = 'Nantes';

-- 4. Truy vấn lại để kiểm tra dữ liệu sau khi cập nhật View
SELECT * FROM customer_views;

-- 5. Xóa View khi không còn sử dụng
DROP VIEW IF EXISTS customer_views;