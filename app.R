# Import libraries 
library(shiny)
library(ggplot2)
library(dplyr)
library(leaflet)
library(shinythemes)
library(shinyBS)

# Define UI
ui <- fluidPage(
  theme = shinytheme("flatly"),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
  ),
  titlePanel("Flight Delay Analysis"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("carrier", "Select Carrier:", choices = NULL),
      selectInput("origin", "Select Origin Airport:", choices = NULL),
      selectInput("dest", "Select Destination Airport:", choices = NULL),
      numericInput("dep_delay", "Enter Departure Delay (minutes):", value = 0, min = -30, max = 300),
      
      bsTooltip("carrier", "Choose the airline carrier you want to simulate.", "right", options = list(container = "body")),
      bsTooltip("origin", "Select the airport you're flying from.", "right", options = list(container = "body")),
      bsTooltip("dest", "Select the airport you're flying to.", "right", options = list(container = "body")),
      bsTooltip("dep_delay", "Enter a hypothetical departure delay in minutes.", "right", options = list(container = "body")),
      
      textOutput("auto_distance"),
      br()
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Carrier Performance", plotOutput("carrier_plot", height = "500px")),
        tabPanel("Destination Delays", plotOutput("barplot_dest", height = "500px")),
        tabPanel("Top Delayed Routes", plotOutput("route_delay_plot", height = "600px")),
        tabPanel("Route Map", leafletOutput("route_map", height = "700px")),
        tabPanel("Will my flight be delayed ?",
                 h4("Predicted Probability of Delay"),
                 tableOutput("prediction")
        )
      )
    )
  )
)

# Define Server Logic
server <- function(input, output, session) {
  # Load data and model
  flight_data <- reactive({
    read.csv("flights.csv")
  })
  
  logistic_model <- readRDS("logistic_model.rds")
  
  airports <- read.csv("https://raw.githubusercontent.com/jpatokal/openflights/master/data/airports.dat", header = FALSE)
  airports <- airports[, c(5, 7, 8)]
  colnames(airports) <- c("iata", "lat", "lon")
  
  route_data <- reactive({
    req(input$origin, input$dest)
    flight_data() %>%
      filter(origin == input$origin, dest == input$dest) %>%
      summarise(
        avg_delay = mean(dep_delay, na.rm = TRUE),
        flights = n(),
        .groups = "drop"
      ) %>%
      mutate(origin = input$origin, dest = input$dest) %>%
      left_join(airports, by = c("origin" = "iata")) %>%
      rename(lat_orig = lat, lon_orig = lon) %>%
      left_join(airports, by = c("dest" = "iata")) %>%
      rename(lat_dest = lat, lon_dest = lon)
  })
  
  test_data <- reactive({
    req(input$origin, input$dest)
    
    dist <- flight_data() %>%
      filter(origin == input$origin, dest == input$dest) %>%
      distinct(distance) %>%
      pull(distance)
    
    if (length(dist) == 0) dist <- NA
    
    data.frame(
      carrier = input$carrier,
      origin = input$origin,
      dest = input$dest,
      distance = dist[1],
      dep_delay = input$dep_delay
    )
  })
  
  avg_delays_carrier <- reactive({
    flight_data() %>%
      group_by(carrier) %>%
      summarise(mean_arr_delay = mean(arr_delay, na.rm = TRUE), .groups = "drop")
  })
  
  observe({
    updateSelectInput(session, "carrier", choices = unique(flight_data()$carrier))
    updateSelectInput(session, "origin", choices = unique(flight_data()$origin))
    updateSelectInput(session, "dest", choices = unique(flight_data()$dest))
  })
  
  observeEvent(input$origin, {
    valid_dests <- flight_data() %>%
      filter(origin == input$origin) %>%
      distinct(dest) %>%
      pull(dest)
    updateSelectInput(session, "dest", choices = valid_dests)
  })
  
  output$prediction <- renderTable({
    prob <- predict(logistic_model, newdata = test_data(), type = "response")
    percent <- round(prob * 100, 1)
    data.frame(`Predicted Probability of Delay` = paste0(percent, "%"))
  })
  
  # Visualizations
  output$carrier_plot <- renderPlot({
    ggplot(avg_delays_carrier(), aes(x = carrier, y = mean_arr_delay)) +
      geom_col(fill = "orange") +
      scale_y_continuous(limits = c(-10, 5), breaks = seq(-10, 5, 5)) +
      labs(title = "Average Arrival Delays by Carrier", x = "Carrier", y = "Average Arrival Delay (minutes)") +
      theme_minimal(base_size = 14) +
      theme(plot.title = element_text(hjust = 0.5)) +
      coord_flip()
  })
  
  output$barplot_dest <- renderPlot({
    flight_data() %>%
      group_by(dest) %>%
      summarise(mean_delay = mean(dep_delay, na.rm = TRUE), .groups = "drop") %>%
      top_n(10, mean_delay) %>%
      ggplot(aes(x = reorder(dest, mean_delay), y = mean_delay)) +
      geom_bar(stat = "identity", fill = "darkorange") +
      coord_flip() +
      labs(title = "Top 10 Destinations with Highest Average Departure Delays", x = "Destination", y = "Average Departure Delay (minutes)") +
      theme_minimal(base_size = 14) +
      theme(plot.title = element_text(hjust = 0.5))
  })
  
  output$route_delay_plot <- renderPlot({
    flight_data() %>%
      group_by(origin, dest) %>%
      summarise(avg_delay = mean(dep_delay, na.rm = TRUE), flight_count = n(), .groups = "drop") %>%
      filter(flight_count > 50) %>%
      top_n(10, avg_delay) %>%
      ggplot(aes(x = reorder(paste(origin, "→", dest), avg_delay), y = avg_delay)) +
      geom_bar(stat = "identity", fill = "orange") +
      coord_flip() +
      labs(title = "Top 10 Routes with Highest Average Departure Delay", x = "Route", y = "Average Departure Delay (minutes)") +
      theme_minimal(base_size = 15) +
      theme(plot.title = element_text(hjust = 0.5))
  })
  
  output$route_map <- renderLeaflet({
    leaflet(route_data()) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addPolylines(
        lng = ~c(lon_orig, lon_dest),
        lat = ~c(lat_orig, lat_dest),
        label = ~paste(origin, "→", dest, " - Avg Delay: ", round(avg_delay, 1), "min"),
        color = "red",
        weight = ~sqrt(avg_delay),
        opacity = 0.7
      )
  })
  
  output$auto_distance <- renderText({
    req(input$origin, input$dest)
    
    dist <- flight_data() %>%
      filter(origin == input$origin, dest == input$dest) %>%
      distinct(distance) %>%
      pull(distance)
    
    if (length(dist) == 0) {
      return("No distance found for this origin-destination pair.")
    }
    
    paste("Distance between selected airports:", round(dist[1], 1), "miles")
  })
}

# Run the App
shinyApp(ui = ui, server = server)