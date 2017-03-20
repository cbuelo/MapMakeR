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
    selectInput("lat", label = h3("Latitude column"), 
          choices = colNames, selected="latitude", width="90%")
  })
  # make UI element to select latitude column from data source above
  output$columnLon = renderUI({
    datPlot = getDataFrame()
    colNames = colnames(datPlot)
    names(colNames) = colNames
    selectInput("lon", label = h3("Longitude column"), 
         choices = colNames, selected="longitude", width="90%")
  })
  # create a vector of the column names that have lat and lon
  getLatLon <- reactive({
    LatLon_vector = c(input$lon, input$lat)
    return(LatLon_vector)
  })
  # get just the data you want from above
  getPlotCols = reactive({
    df = getDataFrame()
    cols = getLatLon()
    return(df[,cols])
  })

  #make the plot
  plotInput = reactive({
    datPlot = getPlotCols()
      if(all(is.numeric(datPlot[,1]))& all(is.numeric(datPlot[,2]))){
        mp_range = NULL
        mapWorld = borders(database="world",colour="gray70", fill="gray") # create a layer of borders
        mp_range = ggplot() +  mapWorld 
        mp_range = mp_range + geom_point(aes(x=datPlot[,1], y=datPlot[,2]))
        return(mp_range)
      }
  })

  #make the plot
  output$plot <- renderPlot({
  	# datPlot = getPlotCols()
   #  if(all(is.numeric(datPlot[,1]))& all(is.numeric(datPlot[,2]))){
   #    mp_range = NULL
   #    mapWorld = borders(database="world",colour="gray70", fill="gray") # create a layer of borders
   #    mp_range = ggplot() +  mapWorld 
   #    mp_range = mp_range + geom_point(aes(x=datPlot[,1], y=datPlot[,2]))
   #    mp_range
   #  }
   plotInput()
    # colsPlot = str(datPlot)
    # colsPlot 
	})

  #make the plot UI element
  output$plot.ui = renderUI({
    plotOutput("plot", width = input$width, height=input$height)
    })

  output$downloadPlot <- downloadHandler(
    filename = function() { paste(input$saveFN, '.png', sep='') },
    content = function(file) {
      png(file, width = input$width, height=input$height)
      print(plotInput())
      dev.off()
    })
})