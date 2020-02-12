DROP DATABASE IF EXISTS MMA_TEST CASCADE;
CREATE DATABASE MMA_TEST;

-- ************************** This table is used to populate data *********************************
CREATE TABLE MMA_TEST.DUMMY(T_TINYINT TINYINT);
INSERT INTO TABLE MMA_TEST.DUMMY VALUES (1);

-- ************************** For storage format tests ********************************************
CREATE TABLE MMA_TEST.`TEST_TEXT` (
`T_TINYINT` TINYINT,
`T_SMALLINT` SMALLINT,
`T_INT` INT,
`T_BIGINT` BIGINT,
`T_FLOAT` FLOAT,
`T_DOUBLE` DOUBLE,
`T_DECIMAL` DECIMAL,
`T_TIMESTAMP` TIMESTAMP,
`T_STRING` STRING,
`T_VARCHAR` VARCHAR(255),
`T_CHAR` CHAR(255),
`T_BOOLEAN` BOOLEAN,
`T_BINARY` BINARY,
`T_ARRAY` ARRAY<STRING>,
`T_MAP` MAP<STRING, STRING>,
`T_STRUCT` STRUCT<c1 : STRING, c2 : BIGINT>)
STORED AS TEXTFILE;

CREATE TABLE MMA_TEST.`TEST_TEXT_PARTITIONED_100x10K` (
`T_TINYINT` TINYINT,
`T_SMALLINT` SMALLINT,
`T_INT` INT,
`T_BIGINT` BIGINT,
`T_FLOAT` FLOAT,
`T_DOUBLE` DOUBLE,
`T_DECIMAL` DECIMAL,
`T_TIMESTAMP` TIMESTAMP,
`T_STRING` STRING,
`T_VARCHAR` VARCHAR(255),
`T_CHAR` CHAR(255),
`T_BOOLEAN` BOOLEAN,
`T_BINARY` BINARY,
`T_ARRAY` ARRAY<STRING>,
`T_MAP` MAP<STRING, STRING>,
`T_STRUCT` STRUCT<c1 : STRING, c2 : BIGINT>)
PARTITIONED BY (
`P1` STRING,
`P2` BIGINT
)
STORED AS TEXTFILE;

CREATE TABLE MMA_TEST.`TEST_ORC`(
`T_TINYINT` TINYINT,
`T_SMALLINT` SMALLINT,
`T_INT` INT,
`T_BIGINT` BIGINT,
`T_FLOAT` FLOAT,
`T_DOUBLE` DOUBLE,
`T_DECIMAL` DECIMAL,
`T_TIMESTAMP` TIMESTAMP,
`T_STRING` STRING,
`T_VARCHAR` VARCHAR(255),
`T_CHAR` CHAR(255),
`T_BOOLEAN` BOOLEAN,
`T_BINARY` BINARY,
`T_ARRAY` ARRAY<STRING>,
`T_MAP` MAP<STRING, STRING>,
`T_STRUCT` STRUCT<c1 : STRING, c2 : BIGINT>)
STORED AS ORC;

CREATE TABLE MMA_TEST.`TEST_ORC_PARTITIONED_100x10K` (
`T_TINYINT` TINYINT,
`T_SMALLINT` SMALLINT,
`T_INT` INT,
`T_BIGINT` BIGINT,
`T_FLOAT` FLOAT,
`T_DOUBLE` DOUBLE,
`T_DECIMAL` DECIMAL,
`T_TIMESTAMP` TIMESTAMP,
`T_STRING` STRING,
`T_VARCHAR` VARCHAR(255),
`T_CHAR` CHAR(255),
`T_BOOLEAN` BOOLEAN,
`T_BINARY` BINARY,
`T_ARRAY` ARRAY<STRING>,
`T_MAP` MAP<STRING, STRING>,
`T_STRUCT` STRUCT<c1 : STRING, c2 : BIGINT>)
PARTITIONED BY (
`P1` STRING,
`P2` BIGINT
)
STORED AS ORC;

