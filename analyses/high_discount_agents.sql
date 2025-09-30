-- =====================================================
-- Agents with above-average discount behavior

-- 1. Calculate per-agent average discount
-- 2. Compare each agent's avg_discount to the global average
-- =====================================================

WITH global_discount AS (
    SELECT
        sales_agent_name,
        
        -- average discount for each agent
        ROUND(AVG(discount_amount), 2) AS avg_discount,

        -- global average discount across all agents
        ROUND(AVG(AVG(discount_amount)) OVER (), 2) AS global_avg_discount
    FROM analytics.fct_sales_agents
    GROUP BY sales_agent_name
)

SELECT 
    sales_agent_name
FROM global_discount
WHERE avg_discount > global_avg_discount;