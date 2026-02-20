CREATE VIEW Asset_Health_Summary AS
SELECT 
    t.truck_id AS [Truck ID],
    t.make AS [Make],
    t.model_year AS [Model Year],
    AVG(m.CleanTotalCost) AS [Avg Repair Cost],
    u.CleanUtilizationRate AS [Utilization Rate],
    CASE 
        WHEN u.CleanUtilizationRate < 0.85 AND AVG(m.CleanTotalCost) > 2000 THEN 'High Risk - Replace'
        WHEN u.CleanUtilizationRate < 0.85 THEN 'Underutilized'
        WHEN AVG(m.CleanTotalCost) > 2000 AND u.CleanUtilizationRate IS NOT NULL THEN 'High Maintenance'
        WHEN u.CleanUtilizationRate IS NULL THEN 'Never Utilized with Repair Costs'
        ELSE 'Healthy'
    END AS [Asset Status]
FROM dbo.trucks AS t
LEFT JOIN dbo.maintenance_records AS m 
    ON t.truck_id = m.truck_id
LEFT JOIN dbo.truck_utilization_metrics AS u 
    ON t.truck_id = u.truck_id
GROUP BY t.truck_id, t.make, t.model_year, u.CleanUtilizationRate