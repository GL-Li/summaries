# Install necessary packages if not already installed
if (!require("shiny")) install.packages("shiny")
if (!require("DT")) install.packages("DT")

library(shiny)
library(DT)

# Generate a sample data frame with 100 columns and 1000 rows
set.seed(123)
data <- as.data.frame(matrix(rnorm(100 * 1000), nrow = 1000, ncol = 100))
colnames(data) <- paste0("Column_", 1:100)

# Define UI for the application
ui <- fluidPage(
  titlePanel("Scrollable DataTable Example"),
  
  # Use DT::dataTableOutput to create a DataTable with scroll bars
  mainPanel(
    DT::dataTableOutput("mytable")
  )
)

# Define server logic
server <- function(input, output) {
  output$mytable <- DT::renderDataTable({
    DT::datatable(
      data,
      extensions = 'Scroller',  # Enable Scroller extension for smooth scrolling
      options = list(
        scrollX = TRUE,        # Enable horizontal scrolling
        scrollY = "500px",      # Set vertical scroll height
        deferRender = TRUE,     # Improve performance for large datasets
        scroller = TRUE         # Enable Scroller
      )
    )
  })
}

# Run the application
shinyApp(ui = ui, server = server)