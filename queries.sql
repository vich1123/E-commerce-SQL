-- Create the database
drop database if exists ecommerce;
create database ecommerce;
use ecommerce;

-- Create customers table
create table customers (
    id int auto_increment primary key,
    name varchar(255) not null,
    email varchar(255) unique not null,
    address text
);

-- Create products table
create table products (
    id int auto_increment primary key,
    name varchar(255) not null,
    price decimal(10,2) not null,
    description text
);

-- Create orders table
create table orders (
    id int auto_increment primary key,
    customer_id int not null,
    order_date date not null,
    total_amount decimal(10,2) not null,
    foreign key (customer_id) references customers(id) on delete cascade
);

-- Insert sample data into customers
to customers (name, email, address) values
('John Doe', 'john@example.com', '123 Main St'),
('Jane Smith', 'jane@example.com', '456 Park Ave'),
('Alice Brown', 'alice@example.com', '789 Elm St');

-- Insert sample data into products
insert into products (name, price, description) values
('Product A', 25.00, 'Description of Product A'),
('Product B', 30.00, 'Description of Product B'),
('Product C', 40.00, 'Description of Product C');

-- Insert sample data into orders
insert into orders (customer_id, order_date, total_amount) values
(1, CURDATE(), 100.00),
(2, CURDATE() - INTERVAL 10 DAY, 150.00),
(3, CURDATE() - INTERVAL 40 DAY, 200.00);

-- Retrieve all customers who have placed an order in the last 30 days
select distinct c.*
from customers c
join orders o on c.id = o.customer_id
where o.order_date >= CURDATE() - INTERVAL 30 DAY;

-- Get the total amount of all orders placed by each customer
select customer_id, sum(total_amount) as total_spent
from orders
group by customer_id;

-- Update the price of Product C to 45.00
update products
set price = 45.00
where name = 'Product C';

-- Add a new column discount to the products table
alter table products add column discount decimal(5,2) default 0.00;

-- Retrieve the top 3 products with the highest price
select * from products
order by price desc
limit 3;

-- Get the names of customers who have ordered Product A
select distinct c.name
from customers c
join orders o on c.id = o.customer_id
join order_items oi on o.id = oi.order_id
join products p on oi.product_id = p.id
where p.name = 'Product A';

-- Join the orders and customers tables to retrieve the customer's name and order date for each order
select c.name, o.order_date
from customers c
join orders o on c.id = o.customer_id;

-- Retrieve the orders with a total amount greater than 150.00
select * from orders where total_amount > 150.00;

-- Normalize the database by creating an order_items table and updating the orders table
create table order_items (
    id int auto_increment primary key,
    order_id int not null,
    product_id int not null,
    quantity int not null,
    subtotal decimal(10,2) not null,
    foreign key (order_id) references orders(id) on delete cascade,
    foreign key (product_id) references products(id) on delete cascade
);

alter table orders drop column total_amount;

-- Retrieve the average total of all orders
select avg(o.total_amount) as avg_order_total from orders o;
