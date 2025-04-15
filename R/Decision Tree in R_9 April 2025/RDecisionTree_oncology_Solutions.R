## R-HTA in LMICS Chapter 
##2025 R Foundations workshop DAY 1 | 9 April 2025


## Decision Tree Exercise 
#Q1. Set the sample size to 300 
#Q2. Change the tree model 'type' to 2 or 5. What happens to the structure of the tree? 
#Q3. Change extra to 101. How many patients are in palliative care (Hint: numerical number)?
#Q4. Remove the neat layout of the decision tree (Hint: opposite of TRUE)
#Q5: Change the name title of the decision tree to 'Decision Tree for Breast Cancer Treatment'

##############################

#Decision Tree Solutions
#Solution 1:
n <- 300

#Solution 2: 
#Plot if type = 2
rpart.plot(tree_model, type = 2, extra = 100, fallen.leaves = TRUE,
           main = "Oncology treatment decision tree")

#Plot if type = 5
rpart.plot(tree_model, type = 5, extra = 100, fallen.leaves = TRUE,
           main = "Oncology treatment decision tree")

# Solution 3 
rpart.plot(tree_model, type = 3, extra = 101, fallen.leaves = TRUE,
           main = "Oncology treatment decision tree")

#Solution 4
rpart.plot(tree_model, type = 3, extra = 100, fallen.leaves = FALSE,
           main = "Oncology treatment decision tree")
#Solution 5
rpart.plot(tree_model, type = 3, extra = 101, fallen.leaves = FALSE,
           main = "Decision Tree for Breast Cancer Treatment")
# Total breast cancer patients that ended up in Palliative care = 140 
