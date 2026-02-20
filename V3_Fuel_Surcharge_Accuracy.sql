CREATE VIEW Fuel_Surcharge_Accuracy AS 
SELECT
	f_sub.trip_id AS [Trip ID],
	l.CleanFuelSurcharge AS [Fuel Surcharge],         
	f_sub.Actual_FuelCost AS [Actual Fuel Cost],   
	l.CleanFuelSurcharge - f_sub.Actual_FuelCost AS [Fuel Profit/Loss],
	CASE 
		WHEN l.CleanFuelSurcharge - f_sub.Actual_FuelCost < 0 THEN 'Loss'
		ELSE 'Profit'
	END AS [Profitability Status] 
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
