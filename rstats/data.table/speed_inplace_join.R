# compare the speed using different methods to replace values as follows
#
# original data frame:
#  id      col1      col2      col3     ...    col50
#  ee+1    c+-,.J    g+-,.D    a+-,.A   ...    d+-,.E
#  ee+2    c+-,.J    a+-,.J    a+-,.E   ...    b+-,.H
#  ee+3    j+-,.G    g+-,.J    j+-,.E   ...    g+-,.I
#  ee+4    b+-,.C    g+-,.J    h+-,.I   ...    i+-,.H
#  ee+5    f+-,.A    g+-,.J    e+-,.B   ...    j+-,.F
#
# converted into
#  id      col1      col2      col3     ...    col50
#  id_1    col1_1    col2_1    col3_1   ...    col50_1
#  id_2    col1_1    col2_2    col3_2   ...    col50_2
#  id_3    col1_2    col2_3    col3_3   ...    col50_3
#  id_4    col1_3    col2_3    col3_4   ...    col50_4
#  id_5    col1_4    col2_3    col3_5   ...    col50_5
#
# Results:
# the inplace data.table join can be 10 times faster, depending on the data size.
# the large the faster compared to other memory-copy methods.



library(dplyr)
library(data.table)
if (!require(rbenchmark)) {
  install.packages("rbenchmark")
}
library(rbenchmark)
options(dplyr.summarise.inform = FALSE)

N <- 1e4
df <- data.frame(id = paste0("ee+", 1:N))
set.seed(123)
for (col in paste0("col", 1:50)) {
  df[[col]] <- paste0(sample(letters[1:10], N, replace = TRUE),
                      "+-,.",
                      sample(LETTERS[1:10], N, replace = TRUE))
}

df_replacement <- list()
for (col in names(df)) {
  uniq_values <- unique(df[[col]])
  new_values <- paste0(col, "_", seq_len(length(uniq_values)))
  df_replacement[[col]] <- data.frame(old = uniq_values, new = new_values)
}


# replace with data.table inplace join
dt <- as.data.table(df)
dt_replacement <- list()
for (col in names(df_replacement)) {
  tmp <- as.data.table(df_replacement[[col]])
  dt_replacement[[col]] <- tmp
}

dt_inplace <- function(dt, dt_replacement) {
  for (col in names(dt_replacement)) {
    map <- dt_replacement[[col]] |>
      copy() |>
      setnames("old", col)
    dt[map, on = col, (col) := i.new]
  }
  return(NULL)
}


# replace with data.table merge
dt1 <- as.data.table(df)
dt1_replacement <- list()
for (col in names(df_replacement)) {
  tmp <- as.data.table(df_replacement[[col]])
  dt1_replacement[[col]] <- tmp
}

dt_merge <- function(dt1, dt1_replacement) {
  original_names <- names(dt1)
  for (col in names(dt1_replacement)) {
    map <- dt1_replacement[[col]] |>
      copy() |>
      setnames("old", col)
    dt1 <- dt1 |>
      merge(map, by = col, all.x = TRUE, sort = FALSE) |>
      _[, (col) := new]
    dt1$new <- NULL
  }
  return(dt1[, original_names, with = FALSE])
}



# replace with data.table join
dt2 <- as.data.table(df)
dt2_replacement <- list()
for (col in names(df_replacement)) {
  tmp <- as.data.table(df_replacement[[col]])
  dt2_replacement[[col]] <- tmp
}

dt_join <- function(dt2, dt2_replacement) {
  original_names <- names(dt2)
  for (col in names(dt2_replacement)) {
    map <- dt2_replacement[[col]] |>
      copy() |>
      setnames("old", col)
    dt2 <- map[dt2, on = col] |>
      _[, (col) := new]
    dt2$new <- NULL
  }
  return(dt2[, original_names, with = FALSE])
}


# replace with dplyr join
tb <- as_tibble(df)
tb_replacement <- list()
for (col in names(df_replacement)) {
  tmp <- as_tibble(df_replacement[[col]])
  tb_replacement[[col]] <- tmp
}

dplyr_join <- function(tb, tb_replacement) {
  for (col in names(tb_replacement)) {
    map <- tb_replacement[[col]] |>
      rename(!!col := old)
    tb <- tb |>
      left_join(map, by = col) |>
      mutate(!!col := new)
    tb$new <- NULL
  }
  return(tb)
}


# validation: all method have the same output
if (interactive()) {
  dt_inplace(dt, dt_replacement)
  dt_1 <- dt_merge(dt1, dt1_replacement)
  all.equal(dt, dt_1)
  dt_2 <- dt_join(dt2, dt2_replacement)
  all.equal(dt, dt_2)

  tb_new <- dplyr_join(tb, tb_replacement)
  all.equal(dt, tb_new, check.attributes = FALSE)
}

# benchmarking.
print("benchmarking -----------")
res <- benchmark(
  dt_inplace(dt, dt_replacement),
  dt_1 <- dt_merge(dt1, dt1_replacement),
  tb_new <- dplyr_join(tb, tb_replacement),
  dt_2 <- dt_join(dt2, dt2_replacement),
  replications = 10,
  order = "relative"
)
print(res)
