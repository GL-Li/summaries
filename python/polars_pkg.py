# https://docs.pola.rs/user-guide/getting-started/#combination

import polars as pl
from datetime import datetime

""" ==========================================================
Create Polars data frame
- from a dictionary
- read from a csv file
"""

# from a dictionary
df = pl.DataFrame(
    {
        "integer": [1, 2, 3],
        "date": [
            datetime(2025, 1, 1),
            datetime(2025, 1, 2),
            datetime(2025, 1, 3),
        ],
        "float": [4.0, 5.0, 6.0],
        "string": ["a", "b", "c"],
    }
)

# read from a csv file
iris = pl.read_csv("iris.csv")

""" ============================================================
Expressions
- select
- filter
- with_columns
- group_by
"""

# select columns
df.select(pl.col("integer", "string"))
df.select(pl.all().exclude(["date", "float"]))

# filter rows
df.filter(pl.col("float").is_between(3.0, 5.9))
df.filter(pl.col("float").is_between(3.0, 5.9) & pl.col("string").is_in(["a", "c"]))

# add columns
df.with_columns(pl.col("integer").sum().alias("sum"))
df.with_columns(
    pl.col("integer").sum().alias("sum"), (pl.col("float") + 10).alias("add10")
)

# group_by
df2 = pl.DataFrame(
    {
        "x": range(8),
        "y": ["A", "A", "A", "B", "B", "C", "X", "X"],
    }
)
df2.group_by("y", maintain_order=True).len()


""" ===============================================================
Combining data frames
- join
    - df1.join(df2, on="id", how="left")
    - df1.join(df2, left_on="id1", right_on="id2", how="full")
- concat
    - df1.hstack(df2)
    - df1.vstack(df2)
    - use in_place=True to concat on df1 in place
"""

# join by shared id
df1 = pl.DataFrame(
    {
        "id": ["A", "B", "C"],
        "x": range(3),
    }
)
df2 = pl.DataFrame(
    {
        "id": ["A", "B"],
        "y": range(10, 12),
    }
)
df1.join(df2, on="id")  # keep only shared ids
df1.join(df2, on="id", how="left")  # keep all rows in df1

# join by different ids
df1 = pl.DataFrame(
    {
        "id1": ["A", "B", "C"],
        "x": range(3),
    }
)
df2 = pl.DataFrame(
    {
        "id2": ["A", "B"],
        "y": range(10, 12),
    }
)
df1.join(df2, left_on="id1", right_on="id2")  # use different ids

# hstack is cbind, same number of rows in df1 and df2
df1 = pl.DataFrame(
    {
        "id1": ["A", "C"],
        "x": range(2),
    }
)
df2 = pl.DataFrame(
    {
        "id2": ["A", "B"],
        "y": range(10, 12),
    }
)
df1.hstack(df2)

# vstack is rbind, same columns in df1 and df2
df1 = pl.DataFrame(
    {
        "id": ["A", "C"],
        "x": range(2),
    }
)
df2 = pl.DataFrame(
    {
        "id": ["A", "B"],
        "x": range(10, 12),
    }
)
df1.vstack(df2)


""" ============================================================
Operations on a single data frame
- df.sample(5): randomly select 5 rows
- df.describe(): show summary statistics
- df.sort(by=["x", "y"], descending=True): order by columns
- df.drop(["x", "y"]): delete columns
- df.cast({"x": pl.float32, "y": pl.string}): changes columns to specific types
"""

# sample on rows
df = pl.DataFrame(
    {
        "x": range(8),
        "y": ["A", "B", "C", "X", "A", "A", "B", "X"],
        "z": [14, 18, 19, 13, 18, 12, 13, 14],
    }
)
df.sample(3)
df.describe()
df.sort(by="y", descending=True)
df.sort(by=["y", "z"])
df.drop(["x", "z"])
df.cast({"x": pl.Float32, "z": pl.String})
df.melt()
