# Import libraries 
library(shiny)
library(ggplot2)
library(dplyr)




# Define UI
ui <- fluidPage(
  titlePanel("Flight Delay Analysis"),
  
  sidebarLayout(
    sidebarPanel(
      # Add inputs for user interaction
      selectInput("carrier", "Select Carrier:", choices = NULL ),
      selectInput("origin", "Select Origin:", choices = NULL),
      selectInput("dest", "Select Destination:", choices = NULL),
      sliderInput("dep_delay", label = "dep_delay", value = 0.0,
                  min = min(flight$dep_delay),
                  max = max(flight$dep_delay)),
      sliderInput("distance", label = "distance", value = 0.0,
                  min = min(flight$distance),
                  max = max(flight$distance)),
    
    ),
    
    mainPanel(
      # Add outputs for analysis and visualization
      tableOutput("prediction"),
      plotOutput("delay_plot")
        )
      
      
  
    )
  )
# Define Server Logic
server <- function(input, output, session) {
  # Load and preprocess the dataset
  flight_data <- reactive({
    # Replace this with your dataset loading code from the .qmd file
    flight<-read.csv("flights.csv")
    flight
    
  })
  logistic_model <- readRDS("logistic_model.rds")  

  
  # Populate the drop down menus dynamically
  observe({
    updateSelectInput(session, "carrier", choices = unique(flight_data()$carrier))
    updateSelectInput(session, "origin", choices = unique(flight_data()$origin))
    updateSelectInput(session, "dest", choices = unique(flight_data()$dest))
    updateSelectInput(session, "distance", choices = (flight_data()$minute))
    updateSelectInput(session, "dep_delay", choices = (flight_data()$dep_delay))
    
  })
  
  

  
  
  # Prediction
  
  output$prediction <- renderTable({
    test_data <- data.frame(
      carrier = input$carrier,
      origin = input$origin,
      dest = input$dest,
      distance = input$distance,
      dep_delay = input$dep_delay
    )
    test_data$prob_delay_yes <- predict(logistic_model, newdata = test_data, type = "response")
    test_data
  })
  
  
  # Delay distribution plot
  output$delay_plot <- renderPlot({
    ggplot(flight_data(), aes(x = arr_delay)) +
      geom_histogram(binwidth = 10, fill = "blue", color = "black", alpha = 0.7) + scale_x_continuous(limits = c(-20,100), breaks = seq(-20, 100, 10)) + labs(title = "Distribution of Arrival Delays", x = "Arrival Delay (minutes)", y = "Frequency") +
      theme(plot.title = element_text(hjust = 0.5))
  })
  

}

# Run the App
shinyApp(ui = ui, server = server)