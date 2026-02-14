/*********************************************************************************************************
PROJECT: Logistics Operations Analysis
STEP 01: Data Cleaning & Type Conversion
AUTHOR: Dhanush Nandh Ponnumani Sachithanantham
DESCRIPTION: Converting staging (VARCHAR) tables to production-ready formats.
*********************************************************************************************************/

/*============================== 01.TABLE: dbo.customers ===============================================*/
-- No data cleaning as the table looks clean

/*============================== 02.TABLE: dbo.delivery_events =========================================*/
-- No data cleaning as the table looks clean

/*============================== 03.TABLE: dbo.driver_monthly_metrics ==================================*/
-- 1. Adding new columns
ALTER TABLE dbo.driver_monthly_metrics 
ADD 
    CleanTotalRevenue        DECIMAL(18, 2),                
    CleanAverageMpg          DECIMAL(18, 2),      
    CleanTotalFuelGallons    DECIMAL(18, 2),
    CleanOnTimeDeliveryRate  DECIMAL(18, 2),
    CleanAverageIdleHours    DECIMAL(18, 2);

-- 2. Updating with "Defensive" Logic
UPDATE dbo.driver_monthly_metrics
SET 
    -- TRY_CAST is safer; it handles dirty data by returning NULL instead of crashing
    CleanTotalRevenue        = TRY_CAST(TRY_CAST(total_revenue AS FLOAT) AS DECIMAL(18, 2)), 
    CleanAverageMpg          = TRY_CAST(TRY_CAST(average_mpg AS FLOAT) AS DECIMAL(18, 2)),
    CleanTotalFuelGallons    = TRY_CAST(TRY_CAST(total_fuel_gallons AS FLOAT) AS DECIMAL(18, 2)),
    CleanOnTimeDeliveryRate  = TRY_CAST(TRY_CAST(on_time_delivery_rate AS FLOAT) AS DECIMAL(18, 2)),
    CleanAverageIdleHours    = TRY_CAST(TRY_CAST(average_idle_hours AS FLOAT) AS DECIMAL(18, 2));

-- 3. Data Quality Audit
-- This helps to find rows that failed to convert so it can be investigated.
SELECT 
    total_revenue, 
    CleanTotalRevenue
FROM dbo.driver_monthly_metrics
WHERE total_revenue IS NOT NULL AND CleanTotalRevenue IS NULL;

/*============================== 04.TABLE: dbo.drivers =================================================*/
-- No data cleaning as the table looks clean

/*============================== 05.TABLE: dbo.facilities ==============================================*/
-- 1. Adding new columns
ALTER TABLE dbo.facilities 
ADD 
    CleanLatitude            DECIMAL(18, 2),
    CleanLongitude           DECIMAL(18, 2);

-- 2. Updating with "Defensive" Logic
UPDATE dbo.facilities
SET 
    -- TRY_CAST is safer; it handles dirty data by returning NULL instead of crashing
    CleanLatitude            = TRY_CAST(TRY_CAST(latitude AS FLOAT) AS DECIMAL(18, 2)),
    CleanLongitude           = TRY_CAST(TRY_CAST(longitude AS FLOAT) AS DECIMAL(18, 2));

-- 3. Data Quality Audit
-- This helps to find rows that failed to convert so it can be investigated.
SELECT 
    latitude, 
    CleanLatitude
FROM dbo.facilities
WHERE latitude IS NOT NULL AND CleanLatitude IS NULL;

/*============================== 06.TABLE: dbo.fuel_purchases ==========================================*/
-- 1. Adding new columns
ALTER TABLE dbo.fuel_purchases 
ADD 
    CleanGallons             DECIMAL(18, 2),
    CleanPricePerGallon      DECIMAL(18, 2),
    CleanTotalCost           DECIMAL(18, 2);

-- 2. Updating with "Defensive" Logic
UPDATE dbo.fuel_purchases
SET 
    -- TRY_CAST is safer; it handles dirty data by returning NULL instead of crashing
    CleanGallons             = TRY_CAST(TRY_CAST(gallons AS FLOAT) AS DECIMAL(18, 2)),
    CleanPricePerGallon      = TRY_CAST(TRY_CAST(price_per_gallon AS FLOAT) AS DECIMAL(18, 2)),
    CleanTotalCost           = TRY_CAST(TRY_CAST(total_cost AS FLOAT) AS DECIMAL(18, 2));

