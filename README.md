# Online Bookstore SQL Project

## Overview
This is a **complete SQL project** simulating an **Online Bookstore** database.  
It demonstrates practical SQL skills including **database design, table relationships, CRUD operations, advanced queries, views, stored procedures, and indexes**.  
This project is suitable for showcasing SQL knowledge for interviews, portfolios, or GitHub.

---

## Features

- **Relational Database Design**
  - Authors, Books, Customers, Orders, Order_Items
  - Many-to-Many relationships (Orders ↔ Books)

- **CRUD Operations**
  - Insert, Update, Delete, and Select queries
  - Example: Update book stock after a sale

- **Advanced Queries**
  - Top-selling books
  - Customer order history
  - Revenue per genre
  - Authors with most books in stock

- **Views**
  - `Customer_Spending` view to show total spending per customer

- **Stored Procedures**
  - `AddOrder` procedure to add a new order and update stock automatically

- **Indexes**
  - Index on `Books.genre` for faster query performance

---

## Database Schema

**Tables and Relationships:**

- **Authors** (`author_id`, `name`, `country`)  
- **Books** (`book_id`, `title`, `author_id`, `genre`, `price`, `stock`)  
- **Customers** (`customer_id`, `name`, `email`, `phone`)  
- **Orders** (`order_id`, `customer_id`, `order_date`, `total_amount`)  
- **Order_Items** (`order_item_id`, `order_id`, `book_id`, `quantity`, `price`)  

**Relationships:**

- One-to-Many: `Authors` → `Books`  
- One-to-Many: `Customers` → `Orders`  
- Many-to-Many: `Orders` ↔ `Books` (through `Order_Items`)

---

## Sample Queries

**1. List all books with authors:**
```sql
SELECT b.title, a.name AS author, b.genre, b.price
FROM Books b
JOIN Authors a ON b.author_id = a.author_id;
