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
 ```

