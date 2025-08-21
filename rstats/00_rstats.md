# Installation

## Install packages

Recommend `pak` to install packages in a controlled way. By default, it only installs dependencies in groups Depends and Imports, and skips update if a dependency is already installed and meets the minimal version requirement. 

`install.packages(...)` forces upgrade dependencies to the latest version.

```r
pak::pkg_install("abc")
```


## trim installed packages

R is not in registry on Window. So `path/to/Rscript.exe xxx.R` will run from command line. Under the installation directory, the following subdirectories are not required for `Rscript.exe`:

- Tcl/
- tests/
- doc/
- share/
- subdir in library/
  - translations/
  - KernSmooth
  - spatial
  - survival
  - mgcv
  - rpart
  - nlme

required packages
- tools

local-installed-package, tried to delete 3, all required
- zip
- tzdb
- Rcpp

These base packages must stay in R-4.4.1/library/ and cannot be moved to user library.
`base  compiler  datasets  grDevices  graphics  grid  methods  parallel  stats  tools  utils`


# Run .R files

## Collect all termimal output from Rscript run
Collect both the standard output and error:
- package loading message and warnings are part of error.
- we can see the printout on terminal and the same time the message is sent to the log file.

`$ Rscript xxx.R 2>&1 | tee xxx.log`


# to be determined
### import an environment to .GlobalEnv

```r
# save an env object to RDS file
saveRDS(env_i, file = "env_i.RDS")

# clear global environment
rm(list = ls(envir = .GlobalEnd), envir = .GlobalEnv)

# read the saved environment
env_i <- readRDS("env_i.RDS")

# load all objects in env_i to global environment
list2env(as.list(env_i), envir = .GlobalEnv)

# delete env_i from global environment
rm("env_i")
```

### catch exit status with system()

For example, we have a test file `ttt.R`, which has a quit statement
```r
print("stat the test")
quit(save = "no", status = 5) 
```
In another file `ttt_run.R`, which runs `ttt.R` with `system()` function:
```r
# pass exit status 5 to exit_status
std_out <- system("Rscript ttt.R ; echo $?", intern = TRUE)
exit_status <- std_out[length(std_out)]
print(exit_status)

# or if consol output is not required, simply
exit_status <- system("Rscript ttt.R")
```
From terminal, when we run $ Rscript ttt_run.R, it will print 5 to stdout.


### garbage collector gc()
No need to run `gc()` to manually collect garbage. R will automatically collect garbage whenever more memory is needed.

Sources of garbages:
- Objects created inside a function scope after function run is completed.
- Objects removed with `rm(x, y, abc)`
- A memory location that is not reachable in R anymore, for example, if we first run `dat <- 123` and then run `dat <- "abc"`, then data `123` is not reachable anymore and becomes garbage.
  
Use `rm()` to explicityly remove a large object before creating a new large object with the same name. Without `rm(df)`, the memory for the first df is not released before the creation of the second df is completed, which means a minimal memory of two df is required.
```r
df <- data.frame(x = 1:1e9, y = rnorm(1e9))
rm(df)
df <- data.frame(x = 1:1e9, y = rnorm(1e9))
```



### Use a variable of a function

```r
fun_var <- "mean"
get(fun_var)(1:9)  # same as mean(1:9)
```


### Use .Renviron for environment variables

Locations of .Renviron file
- under user home directory: place API keys and other secret here, which is shared by all projects.
- under project root: place project-specific constant here. When R started from the project root, the variables will be picked up. If the same variable name also in the file at the user home, the one at the project root is used.

How to use it
- automatically picked up when R starts
- `my_api_key <- Sys.getenv("API_KEY")` to extract an environment variable.

