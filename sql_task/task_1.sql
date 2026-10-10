-- 1.	Вывести все регионы и суммарные продажи по каждому (включая регионы без продаж)
SELECT r.region_name, COALESCE(SUM(s.amount), 0) as sum_sales
FROM regions r
    LEFT JOIN sales s ON r.region_id = s.region_id
GROUP BY
    r.region_id

-- 2.	Найти регионы, продажи в которых выше средних продаж по всем регионам
WITH
    region_totals AS (
        SELECT r.region_name, COALESCE(SUM(s.amount), 0) AS sum_sales
        FROM regions r
            LEFT JOIN sales s ON r.region_id = s.region_id
        GROUP BY
            r.region_id,
            r.region_name
    )
SELECT region_name
FROM region_totals
WHERE
    sum_sales > (
        SELECT AVG(sum_sales)
        FROM region_totals
    )

-- 3.	Для каждого региона определить ранг по сумме продаж
WITH
    region_totals AS (
        SELECT r.region_name, COALESCE(SUM(s.amount), 0) AS sum_sales
        FROM regions r
            LEFT JOIN sales s ON r.region_id = s.region_id
        GROUP BY
            r.region_id,
            r.region_name
    )
SELECT
    region_name,
    sum_sales,
    RANK() OVER (
        ORDER BY sum_sales DESC
    ) AS sales_rank
FROM region_totals

-- 4.	Вывести топ-2 региона по сумме продаж.
SELECT r.region_name, COALESCE(SUM(s.amount), 0) as sum_sales
FROM regions r
    LEFT JOIN sales s ON r.region_id = s.region_id
GROUP BY
    r.region_id
ORDER BY sum_sales DESC
LIMIT 2