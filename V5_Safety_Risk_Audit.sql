CREATE VIEW Safety_Risk_Audit AS
SELECT 
    s.incident_id AS [Incident ID],
    s.driver_id AS [Driver ID],
    CONCAT(d.first_name, ' ', d.last_name) AS [Driver Fullname],
    s.incident_type AS [Incident Type],
    s.description AS [Incident Description],
    s.at_fault_flag AS [At Fault],                      -- 1 is Yes / 0 is No
    s.preventable_flag AS [Preventable],                -- 1 is Yes / 0 is No
    s.CleanClaimAmount AS [Claim Amount],
    RANK() OVER (ORDER BY s.CleanClaimAmount DESC) AS [Financial Risk Rank]
FROM dbo.safety_incidents AS s
LEFT JOIN dbo.drivers AS d
	ON s.driver_id = d.driver_id
WHERE CleanClaimAmount > 0

