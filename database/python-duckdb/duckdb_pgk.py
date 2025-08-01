"""
https://duckdb.org/docs/stable/clients/python/overview.html

Installation 
- $ uv add duckdb

In-memory database
- use con.execute(sql_command) for database related work such as
    - con.execute("DESC table_xxx")
    - con.execute("SHOW TABLES")
- schema best practice for tables from data frames
    - make sure the type is correct in data frame
    - automatically create schema
"""

import duckdb
import pandas as pd
import polars as pl  # uv add "polars[pyarrow]"

# Basic API Usage
# ================================================================================
# - understand what is relation
# - use relation as table

# duckdb.sql(...) returns a relation representing the query. It is not executed
# until the result is requested.

# a relation
duckdb.sql("SELECT 42")

# the relation is executed
duckdb.sql("SELECT 42").show()

# a relation can be used as a table
r1 = duckdb.sql("SELECT 42 AS i")
duckdb.sql("SELECT i * 2 AS k FROM r1")


# Data Input 
# ================================================================================

# from files like csv and json --------------------

# read a csv file into a relation
mpg = duckdb.read_csv("mpg.csv")

# query from the relation table
duckdb.sql("SELECT model, hwy FROM mpg WHERE hwy > 30")

# use Pandas data frame --------------------

pandas_df = pd.read_csv("mpg.csv")
duckdb.sql("SELECT model, hwy FROM pandas_df WHERE hwy > 30")

# use Polars data frame --------------------

polars_df = pl.read_csv("mpg.csv")
duckdb.sql("SELECT model, hwy FROM polars_df WHERE hwy > 30")


# Result conversion
# ================================================================================

# start from a relation
mpg = duckdb.read_csv("mpg.csv")
selected = duckdb.sql("SELECT model, hwy FROM mpg WHERE hwy > 30")

# convert to a python object
selected.fetchall()  # a list of tuple

# pandas data frame
selected.df()

# polars data frame
selected.pl()


# Connection options
# ================================================================================

# Use in-memory database --------------------
# - can add multiple table to the database from pandas or polars data frames

# create a in-memory database
con = duckdb.connect(database=':memory:')  # it is the default duckdb.connect()

# add plolars_df to the database and rename it to table table_pl
polars_df = pl.read_csv("mpg.csv")
con.register("table_pl", polars_df)
# run query on table_pl
con.execute("SELECT model, hwy FROM table_pl WHERE hwy > 30").pl()

# add another table to the database
pandas_df = pd.read_csv("mpg.csv")
con.register("table_pd", pandas_df)
con.execute("SELECT model, hwy FROM table_pd WHERE hwy > 30").pl()


# Schema Construction for DataFrames
# ================================================================================

# 1. Automatic Schema Inference (default)
# DuckDB automatically infers schema from DataFrame structure
auto_df = pd.DataFrame({
    'id': [1, 2, 3],
    'name': ['Alice', 'Bob', 'Charlie'],
    'score': [95.5, 87.3, 91.2],
    'is_active': [True, False, True]
})
con.register("auto_table", auto_df)
print("Automatic schema:")
print(con.execute("DESCRIBE auto_table").fetchall())

# 2. Manual Schema Specification
# First create table with explicit schema, then insert data
con.execute("""
    CREATE TABLE manual_table (
        id VARCHAR,
        name VARCHAR,
        score DOUBLE,
        is_active BOOLEAN
    )
""")

# Insert data into the manually created table
manual_df = pd.DataFrame({
    'id': ["1", "2", "3"],  # match schema, otherwise the schema is ignored
    'name': ['Alice', 'Bob', 'Charlie'],
    'score': [95.5, 87.3, 91.2],
    'is_active': [True, False, True]
})
con.register("manual_table", manual_df)
print("\nManual schema:")
print(con.execute("DESCRIBE manual_table").fetchall())

# Listing Tables in In-Memory Database
# ================================================================================
print("\nAll tables in database:")
print(con.execute("SHOW TABLES").fetchall())