CREATE TABLE MMA_TEST.`TEST_PARQUET` (
`T_TINYINT` TINYINT,
`T_SMALLINT` SMALLINT,
`T_INT` INT,
`T_BIGINT` BIGINT,
`T_FLOAT` FLOAT,
`T_DOUBLE` DOUBLE,
`T_DECIMAL` DECIMAL,
`T_TIMESTAMP` TIMESTAMP,
`T_STRING` STRING,
`T_VARCHAR` VARCHAR(255),
`T_CHAR` CHAR(255),
`T_BOOLEAN` BOOLEAN,
`T_BINARY` BINARY,
`T_ARRAY` ARRAY<STRING>,
`T_MAP` MAP<STRING, STRING>,
`T_STRUCT` STRUCT<c1 : STRING, c2 : BIGINT>)
STORED AS PARQUET;

CREATE TABLE MMA_TEST.`TEST_PARQUET_PARTITIONED_100x10K` (
`T_TINYINT` TINYINT,
`T_SMALLINT` SMALLINT,
`T_INT` INT,
`T_BIGINT` BIGINT,
`T_FLOAT` FLOAT,
`T_DOUBLE` DOUBLE,
`T_DECIMAL` DECIMAL,
`T_TIMESTAMP` TIMESTAMP,
`T_STRING` STRING,
`T_VARCHAR` VARCHAR(255),
`T_CHAR` CHAR(255),
`T_BOOLEAN` BOOLEAN,
`T_BINARY` BINARY,
`T_ARRAY` ARRAY<STRING>,
`T_MAP` MAP<STRING, STRING>,
`T_STRUCT` STRUCT<c1 : STRING, c2 : BIGINT>)
PARTITIONED BY (
`P1` STRING,
`P2` BIGINT
)
STORED AS PARQUET;

CREATE TABLE MMA_TEST.`TEST_RCFILE` (
`T_TINYINT` TINYINT,
`T_SMALLINT` SMALLINT,
`T_INT` INT,
`T_BIGINT` BIGINT,
`T_FLOAT` FLOAT,
`T_DOUBLE` DOUBLE,
`T_DECIMAL` DECIMAL,
`T_TIMESTAMP` TIMESTAMP,
`T_STRING` STRING,
`T_VARCHAR` VARCHAR(255),
`T_CHAR` CHAR(255),
`T_BOOLEAN` BOOLEAN,
`T_BINARY` BINARY,
`T_ARRAY` ARRAY<STRING>,
`T_MAP` MAP<STRING, STRING>,
`T_STRUCT` STRUCT<c1 : STRING, c2 : BIGINT>)
STORED AS RCFILE;

CREATE TABLE MMA_TEST.`TEST_RCFILE_PARTITIONED_100x10K` (
`T_TINYINT` TINYINT,
`T_SMALLINT` SMALLINT,
`T_INT` INT,
`T_BIGINT` BIGINT,
`T_FLOAT` FLOAT,
`T_DOUBLE` DOUBLE,
`T_DECIMAL` DECIMAL,
`T_TIMESTAMP` TIMESTAMP,
`T_STRING` STRING,
`T_VARCHAR` VARCHAR(255),
`T_CHAR` CHAR(255),
`T_BOOLEAN` BOOLEAN,
`T_BINARY` BINARY,
`T_ARRAY` ARRAY<STRING>,
`T_MAP` MAP<STRING, STRING>,
`T_STRUCT` STRUCT<c1 : STRING, c2 : BIGINT>)
PARTITIONED BY (
`P1` STRING,
`P2` BIGINT
)
STORED AS RCFILE;

