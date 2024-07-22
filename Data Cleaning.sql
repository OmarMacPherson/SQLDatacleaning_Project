SELECT *
FROM stolen_vehicles;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or blank Values
-- 4. Remove any columns

# We are going to create a table backup following best practices and avoid damage the original dataset
# We use the LIKE for create the table following the same columns than our original dataset

CREATE TABLE stolen_vehicles_backup
LIKE stolen_vehicles;

SELECT *
FROM stolen_vehicles_backup;

# Now we are going to insert all the data and information of our original Data Set

INSERT stolen_vehicles_backup
SELECT *
FROM stolen_vehicles;

# We are going to bring the information of table "make_details" for have it in our dataset

ALTER TABLE stolen_vehicles_backup
ADD COLUMN make_name VARCHAR(255),
ADD COLUMN make_type VARCHAR(255);

# We are going to disable safe update mode.

SET SQL_SAFE_UPDATES = 0;

# Now we are going to update our main table

UPDATE stolen_vehicles_backup svb
JOIN make_details md ON svb.make_id = md.make_id
SET svb.make_name = md.make_name,
svb.make_type = md.make_type;

# for protection of our database will be re-enable safe update mode

SET SQL_SAFE_UPDATES = 1;

# Now we are going to our table the information of the table "locations" in our dataset

ALTER TABLE stolen_vehicles_backup
ADD COLUMN region VARCHAR(255),
ADD COLUMN country VARCHAR(255),
ADD COLUMN population VARCHAR(255),
ADD COLUMN density VARCHAR(255);

# Now We are going to disable safe update mode.

SET SQL_SAFE_UPDATES = 0;

# Now we are going to incorporate the data of our table "locations" for the table "stolen_vehicles_backup"

UPDATE stolen_vehicles_backup svb
JOIN locations l ON svb.location_id = l.location_id
SET svb.region = l.region,
	svb.country = l.country,
	svb.population = l.population,
	svb.density = l.density;
    
# Now We are going to disable safe update mode.

SET SQL_SAFE_UPDATES = 0;

# Identify duplicates in our dataset 

SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY vehicle_type, make_id, model_year, vehicle_desc, 
color, date_stolen, location_id, make_name, make_type, region, country, population, density) AS row_num
FROM stolen_vehicles_backup;

# With the use of CTE we identify if we have or we dont have duplicates 

WITH duplicate_cte as
(
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY vehicle_type, make_id, model_year, vehicle_desc, 
color, date_stolen, location_id, make_name, make_type, region, country, population, density) AS row_num
FROM stolen_vehicles_backup
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

# We check that the information provided that is duplicated is correct, checking the information. 

SELECT *
FROM stolen_vehicles_backup
WHERE date_stolen = '1/8/22'
AND vehicle_desc = 'FORESTER';

SELECT *
FROM stolen_vehicles_backup
WHERE date_stolen = '1/29/22'
AND vehicle_desc = 'CAPELLA';

SELECT *
FROM stolen_vehicles_backup
WHERE date_stolen = '3/4/22'
AND vehicle_desc = 'COURIER';

SELECT *
FROM stolen_vehicles_backup
WHERE date_stolen = '11/17/21'
AND vehicle_desc = 'CAPELLA';

# Now we are going to delete all the duplicates of our dataset, using our CTE and DELETE statement.

WITH duplicate_cte as
(
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY vehicle_type, make_id, model_year, vehicle_desc, 
color, date_stolen, location_id, make_name, make_type, region, country, population, density) AS row_num
FROM stolen_vehicles_backup
)
DELETE
FROM duplicate_cte
WHERE row_num > 1;

# However, sometimes the system cannot allow this option, so the second way to do it, is creating another table and removing the duplicates data.alter

CREATE TABLE `stolen_vehicles_backup2` (
  `vehicle_id` int DEFAULT NULL,
  `vehicle_type` text,
  `make_id` int DEFAULT NULL,
  `model_year` text,
  `vehicle_desc` text,
  `color` text,
  `date_stolen` text,
  `location_id` int DEFAULT NULL,
  `make_name` varchar(255) DEFAULT NULL,
  `make_type` varchar(255) DEFAULT NULL,
  `region` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `population` varchar(255) DEFAULT NULL,
  `density` varchar(255) DEFAULT NULL,
  `row_numb` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

# Now we are going to add the info of our table backup

INSERT INTO stolen_vehicles_backup2
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY vehicle_type, make_id, model_year, vehicle_desc, 
color, date_stolen, location_id, make_name, make_type, region, country, population, density) AS row_num
FROM stolen_vehicles_backup;

# Now our table has been created and we must delete the duplicate data of the column 'row_numb'

DELETE
FROM stolen_vehicles_backup2
WHERE row_numb > 1;

