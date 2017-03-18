# MapMakeR v0.1
An easy-to-use (no coding required), R-based web app for making maps in your browser. Upload your map data (e.g. latitude, longitude, point scaling and/or grouping data), customize your map, and download it in the size and format of your choice. Based on the shiny and ggplot2 R packages. Under continual development, contact Cal Buelo (GitHub: cbuelo; email: cbuelo10@gmail.com) with questions or to contribute.

## Instructions
Will eventually be made into an R package for download via GitHub and CRAN. For now:
1. Install dependencies = R packages "shiny" and "ggplot2"
	* install.packages("shiny")
	* install.packages("ggplot2")
2. Download "MapMakeR" application from GitHub
	* https://github.com/cbuelo/MapMakeR
3. Set working directory to "R" folder within "MapMakeR"
	* ex: setwd("path/to/MapeMakeR/R"), or with RStudio or other IDE menu
4. Run these lines in R:
	* library(shiny)
	* runApp()
5. In the browser window that pops up, make your map (upload data, format, download)