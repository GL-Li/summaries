library(dplyr)
library(data.table)
if (!require(rbenchmark)) {
  install.packages("rbenchmark")
}
library(rbenchmark)
options(dplyr.summarise.inform = FALSE) 

n <- 1e5
df <- tibble(
  id = 1:n,
  pag = sample(paste0("pag_", 1:100), n, replace = TRUE),
  jobTitle = sample(paste0("job_", 1:100), n, replace = TRUE),
  num1 = rnorm(n),
  num2 = rnorm(n, mean = 10, sd = 2),
  num3 = rnorm(n, mean = 100, sd = 10)
)

dplyr_bench <- function(dataset) {
  res <- dataset %>%
    group_by(pag, jobTitle) %>%
    summarise(
      avg_num1 = mean(num1),
      avg_num2 = mean(num2),
      avg_num3 = mean(num3)
    )

  return(res)
}


# data.table
datatable_bench <- function(dt) {
  res <- dt[
    ,
    list( avg_num1 = mean(num1),
          avg_num2 = mean(num2),
          avg_num3 = mean(num3)),
    by = c("pag", "jobTitle")
  ] 

  return(res)
}

tb <- as_tibble(df)
dt <- as.data.table(df)


if (interactive()) {
  cat("\nMake sure dplyr and data.table have the same output ------------")
  res_dplyr <- dplyr_bench(tb) |> 
    as.data.frame()
  res_datatable <- datatable_bench(dt) |>
    _[order(pag, jobTitle)] |>
    as.data.frame()
  
  all.equal(res_dplyr, res_datatable)
}


cat("\n\nbenchmarking 1 ----------------\n")
bench_res_1 <- benchmark(
  dplyr_bench(tb),
  datatable_bench(dt)
)
print(bench_res_1)

cat("\n\nbenchmarking 2 ----------------\n")
bench_res_2 <- benchmark(
  dplyr_bench(tb),
  datatable_bench(dt) |>
    _[order(pag, jobTitle)]
)
print(bench_res_2)
