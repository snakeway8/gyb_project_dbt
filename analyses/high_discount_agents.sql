
-- Find agents whose average discount is above the global average

WITH global_discount AS (
    SELECT
        sales_agent_name,
        ROUND(AVG(discount_amount), 2) AS avg_discount,
        ROUND(AVG(AVG(discount_amount)) OVER (), 2) AS global_avg_discount
    FROM analytics.fct_sales_agents
  
    GROUP BY sales_agent_name
)
SELECT 
    sales_agent_name  
FROM global_discount
WHERE avg_discount > global_avg_discount