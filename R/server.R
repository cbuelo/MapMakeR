# Server script for MapMakeR shiny app
# Cal Buelo, 3/16/17


library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot

  

  output$tsPlot <- renderPlot({
  	datSource = reactive(input$select)
    output$value = datSource
  	if(datSource() == "cities"){
  	 dat = read.csv("./Data/LargestCities.csv", stringsAsFactors=FALSE)
	  }else if(datSource() == "cburial"){
	   dat = read.csv("./Data/CarbonBurialLocations.csv", stringsAsFactors=FALSE)
	  }else if(datSource() == "my"){
       dat = input$file
       # output$value <- renderPrint({str(input$file)}
  }
    output$value2 = reactive(dat[1,2])
    

	  # output$value = renderPrint({ dat[1,2] })
    plot(lynx)
	    # draw the plot with the specified line width
	    # hist(dat[,3])
	  # plot(input$selectedData[,3])

	  })
})