-- 3. Data Quality Audit
-- This helps to find rows that failed to convert so it can be investigated.
SELECT 
    gallons, 
    CleanGallons
FROM dbo.fuel_purchases
WHERE gallons IS NOT NULL AND CleanGallons IS NULL;

/*============================== 07.TABLE: dbo.loads ===================================================*/
-- 1. Adding new columns
ALTER TABLE dbo.loads 
ADD 
    CleanRevenue             DECIMAL(18, 2),
    CleanFuelSurcharge       DECIMAL(18, 2);

-- 2. Updating with "Defensive" Logic
UPDATE dbo.loads
SET 
    -- TRY_CAST is safer; it handles dirty data by returning NULL instead of crashing
    CleanRevenue             = TRY_CAST(TRY_CAST(revenue AS FLOAT) AS DECIMAL(18, 2)),
    CleanFuelSurcharge       = TRY_CAST(TRY_CAST(fuel_surcharge AS FLOAT) AS DECIMAL(18, 2));

-- 3. Data Quality Audit
-- This helps to find rows that failed to convert so it can be investigated.
SELECT 
    revenue, 
    CleanRevenue
FROM dbo.loads
WHERE revenue IS NOT NULL AND CleanRevenue IS NULL;

/*============================== 08.TABLE: dbo.maintenance_records =====================================*/
-- 1. Adding new columns
ALTER TABLE dbo.maintenance_records 
ADD 
    CleanLaborHours          DECIMAL(18, 2),
    CleanLaborCost           DECIMAL(18, 2),
    CleanPartsCost           DECIMAL(18, 2),
    CleanTotalCost           DECIMAL(18, 2),
    CleanDowntimeHours       DECIMAL(18, 2);

-- 2. Updating with "Defensive" Logic
UPDATE dbo.maintenance_records
SET 
    -- TRY_CAST is safer; it handles dirty data by returning NULL instead of crashing
    CleanLaborHours          = TRY_CAST(TRY_CAST(labor_hours AS FLOAT) AS DECIMAL(18, 2)),
    CleanLaborCost           = TRY_CAST(TRY_CAST(labor_cost AS FLOAT) AS DECIMAL(18, 2)),
    CleanPartsCost           = TRY_CAST(TRY_CAST(parts_cost AS FLOAT) AS DECIMAL(18, 2)),
    CleanTotalCost           = TRY_CAST(TRY_CAST(total_cost AS FLOAT) AS DECIMAL(18, 2)),
    CleanDowntimeHours       = TRY_CAST(TRY_CAST(downtime_hours AS FLOAT) AS DECIMAL(18, 2));

-- 3. Data Quality Audit
-- This helps to find rows that failed to convert so it can be investigated.
SELECT 
    labor_hours, 
    CleanLaborHours
FROM dbo.maintenance_records
WHERE labor_hours IS NOT NULL AND CleanLaborHours IS NULL;

/*============================== 09.TABLE: dbo.routes ==================================================*/
-- 1. Adding new columns
ALTER TABLE dbo.routes 
ADD 
    CleanBaseRatePerMile     DECIMAL(18, 2),
    CleanFuelSurchargeRate   DECIMAL(18, 2);

-- 2. Updating with "Defensive" Logic
UPDATE dbo.routes
SET 
    -- TRY_CAST is safer; it handles dirty data by returning NULL instead of crashing
    CleanBaseRatePerMile     = TRY_CAST(TRY_CAST(base_rate_per_mile AS FLOAT) AS DECIMAL(18, 2)),
    CleanFuelSurchargeRate   = TRY_CAST(TRY_CAST(fuel_surcharge_rate AS FLOAT) AS DECIMAL(18, 2));

-- 3. Data Quality Audit
-- This helps to find rows that failed to convert so it can be investigated.
SELECT 
    base_rate_per_mile, 
    CleanBaseRatePerMile
FROM dbo.routes
WHERE base_rate_per_mile IS NOT NULL AND CleanBaseRatePerMile IS NULL;

/*============================== 10.TABLE: dbo.safety_incidents ========================================*/
-- 1. Adding new columns
ALTER TABLE dbo.safety_incidents 
ADD 
    CleanVehicleDamageCost DECIMAL(18, 2),                
    CleanCargoDamageCost   DECIMAL(18, 2),      
    CleanClaimAmount       DECIMAL(18, 2);

