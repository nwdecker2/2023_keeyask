library(dplyr)
library(tidyverse)
library(janitor)
library(readxl)
library(writexl)
library(here)
library(readr)

## Import the data to R for manipulation (MC CH4)
mcch4raw <- read_delim(here("data/2023_MC_CH4_raw.txt"), 
                       delim = ";", 
                       locale = locale(), 
                       skip = 3) %>%
  clean_names() %>%
  rename(p_pump_w = p_pump,
         p_tdlas_mbar = p_tdlas,
         p_in_mbar = p_in,
         pch4_uatm = p_ch4,
         xch4_ppm = x_ch4,
         runtime_s = runtime,
         t_control_c = t_control,
         t_gas_c = t_gas) %>%
  slice(-1) %>% 
  mutate(date_time = as.POSIXct(paste(date, time))) %>%
  select(-1:-2) %>% 
  mutate(
    year = year(date_time),
    month = month(date_time),
    day = day(date_time),
    hour = hour(date_time)
  ) %>% 
  mutate_at(vars(-date_time), as.numeric)
## 

## Mutate Data to be hourly
mcch4hourly <- mcch4raw %>%
  group_by(month, day, hour) %>%
  summarize(across(where(is.numeric), mean, na.rm = TRUE))%>% 
  mutate(
    year = as.integer(year),  
    month = as.integer(month), 
    day = as.integer(day), 
    hour = as.integer(hour),
    date = make_datetime(year, month, day, hour))

## Mutate Data to be Daily
mcch4daily <- mcch4raw %>% 
  group_by(month, day) %>% 
  summarize(across(where(is.numeric), mean, na.rm = TRUE)) %>% 
  mutate(month = as.factor(month))
