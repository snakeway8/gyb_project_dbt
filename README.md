Sales Analytics with dbt

This project demonstrates how raw sales transactions can be transformed into business-ready insights using dbt + PostgreSQL. It follows best practices from real-world data teams: staging → fact models → analyses.

Project structure

models/

staging/ → cleaned raw data

stg_sales.sql → standardizes and cleans raw sales data

marts/ → fact tables for analytics

fct_sales.sql → transactional fact table (one row = one sale)

fct_sales_month.sql → monthly aggregated fact table

analyses/

monthly_revenue_growth.sql → calculates month-over-month revenue growth 📈

agent_performance.sql → evaluates sales agents’ performance (revenue, discounts, ranking) 👩‍💼

high_discount_agents.sql → identifies agents giving above-average discounts 💸

seeds/

CSV data sources for testing (loaded with dbt seed)

tests/

Data quality & integrity checks (e.g., no NULL IDs, valid dates)

snapshots/

Reserved for slowly changing dimensions (not used in this project)

results/ (final output tables in CSV format)

agent_performance.csv → aggregated metrics on sales agents (revenue, discounts, ranking)

fct_sales.csv → transactional fact table (one row per sale)

fct_sales_month.csv → monthly aggregated fact table

high_discount_agents.csv → agents giving above-average discounts

monthly_revenue_growth.csv → month-over-month revenue dynamics

stg_sales.csv → cleaned and standardized raw sales data

Tech stack

dbt-core – transformation & data modeling

PostgreSQL – data warehouse



🌟 Business goals

Build a single source of truth for sales data.

Provide a fact table with revenue, rebills, refunds, discounts, and agent participation.

Deliver monthly marts for trend analysis and reporting.

Enable analysts to quickly answer questions:

How does revenue grow month over month?

Which agents bring the most revenue?

Who gives higher-than-average discounts?
