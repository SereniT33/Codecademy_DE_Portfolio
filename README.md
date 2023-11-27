# Codecademy Portfolio: Automate Pipeline
This repository contains the portfolio project as a part of the [Codecademy DE certification].(https://www.codecademy.com/learn/paths/data-engineer)

# Project Description
This project builds a semi-automated bash+python pipeline to transform a SQLite Database into a clean source.
The final product aims to do the following:
- performs unit tests to confirm data validity
- raises errors to an error log
- automatically checks and updates changelogs
- updates a production database with new clean data

## Scenario
A fictional subscription-based company  `Cademycode` has a database of long-term cancelled subscribers. This mock database is regularly updated from multiple sources. The company wants to automate the process of cleaning the database for their analytics team. As a data engineer, my goal was to create a semi-automated data ingestion pipline that checks for new data, automatically clean and tranform the database, run unit tests, and log errors for review.

# Process

## Data Exploration & Tranformation - [Writeup in Jupyter Notebook](https://github.com/SereniT33/codecademy_automate_pipeline/blob/main/pipeline_writeup.ipynb)
Upon exploration, the raw data tables have gone through the following tranformations:
1. Changing the student's date of birth as a datatime object and creating age column;
2. Exploding the dictonary that contains student's cotact information to flat columns;
3. Changing datatypes of the columns;
4. Handling Null Values

In regards with the null values, I visualized the amount and distribution of missing values for each variable and decided that the most of missing data was missing at random (MAR). Not only that this data was MAR, it also constituted of a very small percentage of the overall data. Therefore, I chose to perform listwise deletions. 

Additionally, some missing data was structually missing. To resolve this, I introduced a new category for those group of cancelled subscribers. 

## Automation
The code to clean and join the data is wrapped in a Python script to perform unit tests and log errors for the review.

In detail, my unit tests check:
- If thee are nay updates to the database
- If all join keys are present before joining the tables
- If the number of columns match as expected
- If the data types are the same as expected
- If the cleaned table has any missing values

If the process passes all the tests, the automated cleaning script will operate as expected. If not, the errors will be logged to identify any unexpected changes for the database. 

Lastly, a bash script is created to automate the process of:
- running the unit tests and update script
- checking if the script found and made any updates
- if so, moving the newly updated clean database to a production folder
