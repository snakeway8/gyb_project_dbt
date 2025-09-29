-- =====================================================
-- Agents with above-average discount behavior
-- 1. Deduplicate sales by reference_id + revenue + campaign
-- 2. Calculate per-agent average discount
-- 3. Compare each agent's avg_discount to the global average
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

global_discount AS (
    SELECT
        sales_agent_name,
        -- average discount for each agent
        ROUND(AVG(discount_amount), 2) AS avg_discount,

        -- global average discount across all agents
        ROUND(AVG(AVG(discount_amount)) OVER (), 2) AS global_avg_discount
    FROM deduplicated_sales
    WHERE rn = 1
    GROUP BY sales_agent_name
)

SELECT 
    sales_agent_name
   
FROM global_discount
WHERE avg_discount > global_avg_discount;