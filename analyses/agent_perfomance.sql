-- Agent performance metrics calculated from fct_sales_month:
--   - Number of sales
--   - Average revenue per sale
--   - Average discount per sale
--   - Total revenue
--   - Ranking by total revenue

SELECT
    sales_agent_name,
    ROUND(AVG(revenue_share), 2) AS avg_revenue,
    count(reference_id) AS number_of_sales,
    ROUND(AVG(discount_amount), 2) AS avg_discount,
    ROUND(SUM(revenue_share), 2) AS total_revenue,
    RANK() OVER (ORDER BY SUM(revenue_share) DESC) AS rank_position
FROM analytics.fct_sales_agents

GROUP BY sales_agent_name;

GROUP BY sales_agent_name
