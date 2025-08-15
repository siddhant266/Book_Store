-- =========================================
-- 1. DATABASE CREATION
-- =========================================
CREATE DATABASE IF NOT EXISTS OnlineBookstore;
USE OnlineBookstore;

-- =========================================
-- 2. TABLE CREATION
-- =========================================

-- Authors Table
CREATE TABLE Authors (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(50)
);

-- Books Table
CREATE TABLE Books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    author_id INT,
    genre VARCHAR(50),
    price DECIMAL(10,2),
    stock INT,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
);

-- Customers Table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15)
);

-- Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Order_Items Table (Many-to-Many)
CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    book_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

-- =========================================
-- 3. INSERT SAMPLE DATA
-- =========================================

-- Authors
INSERT INTO Authors (name, country) VALUES
('J.K. Rowling', 'UK'),
('George R.R. Martin', 'USA'),
('J.R.R. Tolkien', 'UK'),
('Agatha Christie', 'UK'),
('Dan Brown', 'USA'),
('Haruki Murakami', 'Japan'),
('Stephen King', 'USA'),
('Isaac Asimov', 'USA');

-- Books
INSERT INTO Books (title, author_id, genre, price, stock) VALUES
('Harry Potter', 1, 'Fantasy', 500, 50),
('Game of Thrones', 2, 'Fantasy', 600, 30),
('The Hobbit', 3, 'Fantasy', 450, 40),
('Murder on the Orient Express', 4, 'Mystery', 350, 20),
('Da Vinci Code', 5, 'Thriller', 400, 25),
('Kafka on the Shore', 6, 'Fiction', 380, 15),
('It', 7, 'Horror', 550, 10),
('Foundation', 8, 'Sci-Fi', 480, 35),
('Harry Potter 2', 1, 'Fantasy', 520, 45),
('Game of Thrones 2', 2, 'Fantasy', 620, 28);

-- Customers
INSERT INTO Customers (name, email, phone) VALUES
('Alice', 'alice@example.com', '1234567890'),
('Bob', 'bob@example.com', '0987654321'),
('Charlie', 'charlie@example.com', '1122334455'),
('David', 'david@example.com', '2233445566'),
('Eve', 'eve@example.com', '3344556677');

-- Orders
INSERT INTO Orders (customer_id, order_date, total_amount) VALUES
(1, '2025-08-15', 1100),
(2, '2025-08-14', 600),
(3, '2025-08-13', 380),
(4, '2025-08-12', 450),
(5, '2025-08-11', 1020);

-- Order_Items
INSERT INTO Order_Items (order_id, book_id, quantity, price) VALUES
(1, 1, 1, 500),
(1, 2, 1, 600),
(2, 2, 1, 600),
(3, 6, 1, 380),
(4, 3, 1, 450),
(5, 1, 1, 500),
(5, 9, 1, 520);

-- =========================================
-- 4. UPDATE EXAMPLES
-- =========================================

-- Update stock after a sale
UPDATE Books b
JOIN Order_Items oi ON b.book_id = oi.book_id
SET b.stock = b.stock - oi.quantity
WHERE oi.order_id = 1;

-- Increase price of Fantasy books by 10%
SET SQL_SAFE_UPDATES = 0;

-- Now you can run your UPDATE/DELETE
UPDATE Books
SET price = price * 1.10
WHERE genre = 'Fantasy';

-- Optionally, turn it back on
SET SQL_SAFE_UPDATES = 1;

-- =========================================
-- 5. DELETE EXAMPLES
-- =========================================

-- Delete customers with no orders
DELETE FROM Customers
WHERE customer_id NOT IN (SELECT customer_id FROM Orders);

-- Delete books out of stock
DELETE FROM Books
WHERE stock = 0;

-- =========================================
-- 6. ADVANCED QUERIES
-- =========================================

-- Top-selling books
SELECT b.title, SUM(oi.quantity) AS total_sold
FROM Order_Items oi
JOIN Books b ON oi.book_id = b.book_id
GROUP BY b.title
ORDER BY total_sold DESC;

-- Customer order history
SELECT c.name, o.order_id, o.order_date, o.total_amount
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
ORDER BY o.order_date DESC;

-- Revenue per genre
SELECT b.genre, SUM(oi.price * oi.quantity) AS revenue
FROM Order_Items oi
JOIN Books b ON oi.book_id = b.book_id
GROUP BY b.genre;

-- Authors with most books in stock
SELECT a.name, SUM(b.stock) AS total_stock
FROM Authors a
JOIN Books b ON a.author_id = b.author_id
GROUP BY a.name
ORDER BY total_stock DESC;

-- =========================================
-- 7. VIEWS
-- =========================================

CREATE VIEW Customer_Spending AS
SELECT c.name, SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.name;

-- Query the view
SELECT * FROM Customer_Spending
WHERE total_spent > 500;

-- =========================================
-- 8. STORED PROCEDURES
-- =========================================

DELIMITER //
CREATE PROCEDURE AddOrder(IN cid INT, IN bid INT, IN qty INT)
BEGIN
    DECLARE price DECIMAL(10,2);
    SELECT price INTO price FROM Books WHERE book_id = bid;
    INSERT INTO Orders (customer_id, order_date, total_amount) VALUES (cid, CURDATE(), price * qty);
    INSERT INTO Order_Items (order_id, book_id, quantity, price) VALUES (LAST_INSERT_ID(), bid, qty, price);
    UPDATE Books SET stock = stock - qty WHERE book_id = bid;
END //
DELIMITER ;

-- Call the procedure example
CALL AddOrder(1, 5, 2);

-- =========================================
-- 9. INDEXES
-- =========================================

-- Index on genre for faster search
CREATE INDEX idx_genre ON Books(genre);
