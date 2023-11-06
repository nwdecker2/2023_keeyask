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
  clean_names() %>% 
  slice(-1) %>% 
  mutate(date_time = as.POSIXct(paste(date, time), 
                                format = "%Y-%m-%d %H:%M:%S")) %>% 
  mutate_if(!grepl("date_time", names(.)), as.numeric) %>% 
  mutate(kh = exp(-68.8862 + 101.4956 * (100 / (t_gas + 273.15)) + 
                    28.7314 * log((t_gas + 273.15) / 100) + 
                    0 * (-0.076146 + 0.04397 * ((t_gas + 273.15) / 100) - 
                           0.0068672 * ((t_gas + 273.15) / 100) ^ 2)) / (273.15 * 0.08205736608096)) %>% 
  mutate(
    year = year(date_time),
    month = month(date_time),
    day = day(date_time),
    hour = hour(date_time)
  ) %>% 
  mutate_if(!grepl("date_time", names(.)), as.numeric) %>%
  select(-1:-2) %>% 
  mutate(
    ch4_uatm = (((((concentration)/1000000)*kh)*1000000)*p_in)/1013.25
  ) %>% 
filter(!is.na(ch4_uatm))
  
## Mutate the date to incule the hourly average
clch4hourly <- clch4raw %>%
  group_by(month, day, hour) %>%
  summarize(across(where(is.numeric), mean, na.rm = TRUE)) %>% 
  mutate(month = as.factor(month)) %>% 
  mutate(date = as.Date(paste(year, month, day, sep = "-")))
##

## Mutate the data to include the daily average
clch4daily <- clch4raw %>% 
  group_by(month, day) %>% 
  summarize(across(where(is.numeric), mean, na.rm = TRUE)) %>% 
  mutate(month = as.factor(month))
