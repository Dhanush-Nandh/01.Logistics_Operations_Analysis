/* 
Q2. Driver Retention & Experience 
Question: Find the average "tenure" (days between hire_date and today/termination_date) for drivers, 
grouped by their experience level (Junior 0-2yrs vs. Mid-level 3-10yrs vs. Senior 11-20yrs vs. Veteran more than 20yrs).
Logistics Context: Does higher experience actually lead to longer retention in the fleet?  */

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

-- higher the experience level longer is the retention 
