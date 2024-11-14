# How t odebug an error at the stage of its happening
# - step 1: set option to recover error:
#   options(error = recover) # nolint
# - step 2: run the code, which creates a global environment.
#   - error happens when running fff(dt)
#   - select from the list which function to debug.
# - step 3: debug a function
#   - Browse[1]> ls() to view all variables in the function scope.
#     These variables are frozen at the time when error occurred.
#   - check names(dat) for column ss. The bug is the missing ss column
#   - Q to quit brower
# - step 4: to repeat the debugging if necessary
#   - above process does not polute golbal environment, so to create the
#     same bug,
#   - simply run fff(dt) again to generate the list of selection
#   - select the same or another function to debug.
#
# How to debug a function line-by-line from beginning till error happens
# - debug(fff): set for debugging function fff
# - run fff(dat) to start the debugging
#
# How to debug a function that has no runtime error line-by-line
# - run trace(ggg, edit = TRUE) to temporarily edit the function
# - add line broweser() to the function

library(data.table)

ggg <- function() {
  mpg <- rnorm(3)
  wt <- c(4, 3, 8)
  cyl <- 5:7
  dt <- data.table(
    mpg = mpg,
    wt = wt,
    cyl = cyl
  )
  return(dt)
}

# aaa -------
fff <- function() {
  a <- 0
  for (i in 1:6) {
    s <- 3
    a <- a + s
    b <- a^2
    print(b)

    dat <- ggg()

    if (i == 3) {
      # error  ss not exist
      lm(mpg ~ wt + ss + cyl, data = dat)
    }
  }
  return(x)
}

fff()


## bbb =====