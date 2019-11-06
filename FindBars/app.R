#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(sp)
library(rgdal)
library(ggmap)
library(leaflet)
library(dplyr)
library(shiny)
library(geosphere)
library(leaflet.extras)

data_of_crashes <- read.csv(file="CrashDataLeaflet.csv", header=TRUE, sep=",")
leaf_data <- data.frame(data_of_crashes)
data_of_bars <- read.csv(file="Bars.csv", header=TRUE, sep=",")
bars_data <- data.frame(data_of_bars)

data_of_hosp <- read.csv(file="Hosp.csv", header=TRUE, sep=",")
hosp <- data.frame(data_of_hosp)
data_of_pharmacies <- read.csv(file="pharmacies.csv", header=TRUE, sep=",")
pharmacies <- data.frame(data_of_pharmacies)

data_of_police <- read.csv(file="Police.csv", header=TRUE, sep=",")
police <- data.frame(data_of_police)

# Define UI for application that draws a histogram
shinyApp(
    ui <- shinyUI( fluidPage(    
        
        # Give the page a title
        titlePanel("Find bars"),
        
        # Generate a row with a sidebar
        sidebarLayout(      
            
            # Define the sidebar with one input
            sidebarPanel(
                selectInput("region", "Bar:", choices=unique(bars_data$Trading.name)),
                hr(),
                helpText("Look for bars and clubs you can explore. Find nearby places where you can get help for medication etc."),
                hr(),
                helpText("In case of emergency, Call 000")
            ),
            
            # Create a spot for the map
            mainPanel(
                leafletOutput("plot1",width="100%",height="600px")  
            )
            
        )
    )),
    server <- function(input,output){
        output$plot1 <- renderLeaflet({
            
            temp_bar <- bars_data %>% filter(Trading.name == input$region)
            
            hosp$distance<-distHaversine(temp_bar[,4:5], hosp[,1:2])
            pharmacies$distance<-distHaversine(temp_bar[,4:5], pharmacies[,4:5])
            police$distance <- distHaversine(temp_bar[,4:5], police[,5:6])
            
            temp_hosp <- hosp %>% filter(distance < 1000)
            temp_pharmacies <- pharmacies %>% filter(distance < 700)
            temp_police <- police %>% filter(distance < 1000)
            
            icon.first <- makeAwesomeIcon(icon = 'flag', markerColor = 'green', iconColor = 'black')
            icon.second <- makeAwesomeIcon(icon = 'flag', markerColor = 'blue',iconColor = 'black')
            icon.third <- makeAwesomeIcon(icon = 'flag', markerColor = 'yellow',iconColor = 'black')
            
            qMap <- leaflet() %>% addTiles() %>% setView(lng = 144.96332,lat = -37.814, zoom = 15) %>%
                addWebGLHeatmap(data = leaf_data,lng=~LONGITUDE, lat=~LATITUDE, size=300,opacity = 0.6) %>%
                addMarkers(data = temp_bar, lng=~x.coordinate, lat=~y.coordinate , popup = paste("Bar Name :", temp_bar$Trading.name,"<br>", 
                                                                                                 "Address :", temp_bar$Street.address,"<br>"
                )) %>%
                addAwesomeMarkers(data = temp_pharmacies , lng = ~x.coordinate ,lat = ~y.coordinate, icon = icon.first, popup = paste("Name :", temp_pharmacies$Trading.name,"<br>", 
                                                                                                                                       "Type :", temp_pharmacies$Desc,"<br>"
                )) %>%
                addAwesomeMarkers(data = temp_hosp, lng = ~X ,lat = ~Y, icon = icon.second, popup = paste("Name :", temp_hosp$LabelName,"<br>", 
                                                                                                        "Address :", temp_hosp$StreetNum, temp_hosp$RoadName," ",temp_hosp$RoadType ,"<br>"
                )) %>%
                addAwesomeMarkers(data = temp_police, lng = ~Long ,lat = ~Lat, icon = icon.third, popup = paste("Name :", temp_police$Name,"<br>", 
                                                                                                          "Address :", temp_police$Street.Address ,"<br>",
                                                                                                          "Phone No :", temp_police$Phone ,"<br>",
                                                                                                          "Open Hrs :", temp_police$Opening.Hours ,"<br>"
                ))
            
            qMap
        })
        
        
    })
    shinyApp(ui = ui, server = server)
