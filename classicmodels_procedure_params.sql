-- Sử dụng cơ sở dữ liệu classicmodels
USE classicmodels;

-- ========================================================
-- PHẦN 1: THAM SỐ LOẠI IN
-- ========================================================
DELIMITER //

DROP PROCEDURE IF EXISTS getCusById //

CREATE PROCEDURE getCusById(
    IN cusNum INT
)
BEGIN
    SELECT * FROM customers WHERE customerNumber = cusNum;
END //

DELIMITER ;

-- Gọi procedure với tham số IN (ví dụ tìm khách hàng số 112 hoặc 175)
CALL getCusById(112);


-- ========================================================
-- PHẦN 2: THAM SỐ LOẠI OUT
-- ========================================================
DELIMITER //

DROP PROCEDURE IF EXISTS GetCustomersCountByCity //

CREATE PROCEDURE GetCustomersCountByCity(
    IN in_city VARCHAR(50),
    OUT total INT
)
BEGIN
    SELECT COUNT(customerNumber)
    INTO total
    FROM customers
    WHERE city = in_city;
END //

DELIMITER ;

-- Gọi procedure với tham số OUT và xuất kết quả biến @total
CALL GetCustomersCountByCity('Las Vegas', @total);
SELECT @total AS TotalCustomersInCity;


-- ========================================================
-- PHẦN 3: THAM SỐ LOẠI INOUT
-- ========================================================
DELIMITER //

DROP PROCEDURE IF EXISTS SetCounter //

CREATE PROCEDURE SetCounter(
    INOUT counter INT,
    IN inc INT
)
BEGIN
    SET counter = counter + inc;
END //

DELIMITER ;

-- Gọi procedure với tham số INOUT
SET @counter = 1;

CALL SetCounter(@counter, 1); -- @counter = 2
CALL SetCounter(@counter, 1); -- @counter = 3
CALL SetCounter(@counter, 5); -- @counter = 8

SELECT @counter AS FinalCounter;