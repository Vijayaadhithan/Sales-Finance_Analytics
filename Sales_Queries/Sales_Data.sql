/*

Cleaning Data in SQL Queries

*/

SELECT *
FROM sales_data.features_data_set
WHERE MarkDown1 IS  NULL
   AND MarkDown2 IS NULL
   AND MarkDown3 IS NULL
   AND MarkDown4 IS NULL
   AND MarkDown5 IS NULL
   AND IsHoliday IS NULL;
   
SELECT * 
FROM sales_data.features_data_set 
WHERE MarkDown1 IS NOT NULL    
	AND MarkDown2 IS NOT NULL    
	AND MarkDown3 IS NOT NULL    
    AND MarkDown4 IS NOT NULL    
    AND MarkDown5 IS NOT NULL    
    AND IsHoliday IS NOT NULL LIMIT 10;
    
ALTER TABLE sales_data.features_data_set
DROP COLUMN MarkDown1,
DROP COLUMN MarkDown2,
DROP COLUMN MarkDown3,
DROP COLUMN MarkDown4,
DROP COLUMN MarkDown5;

SELECT *
FROM sales_data.features_data_set
Where Temperature IS NULL
AND Store is NULL
AND CPI is NULL
AND Unemployment is NULL
AND Date is NULL;

/*

Aggregate functions

*/

SELECT MAX(Weekly_Sales) AS highest_weekly_sales
FROM sales_data.sales_data_set;

SELECT MIN(Weekly_Sales) AS lowest_weekly_sales
FROM sales_data.sales_data_set;

SELECT MAX(Temperature) AS highest_temperature
FROM sales_data.features_data_set;

SELECT MIN(Temperature) AS lowest_temperature
FROM sales_data.features_data_set;

/*

Joins and Union

*/

SELECT *
FROM sales_data.features_data_set AS features
JOIN sales_data.stores_data_set AS stores ON features.Store = stores.Store
JOIN sales_data.sales_data_set AS sales ON features.Store = sales.Store
LIMIT 10;

SELECT *
FROM sales_data.features_data_set AS features
LEFT JOIN sales_data.stores_data_set AS stores ON features.Store = stores.Store
LEFT JOIN sales_data.sales_data_set AS sales ON features.Store = sales.Store LIMIT 10;

SELECT *
FROM sales_data.features_data_set AS features
RIGHT JOIN sales_data.stores_data_set AS stores ON features.Store = stores.Store
RIGHT JOIN sales_data.sales_data_set AS sales ON features.Store = sales.Store
LIMIT 10;

SELECT *
FROM sales_data.features_data_set AS features
INNER JOIN sales_data.stores_data_set AS stores ON features.Store = stores.Store
INNER JOIN sales_data.sales_data_set AS sales ON features.Store = sales.Store LIMIT 10;

SELECT *
FROM sales_data.features_data_set AS features
LEFT JOIN sales_data.stores_data_set AS stores ON features.Store = stores.Store
UNION
SELECT *
FROM sales_data.features_data_set AS features
RIGHT JOIN sales_data.stores_data_set AS stores ON features.Store = stores.Store
LIMIT 10;

/*

Cleaning Data in SQL Queries

*/

SELECT Store, Date, COUNT(*)
FROM sales_data.features_data_set
GROUP BY Store, Date
HAVING COUNT(*) > 1
LIMIT 10;

SELECT *
FROM sales_data.features_data_set
WHERE Date IN (
    SELECT Date
    FROM sales_data.features_data_set
    GROUP BY Date
    HAVING COUNT(*) > 1
)LIMIT 10;


SELECT
    f.Date,
    AVG(f.Temperature) AS Avg_Temperature,
    AVG(f.Fuel_Price) AS Avg_Fuel_Price,
    AVG(f.CPI) AS Avg_CPI,
    SUM(s.Weekly_Sales) AS Total_Weekly_Sales
FROM
    sales_data.features_data_set f
JOIN
    sales_data.sales_data_set s ON f.Store = s.Store AND f.Date = s.Date
GROUP BY
    f.Date
ORDER BY
    f.Date;

SELECT
    f.Store,
    AVG(f.Temperature) AS Avg_Temperature,
    AVG(f.Fuel_Price) AS Avg_Fuel_Price,
    AVG(f.CPI) AS Avg_CPI,
    AVG(s.Weekly_Sales) AS Avg_Weekly_Sales
FROM
    sales_data.features_data_set f
JOIN
    sales_data.sales_data_set s ON f.Store = s.Store AND f.Date = s.Date
GROUP BY
    f.Store
ORDER BY
    f.Store;

