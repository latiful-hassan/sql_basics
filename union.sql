-----------------------------------------------------
-- COMBINING QUERY RESULTS WITH THE UNION OPERATOR --
-----------------------------------------------------
-- UNION operator takes rows retuned from one SELECT and vertically combines with another

-- UNION ALL >> vertically combines, row positions are arbitrary:
	SELECT statement
    UNION ALL
    SELECT statement
-- UNION DISTINCT >> same as UNION ALL but returns only distinct values:
	SELECT statement
    UNION DISTINCT
    SELECT statement
    
-- Older vers. of Hive doesn not support UNION DISTINCT

-- UNION = UNION DISTINCT

-- number of columns, data-types and names should be equal:
	SELECT year FROM flights
    UNION DISTINCT
    SELECT CAST(year AS INT) AS year FROM games
    
------------------------------------------------------
-- MISSING OR TRUNCATED VALUES FROM TYPE CONVERSION --
------------------------------------------------------
-- type conv. can give NULL or 0 as values (depending on engine) if there is no way to CAST (e.g. STRING to INT)
-- type conv. can truncate or ROUND (depending on engine), e.g. DECIMAL to INT (19.99 -> 19, 19.99 -> 20)

-----------------------------------------
-- USING ORDER BY AND LIMIT WITH UNION --
-----------------------------------------
-- SELECT on both sides of UNION can use any clause except ORDER BY and LIMIT in Hive and Impala

-- ORDER BY --
-- MySQL allows you to ORDER BY both SELECT statements:
	SELECT statement
    UNION DISTINCT
    SELECT statement
    ORDER BY col
-- to use ORDER BY in Hive or Impala, use sub-queries

-- LIMIT --
-- can at LIMIT clause to both SELECT statements separately
-- to use LIMIT on the whole UNION, use sub-queries































