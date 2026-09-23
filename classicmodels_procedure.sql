-- Sử dụng cơ sở dữ liệu classicmodels
USE classicmodels;

-- 1. Tạo Stored Procedure đầu tiên: findAllCustomers
DELIMITER //

DROP PROCEDURE IF EXISTS `findAllCustomers` //

CREATE PROCEDURE findAllCustomers()
BEGIN
    SELECT * FROM customers;
END //

DELIMITER ;

-- 2. Gọi procedure lần 1 để lấy toàn bộ danh sách khách hàng
CALL findAllCustomers();

-- 3. Sửa procedure bằng cách xóa và tạo lại với điều kiện lọc customerNumber = 175
DELIMITER //

DROP PROCEDURE IF EXISTS `findAllCustomers` //

CREATE PROCEDURE findAllCustomers()
BEGIN
    SELECT * FROM customers WHERE customerNumber = 175;
END //

DELIMITER ;

-- 4. Gọi lại procedure sau khi sửa
CALL findAllCustomers();