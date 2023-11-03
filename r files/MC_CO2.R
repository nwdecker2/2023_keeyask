library(dplyr)
library(tidyverse)
library(janitor)
library(readxl)
library(writexl)
library(here)
library(readr)


mcco2raw <- read_delim(here("data/2023_MC_Co2_raw.txt"), 
                       delim = ",", 
                       locale = locale(), 
                       skip = 0)