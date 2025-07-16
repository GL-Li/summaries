## Use sqlite3 from terminal

```sh
# start a database sqlite3.db and start sqlite console
sqlite3 sqlites_sample.db

# to quit
sqlite> .quit

# display data in table
sqlite> .mode table

# list table names
sqlite> .tables

# list column names of a table
sqlite> PRAGMA table_info(users)

# show schema
sqlite> .schema

# display a table
sqlite> SELECT * FROM todos LIMIT 3;
```
