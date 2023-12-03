WITH union_shops_tabl AS (
    SELECT * FROM shop_citilink
    UNION ALL SELECT * FROM shop_dns
    UNION ALL SELECT * FROM shop_mvideo
    ORDER BY sale_date, shop_id, product_id
)	  
, avg_check_data AS (
    SELECT 
        toMonth(sale_date) AS sale_month,
        shop_name, 
        product_name, 
        SUM(sales_cnt) AS sales_fact,
        SUM(plan_cnt) AS sales_plan,
        ROUND(SUM(sales_cnt)::FLOAT / SUM(plan_cnt), 2) AS "sales_fact/sales_plan",
        SUM(price * sales_cnt) AS income_fact,
        SUM(price * plan_cnt) AS income_plan,
        ROUND((SUM(price * sales_cnt)::FLOAT / SUM(price * plan_cnt)), 2) AS "income_fact/income_plan",
        RANK() OVER (PARTITION BY product_name ORDER BY ROUND((SUM(price * sales_cnt)::FLOAT / SUM(plan_cnt)), 2) DESC) AS rank_max_avg_check
    FROM 
        union_shops_tabl us
    JOIN 
        shops sh ON us.shop_id = sh.shop_id
    JOIN 
        products pr ON us.product_id = pr.product_id 
    JOIN 
        plan p ON us.product_id = p.product_id AND us.shop_id = p.shop_id AND us.sale_date = p.plan_date 
    WHERE 
        toMonth(sale_date) = 5
    GROUP BY 
        sale_month, shop_name, product_name
)
SELECT 
    sale_month,
    shop_name, 
    product_name, 
    sales_fact,
    sales_plan,
    "sales_fact/sales_plan",
    income_fact,
    income_plan,
    "income_fact/income_plan",
    sale_month AS max_avg_check_date,
    "sales_fact/sales_plan" AS max_avg_check_value
FROM 
    avg_check_data
WHERE 
    rank_max_avg_check = 1
ORDER BY 
    shop_name, product_name;
