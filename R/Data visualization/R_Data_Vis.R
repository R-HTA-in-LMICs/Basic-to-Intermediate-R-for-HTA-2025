#####
# R Data Visualization R for HTA in LMICs
#####
# Update: 04/07/2025 by Satoshi Koiso

# 0. Install and load packages --------------------------------------------
if (TRUE) {
  list.of.packages <- c("ggplot2", "dplyr", "tidyr", "scales", "stringr", "rstudioapi")
  new.packages <- list.of.packages[
    !( list.of.packages %in% installed.packages()[,"Package"] )
  ]
  if(length(new.packages)) install.packages(new.packages,
                                            repos = "https://cloud.r-project.org",type = "source")
  lapply(list.of.packages, library, character.only = TRUE)
}

# set the working directory
setwd(dirname(getActiveDocumentContext()$path))

# import data
#!#! Make sure the data file is under the same folder as this Rscript is located !#!#
# read data from a csv file
# Here the data set has the percent of the population with access to ARV by gender of countries from 2001 to 2020 (World Bank)
arv <- read.csv("Supp.WB_DB_Genderstat_ARV_2001-20.csv", header = T, encoding = "UTF-8")
tornado <- read.csv("1.tornado_data.csv") 
heat <- read.csv("2.heatmap_data.csv") 

# check the imported data
str(arv) # str means "structure". This function shows data by column with data types
View(arv) # a new tab will pop up. This is more intuitive and looks similar to MS Excel.


# 1. Histogram ------------------------------------------------------------
# Objective: to understand the distribution of a variable
# Ex. Visualize the the distribution of the number of countries by percentage of females who have access to ARV in the world in 2020

# select data of female in 2020
arv_fe_2020 <- arv[arv$gender=="female" & arv$year == 2020,]

# check the data table structure
str(arv_fe_2020)

# plot
ggplot(data=arv_fe_2020,  # specify the data you want to use
       aes(x=value)) +  # specify the column that you want to show in the x-axis
  # specify the type of your graph
  geom_histogram(
    fill = "grey",  # which color is used to fill the bins
    color = "black",  # which color is used to draw the borders of bins
    bins = 10,      # number of bins
  ) +
  # add title
  ggtitle("Distribution of the percentage of female who have access to anti-retroviral drugs \n in the world in 2020") +  #"\n" means change a line
  # add x-axis label
  xlab("Percentage (%)") +
  # add y-axis label
  ylab("Number of countries") +
  # customize the background theme
  theme_bw()

## y-axis does not make sense because the number of countries would never become a decimal

# plot
ggplot(data=arv_fe_2020,  # specify the data you want to use
       aes(x=value)) +  # specify the column that you want to show in the x-axis
  # specify the type of your graph
  geom_histogram(
    fill = "grey",  # which color is used to fill the bins
    color = "black",  # which color is used to draw the borders of bins
    bins = 10,      # number of bins
  ) +
  scale_y_continuous(breaks = seq(0,14,2))+ # ticks will appear only even integers below 14
  # add title
  ggtitle("Distribution of the percentage of female who have access to anti-retroviral drugs \n in the world in 2020") +  #"\n" means change a line
  # add x-axis label
  xlab("Percentage (%)") +
  # add y-axis label
  ylab("Number of countries") +
  # customize the background theme
  theme_bw()


# save the figure in png
ggsave("hist.png", width = 8, height = 6)


# 2. Bar plot -------------------------------------------------------------
# Objective: to compare numerical values between different groups
# Ex. Visualize the percentage of females who have access to ARV in 2020 by country

# check the data table structure
str(arv_fe_2020)

# plot
ggplot(data=arv_fe_2020, # specify data
       aes(x=CountryName, # specify the column that you want to show in the x-axis
           y=value)) +    # specify the column that you want to show in the y-axis
  # specify the type of your graph
  geom_bar(
    fill = "grey",  # which color is used to fill the bins
    color = "black",  # which color is used to draw the borders of bins
    stat = "identity" # when you specify x and y in geom_bar, don't forget this argument
  ) +
  # add title
  ggtitle("Percentage of female who have access to anti-retroviral drugs \n by country in 2020") +
  # add x-axis label
  xlab("Country") +
  # add y-axis label
  ylab("Percentage (%)") +
  # customize the background theme
  theme_bw() 

