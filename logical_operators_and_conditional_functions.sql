----------------------------------------------
-- IF, NULL, COALESCE AND LOGICAL OPERATORS -- 
----------------------------------------------

<=> is equal to 'IS NOT DISTINCT FROM'

NULL != non-NULL 				-> NULL
NULL IS DISTINCT FROM non-NULL 	-> True
NULL != NULL 					-> NULL
NULL IS DISTINCT FROM NULL 		-> False

True AND NULL 	-> NULL
False AND NULL 	-> False
NULL AND NULL 	-> NULL

True OR NULL 	-> True
False OR NULL 	-> NULL
NULL OR NULL 	-> NULL

NOT NULL -> NULL

---------------------------
-- CONDITIONAL FUNCTIONS -- 
---------------------------

if(cond_expression, result, else_result)

CASE
    WHEN cond1 THEN result1
    WHEN cond2 THEN result2
    WHEN condN THEN resultN
    ELSE result
END;
    
ifnull(x,y)  -- if x is null, replace with y
nullif(x,y)  -- makes x NULL if it is equal to the value y
COALESCE(x,y)  -- gives y if x is null 
