install.packages("BCEA")
library(BCEA)
?list.function.in.file()
# Simulate cost and QALY data
set.seed(42)
n <- 1000
costs <- cbind(
  rnorm(n, mean = 20000, sd = 1000),
  rnorm(n, mean = 15000, sd = 1500),
  rnorm(n, mean = 25000, sd = 1800)
)

qalys <- cbind(
  rnorm(n, mean = 1.8, sd = 0.1),
  rnorm(n, mean = 1.5, sd = 0.3),
  rnorm(n, mean = 2.5, sd = 0.1)
)

cea <- bcea(e = qalys, c = costs, ref = 1, 
            interventions = c("Standard", "Improved", "New"))
# Cost-effectiveness plane
ceplane.plot(cea, graph = "ggplot2", legend.position = "top")

icer <- (mean(costs[,3]) - mean(costs[,1])) / (mean(qalys[,3]) - mean(qalys[,1]))
icer  # prints ICER for 'New' vs 'Standard'

ceac.plot(cea, graph = "ggplot2", pos = c(1, 0.5))

eib.plot(cea, graph = "ggplot2")  # Shows Expected Incremental Benefit

################### Standard vs New
set.seed(42)
n <- 1000
costs <- cbind(
  rnorm(n, mean = 20000, sd = 1000),
  rnorm(n, mean = 25000, sd = 1800)
)

qalys <- cbind(
  rnorm(n, mean = 1.8, sd = 0.1),
  rnorm(n, mean = 2.5, sd = 0.1)
)

cea <- bcea(e = qalys, c = costs, ref = 1, 
            interventions = c("Standard", "New"))
# Cost-effectiveness plane
ceplane.plot(cea, graph = "ggplot2", legend.position = "top")

icer <- (mean(costs[,2]) - mean(costs[,1])) / (mean(qalys[,3]) - mean(qalys[,1]))
icer  

ceac.plot(cea, graph = "ggplot2", pos = c(1, 0.5))

eib.plot(cea, graph = "ggplot2")  # Shows Expected Incremental Benefit


################## Standard vs Improved

# Simulate cost and QALY data
set.seed(42)
n <- 1000
costs <- cbind(
  rnorm(n, mean = 20000, sd = 1000),
  rnorm(n, mean = 15000, sd = 1500)
)

qalys <- cbind(
  rnorm(n, mean = 1.8, sd = 0.1),
  rnorm(n, mean = 1.5, sd = 0.3)
)

cea <- bcea(e = qalys, c = costs, ref = 1, 
            interventions = c("Standard", "Improved"))
# Cost-effectiveness plane
ceplane.plot(cea, graph = "ggplot2", legend.position = "top")

icer <- (mean(costs[,2]) - mean(costs[,1])) / (mean(qalys[,2]) - mean(qalys[,1]))
icer  # prints ICER for 'New' vs 'Standard'

ceac.plot(cea, graph = "ggplot2", pos = c(1, 0.5))

eib.plot(cea, graph = "ggplot2")  # Shows Expected Incremental Benefit