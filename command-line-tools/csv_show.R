#!/usr/bin/env Rscript

library(data.table)

# the command is in the format of
# csv_show filename --columns col1 col2 --tasks summary

parse_options <- function(args, opt) {

  opt <- paste0("--", opt)

  if (!opt %in% args) {
    return(NULL)
  }

  i__ <- which(grepl("--", args))
  i_opt <- which(grepl(opt, args))
  if (i_opt == max(i__)) {
    opts <- args[(i_opt + 1):length(args)]
  } else {
    opts <- args[(i_opt + 1):(max(i__) - 1)]
  }

  return(opts)
}

args = commandArgs(trailingOnly=TRUE)
fname <- args[1]
cols_selected <- parse_options(args, opt = "columns")
task <- parse_options(args, opt = "task")

group_by_func <- parse_options(args, opt = "group_by_func")
group_var <- group_by_func[1]
by_var <- group_by_func[2]
group_func <- group_by_func[3]

xy<- parse_options(args, opt = "xycount")
print(xy)


dat <- fread(fname, keepLeadingZeros = TRUE)

if (is.null(cols_selected)) {
  cols_selected <- names(dat)
}
dat <- dat[, cols_selected, with = FALSE]

if (is.null(task) && is.null(group_by_func) && is.null(xy)) {
  print(dat)
}

if (!is.null(task) && task == "summary") {
  print(summary(dat))
}

if (!is.null(task) && task == "count") {
  for (col in cols_selected) {
    if (is.character(dat[[col]])) {
      print(as.data.frame(table(dat[[col]])))
    }
  }
}

if (!is.null(group_by_func)) {
  cat(paste0("\ngroup by '", group_var, 
             "', the ", group_func, " of '", by_var, 
             "' is ----\n"))
  func <- get(group_func)
  res <- dat[, func(get(by_var)), by = group_var] |>
    setnames("V1", group_func)
  print(res)
}

if (!is.null(xy)) {
  res <- dat[, .N, by = xy] |>
    _[order(get(xy[1]), get(xy[2]))]
  print(res)
}
