# =======================================================
#  BREAKOUT SESSION – EXERCISE 1 SOLUTIONS
# =======================================================

# ========================================================== 
#____________________Group Work 1
# ==========================================================  

# -------------------------------------------------------
#  Task 1: Basic R Syntax
# -------------------------------------------------------

# 1.1 Define two vectors of same length
devices <- c("MRI", "CT Scan", "X-ray", "Ultrasound", "ECG")
costs <- c(3000, 2500, 500, 1000, 200)

# 1.2 Create a variable 'sum_costs' containing the sum of all costs
sum_costs <- sum(costs)

# 1.3 Find the most expensive device using which.max()
most_expensive <- devices[which.max(costs)]

# ✅ Alternative using which() and max()
# most_expensive <- devices[which(costs == max(costs))]

# Print the most expensive device
print(most_expensive)

# -------------------------------------------------------
#  Task 2: Using dplyr and Base R Functions
# -------------------------------------------------------

# 2.1 Move the column "disp" to the last position in mtcars
mtcars_V1 <- dplyr::relocate(mtcars, disp, .after = dplyr::last_col())

# 2.2 Move the column "hp" to the first position
mtcars_V2 <- dplyr::relocate(mtcars, hp)

# 2.3 Replace "$" with a space using gsub in the string "30,4$"
gsub("$", " ", "30,4$", fixed = TRUE) #fixed = TRUE to not interpret the $ as a reg exp


# ========================================================== 
#____________________Group Work 2 
# ==========================================================  

# -------------------------------------------------------
#  Task 3: Customised Functions
# -------------------------------------------------------

# 3.1 Function that prints weight, height, and BMI

calculate_bmi <- function(weight_kg, height_m) {
  if (height_m <= 0) {
    return("Height must be greater than zero")
  }
  
  bmi <- weight_kg / (height_m^2)
  bmi <- round(bmi, 2)
  
  output <- paste0("Weight is: ", weight_kg, "Kg\n",
                   "Height is: ", height_m, "M\n",
                   "BMI is: ", bmi)
  
  return(cat(output))
}

# ✅ Example usage
calculate_bmi(70, 1.75)

# 3.2 Function that also includes health status based on BMI
calculate_bmi_v1 <- function(weight_kg, height_m) {
  if (height_m <= 0) {
    return("Height must be greater than zero")
  }
  
  bmi <- weight_kg / (height_m^2)
  bmi <- round(bmi, 2)
  
  # Classify health status
  if (bmi < 18.5) {
    status <- "Underweight"
  } else if (bmi < 25) {
    status <- "Normal weight"
  } else if (bmi < 30) {
    status <- "Overweight"
  } else {
    status <- "Obese"
  }
  
  output <- paste0("BMI is: ", bmi, "\n", "Status: ", status)
  return(cat(output))
}

# ✅ Example usage
calculate_bmi_v1(70, 1.75)
