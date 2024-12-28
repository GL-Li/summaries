library(dplyr)

N <- 1e8

tb <- tibble(
  x = 1:N,
  y1 = rnorm(N),
  y2 = rnorm(N),
  y3 = rnorm(N),
  y4 = rnorm(N),
  y5 = rnorm(N),
  y6 = rnorm(N),
  y7 = rnorm(N),
  y8 = rnorm(N)
)

gc()

Y1 = rnorm(N)
Y2 = rnorm(N)
Y3 = rnorm(N)
Y4 = rnorm(N)
Y5 = rnorm(N)
Y6 = rnorm(N)
Y7 = rnorm(N)
Y8 = rnorm(N)

print("sleeping ------")
Sys.sleep(10)

print("update ---------")
tb <- tb |>
  mutate(y1 = Y1) |>
  mutate(y2 = Y2) |>
  mutate(y3 = Y3) |>
  mutate(y4 = Y4) |>
  mutate(y5 = Y5) |>
  mutate(y6 = Y6) |>
  mutate(y7 = Y7) |>
  mutate(y8 = Y8)


print("sleeping ------")
Sys.sleep(10)
