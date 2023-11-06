library(dplyr)
library(tidyverse)
library(janitor)
library(readxl)
library(writexl)
library(here)
library(readr)

## Import the data to R for manipulation (BB CO2)
bbco2raw <- read_delim(here("data/2023_BB_CO2_raw.txt"),
                       delim = ",",
                     locale = locale(encoding = "UTF-8")) %>%
  clean_names() %>%
  filter(co2 >= 100 &
           !(co2 %in% c(-16414,
                        -16413,
                        -959410,
                        -978194,
                        -50152,
                        -107725,
                        -222220,
                        -241304,
                        -317455,
                        1355106,
                        -373955,
                        431140, 
                        -638651, 
                        -808510, 
                        -846175, 
                        -883996))) %>% 
  slice(-1) %>%
  select(-1, -6:-7, -13)  %>% 
  mutate_all(as.numeric) %>% 
  filter(day < 32) %>% 
  filter(hour < 24) %>% 
  filter(year == 2023) %>% 
  mutate(pco2_uatm = ((cell_gas_pressure/1013.25)*co2)
  )
  
  
## 

## Mutate the data to include the hourly average

bbco2hourly <- bbco2raw %>%
  group_by(month, day, hour) %>%
  summarize(across(everything(), mean, na.rm = TRUE)) %>% 
  filter(month > 4, month < 10) %>% 
  mutate(
    year = as.integer(year),  
    month = as.integer(month), 
    day = as.integer(day), 
    hour = as.integer(hour),
    date = make_datetime(year, month, day, hour))
##

## Mutate the data to include the daily average
bbco2daily <- bbco2raw %>%
  group_by(month, day) %>%
  summarize(across(everything(), mean, na.rm = TRUE)) %>% 
  filter(!is.nan(pco2_uatm)) %>%
  filter(month > 4, month < 10) %>% 
  mutate(month = as.factor(month))

