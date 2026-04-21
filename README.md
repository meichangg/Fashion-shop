Fashion E-commerce System: 	
Dự án giải quyết nhu cầu chuyển đổi số cho các cửa hàng thời trang truyền thống, tập trung vào trải nghiệm mua sắm tiện lợi và quản lý kho bãi hiệu quả.


Công nghệ sử dụng:
Hệ thống được triển khai theo mô hình MVC để tách biệt nghiệp vụ và giao diện:
- Frontend: HTML, CSS, JSP, Figma (Thiết kế).
- Backend: Java (Servlet/JSP), JDBC kết nối SQL Server.
- Server: Apache Tomcat

  
Thiết kế hệ thống (System Design)
- UML Diagrams: Bao gồm Use Case Diagram (tương tác người dùng), Activity Diagram (luồng nghiệp vụ đăng nhập, đặt hàng).
- Data Design: Mô hình ERD chuẩn hóa đảm bảo tính nhất quán dữ liệu giữa các bảng Customers, Products, Orders và OrderItems.

  
Quy trình nghiệp vụ (Business Processes):
Mô hình hóa các quy trình cốt lõi để đảm bảo logic hệ thống thông suốt:
- Quy trình Đặt hàng: Xem sản phẩm → Thêm vào giỏ hàng (Kiểm tra tồn kho) → Xác nhận thông tin → Đặt hàng & trích xuất hóa đơn.


 Đảm bảo chất lượng (QA/Testing): Để đảm bảo sản phẩm đầu ra đúng yêu cầu, tôi đã xây dựng bộ Test Cases chi tiết:
 - Kiểm thử chức năng: Kiểm tra các trường hợp Positive (Đặt hàng thành công) và Negative (Thêm số lượng vượt tồn kho, tìm kiếm từ khóa không tồn tại).
 - Kiểm thử tích hợp: Đảm bảo dữ liệu từ giỏ hàng được chuyển đổi chính xác sang đơn hàng và trừ số lượng tồn kho tương ứng.
