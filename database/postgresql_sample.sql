-- PostgreSQL Sample Database Setup
-- Database: postgresql_sample

CREATE DATABASE postgresql_sample;

\c postgresql_sample

-- Table 1: customers
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    registration_date DATE DEFAULT CURRENT_DATE
);

-- Table 2: products
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    category VARCHAR(50),
    stock_quantity INTEGER DEFAULT 0
);

-- Table 3: orders
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'pending'
);

-- Insert sample data into customers
INSERT INTO customers (first_name, last_name, email) VALUES
('John', 'Doe', 'john.doe@example.com'),
('Jane', 'Smith', 'jane.smith@example.com'),
('Robert', 'Johnson', 'robert.j@example.com'),
('Emily', 'Davis', 'emily.d@example.com'),
('Michael', 'Wilson', 'michael.w@example.com'),
('Sarah', 'Brown', 'sarah.b@example.com'),
('David', 'Miller', 'david.m@example.com');

-- Insert sample data into products
INSERT INTO products (product_name, price, category, stock_quantity) VALUES
('Laptop', 999.99, 'Electronics', 15),
('Smartphone', 699.99, 'Electronics', 30),
('Headphones', 149.99, 'Electronics', 50),
('Desk Chair', 199.99, 'Furniture', 10),
('Coffee Mug', 9.99, 'Kitchen', 100),
('Notebook', 4.99, 'Office', 200),
('Pen Set', 12.99, 'Office', 150);

-- Insert sample data into orders
INSERT INTO orders (customer_id, total_amount, status) VALUES
(1, 999.99, 'completed'),
(1, 149.99, 'completed'),
(2, 699.99, 'shipped'),
(3, 199.99, 'processing'),
(4, 9.99, 'completed'),
(5, 12.99, 'completed'),
(6, 4.99, 'completed'),
(7, 999.99, 'processing'),
(1, 199.99, 'pending'),
(2, 149.99, 'shipped');
