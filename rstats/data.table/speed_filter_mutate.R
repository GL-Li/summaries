library(dplyr)
library(data.table)
if (!require(rbenchmark)) {
  install.packages("rbenchmark")
}
library(rbenchmark)

n <- 1e5
df <- data.table(
  id = 1:n,
  pag = sample(paste0("pag_", 1:100), n, replace = TRUE),
  num1 = rnorm(n)
)

tb <- as_tibble(df)
dt <- as.data.table(df)


dplyr_bench <- function(tb) {
  res <- tb |>
    mutate(pag = if_else(num1 > 1, "Other", pag))

  return(res)
}


# data.table
datatable_bench <- function(dt) {
  res <- dt[num1 > 1, pag := "Other" ]

  return(res)
}

if (interactive()) {
  cat("\nMake sure dplyr and data.table have the same output ------------\n")
  res_dplyr <- dplyr_bench(tb)
  res_datatable <- datatable_bench(dt)

  base::all.equal(res_dplyr, res_datatable, check.attributes = FALSE)
}


cat("\n\nbenchmarking 1 ----------------\n")
bench_res_1 <- benchmark(
  dplyr_bench(tb),
  datatable_bench(dt)
)
print(bench_res_1)
