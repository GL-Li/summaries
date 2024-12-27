mem_test <- function(N) {
  dt <- data.frame(
    x = 1:N,
    y = rnorm(N)
  )

  return(mean(dt$y))
}

N <- 5e8
print("run mem_test ----------")
avg <- mem_test(N)
print(avg)

N <- 1e5
df <- data.frame(
  x = 1:N,
  y = rnorm(N)
)


cat("\nsleep 1 --------")
Sys.sleep(20)
print("create df --------------")
N <- 5e8
df <- data.frame(
  x = 1:N,
  y = rnorm(N)
)
rm(df)

cat("\nsleep 2 ------------")
Sys.sleep(20)

print("run gc() -------------")
gc()



cat("\nsleep 3 -----------")
Sys.sleep(20)
