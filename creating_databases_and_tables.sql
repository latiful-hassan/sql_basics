-----------------------------------
-- CREATING DATABASES AND TABLES --
-----------------------------------
###
HUE
###
-- when you create database, Hive/Impala creates the directory:
	/user/hive/warehouse/databasename.db

-- to create new database (can be done via Data Source Panel, left panel):
	databases -> click create new database -> name it -> submit
    verify creation with /user/hive/warehouse/databasename.db
-- to drop (delete) database check the box next to it and click 'Drop'

-- when you create table Hive/Impala creates directory:
	/user/hive/warehouse/tablename 
    OR if not in default db
    /user/hive/warehouse/databasename.db/tablename
    
-- to create empty table use Data Source Panel (left panel)
-- to create table to query data that already exists in HDFS use Data Source Panel

-- limitations of using Hue to create db/tables:
	Hue assumes data files have header rows
    
###
SQL
###  
-- CREATE DATABASE dbname
-- USE dbname
-- CREATE TABLE name (col1 type, ....)  -- creates table in active database
-- DROP TABLE name
-- CREATE TABLE default.test  -- puts table, test, into database, default

--------------------------------
-- THE CREATE TABLE STATEMENT --
--------------------------------
"""
When you execute a create table command, Hive or Impala adds the table to the metastore and creates 
a new subdirectory in the warehouse directory in HDFS to store the table data.
"""
-- CREATE TABLE creates a 'managed table' so when its dropped everything is deleted
-- to ONLY delete metadata and keep data use:
	CREATE EXTERNAL TABLE ...  -- 'externally managed table'

-- Hive can create a 'temporary' table which only exists for the session:#
	CREATE TEMPORARY TABLE ...  -- 'temporary table'
    
-- three optional clauses for CREATE TABLE:
	ROW FORMAT ...
    STORED AS ...
    LOCATION ...

-- ROW FORMAT allows you to specify how data is delimited in files:
	ROW FORMAT DELIMITED
		FIELDS TERMINATED BY character
        
-- STORED AS allows you to specify what file format you want new table to use:
	STORED AS filetype  -- e.g. TEXTFILE, PARQUET etc.
    
-- LOCATION allows you to create table whose data is stored in specified directory:
	LOCATION 'path/to/location'
    -- 'EXTERNAL' can be used with LOCATION to store outside warehouse, do not confused with EXTERNAL TABLE

-- creating db/table that exists will cause error, avoid this:
	"""
    This is useful if you have script and want subsequent runs to not cause errors.
    """
	CREATE DATABASE IF NOT EXISTS dbname
    CREATE TABLE IF NOT EXISTS name
    -- can be combined with EXTERNAL

-- if you need table with same structure as another:
	CREATE TABLE newtablename LIKE exisitingtablename
    -- will copy schema but not data

-- two tables can be created to query the same data if using different delimiters:
	CREATE EXTERNAL TABLE name(
		...
    )
	ROW FORMAT DELIMITED 
		FIELDS TERMINATED BY '>'
	STORED AS TEXTFILE
    LOCATION 'path/';
    
    CREATE EXTERNAL TABLE name(
		...
    )
	ROW FORMAT DELIMITED 
		FIELDS TERMINATED BY ','
	STORED AS TEXTFILE
    LOCATION 'path/';
    
    
--------------------------------------
-- ADVANCED CREATE TABLE TECHNIQUES --
--------------------------------------
-- TBLPROPERTIES clause adds extra parameters:
	CREATE TABLE ....
	TBLPROPERTIES('skip.header.line.count'='1');

###
# SerDe(s) (Serializing/Deserializing) allow Hive read/write data NOT in a strucutred tabular format. Serializing is
# the process for convering data to bytes so it can be stored, deserializing is the reverse process - decoding 
# when reading the stored file
###

-- SerDe is automatically set to default based on ROW FORMAT and STORED AS
-- default SerDe is 'LazySimpleSerDe' which uses 'lazy initialisation' (does not instantiate objects until needed)

-- OpenCSVSerde can process csv and it better than using ROW FORMAT as it can handle other chars in file:
	 CREATE EXTERNAL TABLE default.investors
            (name STRING, amount INT, share DECIMAL(4,3))
        ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde';

-- JsonSerDe:
	 CREATE TABLE subscribers
            (id INT, name STRING, city STRING, state STRING)
        ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe';

-- RegexSerDe:
	 CREATE TABLE calls (
            event_date STRING, event_time STRING,
            phone_num STRING, event_type STRING, details STRING)   
        ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
            WITH SERDEPROPERTIES ("input.regex" = 
                "([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) \"([^\"]*)\"");


------------------------------
-- MANAGING EXISTING TABLES --
------------------------------
-- DESCRIBE tabname;  -- shows schema
-- DESCRIBE FORMATTED; tabname  -- more details

-- SHOW CREATE TABLE another way to understand strucuture/properties of a table

-- DROP DATABASE IF EXISTS database_name;
-- DROP TABLE IF EXISTS table_name;
-- DROP DATABASE database_name CASCADE;  -- overrides error given when dropping db that contains tables

-- ALTER TABLE tabname ACTION params  -- alter schema after creating a table
-- ALTER TABLE old_tablename RENAME TO new_tablename;  -- renames table
-- ALTER TABLE old_database.tablename RENAME TO new_database.tablename;  -- moving table (metadata and direct. changes)
-- ALTER TABLE tablename CHANGE old_colname new_colname type;  -- change column names

-- HIVE ONLY: 
	ALTER TABLE employees CHANGE salary salary INT AFTER office_id;  -- change order to after column
	ALTER TABLE tablename CHANGE col_name col_name col_type FIRST;  -- change order to first column

-- ALTER TABLE tablename ADD COLUMNS (col1 TYPE1,col2 TYPE2,… );  -- add columns
-- ALTER TABLE tablename DROP COLUMN colname;  -- delete columns (IMPALA ONLY)
-- ALTER TABLE tablename REPLACE COLUMNS (col1 TYPE1,col2 TYPE2,… );  -- replaces all columns with new list
-- ALTER TABLE tablename SET TBLPROPERTIES('EXTERNAL'='TRUE');  -- change from managed to external table


--------------------------------------
-- HIVE AND IMPALA INTEROPERABILITY --
--------------------------------------
###
# Remember that Hive is typically slower than Impala, but Hive is more general than Impala in the types of file formats 
# it supports for tables. Impala is designed to be much faster and so it specializes in the use of the best file formats 
# for fast running queries, formats like Apache Parquet. When you're on the job, you will often find yourself using Hive
# and its wide variety of available SERDEs to read data in many different formats. Then Hive can put that data into new 
# tables in a format like Parquet for fast querying using Impala.
###

###
# Hive retrieves metadata from the metastore every time it builds a query, but Impala does not. Impala 
# caches metadata in memory to reduce query latency.
###

-- Impala metadata cache can get out of sync so need to refresh --
-- Table modified with new data:
	REFRESH tabname;  -- reloads metad. for one table and reloads storage block locs. for data files only
-- New table added:
	INVALIDATE METADATA tabname;  -- marks metad. for 1 table as 'stale', when metad. needed, storage block locs, are retrieved




























