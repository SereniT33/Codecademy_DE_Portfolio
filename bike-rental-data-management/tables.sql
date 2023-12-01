CREATE TABLE dates (
  date_key integer PRIMARY KEY,
  date date,
  month integer,
  day integer,
  day_name varchar(20),
  weekend boolean
 );

CREATE TABLE stations (
  id integer PRIMARY KEY,
  name varchar(50),
  latitude real,
  longitude real
  );
  
 CREATE TABLE trips (
   id integer PRIMARY KEY,
   date_key integer,
   trip_duration integer,
   start_time timestamp,
   stop_time timestamp,
   start_station_id integer,
   end_station_id integer,
   bike_id integer,
   exceed_trip_duration boolean,
   FOREIGN KEY (date_key) REFERENCES dates(date_key),
   FOREIGN KEY (start_station_id) REFERENCES stations(id),
   FOREIGN KEY (end_station_id) REFERENCES stations(id)
 );
 
 CREATE TABLE users (
   id integer PRIMARY KEY,
   user_type varchar(50),
   birth_year integer,
   gender integer,
   trip_id integer,
   FOREIGN KEY (trip_id) REFERENCES trips(id)
  );
 
  
  CREATE TABLE weather (
    id integer PRIMARY KEY,
    date date,
    avg_wind real,
    prcp real,
    snow_amount real,
    snow_depth real,
    tavg integer,
    tmax integer,
    tmin integer,
    rain boolean,
    snow boolean,
    date_key integer,
    FOREIGN KEY (date_key) REFERENCES dates(date_key)
   );