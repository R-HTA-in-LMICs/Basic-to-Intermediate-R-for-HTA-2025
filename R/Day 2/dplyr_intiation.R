
# --------------------------------------------------------------------------------------------------------------
# --------------        Introduction to data manipulation in R using the dplyr    ---------------------------------
# --------------------------------------------------------------------------------------------------------------



# Load necessary libraries
library(dplyr)

# -------------------------------understand %>%  

# CTRL + SHIFT + M, is used in RStudio to quickly insert the pipe operator (%>%).
# pipe operator (%>%) in R, primarily from the dplyr package, allows you to pass
# the result of one function directly into the next function, making your code more 
# readable and concise by chaining operations.

# ------------------------------- Example:

# Create a simple dataframe
df <- data.frame(
  ID = 1:5,
  Age = c(25, 30, 35, 40, 45),
  Score = c(80, 85, 90, 95, 100)
)
print(df)

# Without pipe: Nested function calls or creation of many variables seq
result <- sum(sqrt(df$Score[df$Age > 30]))

print(result)
# or : many code operations & variables creation
var1 <- df$Score[df$Age > 30]
var2 <- sqrt(var1)
result <- sum(var2)
print(result)


# With pipe: Chaining operations : more clear , readable , efficient 
result <- df %>%
  filter(Age > 30) %>%  # Filter rows where Age > 30
  pull(Score) %>%       # Extract the Score column
  sqrt() %>%            # Apply sqrt() to the Score values
  sum()                 # Sum the square roots

print(result)

# -------------------------------


# Sample data: in hta context
# Each row represents a technology evaluated
hta_data <- data.frame(
  Technology = c("Drug A", "Drug B", "Device X", "Procedure Y"),
  Cost = c(5000, 7000, 12000, 4000),             # in USD
  QALY_Gain = c(1.2, 1.5, 2.0, 0.8),             # Quality-Adjusted Life Years
  Effectiveness_Score = c(85, 90, 92, 70)        # From 0 to 100
)
# QALY: Quality-Adjusted Life Years: A measure that combines both quantity and quality of life.
# 1 QALY = 1 year of life in perfect health.
# QALY Gain tells us how much healthier life a treatment provides.
# QALY gain represents the total health benefit (in QALY) gained from a treatment
# or intervention. It combines both the length of life and the quality of that
# life over time.

print(hta_data)

# -------------------------------
# 1. mutate(): Create new columns or transform specific columns

hta_data <- hta_data %>%
  # The Cost-Effectiveness Ratio (CER) can be used to compare 
  # treatments by measuring cost per unit of health gain (like QALY).
  mutate(
    CER = Cost / QALY_Gain  # Cost-Effectiveness Ratio
  )
print(hta_data)

# -------------------------------
# relocate:reorder the columns 
# of a data frame by moving specified columns to a new position.

hta_data <- hta_data %>%
  relocate(CER,.after = QALY_Gain)

print(hta_data)


# -------------------------------
# 2. mutate_at(): Apply a transformation to specific columns

# Example: convert scores from 0-100 to a 0-1 scale for selected variables
hta_data <- hta_data %>%
  # For the column Effectiveness_Score, divide its values by 100.
  mutate_at(
    vars(Effectiveness_Score),  ~ . / 100 
  )
print(hta_data)

# ~ means: “Apply the following expression to each element or column.”
#  The dot . represents the current item (like a column or set columns)

# -------------------------------
# 3. mutate_all(): Apply a transformation to all numeric columns
# select() : to select columns by index or name or to unselect using - 

# select(-Technology) removes colimn 'Technology' the character column
# First, exclude the character column 'Technology'
hta_data_transformed <- hta_data %>%
  select(-Technology) %>%           # Remove the text column temporarily
  mutate_all(~ . * 10)            # Multiply all columns by 10
  
print(hta_data_transformed)

# -------------------------------
#4. group_by() function is used to split your data into groups based on one or more columns.
# It is typically used before summarizing or mutating, so you can apply calculations 
# within each group!


# Add a new column: Technology_Type
final_hta_data <- hta_data_transformed %>%
  mutate(
    Technology_Type = c("Drug", "Drug", "Device", "Procedure")
  )

print(final_hta_data)
# Group by Technology_Type and calculate average cost and average QALY
hta_summary <- final_hta_data %>%
  group_by(Technology_Type) %>%
  # summarise() reduces multiple rows into a single summary row,
  # either per group (when used with group_by()) or for the entire dataset.
  mutate( #explore the diff between summarize and mutate here
    Avg_Cost = mean(Cost),
    Avg_QALY = mean(QALY_Gain),
    Max_Effectiveness = max(Effectiveness_Score)
  )
print(hta_summary)

# other functions of dplyr ex
# ?case_when
