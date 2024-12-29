library(dplyr)
library(data.table)
if (!require(rbenchmark)) {
  install.packages("rbenchmark")
}
library(rbenchmark)

n <- 1e5
df <- tibble(
  id = 1:n,
  pag = sample(paste0("pag_", 1:100), n, replace = TRUE),
  jobTitle = sample(paste0("job_", 1:100), n, replace = TRUE),
  num1 = rnorm(n),
  num2 = rnorm(n, mean = 10, sd = 2),
  num3 = rnorm(n, mean = 100, sd = 10)
)

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

tb <- as_tibble(df)
dt <- as.data.table(df)


if (interactive()) {
  cat("\nMake sure dplyr and data.table have the same output ------------")
  res_dplyr <- dplyr_bench(tb) |> 
    as.data.frame()
  res_datatable <- datatable_bench(dt) |>
    as.data.frame()
  
  all.equal(res_dplyr, res_datatable)
}


cat("\n\nbenchmarking 1 ----------------\n")
bench_res_1 <- benchmark(
  dplyr_bench(tb),
  datatable_bench(dt)
)
print(bench_res_1)