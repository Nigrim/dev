-- Создание временной таблицы с данными о продажах и планах
WITH SalesData AS (
    -- Выбираем необходимые атрибуты и объединяем данные о продажах из разных магазинов
    SELECT
        pl.shop_name,
        p.product_name,
        COALESCE(sd.sales_cnt + mv.sales_cnt + sl.sales_cnt, 0) AS sales_fact, -- Количество фактических продаж
        pl.plan_cnt AS sales_plan, -- Количество запланированных продаж
        COALESCE(sd.sales_cnt + mv.sales_cnt + sl.sales_cnt, 0) / pl.plan_cnt AS sales_fact_plan_ratio, -- Отношение фактических продаж к запланированным
        COALESCE(sd.sales_cnt, 0) * p.price AS income_fact, -- Фактический доход
        pl.plan_cnt * p.price AS income_plan, -- Планируемый доход
        COALESCE(sd.sales_cnt, 0) * p.price / NULLIF(pl.plan_cnt * p.price, 0) AS income_fact_plan_ratio -- Отношение фактического дохода к запланированному
    FROM
        products p
    JOIN
        plan pl ON p.product_id = pl.product_id
    LEFT JOIN
        shop_dns sd ON p.product_id = sd.product_id
    LEFT JOIN
        shop_mvideo mv ON p.product_id = mv.product_id
    LEFT JOIN
        shop_sitilink sl ON p.product_id = sl.product_id
)

-- Создание итоговой таблицы с объединением
SELECT
    s.shop_name,
    s.product_name,
    s.sales_fact,
    s.sales_plan,
    s.sales_fact_plan_ratio,
    s.income_fact,
    s.income_plan,
    s.income_fact_plan_ratio
FROM
    SalesData s;
