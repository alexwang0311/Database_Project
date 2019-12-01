-- Stored procedures
-- Some useful procedures that are called from the backend
-- Author: Zhitao Shu
-- Last changed: 11/30/2019

-- filter_time
-- filter accident records based on year and month (optional)
-- input param @yr: the year to be queried
-- input param @mon: the month to be queried. 0 represents the whole year
-- output param @num_hit_and_run: total number of hit and runs of the specified year and month(s)
-- output param @num_inj: total number of injuries of the specified year and month(s)
-- output param @num_fatal: total number of fatalities of the specified year and month(s)
DROP PROCEDURE IF EXISTS filter_time;
DELIMITER //
CREATE PROCEDURE filter_time(IN yr INT, IN mon INT, OUT num_hit_and_run INT, OUT num_inj  INT, OUT num_fatal INT)
BEGIN

IF mon = 0 THEN
SELECT COUNT(*) FROM accident_info INNER JOIN damage_info USING(accident_id)
WHERE YEAR(accident_date) = yr AND hit_and_run = 'Y' INTO num_hit_and_run;

SELECT SUM(num_injuries) FROM accident_info INNER JOIN damage_info USING(accident_id)
WHERE YEAR(accident_date) = yr INTO num_inj;

SELECT SUM(num_fatalities) FROM accident_info INNER JOIN damage_info USING(accident_id)
WHERE YEAR(accident_date) = yr INTO num_fatal;

ELSE
SELECT COUNT(*) FROM accident_info
WHERE YEAR(accident_date) = yr AND MONTH(accident_date) = mon AND hit_and_run = 'Y' INTO num_hit_and_run;

SELECT SUM(num_injuries) FROM accident_info INNER JOIN damage_info USING(accident_id)
WHERE YEAR(accident_date) = yr AND MONTH(accident_date) = mon INTO num_inj;

SELECT SUM(num_fatalities) FROM accident_info INNER JOIN damage_info USING(accident_id)
WHERE YEAR(accident_date) = yr AND MONTH(accident_date) = mon INTO num_fatal;
END IF;

END//
DELIMITER ;

-- 2
-- filter_city
-- filter accident records based on city name in Davidson County
-- input param @city_name: the city name to be queried
-- output param @num: the total number of accidents in that city
/*
options: 
NASHVILLE
ANTIOCH
HERMITAGE
GOODLETTSVILLE
WHITES CREEK
NOLENSVILLE
BRENTWOOD
MADISON
OLD HICKORY
JOELTON
ASHLAND CITY
PEGRAM
MOUNT JULIET
BELLE MEADE
LAVERGNE
DONELSON
HENDERSONVILLE
WILLIAMSON CNTY
LA VERGNE
SPRING HILL
LAKEWOOD
*/
DROP PROCEDURE IF EXISTS filter_city;
DELIMITER //
CREATE PROCEDURE filter_city(IN city_name VARCHAR(255), OUT num INT)
BEGIN
IF city_name = 'NASHVILLE' THEN
SELECT COUNT(*) FROM location_info
WHERE city = city_name or city = 'NORTH' or city = 'CENTRAL' or city = 'SOUTH' INTO num;

ELSE
SELECT COUNT(*) FROM location_info
WHERE city = city_name INTO num;
END IF;
END//
DELIMITER ;

-- filter_damage
-- filter accident records based on injuries and fatalities
-- input param @num: the code of different types of situations:
-- 1: no injuries or fatalities
-- 2: injuries, no fatalities
-- 3: fatalities (and injuries)
-- output param @ cnt: the total number of accidents that meet the conditions
DROP PROCEDURE IF EXISTS filter_damage;
DELIMITER //
CREATE PROCEDURE filter_damage(IN num INT, OUT cnt INT)
BEGIN
IF num = 1 THEN
SELECT COUNT(*) FROM damage_info
WHERE num_injuries = 0 AND num_fatalities = 0 INTO cnt;

ELSEIF num = 2 THEN
SELECT COUNT(*) FROM damage_info
WHERE num_injuries > 0 AND num_fatalities = 0 INTO cnt;

ELSEIF num = 3 THEN
SELECT COUNT(*) FROM damage_info
WHERE num_fatalities > 0 INTO cnt;
END IF;
END//
DELIMITER ;

-- filter_weather
-- filter accident records based on weather conditions
-- input param @weather: weather description
-- output param @cnt: total number of accidents under that weather
/*
options:
CLOUDY
CLEAR
RAIN
NO ADVERSE CONDITIONS
UNKNOWN
SLEET, HAIL
SNOW
OTHER (NARRATIVE)
RAIN AND FOG
FOG
SEVERE CROSSWIND
SLEET AND FOG
SMOG, SMOKE
BLOWING SAND, SOIL, DIRT, SNOW
BLOWING SNOW
BLOWING SAND/SOIL/DIRT
*/
DROP PROCEDURE IF EXISTS filter_weather;
DELIMITER //
CREATE PROCEDURE filter_weather(IN weather VARCHAR(255), OUT cnt INT)
BEGIN
SELECT COUNT(*) FROM weather_info
WHERE weather_desc = weather INTO cnt;
END//
DELIMITER ;






