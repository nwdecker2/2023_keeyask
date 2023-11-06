library(dplyr)
library(tidyverse)
library(janitor)
library(readxl)
library(writexl)
library(here)
library(readr)

## Tim has already done the calculations

## Hourly Averages
gsco2hourly <- read_xlsx(here("data/2023_GS_CO2_raw.xlsx"),
                      sheet = "hourly",
                      na = c("NaN", NA)) %>% 
  clean_names() %>% 
  slice(-1) %>% 
  filter(!is.na(p_co2_screened)) %>% 
  mutate_all(as.numeric) %>% 
  mutate(month = as.factor(month)) %>% 
  mutate(date = ymd("2023-01-01") + days(doy - 1) + hours(hour_3))
## 

## Daily averages
gsco2daily <- read_xlsx(here("data/2023_GS_CO2_raw.xlsx"),
                         sheet = "daily",
                        na = c("NaN", NA))  %>% 
  clean_names() %>% 
  slice(-1) %>% 
  filter(!is.na(p_co2_screened)) %>% 
  mutate_all(as.numeric) %>% 
  mutate(month = as.factor(month))
