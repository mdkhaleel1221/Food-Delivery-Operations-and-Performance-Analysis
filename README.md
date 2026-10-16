# Food Delivery Operations and Performance Analysis

**An end-to-end data analytics and business intelligence project exploring 50,000 food delivery orders using Python, MySQL, and Power BI.**

This project examines customer ordering behavior, restaurant preparation efficiency, delivery-partner performance, order economics, and the relationship of traffic and weather conditions with estimated and actual delivery times.

The goal is to transform operational data into actionable business insights for improved delivery planning, logistics efficiency, and customer service.

> **Project Scope:** Descriptive and diagnostic analytics, SQL business queries, interactive Power BI dashboards, and preparation for future ETA prediction. This project does not claim a trained or validated prediction model.

---

## 📌 Project Overview

Food delivery operations involve several interconnected processes, including customer orders, restaurant food preparation, driver assignments, delivery logistics, and environmental conditions.

This project analyzes these operational factors to identify delivery patterns, performance differences, and potential inefficiencies.

### 🎯 Core Objectives

- Analyze order volumes, customer demographics, and loyalty segments.
- Compare restaurant categories, ratings, and preparation times.
- Evaluate driver experience, ratings, and delivery performance.
- Analyze order values, discounts, taxes, and delivery fees.
- Investigate estimated delivery time (ETA), actual delivery time, and delays.
- Examine the influence of traffic and weather conditions on delivery performance.
- Detect unusual observations using descriptive statistics and the Interquartile Range (IQR) method.
- Develop interactive Power BI dashboards for operational and business intelligence.

---

## 📊 Dataset Overview

The dataset contains **50,000 food delivery order records**, covering six analytical domains.

| Domain | Example Attributes | Analysis Purpose |
|---|---|---|
| Customer | Customer ID, Age, Loyalty Tier | Customer segmentation and ordering behavior |
| Restaurant | Restaurant ID, Cuisine, Rating, Preparation Time | Restaurant performance and efficiency |
| Driver | Driver ID, Experience, Rating | Delivery-partner performance |
| Environment | Traffic, Weather | Operational conditions and ETA analysis |
| Finance | Subtotal, Tax, Discount, Delivery Fee, Total Amount | Order economics and financial performance |
| Delivery | ETA, Actual Delivery Time, Delay | Delivery efficiency and delay analysis |

> **Note:** Column names and field availability should be verified against the actual dataset. The project guide provides a logical data dictionary.

---

## 🛠️ Tools & Technologies

| Technology | Purpose |
|---|---|
| **Python** | Data cleaning, validation, feature engineering, EDA, and outlier detection |
| **Pandas & NumPy** | Data manipulation and numerical analysis |
| **Matplotlib & Seaborn** | Statistical and exploratory visualizations |
| **MySQL** | SQL queries, aggregations, joins, and business analysis |
| **Power BI** | Interactive dashboards, DAX measures, KPIs, and slicers |
| **Google Colab / Jupyter Notebook** | Python analysis and documentation |
| **Git & GitHub** | Version control and project management |

---

## 🔄 End-to-End Project Workflow

```text
Raw Food Delivery Dataset
          |
          v
Data Understanding & Profiling
          |
          v
Data Cleaning & Validation
          |
          v
Feature Engineering
          |
          v
Exploratory Data Analysis (EDA)
          |
          v
Customer, Restaurant & Driver Analysis
          |
          v
Traffic, Weather & Financial Analysis
          |
          v
ETA, Delay & Outlier Analysis
          |
          v
MySQL Business Analysis
          |
          v
Power BI Dashboards & DAX KPIs
          |
          v
Business Insights & Recommendations
          |
          v
Future ETA Prediction Readiness
```

---

## 🔍 Key Analysis Areas

### 1. Customer Analytics

- Customer age distribution.
- Loyalty-tier order volumes.
- Average order value by customer segment.
- Customer contribution to total order value.
- Ordering patterns across customer groups.

### 2. Restaurant Analytics

- Restaurant category and cuisine-level demand.
- Total order value by restaurant category.
- Restaurant ratings and preparation times.
- Preparation efficiency across restaurant groups.
- Relationships between preparation time and delivery performance.

### 3. Driver Analytics

- Driver experience distribution.
- Driver ratings and order volumes.
- Average delivery time across experience groups.
- Delivery delays by driver experience.
- Driver performance comparisons.

### 4. Logistics & ETA Analytics

- Estimated delivery time distribution.
- Actual versus estimated delivery time.
- ETA variation across traffic conditions.
- Preparation time and delivery performance.
- Delivery efficiency across operational groups.

