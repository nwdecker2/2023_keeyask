library(dplyr)
library(tidyverse)
library(janitor)
library(readxl)
library(writexl)
library(here)
library(readr)

## Import the data to R for manipulation (CL CH4)
clch4raw <- read_delim(here("data/2023_CL_CH4_raw.txt"), 
                       delim = ";", 
                       locale = locale(), 
                       skip = 3,
                       na = c("0", "NA")) %>%
  clean_names()