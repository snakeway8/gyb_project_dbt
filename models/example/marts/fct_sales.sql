-- fct_sales
-- One row = one sale (reference_id, campaign_name, total_amount)
-- This model creates the transactional fact table:
--   - calculates company_revenue (total + rebill – returned)
--   - adds order/return dates in three time zones (Kyiv, UTC, New York)
--   - calculates days_to_return (difference between return and purchase)
--   - removes duplicates by keeping the latest order per (reference_id, campaign_name, total_amount)
--   - excludes rows where campaign_name = 'n/a'
-- =====================================================

with base as (
    select
        reference_id,
        product_name,
        country,
        campaign_name,
        source,
        sales_agent_name,

        -- derived metric
        total_amount + total_rebill_amount - returned_amount as company_revenue,

        -- keep original fields
        total_rebill_amount,
        number_of_rebills,
        returned_amount,
        discount_amount,
        total_amount,

        -- dates in different time zones
        order_date_kyiv,
        order_date_kyiv at time zone 'Europe/Kiev' at time zone 'UTC' as order_date_utc,
        order_date_kyiv at time zone 'Europe/Kiev' at time zone 'America/New_York' as order_date_ny,

        return_date_kyiv,
        return_date_kyiv at time zone 'Europe/Kiev' at time zone 'UTC' as return_date_utc,
        return_date_kyiv at time zone 'Europe/Kiev' at time zone 'America/New_York' as return_date_ny,

        -- days difference (if return exists)
        case
            when return_date_kyiv is not null and order_date_kyiv is not null
                then date_part('day', return_date_kyiv - order_date_kyiv)
            else null
        end as days_to_return
    from {{ ref('stg_sales') }}
    where campaign_name <> 'n/a'  
),
dedup as (
    select
        *,
        row_number() over (
            partition by reference_id, campaign_name, total_amount
            order by order_date_kyiv desc
        ) as rn
    from base
)

select *
from dedup
where rn = 1
