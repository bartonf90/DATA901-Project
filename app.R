library(shiny)

NIV <- read.csv("clean NIV data 118.csv", stringsAsFactors = FALSE)

ui <- fluidPage(
  titlePanel(title="Non-Immigrant Visas 1999 to 2017"),
  sidebarLayout(
    sidebarPanel("Sidebar panel...",
      sliderInput("yearInput", "Year", 1999, 2017, 1),
      radioButtons("typeInput", "Visa Type",
                   choices = c("FIANCE", "VISITOR", "STUDENT", "TEMP WORKER", "TOTAL"),
                   selected = "FIANCE"),
      checkboxGroupInput("CountryInput", label = h3("Country"), 
                         choices = unique(NIV$Country),
                         selected = "Mexico"),
    mainPanel(
      
    ),
      
    )))
    
  
  


server <- function(input, output) 

shinyApp(ui = ui, server = server)

