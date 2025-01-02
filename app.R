# Import libraries 
library(shiny)
library(ggplot2)
library(dplyr)
library(reshape2)
library(Rcpp)
library(gbm)
library(rsconnect)

# Define UI
ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
  ),
  titlePanel("Flight Delay Analysis"),
  
  sidebarLayout(
    sidebarPanel(
      HTML("<h3>Welcome to the Flight Delay Analysis App</h3>"),
      HTML("<p>This app provides insights into flight delays using various machine learning models.</p>"),
      selectInput("carrier", "Select Carrier:", choices = NULL),
      selectInput("origin", "Select Origin:", choices = NULL),
      selectInput("dest", "Select Destination:", choices = NULL),
      sliderInput("dep_delay", label = "Departure Delay (minutes)", min = 0, max = 100, value = 0),
      sliderInput("distance", label = "Distance (miles)", min = 0, max = 1000, value = 0),
      downloadButton("downloadData", "Download Dataset")
    ),
    
    mainPanel(
      # Add outputs for analysis and visualization
      
      
      tabsetPanel(
        tabPanel("Visualizations",plotOutput("carrier_plot"),plotOutput("delay_plot"),plotOutput("scatter_plot"),plotOutput("barplot_dest")),
        tabPanel("Logistic Model Prediction", tableOutput("prediction")),
        tabPanel("Boost Ensemble Method Prediction ",tableOutput("prediction2")),
        tabPanel("Stacked Emsemble Method using previous models", tableOutput("prediction3"))
      )
    )
  )
)

# Define Server Logic
server <- function(input, output, session) {
  # Load and preprocess the dataset
  flight_data <- reactive({
    flight <- read.csv("flights.csv")
    flight
  })
  
  
  avg_delays_carrier <- reactive({
    flight_data() %>%
      group_by(carrier) %>%
      summarise(mean_arr_delay = mean(arr_delay, na.rm = TRUE))
  })
  
  
  
  logistic_model <- readRDS("logistic_model.rds")  
  boost_model <-readRDS("boost_model.rds")
  stacked_model<-readRDS("stacked_model.rds")
  
 
  
  
  
  
  # Populate the drop down menus dynamically
  observe({
    updateSelectInput(session, "carrier", choices = unique(flight_data()$carrier))
    updateSelectInput(session, "origin", choices = unique(flight_data()$origin))
    updateSelectInput(session, "dest", choices = unique(flight_data()$dest))
    
    # Update slider inputs with actual data ranges
    updateSliderInput(session, "dep_delay", min = min(flight_data()$dep_delay, na.rm = TRUE), max = max(flight_data()$dep_delay, na.rm = TRUE), value = 0)
    updateSliderInput(session, "distance", min = min(flight_data()$distance, na.rm = TRUE), max = max(flight_data()$distance, na.rm = TRUE), value = 0)
  })
  
  # Predictions
  
  #Logistic Model
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
  
  #Boost
  output$prediction2 <- renderTable({
    test_data <- data.frame(
      carrier = input$carrier,
      origin = input$origin,
      dest = input$dest,
      distance = input$distance,
      dep_delay = input$dep_delay
    )
    
    test_data$prob_delay_yes <- predict(boost_model, newdata = test_data, type = "response")
    test_data
  })
  
  
  #Stacked
  output$prediction3 <- renderTable({
    test_data <- data.frame(
      carrier = input$carrier,
      origin = input$origin,
      dest = input$dest,
      distance = input$distance,
      dep_delay = input$dep_delay
    )
    
    test_data$prob_delay_yes <- predict(stacked_model, newdata = test_data, type = "response")
    test_data
    
  })
  
  
# Visualizations  

  # Departure Delay distribution plot
  output$delay_plot <- renderPlot({
    ggplot(flight_data(), aes(x = dep_delay)) +
      geom_histogram(binwidth = 10, fill = "blue", color = "black", alpha = 0.7) +
      scale_x_continuous(limits = c(-20, 80), breaks = seq(-20, 80, 5)) +
      labs(title= " Distribution of Departure Delay Variable", x = "Departure Delay (minutes)", y = "Frequency") +
      theme(plot.title = element_text(hjust = 0.5))
  })

  
  # Carrier Delay plot

  output$carrier_plot <- renderPlot({
    ggplot(avg_delays_carrier(), aes(x = carrier, y = mean_arr_delay)) +
      geom_col(fill = "grey") +
      scale_y_continuous(limits = c(-10, 5), breaks = seq(-10, 5, 5)) +
      labs(title = "Average Arrival Delays by Carrier", 
           x = "Carrier", 
           y = "Average Arrival Delay (minutes)") +
      theme(plot.title = element_text(hjust = 0.5)) +
      coord_flip()
    
  })
  # Scatter Plot of Distance vs departure Delay 
  output$scatter_plot <- renderPlot({
    ggplot(flight_data(), aes(x = distance, y = dep_delay)) +
      geom_point(alpha = 0.5) +
      labs(title = "Scatter Plot of Departure Delay vs. Distance", x = "Distance (miles)", y = "Departure Delay (minutes)") +
      theme(plot.title = element_text(hjust = 0.5))
  })
  
  # Bar Plot of Delays by Destination 
  output$barplot_dest <- renderPlot({
    flight_data() %>%
      group_by(dest) %>%
      summarise(mean_delay = mean(dep_delay, na.rm = TRUE)) %>%
      top_n(10, mean_delay) %>%
      ggplot(aes(x = reorder(dest, mean_delay), y = mean_delay)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      labs(title = "Top 10 Destinations with Highest Average Departure Delays", x = "Destination", y = "Average Departure Delay (minutes)") + theme(plot.title = element_text(hjust = 0.5))

  })
  
  # Download Data
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("flight_data-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(flight_data(), file)
    }
  )
  }

# Run the App
shinyApp(ui = ui, server = server)