-- 2. Updating with "Defensive" Logic
UPDATE dbo.safety_incidents
SET 
    -- TRY_CAST is safer; it handles dirty data by returning NULL instead of crashing
    CleanVehicleDamageCost = TRY_CAST(TRY_CAST(vehicle_damage_cost AS FLOAT) AS DECIMAL(18, 2)), 
    CleanCargoDamageCost   = TRY_CAST(TRY_CAST(cargo_damage_cost AS FLOAT) AS DECIMAL(18, 2)),
    CleanClaimAmount       = TRY_CAST(TRY_CAST(claim_amount AS FLOAT) AS DECIMAL(18, 2));

-- 3. Data Quality Audit
-- This helps to find rows that failed to convert so it can be investigated.
SELECT 
    vehicle_damage_cost, 
    CleanVehicleDamageCost
FROM dbo.safety_incidents
WHERE vehicle_damage_cost IS NOT NULL AND CleanVehicleDamageCost IS NULL;

/*============================== 11.TABLE: dbo.trailers ================================================*/
-- No data cleaning as the table looks clean

/*============================== 12.TABLE: dbo.trips ===================================================*/
-- 1. Adding new columns
ALTER TABLE dbo.trips 
ADD 
    CleanActualDurationHours DECIMAL(18, 2),
    CleanFuelGallonsUsed     DECIMAL(18, 2),
    CleanAverageMpg          DECIMAL(18, 2),
    CleanIdleTimeHours       DECIMAL(18, 2);

-- 2. Updating with "Defensive" Logic
UPDATE dbo.trips
SET 
    -- TRY_CAST is safer; it handles dirty data by returning NULL instead of crashing
    CleanActualDurationHours = TRY_CAST(TRY_CAST(actual_duration_hours AS FLOAT) AS DECIMAL(18, 2)),
    CleanFuelGallonsUsed     = TRY_CAST(TRY_CAST(fuel_gallons_used AS FLOAT) AS DECIMAL(18, 2)),
    CleanAverageMpg          = TRY_CAST(TRY_CAST(average_mpg AS FLOAT) AS DECIMAL(18, 2)),
    CleanIdleTimeHours       = TRY_CAST(TRY_CAST(idle_time_hours AS FLOAT) AS DECIMAL(18, 2));

-- 3. Data Quality Audit
-- This helps to find rows that failed to convert so it can be investigated.
SELECT 
    actual_duration_hours, 
    CleanActualDurationHours
FROM dbo.trips
WHERE actual_duration_hours IS NOT NULL AND CleanActualDurationHours IS NULL;

/*============================== 13.TABLE: dbo.truck_utilization_metrics ===============================*/
-- 1. Adding new columns
ALTER TABLE dbo.truck_utilization_metrics 
ADD 
    CleanTotalRevenue        DECIMAL(18, 2),
    CleanAverageMpg          DECIMAL(18, 2),
    CleanMaintenanceCost     DECIMAL(18, 2),
    CleanDowntimeHours       DECIMAL(18, 2),
    CleanUtilizationRate     DECIMAL(18, 2);

-- 2. Updating with "Defensive" Logic
UPDATE dbo.truck_utilization_metrics
SET 
    -- TRY_CAST is safer; it handles dirty data by returning NULL instead of crashing
    CleanTotalRevenue        = TRY_CAST(TRY_CAST(total_revenue AS FLOAT) AS DECIMAL(18, 2)),
    CleanAverageMpg          = TRY_CAST(TRY_CAST(average_mpg AS FLOAT) AS DECIMAL(18, 2)),
    CleanMaintenanceCost     = TRY_CAST(TRY_CAST(maintenance_cost AS FLOAT) AS DECIMAL(18, 2)),
    CleanDowntimeHours       = TRY_CAST(TRY_CAST(downtime_hours AS FLOAT) AS DECIMAL(18, 2)),
    CleanUtilizationRate     = TRY_CAST(TRY_CAST(utilization_rate AS FLOAT) AS DECIMAL(18, 2));

-- 3. Data Quality Audit
-- This helps to find rows that failed to convert so it can be investigated.
SELECT 
    total_revenue, 
    CleanTotalRevenue
FROM dbo.truck_utilization_metrics
WHERE total_revenue IS NOT NULL AND CleanTotalRevenue IS NULL;

/*============================== 14.TABLE: dbo.trucks ==================================================*/
-- No data cleaning as the table looks clean