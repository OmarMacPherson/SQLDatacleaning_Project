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
![Data Analyst Professional](https://github.com/OmarMacPherson/SQLDatacleaning_Project/blob/main/ALTER%20TABLE.png)

> [!IMPORTANT]
> To facilitate the use of **UPDATE** and **DELETE** commands in our SQL operations, I needed to disable safe mode. This was accomplished by executing the following query:

```ruby
SET SQL_SAFE_UPDATES = 0;
```






















