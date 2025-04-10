# ✈️ Flight Delay Analysis App

## 🧭 A. Introduction

Welcome to the **Flight Delay Analysis App** — a project born from a New Year’s holiday travel delay at JFK Airport ([LinkedIn Post](https://www.linkedin.com/posts/minh-phan-0409_it-is-the-new-years-holiday-one-of-the-activity-7280805963832410112-8Cs3?utm_source=share&utm_medium=member_desktop)). This interactive R Shiny application helps you visualize, explore, and simulate real-world flight delay scenarios using historical flight data and predictive modeling.

🎯 **Live App**: [Flight Delay App on ShinyApps.io](http://jj1tt9minh0phan.shinyapps.io/FlightDelayApp)  
📂 **Code & Documentation**: [GitHub Repository](https://github.com/MinhPhanBabsonMSBA/Flight-Delay-Stat-Analysis-App)

---

## ❓ B. Business Questions

1. **Which airlines are more prone to delays?**  
2. **Does flight distance influence delay likelihood?**  
3. **Which destinations tend to have the worst delay patterns?**  
4. **Can we predict the probability of a delay based on route, airline, and departure info?**

---

## 🎯 C. Project Objectives

- Create an intuitive R Shiny dashboard for flight delay simulation and exploration.
- Develop machine learning models to predict delay probabilities.
- Offer real-time user interaction with origin-destination inputs.
- Deliver valuable insights for both travelers and airline analysts.

---

## 📊 D. Data & Methodology

### 1. ✈️ Data Source
- **Flight Data**: Flights originating from NYC-area airports (JFK, LGA, EWR) to 59 destinations.
- **Variables**:
  - `carrier` – Airline code  
  - `origin` / `dest` – Airport codes  
  - `dep_delay` – Departure delay in minutes  
  - `distance` – Distance in miles  

### 2. 🔬 Methodology
- **EDA**: Explore delay patterns across carriers and airports.
- **ML Modeling**: Train and compare logistic regression, boosting, and stacked ensemble models.
- **Visualization**: Use `ggplot2` and `leaflet` to generate interactive plots and maps.

---

## 🧩 E. Key Features



### 🖥️ R Shiny Dashboard

- **Interactive Inputs**:
  - Select carrier, origin, and destination.
  - Simulate departure delays and auto-calculate distance.

  
- **Visual Analytics**:
  - Top 10 routes have the highest average departure delay 
    ![](https://github.com/MinhPhanBabsonMSBA/Flight-Delay-Stat-Analysis-App/blob/main/flight%20delay%203.png)
  - Top 10 destinations by average delay
   ![](https://github.com/MinhPhanBabsonMSBA/Flight-Delay-Stat-Analysis-App/blob/main/flight%20delay%202.png)
  - Route-level delay maps
    ![](https://github.com/MinhPhanBabsonMSBA/Flight-Delay-Stat-Analysis-App/blob/main/flight%20delay%204.png)
  - Carrier performance bar plots
  ![](https://github.com/MinhPhanBabsonMSBA/Flight-Delay-Stat-Analysis-App/blob/main/flight%20delay%201.png)
- **Predictive Analytics**:
  - Real-time probability prediction of a flight being delayed.
   ![](https://github.com/MinhPhanBabsonMSBA/Flight-Delay-Stat-Analysis-App/blob/main/flight%20delay%205.png)
  - AI Price Assistant
  ![](https://github.com/MinhPhanBabsonMSBA/Flight-Delay-Stat-Analysis-App/blob/main/flight%20delay%206.png)


---

## 🗺️ F. Visual Highlights

| Feature | Description |
|--------|-------------|
| 📈 **Carrier Bar Plot** | Visualize average delays by airline |
| 🧭 **Route Delay Map** | See origin-destination delay flows |
| 🧮 **Delay Probability Calculator** | Predict likelihood of delay for a flight |
| 🛫 **Top Delayed Routes** | Explore routes with the most delay on average |

---

## 🤖 G. Machine Learning Component

The machine learning module powers the **“Will My Flight Be Delayed?”** tab and offers real-time prediction.
The AI-powered assistant helps users see the desired flight price range from one destination to another.

### ✅ Models Used

| Model                | Description                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| **Logistic Regression** | A fast, interpretable baseline classifier. Estimates probabilities of delay. |
| **Gradient Boosting (GBM)** | Captures complex non-linear interactions among features.                 |
| **Stacked Ensemble**     | Combines multiple models to boost predictive accuracy.                     |



### 📐 Features Used for Prediction
- `carrier` – Airline code  
- `origin` – Departure airport  
- `dest` – Arrival airport  
- `distance` – Auto-filled based on origin/dest  
- `dep_delay` – User-specified scenario value  

> Predictions are updated immediately based on user inputs. The app automatically calculates the flight distance once an origin-destination pair is selected.


### AI Assistant 
- Using Groq API to fetch data and responses to answer users questions


---

## 🛠️ H. Technologies Used

- **Frontend**: R Shiny, `shinythemes`, `shinyBS`
- **Backend**: `dplyr`, `ggplot2`, `leaflet`, `Rcpp`, `gbm`
- **Machine Learning**: Logistic regression, gradient boosting, ensemble stacking
- **Deployment**: [shinyapps.io](http://jj1tt9minh0phan.shinyapps.io/FlightDelayApp)
- **Documentation**: Quarto for analysis and reporting

---

## 📌 I. Future Enhancements

- 🔍 Add SHAP or LIME for model interpretability  
- 🌤️ Integrate NOAA weather data to explain weather-related delays  
- 🔄 Enable API-based real-time flight data updates (e.g., OpenSky, AviationStack)  
- 💡 Add user-driven scenario simulations for multiple flights  

---

## 🙌 J. Why This Matters

Flight delays are frustrating and costly. This app empowers users with data-driven insights to better anticipate and understand delay risks — turning uncertainty into informed decisions.

---

Feel free to fork, explore, or contribute!
