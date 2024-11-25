# To test memory usage in future sessions

library(future)
options(future.globals.maxSize = 5e9)
plan(multisession)
print(Sys.getpid())

# generate a large global object
x <- rnorm(5e8)

Sys.sleep(10)
print("x created")

fff <- function() {
  f1 <- future({
    # this future session need this large object
    # x is exported to this session
    xxx <- length(x)
    print(xxx)
    Sys.sleep(10)
    print(Sys.getpid())
    cat("f1: Hello World!\n")
    "111"
  })

  print("f1 created")

  f2 <- future({
    # this future session does not need this large object
    Sys.sleep(10)
    print(Sys.getpid())
    cat("f2: Hello World!\n")
    "222"
  })

  print("f1 and f2 futures created ------")
  v1 <- value(f1)
  print(v1)
  v2 <- value(f2)
  print(v2)

  print("end of the test")

  return(list(f1 = v1, f2 = v2))
}

system.time({
  f <- fff()
})

plan(sequential)
