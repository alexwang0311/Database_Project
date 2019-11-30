-- Stored procedures

-- 1
-- filter accident records based on year and month (optional)
-- year options:
/*
1942
1956
1969
1973
1975
1978
1983
1989
1990
2001
2006
2008 - 2019

month :
0: all months
1-12 : January - December
*/
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
-- filter accident records based on city
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

-- 3
-- filter accident records based on injuries and fatalities
-- 1: no injuries or fatalities
-- 2: injuries, no fatalities
-- 3: fatalities (and injuries)
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

-- 4
-- filter accident records based on weather conditions
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