### 5. Weather & Traffic Analytics

- Delivery performance across weather categories.
- ETA differences by traffic intensity.
- Traffic-related delivery patterns.
- Weather-related delivery delays.
- Operational conditions associated with longer delivery times.

### 6. Financial Analytics

- Total order value.
- Average order value.
- Discounts and tax analysis.
- Delivery fee distribution.
- Restaurant category contribution to order value.
- Financial performance across customer segments.

### 7. Delay & Risk Analytics

- Delivery delay identification.
- Delayed order percentage.
- Delay patterns across traffic and weather categories.
- Delivery-time outlier detection.
- IQR-based identification of unusual observations.

---

## 📈 Key Performance Indicators (KPIs)

| KPI | Description |
|---|---|
| Total Orders | Total number of order records |
| Total Customers | Number of unique customers |
| Total Restaurants | Number of unique restaurants |
| Total Drivers | Number of unique delivery partners |
| Total Order Value | Sum of final order amounts |
| Average Order Value | Total order value divided by total orders |
| Average ETA | Average estimated delivery duration |
| Average Delivery Time | Average actual delivery duration, where available |
| Delay Rate | Percentage of eligible orders delivered later than ETA |
| Average Preparation Time | Average restaurant preparation duration |
| Total Discounts | Sum of all order discounts |
| Total Delivery Fees | Sum of delivery charges |

### KPI Calculations

Where the required fields are available:

```text
Final Order Amount = Subtotal + Tax + Delivery Fee - Discount

Average Order Value = Total Order Value / Total Orders

Delay (Minutes) = Actual Delivery Time - ETA

Delayed Order = Delay > 0

Delay Rate (%) = (Delayed Orders / Eligible Orders) × 100
```

---

## 📊 Power BI Dashboard

An interactive **seven-page Power BI dashboard** developed to visualize food delivery operations, customer behavior, restaurant efficiency, driver performance, logistics, financial trends, and delivery delays.

| Dashboard Page | Key Focus |
|---|---|
| Executive Overview | Orders, order value, ETA, delay rate, and operational trends |
| Customer Analytics | Customer demographics, loyalty tiers, and spending patterns |
| Restaurant Analytics | Restaurant categories, ratings, demand, and preparation efficiency |
| Driver Analytics | Driver experience, ratings, and delivery performance |
| Logistics & ETA Analytics | ETA patterns, traffic, weather, and delivery efficiency |
| Financial Analysis | Order value, discounts, taxes, and delivery fees |
| Delay & Risk Analysis | Delayed orders, operational risk factors, and ETA outliers |

---

## 🖼️ Dashboard Screenshots

### 1. Executive Overview

![Executive Overview](screenshots/01_Executive_Overview.png)

### 2. Customer Analytics

![Customer Analytics](screenshots/02_Customer_Analytics.png)

### 3. Restaurant Analytics

![Restaurant Analytics](screenshots/03_Restaurant_Analytics.png)

### 4. Driver Analytics

![Driver Analytics](screenshots/04_Driver_Analytics.png)

### 5. Logistics & ETA Analytics

![Logistics & ETA Analytics](screenshots/05_Logistics_ETA_Analytics.png)

### 6. Financial Analysis

![Financial Analysis](screenshots/06_Financial_Analysis.png)

### 7. Delay & Risk Analysis

![Delay & Risk Analysis](screenshots/07_Delay_Risk_Analysis.png)

---

## 📁 Repository Structure

```text
End-to-End-Food-Delivery-Orders-ETA-Logistics-Analysis/
│
├── Power BI/
│   └── Food_delivery_project.pbix
│
├── SQL/
│   └── food_delivery_analysis_queries.sql
│
├── data/
│   ├── cleaned/
│   │   └── food_delivery_cleaned.csv
│   └── raw/
│       └── food_delivery_orders_dataset.csv
│
├── notebooks/
│   └── Food_Delivery_dataset_analysis.ipynb
│
├── reports/
│   └── Food Delivery Orders & ETA Logistics Analysis.pdf
│
├── screenshots/
│   ├── 01_Executive_Overview.png
│   ├── 02_Customer_Analytics.png
│   ├── 03_Restaurant_Analytics.png
│   ├── 04_Driver_Analytics.png
│   ├── 05_Logistics_ETA_Analytics.png
│   ├── 06_Financial_Analysis.png
│   └── 07_Delay_Risk_Analysis.png
│
├── README.md
└── requirements.txt
```

---

## 🚀 How to Explore the Project

### Step 1: Clone the Repository

