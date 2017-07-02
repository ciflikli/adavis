source("global.R",local=TRUE)

ui <- dashboardPage(
  dashboardHeader(title = "ADA Voting Scores"),
  dashboardSidebar(
    sidebarMenu(
      selectInput("Party", "Select Party", choices = c("Democrat", "Republican")),
      selectInput("Chamber", "Select Chamber", choices = c("House", "Senate")),
      selectInput("ADA", "Select ADA Score", choices = c("Nominal", "Adjusted")),
      sliderInput("Year", "Select Year", 1947, min = 1947, max = 2015, animate = TRUE, sep = ""),
      menuItem(textOutput("text1")),
      menuItem("About"),
      menuItem("gokhanciflikli.com", icon = icon("external-link"),
               href = "https://www.gokhanciflikli.com"),
      menuItem("Source code", icon = icon("github"), 
               href = "https://github.com/ciflikli/"))
  ),
  dashboardBody(fluidPage(highchartOutput("hcmap", height = 600)))
)


server <- function(input, output){
  
  output$text1 <- reactive({
    president$president[president$year == input$Year]
  })
  
  output$downloadData <- downloadHandler(
    filename = "ada4715.csv",
    content = function(file) {
      write.csv(dataset, file)
    })
  
  dataset <- data %>%
    group_by(Year, StateAbbr, Chamber, Party) %>%
    summarise(ADA = round(mean(Nominal.Score), 2),
              aADA = round(mean(Adjusted.Score), 2))
  
  mapData <- reactive({
    dataset <- dataset[dataset$Year == input$Year & dataset$Party == input$Party &
                         dataset$Chamber == ifelse(input$Chamber == "House", 1, 2), ]
  })
  
  output$hcmap <- renderHighchart({
    
    hcmap(map = "countries/us/us-all", data = mapData(),
          value = ifelse(input$ADA == "Nominal", "ADA", "aADA"), joinBy = c("hc-a2", "StateAbbr"), name = "ADA Voting Score",
          borderColor = "#DADADA", dataLabels = list(enabled = TRUE, format = '{point.name}')) %>%
      hc_title(text = "Americans for Democratic Action Voting Scores 1947-2015") %>% 
      hc_legend(layout = "vertical", align = "right",
                floating = TRUE, valueDecimals = 0, valueSuffix = "%")
  })
}

shinyApp(ui = ui, server = server)
