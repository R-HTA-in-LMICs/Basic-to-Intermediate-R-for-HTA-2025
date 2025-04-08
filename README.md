# Basic to Intermediate R for HTA 2025:

<img src="img/logo.png" width="260" height="200" align="right"/>

This repository stores the code, presentations, and material used in the R-HTA in LMICs basic to intermediate 2025 tutorials.

The following sections provide a breakdown of the primary documents and guidance on how to use them for your own personal training. The tutorial is based on several open-source frameworks for basic survival analysis in R.

## Navigation

The [`R`]() folder stores the primary code script used during the tutorials..

The [`resources`]() folder stores the primary code script used during the tutorials.

## Preliminaries

-   Install `tidyverse`, `ggplot2`, `dplyr`, and `rvest` from [CRAN](https://cran.r-project.org), which are R packages used for survival analysis. Then, install `devtools` to install the [`darthtools`](https://github.com/DARTH-git/darthtools) package, which is an R package from [DARTH's GitHub](https://github.com/DARTH-git). See below:

```{r, eval=FALSE}
# For the survival analysis, install the following packages from CRAN
install.packages("tidyverse")
install.packages("ggplot2")
install.packages("dplyr")
install.packages("rvest")
```

-   then install `darthtools` using `devtools`

```{r, eval=FALSE}
# Install devtools from CRAN
install.packages("devtools")

# Install development DARTH tools package from GitHub
devtools::install_github("DARTH-git/darthtools")
```

# Additional Information

Visit our [webpage](https://r-hta-in-lmics.github.io/) and follow the links to our social media to keep up-to-date with our latest tutorials. Alternatively, follow us on [EventBrite](https://www.eventbrite.co.uk/o/r-hta-in-lmics-46016978693) to receive notifications as new events go live!
