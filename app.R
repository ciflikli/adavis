source("global.R",local=TRUE)

ui <- dashboardPage(
  dashboardHeader(title = "ADA Voting Scores"),
  dashboardSidebar(
    sidebarMenu(
      selectInput("Party", "Select Party", choices = c("Democrat", "Republican")),
      selectInput("Chamber", "Select Chamber", choices = c("House", "Senate")),
      selectInput("ADA", "Select ADA Score", choices = c("Nominal", "Adjusted")),
      sliderInput("Year", "Select Year", 1963, min = 1947, max = 2015, animate = TRUE, sep = ""),
      menuItem(imageOutput("avatar", height = "5%")),
      menuItem(textOutput("president")),
      menuItem(textOutput("average")),
      menuItem(textOutput("average2")),
      #downloadButton("downloadData", "Download Dataset"),
      menuItem("Source code", icon = icon("github"), 
               href = "https://github.com/ciflikli/adamap"),
      menuItem("gokhanciflikli.com", icon = icon("external-link"),
               href = "https://www.gokhanciflikli.com"))),
  dashboardBody(includeCSS("styles.css"), fluidPage(highchartOutput("hcmap", height = 600))))
  
server <- function(input, output){
  
  output$avatar <- renderImage({
    if (president$name[president$year == input$Year] == "Truman")
    return(list(
      src = "data/truman.png",
      filetype = "image/png"))
    if (president$name[president$year == input$Year] == "Eisenhower")
      return(list(
        src = "data/eisenhower.png",
        filetype = "image/jpeg"))
    if (president$name[president$year == input$Year] == "Kennedy")
      return(list(
        src = "data/kennedy.png",
        filetype = "image/jpeg"))
    if (president$name[president$year == input$Year] == "Johnson")
      return(list(
        src = "data/johnson.png",
        filetype = "image/jpeg"))
    if (president$name[president$year == input$Year] == "Nixon")
      return(list(
        src = "data/nixon.png",
        filetype = "image/jpeg"))
    if (president$name[president$year == input$Year] == "Ford")
      return(list(
        src = "data/ford.png",
        filetype = "image/jpeg"))
    if (president$name[president$year == input$Year] == "Carter")
      return(list(
        src = "data/carter.png",
        filetype = "image/jpeg"))
    if (president$name[president$year == input$Year] == "Reagan")
      return(list(
        src = "data/reagan.png",
        filetype = "image/jpeg"))
    if (president$name[president$year == input$Year] == "Bush")
      return(list(
        src = "data/bush.png",
        filetype = "image/jpeg"))
    if (president$name[president$year == input$Year] == "Clinton")
      return(list(
        src = "data/clinton.png",
        filetype = "image/jpeg"))
    if (president$name[president$year == input$Year] == "Bush Jr")
      return(list(
        src = "data/bush2.png",
        filetype = "image/jpeg"))
    if (president$name[president$year == input$Year] == "Obama")
      return(list(
        src = "data/obama.png",
        filetype = "image/jpeg"))
  }, deleteFile = FALSE)
  
  output$president <- reactive({
    paste(president$name[president$year == input$Year], president$party[president$year == input$Year], sep = " ")
  })
  
  output$average <- reactive({
    n <- as.numeric(yhat[yhat$Year == input$Year & yhat$Chamber == ifelse(input$Chamber == "House", 1, 2) &
                         yhat$Party == "Democrat", ifelse(input$ADA == "Nominal", 4, 5)])
    paste("Democrat Mean:", n, sep = " ")
  })
  
  output$average2 <- reactive({
    n <- as.numeric(yhat[yhat$Year == input$Year & yhat$Chamber == ifelse(input$Chamber == "House", 1, 2) &
                           yhat$Party == "Republican", ifelse(input$ADA == "Nominal", 4, 5)])
    paste("Republican Mean:", n, sep = " ")
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
