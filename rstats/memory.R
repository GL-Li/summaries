#library(pryr)

mem_test <- function() {
  dt <- data.frame(
    x = 1:N,
    y = rnorm(N)
  )

  print(pryr::mem_used())
  
  return(mean(dt$y))
}

N <- 1.5e9
# for (i in 1:20) {
#   print(i)
#   avg <- mem_test()
#   print(avg)
#   print(pryr::mem_used())
# }

N <- 1.5e8
for (i in 1:10) {
  print(i)
  dt <- data.frame(
    x = 1:N,
    y = rnorm(N)
  )
  avg <- mean(dt$y)

  print(pryr::mem_used())
  #rm(dt)
  #gc()
  print(pryr::mem_used())
}
