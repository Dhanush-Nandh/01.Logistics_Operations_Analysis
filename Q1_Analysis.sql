/* 
Q1. To identify "High-Value" active customers who have outperformed their estimated annual revenue.*/

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