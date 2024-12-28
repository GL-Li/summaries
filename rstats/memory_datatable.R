library(data.table)

N <- 1e8

dt <- data.table(
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

gc()
print("sleeping ------")
Sys.sleep(5)

print("update ---------")
dt[, y1 := Y1]
gc()
print("sleeping ------")
Sys.sleep(5)

dt[, y2 := Y2]
gc()
print("sleeping ------")
Sys.sleep(5)

dt[, y3 := Y3]
gc()
print("sleeping ------")
Sys.sleep(5)

dt[, y4 := Y4]
gc()
print("sleeping ------")
Sys.sleep(5)

dt[, y5 := Y5]
gc()
print("sleeping ------")
Sys.sleep(5)

dt[, y6 := Y6]
gc()
print("sleeping ------")
Sys.sleep(5)

dt[, y7 := Y7]
gc()
print("sleeping ------")
Sys.sleep(5)

dt[, y8 := Y8]
gc()


print("sleeping ------")
Sys.sleep(5)