```bash
git clone https://github.com/faizan-klm/End-to-End-Food-Delivery-Orders-ETA-Logistics-Analysis.git
```

### Step 2: Install Python Dependencies

```bash
pip install -r requirements.txt
```

### Step 3: Explore the Dataset

Navigate to:

```text
data/raw/food_delivery_orders_dataset.csv
```

The cleaned dataset is available at:

```text
data/cleaned/food_delivery_cleaned.csv
```

### Step 4: Run the Python Analysis

Open the notebook using Jupyter Notebook or Google Colab:

```text
notebooks/Food_Delivery_dataset_analysis.ipynb
```

The notebook covers:

- Data profiling and validation.
- Missing-value and duplicate checks.
- Data cleaning and feature engineering.
- Exploratory Data Analysis (EDA).
- Customer, restaurant, and driver analysis.
- Traffic, weather, and financial analysis.
- ETA and delay analysis.
- Outlier detection using IQR.

### Step 5: Explore SQL Analysis

Open the SQL script:

```text
SQL/food_delivery_analysis_queries.sql
```

Review the business queries, aggregations, joins, and operational analysis.

### Step 6: Open the Power BI Dashboard

Open the following file in **Microsoft Power BI Desktop**:

```text
Power BI/Food_delivery_project.pbix
```

Explore the interactive report pages, KPIs, charts, and slicers.

### Step 7: Review the Project Report

The project documentation is available at:

```text
reports/Food Delivery Orders & ETA Logistics Analysis.pdf
```

---

## 💡 Business Questions Addressed

1. Which customer loyalty tiers contribute the highest order volumes and order value?
2. Which restaurant categories generate the greatest demand?
3. How does restaurant preparation time vary across categories?
4. How does driver experience relate to delivery performance?
5. How do traffic conditions affect estimated and actual delivery times?
6. How does weather relate to delivery delays?
7. Which orders exhibit unusually long delivery times?
8. How do discounts, taxes, and delivery fees contribute to order economics?
9. Which operational groups experience higher observed delay rates?
10. What insights can support more efficient delivery planning?

---

## 📌 Insights & Recommendations

The analysis is designed to identify operational patterns across customers, restaurants, drivers, traffic, weather, and delivery times.

### Key Findings

Verified numerical findings from Python, SQL, and Power BI analysis can be documented here, including:

- Customer segments generating the highest order volumes.
- Restaurant categories contributing the most order value.
- Categories associated with longer preparation times.
- Delivery performance differences across driver experience groups.
- Traffic and weather conditions associated with longer delivery durations.
- Unusual ETA and delivery-time observations.

### Business Recommendations

**1. Restaurant Preparation Efficiency**

Identify restaurant categories with longer preparation times and investigate opportunities to improve order readiness.

**2. Delivery Resource Planning**

Use observed demand and delivery patterns to support more effective driver allocation.

**3. Traffic-Aware Delivery Planning**

Consider traffic conditions when evaluating delivery schedules and ETA performance.

**4. Weather-Aware Operations**

Monitor delivery performance under adverse weather conditions and assess whether operational adjustments are necessary.

**5. ETA Improvement**

Use historical delivery patterns to identify potential inputs for future ETA prediction models.

> **Important:** Observed associations do not establish causal relationships.

---

## ⚠️ Project Limitations

- The analysis uses historical data rather than real-time operational monitoring.
- Geographic distance, GPS tracking, and live driver availability may not be available.
- Delay calculations depend on valid ETA and actual delivery-time fields.
- Descriptive analysis and correlations do not establish causation.
- The project does not include a trained or validated predictive model.
- Operational recommendations require further evaluation before implementation.

---

## 🔮 Future Enhancements

- Develop a machine learning model for ETA prediction.
- Explore delivery-delay classification.
- Incorporate geographic distance and GPS information.
- Integrate live traffic and weather data.
- Implement automated Power BI refresh.
- Develop operational monitoring dashboards.
- Evaluate model performance using appropriate prediction metrics.

---

## 🏁 Conclusion

This project demonstrates a complete **end-to-end data analytics and business intelligence workflow** for food delivery operations.

By integrating **Python, MySQL, and Power BI**, the analysis explores customer demand, restaurant preparation efficiency, driver performance, order economics, and delivery-time patterns.

The project highlights how structured data analysis, SQL-based business querying, and interactive visualization can support informed operational decisions and provide a foundation for future predictive analytics.

---

## 👨‍💻 Author

**Md Khaleel ur Rahman**

---

⭐ **If you find this project useful, consider giving the repository a star!**