## Country names are too long !!

## Let's rotate 90 degrees.
ggplot(data=arv_fe_2020, # specify data
       aes(x=CountryName, # specify the column that you want to show in the x-axis
           y=value)) +    # specify the column that you want to show in the y-axis
  # specify the type of your graph
  geom_bar(
    fill = "grey",  # which color is used to fill the bins
    color = "black",  # which color is used to draw the borders of bins
    stat = "identity" # when you specify x and y in geom_bar, don't forget this argument
  ) +
  # add title
  ggtitle("Percentage of female who have access to anti-retroviral drugs \n by country in 2020") +
  # add x-axis label
  xlab("Country") +
  # add y-axis label
  ylab("Percentage (%)") +
  # customize the background theme
  theme_bw() +
  coord_flip() # to switch x and y 

## Do you want to order the countries from highest to lowest percentage?
ggplot(data=arv_fe_2020, # specify data
       aes(x=reorder(CountryName, value), # x-axis, reorder by value in a descending order
           y=value)) +    # specify the column that you want to show in the y-axis
  # specify the type of your graph
  geom_bar(
    fill = "grey",  # which color is used to fill the bins
    color = "black",  # which color is used to draw the borders of bins
    stat = "identity" # when you specify x and y in geom_bar, don't forget this argument
  ) +
  # add title
  ggtitle("Percentage of female who have access to anti-retroviral drugs \n by country in 2020") +
  # add x-axis label
  xlab("Country") +
  # add y-axis label
  ylab("Percentage (%)") +
  # customize the background theme
  theme_bw() +
  coord_flip() # to switch x and y 


### 2.1 Stacked bar plot ###
# Objective: to compare numerical values with subgroups between different groups
# Ex. create a stacked bar plot that shows % of female and male with access to ARV in 2020 by country together

# select data of female & male in 2020
arv_2020 <- arv[arv$year == 2020,]

# check the data table
str(arv_2020)

# plot
ggplot(data=arv_2020, # specify the data
       aes(x=reorder(CountryName, value), # x-axis, reorder by value in a descending order
           y=value,    # specify the column that you want to show in the y-axis
           fill = gender)) +  # specify the subgroup  
  # specify the type of your graph
  geom_bar(
    stat = "identity", # when you specify x and y in geom_bar, don't forget this argument
    position = "stack" # when you make a stacked barchart, don't forget this argument
  ) +
  # add title
  ggtitle("Percentage of individuals with access to anti-retroviral drugs \n by country in 2020") +
  # add x-axis label
  xlab("Country") +
  # add y-axis label
  ylab("Percentage (%)") +
  # customize the background theme
  theme_bw() +
  coord_flip() # to switch x and y 


# 3. Line plot ------------------------------------------------------------
# Objective: to present continuous changes in value of a variable
# Ex. create a line plot that shows the changes in % of female and male with access to ARV in Myanmar from 2001 to 2020.

# select data of Myanmar from 2001 to 2020
arv_myanmar <- arv[arv$CountryName=="Myanmar",]

# check the data table
str(arv_myanmar)

# plot
ggplot(data=arv_myanmar, # specify data
       aes(x=year, # specify the column that you want to show in the x-axis
           y=value,  # # specify the column that you want to show in the y-axis
           group = gender,    # different lines by group
           color = gender)) +   # different colors by group
  # specify the type of your graph
  geom_line() +
  # add title
  ggtitle("Percentage of individuals with access to anti-retroviral drugs \n in Myanmar from 2001 to 2020") +
  # add x-axis label
  xlab("Year") +
  # add y-axis label
  ylab("Percentage (%)") +
  # customize the background theme
  theme_bw()
  

# 4. Scatter plot ---------------------------------------------------------
# Objective: to show relationships between two numeric variables
# Ex. create a scatter plot that shows the relationship of % of female and that of male with access to ARV in 2020. Is there any correlation?

# change the shape of the data table to put the percentages of female and male in different columns
arv_2020_spread <- arv_2020 %>% 
    select(-c(SeriesCode,n)) %>%
    spread(key = gender, value = value)

# check the data table
View(arv_2020_spread)

