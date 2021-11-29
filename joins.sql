------------------
-- JOIN SYNTAX --
------------------
-- general syntax:
	SELECT col1 ...
    FROM table1 JOIN table2
		ON table1.col = table2.col

-- shortcut:
	SELECT A.col, B.col ...
    FROM table1 A JOIN table2 B  -- 'AS' keyword is not needed in FROM clause for aliasing 
		ON table1.col = table2.col

-----------------
-- INNER JOINS --
-----------------
-- rows without a match are not returned in results (this is an INNER JOIN = JOIN)

-----------------
-- OUTER JOINS --
-----------------
-- unmatched rows can be returned with an OUTER JOIN (unlike INNER JOIN)

-- LEFT OUTER JOIN >> unmatched values in left table are returned
-- RIGHT OUTER JOIN >> unmatched values in right table are returned
-- FULL OUTER JOIN >> all unmatched values are returned
-- the LEFT/RIGHT OUTER JOINs can be equal to each other if you swap table order

----------------------------------
-- JOINING THREE OR MORE TABLES --
----------------------------------
-- the following is an example of joining three tables:
	SELECT 
		c.name AS customer_name,
 ​   ​   	o.total AS order_total,
 ​  ​    	e.first_name AS employee_name
	FROM 
		customers c JOIN orders o 
			ON c.cust_id = o.cust_id
​   	JOIN employees e 
			ON o.empl_id = e.empl_id;

-- joining multiple tables can be combined with LEFT/RIGHT to return desired unmatched rows

----------------------------------------------
-- HANDLING NULL VALUES IN JOIN KEY COLUMNS --
----------------------------------------------



























