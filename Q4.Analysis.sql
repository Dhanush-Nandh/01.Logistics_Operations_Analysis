/*
Q4. Asset Health (Maintenance vs. Utilization)
The Question: Identify trucks  
	- with high maintenance costs (Labor + Parts) per maintenance event: > 2000$
	- have low utilization rates: < 0.85 or 85% (industry benchmark rate is 85-100%) 
Why it's a Key Metric: This identifies trucks and its make that should be sold or reconsidered for leasing because they cost more to keep on the road than they earn. */

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

-- More than half of the trucks (15 out of 28) belong to make "Freightliner" and "International"