# plot
ggplot(data=arv_2020_spread, # specify data
       aes(x=female, # specify the column that you want to show in the x-axis
           y=male)) +   # specify the column that you want to show in the y-axis
  # specify the type of your graph
  geom_point() +
  # make sure x-axis extends to 100%
  xlim(0,100) +
  # make sure y-axis extends to 100%
  ylim(0,100) +
  # add title
  ggtitle("Comparison of percentages of female and male with access to anti-retroviral drugs \n in 2020") +
  # add x-axis label
  xlab("Female (%)") +
  # add y-axis label
  ylab("Male (%)") +
  # customize the background theme
  theme_bw()

## Is there any correlation? Add the trend line and confidence interval
ggplot(data=arv_2020_spread, # specify data
       aes(x=female, # specify the column that you want to show in the x-axis
           y=male)) +   # specify the column that you want to show in the y-axis
  # specify the type of your graph
  geom_point() +
  # add the linear trend and the confidence interval
  geom_smooth() +
  # make sure x-axis extends to 100%
  xlim(0,100) +
  # make sure y-axis extends to 100%
  ylim(0,100) +
  # add title
  ggtitle("Comparison of percentages of female and male with access to anti-retroviral drugs \n in 2020") +
  # add x-axis label
  xlab("Female (%)") +
  # add y-axis label
  ylab("Male (%)") +
  # customize the background theme
  theme_bw()

## Do you wanna add country names?
ggplot(data=arv_2020_spread, # specify data
       aes(x=female, # specify the column that you want to show in the x-axis
           y=male)) +   # specify the column that you want to show in the y-axis
  # specify the type of your graph
  geom_point() +
  # add country names
  geom_text(
    label = arv_2020_spread$CountryName, # specify texts
    nudge_x = 1, nudge_y = 3,   # shift the texts along x and y axis
    check_overlap = TRUE    # avoid overlap
  ) +
  # make sure x-axis extends to 100%
  xlim(0,100) +
  # make sure y-axis extends to 100%
  ylim(0,100) +
  # add title
  ggtitle("Comparison of percentages of female and male with access to anti-retroviral drugs \n in 2020") +
  # add x-axis label
  xlab("Female (%)") +
  # add y-axis label
  ylab("Male (%)") +
  # customize the background theme
  theme_bw()



# 5. Tornado plot ---------------------------------------------------------
# check the imported data
str(tornado) # str means "structure". This function shows data by column with data types

## 5.1 Data manipulation ----------------------------------------------------
# base case value
basecasevalue <- -1.6 # assumption: you already know this value

# add differences between max and min
tornado <- tornado %>%
      # find difference between maximum and minimum
      mutate(dif = max - min)

# get the order of the parameters depending on the absolute values
param_order <- tornado %>% 
  # set the order of the parameters depending on the absolute values
  arrange(desc(dif)) %>% 
  mutate(parameter = factor(x = parameter, levels = parameter)) %>%
  select(parameter) %>% 
  # change the data type from list to vector
  unlist() %>% 
  levels()

param_order

# width of columns in plot (any value between 0 and 1)
width <- 0.95

# read and modify data
tornado_data <- tornado %>%
  # change the structure of the datatable
  gather(key = "min_max",value = "value",max,min) %>% 
  # calculate the positions of apexes of rectangles
  mutate(parameter=factor(parameter,levels = param_order),
         ymin=pmin(value, basecasevalue),
         ymax=pmax(value, basecasevalue),
         xmin=as.numeric(parameter)-width/2,
         xmax=as.numeric(parameter)+width/2)

# check the data
View(tornado_data)
         
