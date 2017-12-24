source("global.R", local = TRUE)

ui <- dashboardPage(skin = "black",
  dashboardHeader(title = "adavis", titleWidth = "250px"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Liberal Quotient (LQ) Scores", tabName = "frontpage"),
      selectInput("Party", "Select Party", choices = c("Democrats", "Republicans")),
      selectInput("Chamber", "Select Chamber", choices = c("House", "Senate")),
      selectInput("ADA", "Select LQ Score", choices = c("Nominal", "Adjusted"), selected = "Adjusted"),
      sliderInput("Year", "Select Year", 1963, min = 1948, max = 2015,
                  animate = animationOptions(interval = 4000), sep = ""),
      selectInput("Colour", "Select Palette", selected = "Viridis",
                  choices = c("Viridis" = "D", "Plasma" = "C", "Inferno" = "B", "Magma" = "A")),
      materialSwitch("Switch", label = "Direction", value = TRUE),
      menuItem("Source code", icon = icon("code"), 
               href = "https://github.com/ciflikli/adavis"))),
  dashboardBody(includeCSS("www/custom.css"),
                fluidPage(
                tabBox(width = 12,
                  id = "frontpage",
                  tabPanel("State of the Union", withSpinner(plotOutput("statebins",
                           height = "640px"), color = "#232d33")),
                  tabPanel("Change from Previous Year", plotlyOutput("plotly", height = "640px")),
                  tabPanel("Head-to-Head",
                           fluidPage(
                           column(4,
                           selectInput("State1", label = HTML("Select State One &#9679;"),
                                       choices = state.name, selected = "California")),
                           column(4,
                           selectInput("State2", label = HTML("Select State Two &#9650;"),
                                       choices = state.name, selected = "Texas")),
                           column(4,
                           sliderInput("Range", "Select Range", min = 1948, max = 2015, sep = "",
                                       value = c(1948, 2015),
                                       ticks = FALSE, dragRange = TRUE)),
                           column(12,
                           plotOutput("ggplot", height = "560px")))),
                  tabPanel("Representatives",
                           fluidPage(
                           fluidRow(
                           column(4,
                           selectizeInput("Rep", "Search Representative", choices = NULL, selected = "Pelosi, Nancy",
                                          options = list(placeholder = "Obama, Barack",
                                                         maxOptions = 20))),
                           column(8, br(),
                           verbatimTextOutput("Info"),
                           tags$style(type = 'text/css', "#Info {font-family: 'Roboto Condensed', sans-serif;
                                      font-size: 14px; background-color: white; border-color: white;}"))),
                           fluidRow(
                           column(4,
                           dataTableOutput("History")),
                           column(8,
                           plotOutput("trend"))))),
                  tabPanel("About",
                           fluidPage(
                             column(7,
                                    h3("adavis"),
                                    h5("Visualising Americans for Democratic Action (ADA) Voting Scores"),
                                    p("This app visually explores nearly 70 years of U.S. voting records from 1948 to 2015.
The original data have been collected by the", a("ADA", href = "http://www.adaction.org/pages/publications.php", target = "_blank"), "foundation.",
"Adjusted scores are taken from a blog post by ", a("Justin Briggs,",
href = "http://trialstravails.blogspot.co.uk/2017/01/adjusted-ada-scores-from-1947-2015.htmlg/", target = "_blank"),
"following the adjustment procedures based on ", a("Tim Groseclose's",href = "http://timgroseclose.com/adjusted-interest-group-scores/", target = "_blank"), "work."),
                                    p("Built by ", a("Gokhan Ciflikli", icon("external-link"), href = "https://gokhanciflikli.com", target = "_blank"), "in R using ", code("shinydashboard"), "and packages such as ", code("statebins, plotly, ggExtra, viridis"), "and ", code("hrbrthemes."), "Some of the artistic impressions for the figures are heavily influenced by Lukasz Piwek's brilliant post on ", a("Tufte.", href = "http://motioninsocial.com/tufte/", target = "_blank")),
                                    p("This is an open-source project and the underlying code is available on ",
a("GitHub.", href = "https://github.com/ciflikli/adavis", target = "_blank"),
"Consult the readme file for further information."), p("Contact me on ", a("Twitter", icon("twitter"), href = "https://twitter.com/gokhan_ciflikli", target = "_blank"))
)))
                ),
useShinyjs(), tags$head({tags$style(HTML("
.material-switch > input[type='checkbox']:checked + label::before {
opacity: 1;
border: 1px solid #68ce5a;
}
.material-switch > label::before {
width: 36px;
}
.material-switch > label::after {
height: 16px;
width: 16px;
top: 0px;
}
.selectize-input.focus {
border-color: #23a784;
}
code {
color: #3d4989;
background-color: transparent;
padding: 0px 0px;
font-size: 80%;
}
a:hover {
color: #3d4989;
}
.irs-slider {
top: 19px;
width: 6px;
height: 20px;
background: white;
border: 1px solid #6389a6c2;
}
.irs-grid-pol {
opacity: 0.7;
background: #35b679;
}
.js-irs-1 .irs-single,
.js-irs-1 .irs-bar-edge,
.js-irs-1 .irs-bar, .irs-from, .irs-to
{
color: #000;
background: none;
border-top: none;
border-bottom: none;}
.irs-single, .irs-bar, .irs-bar-edge, .irs-min, .irs-max
{
background: none;
border-top: none;
border-bottom: none;
}
.skin-black .sidebar-menu>li>a {
border-left: none;
}
.skin-black .sidebar-menu>li.active>a, .skin-black .sidebar-menu>li:hover>a {
background: none;
border-left: none;
}
.skin-black .main-header .navbar>.sidebar-toggle {
border-right: none;
}
.skin-black .main-header>.logo {
border-right: none;
}
.nav-tabs-custom> .nav-tabs>li.active {
border-top-color: transparent;
}
label {
font-weight: 400;
}
.main-header .logo {
font-family: 'Roboto Condensed', sans-serif;
font-weight: normal;
font-size: 24px;
}
.main-sidebar, .left-side {
width: 250px;
}
@media (min-width: 768px) {
.content-wrapper,
.right-side,
.main-footer {
background-color: #232d33;
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
}"
))}))))
  
server <- function(input, output, session){
  
  mapData <- reactive({
    dataset <- dataset[dataset$Year == input$Year & dataset$Party == input$Party &
                         dataset$Chamber == ifelse(input$Chamber == "House", 1, 2), ]
  })
  
  plotData <- reactive({
    trend <- trend[trend$Year == input$Year & trend$Party == input$Party &
                   trend$Chamber == ifelse(input$Chamber == "House", 1, 2),
                   c("State", "Year", "Party", "Chamber", "Number",
                     ifelse(input$ADA == "Nominal", "ADA", "aADA"),
                     ifelse(input$ADA == "Nominal", "Diff", "Diff.Adj"),
                     ifelse(input$ADA == "Nominal", "Thresh.Ada", "Thresh.AAda"))]
    
    names(trend)[6:8] <- c("Score", "Change", "Label")
    trend <- as.data.frame(trend)
    
  })
  
  marginalData <- reactive({
    
    trend <- trend[trend$Party == input$Party & trend$Chamber == ifelse(input$Chamber == "House", 1, 2),
                   c("State", "Year", "Party", "Chamber", "Number",
                     ifelse(input$ADA == "Nominal", "ADA", "aADA"),
                     ifelse(input$ADA == "Nominal", "Diff", "Diff.Adj"),
                     ifelse(input$ADA == "Nominal", "Thresh.Ada", "Thresh.AAda"))]
    
    names(trend)[6:8] <- c("Score", "Change", "Label")
    trend <- as.data.frame(trend)
    
    trend <- trend[trend$Year >= input$Range[1] & trend$Year <= input$Range[2] &
                   trend$State %in% c(input$State1, input$State2), ]
    
  })
  
  lookupData <- reactive({
    
    data$Party <- substr(data$Party, 1, nchar(data$Party) - 1)
    names(data)[c(10, 12)] <- c("Nominal Score", "Adjusted Score")
    data <- data[data$`Full Name` == input$Rep,
                 c("Year", "Congress", "State", "District",
                   "Party", ifelse(input$ADA == "Nominal", "Nominal Score", "Adjusted Score"))]
    names(data)[6] <- "Score"
    data <- as.data.frame(data)
    
  })
  
  updateSelectizeInput(
    session, "Rep", server = TRUE, choices = data$`Full Name`
  )
  
  output$History <- DT::renderDataTable({
    
    m <- DT::datatable(lookupData()[, -c(5, 3)], options = list(dom = "tp"))
    m %>% DT::formatRound("Score", 0)
    
  })
  
  observeEvent(eventExpr = input$Rep, ({
  
  output$Info <- renderText({
    
    post <- glimpse(lookupData()[, c(1, 5, 3, 4)])
    first <- glimpse(lookupData()[1, c(1, 5, 3, 4)])
    paste("Served as a", first$Party, "from", first$State,
          "between", min(post$Year), "and", max(post$Year))
    
  })
  
  output$trend <- renderPlot({
    
    v1 <- mean(lookupData()$Score)
    v2 <- sd(lookupData()$Score)
    v3 <- min(lookupData()$Year)
    v4 <- max(lookupData()$Year)
    v5 <- summary(lookupData()$Year)
    
    plot(lookupData()$Score ~ lookupData()$Year, xlab = "", ylab = "", axes = FALSE, family = "Roboto Condensed",
         pch = 16, type = "b", lwd = 2)#, col = viridis(n = 12, alpha = .7, option = input$Colour))
    abline(h = v1 + v2, lty = 2, col = alpha("black", .2))
    abline(h = v1, lty = 2)
    abline(h = v1 - v2, lty = 2, col = alpha("black", .2))
    axis(1, at = c(v3, v4, (v3 + v4) / 2),
         labels = c(v3, v4, round((v3 + v4) / 2, 0)),
         tick = FALSE, family = "Roboto Condensed")
    axis(2, at = c(v1, v1 + v2, v1 - v2), labels = round(c(v1, v1 + v2, v1 - v2), 0),
         las = 2, family = "Roboto Condensed", tick = FALSE, lty = 0)
    axis(4, at = c(v1, v1 + v2, v1 - v2), lwd = 0, las = 2,
         labels = c(expression(mu), expression(sigma), expression(sigma)),
         col = alpha("black", .2), family = "Roboto Condensed", ps = 20)
    
    })
  
  }), ignoreInit = TRUE, ignoreNULL = TRUE
  )
  
  output$statebins <- renderPlot({
    
    us <- statebins(mapData(), state_col = "State", value_col = ifelse(input$ADA == "Nominal", "ADA", "aADA"),
                    round = TRUE, font_size = 7, state_border_col = "#232d33",
                    state_border_size = .8, radius = grid::unit(10, "pt")) +
          labs(title = "") +
          theme(axis.text.x = element_blank(), axis.text.y = element_blank(), axis.ticks = element_blank(),
                panel.grid.minor = element_blank(), panel.grid.major = element_blank(),
                panel.background = element_rect(fill = "white", linetype = "blank"),
                legend.position = c(.075, .85), legend.direction = "horizontal",
                legend.text = element_text(colour = "#232d33", size = 14),
                legend.title = element_text(colour = "#232d33", size = 18),
                legend.key.height = grid::unit(.01, "snpc"),
                legend.key.width = grid::unit(.05, "snpc"),
                plot.margin = margin(-1, 0, 0, 0, "cm"))
    us + scale_fill_viridis(option = input$Colour, direction = ifelse(input$Switch == FALSE, -1, 1),
         breaks = c(seq(-25, 100, 25)),
         labels = c("No Rep", paste(seq(0, 100, 25), "%  ")),
         guide = guide_legend(title = "", title.position = "top",
                              keywidth = 2, keyheight = 2, ncol = 1))
  })
  
  output$plotly <- renderPlotly({
    
    ax <- list(
      showline = FALSE,
      showticklabels = TRUE,
      showgrid = FALSE)
    
      plot_ly(plotData(), x = ~Score, key = plotData()[, 1],
              y = ~Change, mode = "markers", type = "scatter", hoverinfo = "text",
              hoverlabel = list(font = list(family = "Roboto Condensed",
                                        size = 14)),
              text = ~paste(input$Chamber, input$Party, "from",
              State, "voted\n", paste0(abs(round(Change, 2)), "% more"), Label, "in", input$Year),
              color = ~Change, colors = viridis(direction = ifelse(input$Switch == FALSE, -1, 1), n = 12, option = input$Colour),
              marker = list(size = 30, opacity = .7)) %>%
      layout(dragmode = "select", showlegend = FALSE,
             xaxis = c(ax, list(title = "Selected Year Voting Score", zeroline = FALSE)),
             yaxis = c(ax, list(title = "Change from Last Year", zeroline = TRUE, zerolinecolor = toRGB("black", .05))),
             font = list(family = "Roboto Condensed")) %>%
      config(displayModeBar = FALSE)
  })
  
  output$ggplot <- renderPlot({
    
    p <- ggplot(marginalData(), aes(Year, Score, color = Score)) +
         geom_point(aes(shape = State), size = 3, alpha = .7) +
         scale_color_viridis(option = input$Colour, direction = ifelse(input$Switch == FALSE, -1, 1)) +
         theme(legend.position = "none", axis.title.x = element_text(size = 20),
               axis.title.y = element_text(size = 20), axis.text = element_text(size = 18))
    
    ggMarginal(p, type = "histogram", margins = "y",
               yparams = list(bins = 50, fill = viridis(n = 49, alpha = .8,
                                                        direction = ifelse(input$Switch == FALSE, -1, 1),
                                                        option = input$Colour)))
    
  })
  
}

shinyApp(ui = ui, server = server)