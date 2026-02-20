CREATE VIEW Customer_Revenue_Performance AS
SELECT 
    c.customer_id AS [Customer ID],
    c.customer_name AS [Customer Name],
    c.annual_revenue_potential AS [Target Revenue],
    SUM(l.CleanRevenue) AS [Actual Revenue],
    -- Efficiency Metric: What % of their potential have they reached?
    CASE 
        WHEN c.annual_revenue_potential > 0 THEN (SUM(l.CleanRevenue) / c.annual_revenue_potential) * 100 
        ELSE 0 
    END AS [Potential Reach %],
    COUNT(l.load_id) AS [Total Loads Delivered]
FROM dbo.customers AS c
INNER JOIN dbo.loads AS l 
    ON c.customer_id = l.customer_id
WHERE c.account_status = 'Active'
GROUP BY 
    c.customer_id, 
    c.customer_name, 
    c.annual_revenue_potential 

