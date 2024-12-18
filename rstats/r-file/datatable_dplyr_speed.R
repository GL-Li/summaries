library(data.table)
library(dplyr)
library(stringi)

N <- 1e6
ss <- c("aa", "bb", "cc", "dd", "ee", "ff")

set.seed(111)
dtt <- data.table(
  id = 1:N,
  x = "aaa",
  y = rnorm(N),
  aa = paste0(sample(ss), rnorm(N)),
  # the following columns just to make a bigger data frame
  bb = paste0(sample(ss, 1), rnorm(N)),
  cc = paste0(sample(ss, 1), rnorm(N)),
  dd = paste0(sample(ss, 1), rnorm(N)),
  ee = paste0(sample(ss, 1), rnorm(N)),
  ff = paste0(sample(ss, 1), rnorm(N)),
  gg = paste0(sample(ss, 1), rnorm(N)),
  hh = paste0(sample(ss, 1), rnorm(N))
)

cat("\ndata.table := --------------------\n")
dt0 <- copy(dtt)
system.time({
  dt0[stri_detect_fixed(aa, "aa"), aa := stri_replace_all_fixed(aa, "aa", "xxxx")]
  dt0[stri_detect_fixed(aa, "bb"), aa := stri_replace_all_fixed(aa, "bb", "yyyy")]
  dt0[stri_detect_fixed(aa, "cc"), aa := stri_replace_all_fixed(aa, "cc", "zzzz")]
  dt0[stri_detect_fixed(aa, "dd"), aa := stri_replace_all_fixed(aa, "dd", "zzzz")]
  dt0[stri_detect_fixed(aa, "ee"), aa := stri_replace_all_fixed(aa, "ee", "zzzz")]
  dt0[stri_detect_fixed(aa, "ff"), aa := stri_replace_all_fixed(aa, "ff", "zzzz")]
})

cat("\ndplyr ----------------------------\n")
df <- as_tibble(dtt)
system.time({
  df <- df |>
    mutate(aa = ifelse(stri_detect_fixed(aa, "aa"), stri_replace_all_fixed(aa, "aa", "xxxx"), aa)) |>
    mutate(aa = ifelse(stri_detect_fixed(aa, "bb"), stri_replace_all_fixed(aa, "bb", "yyyy"), aa)) |>
    mutate(aa = ifelse(stri_detect_fixed(aa, "cc"), stri_replace_all_fixed(aa, "cc", "zzzz"), aa)) |>
    mutate(aa = ifelse(stri_detect_fixed(aa, "dd"), stri_replace_all_fixed(aa, "dd", "zzzz"), aa)) |>
    mutate(aa = ifelse(stri_detect_fixed(aa, "ee"), stri_replace_all_fixed(aa, "ee", "zzzz"), aa)) |>
    mutate(aa = ifelse(stri_detect_fixed(aa, "ff"), stri_replace_all_fixed(aa, "ff", "zzzz"), aa)) 
})


cat("\ndata.table set -------------------\n")
dt <- copy(dtt)
system.time({
  ii <- which(stri_detect_fixed(dt$aa, "aa"))
  set(dt, i = ii, j = 4L, stri_replace_all_fixed(dt$aa[ii], "aa", "xxxx"))
  ii <- which(stri_detect_fixed(dt$aa, "bb"))
  set(dt, i = ii, j = 4L, stri_replace_all_fixed(dt$aa[ii], "bb", "yyyy"))
  ii <- which(stri_detect_fixed(dt$aa, "cc"))
  set(dt, i = ii, j = 4L, stri_replace_all_fixed(dt$aa[ii], "cc", "zzzz"))
  ii <- which(stri_detect_fixed(dt$aa, "dd"))
  set(dt, i = ii, j = 4L, stri_replace_all_fixed(dt$aa[ii], "dd", "zzzz"))
  ii <- which(stri_detect_fixed(dt$aa, "ee"))
  set(dt, i = ii, j = 4L, stri_replace_all_fixed(dt$aa[ii], "ee", "zzzz"))
  ii <- which(stri_detect_fixed(dt$aa, "ff"))
  set(dt, i = ii, j = 4L, stri_replace_all_fixed(dt$aa[ii], "ff", "zzzz"))
})


cat("\nnative data.frame ----------------\n")
df0 <- as.data.frame(dtt)
system.time({
  ii <- which(stri_detect_fixed(df0$aa, "aa"))
  df0$aa[ii] = stri_replace_all_fixed(df0$aa[ii], "aa", "xxxx")
  ii <- which(stri_detect_fixed(df0$aa, "bb"))
  df0$aa[ii] = stri_replace_all_fixed(df0$aa[ii], "bb", "yyyy")
  ii <- which(stri_detect_fixed(df0$aa, "cc"))
  df0$aa[ii] = stri_replace_all_fixed(df0$aa[ii], "cc", "zzzz")
  ii <- which(stri_detect_fixed(df0$aa, "dd"))
  df0$aa[ii] = stri_replace_all_fixed(df0$aa[ii], "dd", "zzzz")
  ii <- which(stri_detect_fixed(df0$aa, "ee"))
  df0$aa[ii] = stri_replace_all_fixed(df0$aa[ii], "ee", "zzzz")
  ii <- which(stri_detect_fixed(df0$aa, "ff"))
  df0$aa[ii] = stri_replace_all_fixed(df0$aa[ii], "ff", "zzzz")
})

stopifnot(all(dt$aa == dt0$aa))
stopifnot(all(dt$aa == df$aa))
stopifnot(all(dt$aa == df0$aa))

cat("\nall done ---\n\n")
