/*======================================================
    CREATE SCHEMA AND TABLES
======================================================*/
CREATE DATABASE IF NOT EXISTS school_demo;
USE school_demo;

-- Drop tables if they exist (clean environment)
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

-- CUSTOMERS TABLE
CREATE TABLE customers (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

-- ORDERS TABLE
CREATE TABLE orders (
    id INT PRIMARY KEY,
    customer_id INT,
    product VARCHAR(50)
);


/*======================================================
    INSERT DATA
======================================================*/
INSERT INTO customers VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie'),
(4, 'Diana');      -- No order

INSERT INTO orders VALUES
(1, 1, 'Laptop'),
(2, 1, 'Mouse'),
(3, 3, 'Keyboard'),
(4, 5, 'Monitor');  -- Order WITHOUT a valid customer
                    -- (customer_id = 5 does NOT exist)


-- INNER JOIN = ONLY matches from both tables
SELECT customers.id as idCustomer, customers.name as customer, orders.id as idProduct, orders.product
FROM customers
INNER JOIN orders
    ON customers.id = orders.customer_id;

/*
Bob does NOT appear (no orders)
Diana does NOT appear (no orders)
Order with customer_id = 5 does NOT appear (the customer does not exist)
*/


-- LEFT JOIN = all LEFT rows + matches
SELECT customers.id as idCustomer, customers.name as customer, orders.id as idProduct, orders.product
FROM customers
LEFT JOIN orders
    ON customers.id = orders.customer_id;

/*
 Order with customer_id = 5 does NOT appear because it has no matching customer
*/

-- RIGHT JOIN = all RIGHT rows + matches
SELECT customers.id as idCustomer, customers.name as customer, orders.id as idProduct, orders.product
FROM customers
RIGHT JOIN orders
    ON customers.id = orders.customer_id;

/*
Bob and Diana do NOT appear because they have no orders
*/
