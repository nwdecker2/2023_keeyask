library(dplyr)
library(tidyverse)
library(janitor)
library(readxl)
library(writexl)
library(here)
library(readr)

## Import the data to R for manipulation (BB CO2)
bbco2raw <- read_delim(here("data/2023_BB_CO2_raw.txt")) %>%
  clean_names() %>%
  slice(-1)
## 

## Mutate the data to include the hourly average

bbco2hourly <- bbco2raw %>%
  mutate(hour = lubridate::hour(date_time)) %>%
  group_by(date = as.Date(date_time)) %>%
  filter(n() > 1) %>%
  summarize(across(everything(), mean, na.rm = TRUE))
##

## Mutate the data to include the daily average
bbch4daily <- bbch4raw %>%
  mutate(date = as.Date(date_time)) %>%
  group_by(date) %>%
  summarize(across(everything(), mean, na.rm = TRUE))
