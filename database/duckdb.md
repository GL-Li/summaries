## Install duckdb command line tool
https://duckdb.org/docs/installation/?version=stable&environment=cli&platform=macos&download_method=direct

```sh
# installation
curl https://install.duckdb.org | sh

# start duckdb
# duckdb console starts with D
duckdb duckb_sample.duckdb

# list tables
D SHOW tables;
D SHOW ALL tables;
D .tables

# table details
D DESCRIBE orders;
D .schema

# display tables
D SELECT * FROM orders LIMIT 5;

# view all constraints
SELECT * FROM duckdb_constrains();

# view comments on tables
SELECT table_name, comment FROM duckdb_tables() WHERE schema_name = 'main' AND comment IS NOT NULL;

# view comments on columns
SELECT table_name, column_name, comment FROM duckdb_columns() WHERE schema_name = 'main' AND comment IS NOT NULL;

# more standard SQL approach for information on tables and columns
SELECT * FROM Information_schema.tables;
SELECT * FROM Information_schema.columns;
 ```

