

-- analyses/monthly_revenue_growth_from_fct_sales_month.sql


WITH monthly_revenue AS (
    SELECT
        month,
        SUM(company_revenue) AS total_revenue
    FROM analytics.fct_sales_month
    GROUP BY month
)

SELECT
    month,
    total_revenue,
    ROUND(
        100 * (total_revenue - LAG(total_revenue) OVER (ORDER BY month))
        / NULLIF(LAG(total_revenue) OVER (ORDER BY month), 0), 
        2
    ) AS revenue_growth_pct
FROM monthly_revenue
ORDER BY month