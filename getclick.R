library(shiny)
library(shinyBS)
library(ggmap)
library(leaflet)
library(rgdal)
library(markdown)


ui <- shinyUI(navbarPage("VegMapEx",
                         tabPanel("Instructions",
                                  fluidRow(
                                    column(9,includeMarkdown("/Users/glennmoncrieff/Documents/ShinyVeg/instructions.md")),
                                    column(3,imageOutput("saeon")))
                                  ),
                         tabPanel("Map",
                                  
                              sidebarPanel("",
                                           
                                  selectInput("inmethod", "Polygon input method",
                                             list("Draw", "Upload")),
                                 
                                  conditionalPanel(
                                     condition = "input.inmethod == 'Upload'",
                                        fileInput('file1', 'Choose polygon File',accept=c('.shp'))),
                                 
                                  tags$hr(),
                                 
                                  conditionalPanel(
                                     condition = "input.inmethod == 'Draw'",
                                     bsButton("togOne", label = "add markers to map", block = TRUE, type = "toggle", value = FALSE,style="info"),
                                     tags$hr(),
                                     fluidRow(
                                        column(6,actionButton("rmpoly", "clear points")),
                                        column(6,actionButton("updatep", "update polygon"))),
                                     tags$hr(),
                                     checkboxInput("tablep", "show point coordinates"),
                                     conditionalPanel(
                                        condition = "input.tablep == true",
                                        tableOutput("table"))),
                                  width=4),
                               
                             mainPanel("",
                                      leafletOutput("map", width = "100%", height = 600)
                                      )
                          ),
                        tabPanel("Results",
                                 p("oink"))
))

server <- shinyServer(function(input, output, session) {
  
  #create table fro clickpoints
  #initial click ID
  values <- reactiveValues()
  values$circs <- data.frame(latitude = numeric(0), longitude = numeric(0))
  
  #load vegmap
  #vegmap<-readOGR(dsn="/Users/glennmoncrieff/Documents/GIS/Vegmap2009",layer="vegm2009")
  vegmap<-readOGR(dsn="/Users/glennmoncrieff//Documents/ShinyVeg/GIS",layer="vegmap_small")
  

  factpal <- colorFactor(topo.colors(201), vegmap$VEGTYPEID)
  
  ## Make your initial map
  output$map <- renderLeaflet({
   mymap<- leaflet() %>%
      setView(lng = 18.4239, lat = -34, zoom = 11) %>%
      addTiles(options = providerTileOptions(noWrap = TRUE))  %>%
      hideGroup("show vegetation") %>% 
      addPolygons(data=vegmap,
                 stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5,
                 color = ~factpal(VEGTYPEID),group="show vegetation") %>%
      # addPolygons(data=polygon_,
      #            stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5,
      #            color = "blue",group="draw polygon") %>%
      addLayersControl(overlayGroups = c("show vegetation","draw polygon"),
                       options = layersControlOptions(collapsed = FALSE)) 
  
  })
  
  #get status of click check
  clickplot <- reactive({
    input$togOne
  })
  
  ## Observe mouse clicks and add circles
  observeEvent(input$map_click, {
    if(clickplot()){
    ## Get the click info like had been doing
   
    click <- input$map_click
    clat <- click$lat
    clng <- click$lng
    address <- revgeocode(c(clng,clat))
    
    values$circs[nrow(values$circs) + 1,] <- c(clat, clng)
    
    
    ## Add the circle to the map proxy
    ## so you dont need to re-render the whole thing
    ## I also give the circles a group, "circles", so you can
    ## then do something like hide all the circles with hideGroup('circles')
    leafletProxy('map') %>% # use the proxy to save computation
      addMarkers(lng=clng, lat=clat,group='circles',markerOptions(opacity=0.5))
    }else
    {  
      return()
    }
  })
  
  #action button - clear points
  observeEvent(input$rmpoly, {
    values$circs <- data.frame(latitude = numeric(0), longitude = numeric(0))
    leafletProxy('map') %>% # use the proxy to save computation
      clearShapes()
  })
  
  #action button - create polygon
  observeEvent(input$rmpoly, {
    values$circs <- data.frame(latitude = numeric(0), longitude = numeric(0))
    leafletProxy('map') %>% # use the proxy to save computation
      clearShapes()
  })
  
  # ## Observe mouse clicks and add circles
  # observeEvent(input$map_click, {
  # 
  #   
  #   ## Add the circle to the map proxy
  #   ## so you dont need to re-render the whole thing
  #   ## I also give the circles a group, "circles", so you can
  #   ## then do something like hide all the circles with hideGroup('circles')
  #   leafletProxy('map') %>% # use the proxy to save computation
  #     addCircles(lng=clng, lat=clat, group='circles',
  #                weight=1, radius=100, color='black', fillColor='orange',
  #                popup=address, fillOpacity=0.5, opacity=1)
  # })
  
  output$table <- renderTable({
    values$circs
  },include.rownames=F) 
  
  output$saeon <- renderImage({
    filename<-"/Users/glennmoncrieff/Documents/Projects/shiny_veg/nrf_saeon_logo.jpg"
    list(src = filename,
         width = 200,
         height =80
    )
  }, deleteFile = FALSE)
  
})

shinyApp(ui=ui, server=server)