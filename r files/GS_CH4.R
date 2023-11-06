library(dplyr)
library(tidyverse)
library(janitor)
library(readxl)
library(writexl)
library(here)
library(readr)

gsch4raw <- read_xlsx(here("data/2023_GS_CH4_raw.xlsx"), 
                      na = c("0", NA), 
                      skip = 2) %>%
  clean_names() %>%
  slice(-1) %>% 
  mutate_all(as.numeric) %>% 
  filter(!is.na(flag_1_good))
## 

## Mutate Data to be hourly
gsch4hourly <- gsch4raw %>%
  group_by(month, day, hour) %>%
  summarize(across(where(is.numeric), mean, na.rm = TRUE)) %>% 
  mutate(month = as.factor(month)) %>% 
  mutate(
    year = as.integer(year),  
    month = as.integer(month), 
    day = as.integer(day), 
    hour = as.integer(hour),
    date = make_datetime(year, month, day, hour))

## Mutate Data to be Daily
gsch4daily <- gsch4raw %>% 
  group_by(month, day) %>% 
  summarize(across(where(is.numeric), mean, na.rm = TRUE)) %>% 
  mutate(month = as.factor(month))
