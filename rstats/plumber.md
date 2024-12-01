## Minimal example:
To deploy R code as web API, we need two files:

- `xxx.R` that defines the API
    ```r
    # save the file as xxx.R

    #* Echo back the input
    #* @param msg The message to echo
    #* @get /echo
    function(msg="") {
      list(msg = paste0("The message is: '", msg, "'"))
    }

    #* Plot a histogram
    #* @serializer png
    #* @get /plot
    function() {
      rand <- rnorm(100)
      hist(rand)
    }

    #* Return the sum of two numbers
    #* @param a The first number to add
    #* @param b The second number to add
    #* @post /sum
    function(a, b) {
      as.numeric(a) + as.numeric(b)
    }


    #* Return the iris dataset as JSON
    #* @get /iris
    function() {
      # Use 'jsonlite' package to convert data frame to JSON format.
      jsonlite::toJSON(iris, pretty = TRUE)
    }
    ```
- `run_xxx.R` to start the server with `$ Rscipt run_xxx.R`
    ```r
    library(plumber)
    pr("xxx.R") %>%
      pr_run(port=8000)
    ```

Access the endpoints in web brouser:
- http://localhost:8000/plot
- http://localhost:8000/echo
- http://localhost:8000/iris

Download JSON files:
- wget http://localhost:8000/iris iris.json
- curl http://localhost:8000/iris -o iris.json

## Use plumber in a large project
Separate web API from business logic

- Run the main calculations and save the output
- Define web APIs that use the output
- Start web server
