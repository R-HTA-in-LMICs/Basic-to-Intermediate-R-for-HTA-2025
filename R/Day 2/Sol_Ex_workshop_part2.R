
# ========================================================== 
#____________________Group Work 
# ==========================================================  

# ============================================================================
# EXERCISE 2 – Web Scraping Drug Variants and Prices from drugs.com
# ============================================================================

# ------------------------------------------------
#  Load Required Libraries
# ------------------------------------------------
library(rvest)   # For web scraping
library(dplyr)   # For data manipulation

# ------------------------------------------------
#  Task 2.1 – Run and Understand the Code Below
# ------------------------------------------------
# This block extracts drug variant names and their corresponding prices
# from the page of Isosorbide Mononitrate

drug_url <- "https://www.drugs.com/price-guide/isosorbide-mononitrate"

# Read the webpage
drug_html_content <- read_html(drug_url)

# Extract part 1 of drug names (e.g., brand/form)
drug_names_part1 <- drug_html_content %>%
  html_nodes("span.ddc-grid-col-7 b") %>%
  html_text()

# Extract part 2 of drug names (e.g., dose/form details)
drug_names_part2 <- drug_html_content %>%
  html_nodes("span.ddc-grid-col-7 p") %>%
  html_text()

# Combine both parts into full variant names
drug_full_name <- paste(drug_names_part1, drug_names_part2, sep = ", ")

# Extract drug prices
drug_prices <- drug_html_content %>%
  html_nodes("span.ddc-grid-col-5 b") %>%
  html_text()

# to get other prices details
# drug_prices2 <- drug_html_content %>%
#   html_nodes("span.ddc-grid-col-5 p") %>%
#   html_text()
# drug_prices_det <- paste(drug_prices, drug_prices2, sep = ", ")

# Create a data frame with the extracted data
drug_data <- data.frame(
  Drug = drug_full_name,
  Price = drug_prices,
  stringsAsFactors = FALSE
)

# Display the results
print(drug_data)

# ------------------------------------------------
# 🔁 Task 2.2 – Test with Another Drug
# ------------------------------------------------
# Pick a drug from this list: https://www.drugs.com/price-guide-d1.html
# Replace the value of `drug_url` above to test with another drug
# Example:
# drug_url <- "https://www.drugs.com/price-guide/alunbrig"

# ------------------------------------------------
# 🔄 Task 2.3 – Transform into a Reusable Function
# ------------------------------------------------
# Create a function `Get_Drug_Details()` that:
#   - Takes a single argument: drug_name
#   - Reuses the logic above to extract drug variant names and prices
#   - Returns a data frame with columns: 'Drug' and 'Price'

# Function Definition
Get_Drug_Details <- function(drug_name) {
  
  Base_Url <- "https://www.drugs.com/price-guide/"
  # drug_url : Base_Url + drugname
  drug_url<- paste0(Base_Url,drug_name)
  
  # Read HTML content of the page
  webpage_html_content <- read_html(drug_url)
  
  # Extract both parts of the drug name
  drug_names_part1 <- webpage_html_content %>%
    html_nodes("span.ddc-grid-col-7 b") %>%
    html_text()
  
  drug_names_part2 <- webpage_html_content %>%
    html_nodes("span.ddc-grid-col-7 p") %>%
    html_text()
  
  drug_full_name <- paste(drug_names_part1, drug_names_part2, sep = ", ")
  
  # Extract prices
  drug_prices <- webpage_html_content %>%
    html_nodes("span.ddc-grid-col-5 b") %>%
    html_text()
  
  # Create the result dataframe
  drug_data <- data.frame(
    Drug = drug_full_name,
    Price = drug_prices,
    stringsAsFactors = FALSE
  )
  
  return(drug_data)
}

# ------------------------------------------------
# – Test the Function
# ------------------------------------------------
# Call the function with different drug names

Get_Drug_Details("alunbrig")

# ------------------------------------------------
# 🔄 Task 2.4 – Export the Extracted Data to CSV
# ------------------------------------------------
# Use the function to get the data, and then export it to a CSV file
# Replace the URL and filename as needed

drug_df <- Get_Drug_Details("alunbrig")

# Export to CSV
write.csv(drug_df, file = "alunbrig_prices.csv", row.names = FALSE)

# Check your working directory to find the saved file!
getwd()
