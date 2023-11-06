library(dplyr)
library(tidyverse)
library(janitor)
library(readxl)
library(writexl)
library(here)
library(readr)


## Import the data to R for manipulation (BB CO2)
mcco2raw <- read_delim(here("data/2023_MC_CO2_raw.txt"),
                       delim = ",",
                       locale = locale(encoding = "UTF-8")) %>%
  clean_names() %>% 
  mutate_all(as.numeric) %>% 
  mutate(pco2_uatm = ((cell_gas_pressure/1013.25)*co2) 
  ) %>% 
  slice(-1) %>% 
  select(-1)

## 

## Mutate the data to include the hourly average
mcco2hourly <- mcco2raw %>%
  group_by(month, day, hour) %>%
  summarize(across(everything(), mean, na.rm = TRUE)) %>% 
  mutate(month = as.factor(month)) %>% 
  mutate(date = as.Date(paste(year, month, day, sep = "-")))
##

## Mutate the data to include the daily average
mcco2daily <- mcco2raw %>%
  group_by(month, day) %>%
  summarize(across(everything(), mean, na.rm = TRUE))  %>% 
  mutate(month = as.factor(month))

