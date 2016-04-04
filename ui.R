shinyUI(navbarPage("VegMapEx",
                   
                   #instructions page
                   tabPanel("Instructions",
                            fluidRow(
                              column(9,includeMarkdown("instructions.md")),
                              column(3,imageOutput("saeon")))
                   ),
                   
                   #map page
                   tabPanel("Map",
                            
                            #side panel with controls
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
                            #main panel with map
                            mainPanel("",
                                      leafletOutput("map", width = "100%", height = 600)
                            )
                   ),
                   
                   #results page (currently blank)
                   tabPanel("Results",
                            p("oink"))
))