SELECT
    Store,
    Date,
    Weekly_Sales
FROM
    sales_data.sales_data_set
WHERE
    Date BETWEEN '01-01-2010' AND '31-12-2012';

SELECT Store, Date, Weekly_Sales 
FROM sales_data.sales_data_set 
WHERE IsHoliday = 'TRUE';

CREATE VIEW SalesAndFeaturesView AS
SELECT
    s.Store,
    s.Dept,
    s.Date,
    s.Weekly_Sales,
    s.IsHoliday,
    f.Temperature,
    f.Fuel_Price,
    f.CPI
FROM
    sales_data.sales_data_set s
JOIN
    sales_data.features_data_set f ON s.Store = f.Store AND s.Date = f.Date;

select * from sales_data.salesandfeaturesview LIMIT 10;

CREATE VIEW HighSalesStores AS
SELECT
    s.Store,
    s.Date,
    s.Weekly_Sales,
    f.Temperature,
    f.Fuel_Price,
    f.CPI
FROM
    sales_data.sales_data_set s
JOIN
    sales_data.features_data_set f ON s.Store = f.Store AND s.Date = f.Date
WHERE
    s.Weekly_Sales > 50000;

CREATE VIEW HolidaySalesSummary AS
SELECT
    s.Date,
    SUM(s.Weekly_Sales) AS Total_Weekly_Sales,
    AVG(f.Temperature) AS Avg_Temperature
FROM
    sales_data.sales_data_set s
JOIN
    sales_data.features_data_set f ON s.Store = f.Store AND s.Date = f.Date
WHERE
    s.IsHoliday = 'TRUE'
GROUP BY
    s.Date
ORDER BY
    s.Date;

    
SELECT
    f.Store,
    AVG(f.Temperature) AS Avg_Temperature,
    AVG(f.Fuel_Price) AS Avg_Fuel_Price,
    AVG(f.CPI) AS Avg_CPI
FROM
    sales_data.features_data_set f
WHERE
    f.Store IN (
        SELECT Store
        FROM sales_data.sales_data_set
        GROUP BY Store
        HAVING SUM(Weekly_Sales) > 100000
    )
GROUP BY
    f.Store;


SELECT
    f.Store,
    AVG(f.Temperature) AS Avg_Temperature,
    AVG(f.Fuel_Price) AS Avg_Fuel_Price,
    AVG(f.CPI) AS Avg_CPI
FROM
    sales_data.features_data_set f
WHERE
    f.Store IN (
        SELECT Store
        FROM sales_data.sales_data_set
        WHERE IsHoliday = 'TRUE'
        GROUP BY Store
        HAVING SUM(Weekly_Sales) > 50000
    )
GROUP BY
    f.Store;
    
SELECT
    s.Store,
    SUM(CASE WHEN s.IsHoliday = 'TRUE' THEN s.Weekly_Sales ELSE 0 END) / SUM(s.Weekly_Sales) AS Holiday_Sales_Ratio
FROM
    sales_data.sales_data_set s
GROUP BY
    s.Store
ORDER BY
    s.Store;
    
SELECT
    s.Store,
    AVG(s.Weekly_Sales) / st.Size AS Sales_Per_Size
FROM
    sales_data.sales_data_set s
JOIN
    sales_data.stores_data_set st ON s.Store = st.Store
GROUP BY
    s.Store, st.Size
ORDER BY
    s.Store
LIMIT 20;

SELECT
    YEAR(STR_TO_DATE(Date, '%d/%m/%Y')) AS Year,
    MONTH(STR_TO_DATE(Date, '%d/%m/%Y')) AS Month,
    SUM(Weekly_Sales) AS Monthly_Sales
FROM
    sales_data.sales_data_set
WHERE
    Date IS NOT NULL
GROUP BY
    YEAR(STR_TO_DATE(Date, '%d/%m/%Y')), MONTH(STR_TO_DATE(Date, '%d/%m/%Y'))
ORDER BY
    YEAR(STR_TO_DATE(Date, '%d/%m/%Y')), MONTH(STR_TO_DATE(Date, '%d/%m/%Y'))
LIMIT 20;


SELECT
    Date,
    DAYOFWEEK(STR_TO_DATE(Date, '%d/%m/%Y')) AS Day_of_Week,
    AVG(COALESCE(Weekly_Sales, 0)) AS Avg_Weekly_Sales
FROM
    sales_data.sales_data_set
WHERE
    Date IS NOT NULL
GROUP BY
    Date, DAYOFWEEK(STR_TO_DATE(Date, '%d/%m/%Y'))
ORDER BY
    Date
LIMIT 10;
