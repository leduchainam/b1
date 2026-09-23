#### File 2: `autoride_db.sql`
```sql
CREATE DATABASE IF NOT EXISTS autoride_db;
USE autoride_db;

DROP TABLE IF EXISTS Inspections;
DROP TABLE IF EXISTS Rentals;
DROP TABLE IF EXISTS Cars;

CREATE TABLE Cars (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    license_plate VARCHAR(20) UNIQUE NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Rentals (
    rental_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    rent_date DATETIME NOT NULL,
    return_date DATETIME NULL,
    status ENUM('BOOKED', 'ACTIVE', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'BOOKED',
    security_deposit DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    late_fee DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    damage_fee DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    FOREIGN KEY (car_id) REFERENCES Cars(car_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE Inspections (
    inspection_id INT AUTO_INCREMENT PRIMARY KEY,
    rental_id INT NOT NULL,
    inspection_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    damage_description TEXT NOT NULL,
    inspector_name VARCHAR(100) NOT NULL,
    FOREIGN KEY (rental_id) REFERENCES Rentals(rental_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

DELIMITER $$
CREATE TRIGGER trg_check_inspection_status
BEFORE INSERT ON Inspections
FOR EACH ROW
BEGIN
    DECLARE current_status VARCHAR(20);
    SELECT status INTO current_status FROM Rentals WHERE rental_id = NEW.rental_id;
    IF current_status = 'BOOKED' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Loi nghiep vu: Khong the lap bien ban kiem tra khi xe chua duoc giao (trang thai dang la BOOKED)!';
    END IF;
END$$
DELIMITER ;

-- Kịch bản dữ liệu mô phỏng
INSERT INTO Cars (model_name, license_plate) VALUES ('VinFast VF8', '30A-999.88');

INSERT INTO Rentals (car_id, customer_name, rent_date, status, security_deposit)
VALUES (1, 'Nguyen Van A', '2026-10-01 08:00:00', 'ACTIVE', 10000000.00);
SET @rental_id = LAST_INSERT_ID();

INSERT INTO Inspections (rental_id, inspection_date, damage_description, inspector_name)
VALUES (@rental_id, '2026-10-03 10:00:00', 'Vỡ đèn pha trái', 'Tran Nhan Vien');

UPDATE Rentals
SET status = 'COMPLETED',
    return_date = '2026-10-03 10:00:00',
    late_fee = 0.00,
    damage_fee = 2000000.00
WHERE rental_id = @rental_id;

-- Truy vấn quyết toán hoàn cọc
SELECT 
    r.rental_id,
    r.customer_name,
    c.model_name,
    c.license_plate,
    r.security_deposit,
    r.late_fee,
    r.damage_fee,
    (r.security_deposit - r.late_fee - r.damage_fee) AS refund_amount,
    i.damage_description,
    i.inspector_name
FROM Rentals r
JOIN Cars c ON r.car_id = c.car_id
LEFT JOIN Inspections i ON r.rental_id = i.rental_id
WHERE r.rental_id = @rental_id;