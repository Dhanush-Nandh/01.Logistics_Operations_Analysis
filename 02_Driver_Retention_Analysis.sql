CREATE VIEW Driver_Retention_Analysis AS 
SELECT 
	driver_id AS [Driver ID],
	years_experience AS [Experience (Years)],
	employment_status AS [Status],
	CASE 
		WHEN years_experience <=  2 THEN 'Junior'
		WHEN years_experience <= 10 THEN 'Mid-level'
		WHEN years_experience <= 20 THEN 'Senior'
		ELSE 'Veteran' 
	END AS [Experience Level],
	DATEDIFF(dd, hire_date, ISNULL(termination_date,GETDATE()))/365.0 AS [Tenure (Years)]
FROM dbo.drivers