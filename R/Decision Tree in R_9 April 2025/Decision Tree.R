## Decision tree analysis
## R-HTA in LMICS Chapter 
## 2025 R Foundations workshop DAY 1 | 9 April 2025

# References: 
# The decision tree structure comes from Briggs et al., 2006, pg 23 (Box2.3)
# The R code refers to Decision Tree Tutorial by Mark Bounthavong 

# Migraine attack model
# Decision options on Migraine attack episode
# 1. Sumatriptan
# 2. Caffeine/ergotamine


################################
#### Vector of parameter inputs
################################
input <- data.frame(
  p.ST_RF    = 0.558,     # Probability of relief with Sumatriptan
  p.ST_RF_NR = 0.594,     # Probability of no recurrence after relief with Sumatriptan
  p.ST_NR_EA = 0.92,      # Probability of enduring attack after no relief with Sumatriptan
  p.ST_ER_RF = 0.998,     # Probability of relief after ER after no relief with Sumatriptan
  p.CE_RF    = 0.379,     # Probability of relief with Caffeine/ergotamine
  p.CE_RF_NR = 0.703,     # Probability of no recurrence after relief with Caffeine/ergotamine
  p.CE_NR_EA = 0.92,      # Probability of enduring attack after no relief with Caffeine/ergotamine
  p.CE_ER_RF = 0.998,     # Probability of relief after ER after no relief with Caffeine/ergotamine
  
  u.RF_NR    = 1,         # Utility after no recurrence after relief
  u.RF_R     = 0.9,       # Utility after recurrence after relief
  u.NR_EA    = -0.3,      # Utility after enduring attack after no relief
  u.ER_RF    = 0.1,       # Utility after relief after ER after no relief
  u.ER_HS    = -0.3,      # Utility after hospitalization after ER after no relief
  
  c.A        = 16.1,      # Costs of Path A
  c.B        = 32.2,      # Costs of Path B
  c.C        = 16.1,      # Costs of Path C
  c.D        = 79.26,     # Costs of Path D
  c.E        = 1172,      # Costs of Path E 
  c.F        = 1.32,      # Costs of Path F 
  c.G        = 2.64,      # Costs of Path G 
  c.H        = 1.32,      # Costs of Path H 
  c.I        = 64.45,     # Costs of Path I 
  c.J        = 1157,      # Costs of Path J 

  wtp    = 100          # Willingess to pay per life year gained
)


##################################################
#### Wrap decision tree into a function ####
##################################################
dec_tree <- function(params){
  with(
    as.list(params), 
    {
      
      # Expected probabilities for each pathway
      ### Pathways for Sumatriptan
      epA <- p.ST_RF * p.ST_RF_NR                                # Expected probability for Pathway A
      epB <- p.ST_RF * (1 - p.ST_RF_NR)                          # Expected probability for Pathway B
      epC <- (1 - p.ST_RF) * p.ST_NR_EA                          # Expected probability for Pathway C
      epD <- (1 - p.ST_RF) * (1 - p.ST_NR_EA) * p.ST_ER_RF       # Expected probability for Pathway D
      epE <- (1 - p.ST_RF) * (1 - p.ST_NR_EA) * (1 - p.ST_ER_RF) # Expected probability for Pathway E
      
      ### Pathways for Caffeine/ergotamine
      epF <- p.CE_RF * p.CE_RF_NR                                # Expected probability for Pathway F
      epG <- p.CE_RF * (1 - p.CE_RF_NR)                          # Expected probability for Pathway G
      epH <- (1 - p.CE_RF) * p.CE_NR_EA                          # Expected probability for Pathway H
      epI <- (1 - p.CE_RF) * (1 - p.CE_NR_EA) * p.CE_ER_RF       # Expected probability for Pathway I
      epJ <- (1 - p.CE_RF) * (1 - p.CE_NR_EA) * (1 - p.CE_ER_RF) # Expected probability for Pathway J
      
      # Total costs for each pathway (unweighted)
      ### Total costs for Sumatriptan
      tcA <- c.A                 # Total costs for Pathway A
      tcB <- c.B                 # Total costs for Pathway B
      tcC <- c.C                 # Total costs for Pathway C
      tcD <- c.D                 # Total costs for Pathway D
      tcE <- c.E                 # Total costs for Pathway E
      
      ### Total costs for Caffeine/ergotamine
      tcF <- c.F                 # Total costs for Pathway F
      tcG <- c.G                 # Total costs for Pathway G
      tcH <- c.H                 # Total costs for Pathway H
      tcI <- c.I                 # Total costs for Pathway I
      tcJ <- c.J                 # Total costs for Pathway J
      
      # Expected Total Costs for each Treatment strategy is the sum of the weighted values
      # (probabilities of each pathway multiplied by the total costs of each pathway)
      ### Expected Total Costs for Sumatriptan
      etc.ST <- (epA * tcA) + (epB * tcB) + (epC * tcC) + (epD * tcD) + (epE * tcE)
      
      ### Expected Total Costs for Caffeine/ergotamine
      etc.CE <- (epF * tcF) + (epG * tcG) + (epH * tcH) + (epI * tcI) + (epJ * tcJ)
      
      # Expected Utility for each Treatment strategy is the sum of the weighted values
      # (probabilities of each pathway multiplied by the Life Years of each pathway)
      ### Expected Utility for Sumatriptan
      eu.ST <- (epA * u.RF_NR) + (epB * u.RF_R) + (epC * u.NR_EA) + (epD * u.ER_RF) + (epE * u.ER_HS)
      
      ### Expected Utility for Caffeine/ergotamine
      eu.CE <- (epF * u.RF_NR) + (epG * u.RF_R) + (epH * u.NR_EA) + (epI * u.ER_RF) + (epJ * u.ER_HS)
      
      # Expected total costs, expected utility, incremental costs, incremental utility, and ICER lists
      C    <- c(etc.ST, etc.CE)
      U   <- c(eu.ST, eu.CE)
      IC   <- etc.ST - etc.CE
      IE   <- eu.ST - eu.CE
      ICER <- (etc.ST - etc.CE)/ (eu.ST - eu.CE)
      
      names(C)    <- paste("C", c("ST", "CE"), sep = "_")
      names(U)    <- paste("U", c("ST", "CE"), sep = "_")
      names(IC)   <- paste("Incr Costs")
      names(IE)   <- paste("Incr Utility")
      names(ICER) <- paste("ICER")
      
      # Generate the output
      return(c(C, U, IC, IE, ICER))
    }
  )
}

#### Now, we can use the function "dec_tree" with the inputs to estimate the ICER and its corresponding values
dec_tree(input)