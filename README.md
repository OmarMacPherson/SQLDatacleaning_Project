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

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/Excel%20crop.png)

### Import Successfully in MySQL

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

After confirming the conversion accuracy, we **updated** the column to store the dates in the correct format.

```ruby
UPDATE stolen_vehicles_backup2
SET date_stolen = STR_TO_DATE(date_stolen, '%m/%d/%Y');
```

Finally, we altered the data type of the **date_stolen** column to **DATE** to facilitate proper **date handling** in SQL queries and visualizations.

```ruby
ALTER TABLE stolen_vehicles_backup2
MODIFY COLUMN date_stolen DATE;
```

# Step 7: Converting Data Types for Enhanced Analysis

For more effective analysis and visualization, we identified the need to convert the data types of several key columns in our dataset. Specifically, the **'model_year'**, **'population'**, and **'density'** columns were originally stored in formats that are not optimal for numerical analysis.

The **'model_year'** should be represented as an integer to enable year-based calculations and comparisons.

```ruby
ALTER TABLE stolen_vehicles_backup2
MODIFY COLUMN model_year INT;
```

Accurate population figures are crucial for demographic analysis.

```ruby
ALTER TABLE stolen_vehicles_backup2
MODIFY COLUMN population INT;
```

The **'density'** column represents population density, which may require precision to account for fractional values. Thus, i converted this column to a decimal format.

```ruby
ALTER TABLE stolen_vehicles_backup2
MODIFY COLUMN density DECIMAL(10,2);
```

# Step 8: Removing and Correcting Blank Data

**Blank data** in key fields can impede accurate analysis. In this step, we focus on **removing unnecessary blank values** from the **vehicle_type** column and ensuring consistency across similar records.

First, I convert any empty strings in the **'vehicle_type'** column to NULL for **standardization**.

```ruby
UPDATE stolen_vehicles_backup2
SET vehicle_type = NULL
WHERE vehicle_type = '';
```

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/7%20ROWS%20nulls%20now.png)

To fill in the **NULL** values in the **'vehicle_type'** where possible, we perform a **SELF JOIN** to match records by **'make_id'** and **'vehicle_desc'**. This allows us to propagate known **'vehicle_type'** values from similar records.

```ruby
UPDATE stolen_vehicles_backup2 svb1
JOIN (
    SELECT make_id, vehicle_desc, vehicle_type
    FROM stolen_vehicles_backup2
    WHERE vehicle_type IS NOT NULL
) svb2 ON svb1.make_id = svb2.make_id AND svb1.vehicle_desc = svb2.vehicle_desc
SET svb1.vehicle_type = svb2.vehicle_type
WHERE svb1.vehicle_type IS NULL;
```

After addressing most blank entries through previous steps, a few records (specifically the last 7 rows in the **'vehicle_type'** column) still contain **NULL** values due to unavailable data. Given the small number affected, assigning these entries a default value of **"Unknown"** will not significantly impact our overall analysis.

```ruby
UPDATE stolen_vehicles_backup2
SET vehicle_type = 'Unknown'
WHERE vehicle_type IS NULL;
```

### Output

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/Null%20to%20Unknown.png)

# Step 9: Removing Unnecessart Columns

I decided to remove several columns that were either redundant or not necessary for the project's objectives.

* **'row_numb':** This column was temporarily created to assist with identifying duplicates and is no longer needed following data cleaning.
* **'country':** This column was removed because it contains repetitive information that does not add value to our specific analysis.
* **'location_id':** Removed as its purpose was fulfilled after merging relevant location data into the dataset, specifically into 'make_name' and 'make_type'.
* **'make_id':** This column was redundant after successfully joining and embedding its information into 'region', 'population', and 'density'.

### Queries to remove Columns

```ruby
ALTER TABLE stolen_vehicles_backup2
DROP COLUMN row_numb;
```

```ruby
ALTER TABLE stolen_vehicles_backup2
DROP COLUMN country;
```

```ruby
ALTER TABLE stolen_vehicles_backup2
DROP COLUMN location_id;
```

```ruby
ALTER TABLE stolen_vehicles_backup2
DROP COLUMN make_id;
```

### Finally our dataset is clean:

### Before

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/BEFORE%20DATA%20DIRTY.png
)

### After

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/Final%20DATASET%20CLEAN.png)

# <p align="center"> Data Exploratory Analysis </p>

With the data now clean and streamlined, we can begin exploratory analysis to uncover valuable insights. We employ **summary statistics** to provide a quick overview of the data's characteristics, helping to identify **patterns**, **outliers**, and typical values that inform our understanding of vehicle theft dynamics.

### Summary Statistics

```ruby
SELECT AVG(model_year), MIN(model_year), MAX(model_year), STDDEV(model_year)
FROM stolen_vehicles_backup2;
```

### Insights derived from Summary Statistics

