/* 
Q3. Fuel Surcharge Accuracy: Compare the CleanFuelSurcharge from the "loads" table against the ActualFuelCost from the "fuel_purchases" table per trip.
Why: To see if the company is actually covering its fuel costs or losing money on the surcharge.
In trucking, if your surcharge doesn't cover the actual fuel price, we're losing money before the trip even starts. This is a vital Operating Margin KPI. */

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