## 5.2 Plot ----------------------------------------------------
# plot
ggplot(data = tornado_data,
       aes(ymax=ymax, # set each apex
           ymin=ymin, 
           xmax=xmax, 
           xmin=xmin)) + 
  # specify the type of your graph and fill and border color
  geom_rect(aes(fill="", color="")) +
  scale_fill_manual(values = "lightblue") + # color inside the rect
  scale_color_manual(values = "black") + # color of the rect borders
  # add title
  ggtitle("Effects of select parameters on absolute mortality decrease due to Empiric TB in \n the \"Medium\" Undiagnosed Active TB Prevalence Scenario (10.6%)") +
  # add y-axis label (caution: we will flip the axis so technically "x-axis")
  ylab("Absolute mortality decrease (%) due to Empiric TB") +
  # add bar labels
  scale_x_continuous(breaks = c(1:length(unique(param_order))),
                     labels = unique(param_order)) +
  # control x-axis ticks interval
  scale_y_continuous(breaks = c(seq(-14.00,0.00,2.0)),labels=label_number(accuracy = 0.01)) +
  # for extending x-axis
  annotate("text",x=1,y=-13.5,label="") +
  # customize the backgroud theme
  theme_classic() + 
  theme(
        legend.position = "none",   # remove legend
        axis.ticks.y = element_blank(), # remove axis ticks
        axis.title.y = element_blank(), # remove axis title
        panel.grid = element_blank(),   # remove grids in the plot
        plot.margin = unit(c(1,0.25,0.25,0.25), "cm")) + # add margin
  # add vertical line to show the baseline result
  geom_segment(aes(x=max(xmax) + 0.5, 
                   xend=0.2,
                   y=basecasevalue,
                   yend=basecasevalue),
               linetype = 2,  # dashed line
               linewidth = 1) +
  # add annotation of the vertical line
  annotate("text", # set annotation type
           x = max(tornado_data$xmax) + 0.7, y = basecasevalue, # set the position
           label = paste0("Base Case = ", basecasevalue)) +
  coord_flip() # rotate the plot 90 degree

# save the figure in png
# ggsave("tornado.png", width = 8, height = 6)


# 6. Heatmap ---------------------------------------------------------
# check the data
View(heat)


## 6.1. Data manipulation ----------------------------------------------------
# base case values. Assumption: you already know the base case values
Tx_cost_base <- 600
Test_cost_base <- 10

# create "levels" for the x- and y-axis to show the result in ascending order
heat <- heat %>% 
  mutate(Tx_cost_times = factor(Tx_cost_times, levels = unique(heat$Tx_cost_times)),
         Test_cost_times = factor(Test_cost_times, levels = unique(heat$Test_cost_times)))

# create x axis labels
heat$x_labels = paste0(
  as.numeric(as.character(heat$Test_cost_times))*Test_cost_base,
  "\n(",heat$Test_cost_times, "x)")

# create y axis labels
heat$y_labels = paste0(
  as.numeric(as.character(heat$Tx_cost_times))*Tx_cost_base,
  " (",heat$Tx_cost_times, "x)")

# check the data
View(heat)


## 6.2. Plot ----------------------------------------------------
# plot
ggplot(data = heat,  # specify the data
       aes(x=Test_cost_times, # specify the x-axis
           y=Tx_cost_times, # specify the y-axis
           fill = Optimal_strategy)) + # specify the color showing the optimal strategy
  geom_tile() + 
  # add "X" at the base case
  geom_point(
    data = heat[(heat$Tx_cost_times == 1) & (heat$Test_cost_times == 1),], 
    aes(x = Test_cost_times, y = Tx_cost_times), fill = "NA",
    color = "black", size = 7, shape = 4
  ) +
  theme_classic() +
  # add plot title
  ggtitle("Test cost and Treatment scale-up cost") + 
  # x axis label
  xlab("Test Cost, $/person/year\n(Test baseline cost multiplier)") +
  # y axis label
  ylab("Treatment Scale-Up Cost, $/person/year\n(Treatment Scale-Up baseline cost multiplier)") +
  # set strategy colors, reverse legend order, name legend "Optimal strategies"
  scale_fill_manual(values = c("salmon","gold","darkblue"),
                    guide = guide_legend(reverse = TRUE),
                    name = "Optimal strategies") + 
  # adjust distance between x axis labels and plot, add x axis tick labels
  scale_x_discrete(expand = c(0,0),
                   labels = unique(heat$x_labels)) +
  # adjust distance between y axis labels and plot, add y axis tick labels
  scale_y_discrete(expand = c(0,0), 
                   labels = unique(heat$y_labels)) + 
  # remove axis ticks and lines, add margin between axes and axes titles 
  theme(axis.ticks = element_blank(),
        axis.line = element_blank(),
        axis.title.y = element_text(margin = unit(c(0,5,0,0), "mm")),
        axis.title.x = element_text(margin = unit(c(5,0,0,0), "mm")))
         
# save the figure in png
# ggsave("heatmap.png", width = 8, height = 6)
