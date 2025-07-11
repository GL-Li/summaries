# make connection and create new duckdb if not exists
con <- DBI::dbConnect(duckdb::duckdb(), dbdir = "tmp.duckdb", read_only = FALSE)

# make up data tables
dt1 <- data.table::data.table(
  id = 1:5,
  name = c("Alice", "Bob", "Charlie", "David", "Eve"),
  value = rnorm(5)
)
dt2 <- data.table::data.table(
  product_id = 101:103,
  product_name = c("Laptop", "Mouse", "Keyboard"),
  price = c(1200.00, 25.50, 75.99)
)

# write to a new table or replace an existing table
DBI::dbWriteTable(
  conn = con,
  name = "table_1",
  value = dt1,
  overwrite = TRUE
)

# write a new table or append to an existing table (much have same columns)
DBI::dbWriteTable(
  conn = con,
  name = "table_2",
  value = dt2,
  append = TRUE
)

# verify tables
DBI::dbListTables(con)
DBI::dbGetQuery(con, "SELECT * FROM table_1")
DBI::dbGetQuery(con, "SELECT * FROM table_2")

# disconnect
DBI::dbDisconnect(con)
