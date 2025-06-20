CREATE DATABASE ECommerceDB;
GO
USE ECommerceDB;
GO

-- 1. Bảng người dùng
CREATE TABLE tblUsers (
    userID VARCHAR(20) PRIMARY KEY,
    fullName NVARCHAR(100),
    roleID VARCHAR(5),
    password NVARCHAR(100),
    phone VARCHAR(15)
);
GO

-- 4. Chương trình khuyến mãi
CREATE TABLE tblPromotions (
    promoID INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100),
    discountPercent FLOAT,
    startDate DATE,
    endDate DATE,
    status VARCHAR(20)
);
GO

-- 2. Ngành hàng
CREATE TABLE tblCategories (
    categoryID INT PRIMARY KEY IDENTITY(1,1),
    categoryName NVARCHAR(100),
    description NVARCHAR(255),
	promoID INT,
	FOREIGN KEY (promoID) REFERENCES tblPromotions(promoID)
);
GO

-- 3. Sản phẩm
CREATE TABLE tblProducts (
    productID INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100),
    categoryID INT,
    price FLOAT,
    quantity INT,
    sellerID VARCHAR(20),
	promoID INT,
    status VARCHAR(20),
	FOREIGN KEY (promoID) REFERENCES tblPromotions(promoID),
    FOREIGN KEY (categoryID) REFERENCES tblCategories(categoryID),
    FOREIGN KEY (sellerID) REFERENCES tblUsers(userID)
);
GO

-- 5. Giỏ hàng
CREATE TABLE tblCarts (
    cartID INT PRIMARY KEY IDENTITY(1,1),
    userID VARCHAR(20),
    createdDate DATE,
    FOREIGN KEY (userID) REFERENCES tblUsers(userID)
);
GO

CREATE TABLE tblCartDetails (
    cartID INT,
    productID INT,
    quantity INT,
    PRIMARY KEY (cartID, productID),
    FOREIGN KEY (cartID) REFERENCES tblCarts(cartID),
    FOREIGN KEY (productID) REFERENCES tblProducts(productID)
);
GO

-- 6. Hóa đơn
CREATE TABLE tblInvoices (
    invoiceID INT PRIMARY KEY IDENTITY(1,1),
    userID VARCHAR(20),
    totalAmount FLOAT,
    status VARCHAR(20),
    createdDate DATE,
    FOREIGN KEY (userID) REFERENCES tblUsers(userID)
);
GO

CREATE TABLE tblInvoiceDetails (
    invoiceID INT,
    productID INT,
    quantity INT,
    price FLOAT,
    PRIMARY KEY (invoiceID, productID),
    FOREIGN KEY (invoiceID) REFERENCES tblInvoices(invoiceID),
    FOREIGN KEY (productID) REFERENCES tblProducts(productID)
);
GO

-- 7. Giao hàng
CREATE TABLE tblDeliveries (
    deliveryID INT PRIMARY KEY IDENTITY(1,1),
    invoiceID INT,
    address NVARCHAR(255),
    deliveryDate DATE,
    status VARCHAR(50),
    FOREIGN KEY (invoiceID) REFERENCES tblInvoices(invoiceID)
);
GO

-- 8. Trả hàng
CREATE TABLE tblReturns (
    returnID INT PRIMARY KEY IDENTITY(1,1),
    invoiceID INT,
    reason NVARCHAR(255),
    status VARCHAR(50),
    FOREIGN KEY (invoiceID) REFERENCES tblInvoices(invoiceID)
);
GO

-- 9. Chăm sóc khách hàng
CREATE TABLE tblCustomerCares (
    ticketID INT PRIMARY KEY IDENTITY(1,1),
    userID VARCHAR(20),
    subject NVARCHAR(100),
    content TEXT,
    status VARCHAR(50),
    reply TEXT,
    FOREIGN KEY (userID) REFERENCES tblUsers(userID)
);
GO

-- 1. tblUsers
INSERT INTO tblUsers (userID, fullName, roleID, password, phone) VALUES
('ltk', N'Lương Tuấn Kiệt', 'AD', '1', '0888819044'),
('user01', N'Nguyễn Văn A', 'US', 'pass123', '0912345678'),
('seller01', N'Trần Thị B', 'SE', 'abc123', '0909123456'),
('user02', N'Phạm Văn C', 'US', 'pw456', '0932123456');

-- 2. tblCategories
INSERT INTO tblCategories (categoryName, description) VALUES
(N'Điện thoại', N'Smartphone chính hãng'),
(N'Máy tính', N'Laptop, desktop và linh kiện'),
(N'Gia dụng', N'Thiết bị sử dụng trong gia đình');

-- 3. tblPromotions
INSERT INTO tblPromotions (name, discountPercent, startDate, endDate, status) VALUES
(N'Summer Sale', 10.0, '2025-06-01', '2025-06-30', N'Đang áp dụng'),
(N'Back to School', 5.0, '2025-07-01', '2025-07-15', N'Sắp diễn ra');

-- 4. tblProducts
INSERT INTO tblProducts (name, categoryID, price, quantity, sellerID, status, promoID) VALUES
(N'iPhone 15 Pro', 1, 28990000, 20, 'seller01', N'Còn hàng', 1),
(N'Dell XPS 13', 2, 27990000, 10, 'seller01', N'Còn hàng', 1),
(N'Nồi chiên không dầu', 3, 1990000, 30, 'seller01', N'Còn hàng', NULL);

-- 5. tblCarts
INSERT INTO tblCarts (userID, createdDate) VALUES
('ltk', '2025-06-17'),
('user01', '2025-06-18');

-- 6. tblCartDetails
INSERT INTO tblCartDetails (cartID, productID, quantity) VALUES
(1, 1, 1),
(1, 3, 2),
(2, 2, 1);

-- 7. tblInvoices
INSERT INTO tblInvoices (userID, totalAmount, status, createdDate) VALUES
('ltk', 32970000, N'Đã thanh toán', '2025-06-18'),
('user01', 27990000, N'Chưa thanh toán', '2025-06-19');

-- 8. tblInvoiceDetails
INSERT INTO tblInvoiceDetails (invoiceID, productID, quantity, price) VALUES
(1, 1, 1, 28990000),
(1, 3, 2, 1990000),
(2, 2, 1, 27990000);

-- 9. tblDeliveries
INSERT INTO tblDeliveries (invoiceID, address, deliveryDate, status) VALUES
(1, N'123 Lê Lợi, Q.1, TP.HCM', '2025-06-20', N'Đang giao'),
(2, N'456 Phạm Văn Đồng, Hà Nội', NULL, N'Chưa giao');

-- 10. tblReturns
INSERT INTO tblReturns (invoiceID, reason, status) VALUES
(1, N'Lỗi kỹ thuật', N'Đã tiếp nhận');

-- 11. tblCustomerCares
INSERT INTO tblCustomerCares (userID, subject, content, status, reply) VALUES
('ltk', N'Không nhận được sản phẩm', N'Tôi đã đặt hàng nhưng chưa thấy giao', N'Chờ xử lý', NULL),
('user01', N'Sản phẩm bị hư', N'Sản phẩm không hoạt động khi mở hộp', N'Đang xử lý', 