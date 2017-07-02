library(shiny)
library(shinydashboard)
library(highcharter)
library(readxl)
library(tidyverse)

data <- read_excel("data/ada4715.xlsx")
president <- read_csv("data/presidents.csv")