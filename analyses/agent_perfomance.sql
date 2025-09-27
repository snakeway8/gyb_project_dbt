-- Agent performance metrics calculated from fct_sales_month:
--   - Number of sales
--   - Average revenue per sale
--   - Average discount per sale
--   - Total revenue
--   - Ranking by total revenue

SELECT
    sales_agent_name,
    ROUND(AVG(company_revenue), 2) AS avg_revenue,
    SUM(number_of_sales) AS number_of_sales,
    ROUND(AVG(total_discount), 2) AS avg_discount,
    ROUND(SUM(company_revenue), 2) AS total_revenue,
    RANK() OVER (ORDER BY SUM(company_revenue) DESC) AS rank_position
FROM analytics.fct_sales_month
WHERE sales_agent_name <> 'n/a'
GROUP BY sales_agent_name
