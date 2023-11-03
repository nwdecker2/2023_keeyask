library(dplyr)
library(tidyverse)
library(janitor)
library(readxl)
library(writexl)
library(here)
library(readr)

## Tim has already done the calculations
gsco2hourly <- read_xlsx(here("data/2023_GS_CO2_raw.xlsx"),
                      sheet = "hourly",
                      na = c("NaN", NA)) %>% 
  clean_names() %>% 
  slice(-1) %>% 
  filter(!is.na(flag_1_good))
## 

## Mutate Data to be Daily
gsco2daily <- read_xlsx(here("data/2023_GS_CO2_raw.xlsx"),
                         sheet = "daily",
                        na = c("NaN", NA))  %>% 
  clean_names() %>% 
  slice(-1) %>% 
  filter(!is.na(flag_1_good))
