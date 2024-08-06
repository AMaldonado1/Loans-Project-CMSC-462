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

