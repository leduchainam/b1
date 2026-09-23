-- 1. Tạo và sử dụng CSDL company
CREATE DATABASE IF NOT EXISTS company;
USE company;

-- 2. Dọn dẹp bảng và trigger cũ (nếu có)
DROP TABLE IF EXISTS employees;
DROP TRIGGER IF EXISTS update_department;

-- 3. Tạo bảng employees
CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2) NOT NULL
);

-- 4. Tạo Trigger BEFORE INSERT để tự động cập nhật department dựa trên salary
DELIMITER //

CREATE TRIGGER update_department
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary >= 5000 THEN
        SET NEW.department = 'Management';
    ELSEIF NEW.salary >= 3000 THEN
        SET NEW.department = 'Sales';
    ELSE
        SET NEW.department = 'Support';
    END IF;
END //

DELIMITER ;

-- 5. Chèn dữ liệu kiểm thử (dù ban đầu để department là 'A')
INSERT INTO employees (name, department, salary) VALUES
('John Doe', 'A', 3500),
('Jane Smith', 'A', 2000),
('David Johnson', 'A', 6000);

-- 6. Kiểm tra kết quả: department đã tự động cập nhật theo salary
SELECT * FROM employees;