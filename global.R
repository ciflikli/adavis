library(shinycssloaders)
library(shinydashboard)
library(shinyjs)
library(shinyWidgets)
library(statebins)
library(hrbrthemes)
library(readxl)
library(DT)
library(tidyverse)
library(stringi)
library(ggplot2)
library(ggExtra)
library(ggthemes)
library(viridis)
library(plotly)
library(scales)
library(grid)
library(showtext)
theme_set(theme_ipsum_rc())
font_add_google(name = "Roboto Condensed", family = "Roboto Condensed", regular.wt = 400, bold.wt = 700)
showtext_auto()
showtext_opts(dpi = 112)

data <- read_excel("data/ada4715.xlsx")
data$`Full Name` <- stri_trans_totitle(data$`Full Name`)
data$State <- stri_trans_totitle(data$State)
data <- data[data$Party == "Democrat" | data$Party == "Republican", ]
data$Party <- paste0(data$Party, "s")
data <- data %>% group_by(Year, State) %>% mutate(Number = n())

dataset <- data %>%
  group_by(Year, State, Chamber, Party) %>%
  summarise(ADA = round(mean(Nominal.Score), 2),
            aADA = round(mean(Adjusted.Score), 2),
            Number = mean(Number))

#Add rows for missing states in party-year
states <- data.frame(state.name, stringsAsFactors = FALSE)
states$state.no <- 1:50

dataset <- merge(dataset, states, by.x = "State", by.y = "state.name")

dataset <- dataset %>% complete(state.no = full_seq(state.no, period = 1), Year, Chamber, Party,
                                fill = list(ADA = -25, aADA = -25))
dataset$State <- ifelse(is.na(dataset$State), states[dataset$state.no, 1], dataset$State)

#Calculate change from last year State-wise
trend <- dataset  %>%
  arrange(Year) %>%
  group_by(State, Chamber, Party) %>%
  mutate(Diff = ADA - lag(ADA),
         Diff.Adj = aADA - lag(aADA))
trend <- na.omit(trend)

trend$Thresh.Ada <- factor(ifelse(trend$Diff > 0, "liberal", "conservative"),
                          levels = c("liberal", "conservative"))
trend$Thresh.AAda <- factor(ifelse(trend$Diff.Adj > 0, "liberal", "conservative"),
                          levels = c("liberal", "conservative"))