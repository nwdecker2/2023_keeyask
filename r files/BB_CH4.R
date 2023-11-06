library(dplyr)
library(tidyverse)
library(janitor)
library(readxl)
library(writexl)
library(here)
library(readr)

## Import the data to R for manipulation (BB CH4)
bbch4raw <- read_delim(here("data/2023_BB_CH4_raw.txt"), 
                       delim = ";", 
                       locale = locale()) %>%
  mutate(across(-1:-2, ~as.numeric(gsub(",", ".", .)))) %>%
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
  )
## 

## Mutate the data to include the hourly average

bbch4hourly <- bbch4raw %>%
  group_by(month, day, hour) %>%
  summarize(across(where(is.numeric), mean, na.rm = TRUE)) %>% 
  mutate(month = as.factor(month)) %>% 
  mutate(date = as.Date(paste(year, month, day, sep = "-")))
##

## Mutate the data to include the daily average
bbch4daily <- bbch4raw %>% 
  group_by(month, day) %>% 
  summarize(across(where(is.numeric), mean, na.rm = TRUE)) %>% 
  mutate(month = as.factor(month)) %>% 
  mutate(day = as.factor(day))
