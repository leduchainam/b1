-- ========================================================
-- HỆ THỐNG FLASHMART - REFACTORED SQL SCRIPT
-- Role: Data Engineer
-- ========================================================

CREATE DATABASE IF NOT EXISTS flashmart_db;
USE flashmart_db;

-- 1. Dọn dẹp và tạo bảng
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Products;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
) ENGINE=InnoDB;

-- 2. Chèn dữ liệu kiểm thử
INSERT INTO Customers VALUES 
(1, 'Alice'), 
(2, 'Bob'), 
(3, 'Charlie'); -- Charlie: Chưa từng mua hàng

INSERT INTO Products VALUES 
(101, 'Laptop'), 
(102, 'Mouse'), 
(103, 'Keyboard'); -- Keyboard: Chưa từng được mua

INSERT INTO Orders VALUES 
(1001, 1, 101), 
(1002, 1, 102), 
(1003, 2, 101);

-- ========================================================
-- BÁO CÁO 1: Yêu cầu Giám đốc Marketing
-- Danh sách TẤT CẢ khách hàng kèm số đơn hàng đã mua
-- Charlie phải hiển thị total_orders = 0
-- ========================================================
SELECT 
    c.customer_id, 
    c.name, 
    COUNT(o.order_id) AS total_orders
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

-- ========================================================
-- BÁO CÁO 2: Yêu cầu Giám đốc Kho vận (Anti-Join Pattern)
-- Danh sách sản phẩm CHƯA TỪNG được bán lần nào để thanh lý
-- Kết quả trả về chính xác: Keyboard (product_id = 103)
-- ========================================================
SELECT 
    p.product_id, 
    p.product_name
FROM Products p
LEFT JOIN Orders o ON p.product_id = o.product_id
WHERE o.order_id IS NULL;