--- create a view with daily trips information (daily_trips)
CREATE VIEW daily_trips AS
SELECT dates.date_key
    , dates.date
    , dates.month
    , dates.day
    , dates.day_name
    , dates.weekend
    , COUNT(trips.id) AS total_trips
    , COUNT(trips.id) FILTER (WHERE users.user_type = 'Subscriber') AS subscriber_trips
    , COUNT(trips.id) FILTER (WHERE users.user_type = 'Customer') AS customer_trips
    , COUNT(trips.id) FILTER (WHERE users.user_type = 'Unknown') AS unknown_trips
    , COUNT(trips.exceed_trip_duration) FILTER (where trips.exceed_trip_duration=True) AS late_return
FROM trips
RIGHT JOIN dates ON trips.date_key = dates.date_key
LEFT JOIN users ON trips.id = users.trip_id
GROUP BY dates.date_key
ORDER BY dates.date_key;

--- create a view with daily trips + weather information (daily_data)
CREATE VIEW daily_data AS
SELECT daily_trips.date_key
    , daily_trips.date
    , daily_trips.month
    , daily_trips.day
    , daily_trips.day_name
    , daily_trips.weekend
    , daily_trips.total_trips
    , daily_trips.subscriber_trips
    , daily_trips.customer_trips
    , daily_trips.unknown_trips
    , daily_trips.late_return
    , weather.avg_wind
    , weather.prcp
    , weather.snow_amount
    , weather.snow_depth
    , weather.tavg
    , weather.tmax
    , weather.tmin
    , weather.rain
    , weather.snow
FROM daily_trips
JOIN weather ON daily_trips.date_key = weather.date_key
ORDER BY daily_trips.date_key;

--- create a view with montlhly trips + weather information (monthly_data)
CREATE VIEW monthly_data AS
SELECT dates.month
    , SUM(daily_data.total_trips) AS total_trips
    , ROUND(AVG(daily_data.total_trips)) AS avg_daily_trips
    , SUM(daily_data.subscriber_trips) AS total_subscriber_trips
    , ROUND(AVG(daily_data.subscriber_trips)) AS avg_subscriber_trips
    , SUM(daily_data.customer_trips) AS total_customer_trips
    , ROUND(AVG(daily_data.customer_trips)) AS avg_customer_trips
    , SUM(daily_data.unknown_trips) AS total_unknown_trips
    , ROUND(AVG(daily_data.unknown_trips)) AS avg_unkown_trips
    , SUM(daily_data.late_return) AS toal_late_return
    , ROUND(AVG(daily_data.tavg)) AS avg_tavg
    , COUNT(daily_data.snow) FILTER (WHERE daily_data.snow=True) AS snow_days
    , COUNT(daily_data.rain) FILTER (WHERE daily_data.rain=True) AS rain_days
    , MAX(daily_data.snow_amount) AS max_snow_amount
    , MAX(daily_data.prcp) AS max_prcp
FROM dates
JOIN daily_data ON dates.date_key = daily_data.date_key
GROUP BY dates.month
ORDER BY dates.month;

--- create a view to highlight the trips that went beyond the valid duration
CREATE VIEW late_return AS
SELECT dates.date
    , trips.id
    , trips.trip_duration
    , trips.bike_id
    , [( SELECT stations.name
          FROM stations
         WHERE trips.start_station_id = stations.id)] AS start_location
    , [( SELECT stations.name
          FROM stations
         WHERE trips.end_station_id = stations.id)] AS end_location
    , users.user_type
FROM trips
JOIN dates ON trips.date_key = dates.date_key
JOIN users ON trips.id = users.trip_id
WHERE trips.exceed_trip_duration = True; 