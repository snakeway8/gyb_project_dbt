-- Agent performance analysis
-- 1. Deduplicate sales by reference_id + revenue + campaign
-- 2. Aggregate metrics per sales agent
-- 3. Rank agents by total revenue
-- =====================================================

WITH deduplicated_sales AS (
    SELECT 
        *,
        row_number() OVER (
            PARTITION BY reference_id, company_revenue, campaign_name
            ORDER BY campaign_name  
        ) AS rn
    FROM analytics.fct_sales_agents
),

agent_performance AS (
    SELECT
        sales_agent_name,
       
        ROUND(AVG(revenue_share), 2) AS avg_revenue,

        -- number of unique sales handled by the agent
        COUNT(DISTINCT reference_id) AS number_of_sales,

       
        ROUND(AVG(discount_amount), 2) AS avg_discount,

       
        ROUND(SUM(revenue_share), 2) AS total_revenue,

        -- rank agents by total revenue (highest first)
        RANK() OVER (ORDER BY SUM(revenue_share) DESC) AS rank_position
    FROM deduplicated_sales
    WHERE rn = 1
    GROUP BY sales_agent_name
)

SELECT *
FROM agent_performance;
