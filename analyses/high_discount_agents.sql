
-- Find agents whose average discount is above the global average

WITH global_discount AS (
    SELECT
        sales_agent_name,
        ROUND(AVG(total_discount), 2) AS avg_discount,
        ROUND(AVG(AVG(total_discount)) OVER (), 2) AS global_avg_discount
    FROM analytics.fct_sales_month
    WHERE sales_agent_name <> 'n/a'
    GROUP BY sales_agent_name
)
SELECT 
    sales_agent_name   
FROM global_discount
WHERE avg_discount > global_avg_discount