* **Mean (Average Model Year):**

	* **Insight:** The average model year of the stolen vehicles is approximately 2005. This suggests that the majority of vehicle thefts in this dataset involve vehicles that are about 17 years old, as of 2022.
 	* **Implication:** Older vehicles, which might lack modern security features, are predominantly targeted by thieves.
 
* **Minimum (Oldest Vehicle Stolen):**

	* **Insight:** The oldest vehicle recorded as stolen is from the year 1940.
 	* **Implication:** This indicates that classic or vintage vehicles, which are often valued as collectibles, are also at risk of theft.
 
* **Standard Deviation (Variability in Model Years):**

	* **Insight:** The standard deviation in the model years of stolen vehicles is approximately 9 years. This variability suggests that the model years of stolen cars range roughly from 1996 to 2014.
 	* **Implication:** Understanding the common model years of stolen vehicles can help in focusing preventive measures or enhancing recovery efforts for specific vehicle age groups.
 
> [!NOTE]  
> Before we proceed with addressing our investigative questions and extracting insights, it is essential to determine the time scope of the vehicle theft incidents in our dataset. Understanding the date range helps contextualize our analysis and ensures that temporal comparisons are relevant.

```ruby
SELECT MIN(date_stolen) as Minimun, MAX(date_stolen) as Maximun
FROM stolen_vehicles_backup2;
```

### Output: This query establishes that the dataset spans from July 10, 2021, to April 6, 2022.

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/Range%20dates.png)

# <p align="center"> Investigative Questions </p>

## Which regions in New Zealand are most prone to vehicle thefts?

To address this question, we employed SQL queries that utilize the **GROUP BY** and **ORDER BY** clauses. This approach helps aggregate the data by region and sort it to reveal areas with the highest number of vehicle thefts.

```ruby
SELECT region, COUNT(*) AS number_of_thefts
FROM stolen_vehicles_backup2
GROUP BY region
ORDER BY number_of_thefts DESC;
```

### Ouput: The query revealed that Auckland is significantly impacted by vehicle thefts, with a total of 1,625 reported incidents, far exceeding other regions. 

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/Output%20query%20Question.png)

The **Map visualization** created in **Tableau**, highlights Auckland in a darker shade, indicating its higher theft frequency, with detailed statistics showing that **1,511** standard vehicles and **114** luxury vehicles were stolen.

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/Map%20question%201.png)

### Insights

The concentrated high number of thefts in Auckland underscores its status as the most theft-prone region in New Zealand. This insight is crucial for local authorities and residents to strategize prevention measures effectively.

## Are certain makes or models more likely to be stolen?

To identify which vehicle makes and models are most frequently stolen, we utilized the following SQL query to **COUNT** and rank them by the number of theft incidents.

```ruby
SELECT make_name, COUNT(*) AS number_of_thefts
FROM stolen_vehicles_backup2
GROUP BY make_name
ORDER BY number_of_thefts DESC;
```

### Output

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/output%20query%20q2.png)

The bar chart illustrates these statistics, with Toyota displaying a significantly higher bar, indicating its prominence in theft incidents compared to other brands.

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/graph%20q2.png)

### Insight

The substantial theft numbers for Toyota suggest that certain vehicle characteristics associated with this brand, such as popularity and resale value, may make it a more appealing target for theft.

## What types of vehicles are most commonly stolen?

I analyzed the dataset to determine the frequency of thefts by vehicle type using the following SQL query, which counts the thefts for each type.

```ruby
SELECT vehicle_type, COUNT(*) AS number_of_thefts
FROM stolen_vehicles_backup2
GROUP BY vehicle_type
ORDER BY number_of_thefts DESC;
```

### Output

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/output%20q3.png)

The analysis clearly indicates that certain vehicle types are more frequently targeted by thieves.

The bar chart below provides a visual representation of theft frequency by vehicle type, with station wagons showing the highest incidence, followed closely by saloons and trailers.

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/graph%20q3.png)

### Insight

Station wagons emerge as the most stolen vehicle type, suggesting that their functionality and perhaps their common use in various capacities make them a preferred target for theft.

## Has there been an increase or decrease in vehicle thefts over the years?

To determine the trend in vehicle theft incidents over recent years, the following SQL query was executed to count the number of thefts annually:

```ruby
SELECT YEAR (date_stolen) AS year_stolen, COUNT(*) AS number_of_thefts
FROM stolen_vehicles_backup2
GROUP BY YEAR(date_stolen)
ORDER BY year_stolen DESC;
```

The query showed a significant increase in vehicle thefts from 2021 to 2022.

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/output%20q4.png)

The line graph below tracks monthly trends in vehicle thefts, clearly illustrating a steady increase in theft incidents from October 2021 through April 2022!

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/graph%20q4.png)

### Insight

This upward trend suggests a growing concern that may require increased attention from law enforcement and public safety agencies.

## When are vehicle thefts most common? (Time of year, year on year trends)

To identify patterns in the timing of vehicle thefts, we conducted a monthly trend analysis over the most recent years.

