-- models/example/marts/fct_sales_agents.sql
-- =====================================================
-- Fact table: mapping sales to agents
-- One row = one agent per unique sale
-- Revenue is equally split among agents for the same sale
-- =====================================================

WITH base_sales AS (
    SELECT
        reference_id,
        order_date_kyiv,
        sales_agent_name,
        campaign_name,

        -- calculate company revenue
        total_amount + total_rebill_amount - returned_amount AS company_revenue,
        discount_amount
    FROM {{ ref('stg_sales') }}
    WHERE sales_agent_name <> 'n/a'   -- exclude invalid agents
),

deduplicated_sales AS (
    SELECT 
        *,
        row_number() OVER (
            PARTITION BY reference_id, company_revenue, sales_agent_name
            ORDER BY sales_agent_name  
        ) AS rn 
    FROM base_sales
),

unique_sales AS (
    SELECT *
    FROM deduplicated_sales
    WHERE rn = 1   -- keep only one row per reference_id + company_revenue + sales_agent_name
),

agent_counts AS (
    SELECT
        reference_id,
        order_date_kyiv,
        company_revenue,
        COUNT(DISTINCT sales_agent_name) AS agent_count
    FROM unique_sales
    GROUP BY reference_id, company_revenue, order_date_kyiv
),

final_sales_agents AS (
    SELECT
        u.reference_id,
        u.order_date_kyiv,
        u.sales_agent_name,
        u.campaign_name,
        u.company_revenue,
        u.discount_amount,

        -- split company revenue equally among agents
        ROUND(u.company_revenue / ac.agent_count, 2) AS revenue_share
    FROM unique_sales u
    JOIN agent_counts ac
      ON u.reference_id = ac.reference_id
     AND u.order_date_kyiv = ac.order_date_kyiv
     AND u.company_revenue = ac.company_revenue
)

SELECT *
FROM final_sales_agents
