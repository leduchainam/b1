\# Giải trình Kỹ thuật: Phân biệt COUNT(o.order\_id) và COUNT(\*) khi dùng LEFT JOIN



Trong truy vấn `LEFT JOIN`, với các bản ghi thuộc bảng bên trái không có quan hệ tương ứng ở bảng bên phải (ví dụ: khách hàng `Charlie`), toàn bộ các cột từ bảng `Orders` sẽ mang giá trị `NULL`.



\- \*\*Hàm `COUNT(\*)`:\*\* Đếm số lượng hàng thực tế được sinh ra sau phép kết nối. Dù dòng của Charlie mang toàn giá trị `NULL` ở các trường của bảng `Orders`, dòng đó vẫn tồn tại trong tập kết quả, khiến `COUNT(\*)` trả về giá trị \*\*1\*\* (sai lệch nghiệp vụ nghiêm trọng).

\- \*\*Hàm `COUNT(o.order\_id)`:\*\* Bỏ qua các giá trị `NULL` trên cột được chỉ định. Vì `o.order\_id` của Charlie là `NULL`, hàm trả về chính xác \*\*0 đơn hàng\*\*.



Do đó, bắt buộc sử dụng `COUNT(o.order\_id)` để đảm bảo tính đúng đắn cho báo cáo Marketing.

