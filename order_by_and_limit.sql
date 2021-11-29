-------------------------
-- ORDERING EXPRESSION --
-------------------------
-- You can use expressions in the ORDER BY clause:
	SELECT *, 
		((greatest(red, green, blue) - least(red, green, blue)) / greatest(red, green, blue) AS saturation
	FROM crayons
	ORDER BY saturation DESC;
	
-- Check on DBMSs 'collation' to check ordering priorites

---------------------------------------
-- MISSING VALUES IN ORDERED RESULTS --
---------------------------------------
-- Impala/PostgreSQL handle NULL as higher that non-NULL (use DESC to change)
-- Hive/MySQL hand NULL as lower than non-NULL

-- Impala >> use NULLS FIRST or NULLS LAST in ORDER BY clause to adjust explicitly:
	ORDER BY cond NULLS FIRST
    ORDER BY cond NULLS LAST
-- Hive >> use IS/NOT NULL ASC:
	ORDER BY cond IS NULL ASC, cond 

-----------------------------------------
-- USING ORDER BY WITH HIVE AND IMPALA --
-----------------------------------------
-- HIVE ORDER BY LIMITATIONS --
-- Hive >> the columns in the ORDER BY must be included in SELECT:
	SELECT col1, col2 FROM table ORDER BY col1
-- Hive >> columns in expression in ORDER BY must be included in SELECT:
	SELECT col1, col2, col3, col4 FROM table ORDER BY col3 * col4
-- Hive >> or use column alias if using expressions:
	SELECT col1 * col2 AS col_mul FROM table ORDER BY col_mul

-- IMPALA ORDER BY SHORTCUTS --
-- Impala >> can use column index in ORDER BY:
	SELECT col1, col2, col3 FROM table ORDER BY 3  -- ordering by col3
	
-- Sorting is taxing on compute resources, so filter and constrain data before sorting to improve performance

-------------------------------
-- USING LIMIT WITH ORDER BY --
-------------------------------
-- 'Top-N Query' or 'Botton-N Query' shows N rows at top/bottom (Impala example):
	SELECT col1, col2, AVG(col3) AS avg_col 
    FROM table 
    GROUP BY col1, col2 
    ORDER BY avg_col DESC NULLS LAST 
    LIMIT 10
    
"""
If action will be taken depending on a Top-N query, always return extra rows to check for ties in values 
for example if two people made the same money for a company and based on this they get a prize, but LIMIT 
arbitrarily got rid of another person with the same or similar value
"""

--------------------------------
-- USING LIMIT FOR PAGINATION --
--------------------------------
"""
Pagination (paging) is a technique used to return multiple sets of rows, or pages, from a single query.
You will set a LIMIT and an OFFSET as constraints. For example if tyou want a page with 100 rows, 
set LIMIT 100 (implicitly has OFFSET 0). To then return another page you set LIMIT 100 OFFSET 100.
In conclusion, if you wanted rows 100-200 then >> LIMIT 100 (gives 100 rows) OFFSET 100 (starts from row 100).
"""

-- Hive >> LIMIT offset limit
-- Impala, PostgreSQL >> LIMIT val OFFSET val
-- MySQL >> supports both above syntaxes

"""
Without ORDER BY, pagination will be arbitrary and could return rows from different pages.
Therefore, always use ORDER BY on a column that has unique values (e.g. PK, FK, IDs).
"""
















