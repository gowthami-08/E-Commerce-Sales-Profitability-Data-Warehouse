# 🛒 E-Commerce Sales & Profitability Data Warehouse

## 📌 Project Overview

This project implements a complete end-to-end **E-commerce Sales & Profitability Data Warehouse** using **MySQL**.  
Raw transactional data from an e-commerce platform is transformed into a **star schema** to enable fast, reliable, and meaningful analytical reporting.

The project focuses on **data modeling, SQL-based ETL, KPI computation, monthly trend analysis, and performance optimization**, following real-world data engineering best practices.

---

## 🎯 Objectives

- Convert raw e-commerce CSV data into a structured analytical warehouse  
- Design a **star schema** with fact and dimension tables  
- Calculate key business metrics such as **AOV, LTV, repeat rate, return rate**  
- Enable **monthly sales and customer trend analysis**  
- Optimize query performance using **indexes and query execution plans**

---

## 📂 Dataset Information

**Source:** Kaggle – Olist E-Commerce Dataset  

This dataset represents a real online marketplace and contains information about:
- Orders  
- Customers  
- Products  
- Sellers  
- Payments  
- Reviews  

### 📊 Dataset Size (Approximate)

| Table        | Rows  | Columns |
|--------------|-------|---------|
| Orders       | ~99K  | 8 |
| Order Items  | ~112K | 7 |
| Customers    | ~99K  | 5 |
| Products     | ~33K  | 9 |
| Sellers      | ~3K   | 4 |
| Payments     | ~103K | 5 |
| Reviews      | ~100K | 7 |

---

## 🏗️ Project Architecture

CSV Files
↓
Staging Tables (stg_)
↓
ETL using SQL
↓
Dimension Tables (dim_)
↓
Fact Table (fact_sales)
↓
Views & KPIs


---

## 🧱 Data Warehouse Design

### ⭐ Schema Used
**Star Schema**

---

### ⭐ Fact Table

**fact_sales**

- **Grain:** One product per order  
- Stores measurable business data  

**Measures:**
- price  
- revenue  
- quantity  
- payment_value  
- review_score  

---

### ⭐ Dimension Tables

| Dimension Table | Description |
|-----------------|-------------|
| dim_customer | Customer details |
| dim_product | Product information |
| dim_seller | Seller information |
| dim_date | Time attributes for analysis |

---

## 🧪 Staging Layer

Staging tables (`stg_*`) store raw CSV data **exactly as received**, without constraints or transformations.

### Why staging?
- Protects raw data  
- Enables validation and debugging  
- Follows industry ETL best practices  

---

## 🔄 ETL Process

ETL is implemented entirely using **SQL**.

### Extract
- CSV files loaded using `LOAD DATA INFILE`

### Transform
- Handle NULL values  
- Join multiple source tables  
- Aggregate payment records  
- Derive date attributes  

### Load
- Insert clean data into dimension tables  
- Insert transformed data into fact table  

---

## 📈 KPIs & Metrics Implemented

| Metric | Description |
|------|-------------|
| Total Revenue | Total money earned |
| Total Orders | Number of unique orders |
| Average Order Value (AOV) | Average spend per order |
| Customer Lifetime Value (LTV) | Revenue per customer |
| Repeat Purchase Rate | Percentage of repeat customers |
| Return Rate | Percentage of cancelled/unavailable orders |
| Average Price | Average product price |

---

## 📊 Reporting & Views

The following analytical views are created for reporting and dashboards:

- `vw_monthly_sales`  
- `vw_monthly_aov`  
- `vw_monthly_returns`  
- `vw_monthly_customer_type`  

These views provide **monthly trends** and are **BI-tool ready**.

---

## ⚡ Performance Optimization

- Indexes created on:
  - Fact table foreign keys  
  - Date and customer columns  
- Query execution plans analyzed using `EXPLAIN`  
- Materialized summary table created for faster monthly reporting  

---

## ✅ Data Validation

The project includes data quality checks such as:
- No NULL date keys  
- No negative revenue  
- Valid foreign key relationships  
- Row count consistency between layers  

---

## 📁 Repository Structure

ecommerce-sql-warehouse/
│
├── 01_staging_tables.sql
├── 02_dimension_tables.sql
├── 03_fact_table.sql
├── 04_etl_dimensions.sql
├── 05_etl_fact.sql
├── 06_kpi_queries.sql
├── 07_monthly_views.sql
├── 08_indexes_optimization.sql
├── Ecommerce_Sales_Profitability_Warehouse_Report.pdf
├── Ecommerce_Sales_Profitability_Warehouse_Report.docx
└── README.md


---

## 🏁 Final Outcome

At the end of this project, we obtain:
- A clean and optimized **E-commerce Data Warehouse**
- Accurate business KPIs
- Monthly analytical insights
- SQL queries optimized for performance
- A project suitable for real-world analytics and decision-making

---

## 🚀 Skills Demonstrated

- Data Warehouse Design  
- Star Schema Modeling  
- SQL-based ETL  
- Analytical SQL  
- KPI Development  
- Performance Tuning  
- Data Validation  

---

## 📌 One-Line Summary

This project transforms raw e-commerce data into a structured, optimized data warehouse that delivers meaningful business insights using advanced SQL analytics.

---

## 📬 Future Enhancements

- Profit margin analysis  
- Incremental data loading  
- Power BI / Tableau dashboards  
- Automation using schedulers  
