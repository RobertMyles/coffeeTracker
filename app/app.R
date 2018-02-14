source("global.R")


ui <- fluidPage(theme = "styles.css",
                fluidRow(class = "myrow"),
  sidebarLayout(
    sidebarPanel(width = 3,
      h2("Coffee Price Tracker"),
      wellPanel(
        h3("What the hell is this crap?"),
        p('Calm down, old chum, let me explain. The panel you see on the right has two tabs: 
          One which shows Arabic coffee prices over time, and another which shows the price of a 
          cup of delicious coffee in various Starbucks stores around the world.'),
        h4("But..."),
        p("Don't worry, it's very simple. You can click on the tabs and see the info you want. With 
the time-series graph, you can use the slider at the bottom to limit the time frame.
          Why not grab a coffee and play around with the app?")
      )
    ),
    mainPanel(width = 9,
      tabsetPanel(type = "tabs",
                  tabPanel("Coffee Tracker",
                           dygraphOutput("coffprice")
                  ),
                  tabPanel("Starbucks Prices",
                           fluidRow(
                             column(6, 
                                    selectInput(inputId = "sb_city",
                                                label = "Select cities:",
                                                choices = starb$city,
                                                selectize = TRUE, multiple = TRUE,
                                                selected = c("New York", "London", "Paris"))
                                    ),
                             column(3,
                                    selectInput(inputId = "sb_drink",
                                                label = "Select beverage:",
                                                choices = c("Cappucino" = "cappucino",
                                                            "Americano" = "americano",
                                                            "Latte" = "latte"),
                                                selectize = TRUE, multiple = FALSE,
                                                selected = "americano")
                                    )
                           ),
                           plotOutput("sb_chart")
                           )
                  )
      )
  )
 )

server <- function(input, output){
  
  output$coffprice <- renderDygraph(
    dygraph(data = coffee, main = "Coffee USD Price Over Time") %>% 
      dyHighlight(highlightCircleSize = 5, 
                  highlightSeriesBackgroundAlpha = 0.2,
                  hideOnMouseOut = FALSE, highlightSeriesOpts = list(strokeWidth = 3)) %>%
      dyRangeSelector()
  )
  
  df_maker <- reactive({
    starb %>% filter(city %in% input$sb_city) %>% 
      select(city, country, UQ(input$sb_drink))
  })
  output$sb_chart <- renderPlot({
    req(input$sb_city)
    req(input$sb_drink)
    df <- df_maker()
    
      ggplot(df, aes(x = reorder(city, df[, 3] %>% pull()), y = df[, 3] %>% pull(), 
                     fill = country)) +
      geom_bar(stat = "identity", colour = "grey21") +
      geom_text(aes(y = df[, 3] %>% pull(), label = dollar(df[, 3] %>% pull())), 
                hjust = -.35, colour = "#230903") +
      theme_minimal() +
      scale_y_continuous(labels = dollar_format(), sec.axis = dup_axis(), limits = c(0, 6.25)) +
      scale_fill_manual(values = c("#592D23", "#8C593B", "#BF925A", "#F2E6D0", "#8B8C58",
                                   "#601700", "#E0D0C1", "#06070E", "#F0A868", "#294936", 
                                   "#FFE8C2", "#944654", "#F7F3E3", "#002500", "#6F1A07",
                                   "#EDCBB1", "#7C3238", "#CE8D66", "#D3B88C", "#3B0D11", 
                                   "#F4F2F3", "#230903")) + 
      theme(legend.position = "none", axis.title = element_blank()) +
      coord_flip()
  })
    
}

shinyApp(ui = ui, server = server)