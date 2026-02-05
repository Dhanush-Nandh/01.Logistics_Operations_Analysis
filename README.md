# 01.Logistics Operations Analysis

## Project Overview
**Logistics Operations & Asset Performance Analytics:** This project provides an end-to-end data solution for a mid-sized trucking firm and analyses three years of logistics data using SQL and Power BI. I transformed 14 raw relational datasets into a multi-page executive dashboard. The goal was to identify "profit-killers" like detention time, fuel inefficiency, and safety liabilities that are often hidden in raw operational logs. *CHANGE THIS LATER*

## Tools Used
* **SQL Server(SSMS):** Data cleaning, ETL (Extract, Transform, Load), JOINing tables, data type standardization, and building a reporting layer via SQL Views.
* **Power BI:** Star Schema data modeling, and interactive visuals using DAX for performance KPIs. 
* **Logistics Domain Knowledge:** Applied industry expertise to define "at-risk" metrics for drivers and assets.

## The Data
The dataset is a comprehensive Logistics Operations Database (sourced from Kaggle https://www.kaggle.com/datasets/yogape/logistics-operations-database), consisting of 14 CSV files representing:
* **Core Tables:** drivers, trucks, trailers, customers, facilities, routes
* **Transaction Tables:** loads, trips, fuel_purchases, maintenance_records, delivery_events, safety_incidents
* **Aggregated Metrics:** driver_monthly_metrics, truck_utilization_metrics

## SQL Highlights: Data Engineering & ETL
**Challenge:** Upon ingestion, numeric financial/float data was truncated due to SSMS "Flat File" import limitations (Float/Decimal precision errors). 
**Solution:** I implemented a robust "Staging-to-Production" pipeline:
1. Ingested raw data as VARCHAR to prevent data loss.
2. Developed 01_Data_Cleaning.sql using Nested TRY_CAST (VARCHAR → FLOAT → DECIMAL) approach to ensure string-to-numeric precision.
3. Used SELECT comparison statements to audit the results. By filtering for **WHERE RawColumn IS NOT NULL AND CleanColumn IS NULL**, I could instantly identify any rows that failed the transformation.
> **Note:** *ADD A NOTE LATER*

## Data Modeling (Power BI)
*UPDATE THIS SECTION LATER AS YOU WORK FURTHER*
*I moved beyond flat-file analysis by building a Star Schema within Power BI.
Fact Tables: Loads, Fuel_Purchases, Safety_Incidents.
Dimension Tables: Drivers, Trucks, Facilities.
The Benefit: This structure allows for "cross-filtering"—for example, seeing how a specific Driver (Dim) impacts Fuel_Purchases (Fact) vs. Safety_Incidents (Fact).*

## Power BI Dashboard
*SAVE SPACE HERE - Include screenshots of your dashboard here*

* **Key Metric 1:** *ADD KPI 1*.
* **Key Metric 2:** *ADD KPI 2*.
* **Key Metric 3:** *ADD KPI 3*.

*CHANGE THE BELOW DATA AS PER FINAL VIEWS*
*Executive View: Total Revenue vs. Total Cost (Fuel + Maintenance).
Asset Health: Identifying trucks with high downtime and low utilization.
Safety Audit: Highlighting at-fault incidents and their direct cost to the bottom line.*

## Key Insights
*UPDATE THIS SECTION LATER AS YOU WORK FURTHER*
*1. Detention Impact: Which facilities have the highest wait times, and how does that correlate with "Accessorial Charges"?
2. Fuel Efficiency: Identifying the variance between "Carrier Fuel Surcharge" income vs. "Actual Fuel Spend."
3. Maintenance: Predicting which truck models incur higher repair costs as they age.*
