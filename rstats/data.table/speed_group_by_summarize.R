library(dplyr)
library(data.table)
if (!require(rbenchmark)) {
  install.packages("rbenchmark")
}
library(rbenchmark)
options(dplyr.summarise.inform = FALSE)

n <- 1e5
df <- data.frame(
  id = 1:n,
  pag = sample(paste0("pag_", 1:100), n, replace = TRUE),
  jobTitle = sample(paste0("job_", 1:100), n, replace = TRUE),
  num1 = rnorm(n),
  num2 = rnorm(n, mean = 10, sd = 2),
  num3 = rnorm(n, mean = 100, sd = 10)
)

tb <- as_tibble(df)
dt <- as.data.table(df)


dplyr_bench <- function(tb) {
  res <- tb %>%
    group_by(pag, jobTitle) %>%
    summarise(n = n(),
              avg_num1 = mean(num1),
              avg_num2 = mean(num2),
              avg_num3 = mean(num3))

  return(res)
}


# data.table
datatable_bench <- function(dt) {
  res <- dt[
    ,
    list(n = .N,
         avg_num1 = mean(num1),
         avg_num2 = mean(num2),
         avg_num3 = mean(num3)),
    by = c("pag", "jobTitle")
  ]

  return(res)
}


if (interactive()) {
  cat("\nMake sure dplyr and data.table have the same output ------------\n")
  res_dplyr <- dplyr_bench(tb)
  res_datatable <- datatable_bench(dt) |>
    _[order(pag, jobTitle)]

  all.equal(res_dplyr, res_datatable, check.attributes = FALSE)
}


cat("\n\nbenchmarking 1 ----------------\n")
bench_res_1 <- benchmark(
  dplyr_bench(tb),
  datatable_bench(dt),
  replications = 10
)
print(bench_res_1)

cat("\n\nbenchmarking 2 ----------------\n")
bench_res_2 <- benchmark(
  dplyr_bench(tb),
  datatable_bench(dt) |>
    _[order(pag, jobTitle)],
  replications = 10
)
print(bench_res_2)
