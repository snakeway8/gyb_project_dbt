-- models/marts/fct_sales_month.sql
-- Monthly aggregated sales fact table
-- This model aggregates sales from fct_sales on a monthly level
-- and enriches them with a list of all agents involved in each product sale.

WITH monthly AS (
    SELECT
        -- time dimension
        DATE_TRUNC('month', order_date_kyiv) AS month,

        -- product and sales context
        product_name,
        country,
        campaign_name,
        source,
        sales_agent_name,

        -- revenue metrics (aggregated)
        COUNT(reference_id) AS number_of_sales,
        SUM(company_revenue) AS company_revenue,
        SUM(total_rebill_amount) AS rebill_revenue,
        SUM(number_of_rebills) AS rebill_count,
        SUM(returned_amount) AS total_returned,
        SUM(discount_amount) AS total_discount,
        SUM(days_to_return) AS total_days_to_return
    FROM {{ ref('fct_sales') }}
    GROUP BY 
        DATE_TRUNC('month', order_date_kyiv),
        product_name,
        country,
        campaign_name,
        source,
        sales_agent_name
),

agents AS (
    SELECT
        -- group by the same keys except agent
        DATE_TRUNC('month', order_date_kyiv) AS month,
        product_name,
        country,
        campaign_name,
        source,

        -- collect all agents involved into a single string
        STRING_AGG(DISTINCT sales_agent_name, ', ') AS sales_agents_list
    FROM {{ ref('fct_sales') }}
    GROUP BY 
        DATE_TRUNC('month', order_date_kyiv),
        product_name,
        country,
        campaign_name,
        source
)

SELECT 
    m.*,
    a.sales_agents_list
FROM monthly m
LEFT JOIN agents a
    ON m.month = a.month
   AND m.product_name = a.product_name
   AND m.country = a.country
   AND m.campaign_name = a.campaign_name
   AND m.source = a.source
ORDER BY m.month, m.product_name
