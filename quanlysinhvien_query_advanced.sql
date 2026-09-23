-- Sử dụng cơ sở dữ liệu QuanLySinhVien
USE QuanLySinhVien;

-- 1. Hiển thị tất cả các sinh viên có tên bắt đầu bằng ký tự 'h'
SELECT * 
FROM Student 
WHERE StudentName LIKE 'h%';

-- 2. Hiển thị các thông tin lớp học có thời gian bắt đầu vào tháng 12
SELECT * 
FROM Class 
WHERE MONTH(StartDate) = 12;

-- 3. Hiển thị tất cả các thông tin môn học có credit trong khoảng từ 3-5
SELECT * 
FROM Subject 
WHERE Credit BETWEEN 3 AND 5;

-- 4. Thay đổi mã lớp (ClassId) của sinh viên có tên 'Hung' thành 2
-- Tắt chế độ an toàn tạm thời (nếu có) để update theo tên
SET SQL_SAFE_UPDATES = 0;

UPDATE Student 
SET ClassId = 2 
WHERE StudentName = 'Hung';

SET SQL_SAFE_UPDATES = 1;

-- 5. Hiển thị các thông tin: StudentName, SubName, Mark.
-- Sắp xếp theo điểm thi (Mark) giảm dần, nếu trùng điểm thì sắp theo tên (StudentName) tăng dần.
SELECT S.StudentName, Sub.SubName, M.Mark
FROM Student S
JOIN Mark M ON S.StudentId = M.StudentId
JOIN Subject Sub ON M.SubId = Sub.SubId
ORDER BY M.Mark DESC, S.StudentName ASC;