```ruby
SELECT DATE_FORMAT(date_stolen, '%Y-%m') AS month, COUNT(*) AS thefts
FROM stolen_vehicles_backup2
GROUP BY month
ORDER BY month;
```

### Output

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/output%20q5.png)

The line graph below illustrates the monthly trends in vehicle thefts, with a peak observed in March 2022, where the thefts dramatically increased to 1,047 incidents.

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/graph%20q5.png)

The data reveals a marked increase in vehicle thefts during the early months of 2022, peaking in March. This suggests a seasonal pattern where thefts escalate towards the end of the summer season, possibly influenced by increased outdoor activities and unattended vehicles.

## Which type of car is preferred for theft—standard or luxury?

I conducted a **COUNT** of vehicle thefts categorized by **make type** to ascertain the preference for **standard** versus **luxury** cars among thieves.

```ruby
SELECT make_type, COUNT(*) AS theft_count
FROM stolen_vehicles_backup2
GROUP BY make_type
ORDER BY theft_count DESC;
```

### Output

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/output%20q6.png)

The corresponding visualization underscores the disparity, with standard vehicles far outpacing luxury vehicles in theft occurrences.

![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/graph%20q6.png)

## Insight

**Standard vehicles** are overwhelmingly more likely to be stolen compared to luxury vehicles. This preference can be attributed to the higher number of standard vehicles in use, their ease of resale, and possibly less sophisticated security features compared to luxury models.

# Additional Insights: Population Density and Vehicle Theft Correlations

* Auckland, which has the highest average population in New Zealand, also records the highest number of vehicle thefts.
* Auckland not only possesses a high population but also the highest population density among New Zealand regions.
* Regions such as Southland and Nelson, known for their lower population densities, exhibit significantly lower theft counts.
* Despite having relatively high populations, regions like Canterbury and Waikato have lower theft counts compared to Auckland.

# Summary of Findings

This project has conducted a comprehensive analysis of vehicle thefts in New Zealand, leveraging **Advanced data cleaning techniques**, detailed **exploratory data analysis**, and **interactive visualizations**. Key insights have been drawn regarding the correlation between population density and theft rates across different regions, highlighting both expected trends and intriguing anomalies.

# Project Availability and Use

> [!IMPORTANT]  
> This project is designed to serve as a valuable resource for the community, students, lecturers, and professionals interested in the New Zealand market and vehicle theft dynamics. It offers a solid foundation for anyone looking to derive further insights or develop alternative analyses.

# Interactive Dashboard

Explore the interactive dashboard and you can get your own insights and answers for your own investigative questions. To access to the Dashboard [CLICK HERE](https://public.tableau.com/views/NZVehicleTheftsDashboardProject/Dashboard1?:language=en-GB&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link) or in the Dashboard Picture.

[![FLipkart](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/dashboard.png)](https://public.tableau.com/views/NZVehicleTheftsDashboardProject/Dashboard1?:language=en-GB&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

# SQL File

For those interested in a deeper exploration of the SQL queries used in this project or the raw data, [CLICK HERE TO CHECK THE SQL FILE](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/Data%20Cleaning.sql).

> [!IMPORTANT]
> For any inquiries or further discussions on this project, please feel free to connect via [LinkedIn](www.linkedin.com/in/omaralan). or send an [E-mail](omar.macpherson@outlook.com).

# Author

This Project has been designed and done by **Omar Mac Pherson**.

[<img src='https://cdn.jsdelivr.net/npm/simple-icons@3.0.1/icons/github.svg' alt='github' height='40'>](https://github.com/OmarMacPherson)  [<img src='https://cdn.jsdelivr.net/npm/simple-icons@3.0.1/icons/linkedin.svg' alt='linkedin' height='40'>](https://www.linkedin.com/in/omaralan/)  [<img src='https://cdn.jsdelivr.net/npm/simple-icons@3.0.1/icons/tableau.svg' alt='tableau' height='40'>](https://public.tableau.com/app/profile/omar.alan.mac.pherson/vizzes)  

# Credits

### Format & Style

    * Github Docs (https://docs.github.com/)
    * Dev (https://dev.to/github)
    * Free Code Camp (https://www.freecodecamp.org/)

### Other

    * Icons (https://github.com/anuraghazra/github-readme-stats)
    * Icons (https://www.flaticon.com/free-icons/github)
    * Design Responsive (https://arturssmirnovs.github.io/)
    * HTML (https://talk.jekyllrb.com/t/how-to-add-a-image-with-links-in-markdown/5915)
    * Markdown (https://codinhood.com/nano/git/center-images-text-github-readme/)
    * Markdown 2 (https://github.com/orgs/community/discussions/16925)
    * Badges (https://github.com/Ileriayo/markdown-badges)
    * Icons (https://cdn.jsdelivr.net/npm/simple-icons@3.0.1/icons/)
    
























































 


 
	
	














































































