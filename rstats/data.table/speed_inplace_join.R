library(dplyr)
library(data.table)
if (!require(rbenchmark)) {
  install.packages("rbenchmark")
}
library(rbenchmark)
options(dplyr.summarise.inform = FALSE) 

N <- 1e5
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
  for (col in names(dt1_replacement)) {
    map <- dt1_replacement[[col]] |> 
      copy() |>
      setnames("old", col)
    dt1 <- dt1 |>
      merge(map, by = col, all.x = TRUE, sort = FALSE) |>
      _[, (col) := new]
    dt1$new <- NULL
  }
  return(dt)
}


# replace with dplry
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


# validation
if (interactive()) {
  dt_inplace(dt, dt_replacement)
  dt_new <- dt_merge(dt1, dt1_replacement)
  all.equal(dt, dt_new)
  
  tb_new <- dplyr_join(tb, tb_replacement)
  all.equal(as.data.frame(dt), as.data.frame(tb_new))
}

print("benchmarking -----------")
benchmark(
  dt_inplace(dt, dt_replacement),
  dt_new <- dt_merge(dt1, dt1_replacement),
  tb_new <- dplyr_join(tb, tb_replacement),
  replications = 10
)