CREATE TABLE MMA_TEST.`TEST_SEQUENCEFILE` (
`T_TINYINT` TINYINT,
`T_SMALLINT` SMALLINT,
`T_INT` INT,
`T_BIGINT` BIGINT,
`T_FLOAT` FLOAT,
`T_DOUBLE` DOUBLE,
`T_DECIMAL` DECIMAL,
`T_TIMESTAMP` TIMESTAMP,
`T_STRING` STRING,
`T_VARCHAR` VARCHAR(255),
`T_CHAR` CHAR(255),
`T_BOOLEAN` BOOLEAN,
`T_BINARY` BINARY,
`T_ARRAY` ARRAY<STRING>,
`T_MAP` MAP<STRING, STRING>,
`T_STRUCT` STRUCT<c1 : STRING, c2 : BIGINT>)
STORED AS SEQUENCEFILE;

CREATE TABLE MMA_TEST.`TEST_SEQUENCEFILE_PARTITIONED_100x10K` (
`T_TINYINT` TINYINT,
`T_SMALLINT` SMALLINT,
`T_INT` INT,
`T_BIGINT` BIGINT,
`T_FLOAT` FLOAT,
`T_DOUBLE` DOUBLE,
`T_DECIMAL` DECIMAL,
`T_TIMESTAMP` TIMESTAMP,
`T_STRING` STRING,
`T_VARCHAR` VARCHAR(255),
`T_CHAR` CHAR(255),
`T_BOOLEAN` BOOLEAN,
`T_BINARY` BINARY,
`T_ARRAY` ARRAY<STRING>,
`T_MAP` MAP<STRING, STRING>,
`T_STRUCT` STRUCT<c1 : STRING, c2 : BIGINT>)
PARTITIONED BY (
`P1` STRING,
`P2` BIGINT
)
STORED AS SEQUENCEFILE;

-- ************************** For general function tests ******************************************
CREATE TABLE MMA_TEST.TEST_NON_PARTITIONED_1M (
`T_TINYINT` TINYINT,
`T_SMALLINT` SMALLINT,
`T_INT` INT,
`T_BIGINT` BIGINT,
`T_FLOAT` FLOAT,
`T_DOUBLE` DOUBLE,
`T_DECIMAL` DECIMAL,
`T_TIMESTAMP` TIMESTAMP,
`T_STRING` STRING,
`T_VARCHAR` VARCHAR(255),
`T_CHAR` CHAR(255),
`T_BOOLEAN` BOOLEAN,
`T_BINARY` BINARY,
`T_ARRAY` ARRAY<STRING>,
`T_MAP` MAP<STRING, STRING>,
`T_STRUCT` STRUCT<c1 : STRING, c2 : BIGINT>)
STORED AS TEXTFILE;

CREATE TABLE MMA_TEST.TEST_PARTITIONED_100x10K (
`T_TINYINT` TINYINT,
`T_SMALLINT` SMALLINT,
`T_INT` INT,
`T_BIGINT` BIGINT,
`T_FLOAT` FLOAT,
`T_DOUBLE` DOUBLE,
`T_DECIMAL` DECIMAL,
`T_TIMESTAMP` TIMESTAMP,
`T_STRING` STRING,
`T_VARCHAR` VARCHAR(255),
`T_CHAR` CHAR(255),
`T_BOOLEAN` BOOLEAN,
`T_BINARY` BINARY,
`T_ARRAY` ARRAY<STRING>,
`T_MAP` MAP<STRING, STRING>,
`T_STRUCT` STRUCT<c1 : STRING, c2 : BIGINT>)
 PARTITIONED BY (
`P1` STRING,
`P2` BIGINT
)
STORED AS TEXTFILE;

