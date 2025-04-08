USE farm_project;
SELECT * FROM category;


SET SQL_SAFE_UPDATES = 0;
SET SQL_SAFE_UPDATES = 1;
-- Disable foreign key checks to avoid constraint errors during delete
SET FOREIGN_KEY_CHECKS = 0;

-- Delete in the correct order (child tables first, then parent tables)
DELETE FROM report_to;
DELETE FROM inventory_log;
DELETE FROM feedback;
DELETE FROM order_product;
DELETE FROM orders;
DELETE FROM product;
DELETE FROM category;
DELETE FROM users;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;





CREATE TABLE users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    UName VARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    UPassword VARCHAR(255),
    Phone VARCHAR(20),
    DeliveryAddress TEXT,
    OrderHistory TEXT,
    Role ENUM('customer', 'admin') NOT NULL DEFAULT 'customer'
);

CREATE TABLE product (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    PName VARCHAR(100),
    Description_of_product TEXT,
    CategoryID INT,
    Price DECIMAL(10,2),
    Images TEXT,
    StockQuantity INT,
    FOREIGN KEY (CategoryID) REFERENCES category(CategoryID)
);
CREATE TABLE category (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100)
);



CREATE TABLE orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME DEFAULT NOW(),
    Timestamps DATETIME,
    TotalPrice DECIMAL(30,4),
    DeliveryStatus VARCHAR(100),
    FOREIGN KEY (CustomerID) REFERENCES users(UserID)
);

CREATE TABLE order_product (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES product(ProductID)
);

CREATE TABLE feedback (
    FeedbackID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT,
    UserID INT,
    Feedback TEXT,
    Timestamp DATETIME,
    FOREIGN KEY (ProductID) REFERENCES product(ProductID),
    FOREIGN KEY (UserID) REFERENCES users(UserID)
);

CREATE TABLE inventory_log (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT,
    ChangeType VARCHAR(100),
    Timestamp DATETIME,
    FOREIGN KEY (ProductID) REFERENCES product(ProductID)
);

CREATE TABLE report_to (
    SupervisorID INT,
    SubordinateID INT,
    PRIMARY KEY (SupervisorID, SubordinateID),
    FOREIGN KEY (SupervisorID) REFERENCES users(UserID),
    FOREIGN KEY (SubordinateID) REFERENCES users(UserID)
);

ALTER TABLE category
CHANGE COLUMN Name CName VARCHAR(100);

SET AUTOCOMMIT = OFF;
COMMIT;
ROLLBACK;

-- Categories
INSERT INTO category (CName) VALUES 
('Vegetables'), 
('Fruits'), 
('Dairy');

-- Products
INSERT INTO product (PName, Description_of_product, CategoryID, Price, Images, StockQuantity) VALUES
('Tomato', 'Fresh farm tomatoes', 1, 1.20, 'tomato.jpg', 100),
('Apple', 'Red apples from local farms', 2, 0.80, 'apple.jpg', 150),
('Milk', 'Organic cow milk', 3, 2.00, 'milk.jpg', 200);

-- Users
INSERT INTO users (UName, Email, UPassword, Phone, DeliveryAddress, OrderHistory, Role) VALUES
('Sara Ali', 'sara@example.com', 'pass123', '07501234567', 'Erbil, 100m', NULL, 'customer'),
('Admin Aso', 'aso.admin@example.com', 'adminpass', '07509876543', NULL, NULL, 'admin');

-- Orders
INSERT INTO orders (CustomerID, OrderDate, Timestamps, TotalPrice, DeliveryStatus) VALUES
(1, NOW(), NOW(), 3.20, 'Processing');

-- Order_Product
INSERT INTO order_product (OrderID, ProductID, Quantity) VALUES
(1, 1, 2),  -- 2 Tomatoes
(1, 3, 1);  -- 1 Milk

-- Feedback
INSERT INTO feedback (ProductID, UserID, Feedback, Timestamp) VALUES
(1, 1, 'Very fresh tomatoes!', NOW()),
(3, 1, 'Milk was delicious.', NOW());

-- Inventory Log
INSERT INTO inventory_log (ProductID, ChangeType, Timestamp) VALUES
(1, 'Stock reduced by order', NOW()),
(3, 'Stock reduced by order', NOW());

-- Report To (admin hierarchy example)
INSERT INTO report_to (SupervisorID, SubordinateID) VALUES
(2, 2);  -- Self-report for demo, can be changed later



