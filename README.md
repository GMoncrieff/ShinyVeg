#VegMapEx
####A shiny app to interface with vegetation maps

###Requirements
+ R and Rstudio (version 3+)
+ git
+ the following R packages, which can be installed by running `install.packages("packageName")` :
    - shiny
    - shinyBS
    - leaflet
    - rgdal
    - markdown
    - readr
    - dplyr

###Running the app
At the moment you have two options 

1. Clone the repository and run the app 
    - navigate to the desired location on disk and run `git clone https://github.com/GMoncrieff/ShinyVeg.git`
    - open [RunShinyVeg.R](RunShinyVeg.R) in Rstudio
    - change code block to navigate to your local copy of ShinyVeg
    ```R
        if (Sys.getenv("USER")=='USERNAME') {
      setwd("") 
    ```
     - ensure `runme` variable is set to `"local"`
     - execute [RunShinyVeg.R](RunShinyVeg.R)
     
2. Run the app on GitHub. This means you do not need to download the data
    - download the script [RunShinyVeg.R](RunShinyVeg.R). You do not need to clone the whole repo
    - ensure `runme` variable is set to `"git"`
    - execute [RunShinyVeg.R](RunShinyVeg.R)