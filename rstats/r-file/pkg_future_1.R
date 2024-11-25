library(future)
plan(multisession)
cat("global session id: ------\n")
print(Sys.getpid())

fff <- function() {
  t0 <- Sys.time()
  f1 <- future({
    Sys.sleep(10)
    cat("\nfuture session id in fff::f1 ------\n")
    print(Sys.getpid())
    cat("f1: Hello World!\n")
    "111"
  })

  print("f1 created")
  print(Sys.time() - t0)

  f2 <- future({
    Sys.sleep(10)
    cat("\nfuture session id in fff:f2 ------\n")
    print(Sys.getpid())
    cat("f2: Hello World!\n")
    "222"
  })

  cat("\nf1 and f2 futures created ------\n")
  print(Sys.time() - t0)

  # v1 and v2 are calculated in parallel so the total
  # time is 10 sec although each is 10 sec.

  v1 <- value(f1)
  print(v1)
  print(Sys.time() - t0)

  v2 <- value(f2)
  print(v2)
  print(Sys.time() - t0)

  cat("\nend of the test ------\n")

  return(list(f1 = v1, f2 = v2))
}

# finish in 10.3 secs instead of 20+
system.time({
  fff()
})

plan(sequential)
