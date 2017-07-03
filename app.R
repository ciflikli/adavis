source("global.R",local=TRUE)

ui <- dashboardPage(
  dashboardHeader(title = "ADA Voting Scores", titleWidth = "250px"),
  dashboardSidebar(
    sidebarMenu(
      selectInput("Party", "Select Party", choices = c("Democrat", "Republican")),
      selectInput("Chamber", "Select Chamber", choices = c("House", "Senate")),
      selectInput("ADA", "Select ADA Score", choices = c("Nominal", "Adjusted")),
      sliderInput("Year", "Select Year", 1963, min = 1947, max = 2015, animate = animationOptions(interval = 5000), sep = ""),
      menuItem(imageOutput("avatar", height = "5%")),
      menuItem(textOutput("president")),
      menuItem(textOutput("average")),
      menuItem(textOutput("average2")),
      menuItem("Source code", icon = icon("github"), 
               href = "https://github.com/ciflikli/adamap"),
      menuItem("gokhanciflikli.com", icon = icon("external-link"),
               href = "https://www.gokhanciflikli.com"))),
  dashboardBody(includeCSS("www/custom.css"),
    fluidPage(fluidRow(column(12, withSpinner(highchartOutput("hcmap", height = 600)))),
              fluidRow(column(12, plotOutput("chart", height = 150)))),
              useShinyjs(), tags$head({tags$style(HTML("
                                           ELEMENT.classList.remove('a');
                                           .skin-blue .main-header .navbar {
                                           background-color: #db4c3f;
                                           }
                                           .skin-blue .main-header .navbar .sidebar-toggle:hover {
                                           background-color: #db4c3f;
                                           }
                                           .skin-blue .main-header .navbar .sidebar-toggle:hover {
                                           color: #FFFFFF;
                                           background: rgba(0,0,0,0);
                                           }
                                           .main-sidebar, .left-side {
                                           width: 250px;
                                           }
                                           @media (min-width: 768px) {
                                           .content-wrapper,
                                           .right-side,
                                           .main-footer {
                                           margin-left: 250px;
                                           }
                                           }
                                           @media (max-width: 767px) {
                                           .sidebar-open .content-wrapper,
                                           .sidebar-open .right-side,
                                           .sidebar-open .main-footer {
                                           -webkit-transform: translate(250px, 0);
                                           -ms-transform: translate(250px, 0);
                                           -o-transform: translate(250px, 0);
                                           transform: translate(250px, 0);
                                           }
                                           }
                                           @media (max-width: 767px) {
                                           .main-sidebar,
                                           .left-side {
                                           -webkit-transform: translate(-250px, 0);
                                           -ms-transform: translate(-250px, 0);
                                           -o-transform: translate(-250px, 0);
                                           transform: translate(-250px, 0);
                                           }
                                           }
                                           @media (min-width: 768px) {
                                           .sidebar-collapse .main-sidebar,
                                           .sidebar-collapse .left-side {
                                           -webkit-transform: translate(-250px, 0);
                                           -ms-transform: translate(-250px, 0);
                                           -o-transform: translate(-250px, 0);
                                           transform: translate(-250px, 0);
                                           }
                                           }"))}))
  )
  
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
  
  mapData <- reactive({
    dataset <- dataset[dataset$Year == input$Year & dataset$Party == input$Party &
                         dataset$Chamber == ifelse(input$Chamber == "House", 1, 2), ]
  })
  
  output$chart <- renderPlot({
    
    p <- ggbarplot(trend[trend$Year == input$Year & trend$Chamber == ifelse(input$Chamber == "House", 1, 2) &
                   trend$Party == input$Party, ], size = .1,
                   x = "StateAbbr", y = ifelse(input$ADA == "Nominal", "Diff", "Diff2"),
                   fill = ifelse(input$ADA == "Nominal", "Threshold", "Threshold2"),
                   color = "white", width = 1,
                   palette = c("#18469e", "#ea5148"),
                   sort.val = "asc",
                   sort.by.groups = FALSE,
                   x.text.angle = 90,
                   ylab = "Change from Last Year",
                   xlab = FALSE,
                   legend.title = "Trend Direction")
   p +
   bgcolor("#ecf0f5") +
   geom_abline(slope = 0, color = "gray") +
   theme(legend.background = element_rect("#ecf0f5"), panel.background = element_rect("#ecf0f5"),
         plot.background = element_rect(fill = "#ecf0f5", colour = "#ecf0f5"),
         plot.margin = unit(x = c(0, 0, 0, 0), units = "mm"),
         text = element_text(size = 10, family = "Source Sans Pro"))
  })
  
  output$hcmap <- renderHighchart({
    
    hc <- highchart(type = "map") %>%
          hc_add_series_map(map = usData, df = mapData(), value = ifelse(input$ADA == "Nominal", "ADA", "aADA"),
                            joinBy = c("hc-a2", "StateAbbr"), name = "ADA Voting Score", nullColor = "#DADADA",
                            borderColor = "white", dataLabels = list(enabled = TRUE, format = '{point.name}')) %>%
          hc_title(text = "Americans for Democratic Action Voting Scores 1947-2015") %>%
          hc_legend(layout = "vertical", align = "right", floating = TRUE, valueDecimals = 0)
    
    hc_colorAxis(hc, stops = stops)
  })
}

shinyApp(ui = ui, server = server)
