library(shiny)
library(DT)
library(dplyr)

ui <- fluidPage(
  actionButton("update_btn", "Update Table"),
  DTOutput("main_table")
)

server <- function(input, output) {
  dat <- reactiveVal(mtcars)
  
  # Initial table render
  output$main_table <- renderDT({
    datatable(dat())
  })
  
  proxy <- dataTableProxy("main_table")
  
  observeEvent(input$update_btn, {
    # Create new column data
    new_dat <- dat()
    new_dat$new_col <- rnorm(nrow(new_dat))
    dat(new_dat)
    
    # Update specific column using proxy
    replaceData(proxy, dat(), resetPaging = FALSE, rownames = FALSE)
    
    # Add some user interaction state
    updateActionButton(inputId = "update_btn", 
                      label = paste("Updated", Sys.time()))
  })
}

shinyApp(ui, server)
