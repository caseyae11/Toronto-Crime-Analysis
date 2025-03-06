# Project 3 Updates - Enhanced R Script

# Load Required Libraries
library(dplyr)
library(ggplot2)
library(car)          # For multicollinearity checks
library(effectsize)   # For Cohen's d
library(lmtest)       # For hypothesis testing diagnostics
library(caret)        # For cross-validation

# Load Dataset
crime_data <- read.csv("crime_data.csv")  # Replace with correct dataset path

# Step 1: Data Cleaning and Transformation
# Filter missing values for Longitude and Latitude
crime_data <- crime_data %>%
  filter(!is.na(Longitude) & !is.na(Latitude))

# Add a time period column (Day/Night)
crime_data <- crime_data %>%
  mutate(TimePeriod = ifelse(OccurHour >= 6 & OccurHour < 18, "Day", "Night"))

# Check for missing values and outliers
print(colSums(is.na(crime_data)))
boxplot(crime_data$OccurHour, main = "Occurrence Hour Outliers", ylab = "Occurrence Hour")

# Step 2: Covariance and Correlation
covariance <- cov(crime_data$OccurHour, crime_data$ReportYear, use = "complete.obs")
correlation <- cor(crime_data$OccurHour, crime_data$ReportYear, use = "complete.obs")
cat("Covariance:", covariance, "\nCorrelation:", correlation, "\n")

# Step 3: Data Aggregation and Initial Visualizations
# Aggregate total crimes by OccurHour
crime_counts <- crime_data %>%
  group_by(OccurHour) %>%
  summarise(TotalCrimes = n())

# Scatterplot: Occurrence Hour vs Total Crimes
ggplot(crime_counts, aes(x = OccurHour, y = TotalCrimes)) +
  geom_point(color = "blue") +
  geom_smooth(method = "lm", formula = y ~ x, color = "red") +
  labs(title = "Scatter Plot of Total Crimes vs. Occurrence Hour",
       x = "Occurrence Hour", y = "Total Crimes") +
  theme_minimal()

# Density Plot: Total Crimes by Time Period
ggplot(crime_data, aes(x = OccurHour, fill = TimePeriod)) +
  geom_density(alpha = 0.5) +
  labs(title = "Density Plot of Total Crimes by Time Period",
       x = "Occurrence Hour", y = "Density") +
  theme_minimal()

# Step 4: Research Question 1 - Monthly Crime Count Analysis
monthly_crime <- crime_data %>%
  group_by(ReportMonth = as.numeric(as.factor(OccurHour))) %>%
  summarise(MonthlyCrimeCount = n())

# Linear Regression: Monthly Crime Count ~ Report Month
model1 <- lm(MonthlyCrimeCount ~ ReportMonth, data = monthly_crime)
summary(model1)

# Refined Model with Interaction Terms
model1_interaction <- lm(MonthlyCrimeCount ~ ReportMonth * TimePeriod, data = monthly_crime)
summary(model1_interaction)

# Visualize regression
ggplot(monthly_crime, aes(x = ReportMonth, y = MonthlyCrimeCount)) +
  geom_point() +
  geom_smooth(method = "lm", color = "blue", se = FALSE) +
  labs(title = "Monthly Crime Counts vs Month", x = "Month", y = "Monthly Crime Count")

# Diagnostics for Model 1
par(mfrow = c(2, 2))
plot(model1)
plot(model1_interaction)

# Cross-Validation for Model 1
train_control <- trainControl(method = "cv", number = 10)
cv_model1 <- train(MonthlyCrimeCount ~ ReportMonth, data = monthly_crime, method = "lm", trControl = train_control)
print(cv_model1)

# Step 5: Research Question 2 - Day vs Night Crime Analysis
# T-Test: Day vs Night

day_crimes <- crime_data %>% filter(TimePeriod == "Day") %>% pull(OccurHour)
night_crimes <- crime_data %>% filter(TimePeriod == "Night") %>% pull(OccurHour)

t_test_result <- t.test(day_crimes, night_crimes, paired = FALSE)
print(t_test_result)

# Effect Size: Cohen's d
effect_size <- cohens_d(day_crimes, night_crimes)
print(effect_size)

# Boxplot: Crime Occurrence by Time Period
ggplot(crime_data, aes(x = TimePeriod, y = OccurHour, fill = TimePeriod)) +
  geom_boxplot() +
  labs(title = "Crime Occurrence by Time Period",
       x = "Time Period", y = "Occurrence Hour")

# Step 6: Research Question 3 - Variance in Crime Timing by Division
variance_data <- crime_data %>%
  group_by(Division) %>%
  summarise(VarianceInHours = var(OccurHour, na.rm = TRUE),
            MonthlyCrimeCount = n())

# Linear Regression: Variance in Hours ~ Monthly Crime Count
model2 <- lm(VarianceInHours ~ MonthlyCrimeCount, data = variance_data)
summary(model2)

# Diagnostics for Model 2
par(mfrow = c(2, 2))
plot(model2)

# Visualization: Variance in Timing vs Monthly Crime Counts
ggplot(variance_data, aes(x = MonthlyCrimeCount, y = VarianceInHours)) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ x, color = "red", se = FALSE) +
  labs(title = "Variance in Crime Timing vs Monthly Crime Counts",
       x = "Monthly Crime Counts", y = "Variance in Timing")

# MV Regression with RAExperiment$Days (Optional Advanced Step)
mv_model <- lm(Days ~ OccurHour + Division + CrimeCategory, data = crime_data)
summary(mv_model)

# Cross-Validation for MV Regression
cv_mv_model <- train(Days ~ OccurHour + Division + CrimeCategory, data = crime_data, method = "lm", trControl = train_control)
print(cv_mv_model)

# Hypothesis Testing: ANOVA
anova_result <- aov(OccurHour ~ Division, data = crime_data)
summary(anova_result)

# Tukey Post-Hoc Test
tukey_result <- TukeyHSD(anova_result)
print(tukey_result)

# Step 7: Confidence Intervals and Predictions
# Confidence Intervals for Regression Coefficients
confint(model1)
confint(model2)
confint(mv_model)

# Predictions
new_months <- data.frame(ReportMonth = c(13, 14, 15))
predictions <- predict(model1, newdata = new_months, interval = "confidence")
print(predictions)

new_data_mv <- data.frame(OccurHour = c(10, 12, 14), Division = c("D1", "D2", "D3"), CrimeCategory = c("Assault", "Theft", "Robbery"))
predictions_mv <- predict(mv_model, newdata = new_data_mv, interval = "confidence")
print(predictions_mv)
