cat("loading .Rprofile")

options(defaultPackages=c(options("defaultPackages")[[1]],"dplyr"))

library(tidyverse)
require(utils, quietly=TRUE)

packages <- c("devtools", "here", "rio", "stringr", 
              "purrr") %>% 
  as.data.frame() %>% tbl_df() %>% 
  rename("package name" = ".") %>% 
  separate("package name", into = c("github", "package"), sep = "/", fill = "left")
a <- setdiff(packages$package, intersect(packages$package, rownames(installed.packages())))


if (length(a) > 0) {
  for(i in 1:length(a)){
    if (i %in% available.packages()[,1]){
      install.packages(a[i])
    } else {
      index <- match(a, packages$package)
      gitinstall <- paste(packages[index, 1], packages[index, 2], sep = "/")
      devtools::install_github(gitinstall)
    }
  }
}

if (length(packages$package) > 0) {
  sapply(packages$package, require, character.only=TRUE, quietly=TRUE)
} 

devtools::install_github("CT-Data-Haven/cwi")
devtools::install_github("camille-s/camiller")
library(cwi)
library(camiller)

detach("package:dplyr")
library(dplyr)

cat("All packages installed and loaded!")
