# SQL Data Cleaning and Exploratory Analysis of Vehicle Theft Data in New Zealand!

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/Title%20Omar%20Mac%20Pherson.png)

## Purpose of this Project

This project focuses on cleaning and analysing a dataset related to vehicle thefts in New Zealand. The goal is to prepare the data for meaningful analysis and uncover insights into patterns of vehicle theft across different regions and vehicle types.

# Data Source

- 📁 This project utilizes a robust dataset from [Maven Analytics](https://mavenanalytics.io/data-playground?page=3&pageSize=5), containing over 4,500 entries related to vehicle thefts. The dataset provides comprehensive details including the make, model, type, date, and location of each theft incident.

# Tech Stack Used in this project

![MySQL](https://img.shields.io/badge/mysql-4479A1.svg?style=for-the-badge&logo=mysql&logoColor=white)
![Microsoft Excel](https://img.shields.io/badge/Microsoft_Excel-217346?style=for-the-badge&logo=microsoft-excel&logoColor=white)
![macOS](https://img.shields.io/badge/mac%20os-000000?style=for-the-badge&logo=macos&logoColor=F0F0F0)
![Tableau](https://img.shields.io/badge/Tableau-E97627?style=for-the-badge&logo=Tableau&logoColor=white)

# Techniques Used in this Project

This project employs a comprehensive array of SQL operations to ensure the dataset’s integrity and readiness for analysis. Detailed SQL queries and data manipulation techniques used include:

### a) SQL Queries:

* Utilized a variety of commands such as:

    * ‘SELECT’
    * ‘FROM’
    * ‘WHERE’
    * ‘GROUP BY’
    * ‘ORDER BY’
    * ‘JOIN’
    * ‘SELF JOIN’
    * ‘UPDATE’
    * ‘SET’
    * ‘ALTER’
    * ‘MODIFY COLUMN’
    * ‘LIKE’
    * ‘ROWNUMBER() OVER (PARTITION BY)’
    * ‘INSERT INTO’
    * ‘AND’
    * ‘ADD COLUMN’.

### b) Data Cleaning Techniques:

Techniques such as:

* **Creating backups**
* **Removing duplicates**
* **Standardizing data**
* Changing **data types**
* **Removing unnecessary columns** 

### c) Data Analysis:

Applied **advanced querying** to extract nuanced insights and answer specific investigative questions, enhancing understanding of vehicle theft trends.

# Configuration

Before initiating the **data cleaning process**, it was necessary to address an encoding issue that prevented the dataset from being imported into **MySQL**. The original file was not in UTF-8 encoding, which is required for compatibility with **MySQL**. To resolve this, I utilized **Microsoft Excel** to convert and save the file with the correct **UTF-8 encoding**. This adjustment ensured the data could be imported successfully into **MySQL** for further processing.

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/MS%20Excel.png)

Import Successfully in MySQL

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/Import%20data.png)

# Data Cleaning Process

### Step 1: Create Table Backup

Before starting the **data cleaning process**, it is necessary to ensure data integrity by following best practices, which include creating a backup before making any modifications.

To achieve this, I **created a new table** with the same columns as my main dataset called **“stolen_vehicles”** and inserted all the data into a new backup table called **“stolen_vehicles_backup.”**

```ruby
CREATE TABLE stolen_vehicles_backup
LIKE stolen_vehicles;
```

```ruby
INSERT stolen_vehicles_backup
SELECT *
FROM stolen_vehicles;
```

## Backup Data successfully created

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/BACKUP%20succeffully%20created.png)

### Step 2: Check the size of the dataset

I verified the total number of rows in the dataset, which amounts to 4,538. This count is crucial as it establishes a baseline for ensuring data consistency and integrity throughout the cleaning process. It helps in identifying any discrepancies or anomalies as we proceed.

```ruby
SELECT COUNT(*) AS 'Number of rows'
FROM stolen_vehicles_backup;
```

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/Number%20rows.png)

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/Number%20rows%202.png)

### Step 3: Consolidate Tables into One:

Our dataset was initially spread across three separate tables: **"locations"**, **"make_details"**, and **"stolen_vehicles"**. To centralize the data for streamlined analysis, I merged these tables into a single table.

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/3%20files.png)

To integrate all relevant information, I used the **ALTER TABLE** command to add new columns to the main table, **"stolen_vehicles_backup"**. Specifically, I included **"make_name"** and **"make_type"** from the external **"make_details"** table, enhancing our dataset with comprehensive vehicle make information.

```ruby
ALTER TABLE stolen_vehicles_backup
ADD COLUMN make_name VARCHAR(255),
ADD COLUMN make_type VARCHAR(255);
```

## New Columns Added

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/ALTER%20TABLE.png)

> [!IMPORTANT]
> To facilitate the use of **UPDATE** and **DELETE** commands in our SQL operations, I needed to disable safe mode. This was accomplished by executing the following query:

```ruby
SET SQL_SAFE_UPDATES = 0;
```

## Populating New Columns:

After adding new, initially empty columns to the **stolen_vehicles_backup table**, we proceeded to fill these columns with data. This was accomplished using the following SQL commands: **“UPDATE”**, **“JOIN”** and **“SET”**.

```ruby
UPDATE stolen_vehicles_backup svb
JOIN make_details md ON svb.make_id = md.make_id
SET svb.make_name = md.make_name,
    svb.make_type = md.make_type;
```

## Extending the Main Table with Geographic Information:

