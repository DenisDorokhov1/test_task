import numpy as np
import pandas as pd

# Товары
products = pd.DataFrame(
    {
        "product_id": [1, 2, 3, 4, 5, 6, 7, 8],
        "product_name": [
            "Ноутбук",
            "Телефон",
            "Книга",
            "Футболка",
            "Часы",
            "Планшет",
            "Кроссовки",
            "Сумка",
        ],
        "category": [
            "Электроника",
            "Электроника",
            "Книги",
            "Одежда",
            "Аксессуары",
            "Электроника",
            "Одежда",
            "Аксессуары",
        ],
        "price": [50000, 30000, 500, 1500, 8000, 25000, 4500, 3500],
        "stock_quantity": np.random.randint(5, 50, 8),
    }
)

# Продажи
sales = pd.DataFrame(
    {
        "sale_id": range(1, 31),
        "product_id": np.random.choice([1, 2, 3, 4, 5, 6, 7, 8], 30),
        "quantity": np.random.randint(1, 5, 30),
        "date": pd.date_range("2024-03-01", "2024-03-15", periods=30),
    }
)

# 1.	Рассчитать общее количество проданных товаров по каждому продукту
merged_df = pd.merge(products[["product_id"]], sales, on="product_id", how="left")

units_sold_count = (
    merged_df.groupby(["product_id"]).agg(total_sales=("quantity", "sum")).reset_index()
)
print("=" * 25, "Task 1", "=" * 25)
print(units_sold_count)

# 2.	Добавить информацию о товаре (название, категория, цена, остаток)
more_info = pd.merge(
    products[["product_id", "product_name", "category", "price", "stock_quantity"]],
    units_sold_count,
    on="product_id",
)
print("=" * 25, "Task 2", "=" * 25)
print(more_info)

# 3.	Рассчитать для каждого товара:
# Выручку (цена * проданное количество)
# Остаток после продаж (stock_quantity - проданное количество)
# Признак "Товар заканчивается" (остаток < 3)
more_info["total_sales"] = more_info["total_sales"].fillna(0)

more_info["revenue"] = more_info["price"] * more_info["total_sales"]
more_info["remaining_stock"] = more_info["stock_quantity"] - more_info["total_sales"]
more_info["is_finishing"] = more_info["remaining_stock"] < 3

print("=" * 25, "Task 3", "=" * 25)
print(
    more_info[
        [
            "product_name",
            "price",
            "total_sales",
            "revenue",
            "remaining_stock",
            "is_finishing",
        ]
    ]
)

# 4.	Вывести товары, которые заканчиваются (остаток < 3)
finishing_products = more_info[more_info["is_finishing"]]
print("=" * 25, "Task 4", "=" * 25)
print(finishing_products[["product_name", "remaining_stock", "is_finishing"]])

# 5.	Посчитать выручку по категориям
revenue_by_category = more_info.groupby("category")["revenue"].sum().reset_index()

print("=" * 25, "Task 5", "=" * 25)
print(revenue_by_category.sort_values(by="revenue", ascending=False))