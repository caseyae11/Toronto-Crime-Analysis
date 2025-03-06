# Toronto Crime Analysis

## 📌 Project Overview
Toronto Crime Analysis is a data-driven project that examines crime patterns in Toronto using **statistical modeling and data visualization techniques**. This analysis explores:
- 📍 When crimes occur most frequently.
- 🌆 How crime rates differ between **day and night**.
- 🏙️ How crime trends vary across **different divisions in Toronto**.

The goal is to identify meaningful patterns in crime occurrences, aiding law enforcement agencies and policymakers in making informed decisions.

---

## ⚙️ Technologies Used
- **R** → Primary language for data analysis.
- **ggplot2** → Data visualization.
- **dplyr** → Data manipulation.
- **caret** → Machine learning model validation.
- **lmtest, car** → Hypothesis testing and regression diagnostics.
- **effectsize** → Statistical effect size calculations.

---

## 🚀 Features
- ✅ **Data Cleaning & Transformation** → Handling missing values, filtering datasets, and categorizing time-based occurrences.
- 📊 **Exploratory Data Analysis (EDA)** → Generating **scatter plots, density plots, and boxplots** to visualize trends.
- 📈 **Statistical Analysis** → Performing **correlation, covariance, ANOVA, and T-tests** to identify key relationships.
- 🔮 **Predictive Modeling** → Building **linear regression models** to analyze crime patterns over time.
- 🌃 **Crime Pattern Analysis** → Comparing **crime rates between day and night** using statistical tests.
- 🧠 **Machine Learning Validation** → Applying **cross-validation techniques** to assess model performance.

---

## 🛠 How to Run

```bash
# 1️⃣ Clone the Repository
git clone https://github.com/YOUR-USERNAME/Toronto-Crime-Analysis.git
cd Toronto-Crime-Analysis
# 2️⃣ Install Required R Packages
install.packages(c("ggplot2", "dplyr", "caret", "lmtest", "car", "effectsize"))
# 3️⃣ Load Dataset
Link to the file is located here: https://open.toronto.ca/dataset/major-crime-indicators/
# 4️⃣ Run the Analysis
source("Toronto_Crime_Analysis.R")
