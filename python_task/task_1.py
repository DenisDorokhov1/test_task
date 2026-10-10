import numpy as np
import pandas as pd

# Сотрудники
employees = pd.DataFrame(
    {
        "emp_id": [101, 102, 103, 104, 105, 106, 107, 108],
        "name": [
            "Иванов",
            "Петров",
            "Сидоров",
            "Васильева",
            "Козлов",
            "Морозова",
            "Волков",
            "Соколова",
        ],
        "department": ["IT", "IT", "Sales", "Sales", "HR", "HR", "Sales", "IT"],
        "salary": [120000, 115000, 90000, 95000, 80000, 85000, 88000, 118000],
    }
)
# Продажи
sales = pd.DataFrame(
    {
        "sale_id": range(1, 21),
        "emp_id": [
            101,
            101,
            102,
            103,
            103,
            103,
            104,
            104,
            105,
            106,
            107,
            107,
            108,
            101,
            103,
            104,
            107,
            108,
            102,
            105,
        ],
        "amount": np.random.randint(10000, 100000, 20),
        "month": np.random.choice(["Январь", "Февраль", "Март"], 20),
    }
)

# 1.	Посчитать для каждого сотрудника: сумму продаж и количество продаж
merged_df = pd.merge(employees[["emp_id", "name"]], sales, on="emp_id", how="left")

employee_info = (
    merged_df.groupby(["emp_id"])
    .agg(total_sales=("amount", "sum"), sales_count=("sale_id", "count"))
    .reset_index()
)

print("=" * 25, "Task 1", "=" * 25)
print(employee_info)

# 2.	Добавить информацию об отделе и зарплате из таблицы employees
result_dept = pd.merge(
    employee_info,
    employees[["emp_id", "department", "salary"]],
    on="emp_id",
    how="left",
)
print("=" * 25, "Task 2", "=" * 25)
print(result_dept)

# 3.	Рассчитать для каждого отдела: среднюю зарплату, общую сумму продаж, количество сотрудников
dept_employees = (
    employees.groupby("department")["emp_id"]
    .nunique()
    .reset_index(name="employee_count")
)
mean_dept_salary = (
    employees.groupby("department")["salary"].mean().round(2).reset_index(name="avg_salary")
)

sales_with_department = pd.merge(
    sales, employees[["emp_id", "department"]], on="emp_id", how="left"
)
dept_sales = (
    sales_with_department.groupby("department")["amount"]
    .sum()
    .reset_index(name="total_sales")
)

result_dept_stats = dept_employees.merge(mean_dept_salary, on="department").merge(
    dept_sales, on="department"
)

print("=" * 25, "Task 3", "=" * 25)
print(result_dept_stats)

# 4.	Найти отдел с максимальной эффективностью (сумма продаж / сумма зарплат)
sum_dept_salary = (
    employees.groupby("department")["salary"].sum().reset_index(name="sum_salry")
)
department_salary = result_dept_stats.merge(sum_dept_salary, on="department")
department_salary["efficiency"] = (
    department_salary["total_sales"] / department_salary["sum_salry"]
).round(2)
max_efficiency_dept = department_salary.loc[department_salary["efficiency"].idxmax()]

print("=" * 25, "Task 4", "=" * 25)
print(department_salary)
print()
print(
    f"Самый эффективный отдел: {max_efficiency_dept['department']} (коэффициент: {max_efficiency_dept['efficiency']:.2f})"
)

# 5.	Вывести топ-3 сотрудника по сумме продаж
top_sales = sales.groupby("emp_id")["amount"].sum().reset_index(name="sum_sales")
top_employees = pd.merge(employees, top_sales, on="emp_id", how="left")
top_3 = top_employees.sort_values(by="sum_sales", ascending=False).head(3)

print("=" * 25, "Task 5", "=" * 25)
print(top_3[["name", "department", "sum_sales"]])
