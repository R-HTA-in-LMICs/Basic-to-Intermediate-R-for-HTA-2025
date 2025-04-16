# Drugs.com is an online pharmaceutical encyclopedia that provides drug information for consumers
# and healthcare professionals, primarily in the United States.
#_________________Load packages

library(rvest) #for web scraping
library(dplyr) #for data management
library(scales) #for Vis 
library(ggplot2) #for Vis


#web scraping process: "Identify target site" → "Extract data" → "Clean and process data" → "Analyze"

# "Identify target site" : take a look to the target website and global structture around the price guide
# we will focus on drugs list with alphabet letters, get all related drugs then for each drug get all drugs details

#__________________  1) Extract data
#==================

{
# main function to use : read_html() , html_nodes() , html_attr(), html_text()
# ------- 1.1) Page 1: Get all lists of drugs 
{
# Base URL
target_site_url <- "https://www.drugs.com/price-guide"
# read the HTML content of the webpage into R.
main_page_html <- read_html(target_site_url)
main_page_html

# Extract drug links and names
# ✨The %>% operator, known as the pipe in R, 
# simplifies code by allowing you to chain multiple functions together 
#==> passing the result of one step directly into the next
# without the need to create intermediate variables at each stage.

drug_links_1 <- main_page_html %>%
  # html_nodes(...): Find the right section of the HTML:Tells R where in the HTML to look
  html_nodes("div.ddc-grid div.ddc-grid-col-6 li a") %>% #ul
  # html_attr("href"): Extract the URL links of each drug (inside the href attribute).
  html_attr("href") %>%
  na.omit()

drug_links_1

drug_names_1 <- main_page_html %>%
  html_nodes("div.ddc-grid div.ddc-grid-col-6 li a") %>%
  # html_text(): Instead of links, we now extract the text you see
  html_text() %>%
  # trimws(): Removes extra spaces.
  trimws()
# need all list names in order to automate the process after
drug_names_1
# Convert relative links to full URLs
# base_url="https://www.drugs.com"
# drug_links <- paste0(base_url, drug_links_1)

# Store in dataframe# Store in drug_links_1dataframe
lists_drug_data <- data.frame(Drug = drug_names_1, URL = drug_links_1, stringsAsFactors = FALSE)

}
# ------- 1.2) Page 2 : For each list get all related drugs 
  
# Standalone Example of a getting all drugs related to a given list 
{
druglistpage_exple <- "https://www.drugs.com/price-guide-d1.html"

# Read the HTML content into rvest
# test2 <- "https://www.drugs.com/alpha/i.html"
druglistpage_html <- read_html(druglistpage_exple)

# Extract the names and links (href attributes)
drug_links_2 <- druglistpage_html %>%
  html_nodes("ul.ddc-list-column-2 a") %>%
  html_attr("href")

drug_links_2
drug_names_2 <- druglistpage_html %>%
  html_nodes("ul.ddc-list-column-2 a") %>%
  html_text()

drug_links_2
# Combine the names and links in a data frame
data_ex <- data.frame(Name = drug_names_2, Link = drug_links_2)

# View the data
View(data_ex)

} 

#**** turn into function
get_all_drugs_from_list <- function(Drug_list){
  
  base_url <- "https://www.drugs.com/"
  list_complete_URL <- paste0(base_url,Drug_list)
  
  # Read the HTML content into rvest
  # test2 <- "https://www.drugs.com/alpha/i.html"
  druglistpage_html <- read_html(list_complete_URL)
  
  # Extract the names and links (href attributes)
  drug_links_2 <- druglistpage_html %>%
    html_nodes("ul.ddc-list-column-2 a") %>%
    html_attr("href")
  
  drug_names_2 <- druglistpage_html %>%
    html_nodes("ul.ddc-list-column-2 a") %>%
    html_text()
  
  # Combine the names and links in a data frame
  df_all_drugs<- data.frame(Name = drug_names_2, Link = drug_links_2)
  
  # View the data
  return(df_all_drugs)
  
}
get_all_drugs_from_list("price-guide-d2.html") 

#**** Apply the function to all lists to get all drug names
{
All_drugs <-purrr::map(lists_drug_data$URL[1:3],
                     get_all_drugs_from_list)

All_drugs_final <-  do.call(rbind, All_drugs)
View(All_drugs_final)

# save(All_drugs_final, file = "All_drugs_final.RData")
load("All_drugs_final.RData")
}
#------- 1.3) Page 3 : Now for each drug get all available related drugs and their prices 

#**** Standalone Example
{	
drug_url <- "https://www.drugs.com/price-guide/abilify"
# Read the webpage
drug_html_content <- read_html(drug_url)
# Extract drug names, all details of the two parts 
drug_names_part1  <- drug_html_content %>%
  html_nodes("span.ddc-grid-col-7 b") %>%
  html_text()
drug_names_part2 <- drug_html_content %>%
  html_nodes("span.ddc-grid-col-7 p") %>%
  html_text()

drug_names_part1
drug_names_part2

drug_full_name <- paste(drug_names_part1,drug_names_part2,sep = ", ")
drug_full_name
# Extract drug prices
drug_prices <- drug_html_content %>%
  html_nodes("span.ddc-grid-col-5 b") %>%
  html_text()

drug_prices

# Create a data frame
drug_data <- data.frame(
  Drug = drug_full_name,
  Price = drug_prices,
  stringsAsFactors = FALSE
)
# Print the result
print(drug_data)

}
#**** Turn into function
Get_Drug_Details <-  function (drug_general_name,drug_link){
  # drug_general_name = lists_drug_data$Drug[39]
  # drug_link= lists_drug_data$URL[39]
  base_url <- "https://www.drugs.com/"
  
  drug_url <- paste0(base_url,drug_link)
  
  webpage_html_content <- read_html(drug_url)
  # Extract drug names (first <td> in each row)
  drug_names_part1  <- webpage_html_content %>%
    html_nodes("span.ddc-grid-col-7 b") %>%
    html_text()
  drug_names_part2 <- webpage_html_content %>%
    html_nodes("span.ddc-grid-col-7 p") %>%
    html_text()
  
  drug_full_name <- paste(drug_names_part1,drug_names_part2,sep = ", ")
  # Extract drug prices
  drug_prices <- webpage_html_content %>%
    html_nodes("span.ddc-grid-col-5 b") %>%
    html_text()
  
  # Create a data frame
  drug_data <- data.frame(
    Drug_base_name= drug_general_name,
    Drug = drug_full_name,
    Price = drug_prices,
    stringsAsFactors = FALSE
  )
  
  # Print the result
  # print(drug_data)
  return(drug_data)
  
}


Get_Drug_Details("Abecma","/price-guide/abecma")

#**** Apply the function to all lists
All_drugs_details <- purrr::map2(All_drugs_final$Name[1:10], 
                          All_drugs_final$Link[1:10],
                          Get_Drug_Details)
All_drugs_details_df <- do.call(rbind, All_drugs_details)

# save(All_drugs_details_df, file = "All_drugs_details_df.RData")

}
#__________________ 2) Clean and process data
#==================

