-- 1.	Рассчитать KPI для каждого сотрудника (количество задач, часы, среднее время на задачу)
SELECT
    e.emp_id,
    e.emp_name,
    COUNT(t.task_id) as tasks_num,
    COALESCE(SUM(t.hours_spent), 0) as total_hours,
    ROUND(
        COALESCE(AVG(t.hours_spent), 0),
        2
    ) avg_hours
FROM employees e
    LEFT JOIN tasks t ON t.emp_id = e.emp_id
GROUP BY
    e.emp_id

-- 2.	Определить сотрудников, которые перерабатывают (часы > среднего по отделу + 20%)
WITH
    employee_totals AS (
        SELECT e.emp_id, e.emp_name, e.dept_id, COALESCE(SUM(t.hours_spent), 0) as total_hours
        FROM employees e
            LEFT JOIN tasks t ON t.emp_id = e.emp_id
        GROUP BY
            e.emp_id
    ),
    departments_hours AS (
        SELECT dept_id, AVG(total_hours) AS dept_avg_time
        FROM employee_totals
        GROUP BY
            dept_id
    )
SELECT et.emp_id, et.emp_name, et.total_hours, dh.dept_avg_time
FROM
    employee_totals et
    JOIN departments_hours dh ON et.dept_id = dh.dept_id
WHERE
    et.total_hours > dh.dept_avg_time * 1.20

-- 3.	Создать временную таблицу с ранжированием сотрудников внутри отдела
-- по зарплате
CREATE TEMPORARY TABLE temp_dept_ranks AS
SELECT e.emp_id, e.emp_name, e.dept_id, e.salary, RANK() OVER (
        PARTITION BY
            e.dept_id
        ORDER BY e.salary DESC
    ) AS salary_rank
FROM employees e

-- вывод временной таблицы
SELECT * FROM temp_dept_ranks

-- по отработанным часам
CREATE TEMPORARY TABLE temp_employee_hours_rank AS
WITH
    employee_totals AS (
        SELECT e.emp_id, e.emp_name, e.dept_id, COALESCE(SUM(t.hours_spent), 0) AS total_hours
        FROM employees e
            LEFT JOIN tasks t ON e.emp_id = t.emp_id
        GROUP BY
            e.emp_id
    )
SELECT
    emp_id,
    emp_name,
    dept_id,
    total_hours,
    RANK() OVER (
        PARTITION BY
            dept_id
        ORDER BY total_hours DESC
    ) AS hours_rank
FROM employee_totals

-- вывод таблицы
SELECT * FROM temp_employee_hours_rank ORDER BY dept_id, hours_rank

-- 4.	Вывести сводную статистику по отделам
SELECT
    d.dept_id,
    d.dept_name,
    COUNT(DISTINCT e.emp_id) AS total_employees,
    COUNT(t.task_id) AS total_tasks,
    COALESCE(SUM(t.hours_spent), 0) AS total_hours,
    ROUND(COALESCE(AVG(e.salary), 0), 2) AS avg_salary
FROM
    departments d
    LEFT JOIN employees e ON d.dept_id = e.dept_id
    LEFT JOIN tasks t ON e.emp_id = t.emp_id
GROUP BY
    d.dept_id