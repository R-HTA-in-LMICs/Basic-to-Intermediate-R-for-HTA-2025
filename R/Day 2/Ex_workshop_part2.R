

    # ================================================================
    #  EXERCISE – Web Scraping: Drug Variants and Prices (Beginner)
    # ================================================================
    
    # ------------------------------------------------
    #  Step 0: Load Required Libraries
    # ------------------------------------------------
    # These packages are needed for web scraping and data manipulation
    library(rvest)   # Web scraping
    library(dplyr)   # Data wrangling
    
    # ------------------------------------------------
    #  Task 2.1 – Understand the Example Code
    # ------------------------------------------------
    
    # Below is a working example to extract drug names and prices 
    # from the page for "Isosorbide Mononitrate"
    # Run each block and observe the output to understand what it does
    
    # Define the URL of the drug page
    drug_url <- "https://www.drugs.com/price-guide/isosorbide-mononitrate"
    
    # Read the HTML content of the webpage
    drug_html_content <- read_html(drug_url)
    
    # Extract the first part of the drug names (variant names)
    drug_names_part1  <- drug_html_content %>%
      html_nodes("span.ddc-grid-col-7 b") %>%
      html_text()
    
    print(drug_names_part1)  # Show extracted variant names
    
    # Extract the second part of the drug details (dose, form)
    drug_names_part2 <- drug_html_content %>%
      html_nodes("span.ddc-grid-col-7 p") %>%
      html_text()
    
    print(drug_names_part2)  # Show additional details
    
    # Combine the two parts to get full drug names
    drug_full_name <- paste(drug_names_part1, drug_names_part2, sep = ", ")
    
    print(drug_full_name)  # Show full names
    
    # Extract the prices for each variant
    drug_prices <- drug_html_content %>%
      html_nodes("span.ddc-grid-col-5 b") %>%
      html_text()
    
    print(drug_prices)  # Show prices
    
    # Create a data frame combining names and prices
    drug_data <- data.frame(
      Drug = drug_full_name,
      Price = drug_prices,
      stringsAsFactors = FALSE
    )
    
    # Display the final result
    print(drug_data)
    
    # ------------------------------------------------
    #  Task 2.2 – Test with Another Drug
    # ------------------------------------------------
    # Go to: https://www.drugs.com/price-guide-d1.html
    # ✅ Choose any other drug from the list (e.g., Alunbrig, Demerol, etc.)
    # 🛠️ Replace the drug_url value below with the URL of your chosen drug
    # Then re-run the full script to see the results for your new drug
    
    # Example:
    # drug_url <- "https://www.drugs.com/price-guide/alunbrig"
    
    # ------------------------------------------------
    # ✅ Task 2.3 – Transform into a Reusable Function
    # ------------------------------------------------
    
    # YOUR TASK: Create a function named Get_Drug_Details()
    # ------------------------------------------------
    # Objective: Reuse the same logic as above to extract drug variants + prices for a given drug name
    # What you should do:
    #   - Create a new function called Get_Drug_Details
    #   - It should take one argument: drug_name
    #   - Inside the function,use the same steps from above (read HTML, extract, combine, return)
    #   - The function should return a dataframe with 2 columns: Drug and Price
    
    
    # Function definition :
    
    Get_Drug_Details <- # Your code goes here
    
    
    # ------------------------------------------------
    # Test Your Function
    # ------------------------------------------------
    #  After creating the function, test it using a valid drug name:
    
    # Example test:
    Get_Drug_Details("alunbrig")
    
    # ------------------------------------------------
    #  Task 2.4 – Export the Extracted Data to CSV
    # ------------------------------------------------
    
    # ✅ Now that you can extract drug names and prices using your function,
    # try saving the results into a CSV file.
    
    # Task:
    # 1. Use your function `Get_Drug_Details()` with a drug URL of your choice.
    # 2. Save the returned data frame into a CSV file using an appropriate function.
    
    # Hint:
    # - Use the function `write.csv()` to write the data into a file.
    # - Check the available arguments of the function using `?write.csv`.
    # - Use `getwd()` to find the current working directory where your CSV will be saved.
    
    # Example idea:
    
    # drug_data <- Get_Drug_Details("...")
    # write.csv(...)
    
    # Output: You should find a CSV file in your working directory.
    
    