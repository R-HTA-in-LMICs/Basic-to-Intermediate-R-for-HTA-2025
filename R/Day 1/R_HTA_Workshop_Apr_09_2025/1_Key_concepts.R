
# ----------- Syntax: dictates how we create and manipulate objects.
{
# Assignment: 
x <- 10   # Preferred assignment operator
y = 20    # Also valid but less commonly used in some cases
char_var <- "hello" # Character data types in R are essential for handling text-based information 

# Example data: QALYs for a group of patients
qaly_values <- c(5.2, 6.1, 7.8, 4.9, 6.5)


# Calculate the average QALY
mean_qaly <- mean(qaly_values)
print(mean_qaly)

# Function Calls & documentation: ?function name

#when you want learn more about a function (argument, options) or a dataset : ?
?mean


# Conditional Statements:
# R uses if, else if, and else
# to control the flow of logic based on conditions: allowing 
# the code to react differently depending on the data

x= 4
if (x > 5) {
  print("x is greater than 5")
} else{
  print("x is lower than 5")
 }

View(mtcars)

# ifelse() is a vectorized conditional function in R that checks a condition for each element in a vector and returns a value accordingly:
# ideal for applying logic across entire datasets.
ifelse(mtcars$mpg > 20, "High", "Low") 
#you can store the output above in a new column 
mtcars$newcol <- ifelse(mtcars$mpg > 20, "High", "Low") 
 mtcars
# which(): Get indices of TRUE values. 
which(mtcars$cyl == 6)

which.min(mtcars$mpg)
which.max(mtcars$mpg)

mtcars$mpg[20]
# to select the column from a dataframe
max(mtcars$mpg)

# Loops: 
# for loop uses for (i in sequence) { ... } to repeat code over elements
for (i in 1:5) {
  print(i)
  # print(paste("the index is : ",i ))
}



# Vectorized Operations
x <- c(1, 2, 3)
y <- x * 2  # Each element is multiplied by 2
print(y)
}
# ----------- Data Structures: determine how data is organized and accessed.
{
# Vectors: 1D collection of elements of the same type 

vect1 <- c(1, 2, 3, 4)  # Numeric vector
vect2 <- c("hello1","hello2","hello3")

# 	Matrices: 2D arrays with the same data type 
mat <- matrix(1:9, nrow = 3, ncol = 3)
mat
# lists :Collection of mixed data types 
my_list  <- list(name = "John", age = 30, scores = c(90, 85, 88))

# Data Frames: Tabular structure (like spreadsheets) 

my_df <- data.frame(Name = c("Alice", "Bob"), Age = c(25, 30))

nrow(my_df) #rows number
ncol(my_df) #columns number
# get values of a given column using $
my_df$Age

# add row
# my_df= rbind (my_df, c("John","40"))
# View(my_df)
# add a column
# cbind(my_df,gender=c("F","M","M")) 


# select Data Frame by rows /columns
View (mtcars)
mtcars_rows <- mtcars[c(1:10),] 
mtcars_cols <- mtcars[,c(1:3)] #by column names c("mpg",  "cyl"  ,"disp"
#get the names of columns
names(mtcars)

# Select columns mpg , gear, carb and the rows one to 5, 
# row 7 and the row number 9 to 12

# Factors: Used for categorical variables 
gender <- factor(c("Male", "Female", "Male"))
gender

}
# ----------- Objects store and represent data structures in memory. workspace, objects, source()
{

#Get the current working directory  
getwd()
#Set the current working directory with setwd(‘Path/To/Your/Folder’).
setwd("path/Folder")

#Basic way to structure our code 
source("my_base_script.R")
var1

# save one object
# save(df,file = "df.RData")
# load("df.RData")

# save all objects
# save.image(file="m_all_object.RData")
# load("m__all_object.RData")

#file.exists("Path/to/file_name")
}