{
load("All_drugs_details_df.RData")
  View(All_drugs_details_df)
All_drugs_details_df$Price <- gsub("$","",All_drugs_details_df$Price,fixed = T)
All_drugs_details_df$Price <- gsub(",","",All_drugs_details_df$Price,fixed = T)
All_drugs_details_df$Price <- as.numeric(All_drugs_details_df$Price)
# 
# All_drugs_details_df <- All_drugs_details_df %>% 
#   mutate(Price=as.numeric(Price))

 } 
#__________________ 3) Analyze
#==================

{
#*** exemple vis 1 :The barplot of average prices helps compare the typical cost of each drug base name, 
#* highlighting overall pricing trend.
#* By integrating variants number: This helps analyze whether drugs with more versions tend to have higher or lower average prices.

df_avg <- All_drugs_details_df %>%
  group_by(Drug_base_name) %>%
  summarise(avg_price = mean(Price), num_variants = n()) %>% #num_variants :  counts how many different drug variants exist under each Drug_base_name in
  # previous df
  ungroup() %>% 
  # order by avg price 
  arrange(desc(avg_price)) %>% 
  head(15)

df_avg

ggplot(df_avg, aes(x = Drug_base_name, y = avg_price, fill = num_variants)) +
  geom_bar(stat = "identity", show.legend = FALSE) +  # Bars
  geom_text(aes(label = num_variants, y = avg_price + 5),  # Labels above bars
            vjust = 0, size = 5, fontface = "bold") +
  labs(title = "Top Average Price by Base Drug and Number of Variants", 
       x = "Base Drug", y = "Average Price") +
  scale_y_continuous(labels = comma) +  # Format large numbers
  theme_minimal()

# We map num_variants to the fill aesthetic to visually differentiate the bars based on the number of variants.
# This allows us to see if drugs with more variants tend to have higher/lower average prices.
# The color intensity will change based on num_variants
#==> it seems hat drugs with top prices tend to have no variants .

#**** Vis 2 : Boxplot for drugs having many variantes > 15
#*The boxplot reveals price variability and outliers, showing how consistent or inconsistent drug 
# prices are across different variations

All_drugs_details_df_many_variante <- All_drugs_details_df %>% 
  group_by(Drug_base_name) %>% 
  add_count(Drug_base_name) %>% 
  filter (n>=15)

View(All_drugs_details_df_many_variante)

ggplot(All_drugs_details_df_many_variante, aes(x = Drug_base_name, y = Price, fill = Drug_base_name)) +
  geom_boxplot(alpha = 0.6) +
  labs(title = "Price Variation of Drugs with many variants by Base Name",
       x = "Base Drug Name", y = "Price") +
  theme_minimal() +
  theme(legend.position = "none")

# some interpretations

# If the line is in the middle of the box => The data is symmetrically distributed (balanced around the median).
# If the line is closer to the bottom of the box => The data is right-skewed (more lower values, few high values).
# If the line is closer to the top of the box => The data is left-skewed (more higher values, few low values).
# 
# ==> for HTA context: interpretation
# If a drug's median price is too high, it might indicate affordability issues.
# If prices have a high spread (large IQR), it suggests price inconsistency across variations.
# If there are many outliers, it could indicate price fluctuations in different markets or suppliers.

# "The interquartile range (IQR) contains the second and third quartiles, or the middle half of your data set."
# Small Box (Low IQR)	Prices are stable and consistent.
# Large Box (High IQR)	Big differences in drug prices; price inconsistency.
# Whiskers Very Long	Some variations are much more expensive than others.
# Many Outliers	Some prices are unusually high/low, requiring further investigation.

# so
# Policy makers can investigate why some variations are much more expensive.
# Hospitals & insurance can decide which versions of a drug provide the best cost-effectiveness.
# Regulatory bodies can check if high prices are justified or due to market inefficiencies.
}