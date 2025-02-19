library(shiny)
library(DT)

# Sample data frame
data <- data.frame(
  Name = c("Alice", "Bob", "Charlie", "David", "Eve"),
  Age = c(25, 30, 35, 40, 45),
  Gender = c("Female", "Male", "Male", "Male", "Female"),
  Salary = c(50000, 60000, 70000, 80000, 90000)
)

# Define UI
ui <- fluidPage(
  titlePanel("Data Frame Filter App"),
  sidebarLayout(
    sidebarPanel(
      selectInput("column", "Select Column", choices = c("None", names(data))), # Add "None" option
      uiOutput("filter_ui") # Dynamic UI for filtering
    ),
    mainPanel(
      DTOutput("filtered_table") # Display the filtered table
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  
  # Dynamically generate UI for filtering based on column type
  output$filter_ui <- renderUI({
    column <- input$column
    if (column != "None") { # Only show filtering UI if a column is selected
      if (is.numeric(data[[column]])) {
        sliderInput("range", "Select Range", 
                    min = min(data[[column]], na.rm = TRUE), 
                    max = max(data[[column]], na.rm = TRUE), 
                    value = c(min(data[[column]], na.rm = TRUE), max(data[[column]], na.rm = TRUE)))
      } else if (is.factor(data[[column]]) || is.character(data[[column]])) {
        selectInput("categories", "Select Categories", 
                    choices = unique(data[[column]]), 
                    multiple = TRUE)
      }
    }
  })
  
  # Filter the data frame based on user input
  filtered_data <- reactive({
    column <- input$column
    if (column == "None") {
      # Return the full table if no column is selected
      data
    } else if (is.numeric(data[[column]])) {
      # Filter numeric columns based on the range
      data[data[[column]] >= input$range[1] & data[[column]] <= input$range[2], ]
    } else if (is.factor(data[[column]]) || is.character(data[[column]])) {
      # Filter categorical columns based on selected categories
      if (!is.null(input$categories)) {
        data[data[[column]] %in% input$categories, ]
      } else {
        data
      }
    } else {
      data
    }
  })
  
  # Render the filtered data frame
  output$filtered_table <- renderDT({
    datatable(filtered_data())
  })
}

# Run the application 
shinyApp(ui = ui, server = server)