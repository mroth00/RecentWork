library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("Optimizely AB Test"),

  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
            radioButtons("split","Trafic Split",c("50:50"="even","80:20"="bigSplit"),
              selected="even"),
      numericInput('Visitors', label = h3('Number of Visitors in X'), value=2500,
                 min = 0, max = 1000000),
      numericInput("sliderX", label = h3("Conversion Rate in X"),value=.1124574,
            min = 0, max = 1),
        numericInput("sliderY", label = h3("Conversion Rate in Y"),value=.1098901,
            min = 0, max = 1),
        numericInput('Tau', label = h3('Anticipated Variance'), value=.015,
                 min = 0, max = 1),
        numericInput('Alpha', label = h3('Alpha'), value=.05,
                 min = 0, max = 1)
    ),
    mainPanel(
      plotOutput("ABInfo",width=700,height=500),
      h3(textOutput("Textout"))
    )
  )
))