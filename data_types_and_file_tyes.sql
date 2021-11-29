------------------------
-- INTEGER DATA TYPES --
------------------------
-- TINYINT: -128 to 127
-- SMALLINT: -32,768 to 32,767
-- INT: -2,147,483,648 to 2,147,483,647 (approximately 2.1 billion)
-- BIGINT: -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807 (approximately 9.2 quintillion)

------------------------
-- DECIMAL DATA TYPES --
------------------------
-- DOUBLE has greater range and precison than FLOAT but requires more memory
-- use FLOAT unless you need range/precison
-- DECIMAL represents with fixed precision and scale
-- DECIMAL(p,s): p is total digits, s is digits after decimal point

-- DOUBLE uses 64 bits, FLOAT use 32 bits
-- DOUBLE accurate to 15/16 digits
-- FLOAT accurate to 7 digits

-- FLOAT range: -3.40282346638528860 * 10^38 to 3.40282346638528860 * 10^38
-- DOUBLE range: -1.79769313486231570 x 10^308 to 1.79769313486231570 x 10^308
-- DECIMAL(38,0) range: -10^38 + 1 to 10^38 - 1

----------------------------
-- CHARACTER STRING TYPES --
----------------------------
-- STRING: seq. of chars. with no specified length constraint
-- CHAR: fixed length chars., values longer are truncated, values shorter are padded
-- VARCHAR: variable fixed length, longer are truncated, shorter are not padded

-- The hard limit on the size of a STRING and the total size of a row is 2GB.
-- If a query tries to process or create a string larger than this limit, it will return an error to the user.
-- The limit is 1GB on STRING when writing to Parquet files.
-- Queries on strings with <= 32KB will work reliably and will not hit significant performance or memory problems (unless you have very complex queries, very many columns, and so on.)
-- Performance and memory consumption may degrade with strings larger than 32KB.

----------------------
-- OTHER DATA TYPES --
----------------------
-- BOOLEAN: True or false (true)
-- TIMESTAMP: Instant in time (2019-02-25 16:51:05)
-- DATE (Hive only): Date without time of day (2019-02-25)
-- BINARY (Hive only): Raw bytes (N/A)

-----------------------------------
-- CHOOSING THE RIGHT DATA TYPES --
-----------------------------------
-- Impala does not support DATE

--------------------------
-- EXAMINING DATA TYPES --
--------------------------
-- typeof() (Impala ONLY):
	SELECT typeof(colname) FROM tablename LIMIT 1;

-------------------------
-- OUT-OF-RANGE VALUES --
-------------------------
-- Both Hive and Impala return NULL for DECIMAL values that are out of range for the target data type
-- They also both return -Infinity or Infinity for FLOAT/DOUBLE types when too large, and zero when the value is close to zero but too small for the range

-- Hive returns NULL for out-of-range integer values
-- Impala returns the minimum or maximum value for the column’s specific integer data type
-- Impala allows you to distinguish between NULL and values out-of-range but Hive does not (as it's all NULL)
-- Therefore, you should choose a data type whose largest and smallest values do not occur in your data

----------------
-- TEXT FILES --
----------------
-- PROS: -- 
	-- human-readable file type that can be delimited in a number of ways

-- CONS: --
	-- if storing large data .txt is inefficient
	-- difficult to represent binary data (e.g. images)
	-- converting data requires SerDe which slows performance

-- SUMMARY -- 
	-- good interoperability but poor performance

----------------
-- AVRO FILES --
----------------
-- PROS: -- 
	-- suitable for long-term data storage
    -- 'self-describing' (embedded schema definition)
    -- can handle 'schema evolution' (can modify schema)

-- SUMMARY --
	-- good interoperabiliy and performance (generally good for big data)

-------------------
-- PARQUET FILES --
-------------------
-- PROS: -- 
	-- great for columnar data storage (efficient for one or few columns)
    -- row format means file organised sequentially but columnar organises by column first (quicker)
    -- advanced optimisation to store data more compactly and to speed up queries
    -- most efficient when data is loaded all at once in large batches
    -- Parquet takes advantage of repeated patterns in data to store more efficiently
    -- uses 'compression' (encodes to take less storage)

-- CONS: --
	-- compression means time needed to compress and decompress (read/write) files

-- SUMMARY --
	-- good interoperabiliy and performance (good for columnar data storage)

---------------
-- ORC FILES --
---------------
-- ORC = 'Optimized Record Columnar' (similar to Parquet)

-- PROS: -- 
	-- often used with Hive to take advantage of its features

-- SUMMARY --
	-- limited interoperabiliy and good performance (use with Hive if you need specific features

--------------------
-- SEQUENCE FILES --
--------------------
-- stores key-value pairs in binary container format

-- PROS: -- 
	-- created as alt. for .txt and store data more efficiently as they can story binary data

-- CONS: --
	-- largely supported but Java and not widely supported

-- SUMMARY --
	-- poor interoperability but good performance

-------------
-- RCFiles --
-------------
-- RC = 'Record Columnar'

-- CONS: --
	-- developed for Hive, limited use with Impala
    -- stores data as strings which is inefficient

-- SUMMARY --
	-- poor interoperability and performance

-- ORC is an improved version of RCFiles

-----------------------------------
-- CHOOSING THE RIGHT FILE TYPES --
-----------------------------------
-- Consider:
	-- Ingest pattern (data loaded small/large batches) (Parquet for columnar)
    -- Interoperability (what engines/frameworks needed) (.txt, Parquet)
    -- Data lifetime (temporary or permanent, schema evo) (Avro, Parquet)
	-- Data size and query performance (compressed will be better for larger data such as Parquet)

-------------------------------------------------
-- CREATING TABLES WITH AVRO AND PARQUET FILES --
-------------------------------------------------
-------------------
### APACHE AVRO ###
-------------------
-- use STORED AS AVRO:
	CREATE TABLE ...
    STORED AS AVRO;
-- use TBLPROPERTIES ('avro.schema.url'='/path/to/file.avsc') where file.avsc is JSON file which contains schema:
	CREATE TABLE ...
    STORED AS AVRO
    TBLPROPERTIES ('avro.schema.url'='/path/to/company_email.avsc');
-- use TBLPROPERTIES and specify the JSON string:
	CREATE TABLE company_email_avro
    STORED AS AVRO
    TBLPROPERTIES ('avro.schema.literal'=
     '{"type":"record",
         "name":"company_email_avro",
          "fields":[
                        {"name":"id","type":["null","int"]},
                        {"name":"name","type":["null","string"]},
                        {"name":"email","type":["null","string"]}
        ]}');

-- of JSON data is not availiable you can extract it from Avro data fil via avro-tools command-line utility:
	avro-tools getschema /path/to/avro_data_file.avro

----------------------
### APACHE PARQUET ###
----------------------
-- use STORED AS PARQUET:
	CREATE TABLE ...
    STORED AS PARQUET
-- use LIKE PARQUET (Impala ONLY) (files can be stored elsewhere):
	CREATE TABLE investors_parquet
	LIKE PARQUET '/user/hive/warehouse/investors_parquet/investors.parq'
    STORED AS PARQUET;

-- each column in new table will have a comment stating the SQL col type was inferred from Parquet file
-- new table format defaults to .txt, to change this include STORED AS PARQUET
-- if Parquet data file comes from existing Impala table, all TINYINT/SMALLINT converts to INT

























