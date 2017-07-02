library(shiny)
library(shinydashboard)
library(highcharter)
library(readxl)
library(tidyverse)

data <- read_excel("data/ada4715.xlsx")
president <- read_csv("data/presidents.csv")

yhat <- data %>%
  group_by(Year, Chamber, Party) %>%
  summarise(ADA = round(mean(Nominal.Score), 2),
            aADA = round(mean(Adjusted.Score), 2))