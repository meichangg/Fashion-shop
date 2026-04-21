CREATE DATABASE fashionshop4;
GO
USE fashionshop4;
GO

------------------------------------------------------------
-- 2. BẢNG KHÁCH HÀNG (CUSTOMERS)
------------------------------------------------------------
IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL
    DROP TABLE dbo.Customers;
GO

CREATE TABLE dbo.Customers
(
    CustomerID     INT IDENTITY(1,1) PRIMARY KEY,
    FullName       NVARCHAR(100) NOT NULL,
    Email          NVARCHAR(100) NOT NULL UNIQUE,
    Phone          NVARCHAR(20) NULL,
    Address        NVARCHAR(255) NULL,
    PasswordHash   NVARCHAR(255) NULL,   -- dự phòng cho login sau này
    CreatedAt      DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

------------------------------------------------------------
-- 3. BẢNG LOẠI SẢN PHẨM (CATEGORIES)
------------------------------------------------------------
IF OBJECT_ID('dbo.Categories', 'U') IS NOT NULL
    DROP TABLE dbo.Categories;
GO

CREATE TABLE dbo.Categories
(
    CategoryID   INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL,
    IsActive     BIT NOT NULL DEFAULT (1)
);
GO

------------------------------------------------------------
-- 4. BẢNG SẢN PHẨM (PRODUCTS)
------------------------------------------------------------
IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL
    DROP TABLE dbo.Products;
GO

CREATE TABLE dbo.Products
(
    ProductID       INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID      INT NOT NULL,
    ProductName     NVARCHAR(150) NOT NULL,
    Description     NVARCHAR(MAX) NULL,
    Price           DECIMAL(18,2) NOT NULL CHECK (Price >= 0),
    DiscountPercent INT NOT NULL DEFAULT(0) CHECK (DiscountPercent BETWEEN 0 AND 100),
    Stock           INT NOT NULL DEFAULT(0) CHECK (Stock >= 0),
    ThumbnailUrl    NVARCHAR(255) NULL,  -- link ảnh để show giao diện
    IsActive        BIT NOT NULL DEFAULT(1),
    CreatedAt       DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    UpdatedAt       DATETIME2 NULL,

    CONSTRAINT FK_Products_Categories
        FOREIGN KEY (CategoryID) REFERENCES dbo.Categories(CategoryID)
);
GO

-- Index phục vụ tìm kiếm theo tên & category
CREATE INDEX IX_Products_CategoryID ON dbo.Products(CategoryID);
CREATE INDEX IX_Products_ProductName ON dbo.Products(ProductName);
GO

------------------------------------------------------------
-- 5. GIỎ HÀNG (SHOPPINGCARTS)
--  Một customer có thể có 1 giỏ "Active"; khi đặt hàng sẽ chuyển giỏ này thành order.
------------------------------------------------------------
IF OBJECT_ID('dbo.ShoppingCarts', 'U') IS NOT NULL
    DROP TABLE dbo.ShoppingCarts;
GO

CREATE TABLE dbo.ShoppingCarts
(
    CartID      INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID  INT NOT NULL,
    Status      TINYINT NOT NULL DEFAULT(0), 
    -- 0 = Active, 1 = Converted/Ordered, 2 = Abandoned (nếu muốn)
    CreatedAt   DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_ShoppingCarts_Customers
        FOREIGN KEY (CustomerID) REFERENCES dbo.Customers(CustomerID)
);
GO

------------------------------------------------------------
-- 6. CHI TIẾT GIỎ HÀNG (CARTITEMS)
------------------------------------------------------------
IF OBJECT_ID('dbo.CartItems', 'U') IS NOT NULL
    DROP TABLE dbo.CartItems;
GO

CREATE TABLE dbo.CartItems
(
    CartItemID  INT IDENTITY(1,1) PRIMARY KEY,
    CartID      INT NOT NULL,
    ProductID   INT NOT NULL,
    Quantity    INT NOT NULL CHECK (Quantity > 0),
    UnitPrice   DECIMAL(18,2) NOT NULL CHECK (UnitPrice >= 0),

    CONSTRAINT FK_CartItems_Carts
        FOREIGN KEY (CartID) REFERENCES dbo.ShoppingCarts(CartID),
    CONSTRAINT FK_CartItems_Products
        FOREIGN KEY (ProductID) REFERENCES dbo.Products(ProductID),

    -- Một sản phẩm chỉ nên xuất hiện 1 lần trong 1 cart (mỗi record là 1 dòng với quantity)
    CONSTRAINT UQ_CartItems_Cart_Product UNIQUE (CartID, ProductID)
);
GO

------------------------------------------------------------
-- 7. ĐƠN HÀNG (ORDERS)
------------------------------------------------------------
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL
    DROP TABLE dbo.Orders;
GO

CREATE TABLE dbo.Orders
(
    OrderID         INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID      INT NOT NULL,
    OrderDate       DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    TotalAmount     DECIMAL(18,2) NOT NULL DEFAULT(0),
    ShippingAddress NVARCHAR(255) NOT NULL,
    Status          NVARCHAR(20) NOT NULL DEFAULT N'Pending', 
    -- Pending / Paid / Shipping / Completed / Cancelled
    PaymentMethod   NVARCHAR(50) NULL, -- COD, Bank Transfer, v.v.
    Note            NVARCHAR(255) NULL,

    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (CustomerID) REFERENCES dbo.Customers(CustomerID)
);
GO

------------------------------------------------------------
-- 8. CHI TIẾT ĐƠN HÀNG (ORDERITEMS)
------------------------------------------------------------
IF OBJECT_ID('dbo.OrderItems', 'U') IS NOT NULL
    DROP TABLE dbo.OrderItems;
GO

CREATE TABLE dbo.OrderItems
(
    OrderItemID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID     INT NOT NULL,
    ProductID   INT NOT NULL,
    Quantity    INT NOT NULL CHECK (Quantity > 0),
    UnitPrice   DECIMAL(18,2) NOT NULL CHECK (UnitPrice >= 0),

    CONSTRAINT FK_OrderItems_Orders
        FOREIGN KEY (OrderID) REFERENCES dbo.Orders(OrderID),
    CONSTRAINT FK_OrderItems_Products
        FOREIGN KEY (ProductID) REFERENCES dbo.Products(ProductID)
);
GO

------------------------------------------------------------
-- 9. DỮ LIỆU MẪU: CATEGORIES
------------------------------------------------------------
SET IDENTITY_INSERT dbo.Categories ON;

INSERT INTO dbo.Categories (CategoryID, CategoryName, IsActive)
VALUES
(1, N'Áo nam', 1),
(2, N'Áo nữ', 1),
(3, N'Quần nam', 1),
(4, N'Quần nữ', 1),
(5, N'Váy đầm', 1),
(6, N'Phụ kiện', 1);

SET IDENTITY_INSERT dbo.Categories OFF;
GO

------------------------------------------------------------
-- 10. DỮ LIỆU MẪU: PRODUCTS
------------------------------------------------------------
INSERT INTO dbo.Products
    (CategoryID, ProductName, Description, Price, DiscountPercent, Stock, ThumbnailUrl)
VALUES
(1, N'Áo thun nam basic', N'Áo thun cotton 100%, form regular, phù hợp mặc hàng ngày.', 199000, 0, 100, N'https://product.hstatic.net/200000404243/product/a2mn438r2-cnma159-2410-n__1__e07e89fa83224938a77506f0816374e5.jpg'),
(1, N'Áo sơ mi nam caro', N'Áo sơ mi caro dài tay, chất vải mát, dễ phối đồ.', 299000, 10, 50, N'https://product.hstatic.net/200000588671/product/ao-so-mi-nam-bycotton-trang-art-nhan_8ec622a241ea4deb93a02bdbdcb87954.jpg'),
(2, N'Áo croptop nữ', N'Áo croptop nữ năng động, trẻ trung.', 249000, 5, 80, N'https://product.hstatic.net/200000642007/product/45pkn_3ftsx0243_2_b55c83a251494b20bb63e123379630e2_master.jpg'),
(3, N'Quần jean nam slimfit', N'Quần jean slimfit co giãn nhẹ, phù hợp đi học hoặc đi làm.', 399000, 0, 70, N'https://lados.vn/wp-content/uploads/2024/07/z4466368792985-2cf464eb0e4b2fed78ad607c8795850d-1687830562705-1.jpeg'),
(4, N'Quần tây nữ', N'Quần tây nữ công sở, chất liệu đứng form.', 359000, 15, 40, N'https://detmaythaihoa.com/wp-content/uploads/2020/08/935-17.png'),
(5, N'Đầm maxi dự tiệc', N'Đầm maxi sang trọng, phù hợp dự tiệc.', 599000, 10, 30, N'https://product.hstatic.net/1000312759/product/___12957634323_2087646882_ced6b55d4be84218a519fc828742017b_1024x1024.jpg'),
(6, N'Thắt lưng da nam', N'Thắt lưng da thật, mặt khóa kim.', 199000, 0, 60, N'https://bizweb.dktcdn.net/thumb/large/100/195/073/products/large-70-0d91ac00-727a-4424-aa41-8f9df031e7e0-jpg-v-1703645951387.jpg?v=1714033689680');
GO

------------------------------------------------------------
-- 11. DỮ LIỆU MẪU: CUSTOMERS
------------------------------------------------------------
INSERT INTO dbo.Customers (FullName, Email, Phone, Address, PasswordHash)
VALUES
(N'Nguyễn Văn A', N'a.nguyen@example.com', N'0901234567', N'Q.1, TP.HCM', NULL),
(N'Trần Thị B', N'b.tran@example.com', N'0907654321', N'Q.3, TP.HCM', NULL);
GO

------------------------------------------------------------
-- 12. VIEW DÙNG XUẤT HÓA ĐƠN (JOIN ORDERS + ORDERITEMS + PRODUCTS)
------------------------------------------------------------
IF OBJECT_ID('dbo.vw_InvoiceDetail', 'V') IS NOT NULL
    DROP VIEW dbo.vw_InvoiceDetail;
GO

CREATE VIEW dbo.vw_InvoiceDetail
AS
SELECT 
    o.OrderID,
    o.OrderDate,
    o.CustomerID,
    c.FullName      AS CustomerName,
    c.Email         AS CustomerEmail,
    c.Phone         AS CustomerPhone,
    o.ShippingAddress,
    o.Status,
    o.PaymentMethod,
    o.TotalAmount,
    oi.OrderItemID,
    oi.ProductID,
    p.ProductName,
    oi.Quantity,
    oi.UnitPrice,
    (oi.Quantity * oi.UnitPrice) AS LineTotal
FROM dbo.Orders o
JOIN dbo.Customers c ON o.CustomerID = c.CustomerID
JOIN dbo.OrderItems oi ON o.OrderID = oi.OrderID
JOIN dbo.Products p ON oi.ProductID = p.ProductID;
GO

------------------------------------------------------------
-- 13. CÁC QUERY MẪU (DÙNG TEST/SAU NÀY NHÚNG VÀO DAO)
------------------------------------------------------------

-- 13.1. Lấy danh sách sản phẩm (phục vụ trang Home / danh sách)
-- SELECT * FROM dbo.Products WHERE IsActive = 1;

-- 13.2. Tìm kiếm theo từ khóa (tên + mô tả)
-- DECLARE @keyword NVARCHAR(100) = N'áo';
-- SELECT p.*
-- FROM dbo.Products p
-- WHERE p.IsActive = 1
--   AND (p.ProductName LIKE N'%' + @keyword + N'%' 
--        OR p.Description LIKE N'%' + @keyword + N'%');

-- 13.3. Lọc theo loại (CategoryID)
-- DECLARE @catId INT = 1;
-- SELECT p.*
-- FROM dbo.Products p
-- WHERE p.IsActive = 1
--   AND p.CategoryID = @catId;

-- 13.4. Lấy chi tiết 1 sản phẩm theo ProductID
-- DECLARE @pid INT = 1;
-- SELECT p.*, c.CategoryName
-- FROM dbo.Products p
-- JOIN dbo.Categories c ON p.CategoryID = c.CategoryID
-- WHERE p.ProductID = @pid;

-- 13.5. Lấy dữ liệu hóa đơn (cho 1 OrderID) để xuất PDF
-- DECLARE @OrderID INT = 1;
-- SELECT * 
-- FROM dbo.vw_InvoiceDetail
-- WHERE OrderID = @OrderID
-- ORDER BY OrderItemID;

------------------------------------------------------------
-- KẾT THÚC SCRIPT SQL
------------------------------------------------------------
