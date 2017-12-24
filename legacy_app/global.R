library(shiny)
library(shinycssloaders)
library(shinydashboard)
library(shinyjs)
library(highcharter)
library(htmlwidgets)
library(readxl)
library(tidyverse)
library(ggpubr)
library(grid)
library(httr)

data <- read_excel("data/ada4715.xlsx")
president <- read_csv("data/presidents.csv")

data <- data %>% group_by(Year, StateAbbr) %>% mutate(Number = n())

yhat <- data %>%
  group_by(Year, Chamber, Party) %>%
  summarise(ADA = round(mean(Nominal.Score), 2),
            aADA = round(mean(Adjusted.Score), 2))

dataset <- data %>%
  group_by(Year, StateAbbr, Chamber, Party) %>%
  summarise(ADA = round(mean(Nominal.Score), 2),
            aADA = round(mean(Adjusted.Score), 2),
            Number = mean(Number))

trend <- dataset  %>%
  arrange(Year) %>%
  group_by(StateAbbr, Chamber, Party) %>%
  mutate(Diff = ADA - lag(ADA),
         Diff2 = aADA - lag(aADA))
trend <- na.omit(trend)

trend$Threshold <- factor(ifelse(trend$Diff > 0, "Liberal", "Conservative"),
                          levels = c("Liberal", "Conservative"))
trend$Threshold2 <- factor(ifelse(trend$Diff2 > 0, "Liberal", "Conservative"),
                          levels = c("Liberal", "Conservative"))

usData <- download_map_data("countries/us/us-all")

stops <- data.frame(q = c(0, .5, 1),
                    c = c("#ea5148", "#ffffff", "#18469e"))
stops <- list_parse2(stops)