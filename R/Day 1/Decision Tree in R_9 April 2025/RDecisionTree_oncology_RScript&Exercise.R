## R-HTA in LMICS Chapter 
## 2025 R Foundations workshop DAY 1 | 9 April 2025

#Decision tree model for breast cancer treatment using R software

## Decision problem: Predict the proportion of patients that will need to undergo the various 
## breast cancer treatment based on the characteristics in the data set (e.g. cancer stage, cancer receptor status, HIV Status
##                         and type of healthcare access: private /public)

## Step 1. Install & Load Required Packages
install.packages("rpart")
install.packages("rpart.plot")

# If you already have the packages installed, just recall them
library(rpart)
library(rpart.plot)


## 2. Simulate Sample Data (If you have access to real data, import for use here) 
set.seed(123)
n <- 200

#Set your simulated data in a table
oncology_data <- data.frame(
  stage = sample(c("I", "II", "III", "IV"), n, replace = TRUE),
  ER_status = sample(c("Positive", "Negative"), n, replace = TRUE), #ER = Estrogen receptor in breast cancer.
  HER2_status = sample(c("Positive", "Negative"), n, replace = TRUE), #HER2 is a protein that helps breast cancer cells grow quickly. 
  HIV_status = sample(c("Positive", "Negative"), n, replace = TRUE),
  sector = sample(c("Public", "Private"), n, replace = TRUE),
  age = sample(40:75, n, replace = TRUE)
)

# Define treatment based on simple rules (for training purpose)
oncology_data$treatment <- with(oncology_data, ifelse(
  stage %in% c("I", "II") & ER_status == "Positive", "Hormonal_Therapy",
  ifelse(stage == "III", "Chemo_Radio", "Palliative")
))
oncology_data$treatment <- as.factor(oncology_data$treatment)


## 3. Fit Decision Tree Model
tree_model <- rpart(
  treatment ~ stage + ER_status + HER2_status + HIV_status + sector + age,
  data = oncology_data,
  method = "class"  # classification tree
)


## 4. Plot the Tree
rpart.plot(tree_model, type = 3, extra = 100, fallen.leaves = TRUE,
           main = "Oncology treatment decision tree")
#type = 3: labels on all nodes
#extra = 100: shows probabilities + class
#fallen.leaves = TRUE: neat layout

##5. Evaluate Model (Optional)
# Predict on training data
preds <- predict(tree_model, type = "class")

# Confusion matrix
table(Predicted = preds, Actual = oncology_data$treatment)


####################################################################

## Decision Tree Exercise 
#Q1. Set the sample size to 300 
#Q2. Change the tree model type to 2 or 5. What happens to the structure of the tree? 
#Q3. Change extra to 101. How many patients are in palliative care (Hint: numerical number)?
#Q4. Remove the neat layout of the decision tree (Hint: opposite of TRUE)
#Q5: Change the title of the decision tree to 'Decision Tree for Breast Cancer Treatment'

