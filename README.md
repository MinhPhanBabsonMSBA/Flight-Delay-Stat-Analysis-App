# **Flight Delay Analysis App**

## **A. Introduction**

Welcome to the **Flight Delay Analysis App**! This project was inspired by a personal experience during the New Year’s holiday when a flight delay at JFK Airport sparked curiosity about the causes and patterns of flight delays. Leveraging machine learning and interactive data visualization, this app helps users explore real-world flight delay data and gain insights into factors contributing to delays.

## **B. Business Questions**
Several key questions drive this analysis:
1. **Carrier Performance**: Which airlines are more likely to experience delays?
2. **Distance Impact**: How does the distance between origin and destination airports influence delays?
3. **Departure Time Analysis**: What’s the relationship between the time of day and the probability of delays?
4. **Destination Trends**: Which destinations have the highest average delays, and why?
5. **Predictive Modeling**: Can flight delays be accurately predicted based on factors such as carrier, distance, and departure delays?

## **C. Project Objectives**
The primary objectives of this project are:
1. To build a user-friendly R Shiny app for visualizing and predicting flight delays.
2. To develop machine learning models (logistic regression, boosting, stacked ensembles) for predicting delays.
3. To identify and analyze key factors influencing delays across major airports in the US.
4. To provide actionable insights for travelers and aviation stakeholders.

## **D. Data and Methodology**
### **1. Data**
- **Dataset**: Real-world flight data focusing on three major origin airports near New York City (JFK, Newark, and LaGuardia) and 59 destination airports across the US.
- **Key Variables**:
  - `carrier`: The airline operating the flight.
  - `origin` and `dest`: The origin and destination airports.
  - `dep_delay`: Departure delay in minutes.
  - `distance`: Distance between origin and destination.

### **2. Methodology**
- **Exploratory Data Analysis (EDA)**: 
  - Visualize delay patterns across carriers, destinations, and distances.
  - Identify correlations between variables and delays.
- **Machine Learning Models**:
  - Logistic Regression for baseline predictions.
  - Gradient Boosting to capture non-linear relationships.
  - Stacked Ensemble to combine model strengths for better accuracy.
- **Interactive App**:
  - Built using **R Shiny** to allow users to explore data and predictions dynamically.
  - Includes visualizations such as histograms, scatter plots, and bar plots.

## **E. Features**
### **1. R Shiny App**
- **Dynamic Visualizations**:
  - Delay distributions by carrier and destination.
  - Departure delay trends over time.
  - Scatter plots of delay vs. distance.
- **Predictive Analytics**:
  - Logistic Regression: Predict delay probabilities based on key factors.
  - Boosting Ensemble: Enhanced predictions with non-linear relationships.
  - Stacked Ensemble: Combines model strengths for improved accuracy.
- **Interactive Inputs**:
  - Select carrier, origin, and destination.
  - Adjust sliders for departure delays and distances.
- **Data Download**:
  - Users can download the dataset for their analysis.

### **2. Supporting Quarto Document**
- A detailed Quarto document provides insights into the logic and methods behind the app, including EDA, model evaluation, and feature engineering.

## **F. Visual Highlights**
### **Key Visualizations**:
1. **Average Delays by Carrier**:
   - Compare average arrival delays across airlines.
2. **Top Destinations with Highest Delays**:
   - Bar plot highlighting destinations with the most delays.
3. **Scatter Plot of Departure Delay vs. Distance**:
   - Understand the impact of distance on delays.
4. **Real-Time Predictions**:
   - Display probabilities of delays based on user-selected inputs.

## **G. Technologies Used**
- **Programming Language**: R
- **Libraries**: 
  - `ggplot2`, `dplyr`, `reshape2` for data manipulation and visualization.
  - `gbm`, `Rcpp` for machine learning models.
- **Deployment**: R Shiny for app deployment and user interaction.
- **Documentation**: Quarto for supporting analysis and methodology.

## **H. Why This Project Matters**
This project stemmed from a real-world frustration many travelers face: the unpredictability of flight delays. By combining data analysis and machine learning, this app provides insights into delay patterns and equips users with a tool to make more informed travel decisions.

## **I. Explore the Project**
- **R Shiny App**: [Flight Delay Analysis App](http://jj1tt9minh0phan.shinyapps.io/FlightDelayApp)
- **Quarto Document**: [GitHub Repository](https://github.com/MinhPhanBabsonMSBA/Flight-Delay-Stat-Analysis-App)
