with raw as (

    select
        -- identifiers
        COALESCE(reference_id, 'n/a') as reference_id,
        COALESCE(country, 'n/a') as country,
        COALESCE(product_code, 'n/a') as product_code,
        COALESCE(product_name, 'n/a') as product_name,

        -- dates (keep NULLs for correct difference calculations)
        subscription_start_date,
        subscription_deactivation_date,
        order_date_kyiv,
        return_date_kyiv,
        last_rebill_date_kyiv,

        -- numeric (NULL → 0)
        COALESCE(subscription_duration_months, 0) as subscription_duration_months,
        COALESCE(total_amount, 0) as total_amount,
        COALESCE(discount_amount, 0) as discount_amount,
        COALESCE(number_of_rebills, 0) as number_of_rebills,
        COALESCE(original_amount, 0) as original_amount,
        COALESCE(returned_amount, 0) as returned_amount,
        COALESCE(total_rebill_amount, 0) as total_rebill_amount,

        -- booleans → text
        COALESCE(has_chargeback::text, 'n/a') as has_chargeback,
        COALESCE(has_refund::text, 'n/a') as has_refund,

        -- other text
        COALESCE(sales_agent_name, 'n/a') as sales_agent_name,
        COALESCE(source, 'n/a') as source,
        COALESCE(campaign_name, 'n/a') as campaign_name

    from {{ source('analytics', 'raw_sales') }}
    where reference_id is not null   -- filter out empty rows
)

select *
from raw




