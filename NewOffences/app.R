#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/

# Import all packages 

library(ggmap)
library(leaflet)
library(dplyr)
library(shiny)
library(plotly)
library(reshape2)
library(rmapshaper)
library(raster)
library(sp)
library(leaflet.extras)
library(rgdal)


# Read all required files

offences <- read.csv(file="Offences.csv", header=TRUE, sep=",")
offences_data <- data.frame(offences)

Incidents <- read.csv(file="Incidents.csv", header=TRUE, sep=",")
Incidents_data <- data.frame(Incidents)


all_incidents_offences <- merge(offences_data, Incidents_data)

colnames(all_incidents_offences)[3] <- "vic_loca_2"
#states <- geojson_read("Suburbs.geojson", what = "sp")
#states <- rgdal::readOGR("Suburbs.geojson")

#states_simple <- rmapshaper::ms_simplify(states, keep = 0.05, keep_shapes = TRUE)

all_incidents_offences$Incidents.Recorded <- as.numeric(all_incidents_offences$Incidents.Recorded)
all_incidents_offences$Offence.Count <- as.numeric(all_incidents_offences$Offence.Count)
aggregated_offences <- all_incidents_offences %>% group_by(vic_loca_2) %>% summarise(Incidents.Recorded = sum(Incidents.Recorded))

#aggregated_offences <- aggregated_offences %>% filter(Incidents.Recorded>2000)

#offences.map <- merge(states_simple, aggregated_offences, by = "vic_loca_2")
#class(offences.map)
#View(offences.map)

# Create a palette
#offences.map$Incidents.Recorded <- as.numeric(as.character(offences.map$Incidents.Recorded))

#writeOGR(obj=offences.map, dsn= "tempdir", layer="states", driver="ESRI Shapefile")

# Define UI for application that draws a Map

ui <- fluidPage(
    
    tags$div(
        HTML("<h1>Click on the suburb you want to explore..</h1>")
    ),
    
    leafletOutput(outputId = "mymap",height = 600),
    #tableOutput(outputId = "myDf_output"),
    plotlyOutput(outputId = "incidents_plot_output",height = 600),
    br(),
    br(),
    plotlyOutput(outputId = "piechart_plot_crimes")
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    # Read SHP file
    
    offences.map <- raster::shapefile("states.shp")
    
    #offences.map <- shapefiles::read.shapefile("states")
    
    rv <- reactiveValues()
    rv$myDf <- NULL
    
    output$mymap <- renderLeaflet({
        
        
        pal <- colorBin("Reds", c(1, 17000), na.color = "#808080")
        #, alpha = FALSE, reverse = FALSE)
        
        # Define a Pop-up
        
        # Create a popup
        state_popup <- paste0("<strong>Suburb: </strong>", 
                              offences.map$vc_lc_2, 
                              "<br><strong>Number of offences in past 5 yrs: </strong>", 
                              offences.map$Incdn_R)
        
        # Create a map
        leaflet(offences.map) %>% 
            addProviderTiles(providers$Stamen.TonerLite) %>%  
            setView(lng = 144.96332, lat = -37.814, zoom = 10) %>%  
            addPolygons(layerId = ~vc_lc_2,
                        color = "#444444", weight = 1, 
                        # opacity = 0.5, 
                        fillOpacity = 0.7,
                        fillColor = ~pal(offences.map$Incdn_R),
                        popup = state_popup) %>%
            addLegend("bottomright", pal = pal, values = ~offences.map$Incdn_R, 
                      opacity = 1,
                      title = "Suburb-wise number of offences")
    })
    
    observeEvent(input$mymap_shape_click, {
        
        # Listen to the clicked Suburb
        
        #print("shape clicked")
        event <- input$mymap_shape_click
        #print(str(event))
        
        ## update the reactive value with your data of interest
        
        
        #print(event$id)
        
        # Create Bar chart and Pie chart based on the clicked suburb
        
        if (event$id %in% all_incidents_offences$vic_loca_2)
        {
            print("here")
            rv$myDf <- data.frame(all_incidents_offences %>% filter(vic_loca_2==event$id))
            
            rv$filtered_df <- rv$myDf %>% group_by_(.dots=c("Year.ending.December","Offence.Division")) %>% summarise(Offence.Count = sum(Offence.Count))   #group_by(Year.ending.December) %>% group_by(Offence.Division) %>% summarise(Offence.Count = sum(Offence.Count))
            
            rv$final_data <- dcast(rv$filtered_df, Year.ending.December ~ Offence.Division)
            
            rv$pie_data_df <- rv$myDf %>% group_by(Offence.Subdivision) %>% summarise(Offence.Count = sum(Offence.Count))
            
            if(ncol(rv$final_data)>3){
                
                colnames(rv$final_data)[2] <- "Crimes_against_a_person"
                colnames(rv$final_data)[3] <- "Drug_offences"
                colnames(rv$final_data)[4] <- "Public_order_and_security_offences"
                
                rv$incidents_plot <- plot_ly(rv$final_data, x = ~Year.ending.December, y = ~Crimes_against_a_person, type = 'bar', name = 'Crime against Person') %>%
                    add_trace(y = ~Drug_offences, name = 'Drug Offences') %>%
                    add_trace(y = ~Public_order_and_security_offences, name = 'Public security') %>%
                    layout(yaxis = list(title = 'Count'), barmode = 'group')
                
                rv$piechart_plot <- plot_ly(rv$pie_data_df, labels = ~Offence.Subdivision, values = ~Offence.Count, type = 'pie') %>%
                    layout(title = 'Detailed types of Crimes over 5 years',
                           xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                           yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
                
            }
            
            
        }
    })
    
    #output$myDf_output <- renderTable({
    #    rv$final_data
    #})
    
    # Define output
    
    output$incidents_plot_output <- renderPlotly({
        rv$incidents_plot
    })
    
    output$piechart_plot_crimes <- renderPlotly({
        rv$piechart_plot
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
