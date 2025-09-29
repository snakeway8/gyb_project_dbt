-- models/marts/fct_sales_month.sql
-- Monthly aggregated sales fact table
-- This model aggregates sales from fct_sales on a monthly level


WITH monthly AS (
    SELECT
        -- time dimension
        DATE_TRUNC('month', order_date_kyiv) AS month,

        -- product and sales context
        product_name,
        country,
        campaign_name,
        source,

        

        -- metrics (aggregated)
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
        source
)

SELECT *
FROM monthly
ORDER BY month, product_name