To further enhance our analysis capabilities, I added new columns to the **stolen_vehicles_backup** table to include geographic information such as **region**, **country**, **population**, and **density**. This allows us to incorporate detailed location data into our dataset.

```ruby
ALTER TABLE stolen_vehicles_backup
ADD COLUMN region VARCHAR(255),
ADD COLUMN country VARCHAR(255),
ADD COLUMN population VARCHAR(255),
ADD COLUMN density VARCHAR(255);
```

Following the addition of new geographic columns to the **stolen_vehicles_backup** table, I executed an **SQL query** to populate these columns with data. This was achieved by performing a **JOIN** operation with the locations table and **UPDATING** the main table accordingly.

```ruby
UPDATE stolen_vehicles_backup svb
JOIN locations l ON svb.location_id = l.location_id
SET svb.region = l.region,
	svb.country = l.country,
	svb.population = l.population,
	svb.density = l.density;
```

### Result Output

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/locations%20update.png)

# Step 4: Identifying Duplicate Values

To ensure the accuracy of our dataset, I implemented a **Common Table Expression (CTE)** to identify any duplicate entries in the **stolen_vehicles_backup table**. The **CTE** helps in pinpointing duplicates based on several key attributes, including **vehicle type**, **make ID**, **model year**, vehicle description, color, **date stolen**, **location ID**, and associated make and geographic details.

```ruby
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
```

The execution of our duplicate identification query revealed **13 records** that appear to be duplicates. This finding indicates a need for further in-depth analysis of these specific entries to understand their nature and determine the appropriate actions to resolve any data integrity issues.

### Output

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/Duplicate%20Columns.png)

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/Duplicate%20Columns%202.png)

> [!NOTE]  
> Before proceeding to delete any identified duplicates, it is crucial to manually verify each record to confirm that they are indeed exact duplicates. This precautionary step helps prevent the accidental deletion of unique data entries that might only superficially appear similar.

```ruby
SELECT *
FROM stolen_vehicles_backup
WHERE date_stolen = '1/8/22'
AND vehicle_desc = 'FORESTER';
```

### Output

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/Checking%20Duplicate.png)

```ruby
SELECT *
FROM stolen_vehicles_backup
WHERE date_stolen = '1/29/22'
AND vehicle_desc = 'CAPELLA';
```

### Output 

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/Checking%20dupliocate%202.png)

```ruby
SELECT *
FROM stolen_vehicles_backup
WHERE date_stolen = '3/4/22'
AND vehicle_desc = 'COURIER';
```

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/Checking%20Duplicate%203.png)

```ruby
SELECT *
FROM stolen_vehicles_backup
WHERE date_stolen = '11/17/21'
AND vehicle_desc = 'CAPELLA';
```

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/Checking%20Duplicate%204.png)

> [!IMPORTANT]  
> After confirming the presence of duplicate data, I proceeded to remove these entries using a **DELETE** statement in conjunction with a **Common Table Expression (CTE)**. This method ensures precise targeting and removal of only the duplicate records, maintaining the integrity of our dataset.

```ruby
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
```

> [!WARNING]  
> Sometimes, due to system limitations or specific configurations, the use of a **Common Table Expression (CTE)** may not be recognized. In such cases, an alternative approach is to create a temporary table, populate it with data including a row number identifier for potential duplicates, and then delete duplicates based on this identifier. This method ensures that data integrity is maintained even when traditional methods fail.

```ruby
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
```

```ruby
INSERT INTO stolen_vehicles_backup2
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY vehicle_type, make_id, model_year, vehicle_desc, 
color, date_stolen, location_id, make_name, make_type, region, country, population, density) AS row_num
FROM stolen_vehicles_backup;
```

```ruby
DELETE
FROM stolen_vehicles_backup2
WHERE row_numb > 1;
```

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/DELETE%20Duplicate.png)

# Step 5: Data Standardization

In our dataset, the **"vehicle_type"** column includes multiple categorizations for trailers, specifically **"Trailer"** and **"Trailer - Heavy".** To simplify analysis and ensure uniformity in our data handling, we will standardize these entries under a single label **"Trailer"**.

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/Standardisation%20names%20Trailer.png)

I consolidate all variations to **“Trailer”** to maintain consistency.

```ruby
UPDATE stolen_vehicles_backup2
SET vehicle_type = 'Trailer'
WHERE vehicle_type LIKE 'Trailer%';
```

### Output

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/Trailer%20standarize.png)

I identified an inconsistency in the spelling of the car make **"Kia"** which was erroneously entered as **"Kea"**. To ensure **data accuracy** and consistency in our analysis, we need to **standardize** these entries.

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/Standardisation%20Kia%20and%20KEA.png)

A review of the dataset revealed 28 records where **"Kia"** was misspelled as **"Kea"**.

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/28%20ROWS%20WITH%20KEA.png)

### Solution

```ruby
UPDATE stolen_vehicles_backup2
SET make_name = 'Kia'
WHERE make_name LIKE 'Kea';
```

### Output

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/KIA%20FIXED.png
)

# Step 6: Converting Date Format for Better Analysis

The **date_stolen** column was initially formatted as text, which can hinder efficient date-based analysis and visualization. To optimize this, we converted the text entries into a proper **date format**.

### Process:

> [!IMPORTANT]  
> Before applying the change to the entire dataset, we previewed the conversion to ensure accuracy.

```ruby
SELECT date_stolen,
STR_TO_DATE(date_stolen, '%m/%d/%Y')
FROM stolen_vehicles_backup2;
```

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/Date%20format%20UPDATED.png)



















































