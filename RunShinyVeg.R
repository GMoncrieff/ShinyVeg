# load required libraries
library(shiny)
library(shinyBS)
library(leaflet)
library(rgdal)
library(markdown)
library(readr)
library(dplyr)
library(ggmap)

#do you want to run the app locally or on github?
#options are: "git" or  "local"
runme <- "git"


#run shiny app
if(runme=="local") {

    #set working dir
    Sys.getenv()
    if (Sys.getenv("USER")=='glennmoncrieff') {
      setwd("/Users/glennmoncrieff/Documents/") 
      ## path to local git folder that contains app folder
    } 
    if (Sys.getenv("USER")=='USERNAME') {
      setwd("") 
      ## path to local git folder that contains app folder
    }
    
    #run app
    runApp("ShinyVeg")

} else if (runme == "git") {
  
    runGitHub("ShinyVeg", "GMoncrieff")
  
} else {
  
    print("error: invalid run option")
  
}