# Now we are going to Standardizing data and we are going to standarize the column "vehicle_type". to everyone to Trailer.

SELECT *
FROM stolen_vehicles_backup2
WHERE vehicle_type LIKE 'Trailer%';

UPDATE stolen_vehicles_backup2
SET vehicle_type = 'Trailer'
WHERE vehicle_type LIKE 'Trailer%';

# Now we are going to standardizing the data of the column 'make_name', wrong writing of the make Kia with the word Kea, we need to standarize.
# we found 28 rows affected with the error typing of the make of the car that can cause error in the visualizations

SELECT DISTINCT make_name
FROM stolen_vehicles_backup2
ORDER BY 1;

SELECT *
FROM stolen_vehicles_backup2
WHERE make_name LIKE 'Kea';

UPDATE stolen_vehicles_backup2
SET make_name = 'Kia'
WHERE make_name LIKE 'Kea';

# Now we need to change the data type correct for better analyse in the visualizations. In our column Date.

SELECT date_stolen
FROM stolen_vehicles_backup2;

SELECT date_stolen,
STR_TO_DATE(date_stolen, '%m/%d/%Y')
FROM stolen_vehicles_backup2;

UPDATE stolen_vehicles_backup2
SET date_stolen = STR_TO_DATE(date_stolen, '%m/%d/%Y');

ALTER TABLE stolen_vehicles_backup2
MODIFY COLUMN date_stolen DATE;

# Now we need to convert the data type of the columns 'model_year', 'population' and 'density' that will help for our visualizations

SELECT *
FROM stolen_vehicles_backup2;

ALTER TABLE stolen_vehicles_backup2
MODIFY COLUMN model_year INT;

ALTER TABLE stolen_vehicles_backup2
MODIFY COLUMN population INT;

ALTER TABLE stolen_vehicles_backup2
MODIFY COLUMN density DECIMAL(10,2);

# Now is time to removal blank values that is not neccesary in our database 
# We use SELF JOIN for match the information of Make ID and get the information of Vehicle Type

UPDATE stolen_vehicles_backup2
SET vehicle_type = NULL
WHERE vehicle_type = '';


UPDATE stolen_vehicles_backup2 svb1
JOIN (
    SELECT make_id, vehicle_desc, vehicle_type
    FROM stolen_vehicles_backup2
    WHERE vehicle_type IS NOT NULL
) svb2 ON svb1.make_id = svb2.make_id AND svb1.vehicle_desc = svb2.vehicle_desc
SET svb1.vehicle_type = svb2.vehicle_type
WHERE svb1.vehicle_type IS NULL;

# We dont have the data specified for the last 7 rows of vehicle_type that we have NULL values
# Because is not a big number, we can set the name like "Unknown" and wont be affected our analysis

SELECT *
FROM stolen_vehicles_backup2
WHERE vehicle_type IS NULL;

UPDATE stolen_vehicles_backup2
SET vehicle_type = 'Unknown'
WHERE vehicle_type IS NULL;

# Remove columns that is not neccesary for our analysis. 
# I have decided for the objetive of this project, we wont need the column "row_numb" because it was created for our data cleaning.
# I have decided remove the column "country", because is repetitive in the whole dataset, not add value.
# I have decided remove the column "location_id", because we already join the information in the dataset in the column "make_name" and "make_type"
# I have decided remove the column "make_id" because we already join the information in the dataset in the columns "region", "population" and "density"

SELECT *
FROM stolen_vehicles_backup2;

ALTER TABLE stolen_vehicles_backup2
DROP COLUMN row_numb;

ALTER TABLE stolen_vehicles_backup2
DROP COLUMN country;

ALTER TABLE stolen_vehicles_backup2
DROP COLUMN location_id;

ALTER TABLE stolen_vehicles_backup2
DROP COLUMN make_id;


-- Exploratory Data Analysis

SELECT *
FROM stolen_vehicles_backup2;

# Summary Statistics

# We are using the technique summary statistics, that provide a quick snapshot of the data's characteristics, helping identify patterns, outliers and typical values.
# Insight 1(Mean): On average, the stolen vehicles are from around the year 2005. This indicates that the majority of vehicle thefts in this dataset 
# involve vehicles that are approximately 17 years old, as of 2022.

# Insight 2(Min): The oldest vehicle stolen, as recorded in the dataset, is from the year 1940. 
# This might suggest that classic or vintage vehicles are also at risk of theft, possibly due to their value as collectibles.

# Insight 3(Standard Deviation): The standard deviation shows how much the model years of cars vary around the average year of 2005. 
# It means that many of the cars are roughly 9 years older or 9 years newer than 2005. 
# So, the common model years of these cars range from around 1996 to around 2014.
# understanding which models are most commonly stolen can help focus preventive measures or recovery efforts.


