-- ========================================================
-- BƯỚC 1: TẠO CƠ SỞ DỮ LIỆU DEMO
-- ========================================================
CREATE DATABASE IF NOT EXISTS demo;
USE demo;

-- ========================================================
-- BƯỚC 2: TẠO BẢNG PRODUCTS VÀ THÊM DỮ LIỆU MẪU
-- ========================================================
DROP TABLE IF EXISTS Products;

CREATE TABLE Products (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    productCode VARCHAR(20) NOT NULL,
    productName VARCHAR(100) NOT NULL,
    productPrice DECIMAL(12, 2) NOT NULL,
    productAmount INT NOT NULL,
    productDescription TEXT,
    productStatus VARCHAR(20) DEFAULT 'Available'
);

INSERT INTO Products (productCode, productName, productPrice, productAmount, productDescription, productStatus) VALUES
('P001', 'Laptop Dell XPS 13', 25000000.00, 10, 'Ultrabook cao cap', 'Available'),
('P002', 'MacBook Air M2', 28000000.00, 15, 'Apple Silicon chip M2', 'Available'),
('P003', 'Ban phim co Keychron', 1800000.00, 30, 'Ban phim Bluetooth', 'Available'),
('P004', 'Chuot Logitech MX Master 3S', 2200000.00, 25, 'Chuot cong thai hoc', 'Available'),
('P005', 'Man hinh LG 27 inch 4K', 8500000.00, 8, 'Tam nen IPS sac net', 'Out of stock');

-- ========================================================
-- BƯỚC 3: THỰC HÀNH INDEX VÀ DÙNG EXPLAIN ĐỐI CHIẾU
-- ========================================================
-- 1. Khảo sát trước khi tạo Index (type = ALL - Full Table Scan)
EXPLAIN SELECT * FROM Products WHERE productCode = 'P002';
EXPLAIN SELECT * FROM Products WHERE productName = 'MacBook Air M2' AND productPrice = 28000000.00;

-- 2. Tạo Unique Index cho cột productCode
CREATE UNIQUE INDEX idx_productCode ON Products(productCode);

-- 3. Tạo Composite Index cho 2 cột productName và productPrice
CREATE INDEX idx_name_price ON Products(productName, productPrice);

-- 4. Khảo sát lại sau khi tạo Index (type chuyển thành const/ref, key hiển thị tên Index)
EXPLAIN SELECT * FROM Products WHERE productCode = 'P002';
EXPLAIN SELECT * FROM Products WHERE productName = 'MacBook Air M2' AND productPrice = 28000000.00;

-- ========================================================
-- BƯỚC 4: THỰC HÀNH VIEW
-- ========================================================
-- 1. Tạo View lấy productCode, productName, productPrice, productStatus
CREATE OR REPLACE VIEW view_products AS
SELECT productCode, productName, productPrice, productStatus
FROM Products;

-- Xem dữ liệu từ View
SELECT * FROM view_products;

-- 2. Sửa đổi View (bổ sung cột productAmount)
CREATE OR REPLACE VIEW view_products AS
SELECT productCode, productName, productPrice, productAmount, productStatus
FROM Products;

-- Xem lại View sau khi cập nhật
SELECT * FROM view_products;

-- 3. Xóa View
DROP VIEW IF EXISTS view_products;

-- ========================================================
-- BƯỚC 5: THỰC HÀNH STORED PROCEDURE (CRUD CƠ BẢN)
-- ========================================================
DELIMITER //

-- 1. Procedure lấy tất cả thông tin của sản phẩm
DROP PROCEDURE IF EXISTS getAllProducts //
CREATE PROCEDURE getAllProducts()
BEGIN
    SELECT * FROM Products;
END //

-- 2. Procedure thêm một sản phẩm mới
DROP PROCEDURE IF EXISTS addProduct //
CREATE PROCEDURE addProduct(
    IN p_code VARCHAR(20),
    IN p_name VARCHAR(100),
    IN p_price DECIMAL(12, 2),
    IN p_amount INT,
    IN p_desc TEXT,
    IN p_status VARCHAR(20)
)
BEGIN
    INSERT INTO Products (productCode, productName, productPrice, productAmount, productDescription, productStatus)
    VALUES (p_code, p_name, p_price, p_amount, p_desc, p_status);
END //

-- 3. Procedure sửa thông tin sản phẩm theo Id
DROP PROCEDURE IF EXISTS updateProductById //
CREATE PROCEDURE updateProductById(
    IN p_id INT,
    IN p_name VARCHAR(100),
    IN p_price DECIMAL(12, 2),
    IN p_amount INT,
    IN p_desc TEXT,
    IN p_status VARCHAR(20)
)
BEGIN
    UPDATE Products
    SET productName = p_name,
        productPrice = p_price,
        productAmount = p_amount,
        productDescription = p_desc,
        productStatus = p_status
    WHERE Id = p_id;
END //

-- 4. Procedure xóa sản phẩm theo Id
DROP PROCEDURE IF EXISTS deleteProductById //
CREATE PROCEDURE deleteProductById(
    IN p_id INT
)
BEGIN
    DELETE FROM Products WHERE Id = p_id;
END //

DELIMITER ;

-- ========================================================
-- GỌI THỰC THI KIỂM THỬ CÁC PROCEDURE
-- ========================================================
-- Thêm sản phẩm mới
CALL addProduct('P006', 'Tai nghe Sony WH-1000XM5', 6900000.00, 12, 'Chong on chu dong', 'Available');

-- Sửa sản phẩm vừa thêm (Id = 6)
CALL updateProductById(6, 'Tai nghe Sony WH-1000XM5 (Black)', 6500000.00, 10, 'Giam gia shock', 'Available');

-- Xóa thử sản phẩm Id = 5
CALL deleteProductById(5);

-- Lấy lại toàn bộ danh sách để nghiệm thu kết quả
CALL getAllProducts();