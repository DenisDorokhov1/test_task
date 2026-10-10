-- Active: 1791634346120@@127.0.0.1@3306
CREATE TABLE regions (
    region_id INT PRIMARY KEY,
    region_name VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    region_id INT,
    sale_date DATE,
    amount DECIMAL(10,2),
    product_category VARCHAR(50)
);

INSERT INTO regions VALUES
(1, 'Москва', 'Россия'),
(2, 'СПБ', 'Россия'),
(3, 'Омск', 'Россия'),
(4, 'Новосибирск', 'Россия');

INSERT INTO sales VALUES
(1, 1, '2024-01-10', 15000.00, 'Электроника'),
(2, 1, '2024-01-15', 25000.00, 'Одежда'),
(3, 2, '2024-01-12', 30000.00, 'Электроника'),
(4, 3, '2024-01-14', 12000.00, 'Книги'),
(5, 1, '2024-01-20', 18000.00, 'Электроника'),
(6, 2, '2024-01-18', 22000.00, 'Одежда'),
(7, 2, '2024-01-22', 27000.00, 'Книги'),
(8, 3, '2024-01-25', 35000.00, 'Электроника');

CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT,
    hire_date DATE,
    salary DECIMAL(10,2)
);

CREATE TABLE tasks (
    task_id INT PRIMARY KEY,
    emp_id INT,
    task_date DATE,
    hours_spent DECIMAL(5,2),
    task_priority VARCHAR(20)
);

INSERT INTO departments VALUES
(1, 'IT'), (2, 'HR'), (3, 'Sales');

INSERT INTO employees VALUES
(1, 'Иванов', 1, '2023-01-15', 120000),
(2, 'Петров', 1, '2023-02-20', 115000),
(3, 'Сидорова', 2, '2023-01-10', 80000),
(4, 'Васильев', 2, '2023-03-05', 85000),
(5, 'Козлов', 3, '2023-04-12', 90000);

INSERT INTO tasks VALUES
(1, 1, '2024-03-01', 8.0, 'high'),
(2, 1, '2024-03-01', 7.5, 'medium'),
(3, 2, '2024-03-01', 8.0, 'high'),
(4, 3, '2024-03-01', 4.0, 'low'),
(5, 1, '2024-03-02', 6.0, 'high'),
(6, 2, '2024-03-02', 7.0, 'medium'),
(7, 3, '2024-03-02', 5.0, 'medium'),
(8, 4, '2024-03-02', 8.0, 'high'),
(9, 5, '2024-03-02', 7.0, 'medium'),
(10, 1, '2024-03-03', 4.0, 'low');
