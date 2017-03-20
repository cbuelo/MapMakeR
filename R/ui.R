# UI script for MapMakeR shiny app
# Cal Buelo, 3/16/17

library(shiny)
library(ggplot2)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

	# Application title
	titlePanel("MapMakeR"),

	# Sidebar with a slider input for the number of bins
	sidebarLayout(
    	sidebarPanel(
    		selectInput("select", label = h3("Choose data source"), 
	    		choices = list("Example: Largest Cities" = "cities", "Example: Carbon Burial" = "cburial", "Use my own data" = "my"), selected = 1
	    	),
	  		conditionalPanel(
	  		 	condition = "input.select == 'my'",
	  		 	fileInput("fileIn", label = h3("File input"))
	  		),
	  		fluidRow(
	  			column(6, uiOutput("columnLat")),
	  			column(6, uiOutput("columnLon"))
	  		),
	  		hr(),
	  		h3("Customize Plot"),
	  		fluidRow(
		  		column(6, numericInput("width", label="Map Width (px):", value=990, width="90%")),
		  		column(6, numericInput("height", label="Map Height (px):", value=600, width="90%"))
	  		),
	  		hr(),
	  		h3("Download Map"),
	  		textInput(inputId ="saveFN", label="Filename", value="myMap"),
	      	downloadButton(outputId = "downloadPlot", label = "Download the plot")
		),
    	# Show a plot of the generated distribution
	    mainPanel(
	      uiOutput("plot.ui")
	    )
	)
)
)