SELECT AVG(model_year), MIN(model_year), MAX(model_year), STDDEV(model_year)
FROM stolen_vehicles_backup2;

# We analyse what are the range of dates of stolen. Our dataset is between 07/10/2021 and 06/04/2022

SELECT MIN(date_stolen) as Minimun, MAX(date_stolen) as Maximun
FROM stolen_vehicles_backup2;

# Frequency of thefts

# Auckland is the most dangerous region with most stolen cars in 2021 and 2022.
# answer question: Which regions in New Zealand are most prone to vehicle thefts?

SELECT region, COUNT(*) AS number_of_thefts
FROM stolen_vehicles_backup2
GROUP BY region
ORDER BY number_of_thefts DESC;

# The make more stolen is the brand Toyota
# answer question: Are certain makes or models more likely to be stolen?

SELECT make_name, COUNT(*) AS number_of_thefts
FROM stolen_vehicles_backup2
GROUP BY make_name
ORDER BY number_of_thefts DESC;

# The vehicle type more stolen are Stationwagon, following by Saloon and Trailer.
# answer question: What types of vehicles (vehicle_type) are most commonly stolen?

SELECT vehicle_type, COUNT(*) AS number_of_thefts
FROM stolen_vehicles_backup2
GROUP BY vehicle_type
ORDER BY number_of_thefts DESC;

# The model year more stolen is the models years 2005, 2006, 2007 and 2004.
# answer question: How does the model year relate to the likelihood of a vehicle being stolen?

SELECT model_year, COUNT(*) AS number_of_thefts
FROM stolen_vehicles_backup2
GROUP BY model_year
ORDER BY number_of_thefts DESC;

# We can identify that in 2022 has increase the number of thefts from the previous year.
# answer question: Has there been an increase or decrease in vehicle thefts over the years?

SELECT YEAR (date_stolen) AS year_stolen, COUNT(*) AS number_of_thefts
FROM stolen_vehicles_backup2
GROUP BY YEAR(date_stolen)
ORDER BY year_stolen DESC;

# Final insights in frequency
# Businesses can use frequency counts to understand consumer behavior or risk profiles. 
# In your case, understanding which vehicles are most often stolen might help automotive companies 
# or insurers tailor their products and services to better meet consumer needs and mitigate risks.

-- TRENDS OVER TIME

# 2022 has increased significatly the number of thefts. 
# Answer question: When are vehicle thefts most common? (Time of year, year on year trends)

SELECT DATE_FORMAT(date_stolen, '%Y-%m') AS month, COUNT(*) AS thefts
FROM stolen_vehicles_backup2
GROUP BY month
ORDER BY month;

# Exploring Correlation 

# Auckland, with the highest average population, also has the highest theft count. 
# This suggests that regions with larger populations might be more prone to theft, 
# likely due to a greater number of targets (vehicles) and possibly more anonymity for thieves.

#Auckland not only has a high population but also the highest population density, 
# which correlates with the highest theft count. 
# This indicates that more densely populated areas might experience higher instances of theft. 
# Density can contribute to crime as higher population density often leads to more opportunities for crime and may affect policing effectiveness.

# Regions like Southland and Nelson, which have much lower densities, show significantly lower theft counts. 
# This might suggest that lower-density areas, where people might be more spread out and perhaps know each other better, 
# could experience fewer thefts.

# Some regions like Canterbury and Waikato, despite having relatively high populations, 
# do not have theft counts as high as Auckland. This might suggest other mitigating factors such as effective law enforcement, 
# community vigilance, or fewer targeted vehicle types.
# answer question: How does vehicle theft correlate with population density in these regions?

SELECT 
    region, 
    AVG(population) AS avg_population, 
    AVG(density) AS avg_density, 
    COUNT(*) AS theft_count
FROM stolen_vehicles_backup2
GROUP BY region
ORDER BY theft_count DESC;

# We define what type of car is preferred stole if standard or luxury, and standard is the prefered. 

SELECT make_type, COUNT(*) AS theft_count
FROM stolen_vehicles_backup2
GROUP BY make_type
ORDER BY theft_count DESC;

# answer question: Is there a relationship between the type of vehicle and the region where it is stolen?

SELECT vehicle_type, region, COUNT(*) AS theft_count
FROM stolen_vehicles_backup2
GROUP BY vehicle_type, region
ORDER BY vehicle_type, theft_count DESC;

SELECT make_name, COUNT(*) as number_of_bmws
FROM stolen_vehicles_backup2
WHERE make_name = 'BMW'
GROUP BY make_name;

SELECT make_name
FROM stolen_vehicles_backup2
WHERE make_name LIKE 'Kia'




