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
    selectInput("lat", label = h4("Latitude column"), 
          choices = colNames, selected="latitude", width="90%")
  })
  # make UI element to select latitude column from data source above
  output$columnLon = renderUI({
    datPlot = getDataFrame()
    colNames = colnames(datPlot)
    names(colNames) = colNames
    selectInput("lon", label = h4("Longitude column"), 
         choices = colNames, selected="longitude", width="90%")
  })
  output$pointSize = renderUI({
    datPlot = getDataFrame()
    colNames = c("None",colnames(datPlot))
    names(colNames) = colNames
    selectInput("size", label = h4("Point size column"), 
          choices = colNames, selected="population", width="90%")
  })
  # make UI element to select latitude column from data source above
  output$pointColor = renderUI({
    datPlot = getDataFrame()
    colNames = c("None", colnames(datPlot))
    names(colNames) = colNames
    selectInput("color", label = h4("Point color column"), 
         choices = colNames, selected="country", width="90%")
  })
  # create a vector of the column names that have lat and lon
  getLatLon <- reactive({
    LatLon_vector = c(input$lon, input$lat)
    return(LatLon_vector)
  })

  # create a vector of the column names that have lat and lon
  getPointSizeColor <- reactive({
    Point_vector = c()
    if(input$size != "None"){
      Point_vector = c(Point_vector, input$size)
    }
    if(input$color != "None"){
      Point_vector = c(Point_vector, input$color)
    }
    return(Point_vector)
  })

  # get just the data you want from above
  getPlotCols = reactive({
    df = getDataFrame()
    LatLonCols = getLatLon()
    PointCols = getPointSizeColor()
    outCols = c(LatLonCols, PointCols)
    return(df[,outCols])
  })

  #make the plot
  plotInput = reactive({
    datPlot = getPlotCols()
      if(all(is.numeric(datPlot[,input$lat]))& all(is.numeric(datPlot[,input$lon]))){
        mp_range = NULL
        mapWorld = borders(database="world",colour="gray70", fill="gray") # create a layer of borders
        mp_range = ggplot() +  mapWorld
        if(input$size != "None" & input$color != "None"){
          mp_range = mp_range + geom_point(aes(x=datPlot[,input$lon], y=datPlot[,input$lat], size=datPlot[,input$size], fill=datPlot[,input$color]), pch=21)
          mp_range = mp_range + labs(size = input$size) + labs(fill = input$color)

          if(class(datPlot[,input$color]) == "character"){
            mp_range = mp_range + guides(size = guide_legend(), fill = guide_legend(override.aes = list(size=4)))
          }
          if(class(datPlot[,input$color]) == "numeric"){
            mp_range = mp_range + guides(size = guide_legend(), fill = guide_colourbar())
          }
        }else if(input$size != "None" & input$color == "None"){
          mp_range = mp_range + geom_point(aes(x=datPlot[,input$lon], y=datPlot[,input$lat], size=datPlot[,input$size]), pch=21)
          mp_range = mp_range + labs(size = input$size)
        }else if(input$size == "None" & input$color != "None"){
          mp_range = mp_range + geom_point(aes(x=datPlot[,input$lon], y=datPlot[,input$lat], fill=datPlot[,input$color]), pch=21)
          mp_range = mp_range + labs(fill = input$color)
         }else{
          mp_range = mp_range + geom_point(aes(x=datPlot[,input$lon], y=datPlot[,input$lat]), pch=21)
         }
        return(mp_range)
      }
  })

  #make the plot
  output$plot <- renderPlot({
   plotInput()
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