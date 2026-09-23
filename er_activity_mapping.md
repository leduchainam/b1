\# Phân tích Ánh xạ Quy trình (ER - Activity Mapping)

\*\*Dự án:\*\* AutoRide - Quản lý Thuê và Trả xe

\*\*Vai trò:\*\* Data Architect

3 Khoảng trống dữ liệu (Data Gaps) của hệ thống cũ:

Trạng thái thiếu ràng buộc: Dùng VARCHAR(50) cho cột status không ngăn chặn được giá trị rác, không kiểm soát được 4 trạng thái cốt lõi: BOOKED, ACTIVE, COMPLETED, CANCELLED.



Khuyết thiếu toàn bộ dòng tiền phạt: Không có các cột security\_deposit, late\_fee, damage\_fee, khiến hệ thống mất khả năng tính toán số tiền hoàn cọc (Refund = Deposit - LateFee - DamageFee), dẫn đến thất thoát tài chính.



Thiếu thực thể Kiểm tra xe (Inspections): Không có nơi lưu trữ vết hư hại, người kiểm tra và thời điểm bàn giao xe.



Tầm quan trọng của cột damage\_fee:

Cột damage\_fee là bắt buộc để đảm bảo tính toàn vẹn hệ thống và hạch toán dòng tiền:



Khép kín nhánh rẽ nghiệp vụ: Activity Diagram phân nhánh trực tiếp: Có hư hỏng -> Tính phí sửa chữa. Nếu không có damage\_fee, quy trình nghiệp vụ trên ứng dụng bị đứt gãy tại bước quyết toán.



Minh bạch tài chính: Đảm bảo đối soát giữa biên bản hư hỏng thực tế và số tiền cọc trừ của khách, ngăn chặn việc thất thoát doanh thu của doanh nghiệp.

