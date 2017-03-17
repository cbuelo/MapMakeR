# UI script for MapMakeR shiny app
# Cal Buelo, 3/16/17

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("Plot lynx!"),

  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput("select", label = h3("Choose data source"), 
    choices = list("Example: Largest Cities" = "cities", "Example: Carbon Burial" = "cburial", "Use my own data" = "my"), 
    selected = 1),

      hr(),
  fluidRow(column(3, verbatimTextOutput("value")))
  
),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("tsPlot")
    )
  )
 ))
