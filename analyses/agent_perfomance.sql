-- Agent performance analysis

-- 1. Aggregate metrics per sales agent
-- 2. Rank agents by total revenue
-- =====================================================

WITH agent_performance AS (
    SELECT
        sales_agent_name,

        -- average revenue per sale
        ROUND(AVG(revenue_share), 2) AS avg_revenue,

        -- number of unique sales handled by the agent
        COUNT(DISTINCT reference_id) AS number_of_sales,

        -- average discount applied
        ROUND(AVG(discount_amount), 2) AS avg_discount,

        -- total revenue attributed to the agent
        ROUND(SUM(revenue_share), 2) AS total_revenue,

        -- rank agents by total revenue (highest first)
        RANK() OVER (ORDER BY SUM(revenue_share) DESC) AS rank_position
    FROM analytics.fct_sales_agents
    GROUP BY sales_agent_name
)

SELECT *
FROM agent_performance;
