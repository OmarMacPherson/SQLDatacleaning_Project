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
