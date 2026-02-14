/*
Q5. The "Risk Audit" (Driver & Incident Ranking)
The Question: For all "At-Fault" and "preventable" incidents, rank the financial impact of each claim (claim amounts > 0). 
List of incidents that shows the driver, the cost, incident type, description and a rank that tells us where that specific incident stands. */

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