-- ************************** Some extreme cases **************************************************
-- CREATE TABLE MMA_TEST.TEST_PARTITIONED_1K_SMALL(T_TINYINT TINYINT, T_SMALLINT SMALLINT, T_INT INT, T_BIGINT BIGINT, T_FLOAT FLOAT, T_DOUBLE DOUBLE, T_DECIMAL DECIMAL, T_TIMESTAMP TIMESTAMP,  T_STRING STRING, T_VARCHAR VARCHAR(255), T_CHAR CHAR(255), T_BOOLEAN BOOLEAN, T_BINARY BINARY, T_ARRAY ARRAY<STRING>, T_MAP MAP<STRING, STRING>, T_STRUCT STRUCT<c1 : STRING, c2 : BIGINT>) STORED AS TEXTFILE;
-- CREATE TABLE MMA_TEST.TEST_PARTITIONED_1K_LARGE(T_TINYINT TINYINT, T_SMALLINT SMALLINT, T_INT INT, T_BIGINT BIGINT, T_FLOAT FLOAT, T_DOUBLE DOUBLE, T_DECIMAL DECIMAL, T_TIMESTAMP TIMESTAMP,  T_STRING STRING, T_VARCHAR VARCHAR(255), T_CHAR CHAR(255), T_BOOLEAN BOOLEAN, T_BINARY BINARY, T_ARRAY ARRAY<STRING>, T_MAP MAP<STRING, STRING>, T_STRUCT STRUCT<c1 : STRING, c2 : BIGINT>) STORED AS TEXTFILE;
-- CREATE TABLE MMA_TEST.TEST_PARTITIONED_10K_SMALL(T_TINYINT TINYINT, T_SMALLINT SMALLINT, T_INT INT, T_BIGINT BIGINT, T_FLOAT FLOAT, T_DOUBLE DOUBLE, T_DECIMAL DECIMAL, T_TIMESTAMP TIMESTAMP,  T_STRING STRING, T_VARCHAR VARCHAR(255), T_CHAR CHAR(255), T_BOOLEAN BOOLEAN, T_BINARY BINARY, T_ARRAY ARRAY<STRING>, T_MAP MAP<STRING, STRING>, T_STRUCT STRUCT<c1 : STRING, c2 : BIGINT>) STORED AS TEXTFILE;
-- CREATE TABLE MMA_TEST.TEST_PARTITIONED_10K_LARGE(T_TINYINT TINYINT, T_SMALLINT SMALLINT, T_INT INT, T_BIGINT BIGINT, T_FLOAT FLOAT, T_DOUBLE DOUBLE, T_DECIMAL DECIMAL, T_TIMESTAMP TIMESTAMP,  T_STRING STRING, T_VARCHAR VARCHAR(255), T_CHAR CHAR(255), T_BOOLEAN BOOLEAN, T_BINARY BINARY, T_ARRAY ARRAY<STRING>, T_MAP MAP<STRING, STRING>, T_STRUCT STRUCT<c1 : STRING, c2 : BIGINT>) STORED AS TEXTFILE;


-- ************************** Test invalid keyword ************************************************
CREATE TABLE MMA_TEST.INVALID_KEY_WORD_1 (
`_id` STRING,
`start` STRING, -- since hive 2.0.0
`end` STRING, -- since hive 1.2.0
`primary` STRING, -- since hive 2.1.0
`INTEGER` STRING, -- since hive 2.2.0
`TIME` STRING -- since hive 3.0.0
);

-- ************************** Test hive default partition *****************************************
CREATE TABLE MMA_TEST.TEST_HIVE_DEFAULT_PARTITION_1M (
`T_TINYINT` TINYINT,
`T_SMALLINT` SMALLINT,
`T_INT` INT,
`T_BIGINT` BIGINT,
`T_FLOAT` FLOAT,
`T_DOUBLE` DOUBLE,
`T_DECIMAL` DECIMAL,
`T_TIMESTAMP` TIMESTAMP,
`T_STRING` STRING,
`T_VARCHAR` VARCHAR(255),
`T_CHAR` CHAR(255),
`T_BOOLEAN` BOOLEAN,
`T_BINARY` BINARY,
`T_ARRAY` ARRAY<STRING>,
`T_MAP` MAP<STRING, STRING>,
`T_STRUCT` STRUCT<c1 : STRING, c2 : BIGINT>)
STORED AS TEXTFILE;

-- TODO: test oss