-- models/marts/fct_sales_agents.sql
-- =====================================================
-- Fact table: mapping between sales and agents
-- Each sale (reference_id) may have multiple agents.
-- Company revenue is split equally among agents.
-- =====================================================

with base as (
    select
        reference_id,
        order_date_kyiv,
        sales_agent_name,
        campaign_name,

        -- calculate company revenue
        total_amount + total_rebill_amount - returned_amount as company_revenue,
        discount_amount
    from analytics.stg_sales
    where sales_agent_name <> 'n/a'   -- exclude invalid agents
),

agent_counts as (
    select
        reference_id,
        order_date_kyiv,
        company_revenue,
        count(distinct sales_agent_name) as agent_count
    from base
    group by reference_id, company_revenue, order_date_kyiv
),

final as (
    select
        b.reference_id,
        b.order_date_kyiv,
        b.sales_agent_name,
        b.campaign_name,
        b.company_revenue,
        b.discount_amount,

        -- split company revenue equally among agents
        round(b.company_revenue / ac.agent_count, 2) as revenue_share
    from base b
    join agent_counts ac
      on b.reference_id = ac.reference_id
     and b.order_date_kyiv = ac.order_date_kyiv
     and b.company_revenue = ac.company_revenue
)

select *
from final
