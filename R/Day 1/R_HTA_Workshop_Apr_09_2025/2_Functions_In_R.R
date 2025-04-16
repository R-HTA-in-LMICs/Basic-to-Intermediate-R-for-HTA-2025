#___________ 1) Built-in Functions:

{
my_vector_of_values <- c(2,4,5,6,10)
sum(my_vector_of_values)
mean(my_vector_of_values)
substr("145 Hello",1,3) #on char
nchar("how many char in this string") #on char
?gsub
gsub("a", "@", "Data Analysis") #on char
mychar <- "Data Analysis"
gsub("^", "-", mychar) 
gsub("is$", "**", mychar) 
# Regular expressions(like ^ , $) are patterns used to match character combinations in strings:
# commonly used for text matching, extraction, and replacement in strings
# Define a vector of medical procedure codes
procedures <- c("MRI-001", "MRI-002", "CT-101", "XRAY-200", "MRI-003", "ECG-500")

# Use regex to filter MRI-related procedures
mri_procedures <- grep("^MRI-", procedures) #value = TRUE)

# Print result
print(mri_procedures)
# functtion on df 
subset(mtcars, cyl == 4) #on df
}
#___________ 2) Package Functions:

{# loading Functions from packages, the ‘::” operator if you need one function and load all using library if you need many
# Import the whole library vs using import specific function
  
# Ex1 fread function from data.table

data.table::fread("large_file.csv")
# relocate function from dplyr
# --- Moving a Column After Another Column: If you want to move mpg after hp

dplyr::relocate(mtcars, mpg, .after = hp)
#print vs store into an object 
a_new_df <- dplyr::relocate(mtcars, mpg, .after = hp)

a_new_df <- dplyr::relocate(mtcars, mpg, .before = 4)
# --- Example: Moving a Column to the Last Position

a_new_df <- dplyr::relocate(mtcars, mpg, .after = dplyr::last_col())
}

#___________ 3) Custom Functions:

{  
# Define a function to calculate BMI (Body Mass Index)
# 1 - Desciption function name : calculate_bmi
# 2 - input arguments : weight_kg, height_m  ==> controling the output of the fct


calculate_bmi <- function(weight_kg, height_m) {
  #3 - Body of the function : represents all the code to be used internally (hidden by the wrapper of the function)
  # if (weight_kg <= 0 | height_m <= 0) {
  #   return("Height & Weight must be greater than zero")
  # }

  bmi <- weight_kg / (height_m^2)  # BMI formula
  # bmi <- round(bmi, 2)
  output <- paste0("BMI is: ",bmi ) #\n
  #  last part of a function is the returns: wher the function stop and return 
  # 4-  Returns: what the function return, visible effect or silent effect (file, object) 
  # it either return things : print or does thing
  return(output) #cat(output)
}

# Example usage:
# Weight = 70kg, Height = 1.75m 
calculate_bmi(weight_kg = 60,height_m =  1.75) 
calculate_bmi(70, 1.76)
# calculate_bmi(0, 1.9)
}