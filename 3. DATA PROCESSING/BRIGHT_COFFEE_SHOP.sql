-- testing table
SELECT*
FROM brightcoffeecasestudy.brightcoffee_dataset.brightcoffee;

------number of shops
SELECT DISTINCT (store_location)
FROM brightcoffeecasestudy.brightcoffee_dataset.brightcoffee;

---SALES BY PRODUCT CATEGORY & TIME-INTERVAL 

SELECT
    product_category,
    CASE
        WHEN HOUR(transaction_time) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN HOUR(transaction_time) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN HOUR(transaction_time) BETWEEN 17 AND 21 THEN 'Evening'
        ELSE 'Night'
    END AS time_interval,
    SUM(transaction_qty) AS total_units_sold,
    SUM(transaction_qty * unit_price) AS total_revenue
FROM brightcoffeecasestudy.brightcoffee_dataset.brightcoffee
GROUP BY
    product_category,
    CASE
        WHEN HOUR(transaction_time) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN HOUR(transaction_time) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN HOUR(transaction_time) BETWEEN 17 AND 21 THEN 'Evening'
        ELSE 'Night'
    END
ORDER BY total_revenue DESC;

---------------

SELECT 
    product_category,

    CASE 
        WHEN HOUR(transaction_time) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN HOUR(transaction_time) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN HOUR(transaction_time) BETWEEN 17 AND 21 THEN 'Evening'
        ELSE 'Night'
    END AS time_interval,

    SUM(transaction_qty) AS total_units_sold,

    SUM(transaction_qty * unit_price) AS total_revenue

FROM brightcoffeecasestudy.brightcoffee_dataset.brightcoffee

GROUP BY 
    product_category,
    CASE 
        WHEN HOUR(transaction_time) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN HOUR(transaction_time) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN HOUR(transaction_time) BETWEEN 17 AND 21 THEN 'Evening'
        ELSE 'Night'
    END

ORDER BY 
    product_category,
    CASE 
        WHEN time_interval = 'Morning' THEN 1
        WHEN time_interval = 'Afternoon' THEN 2
        WHEN time_interval = 'Evening' THEN 3
        WHEN time_interval = 'Night' THEN 4
    END;

--------how many units (product_category) are sold at what time interval and revenue @ what store 

SELECT 
    store_LOCATION,
    product_category,

    CASE 
        WHEN HOUR(transaction_time) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN HOUR(transaction_time) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN HOUR(transaction_time) BETWEEN 17 AND 21 THEN 'Evening'
        ELSE 'Night'
    END AS time_interval,

    SUM(transaction_qty) AS total_units_sold,

    SUM(transaction_qty * unit_price) AS total_revenue

FROM brightcoffeecasestudy.brightcoffee_dataset.brightcoffee

GROUP BY 
    store_LOCATION,
    product_category,
    CASE 
        WHEN HOUR(transaction_time) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN HOUR(transaction_time) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN HOUR(transaction_time) BETWEEN 17 AND 21 THEN 'Evening'
        ELSE 'Night'
    END

ORDER BY 
    store_LOCATION,
    product_category,
    total_revenue DESC;

--------------------------
select*
from brightcoffeecasestudy.brightcoffee_dataset.brightcoffee_case_study_revenue;


SELECT 
    store_location,
    SUM(transaction_qty * unit_price) AS total_revenue
FROM brightcoffeecasestudy.brightcoffee_dataset.brightcoffee
GROUP BY store_location
ORDER BY total_revenue DESC;

------shows the profitabilty of the stores(time-intervals)
SELECT 
    store_location,

    CASE 
        WHEN HOUR(transaction_time) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN HOUR(transaction_time) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN HOUR(transaction_time) BETWEEN 17 AND 21 THEN 'Evening'
        ELSE 'Night'
    END AS time_interval,

    SUM(transaction_qty * unit_price) AS total_revenue

FROM brightcoffeecasestudy.brightcoffee_dataset.brightcoffee

GROUP BY 
    store_location,
    CASE 
        WHEN HOUR(transaction_time) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN HOUR(transaction_time) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN HOUR(transaction_time) BETWEEN 17 AND 21 THEN 'Evening'
        ELSE 'Night'
    END

ORDER BY 
    store_location,
    total_revenue DESC;

---whats time does the store open
SELECT
    MIN(transaction_time) AS opening_time,
    MAX(transaction_time) AS closing_time
FROM brightcoffeecasestudy.brightcoffee_dataset.brightcoffee;

--how many products are we selling 
SELECT
    store_location,
    COUNT(DISTINCT product_id) AS number_of_products
FROM brightcoffeecasestudy.brightcoffee_dataset.brightcoffee
GROUP BY store_location;

--what are the product category
SELECT DISTINCT
    product_category
FROM brightcoffeecasestudy.brightcoffee_dataset.brightcoffee
ORDER BY product_category;

---BIG CODE 

SELECT 
    transaction_date,
    DAYNAME(transaction_date) AS Day_name, -----DAYS OF THE WEEK
    MONTHNAME(transaction_date) AS Month_name, ----MONTHS FROM JAN TILL JUNE
     COUNT(transaction_id) AS number_of_sales, ---TOTAL NUMBER OF SALES 
     SUM(transaction_qty) AS units_sold, ----TOTAL QUANTITY SOLD
     COUNT(DISTINCT product_id) AS unique_products,-----DIFFERENT PRODUCT SOLD
     COUNT(store_id) AS number_of_stores,-----STORE ID 
     SUM(transaction_qty * unit_price) AS revenue,----TOTAL SALES REVENUE * UNIT SOLD

    CASE ----Starts a condition to classify each transaction
        WHEN DAYNAME(transaction_date) IN ('Sat','Sun') THEN 'Weekend'----Classifies Saturday and Sunday sales as Weekend
        WHEN DAYNAME(transaction_date) IN ('Mon','Tue','Wed','Thu','Fri') THEN 'Weekday'---Classifies Monday to Friday sales as Weekday
    END AS day_classification,---Ends the conditions and names the new column

    CASE 
        WHEN HOUR (transaction_time) BETWEEN 6 AND 11 THEN 'Morning'--Classifies sales from 06:00 to 11:59 as Morning
        WHEN HOUR (transaction_time) BETWEEN 12 AND 16 THEN 'afternoon'--Classifies sales from 12:00 to 16:59 as Afternoon
        WHEN HOUR (transaction_time) BETWEEN 17 AND 21 THEN 'evening'--Classifies sales from 17:00 to 21:59 as Evening
    END AS time_classification,  

    store_location,--Identifies the store where the sale happened.
    product_category,--Identifies the broad product category, such as Coffee or Bakery
    product_type,--Identifies the specific type of product
    product_detail--Provides the detailed product name or description

FROM brightcoffeecasestudy.brightcoffee_dataset.brightcoffee

GROUP BY --Groups transactions that have the same values in the selected columns.
    transaction_date,--Groups sales by the transaction date
    month_name,--Groups sales by month name
    store_location,--Separates sales by store location
    product_category,--Separates sales by product category
    product_type,--Separates sales by product type
    product_detail,--Separates sales by individual product details

    CASE 
        WHEN DAYNAME(transaction_date) IN ('Sat','Sun') THEN 'Weekend'
        WHEN DAYNAME(transaction_date) IN ('Mon','Tue','Wed','Thu','Fri') THEN 'Weekday'
    END,

    CASE 
        WHEN HOUR (transaction_time) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN HOUR (transaction_time) BETWEEN 12 AND 16 THEN 'afternoon'
        WHEN HOUR (transaction_time) BETWEEN 17 AND 21 THEN 'evening'
    END