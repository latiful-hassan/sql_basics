--------------------------------------------------------
-- USING AGGREGAATE FUNCTIONS IN THE SELECT STATEMENT --
--------------------------------------------------------
-- Can use multiple aggregate functions in the SELECT clause
-- Can do math with aggregate functions
-- VALID mixing of scalar and aggregate operations:
	ROUND(AVG(col))
    SUM(col*literal_value)
-- INVALID mixing of scalar and aggregate operations:
	SELECT scalar_col - AVG(scalar_col) FROM table
    SELECT scalar_col, SUM(scalar_col) FROM table

-------------------------------------------------------
-- GROUPING AND AGGREGATION, TOGETHER AND SEPARATELY -- 
-------------------------------------------------------
-- Aggregate functions can be used without GROUP BY clause and vice versa

-- When using GROUP BY in SELECT clause you can only have:
	-- Aggregate expressions
    -- Expressions used in GROUP BY
    -- Literal values

---------------------------------------------
-- NULL VALUES IN GROUPING AND AGGREGATION --
---------------------------------------------
-- Aggregate functions ignore NULL values
-- A NULL value in col with GROUP BY will return NULL in that row
-- To return number of rows in which column is non-NULL:
	SUM(col IS NOT NULL)
    
------------------------
-- THE COUNT FUNCTION --
------------------------
-- COUNT on a column will return the number of non-NULL values - COUNT(*) is an exception
-- DISTINCT is rarely helpful except with COUNT
-- DISTINCT has no effect on MIN/MAX

------------------------------------------------
-- TIPS FOR APPLYING GROUPING AND AGGREGATION -- 
------------------------------------------------
-- To group non-categorical columns you can:
	-- use WHERE clause before GROUP BY
    -- use conditional statement
    -- use 'Binning' (CASE statement)

-----------------------
-- THE HAVING CLAUSE -- 
-----------------------
-- HAVING allows you to filter using aggregates (cannot do this in WHERE)
-- You can use both WHERE and HAVING to tailor filtering
-- You can have different aggregate expressions in SELECT and HAVING
