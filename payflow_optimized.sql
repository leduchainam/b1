CREATE DATABASE IF NOT EXISTS payflow_db;
USE payflow_db;

DROP TABLE IF EXISTS Transactions;

CREATE TABLE Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    amount DECIMAL(15,2),
    transaction_type VARCHAR(20),
    created_at DATETIME
) ENGINE=InnoDB;

INSERT INTO Transactions (user_id, amount, transaction_type, created_at) VALUES
(1, 5000000.00, 'DEPOSIT',  '2026-06-05 10:15:00'),
(2, 2000000.00, 'DEPOSIT',  '2026-06-20 14:30:00'),
(3, 1500000.00, 'WITHDRAW', '2026-06-12 09:00:00'),
(1, 3000000.00, 'DEPOSIT',  '2026-05-28 11:20:00'),
(4, 7500000.00, 'DEPOSIT',  '2026-07-02 08:45:00');

-- 1. Truy vấn cũ (chưa có index, dùng hàm)
EXPLAIN 
SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT' 
  AND YEAR(created_at) = 2026 
  AND MONTH(created_at) = 6;

-- 2. Tạo composite index
CREATE INDEX idx_type_date ON Transactions(transaction_type, created_at);

-- 3. Truy vấn tối ưu (dùng range)
EXPLAIN 
SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT' 
  AND created_at >= '2026-06-01 00:00:00' 
  AND created_at <  '2026-07-01 00:00:00';

-- 4. Xuất kết quả kiểm tra
SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT' 
  AND created_at >= '2026-06-01 00:00:00' 
  AND created_at <  '2026-07-01 00:00:00';