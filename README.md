# 01.Logistics Operations Analysis

## Project Overview
**Logistics Operations & Asset Performance Analytics:** This project provides an end-to-end data solution for a mid-sized trucking firm and analyses three years of logistics data using SQL and Power BI. I transformed 14 raw relational datasets into a multi-page executive dashboard. The goal was to identify "profit-killers" like detention time, fuel inefficiency, and safety liabilities that are often hidden in raw operational logs. *CHANGE THIS LATER*

## Tools Used
* **SQL Server(SSMS):** Data cleaning, ETL (Extract, Transform, Load), JOINing tables, Exploratory Data Analysis (EDA), and building a reporting layer via SQL Views.
* **Power BI:** Star Schema data modeling, and interactive visuals using DAX for performance KPIs. 
* **Logistics Domain Knowledge:** Applied industry expertise to define "at-risk" or KPI metrics for assets. 

## The Data
The dataset is a comprehensive Logistics Operations Database 🔗 [Kaggle source](https://www.kaggle.com/datasets/yogape/logistics-operations-database)
, consisting of 14 CSV files representing:
* **Core Tables:** `drivers`, `trucks`, `trailers`, `customers`, `facilities`, `routes`
* **Transaction Tables:** `loads`, `trips`, `fuel_purchases`, `maintenance_records`, `delivery_events`, `safety_incidents`
* **Aggregated Metrics:** `driver_monthly_metrics`, `truck_utilization_metrics`

## SQL Highlights: Data Engineering & ETL
**Challenge:** Upon ingestion, numeric financial/float data was truncated due to SSMS "Flat File" import limitations (Float/Decimal precision errors). 
**Solution:** I implemented a robust "Staging-to-Production" pipeline:
1. Ingested raw data as VARCHAR to prevent data loss.
2. Developed [01_Data_Cleaning.sql](https://github.com/Dhanush-Nandh/01.Logistics_Operations_Analysis/blob/main/01_Data_Cleaning.sql) using Nested `TRY_CAST` (VARCHAR → FLOAT → DECIMAL) approach to ensure string-to-numeric precision.
3. Used `SELECT` comparison statements to audit the results. By filtering for **WHERE RawColumn IS NOT NULL AND CleanColumn IS NULL**, I could instantly identify any rows that failed the transformation.
> **Note:** *ADD A NOTE LATER*

## Exploratory Data Analysis (EDA)
Applied O.A.R. (Objective, Action, Result & Key Insights) Framework in this segment to answer and provide key insights. 

### Q1. Top Performing Active Customers (Revenue Variance Analysis)

<ins>**Objective:**</ins> 

To identify "High-Value" active customers who have outperformed their estimated annual revenue. This helps identify which accounts are over-delivering and may require premium support or upselling focus.

<ins>**Action:**</ins> Performed an `INNER JOIN` between `loads` and `customers` tables. I calculated the **Revenue Variance** (Actual - Estimated) and the **Average Load Value** per shipment. To include profitable over-performers, I used a `HAVING` clause to filter for 'Active' status and positive revenue variance.

<ins>**SQL Query:**</ins> 🔗 [View the SQL script for Q1 analysis here.](https://github.com/Dhanush-Nandh/01.Logistics_Operations_Analysis/blob/main/Q1_Analysis.sql)
```
SELECT TOP 10
	c.customer_name,
	c.annual_revenue_potential                        AS EstimatedRevenue_$,
	SUM(l.CleanRevenue)                               AS ActualRevenue_$,
	SUM(l.CleanRevenue) - c.annual_revenue_potential  AS RevenueVariance_$, 
	SUM(l.CleanRevenue) / COUNT(l.load_id)            AS AvgLoadValue_$     
FROM dbo.loads            AS l
INNER JOIN dbo.customers  AS c
	ON l.customer_id = c.customer_id
GROUP BY c.customer_name, c.account_status, c.annual_revenue_potential
HAVING c.account_status = 'Active' 
	AND SUM(l.CleanRevenue) - c.annual_revenue_potential > 0 
ORDER BY ActualRevenue_$ DESC
```
<ins>**Result & Key Insights:**</ins>
* **The "Power 10" Revenue Drivers:** The top 10 active customers accounted for approximately $14.58M in actual revenue so these warrant premium service to ensure continued retention.
* **Higher Growth Potential:** All identified customers exceeded their estimated potential, indicating strong account growth.
* **Operational efficiency:** Average load value can help determine customers who order frequently in small revenue (High-Frequency/Low-Value) versus those with not-so-frequent high-value shipments (Low-Frequency/High-Value).

### Q2. Driver Retention & Experience Analysis

<ins>**Objective:**</ins> 

To determine if a driver’s prior experience correlates with their longevity (tenure) at the company. This helps the HR and Logistics teams understand which "ExperienceLevel" Segment are most stable and where turnover risk might be highest.

<ins>**Action:**</ins> Used a `CASE` statement to bucket drivers into four seniority levels: Junior (0-2 yrs), Mid-level (3-10 yrs), Senior (11-20 yrs), and Veteran (more than 20 yrs) based on their experience. Implemented defensive logic using `ISNULL(termination_date, GETDATE())` to ensure active drivers are included in the tenure calculation. Calculated the average tenure in years using `DATEDIFF` and grouped by the custom experience buckets. 

<ins>**SQL Query:**</ins> 🔗 [View the SQL script for Q2 analysis here.](https://github.com/Dhanush-Nandh/01.Logistics_Operations_Analysis/blob/main/Q2_Analysis.sql)
```
SELECT 
CASE
	WHEN years_experience <=  2 THEN 'Junior'
	WHEN years_experience <= 10 THEN 'Mid-level'
	WHEN years_experience <= 20 THEN 'Senior'
	ELSE 'Veteran' 
END AS ExperienceLevel,
AVG(DATEDIFF(dd, hire_date, ISNULL(termination_date,GETDATE()))/365.0) AS AverageTenure_Years
FROM dbo.drivers
GROUP BY 
CASE
	WHEN years_experience <=  2 THEN 'Junior'
	WHEN years_experience <= 10 THEN 'Mid-level'
	WHEN years_experience <= 20 THEN 'Senior'
	ELSE 'Veteran' 
END 
```
<ins>**Result & Key Insights:**</ins>
* **Address the "Junior Gap":** Junior drivers have the shortest tenure, suggesting that the first 2 years are the "high-risk" period where retention programs (mentorship or sign-on bonuses) should be focused.
* **Knowledge Transfer via Mentorship:** Veterans possess 20+ years of "road wisdom." By creating a **Lead Driver Mentorship Program**, the company can pay Veterans a premium to train Juniors, increasing the stability of the entire fleet.
* **Predictive Retention:** Because experience directly correlates with tenure, the "Mid-level" segment (3-10 years) represents the most critical period for "upskilling" to ensure they transition into the loyal Senior tier.
* **Loyalty Rewards (Lane Priority):** High-tenure drivers (Senior/Veteran) should be prioritized for premium, high-efficiency shipping lanes. This rewards loyalty with better work-life balance.

### Q3. Fuel Surcharge vs. Actual Cost Analysis (Margin Leakage)

<ins>**Objective:**</ins> 

To evaluate the accuracy of the fuel surcharge model by comparing the revenue collected (`CleanFuelSurcharge`) against the actual expenses incurred at the pump (`CleanTotalCost`). The goal is to identify "under-recovered" trips where fuel costs exceeded the surcharge, directly impacting the operating margin.

<ins>**Action:**</ins> Used a `LEFT JOIN` to combine the `loads` table with a subquery from the table `fuel_purchases`. The subquery aggregates fuel spent at the trip_id level to account for multiple fuel stops per journey. Next, calculated Fuel Variance (Surcharge - Actual Cost) and applied a `WHERE` clause to isolate only the trips where the company lost money (Variance < 0), focusing the analysis on financial leakage.

<ins>**SQL Query:**</ins> 🔗 [View the SQL script for Q3 analysis here.](https://github.com/Dhanush-Nandh/01.Logistics_Operations_Analysis/blob/main/Q3_Analysis.sql)
```
SELECT
	f_sub.trip_id,
	l.CleanFuelSurcharge AS FuelSurcharge,         
	f_sub.Actual_FuelCost,   
	l.CleanFuelSurcharge - f_sub.Actual_FuelCost AS FuelVariance
FROM dbo.trips AS t
LEFT JOIN dbo.loads AS l
	ON t.load_id = l.load_id
LEFT JOIN ( 
	        SELECT 
				f.trip_id,
				SUM(f.CleanTotalCost) AS Actual_FuelCost
			FROM dbo.fuel_purchases AS f
			GROUP BY f.trip_id
		  ) AS f_sub
	ON t.trip_id = f_sub.trip_id
WHERE (l.CleanFuelSurcharge - f_sub.Actual_FuelCost) < 0
ORDER BY f_sub.trip_id ASC
```
<ins>**Result & Key Insights:**</ins>
* **Margin Erosion:** Identified specific trips where the fuel surcharge failed to cover actual costs, indicating a potential lag between market fuel price spikes and surcharge adjustments.If the surcharge doesn't cover the actual fuel price, the company loses money before the wheels even turn.
* **Pricing Strategy:** These results suggest the need for a more dynamic surcharge model and proves that the company’s model is not reacting fast enough to fuel market volatility.
* **Sub-Query Logic** By aggregating `fuel_purchases` before joining, we ensure that trips with 2 or more fuel stops are correctly totaled, preventing an under-estimation of costs.

### Q4. Asset Health: Maintenance Costs vs. Utilization

<ins>**Objective:**</ins> 

To identify "underperforming assets"—specifically trucks that are expensive to maintain but are not being utilized enough to justify those costs. This analysis helps leadership decide which vehicle makes/models to decommission or phase out of the fleet.

<ins>**Action:**</ins> Used Subqueries (Derived Tables) to aggregate data from two different sources: `maintenance_records` (to count events) and `truck_utilization_metrics` (for financial and utilization data) and used `LEFT JOIN`. Calculated "Maintenance Cost per Event" by dividing total maintenance (labor and parts) costs by the count of maintenance events. Performed a second `LEFT JOIN` to `trucks` table to retrieve the specific Make of the vehicle for trend analysis. Then filtered the results using a `WHERE` clause based on 
* trucks which are active (as there are records with inactive or in maintenance status)
* Maintenance Cost: > $2,000 per event.
* Low Utilization: < 85% (industry benchmarks: 85 to 100%).

<ins>**SQL Query:**</ins> 🔗 [View the SQL script for Q4 analysis here.](https://github.com/Dhanush-Nandh/01.Logistics_Operations_Analysis/blob/main/Q4.Analysis.sql)
```
SELECT 
	t.truck_id,
	t.make,
	tab_2.Maintenance_Costs / tab_1.Maintenance_Events AS MaintenanceCosts$_perEvent
FROM 
(
       SELECT  
		   truck_id,
	       COUNT(maintenance_type) AS Maintenance_Events
       FROM dbo.maintenance_records
       GROUP BY truck_id 
) AS tab_1
LEFT JOIN 
(
       SELECT
	       truck_id,
	       SUM(CleanMaintenanceCost) AS Maintenance_Costs,
	       AVG(CleanUtilizationRate) AS Avg_UtilizationRate
       FROM dbo.truck_utilization_metrics
       GROUP BY truck_id
) AS tab_2
	ON tab_1.truck_id = tab_2.truck_id
LEFT JOIN dbo.trucks AS t
	ON tab_1.truck_id = t.truck_id
WHERE t.status = 'Active' 
	AND tab_2.Maintenance_Costs / tab_1.Maintenance_Events > 2000 
	AND tab_2.Avg_UtilizationRate < 0.85 --industry benchmark rate is 85-100%
ORDER BY t.make ASC
```
<ins>**Result & Key Insights:**</ins>
* **Make-Specific Issues:** More than half of the underperforming trucks (15 out of 28) belong to "Freightliner" and "International." This suggests a systemic issue with these specific makes and allows the team to negotiate better warranties or replacing them with more reliable manufacturers to improve the overall fleet uptime.
* **Underperforming assets:** These 28 trucks are "active" but are effectively cash-drains. They are in the workshop for expensive repairs but aren't spending enough time on the road to pay for themselves.

### Q5. The Risk Audit (Preventable Incident Financial Ranking)

<ins>**Objective:**</ins> 

To perform a financial analysis on safety incidents. By ranking "At-Fault" and "Preventable" claims, we can identify which specific incident types carry the highest financial risk and which drivers may require immediate safety re-training. 

<ins>**Action:**</ins> Used the `RANK()` window function, partitioned by `incident_type`, to create a relative financial ranking for every claim. Joined the `safety_incidents` table with the `drivers` table to provide accountability by driver's full name using `CONCAT`. Then filtered specifically for `at_fault_flag` and `preventable_flag` to isolate incidents where driver behavior was the primary cause. Finally, focused exclusively on claims with a financial impact `(CleanClaimAmount > 0)`.

<ins>**SQL Query:**</ins> 🔗 [View the SQL script for Q5 analysis here.](https://github.com/Dhanush-Nandh/01.Logistics_Operations_Analysis/blob/main/Q5.Analysis.sql) 
```
SELECT 
	RANK() OVER(PARTITION BY s.incident_type ORDER BY s.CleanClaimAmount DESC) AS Rank_no,
	s.incident_type,
	CONCAT(d.first_name, ' ', d.last_name) AS Driver_fullname,
	s.description,
	s.CleanClaimAmount AS ClaimAmount
FROM dbo.safety_incidents AS s
LEFT JOIN dbo.drivers AS d
	ON s.driver_id = d.driver_id
WHERE s.at_fault_flag = 1 
	AND s.preventable_flag = 1
	AND s.CleanClaimAmount > 0
```

<ins>**Result & Key Insights:**</ins>
* **Financial Prioritization:** The PARTITION BY logic allows the safety team to see the "Worst-in-Class" for each category. The ranking quickly identifies expensive claims that can wipe out the profit margins.
* **Driver Accountability:** The use of full names allows the leadership to quickly see if certain names appear at the top of the rankings across multiple incident types and how frequent by maintaining a list. 
* **Insurance Impact::** This list is vital for insurance renewals. Showing that the company actively ranks and audits preventable claims proves a "Safety First" culture, which can lead to lower premiums.

## Reporting Layer (SQL Views)
To ensure "One Version of the Truth" in my Power BI dashboard, I transformed my analysis into permanent **SQL Views**. This layer handles complex calculations at the database level, ensuring the dashboard remains fast and accurate.

| View Name | Business Purpose | Source Script |
| :--- | :--- | :--- |
| `V1_Customer_Revenue_Performance` | Tracks Revenue Potential vs. Actuals | [Link](./03_Reporting_Layer/Q1_High_Value_Customers.sql) |
| `V2_Driver_Retention_Analysis` | Segments tenure by experience level | [Link](./03_Reporting_Layer/Q2_Driver_Retention.sql) |
| `V3_Fuel_Surcharge_Accuracy` | Audits Fuel Surcharge vs. Actual Spend | [Link](./03_Reporting_Layer/Q3_Fuel_Surcharge.sql) |
| `V4_Asset_Health_Summary` | Identifies high-cost underutilized trucks | [Link](./03_Reporting_Layer/Q4_Asset_Health.sql) |
| `V5_Safety_Risk_Audit` | Ranks incidents by financial impact | [Link](./03_Reporting_Layer/Q5_Risk_Audit.sql) |

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
