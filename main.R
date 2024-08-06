# Data Exploration

# Load Libraries
library(RMySQL)
library(tidyverse)

# Establish connection to Project 3 Loan Database
connection <- dbConnect(MySQL(),
                        port = 3306,
                        user = "root",
                        password = "",
                        host = "localhost",
                        dbname = "proj3")

# Information on the Database
dbGetInfo(connection)
dbListTables(connection)
dbListFields(connection, "lending")

# Data Modeling

# Search and Fetch Query
query <- dbSendQuery(connection, "SELECT loanID, loan_default, loan_amnt, adjusted_annual_inc, months_since_first_credit FROM lending;")
three_parts_data <- dbFetch(query, n=88270)
dbClearResult(query)
min_loan_amnt <- dbGetQuery(connection, "SELECT MIN(loan_amnt) FROM lending;")
max_loan_amnt <- dbGetQuery(connection, "SELECT MAX(loan_amnt) FROM lending;")
avg_loan_amnt <- dbGetQuery(connection, "SELECT AVG(loan_amnt) FROM lending;")
min_annual_income <- dbGetQuery(connection, "SELECT MIN(adjusted_annual_inc) FROM lending;")
max_annual_income <- dbGetQuery(connection, "SELECT MAX(adjusted_annual_inc) FROM lending;")
avg_annual_income <- dbGetQuery(connection, "SELECT AVG(adjusted_annual_inc) FROM lending;")
min_months_since <- dbGetQuery(connection, "SELECT MIN(months_since_first_credit) FROM lending;")
max_months_since <- dbGetQuery(connection, "SELECT MAX(months_since_first_credit) FROM lending;")
avg_months_since <- dbGetQuery(connection, "SELECT AVG(months_since_first_credit) FROM lending;")
dbDisconnect(connection)

# Descriptive Statistical Analysis 

# Descriptive Statistics of the 3 field columns with queries and double check in R
# Gets the Minimum, Median, Mean, and Maximum of the loan amount
print(min_loan_amnt)
min(three_parts_data$loan_amnt)
print(max_loan_amnt)
max(three_parts_data$loan_amnt)
print(avg_loan_amnt)
mean(three_parts_data$loan_amnt)
sd(three_parts_data$loan_amnt)

# Gets the Minimum, Median, Mean, and Maximum of the adjusted annual income
print(min_annual_income)
min(three_parts_data$adjusted_annual_inc)
print(max_annual_income)
max(three_parts_data$adjusted_annual_inc)
print(avg_annual_income)
mean(three_parts_data$adjusted_annual_inc)
sd(three_parts_data$adjusted_annual_inc)

# Gets the Minimum, Median, Mean, and Maximum of the months since first credit
print(min_months_since)
min(three_parts_data$months_since_first_credit)
print(max_months_since)
max(three_parts_data$months_since_first_credit)
print(avg_months_since)
mean(three_parts_data$months_since_first_credit)
sd(three_parts_data$months_since_first_credit)

# Data Visualizations for Descriptive Analysis of Loan Amount

# Graph shows us that a majority of people are within 5000 to 15000 loan amount
ggplot(three_parts_data, aes(x = loan_amnt)) +
  geom_histogram(binwidth = 2500, fill = "darkgreen", color = "black") +
  labs(title = "Frequency Distribution of Loan Amounts", x = "Loan Amount", y = "Count")

# Data Visualizations for Descriptive Analysis of Annual Income

# Remove outliers first though the graph is still not as descriptive as I want it
annual_income_no_outlier <- filter(three_parts_data, adjusted_annual_inc < 2e6)
ggplot(annual_income_no_outlier, aes(x = adjusted_annual_inc)) +
  geom_boxplot(fill = "darkgreen", color = "black") +
  labs(title = "Frequency Distribution of Adjusted Annual Incomes", x = "Adjusted Annual Income", y = "Count")

# Data Visualizations for Descriptive Analysis of Months Since First Credit

# Graph shows us that a majority of people are within 100 to 300 months since first credit
ggplot(three_parts_data, aes(x = months_since_first_credit)) +
  geom_histogram(binwidth = 50, fill = "darkgreen", color = "black") +
  labs(title = "Frequency Distribution of Months Since First Credit", x = "Months Since First Credit", y = "Count")

# Machine Learning

# Multiple regression
multiple_reg_data <- select(three_parts_data, -loanID)

plot(multiple_reg_data)
multiple_reg_loan <- lm(loan_default ~ loan_amnt + adjusted_annual_inc + months_since_first_credit, data = multiple_reg_data)
summary(multiple_reg_loan)

# Naive Bayes
library(caret)
library(e1071)
three_parts_data$loan_default <- factor(three_parts_data$loan_default, levels = c(0,1), labels = c("False", "True"))

# Split the data for training set and the test set
#Creates a series of test/training partitions from Carat
indxTrain <- createDataPartition(y = three_parts_data$loan_default,p = 0.75,list = FALSE)
training <- data[indxTrain,]
testing <- data[-indxTrain,]

# Making the Naive Bayes model
naivebayes_loan <- naiveBayes(loan_default ~ loan_amnt + adjusted_annual_inc + months_since_first_credit, data = training)

# Predict with the testing model
predict <- predict(naivebayes_loan, newdata = testing)
