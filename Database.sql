DROP DATABASE IF EXISTS project2;
CREATE DATABASE project2;
USE project2;


DROP table IF EXISTS Raw_Table;
CREATE TABLE IF NOT EXISTS Raw_Table(
Accident_Number VARCHAR(255),
Date_and_Time VARCHAR(255),
Num_Motor_Vehicles VARCHAR(255),
Num_Injuries VARCHAR(255),
Num_Fatalities VARCHAR(255),
Property_Damage VARCHAR(255),
Hit_and_Run VARCHAR(255),
Reporting_Officer VARCHAR(255),
Collision_Type_Code VARCHAR(255),
Collision_Type_Desc VARCHAR(255),
Weather_Code VARCHAR(255),
Weather_Desc VARCHAR(255),
Illumination_Code VARCHAR(255),
Illumination_Desc VARCHAR(255),
Harmful_Code VARCHAR(255),
Harmful_Code_Desc VARCHAR(255),
Street_Address VARCHAR(255),
City VARCHAR(255),
State VARCHAR(255),
ZIP VARCHAR(255),
RPA VARCHAR(255), 
Precinct VARCHAR(255),
Latitude VARCHAR(255),
Longitude VARCHAR(255),
Mapped_Location VARCHAR(255),
PRIMARY KEY (Accident_Number, Date_and_Time)
);

LOAD DATA INFILE 'H:\\CS 3265\\Project 2\\Database_Project\\Traffic_Accidents__2019_.csv'
INTO TABLE Raw_Table
FIELDS TERMINATED BY '$'
LINES TERMINATED BY '\n';
