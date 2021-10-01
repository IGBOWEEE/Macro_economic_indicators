/* SELECTING THE DATABASE IN USE */

USE  inflation;

# Viewing the different tables

SELECT * FROM exchange_rates;
SELECT * FROM fuel_prices;
SELECT * FROM inflation_rate;
SELECT * FROM interest_rates;
SELECT * FROM money_supply;
SELECT * FROM gdp1;

# CLEANING THE TABLES
# first we need to restructure the 'Year' column into a proper date format as 'Dates'
SELECT
	Year,
	str_to_date(year, '%m/%d/%Y') as Years
FROM 
	money_supply
limit 10;

# ADDING date_year TO GDP1 TABLE
ALTER TABLE gdp1
ADD Date_year int;

UPDATE gdp1
SET Date_year = Year;

SELECT * FROM gdp1;

# ADDING date_year COLUMN TO money_supply TABLE

ALTER TABLE money_supply
ADD Dates DATE;

ALTER TABLE money_supply
ADD Date_year int;

UPDATE money_supply
SET Dates = str_to_date(year, '%m/%d/%Y');

UPDATE money_supply
SET Date_year = year(Dates);

SELECT * FROM money_supply;

# ADDING date_year COLUMN TO exchange_rate TABLE
ALTER TABLE exchange_rates
ADD Dates DATE;

ALTER TABLE exchange_rates
ADD Date_year int;

UPDATE exchange_rates
SET Dates = str_to_date(year, '%m/%d/%Y');

UPDATE exchange_rates
SET Date_year = year(Dates);

# ADDING date_year COLUMN TO fuel_prices TABLE
ALTER TABLE fuel_prices
ADD Dates DATE;

ALTER TABLE fuel_prices
ADD Date_year int;

UPDATE fuel_prices
SET Dates = str_to_date(year, '%m/%d/%Y');

UPDATE fuel_prices
SET Date_year = year(Dates);

# ADDING date_year COLUMN TO inflation_rate TABLE
ALTER TABLE inflation_rate
ADD Dates DATE;

ALTER TABLE inflation_rate
ADD Date_year int;

UPDATE inflation_rate
SET Dates = str_to_date(year, '%m/%d/%Y');

UPDATE inflation_rate
SET Date_year = year(Dates);

# ADDING date_year COLUMN TO interest_rates TABLE

ALTER TABLE interest_rates
ADD Dates DATE;

ALTER TABLE interest_rates
ADD Date_year int;

UPDATE interest_rates
SET Dates = str_to_date(year, '%m/%d/%Y');

UPDATE interest_rates
SET Date_year = year(Dates);

# USING JOINS TO CREATE A UNIFIED TABLE FROM ALL THE TABLES IN THE DATABASE

SELECT 
    er.Date_year,
    ROUND(AVG(er.BDC), 2) AS BDC,
    ROUND(AVG(f.fuel_price), 2)AS FUEL_PRICE,
    ROUND(AVG(g.Total_GDP), 2) AS GDP,
    ROUND(AVG(i.All_Items_Year_on_Year_change), 2) AS Inflation,
    ROUND(AVG(ir.maximum_lending_rate), 2) AS MAX_LENDING_RATE,
    ROUND(AVG(m.money_supply_m2), 2) AS MONEY_SUPPLY
FROM
    exchange_rates er
        LEFT JOIN
    fuel_prices f ON er.Date_year = f.Date_year
        JOIN
    money_supply m ON f.Date_year = m.Date_year
        JOIN
    interest_rates ir ON m.Date_year = ir.Date_year
        LEFT JOIN
    inflation_rate i ON ir.Date_year = i.Date_year
        JOIN
    gdp1 g ON er.Date_year = g.Date_year
GROUP BY er.Date_year
ORDER BY er.Date_year;


 /* steps taken
1. Getting the data from the Central Bank Website
2. Cleaning the data of irregularities
3. Transforming the data 
4. Importing the tables into MySQL workbench
5. Transforming the date format into a suitable one i.e from string to date for MySQL querying 
6. Extracting the Year from the date in order to use the Year in the query
7. Updating the tables and altering them to include the new 'Date' and 'Date-year'
8. Using joins, I created a query which combines key indices from each table into 1 table to enable proper use of this indices for 
further manipulation outside of MySQL workbench

*/


