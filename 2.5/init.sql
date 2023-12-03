-- Создание таблицы "shops" с информацией о магазинах
CREATE TABLE shops (
    shop_id INT PRIMARY KEY,
    shop_name VARCHAR(255) NOT NULL
);

-- Обновление таблицы "plan" с учетом магазинов
ALTER TABLE plan
ADD COLUMN shop_id INT,
ADD FOREIGN KEY (shop_id) REFERENCES shops(shop_id);

-- Создание временной таблицы с объединенными данными из shop_*
WITH ShopSales AS (
    SELECT
        'DNS' AS shop_name,
        product_id,
        sales_cnt
    FROM
        shop_dns

    UNION ALL

    SELECT
        'MVideo' AS shop_name,
        product_id,
        sales_cnt
    FROM
        shop_mvideo

    UNION ALL

    SELECT
        'SitiLink' AS shop_name,
        product_id,
        sales_cnt
    FROM
        shop_sitilink
)

-- Объединение данных из ShopSales с plan, products и shops
SELECT
    s.shop_name,
    p.product_name,
    COALESCE(ss.sales_cnt, 0) AS sales_fact,
    pl.plan_cnt AS sales_plan,
    COALESCE(ss.sales_cnt, 0) / pl.plan_cnt AS sales_fact_plan_ratio,
    COALESCE(ss.sales_cnt, 0) * p.price AS income_fact,
    pl.plan_cnt * p.price AS income_plan,
    COALESCE(ss.sales_cnt, 0) * p.price / NULLIF(pl.plan_cnt * p.price, 0) AS income_fact_plan_ratio
FROM
    ShopSales ss
JOIN
    plan pl ON ss.product_id = pl.product_id
JOIN
    products p ON ss.product_id = p.product_id
JOIN
    shops s ON s.shop_name = ss.shop_name;

