#!/usr/bin/env Rscript

# Analyze a csv file from terminal
# - Created 2024-12-22
# - Examples:
#   - csv_show iris.csv --columns col1 col2 --task summary
#   - csv_show iris.csv --group_by_fun colA colB mean
#   - csv_show iris.csv --xycount colA colB
# 

library(data.table)


#' parse options --xyz value1 value2 --opt2 ...
#'
#' @param args string vector, return of commandArgs(trailingOnly = TRUE)
#' @param opt string, name of an option such as "task" and "columns"
#'
#' @return string, values of the option
#'
#' @export

parse_options <- function(args, opt) {

  opt <- paste0("--", opt)

  if (!opt %in% args) {
    return(NULL)
  }

  i__ <- which(grepl("--", args))  # position of all -- options
  i_opt <- which(grepl(opt, args)) # position of the option of interests
  if (i_opt == max(i__)) {
    opt_values <- args[(i_opt + 1):length(args)]
  } else {
    opt_values <- args[(i_opt + 1):(max(i__) - 1)]
  }

  return(opt_values)
}

cat_help_message <- function() {
  cat("\nexamples:")
  cat("\n$ csvshow aaa.csv                                     # display all columns")
  cat("\n$ csvshow aaa.csv --columns col1 col2                 # display selected columns")
  cat("\n$ csvshow aaa.csv --columns col1 col2 --task count    # count all selected categorical columns")
  cat("\n$ csvshow aaa.csv --columns col1 col2 --task summary  # summary all selected numeric columns")
  cat("\n$ csvshow aaa.csv --group_by_fun colA colB mean       # group by colA and calculate mean of colB.")
  cat("\n$ csvshow aaa.csv --xycount colC colD                 # count colC-colD combinations\n\n")
  quit(save = "no")
}

args = commandArgs(trailingOnly=TRUE)

if (args[1] == "help") {
  cat_help_message()
}

# verify options
options <- args[grepl("^-", args)]
available_options <- c("--columns", "--task", "--group_by_fun", "--xycount")
if (!all(options %in% available_options)) {
  cat("\nError: option", setdiff(options, available_options), "is not avaluable.",
      "\nAvailable options are", paste(available_options, collapse = ", "), "\n")
  cat_help_message()
}

fname <- args[1]
cols_selected <- parse_options(args, opt = "columns")
task <- parse_options(args, opt = "task")

group_by_fun <- parse_options(args, opt = "group_by_fun")
group_var <- group_by_fun[1]
by_var <- group_by_fun[2]
group_fun <- group_by_fun[3]

xy <- parse_options(args, opt = "xycount")

dat <- fread(fname, keepLeadingZeros = TRUE)

if (is.null(cols_selected)) {
  cols_selected <- names(dat)
}
dat <- dat[, cols_selected, with = FALSE]

if (is.null(task) && is.null(group_by_fun) && is.null(xy)) {
  print(dat, topn = 20)
}

if (!is.null(task) && task == "summary") {
  # only show for numeric columns
  numeric_cols <- sapply(dat, is.numeric)
  print(summary(dat[, numeric_cols, with = FALSE]))
}

if (!is.null(task) && task == "count") {
  for (col in cols_selected) {
    if (is.character(dat[[col]])) {
      res <- as.data.table(table(dat[[col]]))
      names(res) <- c(col, "count")
      cat("\n----------------------------------------------\n")
      print(res, topn = 20)
    }
  }
}

if (!is.null(group_by_fun)) {
  cat(paste0("\ngroup by '", group_var, 
             "', the ", group_fun, " of '", by_var, 
             "' is ----\n"))
  func <- get(group_fun)
  res <- dat[, func(get(by_var), na.rm = TRUE), by = group_var] |>
    setnames("V1", group_fun)
  print(res)
}

if (!is.null(xy)) {
  res <- dat[, .N, by = xy] |>
    _[order(get(xy[1]), get(xy[2]))]
  print(res)
}
