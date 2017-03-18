# Server script for MapMakeR shiny app
# Cal Buelo, 3/16/17

library(shiny)

shinyServer(function(input, output) {
  # get the data source you want
  getDataFrame <- reactive({
    datSource = reactive(input$select)
    if(datSource() == "cities"){
     dat = read.csv("./Data/LargestCities.csv", stringsAsFactors=FALSE)
    }else if(datSource() == "cburial"){
     dat = read.csv("./Data/CarbonBurialLocations.csv", stringsAsFactors=FALSE)
    }else if(datSource() == "my"){
      inFile = reactive(input$fileIn)
      dat = read.csv(inFile()$datapath, stringsAsFactors=FALSE)
    }
    return(dat)
  })
  # make UI element to select latitude column from data source above
  output$columnLat = renderUI({
    datPlot = getDataFrame()
    colNames = colnames(datPlot)
    names(colNames) = colNames
    selectInput("lat", label = h3("Choose latitude column"), 
          choices = colNames, selected=4)
  })
  # make UI element to select latitude column from data source above
  output$columnLon = renderUI({
    datPlot = getDataFrame()
    colNames = colnames(datPlot)
    names(colNames) = colNames
    selectInput("lon", label = h3("Choose longitude column"), 
         choices = colNames, selected=5)
  })
  # create a vector of the column names that have lat and lon
  getLatLon <- reactive({
    LatLon_vector = c(input$lat, input$lon)
    return(LatLon_vector)
  })
  # get just the data you want from above
  getPlotCols = reactive({
    df = getDataFrame()
    cols = getLatLon()
    return(df[,cols])
  })
  #output the data you want to UI
  output$tsPlot <- renderPrint({
  	datPlot = getPlotCols()
    colsPlot = str(datPlot)
    colsPlot 
	})
})