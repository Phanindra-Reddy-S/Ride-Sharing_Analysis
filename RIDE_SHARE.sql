-- 1.Find out the Peak Ride Hours
SELECT 
    EXTRACT(HOUR FROM ride_start_time) AS hour,
    COUNT(*) AS number_of_rides
FROM rides
GROUP BY hour
ORDER BY number_of_rides DESC;

-- 2.Average driver Rating
SELECT 
    d.name AS driver_name,
   Round( AVG(rt.rating_value),1) AS average_rating
FROM drivers d
JOIN rides r ON d.driver_id = r.driver_id
JOIN ratings rt ON rt.ride_id = r.ride_id
GROUP BY d.name
ORDER BY average_rating DESC;

-- 3.Ride Statistics for Users , total_rides and total_spent by the user
SELECT 
    u.name AS user_name,
    COUNT(r.ride_id) AS total_rides,
    SUM(r.fare_amount) AS total_spent
FROM users u
JOIN rides r ON u.user_id = r.user_id
GROUP BY u.name
ORDER BY total_spent DESC;

-- 4.Average distance covered by the ride
SELECT 
    AVG(distance_km) AS avg_distance
FROM rides;

-- 5.Creating a view for driver_performance metrics
CREATE VIEW driver_performance AS
SELECT 
    d.driver_id, 
    d.name AS driver_name, 
    AVG(rt.rating_value) AS avg_rating,
    COUNT(r.ride_id) AS total_rides, 
    SUM(r.fare_amount) AS total_fare
FROM drivers d
JOIN rides r ON d.driver_id = r.driver_id
JOIN ratings rt ON rt.ride_id = r.ride_id
GROUP BY d.driver_id, d.name;
SELECT * FROM driver_performance;

-- 6.Top Performing Drivers by Revenue
SELECT 
    d.name AS driver_name, 
    COUNT(r.ride_id) AS total_rides, 
    ROUND(SUM(r.fare_amount),2) AS total_earnings, 
    ROUND(AVG(rt.rating_value),1) AS avg_rating
FROM drivers d
JOIN rides r ON d.driver_id = r.driver_id
JOIN ratings rt ON rt.ride_id = r.ride_id
GROUP BY d.driver_id, d.name
ORDER BY total_earnings DESC
LIMIT 10;

-- 7.Customer Lifetime Value (CLV)
SELECT 
    u.user_id, 
    u.name AS user_name, 
    COUNT(r.ride_id) AS total_rides, 
    ROUND(SUM(r.fare_amount),2) AS total_spent,
    MAX(r.ride_start_time) AS last_ride_date
FROM users u
JOIN rides r ON u.user_id = r.user_id
GROUP BY u.user_id, u.name
ORDER BY total_spent DESC
LIMIT 10;

-- 8.Vehicle Utilization Analysis
SELECT 
    v.vehicle_id, 
    v.make, 
    v.model, 
    COUNT(r.ride_id) AS total_rides, 
    ROUND(SUM(r.distance_km),2) AS total_distance_covered
FROM vehicles v
JOIN drivers d on v.vehicle_id = d.vehicle_id
JOIN rides r ON d.driver_id = r.driver_id
GROUP BY v.vehicle_id, v.make, v.model
ORDER BY total_distance_covered DESC;

-- 9.Surge Pricing Analysis
SELECT 
    ride_hour, 
   ROUND( AVG(fare_amount),2) AS avg_fare
FROM (
    SELECT 
        EXTRACT(HOUR FROM ride_start_time) AS ride_hour, 
        fare_amount
    FROM rides
) AS subquery
GROUP BY ride_hour
ORDER BY avg_fare DESC;

-- 10.Rider Frequency by Location
SELECT 
    start_location, 
    COUNT(*) AS total_rides
FROM rides
GROUP BY start_location
ORDER BY total_rides DESC;

-- 11.Fare by Gender
SELECT 
    u.gender, 
   ROUND( AVG(r.fare_amount) ,2)AS avg_fare
FROM users u
JOIN rides r ON u.user_id = r.user_id
GROUP BY u.gender;

-- 12.Seasonal Ride Analysis
SELECT 
    EXTRACT(MONTH FROM ride_start_time) AS ride_month, 
    COUNT(*) AS total_rides
FROM rides
GROUP BY ride_month
ORDER BY ride_month;
-- 13.Rating Correlation with Fare Amount
SELECT 
    AVG(rt.rating_value) AS avg_rating, 
    AVG(r.fare_amount) AS avg_fare
FROM ratings rt
JOIN rides r ON rt.ride_id = r.ride_id
GROUP BY r.driver_id
ORDER BY avg_rating DESC;

-- 14.Driver Availability vs. Ride Demand
SELECT 
    EXTRACT(HOUR FROM ride_start_time) AS ride_hour, 
    COUNT(DISTINCT r.driver_id) AS available_drivers, 
    COUNT(*) AS total_rides
FROM rides r
JOIN drivers d ON r.driver_id = d.driver_id
WHERE d.available = 'TRUE'
GROUP BY ride_hour
ORDER BY ride_hour;

-- 15.Customer Ride Frequency (Churn Analysis)
SELECT 
    u.user_id, 
    u.name AS user_name, 
    COUNT(r.ride_id) AS total_rides
FROM users u
JOIN rides r ON u.user_id = r.user_id
GROUP BY u.user_id, u.name
HAVING COUNT(r.ride_id) < 5
ORDER BY total_rides ASC;
