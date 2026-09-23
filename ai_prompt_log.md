\# Nhật ký Tương tác AI (AI Prompt Log) - SmartFactory Index Tuning

Lượt 1: Bản chất của Covering Index và chi phí lưu trữ

Prompt: "Covering Index là gì? Tại sao việc nhét tất cả các cột của bảng SensorLogs vào một Secondary Index lại làm dung lượng Index lớn hơn cả Data Length trong InnoDB?"



Tóm tắt phản hồi: Covering Index là chỉ mục chứa toàn bộ các cột cần thiết cho câu truy vấn SELECT, giúp MySQL lấy dữ liệu ngay từ các node lá của B-Tree mà không cần thực hiện tra cứu lại bảng gốc (Bookmark Lookup). Tuy nhiên, trong InnoDB, mỗi dòng trong Secondary Index luôn tự động kèm theo khóa chính (log\_id - 8 bytes). Khi đưa thêm các trường temperature (3 bytes), humidity (3 bytes), và status (VARCHAR(20) \~ 21 bytes), kích thước mỗi bản ghi index tăng đột biến. Cùng với chi phí header của trang B-Tree và khoảng trống phân mảnh trang, dung lượng của Secondary Index dễ dàng vượt xa bảng dữ liệu chính.



Lượt 2: Cơ chế Write Penalty trong hệ thống IoT tốc độ cao

Prompt: "Hãy giải thích chi tiết khái niệm 'Write Penalty'. Tại sao một bảng nhận 10,000 bản ghi INSERT/giây lại sụp đổ nếu dùng Fat Covering Index?"



Tóm tắt phản hồi: Write Penalty là chi phí hiệu năng tiêu tốn trên các thao tác ghi dữ liệu do phải bảo trì các chỉ mục phụ. Với 10.000 INSERT/giây, nếu dùng Fat Index, MySQL phải ghi dữ liệu 2 lần: một lần vào Clustered Index (Primary Key) và một lần vào Secondary B-Tree Index. Vì các giá trị nhiệt độ, độ ẩm và thời gian đến liên tục, các node lá của B-Tree nhanh chóng bị đầy, gây ra hiện tượng tách trang (Page Split) và xáo trộn ngẫu nhiên trên đĩa cứng (Random Disk I/O), làm cạn kiệt băng thông ghi và gây nghẽn toàn bộ đường ống truyền dữ liệu.



Lượt 3: Tính toán byte dữ liệu (Data Byte Calculation) giữa VARCHAR và TINYINT

Prompt: "Nếu thay đổi cột status từ VARCHAR(20) sang TINYINT trong bảng có 100 triệu dòng, dung lượng lưu trữ của Data và Index sẽ được tiết kiệm chính xác bao nhiêu byte?"



Tóm tắt phản hồi:



VARCHAR(20) dùng bảng mã UTF-8 cần 1 byte biểu diễn độ dài chuỗi + tối đa 20 bytes cho chuỗi ký tự (trung bình tiêu tốn khoảng 8 đến 10 bytes).



TINYINT chỉ tiêu tốn đúng 1 byte duy nhất.



Việc chuyển đổi tiết kiệm trung bình từ 7 đến 9 bytes trên mỗi bản ghi. Với 100 triệu dòng, hệ thống tiết kiệm được xấp xỉ 700MB đến 900MB cho dữ liệu thực tế, và nếu cột này nằm trong Index thì tiết kiệm thêm một lượng dung lượng tương đương trên cây B-Tree.

