# 🚀 Sales Analytics with dbt  

This project demonstrates how raw sales transactions can be transformed into **business-ready insights** using **dbt + PostgreSQL**.  
It follows best practices from real-world data teams: staging → fact models → analyses.  

---

## 📂 Project structure  

**models/**  
- `staging/` → cleaned raw data  
  - `stg_sales.sql` → standardizes and cleans raw sales data  
- `marts/` → fact tables for analytics  
  - `fct_sales.sql` → transactional fact table (one row = one sale)  
  - `fct_sales_month.sql` → monthly aggregated fact table  

**analyses/**  
- `monthly_revenue_growth.sql` → calculates month-over-month revenue growth 📈  
- `agent_performance.sql` → evaluates sales agents’ performance (revenue, discounts, ranking) 👩‍💼  
- `high_discount_agents.sql` → identifies agents giving above-average discounts 💸  

**seeds/**  
- CSV data sources for testing (loaded with `dbt seed`)  

**tests/**  
- Data quality & integrity checks (e.g., no NULL IDs, valid dates)  

**snapshots/**  
- Reserved for slowly changing dimensions (not used in this project)  

---

## 🛠️ Tech stack  

- **dbt-core** – transformation & data modeling  
- **PostgreSQL** – data warehouse  
- **SQL + Jinja** – transformations and macros  

---

## 🌟 Business goals  

1. Build a **single source of truth** for sales data.  
2. Provide a **fact table** with revenue, rebills, refunds, discounts, and agent participation.  
3. Deliver **monthly marts** for trend analysis and reporting.  
4. Enable analysts to quickly answer questions:  
   - How does revenue grow month over month?  
   - Which agents bring the most revenue?  
   - Who gives higher-than-average discounts?  

---

## ▶️ How to run  

1. Install dbt and PostgreSQL.  
2. Set up your connection in `profiles.yml`.  
3. Run:  

```bash
dbt seed       # load CSV test data
dbt run        # build staging + fact tables
dbt test       # run data quality tests
dbt docs serve # open interactive dbt docs

